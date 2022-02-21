{% macro get_relationships(node_type) %}

    {% if execute %}

        {% if node_type == 'nodes' %}
            {% set nodes_list = graph.nodes.values() %}   
        {% elif node_type == 'exposures' %}
            {% set nodes_list = graph.exposures.values() %}
        {% else %}
            {{ exceptions.raise_compiler_error("node_type needs to be either nodes or exposures, got " ~ node_type) }}
        {% endif %}
        
        {% set values = [] %}

        {%- for node in nodes_list -%}

            {%- if node.depends_on.nodes|length == 0 -%}

                {% set values_line %}
                  ('{{ node.name }}','{{ node.unique_id }}','{{ node.resource_type }}',NULL)
                {% endset %}
                {% do values.append(values_line) %}

            {%- else -%}       

                {%- for parent in node.depends_on.nodes -%}

                    {% set values_line %}
                    ('{{ node.name }}','{{ node.unique_id }}','{{ node.resource_type }}','{{ parent }}')
                    {% endset %}
                    {% do values.append(values_line) %}

                {% endfor -%}

            {%- endif %}

        {% endfor -%}
    
    {{ return(
        select_from_values(
            values = values,
            column_names = [
                'node',
                'node_id',
                'resource_type',
                'direct_parent_id'
            ]
         )
    ) }}

    {% endif %}
  
{% endmacro %}
-- TO DO: maybe switch grain to one row per "issue" similar to fct_rejoining_of_upstream_concepts

-- this model finds cases where a model references more than one source
with direct_source_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where distance = 1
    and parent_resource_type = 'source'
),

multiple_sources_joined as (
    select
        child,
        {{ listagg('parent', ', ') }} as source_parents
    from direct_source_relationships
    group by 1
    having count(*) > 1
)

select * from multiple_sources_joined
{% macro delivery_status(delivered_at, estimated_delivery_at)%}

    case when date({{ delivered_at }}) = date({{ estimated_delivery_at }}) then 'Delivered on time'
            when date({{ delivered_at }}) > date({{ estimated_delivery_at }}) then 'Delivered late'
            when date({{ delivered_at }}) < date({{ estimated_delivery_at }}) then 'Delivered early'
        end 

{% endmacro %}


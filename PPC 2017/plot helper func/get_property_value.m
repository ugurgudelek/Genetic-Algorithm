function properties = get_property_value(obj_map,chromosomes, property_name)
    iter_size = size(chromosomes,1);
    for i=1:iter_size
        chrom = chromosomes(i,:);
        properties(i,:) = getfield(obj_map(num2str(chrom)),property_name);
    end
end
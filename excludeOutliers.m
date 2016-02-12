function [matched_points_org_excluded, matched_points_new_excluded] = excludeOutliers(matched_points_org, matched_points_new,fundMatrix)
matched_points_org_excluded = cell(size(matched_points_org));
matched_points_new_excluded = cell(size(matched_points_org));
for N = 1:size(matched_points_org,2)
    FM = fundMatrix{N};
    x = matched_points_org{N};
    x1 = matched_points_new{N};
    x = x';
    x1 = x1';
%     exclude_org = zeros(NaN,3);
%     exclude_new = zeros(NaN,3);
    i = 1;
    for j = 1:size(x,1)
        line=FM*x1(j,:)';
        distance_org = abs(line(1)*x(j,1)+line(2)*x(j,2)+line(3))/(line(1)^2+line(2)^2)^0.5;
        line=FM'*x(j,:)';
        distance_new = abs(line(1)*x1(j,1)+line(2)*x1(j,2)+line(3))/(line(1)^2+line(2)^2)^0.5;
        if distance_org<2 && distance_new<2
            exclude_org(i,:) = x(j,:);
            exclude_new(i,:) = x1(j,:);
            i = i+1;
        end
    end
    matched_points_org_excluded{N} = exclude_org';
    matched_points_new_excluded{N} = exclude_new';
end
end
function C = getPixelColor(matched_points_org_excluded, images_org)


C = zeros(size(matched_points_org_excluded, 2),3);

for i = 1:size(matched_points_org_excluded, 2)
% 	display(uint16(matched_points_org_excluded(1,i)))
% 	display(uint16(matched_points_org_excluded(2,i)))
	C(i,:) = images_org(uint16(matched_points_org_excluded(2,i)),uint16(matched_points_org_excluded(1,i)),:);
end

end
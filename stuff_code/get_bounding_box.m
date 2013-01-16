function [bbox] = get_bounding_box(category, img)
bboxfile = fopen(strcat('data/',category,'_bboxes'));

bbox = [];
line = fgetl(bboxfile);
while ischar(line)
    l = textscan(char(line),'%s',3);
    if strcmp(char(l{1}{1}), img)
        out = textscan(l{1}{2},'%d','delimiter', ',' ,'multipleDelimsAsOne',1);
        bbox = [out{1}(1) out{1}(2)];
        out = textscan(l{1}{3},'%d','delimiter', ',' ,'multipleDelimsAsOne',1);
        bbox = [bbox out{1}(1) out{1}(2)];
        break;
    end 
    line = fgetl(bboxfile);
end

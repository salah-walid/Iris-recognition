function [polar_array] = extractIris(fileName, width, height)
img = imread(fileName);
[circleiris, circlepupil, imagewithnoise] = segmentiris(img);

[polar_array, ~] = normaliseiris(imagewithnoise, circleiris(2),...
    circleiris(1), circleiris(3), circlepupil(2), circlepupil(1), circlepupil(3),fileName, width, height);
end
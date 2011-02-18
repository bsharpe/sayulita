-- READ: http://developer.anscamobile.com/content/configuring-projects
-- and http://blog.anscamobile.com/2010/11/content-scaling-made-easy/
-- for more information about this

application =
{
	content =
	{
		width  = 320,
		height = 480,
		scale = "letterbox",
		fps = 60,
		imageSuffix =
    {
        ["@2x"] = 2,
        ["@3x"] = 3,
    },
    antialias = false, -- default
    
	},
}
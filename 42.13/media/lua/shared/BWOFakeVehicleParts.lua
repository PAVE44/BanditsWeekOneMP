BWOFakeVehicleParts = BWOFakeVehicleParts or {}

BWOFakeVehicleParts.CarLightsTemplate = function() 
    return  {
        body = {
            itemType = "Base.CarLightsPolice",
            width = 1.8,
            wheelbase = 3,
            frontOverhang = 0.5,
            rearOverhang = 0.5,
            zoffset = 0.36,
        },
        wheel_rl = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = 0.60,
            yoffset = -0.20,
            yrot = 90,
        },
        wheel_rr = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = -0.60,
            yoffset = -0.20,
            yrot = 90,
            zrot = 180
        },
        wheel_fl = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = 0.60,
            yoffset = 2.50,
            yrot = 90,
            steerRot = true,
        },
        wheel_fr = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = -0.60,
            yoffset = 2.50,
            yrot = 90,
            zrot = 180,
            steerRot = true,
        }
    }
end

BWOFakeVehicleParts.ModernCarLightsTemplate = function()
    return  {
        body = {
            itemType = "Base.ModernCarLightsWestpoint",
            width = 1.8,
            wheelbase = 3,
            frontOverhang = 0.35,
            rearOverhang = 0.5,
            zoffset = 0.35,
        },
        wheel_rl = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = 0.60,
            yoffset = -0.20,
            yrot = 90,
        },
        wheel_rr = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = -0.60,
            yoffset = -0.20,
            yrot = 90,
            zrot = 180
        },
        wheel_fl = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = 0.60,
            yoffset = 2.20,
            yrot = 90,
            steerRot = true,
        },
        wheel_fr = {
            itemType = "Base.NormalTire1",
            zoffset = 0.13,
            xoffset = -0.60,
            yoffset = 2.20,
            yrot = 90,
            zrot = 180,
            steerRot = true,
        }
    }
end

BWOFakeVehicleParts.InstanceParts = function(templateFunc, bodyItemType)
    local parts = templateFunc()
    parts.body.itemType = bodyItemType
    return parts
end



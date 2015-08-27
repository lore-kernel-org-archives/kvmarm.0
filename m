From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
 a platform device
Date: Thu, 27 Aug 2015 19:16:00 +0200
Message-ID: <55DF45D0.5040704@linaro.org>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>	
 <55DF07F0.3070405@linaro.org> <1440691887.20355.27.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E65DC489A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 13:16:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K85D02er0d-s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Aug 2015 13:16:44 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA0F24879B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 13:16:44 -0400 (EDT)
Received: by wicgk12 with SMTP id gk12so15793156wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2015 10:16:48 -0700 (PDT)
In-Reply-To: <1440691887.20355.27.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 08/27/2015 06:11 PM, Alex Williamson wrote:
> On Thu, 2015-08-27 at 14:52 +0200, Eric Auger wrote:
>> Hi Baptiste, Antonios,
>>
>> What are the plans wrt this series? I am currently integrating another
>> QEMU VFIO platform devices where this series could be useful I think
>> (Feb 2015). Do you intend to follow up and bring it upstream?
>>
>> Alex, do you see some show-stoppers in this series or do you advise to
>> simply follow-up?
> 
> I'm at a bit of a disadvantage not really knowing what types of
> properties a user will be able to retrieve here.  The interface itself
> seems sort of like a game of Go Fish.  Should the properties we're
> looking for be generally available via sysfs?  The ioctl proposed needs
> some work to fit within the argsz/flags model that vfio typically uses.
> It's unclear what argsz vs length represents and defining the flags
> field as 'type' limits the future extensions of the ioctl.  Thanks,

The properties that I need can be found in /proc/device-tree too. They
are of different types, with void cell value, with string cell
values(single & multiple), with integer cell value(s), array ...

The aim is to be able to assign a highly configurable platform device to
a guest, read some property values on host and write the same values in
guest dt node.

Do you advise to read the fs directly instead of using such API?

Thanks

Eric

> 
> Alex
> 
>> On 12/19/2014 10:20 PM, Antonios Motakis wrote:
>>> This RFC's intention is to show what an interface to access device
>>> properties for the VFIO platform driver can look like. These properties
>>> can be from the device tree node describing the device, or ACPI properties
>>> in the future.
>>>
>>> If a device property corresponding to a platform device bound by VFIO PLATFORM
>>> or VFIO AMBA is available, this patch series will allow the user to query
>>> for this information. This can be useful for userspace drivers to automatically
>>> query parameters related to the device.
>>>
>>> Specifically for QEMU, reading the "compatible" property of the device tree
>>> node could be of use to find out what device is being assigned to the guest and
>>> handle appropriately a wider range of devices in the future, and to generate an
>>> appropriate device tree for the guest.
>>>
>>> Older versions of this series where specifically targeted at device tree
>>> properties. This version has been reworked on top of Rafael J. Wysocki's
>>> uniform device properties API for device tree and ACPI devices. This will allow
>>> us to use the API in the future with devices described via ACPI.
>>>
>>> This also means a kernel including the uniform device properties API is needed
>>> to apply these patches, in additon to the VFIO patches, e.g. branch pm+acpi-3.19-rc1
>>> from https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/
>>>
>>> The API to get the list of available properties and the device tree full_name
>>> have been removed. These probably don't serve an useful purpose, as the user
>>> of this API need to know anyway what properties are specific to the device he
>>> wants to access with VFIO. If we decide to reintroduce the list of properties
>>> in the future, the generic device properties API in the kernel will have to
>>> be extended accordingly.
>>>
>>> A kernel with this series and all the dependencies applied can be pulled from
>>> branch vfio-device-properties-v3 from the repository:
>>> https://github.com/virtualopensystems/linux-kvm-arm.git
>>>
>>> Changes since v2:
>>>  - Reworked on top of Rafael J. Wysocki's uniform device properties API for
>>>    device tree and ACPI
>>>  - Support for u64 array properties
>>>  - Removed API to get list of available properties and device tree full_name
>>> Changes since v1:
>>>  - Updated for VFIO platform patch series v8:
>>>    VFIO AMBA devices now supported in addition to VFIO PLATFORM devices
>>>  - Refactored and cleaned up the code
>>>
>>> Antonios Motakis (3):
>>>   vfio: platform: add device properties skeleton and user API
>>>   vfio: platform: access device property as a list of strings
>>>   vfio: platform: return device properties as arrays of unsigned
>>>     integers
>>>
>>>  drivers/vfio/platform/Makefile                |   3 +-
>>>  drivers/vfio/platform/properties.c            | 162 ++++++++++++++++++++++++++
>>>  drivers/vfio/platform/vfio_platform_common.c  |  35 ++++++
>>>  drivers/vfio/platform/vfio_platform_private.h |   7 ++
>>>  include/uapi/linux/vfio.h                     |  26 +++++
>>>  5 files changed, 232 insertions(+), 1 deletion(-)
>>>  create mode 100644 drivers/vfio/platform/properties.c
>>>
>>
> 
> 
> 

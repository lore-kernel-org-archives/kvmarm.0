From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v3 0/3] vfio: platform: return device properties for
	a platform device
Date: Thu, 27 Aug 2015 15:49:34 +0200
Message-ID: <55DF156E.1060803@linaro.org>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
	<55DF07F0.3070405@linaro.org> <55DF124F.8020801@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <55DF124F.8020801-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Antonios Motakis <antonios.motakis-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Antonios,

Thank you for your quick answer. Waiting for Baptiste feedback then.

Best Regards

Eric

On 08/27/2015 03:36 PM, Antonios Motakis wrote:
> Hello Eric,
> 
> Myself I am not involved with anything VFIO related at the moment, so (alas) I don't have any plans to revisit this series.
> 
> If someone decides to pick it up, of course I can offer my feedback and support.
> 
> Cheers,
> Antonios
> 
> On 27-Aug-15 14:52, Eric Auger wrote:
>> Hi Baptiste, Antonios,
>>
>> What are the plans wrt this series? I am currently integrating another
>> QEMU VFIO platform devices where this series could be useful I think
>> (Feb 2015). Do you intend to follow up and bring it upstream?
>>
>> Alex, do you see some show-stoppers in this series or do you advise to
>> simply follow-up?
>>
>> Thank you in advance
>>
>> Best Regards
>>
>> Eric
>>
>>
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

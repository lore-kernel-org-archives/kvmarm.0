From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 0/3] vfio: platform: return device properties for
	a platform device
Date: Wed, 09 Sep 2015 14:49:05 -0600
Message-ID: <1441831745.20355.543.camel@redhat.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1441790231-22920-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> This RFC's intention is to show what an interface to access device
> properties for the VFIO platform driver can look like. These properties
> can be retrieved from the device tree node describing the device, or ACPI 
> properties.
> 
> If a device property corresponding to a platform device bound to VFIO PLATFORM
> or VFIO AMBA is available, this patch series will allow the user to query
> for this information. This can be useful for userspace drivers to automatically
> query parameters related to the device.
> 
> Specifically for QEMU, reading the "compatible" property of the device tree
> node could be of use to find out what device is being assigned to the guest and
> handle appropriately a wider range of devices in the future, and to generate an
> appropriate device tree for the guest.
> 
> Older versions of this series were specifically targeted at device tree
> properties. The v3 has been reworked on top of Rafael J. Wysocki's
> uniform device properties API for device tree and ACPI devices. This will allow
> us to use the API in the future with devices described via ACPI.
> 
> The API to get the list of available properties and the device tree full_name
> have been removed. These probably don't serve an useful purpose, as the user
> of this API need to know anyway what properties are specific to the device he
> wants to access with VFIO. If we decide to reintroduce the list of properties
> in the future, the generic device properties API in the kernel will have to
> be extended accordingly.
> 
> A kernel with this series and all the dependencies applied can be pulled from
> branch vfio-device-properties-v4 from the repository:
> https://git.virtualopensystems.com/dev/linux.git


Did we ever get past whether this is a necessary interface and why it's
vfio's job to provide it?  Support for sysfs is a requirement for QEMU
to determine the correct IOMMU group number for a device, and it doesn't
seem unreasonable for sysfs to provide retrieval of device property
information for all users, not just vfio.  So I haven't fully bought
into this interface yet, but I reviewed it nonetheless.  Thanks,

Alex

> Changes since v3:
>  - Rebased on top on v4.2
>  - Rework VFIO_DEVICE_GET_DEV_PROPERTY ioctl
>  - Rework code according to Eric Auger's comments
> Changes since v2:
>  - Reworked on top of Rafael J. Wysocki's uniform device properties API for
>    device tree and ACPI
>  - Support for u64 array properties
>  - Removed API to get list of available properties and device tree full_name
> Changes since v1:
>  - Updated for VFIO platform patch series v8:
>    VFIO AMBA devices now supported in addition to VFIO PLATFORM devices
>  - Refactored and cleaned up the code
> 
> Antonios Motakis (3):
>   vfio: platform: add device properties skeleton and user API
>   vfio: platform: access device property as a list of strings
>   vfio: platform: return device properties as arrays of unsigned
>     integers
> 
>  drivers/vfio/platform/Makefile                |   3 +-
>  drivers/vfio/platform/properties.c            | 178 ++++++++++++++++++++++++++
>  drivers/vfio/platform/vfio_platform_common.c  |  35 +++++
>  drivers/vfio/platform/vfio_platform_private.h |   7 +
>  include/uapi/linux/vfio.h                     |  31 +++++
>  5 files changed, 253 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vfio/platform/properties.c
> 

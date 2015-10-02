From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for
	a platform device
Date: Fri, 02 Oct 2015 13:28:19 -0600
Message-ID: <1443814099.26107.124.camel@redhat.com>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1443604077-3155-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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

On Wed, 2015-09-30 at 11:07 +0200, Baptiste Reynal wrote:
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

If we wanted to describe device properties via vfio, perhaps this is a
reasonable approach.  However, why would we want to do that?  How are
these device properties unique to vfio?  Are there other users that
might want to learn these properties?  How will they get them?  Perhaps
they would decide to expose them via sysfs for everyone, making this
interface redundant.  Why not start with exposing device properties to
userspace in a way that's not specific to vfio?  Thanks,

Alex

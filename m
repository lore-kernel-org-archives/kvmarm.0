From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [RFC PATCH v4 0/3] vfio: platform: return device properties for a
 platform device
Date: Wed,  9 Sep 2015 11:17:08 +0200
Message-ID: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4837A412AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 05:19:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XgSJuRyp48YE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 05:19:17 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FE0840FAB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 05:19:16 -0400 (EDT)
Received: by wicge5 with SMTP id ge5so146853882wic.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 02:19:55 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org
Cc: alex.williamson@redhat.com, tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

This RFC's intention is to show what an interface to access device
properties for the VFIO platform driver can look like. These properties
can be retrieved from the device tree node describing the device, or ACPI 
properties.

If a device property corresponding to a platform device bound to VFIO PLATFORM
or VFIO AMBA is available, this patch series will allow the user to query
for this information. This can be useful for userspace drivers to automatically
query parameters related to the device.

Specifically for QEMU, reading the "compatible" property of the device tree
node could be of use to find out what device is being assigned to the guest and
handle appropriately a wider range of devices in the future, and to generate an
appropriate device tree for the guest.

Older versions of this series were specifically targeted at device tree
properties. The v3 has been reworked on top of Rafael J. Wysocki's
uniform device properties API for device tree and ACPI devices. This will allow
us to use the API in the future with devices described via ACPI.

The API to get the list of available properties and the device tree full_name
have been removed. These probably don't serve an useful purpose, as the user
of this API need to know anyway what properties are specific to the device he
wants to access with VFIO. If we decide to reintroduce the list of properties
in the future, the generic device properties API in the kernel will have to
be extended accordingly.

A kernel with this series and all the dependencies applied can be pulled from
branch vfio-device-properties-v4 from the repository:
https://git.virtualopensystems.com/dev/linux.git

Changes since v3:
 - Rebased on top on v4.2
 - Rework VFIO_DEVICE_GET_DEV_PROPERTY ioctl
 - Rework code according to Eric Auger's comments
Changes since v2:
 - Reworked on top of Rafael J. Wysocki's uniform device properties API for
   device tree and ACPI
 - Support for u64 array properties
 - Removed API to get list of available properties and device tree full_name
Changes since v1:
 - Updated for VFIO platform patch series v8:
   VFIO AMBA devices now supported in addition to VFIO PLATFORM devices
 - Refactored and cleaned up the code

Antonios Motakis (3):
  vfio: platform: add device properties skeleton and user API
  vfio: platform: access device property as a list of strings
  vfio: platform: return device properties as arrays of unsigned
    integers

 drivers/vfio/platform/Makefile                |   3 +-
 drivers/vfio/platform/properties.c            | 178 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_common.c  |  35 +++++
 drivers/vfio/platform/vfio_platform_private.h |   7 +
 include/uapi/linux/vfio.h                     |  31 +++++
 5 files changed, 253 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/platform/properties.c

-- 
2.5.1

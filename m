From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [PATCH v13 00/18] VFIO support for platform devices
Date: Thu, 26 Feb 2015 18:02:16 +0100
Message-ID: <CAN9JPjHo3AP_O=9EE83Fa7ZR+6Q2J2xYjc=ksNwLrF2WChZ4qg@mail.gmail.com>
References: <1422625584-3741-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9219737505624086802=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D25F46AD5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 11:56:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpGUb0Qw+ESX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 11:56:30 -0500 (EST)
Received: from mail-qc0-f178.google.com (mail-qc0-f178.google.com
 [209.85.216.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A37E46AAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 11:56:29 -0500 (EST)
Received: by qcxm20 with SMTP id m20so9492845qcx.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 09:02:17 -0800 (PST)
In-Reply-To: <1422625584-3741-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm-arm <kvmarm@lists.cs.columbia.edu>, Linux IOMMU <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

--===============9219737505624086802==
Content-Type: multipart/alternative; boundary=001a11c081fed4a67a051000b67d

--001a11c081fed4a67a051000b67d
Content-Type: text/plain; charset=UTF-8

Hi everyone,

Are there any comments on this patch series? If not, Is there anything
keeping this series from getting merged upstream?

Thanks,
Baptiste

On Fri, Jan 30, 2015 at 2:46 PM, Baptiste Reynal <
b.reynal@virtualopensystems.com> wrote:

> This patch series aims to implement VFIO support for platform devices that
> reside behind an IOMMU. Examples of such devices are devices behind an ARM
> SMMU, or behind a Samsung Exynos System MMU.
>
> The API used is based on the existing VFIO API that is also used with PCI
> devices. Only devices that include a basic set of IRQs and memory regions
> are
> targeted; devices with complex relationships with other devices on a device
> tree are not taken into account at this stage.
>
> This patch series may be applied on the following series/patches:
>  - [PATCH v3 0/6] vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1
>
> A copy can be cloned from the branch vfio-platform-v13 at:
> git@github.com:virtualopensystems/linux-kvm-arm.git
>
> Changes since v12:
>  - Reorder chunks to be bisect-able
> Changes since v11:
>  - Drop support for ARM AMBA devices
>  - vfio_platform_private.h is now self-contained
>  - Fix masked IRQ initialization
> Changes since v10:
>  - Check if interrupt is already masked when setting a new trigger
>  - Fixed kasprintf with unchecked return value in VFIO AMBA driver
> Changes since v9:
>  - Reworked the splitting of the patches that decouple virqfd from PCI
>  - Some styling issues and typos
>  - Removed superfluous includes
>  - AMBA devices are now named vfio-amba- suffixed by the AMBA device id
>  - Several other cleanups and fixes
> Changes since v8:
>  - Separate irq handler for edge and level triggered interrupts
>  - Mutex based lock for VFIO fd open/release
>  - Fixed bug where the first region of a platform device wasn't exposed
>  - Read only regions can be MMAPed only read only
>  - Code cleanups
> Changes since v7:
>  - Some initial placeholder functionality for PIO resources
>  - Cleaned up code for IRQ triggering, masking and unmasking
>  - Some functionality has been removed from this series and posted
> separately:
>    - VFIO_IOMMU_TYPE1 support for ARM SMMUs
>    - IOMMU NOEXEC patches
>    - driver_override functionality for AMBA devices
>  - Several fixes
> Changes since v6:
>  - Integrated support for AMBA devices
>  - Numerous cleanups and fixes
> Changes since v5:
>  - Full eventfd support for IRQ masking and unmasking.
>  - Changed IOMMU_EXEC to IOMMU_NOEXEC, along with related flags in VFIO.
>  - Other fixes based on reviewer comments.
> Changes since v4:
>  - Use static offsets for each region in the VFIO device fd
>  - Include patch in the series for the ARM SMMU to expose IOMMU_EXEC
>    availability via IOMMU_CAP_DMA_EXEC
>  - Rebased on VFIO multi domain support:
>    - IOMMU_EXEC is now available if at least one IOMMU in the container
>      supports it
>    - Expose IOMMU_EXEC if available via the capability VFIO_IOMMU_PROT_EXEC
>  - Some bug fixes
> Changes since v3:
>  - Use Kim Phillips' driver_probe_device()
> Changes since v2:
>  - Fixed Read/Write and MMAP on device regions
>  - Removed dependency on Device Tree
>  - Interrupts support
>  - Interrupt masking/unmasking
>  - Automask level sensitive interrupts
>  - Introduced VFIO_DMA_MAP_FLAG_EXEC
>  - Code clean ups
>
> Antonios Motakis (18):
>   vfio/platform: initial skeleton of VFIO support for platform devices
>   vfio: platform: probe to devices on the platform bus
>   vfio: platform: add the VFIO PLATFORM module to Kconfig
>   vfio/platform: return info for bound device
>   vfio/platform: return info for device memory mapped IO regions
>   vfio/platform: read and write support for the device fd
>   vfio/platform: support MMAP of MMIO regions
>   vfio/platform: return IRQ info
>   vfio/platform: initial interrupts support code
>   vfio/platform: trigger an interrupt via eventfd
>   vfio/platform: support for level sensitive interrupts
>   vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and
>     export
>   vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit
>   vfio: add local lock for virqfd instead of depending on VFIO PCI
>   vfio: pass an opaque pointer on virqfd initialization
>   vfio: move eventfd support code for VFIO_PCI to a separate file
>   vfio: initialize the virqfd workqueue in VFIO generic code
>   vfio/platform: implement IRQ masking/unmasking via an eventfd
>
>  drivers/vfio/Kconfig                          |   1 +
>  drivers/vfio/Makefile                         |   5 +-
>  drivers/vfio/pci/vfio_pci.c                   |   8 -
>  drivers/vfio/pci/vfio_pci_intrs.c             | 238 +-----------
>  drivers/vfio/pci/vfio_pci_private.h           |   3 -
>  drivers/vfio/platform/Kconfig                 |   9 +
>  drivers/vfio/platform/Makefile                |   4 +
>  drivers/vfio/platform/vfio_platform.c         | 103 +++++
>  drivers/vfio/platform/vfio_platform_common.c  | 521
> ++++++++++++++++++++++++++
>  drivers/vfio/platform/vfio_platform_irq.c     | 336 +++++++++++++++++
>  drivers/vfio/platform/vfio_platform_private.h |  85 +++++
>  drivers/vfio/vfio.c                           |   8 +
>  drivers/vfio/virqfd.c                         | 213 +++++++++++
>  include/linux/vfio.h                          |  27 ++
>  include/uapi/linux/vfio.h                     |   1 +
>  15 files changed, 1326 insertions(+), 236 deletions(-)
>  create mode 100644 drivers/vfio/platform/Kconfig
>  create mode 100644 drivers/vfio/platform/Makefile
>  create mode 100644 drivers/vfio/platform/vfio_platform.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_common.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_private.h
>  create mode 100644 drivers/vfio/virqfd.c
>
> --
> 2.2.2
>
>

--001a11c081fed4a67a051000b67d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi everyone, <br><br>Are there any comments on t=
his patch series? If not, Is there anything keeping this series from gettin=
g merged upstream?<br><br></div>Thanks,<br></div>Baptiste<br></div><div cla=
ss=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Jan 30, 2015 at 2=
:46 PM, Baptiste Reynal <span dir=3D"ltr">&lt;<a href=3D"mailto:b.reynal@vi=
rtualopensystems.com" target=3D"_blank">b.reynal@virtualopensystems.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">This patch series aims=
 to implement VFIO support for platform devices that<br>
reside behind an IOMMU. Examples of such devices are devices behind an ARM<=
br>
SMMU, or behind a Samsung Exynos System MMU.<br>
<br>
The API used is based on the existing VFIO API that is also used with PCI<b=
r>
devices. Only devices that include a basic set of IRQs and memory regions a=
re<br>
targeted; devices with complex relationships with other devices on a device=
<br>
tree are not taken into account at this stage.<br>
<br>
This patch series may be applied on the following series/patches:<br>
=C2=A0- [PATCH v3 0/6] vfio: type1: support for ARM SMMUS with VFIO_IOMMU_T=
YPE1<br>
<br>
A copy can be cloned from the branch vfio-platform-v13 at:<br>
git@github.com:virtualopensystems/linux-kvm-arm.git<br>
<br>
Changes since v12:<br>
=C2=A0- Reorder chunks to be bisect-able<br>
Changes since v11:<br>
=C2=A0- Drop support for ARM AMBA devices<br>
=C2=A0- vfio_platform_private.h is now self-contained<br>
=C2=A0- Fix masked IRQ initialization<br>
Changes since v10:<br>
=C2=A0- Check if interrupt is already masked when setting a new trigger<br>
=C2=A0- Fixed kasprintf with unchecked return value in VFIO AMBA driver<br>
Changes since v9:<br>
=C2=A0- Reworked the splitting of the patches that decouple virqfd from PCI=
<br>
=C2=A0- Some styling issues and typos<br>
=C2=A0- Removed superfluous includes<br>
=C2=A0- AMBA devices are now named vfio-amba- suffixed by the AMBA device i=
d<br>
=C2=A0- Several other cleanups and fixes<br>
Changes since v8:<br>
=C2=A0- Separate irq handler for edge and level triggered interrupts<br>
=C2=A0- Mutex based lock for VFIO fd open/release<br>
=C2=A0- Fixed bug where the first region of a platform device wasn&#39;t ex=
posed<br>
=C2=A0- Read only regions can be MMAPed only read only<br>
=C2=A0- Code cleanups<br>
Changes since v7:<br>
=C2=A0- Some initial placeholder functionality for PIO resources<br>
=C2=A0- Cleaned up code for IRQ triggering, masking and unmasking<br>
=C2=A0- Some functionality has been removed from this series and posted sep=
arately:<br>
=C2=A0 =C2=A0- VFIO_IOMMU_TYPE1 support for ARM SMMUs<br>
=C2=A0 =C2=A0- IOMMU NOEXEC patches<br>
=C2=A0 =C2=A0- driver_override functionality for AMBA devices<br>
=C2=A0- Several fixes<br>
Changes since v6:<br>
=C2=A0- Integrated support for AMBA devices<br>
=C2=A0- Numerous cleanups and fixes<br>
Changes since v5:<br>
=C2=A0- Full eventfd support for IRQ masking and unmasking.<br>
=C2=A0- Changed IOMMU_EXEC to IOMMU_NOEXEC, along with related flags in VFI=
O.<br>
=C2=A0- Other fixes based on reviewer comments.<br>
Changes since v4:<br>
=C2=A0- Use static offsets for each region in the VFIO device fd<br>
=C2=A0- Include patch in the series for the ARM SMMU to expose IOMMU_EXEC<b=
r>
=C2=A0 =C2=A0availability via IOMMU_CAP_DMA_EXEC<br>
=C2=A0- Rebased on VFIO multi domain support:<br>
=C2=A0 =C2=A0- IOMMU_EXEC is now available if at least one IOMMU in the con=
tainer<br>
=C2=A0 =C2=A0 =C2=A0supports it<br>
=C2=A0 =C2=A0- Expose IOMMU_EXEC if available via the capability VFIO_IOMMU=
_PROT_EXEC<br>
=C2=A0- Some bug fixes<br>
Changes since v3:<br>
=C2=A0- Use Kim Phillips&#39; driver_probe_device()<br>
Changes since v2:<br>
=C2=A0- Fixed Read/Write and MMAP on device regions<br>
=C2=A0- Removed dependency on Device Tree<br>
=C2=A0- Interrupts support<br>
=C2=A0- Interrupt masking/unmasking<br>
=C2=A0- Automask level sensitive interrupts<br>
=C2=A0- Introduced VFIO_DMA_MAP_FLAG_EXEC<br>
=C2=A0- Code clean ups<br>
<br>
Antonios Motakis (18):<br>
=C2=A0 vfio/platform: initial skeleton of VFIO support for platform devices=
<br>
=C2=A0 vfio: platform: probe to devices on the platform bus<br>
=C2=A0 vfio: platform: add the VFIO PLATFORM module to Kconfig<br>
=C2=A0 vfio/platform: return info for bound device<br>
=C2=A0 vfio/platform: return info for device memory mapped IO regions<br>
=C2=A0 vfio/platform: read and write support for the device fd<br>
=C2=A0 vfio/platform: support MMAP of MMIO regions<br>
=C2=A0 vfio/platform: return IRQ info<br>
=C2=A0 vfio/platform: initial interrupts support code<br>
=C2=A0 vfio/platform: trigger an interrupt via eventfd<br>
=C2=A0 vfio/platform: support for level sensitive interrupts<br>
=C2=A0 vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and<br>
=C2=A0 =C2=A0 export<br>
=C2=A0 vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit<b=
r>
=C2=A0 vfio: add local lock for virqfd instead of depending on VFIO PCI<br>
=C2=A0 vfio: pass an opaque pointer on virqfd initialization<br>
=C2=A0 vfio: move eventfd support code for VFIO_PCI to a separate file<br>
=C2=A0 vfio: initialize the virqfd workqueue in VFIO generic code<br>
=C2=A0 vfio/platform: implement IRQ masking/unmasking via an eventfd<br>
<br>
=C2=A0drivers/vfio/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0drivers/vfio/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A0drivers/vfio/pci/vfio_pci.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 -<br>
=C2=A0drivers/vfio/pci/vfio_pci_intrs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 238 +-----------<br>
=C2=A0drivers/vfio/pci/vfio_pci_private.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0|=C2=A0 =C2=A03 -<br>
=C2=A0drivers/vfio/platform/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A09 +<br>
=C2=A0drivers/vfio/platform/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0drivers/vfio/platform/vfio_platform.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 103 +++++<br>
=C2=A0drivers/vfio/platform/vfio_platform_common.c=C2=A0 | 521 ++++++++++++=
++++++++++++++<br>
=C2=A0drivers/vfio/platform/vfio_platform_irq.c=C2=A0 =C2=A0 =C2=A0| 336 ++=
+++++++++++++++<br>
=C2=A0drivers/vfio/platform/vfio_platform_private.h |=C2=A0 85 +++++<br>
=C2=A0drivers/vfio/vfio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +<br>
=C2=A0drivers/vfio/virqfd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 213 +++++++++++<br>
=C2=A0include/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 27 ++<br>
=C2=A0include/uapi/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A01 +<br>
=C2=A015 files changed, 1326 insertions(+), 236 deletions(-)<br>
=C2=A0create mode 100644 drivers/vfio/platform/Kconfig<br>
=C2=A0create mode 100644 drivers/vfio/platform/Makefile<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_common.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_irq.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_private.h<br>
=C2=A0create mode 100644 drivers/vfio/virqfd.c<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.2.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c081fed4a67a051000b67d--

--===============9219737505624086802==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9219737505624086802==--

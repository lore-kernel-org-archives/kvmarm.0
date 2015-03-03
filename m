From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH v14 00/20] VFIO support for platform devices
Date: Tue, 3 Mar 2015 11:06:56 +0100
Message-ID: <CAN9JPjH0MQ-f2Vp-Cpd4GZfBtvVjWZKh_WDKrZz40AK14_Awrw@mail.gmail.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6539506644056254108=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425315600-29761-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
Cc: VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============6539506644056254108==
Content-Type: multipart/alternative; boundary=001a1147a780b0802b05105f7edd

--001a1147a780b0802b05105f7edd
Content-Type: text/plain; charset=UTF-8

Added Eric Auger for comments.

On Mon, Mar 2, 2015 at 5:59 PM, Baptiste Reynal <
b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org> wrote:

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
>  - [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
>  - [PATCH v4 0/6] vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1
>
> A copy can be cloned from the branch vfio-platform-v14 at:
> https://github.com/virtualopensystems/linux-kvm-arm.git
>
> This serie has been tested on a DMA PL330 with ARM FastModels.
>
> Changes since v13:
>  - Rebased on linux v4.0-rc1
>  - Re-added support for ARM AMBA devices
>  - Baptiste Reynal is the new maintainer of this serie
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
> Antonios Motakis (20):
>   vfio/platform: initial skeleton of VFIO support for platform devices
>   vfio: platform: probe to devices on the platform bus
>   vfio: platform: add the VFIO PLATFORM module to Kconfig
>   vfio: amba: VFIO support for AMBA devices
>   vfio: amba: add the VFIO for AMBA devices module to Kconfig
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
>  drivers/vfio/platform/Kconfig                 |  19 +
>  drivers/vfio/platform/Makefile                |   8 +
>  drivers/vfio/platform/vfio_amba.c             | 115 ++++++
>  drivers/vfio/platform/vfio_platform.c         | 103 +++++
>  drivers/vfio/platform/vfio_platform_common.c  | 521
> ++++++++++++++++++++++++++
>  drivers/vfio/platform/vfio_platform_irq.c     | 336 +++++++++++++++++
>  drivers/vfio/platform/vfio_platform_private.h |  85 +++++
>  drivers/vfio/vfio.c                           |   8 +
>  drivers/vfio/virqfd.c                         | 213 +++++++++++
>  include/linux/vfio.h                          |  27 ++
>  include/uapi/linux/vfio.h                     |   2 +
>  16 files changed, 1456 insertions(+), 236 deletions(-)
>  create mode 100644 drivers/vfio/platform/Kconfig
>  create mode 100644 drivers/vfio/platform/Makefile
>  create mode 100644 drivers/vfio/platform/vfio_amba.c
>  create mode 100644 drivers/vfio/platform/vfio_platform.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_common.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
>  create mode 100644 drivers/vfio/platform/vfio_platform_private.h
>  create mode 100644 drivers/vfio/virqfd.c
>
> --
> 2.3.1
>
>

--001a1147a780b0802b05105f7edd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Added Eric Auger for comments.<br></div><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote">On Mon, Mar 2, 2015 at 5:59 PM, Bap=
tiste Reynal <span dir=3D"ltr">&lt;<a href=3D"mailto:b.reynal@virtualopensy=
stems.com" target=3D"_blank">b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org</a>&gt;</span>=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex">This patch series aims to impleme=
nt VFIO support for platform devices that<br>
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
=C2=A0- [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition<b=
r>
=C2=A0- [PATCH v4 0/6] vfio: type1: support for ARM SMMUS with VFIO_IOMMU_T=
YPE1<br>
<br>
A copy can be cloned from the branch vfio-platform-v14 at:<br>
<a href=3D"https://github.com/virtualopensystems/linux-kvm-arm.git" target=
=3D"_blank">https://github.com/virtualopensystems/linux-kvm-arm.git</a><br>
<br>
This serie has been tested on a DMA PL330 with ARM FastModels.<br>
<br>
Changes since v13:<br>
=C2=A0- Rebased on linux v4.0-rc1<br>
=C2=A0- Re-added support for ARM AMBA devices<br>
=C2=A0- Baptiste Reynal is the new maintainer of this serie<br>
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
Antonios Motakis (20):<br>
=C2=A0 vfio/platform: initial skeleton of VFIO support for platform devices=
<br>
=C2=A0 vfio: platform: probe to devices on the platform bus<br>
=C2=A0 vfio: platform: add the VFIO PLATFORM module to Kconfig<br>
=C2=A0 vfio: amba: VFIO support for AMBA devices<br>
=C2=A0 vfio: amba: add the VFIO for AMBA devices module to Kconfig<br>
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
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 19 +<br>
=C2=A0drivers/vfio/platform/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A08 +<br>
=C2=A0drivers/vfio/platform/vfio_amba.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 115 ++++++<br>
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
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A016 files changed, 1456 insertions(+), 236 deletions(-)<br>
=C2=A0create mode 100644 drivers/vfio/platform/Kconfig<br>
=C2=A0create mode 100644 drivers/vfio/platform/Makefile<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_amba.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_common.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_irq.c<br>
=C2=A0create mode 100644 drivers/vfio/platform/vfio_platform_private.h<br>
=C2=A0create mode 100644 drivers/vfio/virqfd.c<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1147a780b0802b05105f7edd--

--===============6539506644056254108==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6539506644056254108==--

From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v14 00/20] VFIO support for platform devices
Date: Tue, 10 Mar 2015 18:42:07 +0100
Message-ID: <54FF2CEF.1050705@linaro.org>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
	<CAN9JPjH0MQ-f2Vp-Cpd4GZfBtvVjWZKh_WDKrZz40AK14_Awrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAN9JPjH0MQ-f2Vp-Cpd4GZfBtvVjWZKh_WDKrZz40AK14_Awrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Baptiste,

Please add:
Reviewed-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> on the whole series
Tested-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> on the whole series except
AMBA specific patches.

I currently exercise the following functionalities on Calxeda Midway HW:
- MMIO read/write/mmap,
- automasked IRQ + mask/unmask (NONE flag),
- virqfd (unmask handler only).

Despite a new thorough review I failed in pointing out any new
interesting issues in this series.

just minor points below:

- PIO regions: currently read/write/mmap is not supported. I can't
figure out how much this is a problem at this point?
- nit: vfio_pci_intrs.c: may not need wait.h anymore after removal of
virqfd code. may be added in vfio.h
- nit: interrupt.h not needed at early stage in vfio_platform_private.h,
until irq introduction
- version of the driver: 0.10?

Since there is no real dependency on "[PATCH v4 0/6] vfio: type1:
support for ARM SMMUS with VFIO_IOMMU_TYPE1" I hope we can get this
upstreamed soon.

Best Regards

Eric


On 03/03/2015 11:06 AM, Baptiste Reynal wrote:
> Added Eric Auger for comments.
> 
> On Mon, Mar 2, 2015 at 5:59 PM, Baptiste Reynal
> <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org
> <mailto:b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>> wrote:
> 
>     This patch series aims to implement VFIO support for platform
>     devices that
>     reside behind an IOMMU. Examples of such devices are devices behind
>     an ARM
>     SMMU, or behind a Samsung Exynos System MMU.
> 
>     The API used is based on the existing VFIO API that is also used
>     with PCI
>     devices. Only devices that include a basic set of IRQs and memory
>     regions are
>     targeted; devices with complex relationships with other devices on a
>     device
>     tree are not taken into account at this stage.
> 
>     This patch series may be applied on the following series/patches:
>      - [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
>      - [PATCH v4 0/6] vfio: type1: support for ARM SMMUS with
>     VFIO_IOMMU_TYPE1
> 
>     A copy can be cloned from the branch vfio-platform-v14 at:
>     https://github.com/virtualopensystems/linux-kvm-arm.git
> 
>     This serie has been tested on a DMA PL330 with ARM FastModels.
> 
>     Changes since v13:
>      - Rebased on linux v4.0-rc1
>      - Re-added support for ARM AMBA devices
>      - Baptiste Reynal is the new maintainer of this serie
>     Changes since v12:
>      - Reorder chunks to be bisect-able
>     Changes since v11:
>      - Drop support for ARM AMBA devices
>      - vfio_platform_private.h is now self-contained
>      - Fix masked IRQ initialization
>     Changes since v10:
>      - Check if interrupt is already masked when setting a new trigger
>      - Fixed kasprintf with unchecked return value in VFIO AMBA driver
>     Changes since v9:
>      - Reworked the splitting of the patches that decouple virqfd from PCI
>      - Some styling issues and typos
>      - Removed superfluous includes
>      - AMBA devices are now named vfio-amba- suffixed by the AMBA device id
>      - Several other cleanups and fixes
>     Changes since v8:
>      - Separate irq handler for edge and level triggered interrupts
>      - Mutex based lock for VFIO fd open/release
>      - Fixed bug where the first region of a platform device wasn't exposed
>      - Read only regions can be MMAPed only read only
>      - Code cleanups
>     Changes since v7:
>      - Some initial placeholder functionality for PIO resources
>      - Cleaned up code for IRQ triggering, masking and unmasking
>      - Some functionality has been removed from this series and posted
>     separately:
>        - VFIO_IOMMU_TYPE1 support for ARM SMMUs
>        - IOMMU NOEXEC patches
>        - driver_override functionality for AMBA devices
>      - Several fixes
>     Changes since v6:
>      - Integrated support for AMBA devices
>      - Numerous cleanups and fixes
>     Changes since v5:
>      - Full eventfd support for IRQ masking and unmasking.
>      - Changed IOMMU_EXEC to IOMMU_NOEXEC, along with related flags in VFIO.
>      - Other fixes based on reviewer comments.
>     Changes since v4:
>      - Use static offsets for each region in the VFIO device fd
>      - Include patch in the series for the ARM SMMU to expose IOMMU_EXEC
>        availability via IOMMU_CAP_DMA_EXEC
>      - Rebased on VFIO multi domain support:
>        - IOMMU_EXEC is now available if at least one IOMMU in the container
>          supports it
>        - Expose IOMMU_EXEC if available via the capability
>     VFIO_IOMMU_PROT_EXEC
>      - Some bug fixes
>     Changes since v3:
>      - Use Kim Phillips' driver_probe_device()
>     Changes since v2:
>      - Fixed Read/Write and MMAP on device regions
>      - Removed dependency on Device Tree
>      - Interrupts support
>      - Interrupt masking/unmasking
>      - Automask level sensitive interrupts
>      - Introduced VFIO_DMA_MAP_FLAG_EXEC
>      - Code clean ups
> 
>     Antonios Motakis (20):
>       vfio/platform: initial skeleton of VFIO support for platform devices
>       vfio: platform: probe to devices on the platform bus
>       vfio: platform: add the VFIO PLATFORM module to Kconfig
>       vfio: amba: VFIO support for AMBA devices
>       vfio: amba: add the VFIO for AMBA devices module to Kconfig
>       vfio/platform: return info for bound device
>       vfio/platform: return info for device memory mapped IO regions
>       vfio/platform: read and write support for the device fd
>       vfio/platform: support MMAP of MMIO regions
>       vfio/platform: return IRQ info
>       vfio/platform: initial interrupts support code
>       vfio/platform: trigger an interrupt via eventfd
>       vfio/platform: support for level sensitive interrupts
>       vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and
>         export
>       vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit
>       vfio: add local lock for virqfd instead of depending on VFIO PCI
>       vfio: pass an opaque pointer on virqfd initialization
>       vfio: move eventfd support code for VFIO_PCI to a separate file
>       vfio: initialize the virqfd workqueue in VFIO generic code
>       vfio/platform: implement IRQ masking/unmasking via an eventfd
> 
>      drivers/vfio/Kconfig                          |   1 +
>      drivers/vfio/Makefile                         |   5 +-
>      drivers/vfio/pci/vfio_pci.c                   |   8 -
>      drivers/vfio/pci/vfio_pci_intrs.c             | 238 +-----------
>      drivers/vfio/pci/vfio_pci_private.h           |   3 -
>      drivers/vfio/platform/Kconfig                 |  19 +
>      drivers/vfio/platform/Makefile                |   8 +
>      drivers/vfio/platform/vfio_amba.c             | 115 ++++++
>      drivers/vfio/platform/vfio_platform.c         | 103 +++++
>      drivers/vfio/platform/vfio_platform_common.c  | 521
>     ++++++++++++++++++++++++++
>      drivers/vfio/platform/vfio_platform_irq.c     | 336 +++++++++++++++++
>      drivers/vfio/platform/vfio_platform_private.h |  85 +++++
>      drivers/vfio/vfio.c                           |   8 +
>      drivers/vfio/virqfd.c                         | 213 +++++++++++
>      include/linux/vfio.h                          |  27 ++
>      include/uapi/linux/vfio.h                     |   2 +
>      16 files changed, 1456 insertions(+), 236 deletions(-)
>      create mode 100644 drivers/vfio/platform/Kconfig
>      create mode 100644 drivers/vfio/platform/Makefile
>      create mode 100644 drivers/vfio/platform/vfio_amba.c
>      create mode 100644 drivers/vfio/platform/vfio_platform.c
>      create mode 100644 drivers/vfio/platform/vfio_platform_common.c
>      create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
>      create mode 100644 drivers/vfio/platform/vfio_platform_private.h
>      create mode 100644 drivers/vfio/virqfd.c
> 
>     --
>     2.3.1
> 
> 

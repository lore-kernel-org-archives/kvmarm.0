From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v13 00/18] VFIO support for platform devices
Date: Thu, 26 Feb 2015 17:32:02 +0000
Message-ID: <54EF5892.7080908@arm.com>
References: <1422625584-3741-1-git-send-email-b.reynal@virtualopensystems.com>
 <CAN9JPjHo3AP_O=9EE83Fa7ZR+6Q2J2xYjc=ksNwLrF2WChZ4qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D1446B7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 12:26:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QDm7AFvw2egS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 12:26:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA13946B09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 12:26:18 -0500 (EST)
In-Reply-To: <CAN9JPjHo3AP_O=9EE83Fa7ZR+6Q2J2xYjc=ksNwLrF2WChZ4qg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>, Linux IOMMU <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>
Cc: VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, Will Deacon <Will.Deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Baptiste,

On 26/02/15 17:02, Baptiste Reynal wrote:
> Hi everyone,
> 
> Are there any comments on this patch series? If not, Is there
> anything keeping this series from getting merged upstream?

For a start, it looks like the dependency mentioned below is still not
in, which is a bit of a problem.

Also, trying to merge your branch below (after fixing the URL), I get
some conflicts with the current mainline, so that's a bit of a show
stopper too.

Can you start by rebasing on top of 4.0-rc1 with all the dependencies,
reposting the series, and cc-ing the original author of the patches (as
I cannot see Antonios on the CC list)?

Thanks,

	M.

> Thanks,
> Baptiste
> 
> On Fri, Jan 30, 2015 at 2:46 PM, Baptiste Reynal <b.reynal@virtualopensystems.com<mailto:b.reynal@virtualopensystems.com>> wrote:
> This patch series aims to implement VFIO support for platform devices that
> reside behind an IOMMU. Examples of such devices are devices behind an ARM
> SMMU, or behind a Samsung Exynos System MMU.
> 
> The API used is based on the existing VFIO API that is also used with PCI
> devices. Only devices that include a basic set of IRQs and memory regions are
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
>  - Some functionality has been removed from this series and posted separately:
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
>  drivers/vfio/platform/vfio_platform_common.c  | 521 ++++++++++++++++++++++++++
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


-- 
Jazz is not dead. It just smells funny...

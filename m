From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC v3 00/15] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Fri, 12 Feb 2016 08:13:02 +0000
Message-ID: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
It pursues the efforts done on [1], [2], [3]. It also aims at covering the
same need on PowerPC platforms although the same kind of integration
should be carried out.

On x86 all accesses to the 1MB PA region [FEE0_0000h - FEF0_000h] are directed
as interrupt messages: accesses to this special PA window directly target the
APIC configuration space and not DRAM, meaning the downstream IOMMU is bypassed.

This is not the case on above mentionned platforms where MSI messages emitted
by devices are conveyed through the IOMMU. This means an IOVA/host PA mapping
must exist for the MSI to reach the MSI controller. Normal way to create
IOVA bindings consists in using VFIO DMA MAP API. However in this case
the MSI IOVA is not mapped onto guest RAM but on host physical page (the MSI
controller frame).

In a nutshell, this series does:
- introduce an IOMMU API to register a IOVA window usable for reserved mapping
- reuse VFIO DMA MAP ioctl with a new flag to plug onto that new API
- check if the device MSI-parent controllers allow IRQ remapping
  (allow unsafe interrupt modality) for a given group
- introduce a new IOMMU API to allocate reserved IOVAs and bind them onto
  a physical address
- allow the GICv2M and GICv3-ITS PCI irqchip to map/unmap the MSI frame
  on irq_write_msi_msg

Best Regards

Eric

Testing:
- functional on ARM64 AMD Overdrive HW (single GICv2m frame) with an e1000e
  PCIe card.
- tested there is no regresion on
  x non assigned PCIe driver
  x platform device passthrough
- Not tested: ARM with SR-IOV, ARM GICv3 ITS, ...

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc3-pcie-passthrough-rfcv3

previous version at
v2: https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc3-pcie-passthrough-rfcv2
v1: https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc1-pcie-passthrough-v1

QEMU Integration:
[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
(http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2

User Hints:
To allow PCI/MSI passthrough with GICv2M, compile VFIO as a module and
load the vfio_iommu_type1 module with allow_unsafe_interrupts param:
sudo modprobe -v vfio-pci
sudo modprobe -r vfio_iommu_type1
sudo modprobe -v vfio_iommu_type1 allow_unsafe_interrupts=1

History:

RFC v2 -> RFC v3:
- should fix wrong handling of some CONFIG combinations:
  CONFIG_IOVA, CONFIG_IOMMU_API, CONFIG_PCI_MSI_IRQ_DOMAIN
- fix MSI_FLAG_IRQ_REMAPPING setting in GICv3 ITS (although not tested)

PATCH v1 -> RFC v2:
- reverted to RFC since it looks more reasonable ;-) the code is split
  between VFIO, IOMMU, MSI controller and I am not sure I did the right
  choices. Also API need to be further discussed.
- iova API usage in arm-smmu.c.
- MSI controller natively programs the MSI addr with either the PA or IOVA.
  This is not done anymore in vfio-pci driver as suggested by Alex.
- check irq remapping capability of the group

RFC v1 [2] -> PATCH v1:
- use the existing dma map/unmap ioctl interface with a flag to register a
  reserved IOVA range. Use the legacy Rb to store this special vfio_dma.
- a single reserved IOVA contiguous region now is allowed
- use of an RB tree indexed by PA to store allocated reserved slots
- use of a vfio_domain iova_domain to manage iova allocation within the
  window provided by the userspace
- vfio alloc_map/unmap_free take a vfio_group handle
- vfio_group handle is cached in vfio_pci_device
- add ref counting to bindings
- user modality enabled at the end of the series


Eric Auger (15):
  iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute
  vfio: expose MSI mapping requirement through VFIO_IOMMU_GET_INFO
  vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
  iommu: add alloc/free_reserved_iova_domain
  iommu/arm-smmu: implement alloc/free_reserved_iova_domain
  iommu/arm-smmu: add a reserved binding RB tree
  iommu: iommu_get/put_single_reserved
  iommu/arm-smmu: implement iommu_get/put_single_reserved
  iommu/arm-smmu: relinquish reserved resources on domain deletion
  vfio: allow the user to register reserved iova range for MSI mapping
  msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
  msi: export msi_get_domain_info
  vfio/type1: also check IRQ remapping capability at msi domain
  iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
  irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI frame when needed

 drivers/iommu/Kconfig                    |   2 +
 drivers/iommu/arm-smmu.c                 | 292 +++++++++++++++++++++++++++++--
 drivers/iommu/fsl_pamu_domain.c          |   2 +
 drivers/iommu/iommu.c                    |  43 +++++
 drivers/irqchip/irq-gic-common.c         |  69 ++++++++
 drivers/irqchip/irq-gic-common.h         |   5 +
 drivers/irqchip/irq-gic-v2m.c            |   7 +-
 drivers/irqchip/irq-gic-v3-its-pci-msi.c |   8 +-
 drivers/vfio/vfio_iommu_type1.c          | 157 ++++++++++++++++-
 include/linux/iommu.h                    |  31 ++++
 include/linux/msi.h                      |   2 +
 include/uapi/linux/vfio.h                |  10 ++
 kernel/irq/msi.c                         |   1 +
 13 files changed, 607 insertions(+), 22 deletions(-)

-- 
1.9.1

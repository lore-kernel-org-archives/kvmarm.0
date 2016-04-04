From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v6 0/5] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part
	3/3: vfio changes
Date: Mon,  4 Apr 2016 08:30:06 +0000
Message-ID: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
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
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

This series allows the user-space to register a reserved IOVA domain.
This completes the kernel integration of the whole functionality on top
of part 1 & 2.

We reuse the VFIO DMA MAP ioctl with a new flag to bridge to the
dma-reserved-iommu API. The number of IOVA pages to provision for MSI
binding is reported through the VFIO_IOMMU_GET_INFO iotcl.

vfio_iommu_type1 checks if the MSI mapping is safe when attaching the
vfio group to the container (allow_unsafe_interrupts modality).

On ARM/ARM64, the IOMMU does not astract IRQ remapping. the modality is
abstracted on MSI controller side. The GICv3 ITS is the first controller
advertising the modality.

More details & context can be found at:
http://www.linaro.org/blog/core-dump/kvm-pciemsi-passthrough-armarm64/

Best Regards

Eric

Testing:
- functional on ARM64 AMD Overdrive HW (single GICv2m frame) with
  x Intel e1000e PCIe card
  x Intel X540-T2 (SR-IOV capable)
- Not tested: ARM GICv3 ITS

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git: complete series available at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.6-rc1-pcie-passthrough-v6

previous version at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc6-pcie-passthrough-rfcv5

QEMU Integration:
[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
(http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2

History:

RFC v5 -> patch v6:
- split to ease the review process

RFC v4 -> RFC v5:
- take into account Thomas' comments on MSI related patches
  - split "msi: IOMMU map the doorbell address when needed"
  - increase readability and add comments
  - fix style issues
 - split "iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute"
 - platform ITS now advertises IOMMU_CAP_INTR_REMAP
 - fix compilation issue with CONFIG_IOMMU API unset
 - arm-smmu-v3 now advertises DOMAIN_ATTR_MSI_MAPPING

RFC v3 -> v4:
- Move doorbell mapping/unmapping in msi.c
- fix ref count issue on set_affinity: in case of a change in the address
  the previous address is decremented
- doorbell map/unmap now is done on msi composition. Should allow the use
  case for platform MSI controllers
- create dma-reserved-iommu.h/c exposing/implementing a new API dedicated
  to reserved IOVA management (looking like dma-iommu glue)
- series reordering to ease the review:
  - first part is related to IOMMU
  - second related to MSI sub-system
  - third related to VFIO (except arm-smmu IOMMU_CAP_INTR_REMAP removal)
- expose the number of requested IOVA pages through VFIO_IOMMU_GET_INFO
  [this partially addresses Marc's comments on iommu_get/put_single_reserved
   size/alignment problematic - which I did not ignore - but I don't know
   how much I can do at the moment]

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


Eric Auger (5):
  vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
  vfio: allow the user to register reserved iova range for MSI mapping
  vfio/type1: also check IRQ remapping capability at msi domain
  iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
  vfio/type1: return MSI mapping requirements with VFIO_IOMMU_GET_INFO

 drivers/iommu/arm-smmu.c        |   2 +-
 drivers/vfio/vfio_iommu_type1.c | 349 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  14 +-
 3 files changed, 358 insertions(+), 7 deletions(-)

-- 
1.9.1

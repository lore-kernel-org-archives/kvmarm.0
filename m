From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 0/8] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part
	3/3: vfio changes
Date: Tue, 19 Jul 2016 13:11:26 +0000
Message-ID: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
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
To: eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

This series allows the user-space to register a reserved IOVA domain.
This completes the kernel integration of the whole functionality on top
of the 2 previous parts (v11).

We reuse the VFIO DMA MAP ioctl with a new flag to bridge to the
msi-iommu API. The need for provisioning such MSI IOVA range is reported
through capability chain, using VFIO_IOMMU_TYPE1_INFO_CAP_MSI_GEOMETRY.

vfio_iommu_type1 checks if the MSI mapping is safe when attaching the
vfio group to the container (allow_unsafe_interrupts modality). This is
done in a very coarse way, looking at all the registered doorbells and
returning assignment is safe wrt IRQ if all the doorbells are safe.

More details & context can be found at:
http://www.linaro.org/blog/core-dump/kvm-pciemsi-passthrough-armarm64/

Best Regards

Eric

Testing:
- functional on ARM64 AMD Overdrive HW (single GICv2m frame) with
  Intel I350T2 (SR-IOV capable, igb/igbvf) and Intel 82574L (e1000e)
- functional on Cavium ThunderX (ARM GICv3 ITS) with Intel 82574L (e1000e)

References:
[1] [RFC 0/2] VFIO: Add virtual MSI doorbell support
    (https://lkml.org/lkml/2015/7/24/135)
[2] [RFC PATCH 0/6] vfio: Add interface to map MSI pages
    (https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016607.html)
[3] [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
    (http://permalink.gmane.org/gmane.comp.emulators.kvm.arm.devel/3858)

Git: complete series available at
https://github.com/eauger/linux/tree/v4.7-rc7-passthrough-v11

the above branch includes a temporary patch to work around a ThunderX pci
bus reset crash (which I think unrelated to this series):
"vfio: pci: HACK! workaround thunderx pci_try_reset_bus crash"
Do not take this for other platforms.
This issue will be handled separately on the ML.

previous version at
https://github.com/eauger/linux/tree/v4.7-rc2-passthrough-v10

History:
v10 -> v11:
- no change to this series, just incremented for consistency
- eventually tested with GICv3 ITS on Cavium

v9 -> v10:
Took into account Alex' comments:
- split "vfio/type1: vfio_find_dma accepting a type argument" into 2 patches
- properly implement replay of MSI DMA slots (by setting the aperture on the
  new domain); fixes the assignment of several devices
- rework user api for vfio_iommu_type1_info capability chains (cap_offset
  at the end of the struct and fix padding issues)
- VFIO_IOVA_RESERVED renamed into VFIO_IOVA_MSI_RESERVED
- explicit dma->type setting to VFIO_IOVA_USER

v8 -> v9:
- report MSI geometry through capability chain (last patch only);
  with the current limitation that an arbitrary number of 16 page
  requirement is reported. To be improved later on.

v7 -> v8:
- use renamed msi-iommu API
- VFIO only responsible for setting the IOVA aperture
- use new DOMAIN_ATTR_MSI_GEOMETRY iommu domain attribute

v6 -> v7:
- vfio_find_dma now accepts a dma_type argument.
- should have recovered the capability to unmap the whole user IOVA range
- remove computation of nb IOVA pages -> will post a separate RFC for that
  while respinning the QEMU part

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

Eric Auger (8):
  vfio: introduce a vfio_dma type field
  vfio/type1: vfio_find_dma accepting a type argument
  vfio/type1: implement recursive vfio_find_dma_from_node
  vfio/type1: handle unmap/unpin and replay for VFIO_IOVA_RESERVED slots
  vfio: allow reserved msi iova registration
  vfio/type1: check doorbell safety
  iommu/arm-smmu: do not advertise IOMMU_CAP_INTR_REMAP
  vfio/type1: return MSI geometry through VFIO_IOMMU_GET_INFO capability
    chains

 drivers/iommu/arm-smmu-v3.c     |   3 +-
 drivers/iommu/arm-smmu.c        |   3 +-
 drivers/vfio/vfio_iommu_type1.c | 246 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/vfio.h       |  42 ++++++-
 4 files changed, 276 insertions(+), 18 deletions(-)

-- 
1.9.1

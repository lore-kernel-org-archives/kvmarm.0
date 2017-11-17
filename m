From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [RFC PATCH v2 0/5] Add virtio-iommu driver
Date: Fri, 17 Nov 2017 18:52:06 +0000
Message-ID: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: iommu@lists.linux-foundation.org, devel@acpica.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org
Cc: jasowang@redhat.com, mst@redhat.com, lv.zheng@intel.com, robert.moore@intel.com, joro@8bytes.org, alex.williamson@redhat.com, sudeep.holla@arm.com, hanjun.guo@linaro.org, lorenzo.pieralisi@arm.com, lenb@kernel.org, rjw@rjwysocki.net, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, eric.auger@redhat.com, bharat.bhushan@nxp.com, Jayachandran.Nair@cavium.com, ashok.raj@intel.com, peterx@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Implement the virtio-iommu driver following version 0.5 of the
specification [1]. Previous version of this code was sent back in April
[2], implementing the first public RFC. Since then there has been lots of
progress and discussion on the specification side, and I think the driver
is in a good shape now.

The reason patches 1-3 are only RFC is that I'm waiting on feedback from
the Virtio TC to reserve a device ID.

List of changes since previous RFC:
* Add per-endpoint probe request, for hardware MSI and reserved regions.
* Add a virtqueue for the device to report translation faults. Only
  non-recoverable ones at the moment.
* Removed the iommu_map_sg specialization for now, because none of the
  device drivers I use for testing (virtio, ixgbe and internal DMA
  engines) seem to use map_sg. This kind of feature is a lot more
  interesting when accompanied by benchmark numbers, and can be added back
  during future optimization work.
* Many fixes and cleanup

The driver works out of the box on DT-based systems, but ACPI support
still needs to be tested and discussed. In the specification I proposed
IORT tables as a nice candidate for describing the virtual topology.
Patches 4 and 5 propose small changes to the IORT driver for
instantiating a paravirtualized IOMMU. The IORT node is described in the
specification [1]. x86 support will also require some hacks since the
driver is based on the IOMMU DMA ops, that x86 doesn't use.

Eric's latest QEMU device [3] works with v0.4. For the moment you can use
the kvmtool device [4] to test v0.5 on arm64, and inject arbitrary fault
with the debug tool. The driver can also be pulled from my Linux tree [5].

[1] https://www.spinics.net/lists/kvm/msg157402.html
[2] https://patchwork.kernel.org/patch/9670273/
[3] https://lists.gnu.org/archive/html/qemu-arm/2017-09/msg00413.html
[4] git://linux-arm.org/kvmtool-jpb.git virtio-iommu/base
[5] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.5-dev

Jean-Philippe Brucker (5):
  iommu: Add virtio-iommu driver
  iommu/virtio-iommu: Add probe request
  iommu/virtio-iommu: Add event queue
  ACPI/IORT: Support paravirtualized IOMMU
  ACPI/IORT: Move IORT to the ACPI folder

 drivers/acpi/Kconfig              |    3 +
 drivers/acpi/Makefile             |    1 +
 drivers/acpi/arm64/Kconfig        |    3 -
 drivers/acpi/arm64/Makefile       |    1 -
 drivers/acpi/{arm64 => }/iort.c   |   95 ++-
 drivers/iommu/Kconfig             |   12 +
 drivers/iommu/Makefile            |    1 +
 drivers/iommu/virtio-iommu.c      | 1219 +++++++++++++++++++++++++++++++++++++
 include/acpi/actbl2.h             |   18 +-
 include/uapi/linux/virtio_ids.h   |    1 +
 include/uapi/linux/virtio_iommu.h |  195 ++++++
 11 files changed, 1537 insertions(+), 12 deletions(-)
 rename drivers/acpi/{arm64 => }/iort.c (92%)
 create mode 100644 drivers/iommu/virtio-iommu.c
 create mode 100644 include/uapi/linux/virtio_iommu.h

-- 
2.14.3


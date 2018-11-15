From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v4 0/7] Add virtio-iommu driver
Date: Thu, 15 Nov 2018 16:52:27 +0000
Message-ID: <20181115165234.43990-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE6F4A32C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 11:58:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9W280LXF1AmJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 11:58:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74BE14A32B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 11:58:04 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, joro@8bytes.org, mst@redhat.com
Cc: kevin.tian@intel.com, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, marc.zyngier@arm.com, robin.murphy@arm.com, jasowang@redhat.com, will.deacon@arm.com, robh+dt@kernel.org, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Implement the virtio-iommu driver, following specification v0.8 [1].

Changes since v3 [2]:
* Rebase onto v4.20-rc2. Patch 3 now touches drivers/of/base.c instead
  of drivers/pci/of.c, since the map_rid() function has moved.
* Removed the request timeout, that depended on DEBUG.
* Other small fixes addressing comments on v3.

You can find Linux driver and kvmtool device on my virtio-iommu/v0.8.1
branches [3]. You can also test it with the latest version of Eric's
QEMU device [4].

[1] Virtio-iommu specification v0.8, sources and pdf
    git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.8
    http://jpbrucker.net/virtio-iommu/spec/v0.8/virtio-iommu-v0.8.pdf

[2] [PATCH v3 0/7] Add virtio-iommu driver
    https://www.spinics.net/lists/linux-pci/msg77110.html

[3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.8.1
    git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.8.1

[4] [RFC v8 00/18] VIRTIO-IOMMU device
    https://www.mail-archive.com/qemu-devel@nongnu.org/msg572637.html

Jean-Philippe Brucker (7):
  dt-bindings: virtio-mmio: Add IOMMU description
  dt-bindings: virtio: Add virtio-pci-iommu node
  of: Allow the iommu-map property to omit untranslated devices
  PCI: OF: Initialize dev->fwnode appropriately
  iommu: Add virtio-iommu driver
  iommu/virtio: Add probe request
  iommu/virtio: Add event queue

 .../devicetree/bindings/virtio/iommu.txt      |   66 +
 .../devicetree/bindings/virtio/mmio.txt       |   30 +
 MAINTAINERS                                   |    7 +
 drivers/iommu/Kconfig                         |   11 +
 drivers/iommu/Makefile                        |    1 +
 drivers/iommu/virtio-iommu.c                  | 1160 +++++++++++++++++
 drivers/of/base.c                             |   10 +-
 drivers/pci/of.c                              |    7 +
 include/uapi/linux/virtio_ids.h               |    1 +
 include/uapi/linux/virtio_iommu.h             |  161 +++
 10 files changed, 1451 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
 create mode 100644 drivers/iommu/virtio-iommu.c
 create mode 100644 include/uapi/linux/virtio_iommu.h

-- 
2.19.1

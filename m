From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/3] Introduce MSI hardware mapping for VFIO
Date: Tue, 24 Nov 2015 10:48:18 +0300
Message-ID: <cover.1448350806.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Alex Williamson <alex.williamson@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Manish Jaggi <mjaggi@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

On some architectures (e.g. ARM64) if the device is behind an IOMMU, and
is being mapped by VFIO, it is necessary to also add mappings for MSI
translation register for interrupts to work. This series implements the
necessary API to do this, and makes use of this API for GICv3 ITS on
ARM64.

Pavel Fedin (3):
  vfio: Introduce map and unmap operations
  gicv3, its: Introduce VFIO map and unmap operations
  vfio: Introduce generic MSI mapping operations

 drivers/irqchip/irq-gic-v3-its.c   |  31 ++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c  |  11 ++++
 drivers/vfio/vfio.c                | 112 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c    |  29 ++++++++++
 include/linux/irqchip/arm-gic-v3.h |   2 +
 include/linux/msi.h                |  12 ++++
 include/linux/vfio.h               |   6 +-
 7 files changed, 202 insertions(+), 1 deletion(-)

-- 
2.4.4


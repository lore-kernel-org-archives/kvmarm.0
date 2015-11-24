From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
Date: Tue, 24 Nov 2015 16:50:53 +0300
Message-ID: <cover.1448372839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD7249720
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 08:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HChj2QXz-GIB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 08:50:03 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D58BC4155B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 08:50:03 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00D4GNT0ZD10@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 13:51:00 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Manish Jaggi <mjaggi@caviumnetworks.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On some architectures (e.g. ARM64) if the device is behind an IOMMU, and
is being mapped by VFIO, it is necessary to also add mappings for MSI
translation register for interrupts to work. This series implements the
necessary API to do this, and makes use of this API for GICv3 ITS on
ARM64.

v1 => v2:
- Adde dependency on CONFIG_GENERIC_MSI_IRQ_DOMAIN in some parts of the
  code, should fix build without this option

Pavel Fedin (3):
  vfio: Introduce map and unmap operations
  gicv3, its: Introduce VFIO map and unmap operations
  vfio: Introduce generic MSI mapping operations

 drivers/irqchip/irq-gic-v3-its.c   |  31 ++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c  |  11 ++++
 drivers/vfio/vfio.c                | 116 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c    |  29 ++++++++++
 include/linux/irqchip/arm-gic-v3.h |   2 +
 include/linux/msi.h                |  12 ++++
 include/linux/vfio.h               |  17 +++++-
 7 files changed, 217 insertions(+), 1 deletion(-)

-- 
2.4.4

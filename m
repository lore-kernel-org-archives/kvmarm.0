From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 00/13] Add vfio-pci support
Date: Mon, 18 Jun 2018 19:41:58 +0100
Message-ID: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 960A54A0E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PDBlSZEqoHx4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5636C402B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:24 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This is version six of the VFIO support in kvmtool. It addresses
Will's comments for v5.

Implement vfio-pci support in kvmtool. Devices are assigned to the guest
by passing "--vfio-pci [domain:]bus:dev.fn" to lkvm run, after having
bound the device to the VFIO driver (see Documentation/vfio.txt)

This time around I also tested assignment of the x540 NIC on my old x86
desktop as well (previously only on AMD Seattle, an arm64 host). It
worked smoothly.

v6: git://linux-arm.org/kvmtool-jpb.git vfio/v6
v5: https://www.spinics.net/lists/kvm/msg166119.html

Jean-Philippe Brucker (13):
  pci: add config operations callbacks on the PCI header
  pci: allow to specify IRQ type for PCI devices
  irq: add irqfd helpers
  Extend memory bank API with memory types
  pci: add capability helpers
  Import VFIO headers
  Add fls_long and roundup_pow_of_two helpers
  Add PCI device passthrough using VFIO
  vfio-pci: add MSI-X support
  vfio-pci: add MSI support
  vfio: Support non-mmappable regions
  Introduce reserved memory regions
  vfio: check reserved regions before mapping DMA

 Makefile                     |    2 +
 arm/gic.c                    |   76 ++-
 arm/include/arm-common/gic.h |    6 +
 arm/kvm.c                    |    2 +-
 arm/pci.c                    |    4 +-
 builtin-run.c                |    5 +
 hw/pci-shmem.c               |   12 +-
 hw/vesa.c                    |    2 +-
 include/kvm/irq.h            |   17 +
 include/kvm/kvm-config.h     |    3 +
 include/kvm/kvm.h            |   54 +-
 include/kvm/pci.h            |  118 +++-
 include/kvm/util.h           |   14 +
 include/kvm/vfio.h           |  127 ++++
 include/linux/vfio.h         |  719 ++++++++++++++++++++
 irq.c                        |   31 +
 kvm.c                        |   99 ++-
 mips/kvm.c                   |    6 +-
 pci.c                        |  105 +--
 powerpc/kvm.c                |    2 +-
 vfio/core.c                  |  676 +++++++++++++++++++
 vfio/pci.c                   | 1193 ++++++++++++++++++++++++++++++++++
 virtio/net.c                 |    9 +-
 virtio/scsi.c                |   10 +-
 x86/kvm.c                    |    6 +-
 25 files changed, 3175 insertions(+), 123 deletions(-)
 create mode 100644 include/kvm/vfio.h
 create mode 100644 include/linux/vfio.h
 create mode 100644 vfio/core.c
 create mode 100644 vfio/pci.c

-- 
2.17.0

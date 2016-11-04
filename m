From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 00/16] kvmtool: arm: ITS emulation and GSI routing support
Date: Fri,  4 Nov 2016 17:31:47 +0000
Message-ID: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB55840420
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqS9L1jaMudo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8266D4029B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:22 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this series teaches kvmtool how to support KVM's ITS emulation. Also
(as this is somewhat related and has been co-developed) it enables GSI
routing for ARM/ARM64, which allows IRQFDs to be used, for instance
to use vhost_net. At the moment this is dependent on the guest
using the ITS emulation, but GICv2M support may be added at a later time.

The first six patches are generic fixes and refactoring to pave the
road for the rest of the patches. Most importantly patch 3/16 pulls
the GSI routing code from x86 into generic code.
The following six patches add ITS emulation support. They reserve and
register the required ITS register frame and populate a DT node with
the necessary data. Also the patches add the device ID to the
KVM_SIGNAL_MSI ioctl.
Patches 13 and 14 enable IRQ GSI routing for ARM/ARM64.
This is needed to use IRQFDs, which is a prerequisite for vhost
functionality, for instance. The code sets up the (dummy) SPI
routing table and adds the device ID to the routing entry.
The last two patches enables the guest ITS support by extending the
existing --irqchip= parameter to allow "--irqchip=gicv3-its", both
for ARM64 and ARM (kernel support for this is still pending).

These patches make use of the recently (4.8-rc) merged KVM kernel
functionality, both Eric's IRQ routing series and the ITS emulation.
It can also be found in my kvmtool git repository [1].

Compared to v7 of the series this is mostly bugfixing and updates,
also adds the 32-bit support provided by Vladimir.

Cheers,
Andre.

[1] git://linux-arm.org/kvmtool.git (branch: its/v8)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its/v8

Andre Przywara (15):
  FDT: introduce global phandle allocation
  arm: use new phandle allocation functions
  irq: move IRQ routing into irq.c
  MSI-X: update GSI routing after changed MSI-X configuration
  virtio: fix endianness check for vhost support
  PCI: Only allocate IRQ routing entry when available
  update public Linux headers for GICv3 ITS emulation
  arm: gic: allow 32-bit compilation
  arm: allow creation of an MSI register frame region
  arm: FDT: create MSI controller DT node
  add kvm__check_vm_capability
  PCI: inject PCI device ID on MSI injection
  arm: setup SPI IRQ routing tables
  extend GSI IRQ routing to take a device ID
  arm64: enable GICv3-ITS emulation

Vladimir Murzin (1):
  arm: add support for vGICv3 and vITS

 Makefile                                 |   5 +-
 arm/aarch32/arm-cpu.c                    |   4 +-
 arm/aarch32/include/asm/kvm.h            |   4 +-
 arm/aarch32/include/kvm/kvm-arch.h       |   3 -
 arm/aarch64/arm-cpu.c                    |   5 +-
 arm/aarch64/include/asm/kvm.h            |   2 +
 arm/aarch64/include/kvm/kvm-arch.h       |   3 -
 arm/fdt.c                                |   8 +-
 arm/gic.c                                | 132 ++++++++++++++++++++++++++++-
 arm/include/arm-common/gic.h             |   3 +-
 arm/include/arm-common/kvm-arch.h        |   2 +
 arm/include/arm-common/kvm-config-arch.h |   2 +-
 arm/include/arm-common/kvm-cpu-arch.h    |   3 +-
 arm/include/arm-common/pci.h             |   2 +-
 arm/irq.c                                |   9 --
 arm/pci.c                                |  13 ++-
 hw/pci-shmem.c                           |   5 +-
 include/kvm/fdt.h                        |  10 +--
 include/kvm/irq.h                        |   8 +-
 include/kvm/kvm.h                        |   1 +
 include/kvm/virtio.h                     |   9 +-
 include/linux/kvm.h                      |  19 ++++-
 irq.c                                    | 138 +++++++++++++++++++++++++++++++
 kvm-fdt.c                                |  26 ++++++
 kvm.c                                    |  28 +++++++
 mips/irq.c                               |  10 ---
 powerpc/irq.c                            |  31 -------
 virtio/net.c                             |   2 +-
 virtio/pci.c                             |  87 ++++++++++++++++---
 x86/include/asm/kvm.h                    |   6 +-
 x86/irq.c                                |  45 ++--------
 31 files changed, 480 insertions(+), 145 deletions(-)
 delete mode 100644 arm/irq.c
 create mode 100644 kvm-fdt.c
 delete mode 100644 mips/irq.c
 delete mode 100644 powerpc/irq.c

-- 
2.9.0

From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 00/15] kvmtool: arm: ITS emulation and GSI routing support
Date: Thu,  2 Feb 2017 16:32:08 +0000
Message-ID: <20170202163223.15372-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

an update to the ITS emulation series for kvmtool.
I reworked the phandle allocation by actually removing and replacing it
with some simple, static assignments. That definitely fits kvmtool's
needs today, where the GIC and the PCI controller are statically
assigned anyway. If that is too much of a simplification, let me know.
Also I fixed the error return in case some GSI routing setup fails.
On that way I use the opportunity to merge in 32-bit ARM support for the
ITS and the VGICv3, as the kernel learned about it recently as well.
The rest is effectively unchanged apart from some rebasing and
adjustments due to the mentioned changes.
-------------------------------------------

This series teaches kvmtool how to support KVM's ITS emulation. Also
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
The last patch finally enables the guest ITS support by extending the
existing --irqchip= parameter to allow "--irqchip=gicv3-its".

These patches make use of the recently (4.8-rc) merged KVM kernel
functionality, both Eric's IRQ routing series and the ITS emulation.
It can also be found in my kvmtool git repository [1].

Cheers,
Andre.

[1] git://linux-arm.org/kvmtool.git (branch: its/v9)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its/v9

Andre Przywara (14):
  FDT: use static phandles
  arm: use static DT phandle for the GIC
  irq: move IRQ routing into irq.c
  MSI-X: update GSI routing after changed MSI-X configuration
  virtio: fix endianness check for vhost support
  PCI: Only allocate IRQ routing entry when available
  update public Linux headers for GICv3 ITS emulation
  arm: allow creation of an MSI register frame region
  arm: FDT: create MSI controller DT node
  add kvm__check_vm_capability
  PCI: inject PCI device ID on MSI injection
  arm: setup SPI IRQ routing tables
  extend GSI IRQ routing to take a device ID
  arm64: enable GICv3-ITS emulation

Vladimir Murzin (1):
  arm: allow vGICv3 emulation

 Makefile                                 |   4 +-
 arm/aarch32/arm-cpu.c                    |   4 +-
 arm/aarch32/include/asm/kvm.h            |  13 ++-
 arm/aarch32/include/kvm/fdt-arch.h       |   6 ++
 arm/aarch32/include/kvm/kvm-arch.h       |   3 -
 arm/aarch64/arm-cpu.c                    |   5 +-
 arm/aarch64/include/asm/kvm.h            |   2 +
 arm/aarch64/include/kvm/fdt-arch.h       |   6 ++
 arm/aarch64/include/kvm/kvm-arch.h       |   3 -
 arm/fdt.c                                |   9 +-
 arm/gic.c                                | 130 +++++++++++++++++++++++++---
 arm/include/arm-common/fdt-arch.h        |   6 ++
 arm/include/arm-common/gic.h             |   3 +-
 arm/include/arm-common/kvm-arch.h        |   2 +
 arm/include/arm-common/kvm-config-arch.h |   2 +-
 arm/include/arm-common/kvm-cpu-arch.h    |   3 +-
 arm/include/arm-common/pci.h             |   2 +-
 arm/irq.c                                |   9 --
 arm/pci.c                                |   9 +-
 hw/pci-shmem.c                           |   5 +-
 include/kvm/fdt.h                        |   8 +-
 include/kvm/irq.h                        |   8 +-
 include/kvm/kvm.h                        |   1 +
 include/kvm/virtio.h                     |   9 +-
 include/linux/kvm.h                      |  31 ++++++-
 irq.c                                    | 141 +++++++++++++++++++++++++++++++
 kvm.c                                    |  28 ++++++
 mips/include/kvm/fdt-arch.h              |   6 ++
 mips/irq.c                               |  10 ---
 powerpc/include/asm/kvm.h                |   5 ++
 powerpc/include/kvm/fdt-arch.h           |   6 ++
 powerpc/irq.c                            |  31 -------
 powerpc/kvm.c                            |   2 -
 virtio/net.c                             |   2 +-
 virtio/pci.c                             | 104 +++++++++++++++++++----
 x86/include/asm/kvm.h                    |   6 +-
 x86/include/kvm/fdt-arch.h               |   6 ++
 x86/irq.c                                |  45 ++--------
 38 files changed, 509 insertions(+), 166 deletions(-)
 create mode 100644 arm/aarch32/include/kvm/fdt-arch.h
 create mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 create mode 100644 arm/include/arm-common/fdt-arch.h
 delete mode 100644 arm/irq.c
 create mode 100644 mips/include/kvm/fdt-arch.h
 delete mode 100644 mips/irq.c
 create mode 100644 powerpc/include/kvm/fdt-arch.h
 delete mode 100644 powerpc/irq.c
 create mode 100644 x86/include/kvm/fdt-arch.h

-- 
2.9.0

From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v10 00/15] kvmtool: arm: ITS emulation and GSI routing support
Date: Tue, 25 Apr 2017 15:39:17 +0100
Message-ID: <20170425143932.17235-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

another update to the ITS emulation series for kvmtool.
This addresses the comments Marc and Jean-Philippe had on the last
version (thanks for that!): I moved the DevID feature detection to avoid
static variables, rewrote the error path on creating IRQ routes and
extended the MMIO reservation to cover the ITS doorbell page as well.
Not sure if that's the right way to do, though.
Also we now ignore writes to the PBA region, which is what the spec
somewhat recommends.
-------------------------------------------

This series teaches kvmtool how to support KVM's ITS emulation. Also
(as this is somewhat related and has been co-developed) it enables GSI
routing for ARM/ARM64, which allows IRQFDs to be used, for instance
to use vhost_net. At the moment this is dependent on the guest
using the ITS emulation, but GICv2M support may be added at a later time.

The first six patches are generic fixes and refactoring to pave the
road for the rest of the patches. Most importantly patch 3/15 pulls
the GSI routing code from x86 into generic code.
Patch 7 updates the Linux headers to pull the new ITS and 32-bit
GICv3 definitions in. This allows us to enable GICv3 emulation for 32-bit
ARM and also get rid of some placeholder lines in patch 8.
The following four patches add ITS emulation support. They reserve and
register the required ITS register frame and populate a DT node with
the necessary data. Also the patches add the required device ID to the
KVM_SIGNAL_MSI ioctl.
Patches 13 and 14 enable IRQ GSI routing for ARM/ARM64.
This is needed to use IRQFDs, which is a prerequisite for vhost
functionality, for instance. The code sets up the (dummy) SPI
routing table and adds the device ID to the routing entry.
The last patch finally enables the guest ITS support by extending the
existing --irqchip= parameter to allow "--irqchip=gicv3-its".

These patches make use of the KVM kernel functionality merged into
4.8-rc: both Eric's IRQ routing series and the ITS emulation.
It can also be found in my kvmtool git repository [1].

Cheers,
Andre.

[1] git://linux-arm.org/kvmtool.git (branch: its/v10)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its/v10

Changelog v9 ... v10:
- [04/15]: ignore PBA writes
- [06/15]: reorder error checking for clarity
- [07/15]: update Linux headers with the latest HEAD (4.11-rc7+)
- [09/15]: extend ITS MMIO frame to cover doorbell page
- [11/15]: use actual function name in commit message
- [12/15]: check KVM_CAP_MSI_DEVID capability once and store it in struct kvm
- [14/15]: use stored KVM_CAP_MSI_DEVID capability

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
  add kvm__supports_vm_extension()
  PCI: inject PCI device ID on MSI injection
  arm: setup SPI IRQ routing tables
  extend GSI IRQ routing to take a device ID
  arm64: enable GICv3-ITS emulation

Vladimir Murzin (1):
  arm: allow vGICv3 emulation

 Makefile                                 |   4 +-
 arm/aarch32/arm-cpu.c                    |   4 +-
 arm/aarch32/include/asm/kvm.h            |  26 +++++-
 arm/aarch32/include/kvm/fdt-arch.h       |   6 ++
 arm/aarch32/include/kvm/kvm-arch.h       |   3 -
 arm/aarch64/arm-cpu.c                    |   5 +-
 arm/aarch64/include/asm/kvm.h            |  15 ++++
 arm/aarch64/include/kvm/fdt-arch.h       |   6 ++
 arm/aarch64/include/kvm/kvm-arch.h       |   3 -
 arm/fdt.c                                |   9 +--
 arm/gic.c                                | 134 ++++++++++++++++++++++++++++---
 arm/include/arm-common/fdt-arch.h        |   6 ++
 arm/include/arm-common/gic.h             |   3 +-
 arm/include/arm-common/kvm-arch.h        |   2 +
 arm/include/arm-common/kvm-config-arch.h |   2 +-
 arm/include/arm-common/kvm-cpu-arch.h    |   3 +-
 arm/include/arm-common/pci.h             |   2 +-
 arm/irq.c                                |   9 ---
 arm/pci.c                                |   9 ++-
 hw/pci-shmem.c                           |   5 +-
 include/kvm/fdt.h                        |   8 +-
 include/kvm/irq.h                        |   8 +-
 include/kvm/kvm.h                        |   2 +
 include/kvm/virtio.h                     |   9 ++-
 include/linux/kvm.h                      |  50 +++++++++++-
 irq.c                                    | 127 +++++++++++++++++++++++++++++
 kvm.c                                    |  28 +++++++
 mips/include/asm/kvm.h                   |   2 +
 mips/include/kvm/fdt-arch.h              |   6 ++
 mips/irq.c                               |  10 ---
 powerpc/include/asm/kvm.h                |  27 +++++++
 powerpc/include/kvm/fdt-arch.h           |   6 ++
 powerpc/irq.c                            |  31 -------
 powerpc/kvm.c                            |   2 -
 virtio/net.c                             |   2 +-
 virtio/pci.c                             | 105 ++++++++++++++++++++----
 x86/include/asm/kvm.h                    |   6 +-
 x86/include/kvm/fdt-arch.h               |   6 ++
 x86/irq.c                                |  45 ++---------
 39 files changed, 572 insertions(+), 164 deletions(-)
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

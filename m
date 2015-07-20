From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/14] kvmtool: add ITS emulation and GSI routing for ARM
Date: Mon, 20 Jul 2015 14:02:02 +0100
Message-ID: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this series teaches kvmtool how to support KVM's ITS emulation. Also
(as this is somewhat related and has been co-developed) it enables GSI
routing for ARM/ARM64, which allows IRQFDs to be used, for instance
to use vhost_net. At the moment this is dependent on the guest
using the ITS emulation, but GICv2M support patches will follow.

The first 4 patches are generic fixes and refactoring to pave the
road for the rest of the patches. Most importantly the first two pull
the GSI routing code from x86 into generic code.
The following 7 patches add ITS emulation support. They reserve and
register the required ITS register frame and populate a DT node with
the necessary data. Also the patches add the device ID to the
KVM_SIGNAL_MSI ioctl.
For enabling a guest ITS, the new --irqchip= parameter is extended
to allow "--irqchip=gicv3-its".
The remaining three patches enable IRQ GSI routing for ARM/ARM64.
This is needed to use IRQFDs, which is a prerequisite for vhost
functionality, for instance. The code sets up the (dummy) SPI
routing table and adds the device ID to the routing entry.

The ITS part relies on my kernel ITS emulation patches [1], the
IRQ routing part on Eric's respective series[2].
This code can also be found in my kvmtool git repository [3].

Cheers,
Andre.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015687.html
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-July/015621.html
[3] git://linux-arm.org/kvmtool.git (branch: its/v2)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its/v2


Andre Przywara (14):
  irq: move IRQ routing into irq.c
  MSI-X: update GSI routing after changed MSI-X configuration
  virtio: fix endianness check for vhost support
  FDT: introduce global phandle allocation
  arm: use new phandle allocation functions
  TEMPORARY: arm: update public headers for GICv3 ITS emulation
  arm: allow creation of an MSI register frame region
  arm: FDT: create MSI controller DT node
  add kvm__check_vm_capability
  PCI: inject PCI device ID on MSI injection
  arm64: enable GICv3-ITS emulation
  arm: setup SPI IRQ routing tables
  TEMPORARY: update public headers for kvm_irq_routing_msi extension
  extend GSI IRQ routing to take a device ID

 Makefile                                 |   5 +-
 arm/aarch32/arm-cpu.c                    |   4 +-
 arm/aarch64/arm-cpu.c                    |   5 +-
 arm/aarch64/include/asm/kvm.h            |   3 +
 arm/fdt.c                                |   8 +-
 arm/gic.c                                | 103 +++++++++++++++++++++++-
 arm/include/arm-common/gic.h             |   3 +-
 arm/include/arm-common/kvm-config-arch.h |   2 +-
 arm/include/arm-common/kvm-cpu-arch.h    |   3 +-
 arm/include/arm-common/pci.h             |   2 +-
 arm/irq.c                                |   9 ---
 arm/pci.c                                |  13 ++-
 hw/pci-shmem.c                           |   5 +-
 include/kvm/fdt.h                        |  10 +--
 include/kvm/irq.h                        |   8 +-
 include/kvm/kvm.h                        |   1 +
 include/kvm/virtio.h                     |   9 ++-
 include/linux/kvm.h                      |  11 ++-
 irq.c                                    | 134 +++++++++++++++++++++++++++++++
 kvm-fdt.c                                |  26 ++++++
 kvm.c                                    |  28 +++++++
 mips/irq.c                               |  10 ---
 powerpc/irq.c                            |  31 -------
 virtio/net.c                             |   2 +-
 virtio/pci.c                             |  72 ++++++++++++++---
 x86/irq.c                                |  45 ++---------
 26 files changed, 419 insertions(+), 133 deletions(-)
 delete mode 100644 arm/irq.c
 create mode 100644 kvm-fdt.c
 delete mode 100644 mips/irq.c
 delete mode 100644 powerpc/irq.c

-- 
2.3.5


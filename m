From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
Date: Fri, 29 May 2015 10:53:16 +0100
Message-ID: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 ITS (Interrupt Translation Service) is a part of the
ARM GICv3 interrupt controller used for implementing MSIs.
It specifies a new kind of interrupts (LPIs), which are mapped to
establish a connection between a device, its MSI payload value and
the target processor the IRQ is eventually delivered to.
In order to allow using MSIs in an ARM64 KVM guest, we emulate this
ITS widget in the kernel.
The ITS works by reading commands written by software (from the guest
in our case) into a (guest allocated) memory region and establishing
the mapping between a device, the MSI payload and the target CPU.
We parse these commands and update our internal data structures to
reflect those changes. On an MSI injection we iterate those
structures to learn the LPI number we have to inject.
For the time being we use simple lists to hold the data, this is
good enough for the small number of entries each of the components
currently have. Should this become a performance bottleneck in the
future, those can be extended to arrays or trees if needed.

Most of the code lives in a separate source file (its-emul.c), though
there are some changes necessary both in vgic.c and gic-v3-emul.c.
Patch 01/13 gets rid of the internal tracking of the used LR for
an injected IRQ.
Patch 02/13 extends the KVM MSI ioctl to hold a device ID.
Patch 03/13 introduces an emulation model specific destroy function
to let the ITS be teared down correctly later.
The rest of the patches implement the ITS functionality step by step.
For more details see the respective commit messages.

For the time being this series gives us the ability to use emulated
PCI devices that can use MSIs in the guest. Those have to be
triggered by letting the userland device emulation simulate the MSI
write with the KVM_SIGNAL_MSI ioctl. This will be translated into
the proper LPI by the ITS emulation and injected into the guest in
the usual way (just with a higher IRQ number).

This series is based on 4.1-rc5 and can be found at the its-emul/v1
branch of this repository [1].
For this to be used you need a GICv3 host machine, though it does not
rely on any host ITS bits (neither hardware or software).

To test this you can use the kvmtool patches available in the "its"
branch here [2].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v1
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its

Andre Przywara (13):
  KVM: arm/arm64: VGIC: don't track used LRs in the distributor
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: add emulation model specific destroy function
  KVM: arm64: Introduce new MMIO region for the ITS base address
  KVM: arm64: handle ITS related GICv3 redistributor registers
  KVM: arm64: introduce ITS emulation file with stub functions
  KVM: arm64: implement basic ITS register handlers
  KVM: arm64: add data structures to model ITS interrupt translation
  KVM: arm64: handle pending bit for LPIs in ITS emulation
  KVM: arm64: sync LPI properties and status between guest and KVM
  KVM: arm64: implement ITS command queue command handlers
  KVM: arm64: implement MSI injection in ITS emulation
  KVM: arm64: enable ITS emulation as a virtual MSI controller

 Documentation/virtual/kvm/api.txt              |   10 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |    7 +
 arch/arm64/include/uapi/asm/kvm.h              |    3 +
 arch/arm64/kvm/Kconfig                         |    1 +
 arch/arm64/kvm/Makefile                        |    1 +
 include/kvm/arm_vgic.h                         |   39 +-
 include/linux/irqchip/arm-gic-v3.h             |   10 +
 include/uapi/linux/kvm.h                       |    4 +-
 virt/kvm/arm/its-emul.c                        | 1026 ++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h                        |   52 ++
 virt/kvm/arm/vgic-v2.c                         |    1 +
 virt/kvm/arm/vgic-v3-emul.c                    |   98 ++-
 virt/kvm/arm/vgic-v3.c                         |    1 +
 virt/kvm/arm/vgic.c                            |  280 ++++---
 virt/kvm/arm/vgic.h                            |    5 +
 15 files changed, 1426 insertions(+), 112 deletions(-)
 create mode 100644 virt/kvm/arm/its-emul.c
 create mode 100644 virt/kvm/arm/its-emul.h

-- 
2.3.5


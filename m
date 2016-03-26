From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
Date: Sat, 26 Mar 2016 02:13:58 +0000
Message-ID: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2438140BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cBMagcYI+oud for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2016 22:13:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4846407A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2016 22:13:19 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is a rebased and reworked version of the ITS emulation support.
It allows KVM guests which use an emulated GICv3 to use LPIs as well,
though in the moment this is limited to emulated PCI devices.
It is now based on and requires the new VGIC implementation [1].

You can find all of this code (and the prerequisites) in the
its-emul/v4 branch of my repository [2].

Cheers,
Andre.

Changelog v3..v4:
- adapting to new VGIC (changes in IRQ injection mechanism)

Changelog v2..v3:
- adapt to 4.3-rc and Christoffer's timer rework
- adapt spin locks on handling PROPBASER/PENDBASER registers
- rework locking in ITS command handling (dropping dist where needed)
- only clear LPI pending bit if LPI could actually be queued
- simplify GICR_CTLR handling
- properly free ITTEs (including our pending bitmap)
- fix corner cases with unmapped collections
- keep retire_lr() around
- rename vgic_handle_base_register to vgic_reg64_access()
- use kcalloc instead of kmalloc
- minor fixes, renames and added comments

Changelog v1..v2
- fix issues when using non-ITS GICv3 emulation
- streamline frame address initialization (new patch 05/15)
- preallocate buffer memory for reading from guest's memory
- move locking into the actual command handlers
-   preallocate memory for new structures if needed
- use non-atomic __set_bit() and __clear_bit() when under the lock
- add INT command handler to allow LPI injection from the guest
- rewrite CWRITER handler to align with new locking scheme
- remove unneeded CONFIG_HAVE_KVM_MSI #ifdefs
- check memory table size against our LPI limit (65536 interrupts)
- observe initial gap of 1024 interrupts in pending table
- use term "configuration table" to be in line with the spec
- clarify and extend documentation on API extensions
- introduce new KVM_CAP_MSI_DEVID capability to advertise device ID requirement
- update, fix and add many comments
- minor style changes as requested by reviewers

---------------

The GICv3 ITS (Interrupt Translation Service) is a part of the
ARM GICv3 interrupt controller [4] used for implementing MSIs.
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
there are some changes necessary in the existing VGIC files.

For the time being this series gives us the ability to use emulated
PCI devices that can use MSIs in the guest. Those have to be
triggered by letting the userland device emulation simulate the MSI
write with the KVM_SIGNAL_MSI ioctl. This will be translated into
the proper LPI by the ITS emulation and injected into the guest in
the usual way (just with a higher IRQ number).

This series is based on 4.5 plus the KVM queue for 4.6 and the new VGIC
emulation code and can be found at the its-emul/v4 branch of this
repository [2].
For this to be used you need a GICv3 host machine (a fast model would
do), though it does not rely on any host ITS bits (neither in hardware
or software).

To test this you can use the kvmtool patches available in the "its"
branch here [3].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2016-March/019191.html
[2]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v4
[3]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its
[4]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf

Andre Przywara (12):
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
  KVM: arm64: Introduce new MMIO region for the ITS base address
  KVM: arm64: handle ITS related GICv3 redistributor registers
  KVM: arm64: introduce ITS emulation file with stub functions
  KVM: arm64: implement basic ITS register handlers
  KVM: arm64: add data structures to model ITS interrupt translation
  KVM: arm64: connect LPIs to the VGIC emulation
  KVM: arm64: sync LPI configuration and pending tables
  KVM: arm64: implement ITS command queue command handlers
  KVM: arm64: implement MSI injection in ITS emulation
  KVM: arm64: enable ITS emulation as a virtual MSI controller

 Documentation/virtual/kvm/api.txt              |   14 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |    9 +
 arch/arm/include/asm/kvm_host.h                |    2 +-
 arch/arm/kvm/arm.c                             |    2 +-
 arch/arm64/include/asm/kvm_host.h              |    2 +-
 arch/arm64/include/uapi/asm/kvm.h              |    2 +
 arch/arm64/kvm/Kconfig                         |    1 +
 arch/arm64/kvm/Makefile                        |    1 +
 arch/arm64/kvm/reset.c                         |   12 +-
 include/kvm/vgic/vgic.h                        |   33 +
 include/linux/irqchip/arm-gic-v3.h             |   28 +-
 include/uapi/linux/kvm.h                       |    5 +-
 virt/kvm/arm/vgic.c                            |    5 +
 virt/kvm/arm/vgic/its-emul.c                   | 1146 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c                       |   18 +
 virt/kvm/arm/vgic/vgic.h                       |   33 +
 virt/kvm/arm/vgic/vgic_init.c                  |    9 +
 virt/kvm/arm/vgic/vgic_kvm_device.c            |    7 +
 virt/kvm/arm/vgic/vgic_mmio.c                  |   54 +-
 19 files changed, 1365 insertions(+), 18 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/its-emul.c

-- 
2.7.3

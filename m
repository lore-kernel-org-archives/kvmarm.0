From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 00/15] KVM: arm64: GICv3 ITS emulation
Date: Fri, 10 Jul 2015 15:21:36 +0100
Message-ID: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E740D58564
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wGJMnBatTnRR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 10:10:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50C8858563
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:17 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this respin tries to address all comments I got so far from the list.
Thanks to Eric, Pavel and Christoffer for the review!
The major change in this series is the reworked locking. The current
implementation is now much more fine grained and avoids any calls to
functions that could possibly sleep when the ITS spinlock is held.
For many command handlers this change was straight forward, for some
memory is pre-allocated to avoid kmalloc calls. The function actually
triggering the command processing required some more trickery
(see patch 09/15).
Patch 01, 03, 06, 07, 10 were mostly unchanged, see the Changelog
below for a list of changes in the rest. On [1] there is a branch
called its-emul/v1-updated which is v1 plus the fixes rebased on top
of 4.2-rc1 and has all the changes from v2 in one single commit on
top of it.

Please have a look and feel free to ask questions or give comments.
Also holler if I should have missed to address a previous comment.
For this drop I haven't considered Eric's IRQ routing series too
much, but we should definitely coordinate those two series from this
point on.

Cheers,
Andre.

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
ARM GICv3 interrupt controller [3] used for implementing MSIs.
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
there are some changes necessary both in vgic.c and vgic-v3-emul.c.

Patch 01/15 gets rid of the internal tracking of the used LR for
an injected IRQ, see the commit message for more details.
Patch 02/13 extends the KVM MSI ioctl to hold a device ID.
Patch 03-05 make small changes to the existing VGIC code which make
adaptions to the ITS later easier.
The rest of the patches implement the ITS functionality step by step.
For more details see the respective commit messages.

For the time being this series gives us the ability to use emulated
PCI devices that can use MSIs in the guest. Those have to be
triggered by letting the userland device emulation simulate the MSI
write with the KVM_SIGNAL_MSI ioctl. This will be translated into
the proper LPI by the ITS emulation and injected into the guest in
the usual way (just with a higher IRQ number).

This series is based on 4.2-rc1 and can be found at the its-emul/v2
branch of this repository [1].
For this to be used you need a GICv3 host machine (a fast model would
do), though it does not rely on any host ITS bits (neither in hardware
or software).

To test this you can use the kvmtool patches available in the "its"
branch here [2].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v2
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its
[3]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf

Andre Przywara (15):
  KVM: arm/arm64: VGIC: don't track used LRs in the distributor
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: add emulation model specific destroy function
  KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
  KVM: arm/arm64: make GIC frame address initialization model specific
  KVM: arm64: Introduce new MMIO region for the ITS base address
  KVM: arm64: handle ITS related GICv3 redistributor registers
  KVM: arm64: introduce ITS emulation file with stub functions
  KVM: arm64: implement basic ITS register handlers
  KVM: arm64: add data structures to model ITS interrupt translation
  KVM: arm64: handle pending bit for LPIs in ITS emulation
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
 arch/arm64/kvm/reset.c                         |    8 +-
 include/kvm/arm_vgic.h                         |   41 +-
 include/linux/irqchip/arm-gic-v3.h             |   14 +-
 include/uapi/linux/kvm.h                       |    5 +-
 virt/kvm/arm/its-emul.c                        | 1141 ++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h                        |   55 ++
 virt/kvm/arm/vgic-v2-emul.c                    |    3 +
 virt/kvm/arm/vgic-v2.c                         |    1 +
 virt/kvm/arm/vgic-v3-emul.c                    |  105 ++-
 virt/kvm/arm/vgic-v3.c                         |    1 +
 virt/kvm/arm/vgic.c                            |  284 ++++--
 virt/kvm/arm/vgic.h                            |    5 +
 20 files changed, 1575 insertions(+), 121 deletions(-)
 create mode 100644 virt/kvm/arm/its-emul.c
 create mode 100644 virt/kvm/arm/its-emul.h

-- 
2.3.5

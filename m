From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 00/11] arm/arm64: KVM: Active interrupt state switching for
 shared devices
Date: Fri,  7 Aug 2015 16:45:36 +0100
Message-ID: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA375A44E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pKw+7zvUZ-hl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:33:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7521B5A447
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:00 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

>From day 1, our timer code has been using a terrible hack: whenever
the guest is scheduled with a timer interrupt pending (i.e. the HW
timer has expired), we restore the timer state with the MASK bit set,
in order to avoid the physical interrupt to fire again. And again. And
again...

This is absolutely silly, for at least two reasons:

- This relies on the device (the timer) having a mask bit that we can
  play with. Not all devices are built like this.

- This expects some behaviour of the guest that only works because the
  both the kernel timer code and the KVM counterpart have been written
  by the same idiot (the idiot being me).

The One True Way is to set the GIC active bit when injecting the
interrupt, and to context-switch across the world switch. This is what
this series implements.

We introduce a relatively simple infrastructure enabling the mapping
of a virtual interrupt with its physical counterpart:

- Whenever an virtual interrupt is injected, we look it up in an
  rbtree. If we have a match, the interrupt is injected with the HW
  bit set in the LR, together with the physical interrupt.

- Across the world switch, we save/restore the active state for these
  interrupts using the irqchip_state API.

- On guest EOI, the HW interrupt is automagically deactivated by the
  GIC, allowing the interrupt to be resampled.

The timer code is slightly modified to set the active state at the
same time as the injection.

The last patch also allows non-shared devices to have their interrupt
deactivated the same way (in this case we do not context-switch the
active state). This is the first step in the long overdue direction of
the mythical IRQ forwarding thing... This last patch is not a
candidate for merging, but is included for completeness, and to allow
Eric to base his own code on this stuff.

This series is based on v4.2-rc2 + the current queue for 4.3, and has
been tested on Juno, Cubietruck (GICv2) and the FVP Base model (GICv3
host, both GICv2 and GICv3 guests). I'd appreciate any form of
testing, specially in the context of guest migration (there is
obviously some interesting stuff there...).

The code is otherwise available at
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/active-timer-next

* From v3:
  - Fixed RCU thinko
  - Some more documentation
  - Added RBs from Christoffer

* From v2:
  - Many comments added
  - Fixed potential race between unmap and destroy
  - Removed the requirement for a GFP_ATOMIC allocations in map
  - New function names for the exported functions (map, unmap, get, set, init)
  - New patch preventing the injection of a HW mapped interrupt, and
    offer a new injection API

* From v1:
  - Rebased on top of current mainline
  - Fixed non-shared handling of forwarded interrupts
  - Fixed memory leaks on VM exit
  - Used RCU lists instead of an RB tree

Marc Zyngier (11):
  arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
  arm/arm64: KVM: Move vgic handling to a non-preemptible section
  KVM: arm/arm64: vgic: Convert struct vgic_lr to use bitfields
  KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
  KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
  KVM: arm/arm64: vgic: Allow dynamic mapping of physical/virtual
    interrupts
  KVM: arm/arm64: vgic: Allow HW interrupts to be queued to a guest
  KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
  KVM: arm/arm64: vgic: Prevent userspace injection of a mapped
    interrupt
  KVM: arm/arm64: timer: Allow the timer to control the active state
  KVM: arm/arm64: vgic: Allow HW interrupts for non-shared devices

 arch/arm/kvm/arm.c                 |  21 +-
 arch/arm/kvm/reset.c               |   4 +-
 arch/arm64/kvm/reset.c             |   4 +-
 include/kvm/arm_arch_timer.h       |   7 +-
 include/kvm/arm_vgic.h             |  41 +++-
 include/linux/irqchip/arm-gic-v3.h |   3 +
 include/linux/irqchip/arm-gic.h    |   3 +-
 virt/kvm/arm/arch_timer.c          |  30 ++-
 virt/kvm/arm/vgic-v2.c             |  16 +-
 virt/kvm/arm/vgic-v3.c             |  21 +-
 virt/kvm/arm/vgic.c                | 472 ++++++++++++++++++++++++++++++++++---
 11 files changed, 557 insertions(+), 65 deletions(-)

-- 
2.1.4

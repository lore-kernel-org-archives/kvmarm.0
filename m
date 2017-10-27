From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 00/20] KVM: arm/arm64: Optimize arch timer register handling
Date: Fri, 27 Oct 2017 10:34:21 +0200
Message-ID: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E8840795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IJDaPO91LKfr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:33:36 -0400 (EDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF842405F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:35 -0400 (EDT)
Received: by mail-lf0-f50.google.com with SMTP id 75so6551342lfx.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:35:00 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently spend a measurable amount of time on each entry/exit to the
guest dealing with arch timer registers, even when the timer is not
pending and not doing anything (on certain architectures).

We can do much better by moving the arch timer save/restore to the
vcpu_load and vcpu_put functions, but this means that if we don't read
back the timer state on every exit from the guest, then we have to be
able to start taking timer interrupts for the virtual timer in KVM and
handle that properly.

That has a number of entertaining consequences, such as having to make
sure we don't deadlock between any of the vgic code and interrupt
injection happening from an ISR.  On the plus side, being able to inject
virtual interrupts corresponding to a physical interrupt directly from
an ISR is probably a good system design change overall.

We also have to change the use of the physical vs. virtual counter in
the arm64 kernel to avoid having to save/restore the CNTVOFF_EL2
register on every return to the hypervisor.  The only reason I could
find for using the virtual counter for the kernel on systems with access
to the physical counter is to detect if firmware did not properly clear
CNTVOFF_EL2, and this change has to weighed against the existing check
(assuming I got this right).

On a non-VHE system (AMD Seattle) I have measured this to improve the
world-switch time by about ~100 cycles, but on an EL2 kernel (emulating
VHE behavior on the same hardware) this gives us around ~250 cycles
worth of improvement, and on Thunder-X we seem to get ~650 cycles
improvement, because we can avoid the extra configuration of trapping
accesses to the physical timer from EL1 on every switch.

These patches require that the GICv2 hardware (on such systems) is
properly reported by firmware to have the extra CPU interface page for
the deactivate register.

Code is also available here:
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git timer-optimize-v5

Based on v4.14-rc4

Some recent numbers I ran on Thunder-X with v4.14-rc1 with/without these
patches (averaged over a few hundred thousand executions) for a base
hypercall cost:

Without this series, avg. cycles: 12,476
Without this series, min. cycles: 12,052

With this series, avg. cycles: 11,782
With this series, min. cycles: 11,435

Improvement ~650 cycles (over 5%)

Changes sinve v4:
 - Applied reviewed-by and acked-by tags
 - Reworded commit message of patch 12

Changes since v3:
 - Rebased on v4.14-rc4
 - Changes to specific patches appended to the modified patch
 - Applied acked-by/reviewed-by tags

Changes since v2:
 - Removed RFC tag
 - Included Marc's patch to support EOI/deactivate on broken firmware
   systems
 - Simplified patch 6 (was patch 5 in RFC v2)
 - Clarify percpu_devid interrupts in patch 12 (was patch 11)

Thanks,
-Christoffer

Christoffer Dall (19):
  arm64: Implement arch_counter_get_cntpct to read the physical counter
  arm64: Use physical counter for in-kernel reads when booted in EL2
  KVM: arm/arm64: Guard kvm_vgic_map_is_active against !vgic_initialized
  KVM: arm/arm64: Support calling vgic_update_irq_pending from irq
    context
  KVM: arm/arm64: Check that system supports split eoi/deactivate
  KVM: arm/arm64: Make timer_arm and timer_disarm helpers more generic
  KVM: arm/arm64: Rename soft timer to bg_timer
  KVM: arm/arm64: Move timer/vgic flush/sync under disabled irq
  KVM: arm/arm64: Use separate timer for phys timer emulation
  KVM: arm/arm64: Move timer save/restore out of the hyp code
  genirq: Document vcpu_info usage for percpu_devid interrupts
  KVM: arm/arm64: Set VCPU affinity for virt timer irq
  KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit
  KVM: arm/arm64: Support EL1 phys timer register access in set/get reg
  KVM: arm/arm64: Use kvm_arm_timer_set/get_reg for guest register traps
  KVM: arm/arm64: Move phys_timer_emulate function
  KVM: arm/arm64: Avoid phys timer emulation in vcpu entry/exit
  KVM: arm/arm64: Get rid of kvm_timer_flush_hwstate
  KVM: arm/arm64: Rework kvm_timer_should_fire

Marc Zyngier (1):
  irqchip/gic: Deal with broken firmware exposing only 4kB of GICv2 CPU
    interface

 Documentation/admin-guide/kernel-parameters.txt |   7 +
 arch/arm/include/asm/kvm_asm.h                  |   2 +
 arch/arm/include/asm/kvm_hyp.h                  |   4 +-
 arch/arm/include/uapi/asm/kvm.h                 |   6 +
 arch/arm/kvm/hyp/switch.c                       |   7 +-
 arch/arm64/include/asm/arch_timer.h             |   8 +-
 arch/arm64/include/asm/kvm_asm.h                |   2 +
 arch/arm64/include/asm/kvm_hyp.h                |   4 +-
 arch/arm64/include/asm/timex.h                  |   2 +-
 arch/arm64/include/uapi/asm/kvm.h               |   6 +
 arch/arm64/kvm/hyp/switch.c                     |   6 +-
 arch/arm64/kvm/sys_regs.c                       |  41 +--
 drivers/clocksource/arm_arch_timer.c            |  35 +-
 drivers/irqchip/irq-gic-v3.c                    |   8 +-
 drivers/irqchip/irq-gic.c                       |  77 +++-
 include/kvm/arm_arch_timer.h                    |  26 +-
 kernel/irq/manage.c                             |   3 +-
 virt/kvm/arm/arch_timer.c                       | 448 ++++++++++++++++--------
 virt/kvm/arm/arm.c                              |  45 ++-
 virt/kvm/arm/hyp/timer-sr.c                     |  74 ++--
 virt/kvm/arm/vgic/vgic-its.c                    |  17 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                |  22 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                |  17 +-
 virt/kvm/arm/vgic/vgic-mmio.c                   |  44 ++-
 virt/kvm/arm/vgic/vgic-v2.c                     |   5 +-
 virt/kvm/arm/vgic/vgic-v3.c                     |  12 +-
 virt/kvm/arm/vgic/vgic.c                        |  62 ++--
 virt/kvm/arm/vgic/vgic.h                        |   3 +-
 28 files changed, 654 insertions(+), 339 deletions(-)

-- 
2.7.4

From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 0/9] Userspace timer IRQ number control and PMU with
 userspace-gic
Date: Thu,  8 Jun 2017 15:34:37 +0200
Message-ID: <20170608133446.3875-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D4940C50
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 418HqyBcOvXp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 09:30:41 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1316340430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:40 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id d73so31212556wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jun 2017 06:34:50 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

So far we have been getting away with letting the kernel choosing
interrupt numbers for the timers in the kernel and we have crossed our
fingers in hoping that the DT/ACPI provided by userspace matches with
the interrupt number we use in the kernel for a given VCPU type.

But as we are generally moving towards letting userspace be in more fine
grained control of what is being emulated, let userspace decide the irq
numbers for the timers.

Slightly related, and therefore included in this series, we have
recently added support for a userspace GIC while still supporting the
generic timers and the PMU from inside the VM.  Unfortunately we forgot
to rework the code to actually let userspace create the PMU device
without creating an in-kernel GIC.

Patches 6-9 could be omitted and still support the basic functionality
targeted by this series if preferred.

Tested on APM X-Gene, Thunder-X, and TC2.

QEMU patches used for testing can be found here:

https://git.linaro.org/people/christoffer.dall/qemu-arm.git timer-pmu-irqs

Changes since v2:
 - Grammer change
 - Move PMU irq consistency check to when we are about to run a VCPU,
   ensuring that we do not allow an unconfigure irq line with an
   in-kernel gic.
 - Rebased on kvmarm/queue.
 - Acked reviewed-by and acked-by from Marc on some patches

Changes since v1:
 - Rebased on v4.12-rc1
 - Check for irqchip_in_kernel() in kvm_arm_pmu_v3_get_attr
 - Slightly change the wording around default timer IRQs
 - Add fix for the PMU IRQ setting that assumes an initialized vgic
 - Introduce an allocator for IRQ lines so that in-kernel owned IRQ
   lines cannot be signalled from userspace and such that an IRQ line
   can only be assigned to a single device.

Christoffer Dall (9):
  KVM: arm64: Allow creating the PMU without the in-kernel GIC
  KVM: arm: Handle VCPU device attributes in guest.c
  KVM: arm/arm64: Move irq_is_ppi() to header file
  KVM: arm/arm64: Move timer IRQ default init to arch_timer.c
  KVM: arm/arm64: Allow setting the timer IRQ numbers from userspace
  KVM: arm/arm64: Introduce an allocator for in-kernel irq lines
  KVM: arm/arm64: Check if irq lines to the GIC are already used
  KVM: arm/arm64: Disallow userspace control of in-kernel IRQ lines
  KVM: arm/arm64: Don't assume initialized vgic when setting PMU IRQ

 Documentation/virtual/kvm/devices/vcpu.txt |  41 +++++++--
 arch/arm/include/asm/kvm_host.h            |  22 ++---
 arch/arm/include/uapi/asm/kvm.h            |   8 ++
 arch/arm/kvm/guest.c                       |  51 +++++++++++
 arch/arm/kvm/reset.c                       |  16 +---
 arch/arm64/include/uapi/asm/kvm.h          |   3 +
 arch/arm64/kvm/guest.c                     |   9 ++
 arch/arm64/kvm/reset.c                     |  16 +---
 include/kvm/arm_arch_timer.h               |   8 +-
 include/kvm/arm_pmu.h                      |   6 ++
 include/kvm/arm_vgic.h                     |  13 ++-
 virt/kvm/arm/arch_timer.c                  | 137 ++++++++++++++++++++++++++---
 virt/kvm/arm/arm.c                         |   8 +-
 virt/kvm/arm/pmu.c                         |  65 ++++++++++----
 virt/kvm/arm/vgic/vgic-irqfd.c             |   2 +-
 virt/kvm/arm/vgic/vgic.c                   |  48 +++++++++-
 16 files changed, 359 insertions(+), 94 deletions(-)

-- 
2.9.0

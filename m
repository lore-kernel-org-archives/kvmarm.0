From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 0/5] Support userspace irqchip with arch timers
Date: Fri,  3 Feb 2017 15:56:50 +0100
Message-ID: <20170203145655.15007-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Pekka Enberg <penberg@iki.fi>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series is the second version of the rework of the patches to support
architected timers with a userspace irqchip sent by Alexander Graf [1].

We first cleanup some of the timer code to make it easier to understand
what is being done in the later patches, and then define the ABI,
implement timers support, implement PMU support, and finally advertise
the features.

These patches are based on the recent work from Jintack to support the
physical timer in addition to the virtual timer.  This series including
its dependencies can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git irqs-to-user-v2

I tested this using Alex's QEMU patch with his suggestion to fix the SMP
breakage on top.  While this works for UP guests, SMP guests seem to
still fail.  It would be good if someone could help me have a look at
that since most likely it's a QEMU issue as we established last time.  I
pushed a temporary branch for this stuff:

https://git.linaro.org/people/christoffer.dall/qemu-arm.git no-kvm-irqchip

Changes since v1:
 - Rework the ABI to support devices in general as opposed to just
   timers
 - Support the PMU in addition to timers
 - Also support the physical timer (rebased on Jintack's work)
 - Updated some comments where I noticed things were out of date.

Several changes have been made compared to v7 of the original single
patch, including:
 - Rewording ABI documentation to be more in line with the ARM
   architecture
 - Add an explicit check for needing to notify userspace of a level
   change instead of propagating the value
 - Changes to commenting throughout to more accurately describe the
   architecture concepts we try to maintain
 - Reword of functions, for example from sync to update when the date
   only flows one direction


[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2016-September/021867.html
[2]: git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next

Christoffer Dall (5):
  KVM: arm/arm64: Cleanup the arch timer code's irqchip checking
  KVM: arm/arm64: Add ARM user space interrupt signaling ABI
  KVM: arm/arm64: Support arch timers with a userspace gic
  KVM: arm/arm64: Report PMU overflow interrupts to userspace irqchip
  KVM: arm/arm64: Advertise support for KVM_CAP_ARM_USER_IRQ

 Documentation/virtual/kvm/api.txt |  41 ++++++++++++
 arch/arm/include/uapi/asm/kvm.h   |   2 +
 arch/arm/kvm/arm.c                |  28 ++++++---
 arch/arm64/include/uapi/asm/kvm.h |   2 +
 include/kvm/arm_arch_timer.h      |   2 +
 include/kvm/arm_pmu.h             |   7 +++
 include/uapi/linux/kvm.h          |   8 +++
 virt/kvm/arm/arch_timer.c         | 127 ++++++++++++++++++++++++++++++--------
 virt/kvm/arm/pmu.c                |  42 +++++++++++--
 9 files changed, 220 insertions(+), 39 deletions(-)

-- 
2.9.0

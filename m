From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 0/5] Userspace timer IRQ number control and PMU with userspace-gic
Date: Wed,  3 May 2017 20:32:55 +0200
Message-ID: <20170503183300.4618-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
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

Tested on APM X-Gene, AMD Seattle, and TC2.

QEMU patches used for testing can be found here:

https://git.linaro.org/people/christoffer.dall/qemu-arm.git timer-pmu-irqs


Thanks,
-Christoffer

Christoffer Dall (5):
  KVM: arm64: Allow creating the PMU without the in-kernel GIC
  KVM: arm: Handle VCPU device attributes in guest.c
  KVM: arm/arm64: Move irq_is_ppi() to header file
  KVM: arm/arm64: Move timer IRQ default init to arch_timer.c
  KVM: arm/arm64: Allow setting the timer IRQ numbers from userspace

 Documentation/virtual/kvm/devices/vcpu.txt |  41 +++++++--
 arch/arm/include/asm/kvm_host.h            |  22 ++---
 arch/arm/include/uapi/asm/kvm.h            |   8 ++
 arch/arm/kvm/guest.c                       |  51 +++++++++++
 arch/arm/kvm/reset.c                       |  16 +---
 arch/arm64/include/uapi/asm/kvm.h          |   3 +
 arch/arm64/kvm/guest.c                     |   9 ++
 arch/arm64/kvm/reset.c                     |  16 +---
 include/kvm/arm_arch_timer.h               |   8 +-
 include/kvm/arm_vgic.h                     |   2 +
 virt/kvm/arm/arch_timer.c                  | 132 ++++++++++++++++++++++++++---
 virt/kvm/arm/pmu.c                         |  29 ++++---
 12 files changed, 258 insertions(+), 79 deletions(-)

-- 
2.9.0

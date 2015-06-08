From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/10] arm/arm64: KVM: Active interrupt state switching for shared devices
Date: Mon,  8 Jun 2015 18:03:55 +0100
Message-ID: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
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
the mythical IRQ forwarding thing...

This series is based on v4.1-rc7, and has been tested on Juno (GICv2)
and the FVP Base model (GICv3 host, both GICv2 and GICv3 guests). I'd
appreciate any form of testing, specially in the context of guest
migration (there is obviously some interesting stuff there...).

The code is otherwise available at
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/active-timer

Marc Zyngier (10):
  arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
  arm/arm64: KVM: Move vgic handling to a non-preemptible section
  KVM: arm/arm64: vgic: Convert struct vgic_lr to use bitfields
  KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
  KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
  KVM: arm/arm64: vgic: Allow dynamic mapping of physical/virtual
    interrupts
  KVM: arm/arm64: vgic: Allow HW interrupts to be queued to a guest
  KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
  KVM: arm/arm64: timer: Allow the timer to control the active state
  KVM: arm/arm64: vgic: Allow non-shared device HW interrupts

 arch/arm/kvm/arm.c                 |  21 +++-
 include/kvm/arm_arch_timer.h       |   3 +
 include/kvm/arm_vgic.h             |  31 +++++-
 include/linux/irqchip/arm-gic-v3.h |   3 +
 include/linux/irqchip/arm-gic.h    |   3 +-
 virt/kvm/arm/arch_timer.c          |  13 ++-
 virt/kvm/arm/vgic-v2.c             |  16 ++-
 virt/kvm/arm/vgic-v3.c             |  21 +++-
 virt/kvm/arm/vgic.c                | 206 ++++++++++++++++++++++++++++++++++++-
 9 files changed, 300 insertions(+), 17 deletions(-)

-- 
2.1.4


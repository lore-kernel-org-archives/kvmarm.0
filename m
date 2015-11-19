From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 00/13] ARM IRQ forward control based on IRQ bypass manager
Date: Thu, 19 Nov 2015 14:53:50 +0000
Message-ID: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69BE44994F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mOilVnpTtq-2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:31 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 060DA498D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:30 -0500 (EST)
Received: by wmec201 with SMTP id c201so29559865wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:10 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series allows to optimize the deactivation of virtual interrupts
associated to a vfio platform device IRQ. Let's call this optimization:
ARM IRQ forwarding.

Without that optimization the deactivation of the physical IRQ is done
by the host and the deactivation of the virtual IRQ, by the guest,
is trapped by KVM with a maintenance IRQ. With ARM IRQ forwarding, the
physical IRQ is automatically deactivated by the GIC interrupt controller
when the guest deactivates the virtual IRQ.

The series enables the auto-negotiation of this optimization, on ARM.
The auto-negotiation is coordinated by the IRQ bypass manager. The VFIO
platform driver and KVM/irqfd cooperate to turn that feature on.

The series implements the setup of IRQ forwarding and adapt the existing
VGIC state machine so that it works.

When the IRQ is forwarded, the VFIO platform driver does not need to
mask the physical IRQ anymore before signaling the eventfd. Indeed
genirq lowers the running priority, enabling other physical IRQ to hit
except that one.

The injection still is based on irqfd triggering. The only impact on
irqfd process is the resamplefd is not triggered anymore for level
sensitive IRQs since deactivation is not trapped by KVM.

More backgroung on ARM IRQ forwarding in the text below and at
http://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf.

This was tested on:
- Calxeda Midway, assigning the xgmac main IRQ.
- AMD Seattle, where all XGBE interrupts are assigned:
  - 2 level sensitive and 4 DMA edge sensitive IRQs

applies on top of:
KVM: arm/arm64: leave the LR active state on GICD_ICENABLERn access

All those pieces can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.4-rc1-forward-v4

History:

v3 -> v4:
- dependencies now are fixed (IRQ bypass manager, guest synchronous
  halt/resume, VGIC architected timer)
  - only applies on top of:
  KVM: arm/arm64: leave the LR active state on GICD_ICENABLERn access
- Rebase on vgic series related to forwarded shared interrupts, mainly
  [PATCH v2 0/8] Rework architected timer and forwarded IRQs handling &
  [PATCH 0/2] arm/arm64: KVM: Fix architected timer issues
- took into account Alex's comment on VFIO part:
  - vfio_platform_set_forwarded replacing vfio_platform_set_automasked
  - automasked flag not updated
  - vfio_platform_is_active renamed into vfio_platform_irq_is_active
  - handle returned value for vfio_platform_irq_is_active
  - remove WARN_ON on irq_bypass_register_producer failure
- took into account Christoffer's comments on vgic part
  - clarify comments
  - clarify edge-sensitive handling and validate_injection of edge
    mapped unshared IRQ with level == 0
  - use actual vcpu_id instead of VCPU 0
  - revisit unset_forward implement using unqueue
- moved KVM: arm/arm64: select IRQ_BYPASS_MANAGER in this series
- add support for clear active and clear pending

v2 (RFC) -> v3(PATCH):
- all dependencies now have a patch status
- we dropped the producer active boolean exchanged between the
  VFIO producer and irqfd arm consumer. As a consequence, on
  unforward, if the IRQ is active, this latter is deactivated
  without VFIO-masking it. So we do not exactly come back to the
  exact state where we would be in unforwarded state. A new
  physical IRQ can hit while the previous virtual IRQ is under
  treatment. Its injection in the guest may be rejected thanks
  to the VGIC state machine. This IRQ will be lost but I don't
  think this is a severe issue. In case no new IRQ hits, the
  guest deactivation of the virtual IRQ will trigger the resamplefd
  which will VFIO unmask the non-masked IRQ. This also has no
  consequence.
- VFIO platform driver consumer_add now can fail. It rejects the
  transition for forwarding state in case the IRQ is active
- the series is rebased on new irq_vcpu_affinity series
- no dependency anymore on "chip/vgic adaptations for forwarded irq"
  which was partially integrated into Marc's series. A fix is still
  needed through.
- Guest synchronous halt/resume patch re-integrated into this series
- integrate a new patch file coming mixing
  [PATCH v4 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
                   non-shared devices &
  [RFC v2 2/4] KVM: arm: vgic: fix state machine for forwarded IRQ

v1 -> v2:
- irq bypass manager and irqfd consumer moved in a separate patch
- kvm_arm_[halt,resume]_guest moved in a separate patch
- remove VFIO external functions since we do not need them anymore
- apply container_of strategy advised by Paolo. Only active field
  remains and discussions will tell whether we get rid of it.
- renamed kvm_arch functions

- kvm-vfio v6 -> RFC v1 based on IRQ bypass manager
  see previous history in https://lkml.org/lkml/2015/4/13/353).

Best Regards

Eric


Eric Auger (12):
  KVM: arm/arm64: select IRQ_BYPASS_MANAGER
  VFIO: platform: registration of a dummy IRQ bypass producer
  VFIO: platform: test forwarded state when selecting the IRQ handler
  VFIO: platform: single handler using function pointer
  VFIO: platform: add vfio_platform_set_forwarded
  VFIO: platform: add vfio_platform_irq_is_active
  VFIO: platform: add irq bypass producer management
  KVM: arm/arm64: vgic: support irqfd injection of a mapped IRQ
  KVM: arm/arm64: vgic: forwarding control
  KVM: arm/arm64: vgic: implement clear active for non shared mapped IRQ
  KVM: arm/arm64: vgic: implement clear pending for non shared mapped
    IRQ
  KVM: arm/arm64: implement IRQ bypass consumer functions

Marc Zyngier (1):
  KVM: arm/arm64: vgic: adapt state machine for non shared mapped
    interrupts

 arch/arm/kvm/Kconfig                          |   3 +
 arch/arm/kvm/arm.c                            |  37 +++++
 arch/arm64/kvm/Kconfig                        |   3 +
 drivers/vfio/platform/vfio_platform_irq.c     | 120 +++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   4 +
 include/kvm/arm_vgic.h                        |   8 +-
 virt/kvm/arm/arch_timer.c                     |   2 +-
 virt/kvm/arm/vgic.c                           | 221 ++++++++++++++++++++++++--
 8 files changed, 376 insertions(+), 22 deletions(-)

-- 
1.9.1

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/37] KVM: arm/arm64: Fix potential loss of ptimer interrupts
Date: Mon, 13 Aug 2018 15:57:45 +0100
Message-ID: <20180813145755.16566-28-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A5E84A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbaXDkEw3WgY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46BA04A216
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:16 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

kvm_timer_update_state() is called when changing the phys timer
configuration registers, either via vcpu reset, as a result of a trap
from the guest, or when userspace programs the registers.

phys_timer_emulate() is in turn called by kvm_timer_update_state() to
either cancel an existing software timer, or program a new software
timer, to emulate the behavior of a real phys timer, based on the change
in configuration registers.

Unfortunately, the interaction between these two functions left a small
race; if the conceptual emulated phys timer should actually fire, but
the soft timer hasn't executed its callback yet, we cancel the timer in
phys_timer_emulate without injecting an irq.  This only happens if the
check in kvm_timer_update_state is called before the timer should fire,
which is relatively unlikely, but possible.

The solution is to update the state of the phys timer after calling
phys_timer_emulate, which will pick up the pending timer state and
update the interrupt value.

Note that this leaves the opportunity of raising the interrupt twice,
once in the just-programmed soft timer, and once in
kvm_timer_update_state.  Since this always happens synchronously with
the VCPU execution, there is no harm in this, and the guest ever only
sees a single timer interrupt.

Cc: Stable <stable@vger.kernel.org> # 4.15+
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index bd3d57f40f1b..18ff6203079d 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -295,9 +295,9 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
-	 * If the timer can fire now we have just raised the IRQ line and we
-	 * don't need to have a soft timer scheduled for the future.  If the
-	 * timer cannot fire at all, then we also don't need a soft timer.
+	 * If the timer can fire now, we don't need to have a soft timer
+	 * scheduled for the future.  If the timer cannot fire at all,
+	 * then we also don't need a soft timer.
 	 */
 	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
 		soft_timer_cancel(&timer->phys_timer, NULL);
@@ -332,10 +332,10 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	level = kvm_timer_should_fire(vtimer);
 	kvm_timer_update_irq(vcpu, level, vtimer);
 
+	phys_timer_emulate(vcpu);
+
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
-
-	phys_timer_emulate(vcpu);
 }
 
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
-- 
2.18.0

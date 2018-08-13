From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 28/37] KVM: arm/arm64: Fix lost IRQs from emulated physcial
 timer when blocked
Date: Mon, 13 Aug 2018 15:57:46 +0100
Message-ID: <20180813145755.16566-29-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9508B4A245
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cWFOf08OJ89g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 719394A246
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:19 -0400 (EDT)
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

When the VCPU is blocked (for example from WFI) we don't inject the
physical timer interrupt if it should fire while the CPU is blocked, but
instead we just wake up the VCPU and expect kvm_timer_vcpu_load to take
care of injecting the interrupt.

Unfortunately, kvm_timer_vcpu_load() doesn't actually do that, it only
has support to schedule a soft timer if the emulated phys timer is
expected to fire in the future.

Follow the same pattern as kvm_timer_update_state() and update the irq
state after potentially scheduling a soft timer.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Cc: Stable <stable@vger.kernel.org> # 4.15+
Fixes: bbdd52cfcba29 ("KVM: arm/arm64: Avoid phys timer emulation in vcpu entry/exit")
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 18ff6203079d..17cecc96f735 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -487,6 +487,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	if (unlikely(!timer->enabled))
 		return;
@@ -502,6 +503,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	/* Set the background timer for the physical timer emulation. */
 	phys_timer_emulate(vcpu);
+
+	/* If the timer fired while we weren't running, inject it now */
+	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
+		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
-- 
2.18.0

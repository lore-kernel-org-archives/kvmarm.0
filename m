From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 28/28] KVM: arm/arm64: Fixup userspace irqchip static key optimization
Date: Wed, 31 Jan 2018 10:35:07 +0100
Message-ID: <20180131093507.22219-29-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When I introduced a static key to avoid work in the critical path for
userspace irqchips which is very rarely used, I accidentally messed up
my logic and used && where I should have used ||, because the point was
to short-circuit the evaluation in case userspace irqchips weren't even
in use.

This fixes an issue when running in-kernel irqchip VMs alongside
userspace irqchip VMs.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Fixes: c44c232ee2d3 ("KVM: arm/arm64: Avoid work when userspace iqchips are not used")
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 63cf828f3c4f..fb6bd9b9845e 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -286,7 +286,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
 				   timer_ctx->irq.level);
 
-	if (!static_branch_unlikely(&userspace_irqchip_in_use) &&
+	if (!static_branch_unlikely(&userspace_irqchip_in_use) ||
 	    likely(irqchip_in_kernel(vcpu->kvm))) {
 		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 					  timer_ctx->irq.irq,
-- 
2.14.2

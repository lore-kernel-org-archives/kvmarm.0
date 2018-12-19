From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/28] KVM: arm/arm64: vgic: Consider priority and active
 state for pending irq
Date: Wed, 19 Dec 2018 18:03:39 +0000
Message-ID: <20181219180349.242681-19-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602964A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q92YDPeMbUds for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E08694A38B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:59 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

When checking if there are any pending IRQs for the VM, consider the
active state and priority of the IRQs as well.

Otherwise we could be continuously scheduling a guest hypervisor without
it seeing an IRQ.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index f884a54b2601..a6b135491b6c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -908,6 +908,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	struct vgic_irq *irq;
 	bool pending = false;
 	unsigned long flags;
+	struct vgic_vmcr vmcr;
 
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
@@ -915,11 +916,15 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
 		return true;
 
+	vgic_get_vmcr(vcpu, &vmcr);
+
 	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
-		pending = irq_is_pending(irq) && irq->enabled;
+		pending = irq_is_pending(irq) && irq->enabled &&
+			  !irq->active &&
+			  irq->priority < vmcr.pmr;
 		spin_unlock(&irq->irq_lock);
 
 		if (pending)
-- 
2.19.2

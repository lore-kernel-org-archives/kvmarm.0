From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 17/19] KVM: arm/arm64: Fix spinlock acquisition in
 vgic_set_owner
Date: Mon,  4 Dec 2017 15:03:46 +0100
Message-ID: <20171204140348.21965-15-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75C249DB3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PckCXhFov0Zh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:01:11 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D43CE49D70
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:03 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id f9so14549220wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:04:11 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

vgic_set_owner acquires the irq lock without disabling interrupts,
resulting in a lockdep splat (an interrupt could fire and result
in the same lock being taken if the same virtual irq is to be
injected).

In practice, it is almost impossible to trigger this bug, but
better safe than sorry. Convert the lock acquisition to a
spin_lock_irqsave() and keep lockdep happy.

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 786cce7bd2ec..ecb8e25f5fe5 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -492,6 +492,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 {
 	struct vgic_irq *irq;
+	unsigned long flags;
 	int ret = 0;
 
 	if (!vgic_initialized(vcpu->kvm))
@@ -502,12 +503,12 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 		return -EINVAL;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->owner && irq->owner != owner)
 		ret = -EEXIST;
 	else
 		irq->owner = owner;
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	return ret;
 }
-- 
2.14.2

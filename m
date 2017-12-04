From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 02/19] KVM: arm/arm64: VGIC: extend !vgic_is_initialized guard
Date: Mon,  4 Dec 2017 14:56:20 +0100
Message-ID: <20171204135637.21620-3-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E374349D72
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 08:53:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZJL9LFPlGkD5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 08:53:34 -0500 (EST)
Received: from mail-wr0-f195.google.com (mail-wr0-f195.google.com
 [209.85.128.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F038D49D4E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 08:53:33 -0500 (EST)
Received: by mail-wr0-f195.google.com with SMTP id a41so15514740wra.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 05:56:41 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Commit f39d16cbabf9 ("KVM: arm/arm64: Guard kvm_vgic_map_is_active against
!vgic_initialized") introduced a check whether the VGIC has been
initialized before accessing the spinlock and the VGIC data structure.
However the vgic_get_irq() call in the variable declaration sneaked
through the net, so lets make sure that this also gets called only after
we actually allocated the arrays this function accesses.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index b168a328a9e0..786cce7bd2ec 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -823,13 +823,14 @@ void vgic_kick_vcpus(struct kvm *kvm)
 
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	struct vgic_irq *irq;
 	bool map_is_active;
 	unsigned long flags;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return false;
 
+	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	spin_lock_irqsave(&irq->irq_lock, flags);
 	map_is_active = irq->hw && irq->active;
 	spin_unlock_irqrestore(&irq->irq_lock, flags);
-- 
2.14.2

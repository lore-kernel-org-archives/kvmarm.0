From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 02/59] KVM: arm/arm64: vgic: streamline
 vgic_update_irq_pending() interface
Date: Tue, 24 May 2016 11:08:56 +0200
Message-ID: <1464080993-10884-3-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CD5949B63
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3okoJm+R2yuv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:24 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D6C749B49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:24 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id n129so15328218wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:09:57 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

We actually don't use the irq_phys_map parameter in
vgic_update_irq_pending(), so let's just remove it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 60668a7..f6c6172 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1521,7 +1521,6 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
 }
 
 static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
-				   struct irq_phys_map *map,
 				   unsigned int irq_num, bool level)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -1660,7 +1659,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 	if (map)
 		return -EINVAL;
 
-	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
+	return vgic_update_irq_pending(kvm, cpuid, irq_num, level);
 }
 
 /**
@@ -1686,7 +1685,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.1.2.330.g565301e.dirty

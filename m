From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 04/20] KVM: arm/arm64: Guard kvm_vgic_map_is_active against
 !vgic_initialized
Date: Fri, 27 Oct 2017 10:34:25 +0200
Message-ID: <1509093281-15225-5-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA05040795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f5CAVZz75nQg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:33:59 -0400 (EDT)
Received: from mail-lf0-f68.google.com (mail-lf0-f68.google.com
 [209.85.215.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E029649D51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:33:58 -0400 (EDT)
Received: by mail-lf0-f68.google.com with SMTP id g70so6545300lfl.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:35:23 -0700 (PDT)
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

If the vgic is not initialized, don't try to grab its spinlocks or
traverse its data structures.

This is important because we soon have to start considering the active
state of a virtual interrupts when doing vcpu_load, which may happen
early on before the vgic is initialized.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index fed717e..e1f7dbc 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -777,6 +777,9 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	bool map_is_active;
 
+	if (!vgic_initialized(vcpu->kvm))
+		return false;
+
 	spin_lock(&irq->irq_lock);
 	map_is_active = irq->hw && irq->active;
 	spin_unlock(&irq->irq_lock);
-- 
2.7.4

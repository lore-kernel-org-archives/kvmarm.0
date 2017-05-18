From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 04/13] KVM: arm/arm64: vgic-v2: Do not use Active+Pending state
 for a HW interrupt
Date: Thu, 18 May 2017 11:47:13 +0200
Message-ID: <20170518094722.9926-5-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFE6340C5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1zxWvvoP-E5X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:11 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D23740BBC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:10 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id v15so45993959wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:41 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When an interrupt is injected with the HW bit set (indicating that
deactivation should be propagated to the physical distributor),
special care must be taken so that we never mark the corresponding
LR with the Active+Pending state (as the pending state is kept in
the physycal distributor).

Cc: stable@vger.kernel.org
Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index a65757a..504b4bd 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -149,6 +149,13 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->hw) {
 		val |= GICH_LR_HW;
 		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active && irq_is_pending(irq))
+			val &= ~GICH_LR_PENDING_BIT;
 	} else {
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			val |= GICH_LR_EOI;
-- 
2.9.0

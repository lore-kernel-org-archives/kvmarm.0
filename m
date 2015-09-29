From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 5/8] arm/arm64: KVM: Use appropriate define in VGIC reset
 code
Date: Tue, 29 Sep 2015 16:49:02 +0200
Message-ID: <1443538145-11990-6-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 003F9423B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vy+HsfeD+L70 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:39 -0400 (EDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5EEC41172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:37 -0400 (EDT)
Received: by labzv5 with SMTP id zv5so11737455lab.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:12 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently initialize the SGIs to be enabled in the VGIC code, but we
use the VGIC_NR_PPIS define for this purpose, instead of the the more
natural VGIC_NR_SGIS.  Change this slightly confusing use of the
defines.

Note: This should have no functional change, as both names are defined
to the number 16.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index e606f78..9ed8d53 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2109,7 +2109,7 @@ int vgic_init(struct kvm *kvm)
 		}
 
 		for (i = 0; i < dist->nr_irqs; i++) {
-			if (i < VGIC_NR_PPIS)
+			if (i < VGIC_NR_SGIS)
 				vgic_bitmap_set_irq_val(&dist->irq_enabled,
 							vcpu->vcpu_id, i, 1);
 			if (i < VGIC_NR_PRIVATE_IRQS)
-- 
2.1.2.330.g565301e.dirty

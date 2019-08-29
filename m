Return-Path: <SRS0=G53S=WZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A945AC3A59F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 18:16:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D505233FF
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 18:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xDFEgPrU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D505233FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132AD4A57F;
	Thu, 29 Aug 2019 14:16:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id My1up4Zylrid; Thu, 29 Aug 2019 14:16:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B0F4A585;
	Thu, 29 Aug 2019 14:16:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74E54A55F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 14:16:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQyIA5vkts1i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Aug 2019 14:16:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9763C4A55E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 14:16:53 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1ACA62341B;
 Thu, 29 Aug 2019 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1567102612;
 bh=gTanq0p86gaTdfODTA2HnD4pvQYAj3g9WBxr2OM955c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=xDFEgPrU5BDvnw7f2GEas/qL46Us49j6BW0fIthsz1WvqvGIh3/YPPCFiZOpIhBUX
 eXq1I3mMKSL9Fsq+PNXEZruH898S0K/YL0ZtYnhHv00y2kKQoch6OS1URQaV2VQohh
 mflU4UsiiokWgIMvUcYRRDtgO7yZGTUyDEGyJCNE=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 45/45] KVM: arm/arm64: VGIC: Properly initialise
 private IRQ affinity
Date: Thu, 29 Aug 2019 14:15:45 -0400
Message-Id: <20190829181547.8280-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <dave.martin@arm.com>, Julien Grall <julien.grall@arm.com>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 2e16f3e926ed48373c98edea85c6ad0ef69425d1 ]

At the moment we initialise the target *mask* of a virtual IRQ to the
VCPU it belongs to, even though this mask is only defined for GICv2 and
quickly runs out of bits for many GICv3 guests.
This behaviour triggers an UBSAN complaint for more than 32 VCPUs:
------
[ 5659.462377] UBSAN: Undefined behaviour in virt/kvm/arm/vgic/vgic-init.c:223:21
[ 5659.471689] shift exponent 32 is too large for 32-bit type 'unsigned int'
------
Also for GICv3 guests the reporting of TARGET in the "vgic-state" debugfs
dump is wrong, due to this very same problem.

Because there is no requirement to create the VGIC device before the
VCPUs (and QEMU actually does it the other way round), we can't safely
initialise mpidr or targets in kvm_vgic_vcpu_init(). But since we touch
every private IRQ for each VCPU anyway later (in vgic_init()), we can
just move the initialisation of those fields into there, where we
definitely know the VGIC type.

On the way make sure we really have either a VGICv2 or a VGICv3 device,
since the existing code is just checking for "VGICv3 or not", silently
ignoring the uninitialised case.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Dave Martin <dave.martin@arm.com>
Tested-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8196e4f8731fb..cd75df25fe140 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -19,6 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
@@ -175,12 +176,18 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
 		kref_init(&irq->refcount);
-		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		switch (dist->vgic_model) {
+		case KVM_DEV_TYPE_ARM_VGIC_V2:
 			irq->targets = 0;
 			irq->group = 0;
-		} else {
+			break;
+		case KVM_DEV_TYPE_ARM_VGIC_V3:
 			irq->mpidr = 0;
 			irq->group = 1;
+			break;
+		default:
+			kfree(dist->spis);
+			return -EINVAL;
 		}
 	}
 	return 0;
@@ -220,7 +227,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->intid = i;
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
-		irq->targets = 1U << vcpu->vcpu_id;
 		kref_init(&irq->refcount);
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
@@ -230,11 +236,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 			/* PPIs */
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
-
-		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-			irq->group = 1;
-		else
-			irq->group = 0;
 	}
 
 	if (!irqchip_in_kernel(vcpu->kvm))
@@ -297,10 +298,19 @@ int vgic_init(struct kvm *kvm)
 
 		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
 			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
-			if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+			switch (dist->vgic_model) {
+			case KVM_DEV_TYPE_ARM_VGIC_V3:
 				irq->group = 1;
-			else
+				irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+				break;
+			case KVM_DEV_TYPE_ARM_VGIC_V2:
 				irq->group = 0;
+				irq->targets = 1U << idx;
+				break;
+			default:
+				ret = -EINVAL;
+				goto out;
+			}
 		}
 	}
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4306DFC6195
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 17:50:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0735D21D7F
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 17:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0735D21D7F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B184A97E;
	Fri,  8 Nov 2019 12:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QjIINi7z2j+O; Fri,  8 Nov 2019 12:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4527B4AEF1;
	Fri,  8 Nov 2019 12:50:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EB014AEE0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 12:50:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vDDrOeRkWm3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 12:50:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F2E44AEE1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 12:50:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4DDDAB6;
 Fri,  8 Nov 2019 09:50:03 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76D1F3F719;
 Fri,  8 Nov 2019 09:50:02 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH 3/3] kvm: arm: VGIC: Enable proper Group0 handling
Date: Fri,  8 Nov 2019 17:49:52 +0000
Message-Id: <20191108174952.740-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108174952.740-1-andre.przywara@arm.com>
References: <20191108174952.740-1-andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Now that our VGIC emulation can properly deal with two separate
interrupt groups and their enable bits, we can allow a guest to control
the Group0 enable bit in the distributor.

When evaluating the state of an interrupt, we now take its individual
group enable bit into account, and drop the global "distributor
disabled" notion when checking for VCPUs with a pending interrupt.

This allows the guest to control both groups independently.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 28d9ff282017..ed3a10b9ea93 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -203,8 +203,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
 
 static bool vgic_irq_is_grp_enabled(struct kvm *kvm, struct vgic_irq *irq)
 {
-	/* Placeholder implementation until we properly support Group0. */
-	return kvm->arch.vgic.groups_enable;
+	return vgic_dist_group_enabled(kvm, irq->group);
 }
 
 /**
@@ -320,15 +319,6 @@ int vgic_dist_enable_group(struct kvm *kvm, int group, bool status)
 	if (new_bit == was_enabled)
 		return 0;
 
-	/* Group 0 on GICv3 and Group 1 on GICv2 are ignored for now. */
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		if (group == GIC_GROUP0)
-			return 0;
-	} else {
-		if (group == GIC_GROUP1)
-			return 0;
-	}
-
 	dist->groups_enable &= ~group_mask;
 	dist->groups_enable |= new_bit;
 	if (new_bit > was_enabled)
@@ -435,15 +425,6 @@ bool vgic_dist_group_enabled(struct kvm *kvm, int group)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	/* Group 0 on GICv3 and Group 1 on GICv2 are ignored for now. */
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		if (group == GIC_GROUP0)
-			return false;
-	} else {
-		if (group == GIC_GROUP1)
-			return false;
-	}
-
 	return dist->groups_enable & (1U << group);
 }
 
@@ -1093,9 +1074,6 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
 
-	if (!vcpu->kvm->arch.vgic.groups_enable)
-		return false;
-
 	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
 		return true;
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

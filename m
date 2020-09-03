Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D92CC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53C2B208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1oJVtoOj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53C2B208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C1784B32B;
	Thu,  3 Sep 2020 11:56:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYu9gUQ4Jb+s; Thu,  3 Sep 2020 11:56:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43344B2F4;
	Thu,  3 Sep 2020 11:56:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E68F4B249
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:56:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H-39Zzhr7ZnE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 11:56:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AA514B2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:56:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 54E4B20775;
 Thu,  3 Sep 2020 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599148565;
 bh=BmshpFlV+n7bQmpjLopkOVFKcvTuVvSTl9VMzmtkbv4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1oJVtoOjR7FgrGeGiYdGO8mweovEh7c6U9WSv1EPU8Y17MkDVEfGpwTE4B7OXAuTO
 qJEFPHJAIhL+WJu3ISTXo6V4rnG8vYzSrKWlzEu9w07rXUw3lw7SWXQoxbWSByqjv7
 1veGfPOUuITYAykVdRc3pU0BMNCEt2Vu/h6mcAhg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDr8B-008vT9-SM; Thu, 03 Sep 2020 16:26:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/23] KVM: arm64: Move set_owner into irqchip_flow
Date: Thu,  3 Sep 2020 16:26:05 +0100
Message-Id: <20200903152610.1078827-19-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com
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

Move the set_owner callback into irqchip_flow. It's not that
useful an API anyway, and we should consider getting rid of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_irq.h | 4 ++++
 arch/arm64/kvm/arch_timer.c      | 4 ++--
 arch/arm64/kvm/pmu-emul.c        | 4 ++--
 arch/arm64/kvm/vgic/vgic-init.c  | 1 +
 arch/arm64/kvm/vgic/vgic.h       | 1 +
 include/kvm/arm_vgic.h           | 2 --
 6 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 16556417bd4a..d1fc86b54f2d 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -38,6 +38,7 @@ struct kvm_irqchip_flow {
 	int  (*irqchip_map_phys_irq)(struct kvm_vcpu *, unsigned int,
 				     u32, bool (*)(int));
 	int  (*irqchip_unmap_phys_irq)(struct kvm_vcpu *, unsigned int);
+	int  (*irqchip_set_owner)(struct kvm_vcpu *, unsigned int, void *);
 };
 
 /*
@@ -114,4 +115,7 @@ struct kvm_irqchip_flow {
 #define kvm_irqchip_unmap_phys_irq(v, ...)		\
 	__vcpu_irqchip_action_ret((v), unmap_phys_irq, (v), __VA_ARGS__)
 
+#define kvm_irqchip_set_owner(v, ...)		\
+	__vcpu_irqchip_action_ret((v), set_owner, (v), __VA_ARGS__)
+
 #endif
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 16999de299a7..706fd0c63273 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1083,12 +1083,12 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 	int i, ret;
 
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
-	ret = kvm_vgic_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
+	ret = kvm_irqchip_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
 	if (ret)
 		return false;
 
 	ptimer_irq = vcpu_ptimer(vcpu)->irq.irq;
-	ret = kvm_vgic_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
+	ret = kvm_irqchip_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
 	if (ret)
 		return false;
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f31ee6ad3444..d87f71845a64 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -758,8 +758,8 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			return -ENXIO;
 
-		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
-					 &vcpu->arch.pmu);
+		ret = kvm_irqchip_set_owner(vcpu, vcpu->arch.pmu.irq_num,
+					    &vcpu->arch.pmu);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index ed62c0a27b53..6ace624b439d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -33,6 +33,7 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
 	.irqchip_reset_mapped_irq	= kvm_vgic_reset_mapped_irq,
 	.irqchip_map_phys_irq		= kvm_vgic_map_phys_irq,
 	.irqchip_unmap_phys_irq		= kvm_vgic_unmap_phys_irq,
+	.irqchip_set_owner		= kvm_vgic_set_owner,
 };
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index af4a0e5f31c1..c9e14a6cddf6 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -334,6 +334,7 @@ void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, bool (*get_input_level)(int));
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ff8c49c0ebbd..f753110e24f9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -362,8 +362,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
  */
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
 
-int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
-
 struct kvm_kernel_irq_routing_entry;
 
 int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

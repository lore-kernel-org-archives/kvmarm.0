Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AACC433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:26:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9FE92072A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PppcZONE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9FE92072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 595244B2D1;
	Thu,  3 Sep 2020 11:26:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hrzVHjG52hOi; Thu,  3 Sep 2020 11:26:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F274B313;
	Thu,  3 Sep 2020 11:26:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE6CB4B1FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:26:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhzJPVwHsNaf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 11:26:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BDD14B2F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:26:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C39A1208C7;
 Thu,  3 Sep 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599146786;
 bh=wXj+MzUSlzqCPZ4DfFe3HKrFKIE2+Uir+iEwtYqABWk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PppcZONE5Vx7PAKAOs9M++PS6byf3UAu4kuczVkm12sfMttWmEF+WwI3AURD2PDw3
 Vh1Pt1Znsfd/EAoq4n48JW9t5fdLqlHN6gDgbwZ/0Pi8cnrbcYEIkj8GzrdfDDnriD
 fdKznP5LBg07MzxTX5aqX7jAuNgOP0AKnVLj1KIg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDr85-008vT9-67; Thu, 03 Sep 2020 16:26:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/23] KVM: arm64: Add irqchip callback structure to kvm_arch
Date: Thu,  3 Sep 2020 16:25:54 +0100
Message-Id: <20200903152610.1078827-8-maz@kernel.org>
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

As we are about to abstract part of the vgic implementation in
order to make it more modular, let's start by adding a data
structure that will eventually contain interrupt controller
specific callbacks, as well as helpers to call them (or
gracefully skip them if they aren't implemented.

It is empty so far, so no functional changes are anticipated.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_irq.h  | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c   |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0e30e12b523..52b502f3076f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,6 +100,7 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	enum kvm_irqchip_type	irqchip_type;
+	struct kvm_irqchip_flow	irqchip_flow;
 	struct vgic_dist	vgic;
 
 	/* Mandated version of PSCI */
diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 46bffb6026f8..7a70bb803560 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -17,4 +17,33 @@ enum kvm_irqchip_type {
 #define irqchip_is_gic_v2(k)	((k)->arch.irqchip_type == IRQCHIP_GICv2)
 #define irqchip_is_gic_v3(k)	((k)->arch.irqchip_type == IRQCHIP_GICv3)
 
+struct kvm_irqchip_flow {
+};
+
+/*
+ * Macro galore. At the point this is included, the various types are
+ * not defined yet. Yes, this is terminally ugly.
+ */
+#define __kvm_irqchip_action(k, x, ...)					\
+	do {								\
+		if (likely((k)->arch.irqchip_flow.irqchip_##x))		\
+			(k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__); \
+	} while (0)
+
+#define __kvm_irqchip_action_ret(k, x, ...)				\
+	({								\
+		typeof ((k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__)) ret; \
+		ret = (likely((k)->arch.irqchip_flow.irqchip_##x) ?	\
+		       (k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__) : \
+		       0);						\
+									\
+		ret;							\
+	 })
+
+#define __vcpu_irqchip_action(v, ...)			\
+	__kvm_irqchip_action((v)->kvm, __VA_ARGS__)
+
+#define __vcpu_irqchip_action_ret(v, ...)		\
+	__kvm_irqchip_action_ret((v)->kvm, __VA_ARGS__)
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 76cce0db63a7..6b8f0518c074 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -12,6 +12,9 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+static struct kvm_irqchip_flow vgic_irqchip_flow = {
+};
+
 /*
  * Initialization rules: there are multiple stages to the vgic
  * initialization, both for the distributor and the CPU interfaces.  The basic
@@ -98,6 +101,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	kvm->arch.irqchip_flow = vgic_irqchip_flow;
+
 	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5275FC433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2F7C61601
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2F7C61601
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4617F4B81B;
	Mon, 10 May 2021 09:49:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NUPAx5tD9g33; Mon, 10 May 2021 09:49:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F114B833;
	Mon, 10 May 2021 09:49:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF64F4B45B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MJIOGki2e-Zi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 09:49:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9811A4B4EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 66C08610F7;
 Mon, 10 May 2021 13:49:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg6Hh-000Rol-NE; Mon, 10 May 2021 14:49:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 4/9] KVM: arm64: vgic: Let an interrupt controller
 advertise lack of HW deactivation
Date: Mon, 10 May 2021 14:48:19 +0100
Message-Id: <20210510134824.1910399-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510134824.1910399-1-maz@kernel.org>
References: <20210510134824.1910399-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Hector Martin <marcan@marcan.st>
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

The vGIC, as architected by ARM, allows a virtual interrupt to
trigger the deactivation of a physical interrupt. This allows
the following interrupt to be delivered without requiring an exit.

However, some implementations have choosen not to implement this,
meaning that we will need some unsavoury workarounds to deal with this.

On detecting such a case, taint the kernel and spit a nastygram.
We'll deal with this in later patches.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 10 ++++++++++
 include/kvm/arm_vgic.h                |  3 +++
 include/linux/irqchip/arm-vgic-info.h |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 9fd23f32aa54..5b06a9970a57 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -524,6 +524,16 @@ int kvm_vgic_hyp_init(void)
 	if (!gic_kvm_info)
 		return -ENODEV;
 
+	/*
+	 * If we get one of these oddball non-GICs, taint the kernel,
+	 * as we have no idea of how they *really* behave.
+	 */
+	if (gic_kvm_info->no_hw_deactivation) {
+		kvm_info("Non-architectural vgic, tainting kernel\n");
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+		kvm_vgic_global_state.no_hw_deactivation = true;
+	}
+
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ec621180ef09..e45b26e8d479 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -72,6 +72,9 @@ struct vgic_global {
 	bool			has_gicv4;
 	bool			has_gicv4_1;
 
+	/* Pseudo GICv3 from outer space */
+	bool			no_hw_deactivation;
+
 	/* GIC system register CPU interface */
 	struct static_key_false gicv3_cpuif;
 
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index 0319636be928..d39d0b591c5a 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -30,6 +30,8 @@ struct gic_kvm_info {
 	bool		has_v4;
 	/* rvpeid support */
 	bool		has_v4_1;
+	/* Deactivation impared, subpar stuff */
+	bool		no_hw_deactivation;
 };
 
 #ifdef CONFIG_KVM
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

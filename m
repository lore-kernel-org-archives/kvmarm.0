Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4584C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 16:23:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31E23619B8
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 16:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31E23619B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDAE4B3D9;
	Tue, 23 Mar 2021 12:23:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rNRFwbigD4rR; Tue, 23 Mar 2021 12:23:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC7C4B3D3;
	Tue, 23 Mar 2021 12:23:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 079924B39C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 12:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ohOMFwD1xn26 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 12:23:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29A694B39A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 12:23:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B937619B8;
 Tue, 23 Mar 2021 16:23:08 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lOjoA-003LOd-7E; Tue, 23 Mar 2021 16:23:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility detection
Date: Tue, 23 Mar 2021 16:23:01 +0000
Message-Id: <20210323162301.2049595-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ardb@kernel.org, kernel-team@android.com,
 shameerali.kolothum.thodi@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

In order to detect whether a GICv3 CPU interface is MMIO capable,
we switch ICC_SRE_EL1.SRE to 0 and check whether it sticks.

However, this is only possible if *ALL* of the HCR_EL2 interrupt
overrides are set, and the CPU is perfectly allowed to ignore
the write to ICC_SRE_EL1 otherwise. This leads KVM to pretend
that a whole bunch of ARMv8.0 CPUs aren't MMIO-capable, and
breaks VMs that should work correctly otherwise.

Fix this by setting IMO/FMO/IMO before touching ICC_SRE_EL1,
and clear them afterwards. This allows us to reliably detect
the CPU interface capabilities.

Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Fixes: 9739f6ef053f ("KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index ee3682b9873c..39f8f7f9227c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -429,6 +429,13 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe())
 		flags = local_daif_save();
 
+	/*
+	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
+	 * that to be able to set ICC_SRE_EL1.SRE to 0, all the
+	 * interrupt overrides must be set. You've got to love this.
+	 */
+	sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
+	isb();
 	write_gicreg(0, ICC_SRE_EL1);
 	isb();
 
@@ -436,6 +443,8 @@ u64 __vgic_v3_get_gic_config(void)
 
 	write_gicreg(sre, ICC_SRE_EL1);
 	isb();
+	sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
+	isb();
 
 	if (has_vhe())
 		local_daif_restore(flags);
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

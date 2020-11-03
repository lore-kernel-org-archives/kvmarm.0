Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5430FC388F7
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 17:15:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1D9320E65
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 17:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/Ez577t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1D9320E65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3399B4B2B9;
	Tue,  3 Nov 2020 12:15:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X4oUVecGwtTA; Tue,  3 Nov 2020 12:15:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02764B485;
	Tue,  3 Nov 2020 12:14:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC814B2B9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 12:14:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8owUIQMXRaXs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 12:14:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF4904B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 12:14:53 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EE5A922226;
 Tue,  3 Nov 2020 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604423693;
 bh=5YjynP5jFc3/95/xayd/ezJp4+w6kLJdVUXe1lwjFPc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Y/Ez577ti1olOYhq/bifZKZ7kL66R2Dsi8XS9Yc72I3URa2YDzTAf57RTt78lQ+oV
 QKjC8jMcH17LOnX2f3/agH9kk9vNbXh1l2CEI28o8KjMdUsvkiJpMN7iHELkDz1xQq
 iK20ICkWNH1v2Ou4d/xOP61ppuWvHW53WL9Dt4yY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZztT-007CyW-8o; Tue, 03 Nov 2020 17:14:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] KVM: arm64: Rename access_amu() to undef_access()
Date: Tue,  3 Nov 2020 17:14:44 +0000
Message-Id: <20201103171445.271195-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103171445.271195-1-maz@kernel.org>
References: <20201103171445.271195-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

The only thing that access_amu() does is to inject an UNDEF exception,
so let's rename it to the clearer undef_access(). We'll reuse that
for some other system registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 61789027b92b..fafaa81bf1f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
-static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-			     const struct sys_reg_desc *r)
+static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
 {
 	kvm_inject_undefined(vcpu);
 
@@ -1047,10 +1047,10 @@ static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 }
 
 /* Macro to expand the AMU counter and type registers*/
-#define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), access_amu }
-#define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), access_amu }
-#define AMU_AMEVCNTR1_EL0(n) { SYS_DESC(SYS_AMEVCNTR1_EL0(n)), access_amu }
-#define AMU_AMEVTYPER1_EL0(n) { SYS_DESC(SYS_AMEVTYPER1_EL0(n)), access_amu }
+#define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), undef_access }
+#define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), undef_access }
+#define AMU_AMEVCNTR1_EL0(n) { SYS_DESC(SYS_AMEVCNTR1_EL0(n)), undef_access }
+#define AMU_AMEVTYPER1_EL0(n) { SYS_DESC(SYS_AMEVTYPER1_EL0(n)), undef_access }
 
 static bool trap_ptrauth(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
@@ -1679,14 +1679,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 
-	{ SYS_DESC(SYS_AMCR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCFGR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCGCR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMUSERENR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENCLR0_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENSET0_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENCLR1_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENSET1_EL0), access_amu },
+	{ SYS_DESC(SYS_AMCR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCFGR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCGCR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMUSERENR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENCLR0_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENSET0_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENCLR1_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENSET1_EL0), undef_access },
 	AMU_AMEVCNTR0_EL0(0),
 	AMU_AMEVCNTR0_EL0(1),
 	AMU_AMEVCNTR0_EL0(2),
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

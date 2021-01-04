Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952E4C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 13:50:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 466DE207BC
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 13:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 466DE207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EECB14B2C6;
	Mon,  4 Jan 2021 08:50:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4FU6PQ1-Z0un; Mon,  4 Jan 2021 08:50:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A12FB4B262;
	Mon,  4 Jan 2021 08:50:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A334B2B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 08:50:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNra3jLBApuA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 08:50:49 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D2EC4B248
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 08:50:46 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7C29A21D93;
 Mon,  4 Jan 2021 13:50:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwQFv-005E24-Q1; Mon, 04 Jan 2021 13:50:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 09/17] arm64: cpufeature: Add global feature override
 facility
Date: Mon,  4 Jan 2021 13:50:03 +0000
Message-Id: <20210104135011.2063104-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104135011.2063104-1-maz@kernel.org>
References: <20210104135011.2063104-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, dbrazdil@google.com, alexandru.elisei@arm.com,
 ardb@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

Add a facility to globally override a feature, no matter what
the HW says. Yes, this is dangerous.

Nothing uses this yet, so we are pretty safe. For now.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  2 ++
 arch/arm64/kernel/cpufeature.c      | 26 +++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9a555809b89c..465d2cb63bfc 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -75,6 +75,8 @@ struct arm64_ftr_reg {
 	u64				sys_val;
 	u64				user_val;
 	const struct arm64_ftr_bits	*ftr_bits;
+	u64				*override_val;
+	u64				*override_mask;
 };
 
 extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7ffb5f1d8b68..2dbfc0096b0d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -544,13 +544,17 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 	ARM64_FTR_END,
 };
 
-#define ARM64_FTR_REG(id, table) {		\
-	.sys_id = id,				\
-	.reg = 	&(struct arm64_ftr_reg){	\
-		.name = #id,			\
-		.ftr_bits = &((table)[0]),	\
+#define ARM64_FTR_REG_OVERRIDE(id, table, v, m) {		\
+		.sys_id = id,					\
+		.reg = 	&(struct arm64_ftr_reg){		\
+			.name = #id,				\
+			.ftr_bits = &((table)[0]),		\
+			.override_val = v,			\
+			.override_mask = m,			\
 	}}
 
+#define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, NULL, NULL)
+
 static const struct __ftr_reg_entry {
 	u32			sys_id;
 	struct arm64_ftr_reg 	*reg;
@@ -786,6 +790,18 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 
 	val &= valid_mask;
 
+	if (reg->override_mask && reg->override_val) {
+		u64 override = val;
+		override &= ~*reg->override_mask;
+		override |= (*reg->override_val & *reg->override_mask);
+
+		if (val != override)
+			pr_warn("%s: forced from %016llx to %016llx\n",
+				reg->name, val, override);
+
+		val = override;
+	}
+
 	reg->sys_val = val;
 	reg->strict_mask = strict_mask;
 	reg->user_mask = user_mask;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

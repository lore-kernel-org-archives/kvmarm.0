Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050CAC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:28:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACDFE22515
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:28:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACDFE22515
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5904B25C;
	Mon, 11 Jan 2021 08:28:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BzNc0xyLiI5N; Mon, 11 Jan 2021 08:28:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6C64B324;
	Mon, 11 Jan 2021 08:28:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D8B4B292
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:28:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id atPjfveaJO0X for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 08:28:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D21AC4B352
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:28:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1307C223E8;
 Mon, 11 Jan 2021 13:28:29 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyxFD-006gPD-CK; Mon, 11 Jan 2021 13:28:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
Date: Mon, 11 Jan 2021 13:27:59 +0000
Message-Id: <20210111132811.2455113-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111132811.2455113-1-maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
index e99eddec0a46..492321054bd5 100644
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

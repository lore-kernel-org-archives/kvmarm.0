Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4956C2BB1D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5922320644
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHm16xP1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5922320644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11ECF4B25E;
	Tue, 14 Apr 2020 17:31:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VsZCZzcRuP5X; Tue, 14 Apr 2020 17:31:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E454B272;
	Tue, 14 Apr 2020 17:31:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9974B260
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ayVFtEjCjog for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 17:31:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED0D84B218
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:36 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4A29E2076B;
 Tue, 14 Apr 2020 21:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586899896;
 bh=GfhtXnhbWjI+0uvJbr13btlA5xQXBNo799Ku7twdf1s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hHm16xP1mJuxof7IgkpgHhk8uVL3LU/2o2JHpXaixP3VBb3Lsv/G35SjilgjAjzao
 GW93ORXQVNDBKESRmxoSLozvoZRy/tOb0CMgm4scLDnH9oU8Jugsi3aW0ofFL2vOKy
 MNjUkqBphASqZEuho+BI5vS9ljrrZpZK+mFCgWNM=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/8] arm64: cpufeature: Factor out checking of AArch32 features
Date: Tue, 14 Apr 2020 22:31:11 +0100
Message-Id: <20200414213114.2378-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414213114.2378-1-will@kernel.org>
References: <20200414213114.2378-1-will@kernel.org>
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

update_cpu_features() is pretty large, so split out the checking of the
AArch32 features into a separate function and call it after checking the
AArch64 features.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 108 +++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7dfcdd9e75c1..32828a77acc3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -715,6 +715,65 @@ static int check_update_ftr_reg(u32 sys_id, int cpu, u64 val, u64 boot)
 	return 1;
 }
 
+static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
+				     struct cpuinfo_arm64 *boot)
+{
+	int taint = 0;
+	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	/*
+	 * If we don't have AArch32 at all then skip the checks entirely
+	 * as the register values may be UNKNOWN and we're not going to be
+	 * using them for anything.
+	 */
+	if (!id_aa64pfr0_32bit_el0(pfr0))
+		return taint;
+
+	taint |= check_update_ftr_reg(SYS_ID_DFR0_EL1, cpu,
+				      info->reg_id_dfr0, boot->reg_id_dfr0);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR0_EL1, cpu,
+				      info->reg_id_isar0, boot->reg_id_isar0);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR1_EL1, cpu,
+				      info->reg_id_isar1, boot->reg_id_isar1);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR2_EL1, cpu,
+				      info->reg_id_isar2, boot->reg_id_isar2);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR3_EL1, cpu,
+				      info->reg_id_isar3, boot->reg_id_isar3);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR4_EL1, cpu,
+				      info->reg_id_isar4, boot->reg_id_isar4);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR5_EL1, cpu,
+				      info->reg_id_isar5, boot->reg_id_isar5);
+	taint |= check_update_ftr_reg(SYS_ID_ISAR6_EL1, cpu,
+				      info->reg_id_isar6, boot->reg_id_isar6);
+
+	/*
+	 * Regardless of the value of the AuxReg field, the AIFSR, ADFSR, and
+	 * ACTLR formats could differ across CPUs and therefore would have to
+	 * be trapped for virtualization anyway.
+	 */
+	taint |= check_update_ftr_reg(SYS_ID_MMFR0_EL1, cpu,
+				      info->reg_id_mmfr0, boot->reg_id_mmfr0);
+	taint |= check_update_ftr_reg(SYS_ID_MMFR1_EL1, cpu,
+				      info->reg_id_mmfr1, boot->reg_id_mmfr1);
+	taint |= check_update_ftr_reg(SYS_ID_MMFR2_EL1, cpu,
+				      info->reg_id_mmfr2, boot->reg_id_mmfr2);
+	taint |= check_update_ftr_reg(SYS_ID_MMFR3_EL1, cpu,
+				      info->reg_id_mmfr3, boot->reg_id_mmfr3);
+	taint |= check_update_ftr_reg(SYS_ID_PFR0_EL1, cpu,
+				      info->reg_id_pfr0, boot->reg_id_pfr0);
+	taint |= check_update_ftr_reg(SYS_ID_PFR1_EL1, cpu,
+				      info->reg_id_pfr1, boot->reg_id_pfr1);
+	taint |= check_update_ftr_reg(SYS_MVFR0_EL1, cpu,
+				      info->reg_mvfr0, boot->reg_mvfr0);
+	taint |= check_update_ftr_reg(SYS_MVFR1_EL1, cpu,
+				      info->reg_mvfr1, boot->reg_mvfr1);
+	taint |= check_update_ftr_reg(SYS_MVFR2_EL1, cpu,
+				      info->reg_mvfr2, boot->reg_mvfr2);
+
+	return taint;
+}
+
+
 /*
  * Update system wide CPU feature registers with the values from a
  * non-boot CPU. Also performs SANITY checks to make sure that there
@@ -788,53 +847,6 @@ void update_cpu_features(int cpu,
 	taint |= check_update_ftr_reg(SYS_ID_AA64ZFR0_EL1, cpu,
 				      info->reg_id_aa64zfr0, boot->reg_id_aa64zfr0);
 
-	/*
-	 * If we have AArch32, we care about 32-bit features for compat.
-	 * If the system doesn't support AArch32, don't update them.
-	 */
-	if (id_aa64pfr0_32bit_el0(read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1))) {
-		taint |= check_update_ftr_reg(SYS_ID_DFR0_EL1, cpu,
-					info->reg_id_dfr0, boot->reg_id_dfr0);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR0_EL1, cpu,
-					info->reg_id_isar0, boot->reg_id_isar0);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR1_EL1, cpu,
-					info->reg_id_isar1, boot->reg_id_isar1);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR2_EL1, cpu,
-					info->reg_id_isar2, boot->reg_id_isar2);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR3_EL1, cpu,
-					info->reg_id_isar3, boot->reg_id_isar3);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR4_EL1, cpu,
-					info->reg_id_isar4, boot->reg_id_isar4);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR5_EL1, cpu,
-					info->reg_id_isar5, boot->reg_id_isar5);
-		taint |= check_update_ftr_reg(SYS_ID_ISAR6_EL1, cpu,
-					info->reg_id_isar6, boot->reg_id_isar6);
-
-		/*
-		 * Regardless of the value of the AuxReg field, the AIFSR, ADFSR, and
-		 * ACTLR formats could differ across CPUs and therefore would have to
-		 * be trapped for virtualization anyway.
-		 */
-		taint |= check_update_ftr_reg(SYS_ID_MMFR0_EL1, cpu,
-					info->reg_id_mmfr0, boot->reg_id_mmfr0);
-		taint |= check_update_ftr_reg(SYS_ID_MMFR1_EL1, cpu,
-					info->reg_id_mmfr1, boot->reg_id_mmfr1);
-		taint |= check_update_ftr_reg(SYS_ID_MMFR2_EL1, cpu,
-					info->reg_id_mmfr2, boot->reg_id_mmfr2);
-		taint |= check_update_ftr_reg(SYS_ID_MMFR3_EL1, cpu,
-					info->reg_id_mmfr3, boot->reg_id_mmfr3);
-		taint |= check_update_ftr_reg(SYS_ID_PFR0_EL1, cpu,
-					info->reg_id_pfr0, boot->reg_id_pfr0);
-		taint |= check_update_ftr_reg(SYS_ID_PFR1_EL1, cpu,
-					info->reg_id_pfr1, boot->reg_id_pfr1);
-		taint |= check_update_ftr_reg(SYS_MVFR0_EL1, cpu,
-					info->reg_mvfr0, boot->reg_mvfr0);
-		taint |= check_update_ftr_reg(SYS_MVFR1_EL1, cpu,
-					info->reg_mvfr1, boot->reg_mvfr1);
-		taint |= check_update_ftr_reg(SYS_MVFR2_EL1, cpu,
-					info->reg_mvfr2, boot->reg_mvfr2);
-	}
-
 	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
 		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
 					info->reg_zcr, boot->reg_zcr);
@@ -845,6 +857,8 @@ void update_cpu_features(int cpu,
 			sve_update_vq_map();
 	}
 
+	taint |= update_32bit_cpu_features(cpu, info, boot);
+
 	/*
 	 * Mismatched CPU features are a recipe for disaster. Don't even
 	 * pretend to support them.
-- 
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0932FC54FCC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 14:29:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B527F20736
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 14:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="alIzc6X4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B527F20736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E1964B17C;
	Tue, 21 Apr 2020 10:29:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9yocXVwsYbml; Tue, 21 Apr 2020 10:29:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239214B189;
	Tue, 21 Apr 2020 10:29:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C90B4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 10:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mf35MhUdmCWJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 10:29:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A2754B0D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 10:29:43 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7DA0F2071C;
 Tue, 21 Apr 2020 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587479382;
 bh=8Oyrol7qvIM/UF0b+U1DBGmfmyKVdmtIZeJLwupvoTY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=alIzc6X4cji+C0EuciJTgrC0hul13+KTEuTvXvi6inXEUNSnGg2XYEGop/f/XPdG1
 47E46CpTHxC/IkFVxReR59fHwf4q6q7gRj4U2l2NbAnla/R4TDJSmSirtbB1S2bG6D
 mmGUetf71DqxW34otwpC39CuLQa2gLPo0nkIpm8I=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 6/8] arm64: cpufeature: Relax AArch32 system checks if EL1
 is 64-bit only
Date: Tue, 21 Apr 2020 15:29:20 +0100
Message-Id: <20200421142922.18950-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200421142922.18950-1-will@kernel.org>
References: <20200421142922.18950-1-will@kernel.org>
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

If AArch32 is not supported at EL1, the AArch32 feature register fields
no longer advertise support for some system features:

  * ISAR4.SMC
  * PFR1.{Virt_frac, Sec_frac, Virtualization, Security, ProgMod}

In which case, we don't need to emit "SANITY CHECK" failures for all of
them.

Add logic to relax the strictness of individual feature register fields
at runtime and use this for the fields above if 32-bit EL1 is not
supported.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  7 ++++++
 arch/arm64/kernel/cpufeature.c      | 33 ++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index afe08251ff95..f5c4672e498b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -551,6 +551,13 @@ static inline bool id_aa64mmfr0_mixed_endian_el0(u64 mmfr0)
 		cpuid_feature_extract_unsigned_field(mmfr0, ID_AA64MMFR0_BIGENDEL0_SHIFT) == 0x1;
 }
 
+static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
+
+	return val == ID_AA64PFR0_EL1_32BIT_64BIT;
+}
+
 static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6892b2440676..7e0dbe2a2f2d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -715,6 +715,25 @@ static int check_update_ftr_reg(u32 sys_id, int cpu, u64 val, u64 boot)
 	return 1;
 }
 
+static void relax_cpu_ftr_reg(u32 sys_id, int field)
+{
+	const struct arm64_ftr_bits *ftrp;
+	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(sys_id);
+
+	if (WARN_ON(!regp))
+		return;
+
+	for (ftrp = regp->ftr_bits; ftrp->width; ftrp++) {
+		if (ftrp->shift == field) {
+			regp->strict_mask &= ~arm64_ftr_mask(ftrp);
+			break;
+		}
+	}
+
+	/* Bogus field? */
+	WARN_ON(!ftrp->width);
+}
+
 static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
 				     struct cpuinfo_arm64 *boot)
 {
@@ -729,6 +748,19 @@ static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
 	if (!id_aa64pfr0_32bit_el0(pfr0))
 		return taint;
 
+	/*
+	 * If we don't have AArch32 at EL1, then relax the strictness of
+	 * EL1-dependent register fields to avoid spurious sanity check fails.
+	 */
+	if (!id_aa64pfr0_32bit_el1(pfr0)) {
+		relax_cpu_ftr_reg(SYS_ID_ISAR4_EL1, ID_ISAR4_SMC_SHIFT);
+		relax_cpu_ftr_reg(SYS_ID_PFR1_EL1, ID_PFR1_VIRT_FRAC_SHIFT);
+		relax_cpu_ftr_reg(SYS_ID_PFR1_EL1, ID_PFR1_SEC_FRAC_SHIFT);
+		relax_cpu_ftr_reg(SYS_ID_PFR1_EL1, ID_PFR1_VIRTUALIZATION_SHIFT);
+		relax_cpu_ftr_reg(SYS_ID_PFR1_EL1, ID_PFR1_SECURITY_SHIFT);
+		relax_cpu_ftr_reg(SYS_ID_PFR1_EL1, ID_PFR1_PROGMOD_SHIFT);
+	}
+
 	taint |= check_update_ftr_reg(SYS_ID_DFR0_EL1, cpu,
 				      info->reg_id_dfr0, boot->reg_id_dfr0);
 	taint |= check_update_ftr_reg(SYS_ID_ISAR0_EL1, cpu,
@@ -773,7 +805,6 @@ static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
 	return taint;
 }
 
-
 /*
  * Update system wide CPU feature registers with the values from a
  * non-boot CPU. Also performs SANITY checks to make sure that there
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

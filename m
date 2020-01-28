Return-Path: <SRS0=H5Sr=3R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985E3C33CB2
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 12:39:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CB6A2468E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 12:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB6A2468E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F2A4AC65;
	Tue, 28 Jan 2020 07:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CwjFDQmSNPah; Tue, 28 Jan 2020 07:39:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C594AC77;
	Tue, 28 Jan 2020 07:39:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A918B4A98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 07:39:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oEn26p6K4tAg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jan 2020 07:39:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20CBB4A957
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 07:39:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA79F1045;
 Tue, 28 Jan 2020 04:39:35 -0800 (PST)
Received: from p8cg001049571a15.arm.com (unknown [10.163.1.151])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5ED7C3F52E;
 Tue, 28 Jan 2020 04:39:32 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/6] arm64/cpufeature: Introduce ID_PFR2 CPU register
Date: Tue, 28 Jan 2020 18:09:04 +0530
Message-Id: <1580215149-21492-2-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580215149-21492-1-git-send-email-anshuman.khandual@arm.com>
References: <1580215149-21492-1-git-send-email-anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

This adds basic building blocks required for ID_PFR2 CPU register which
provides information about the AArch32 programmers model which must be
interpreted along with ID_PFR0 and ID_PFR1 CPU registers.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/cpu.h    |  1 +
 arch/arm64/include/asm/sysreg.h |  4 ++++
 arch/arm64/kernel/cpufeature.c  | 11 +++++++++++
 arch/arm64/kernel/cpuinfo.c     |  1 +
 arch/arm64/kvm/sys_regs.c       |  2 +-
 5 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index b4a40535a3d8..464e828a994d 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -46,6 +46,7 @@ struct cpuinfo_arm64 {
 	u32		reg_id_mmfr3;
 	u32		reg_id_pfr0;
 	u32		reg_id_pfr1;
+	u32		reg_id_pfr2;
 
 	u32		reg_mvfr0;
 	u32		reg_mvfr1;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b91570ff9db1..054aab7ebf1b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -151,6 +151,7 @@
 #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
 #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
 #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
+#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
 
 #define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
 #define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
@@ -717,6 +718,9 @@
 #define ID_ISAR6_DP_SHIFT		4
 #define ID_ISAR6_JSCVT_SHIFT		0
 
+#define ID_PFR2_SSBS_SHIFT		4
+#define ID_PFR2_CSV3_SHIFT		0
+
 #define MVFR0_FPROUND_SHIFT		28
 #define MVFR0_FPSHVEC_SHIFT		24
 #define MVFR0_FPSQRT_SHIFT		20
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0b6715625cf6..c1e837fc8f97 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -348,6 +348,12 @@ static const struct arm64_ftr_bits ftr_id_pfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_pfr2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_PFR2_SSBS_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_PFR2_CSV3_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 28, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 24, 4, 0xf),	/* PerfMon */
@@ -429,6 +435,7 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_MVFR0_EL1, ftr_generic_32bits),
 	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_generic_32bits),
 	ARM64_FTR_REG(SYS_MVFR2_EL1, ftr_mvfr2),
+	ARM64_FTR_REG(SYS_ID_PFR2_EL1, ftr_id_pfr2),
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
@@ -635,6 +642,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_ID_MMFR3_EL1, info->reg_id_mmfr3);
 		init_cpu_ftr_reg(SYS_ID_PFR0_EL1, info->reg_id_pfr0);
 		init_cpu_ftr_reg(SYS_ID_PFR1_EL1, info->reg_id_pfr1);
+		init_cpu_ftr_reg(SYS_ID_PFR2_EL1, info->reg_id_pfr2);
 		init_cpu_ftr_reg(SYS_MVFR0_EL1, info->reg_mvfr0);
 		init_cpu_ftr_reg(SYS_MVFR1_EL1, info->reg_mvfr1);
 		init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
@@ -802,6 +810,8 @@ void update_cpu_features(int cpu,
 					info->reg_id_pfr0, boot->reg_id_pfr0);
 		taint |= check_update_ftr_reg(SYS_ID_PFR1_EL1, cpu,
 					info->reg_id_pfr1, boot->reg_id_pfr1);
+		taint |= check_update_ftr_reg(SYS_ID_PFR2_EL1, cpu,
+					info->reg_id_pfr2, boot->reg_id_pfr2);
 		taint |= check_update_ftr_reg(SYS_MVFR0_EL1, cpu,
 					info->reg_mvfr0, boot->reg_mvfr0);
 		taint |= check_update_ftr_reg(SYS_MVFR1_EL1, cpu,
@@ -851,6 +861,7 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
 	switch (sys_id) {
 	read_sysreg_case(SYS_ID_PFR0_EL1);
 	read_sysreg_case(SYS_ID_PFR1_EL1);
+	read_sysreg_case(SYS_ID_PFR2_EL1);
 	read_sysreg_case(SYS_ID_DFR0_EL1);
 	read_sysreg_case(SYS_ID_MMFR0_EL1);
 	read_sysreg_case(SYS_ID_MMFR1_EL1);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 86136075ae41..cb79b083f97f 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -375,6 +375,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 		info->reg_id_mmfr3 = read_cpuid(ID_MMFR3_EL1);
 		info->reg_id_pfr0 = read_cpuid(ID_PFR0_EL1);
 		info->reg_id_pfr1 = read_cpuid(ID_PFR1_EL1);
+		info->reg_id_pfr2 = read_cpuid(ID_PFR2_EL1);
 
 		info->reg_mvfr0 = read_cpuid(MVFR0_EL1);
 		info->reg_mvfr1 = read_cpuid(MVFR1_EL1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e909b117f0c..e266219a35ff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1431,7 +1431,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(MVFR1_EL1),
 	ID_SANITISED(MVFR2_EL1),
 	ID_UNALLOCATED(3,3),
-	ID_UNALLOCATED(3,4),
+	ID_SANITISED(ID_PFR2_EL1),
 	ID_UNALLOCATED(3,5),
 	ID_UNALLOCATED(3,6),
 	ID_UNALLOCATED(3,7),
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

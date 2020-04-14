Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F5AC2BBC7
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:49:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 929DB2076A
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 929DB2076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4BA4B200;
	Tue, 14 Apr 2020 05:49:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nWvctVXBKPd7; Tue, 14 Apr 2020 05:49:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D946D4B142;
	Tue, 14 Apr 2020 05:49:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3B04B156
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 05:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lI7sQTQ0ZuXi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 05:49:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9824B199
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 05:49:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EF8C1FB;
 Tue, 14 Apr 2020 02:49:05 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.1.49])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85D163F6C4;
 Tue, 14 Apr 2020 02:49:02 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 05/16] arm64/cpufeature: Introduce ID_DFR1 CPU register
Date: Tue, 14 Apr 2020 15:18:19 +0530
Message-Id: <1586857710-17154-6-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1586857710-17154-1-git-send-email-anshuman.khandual@arm.com>
References: <1586857710-17154-1-git-send-email-anshuman.khandual@arm.com>
Cc: catalin.marinas@arm.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, maz@kernel.org, will@kernel.org,
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

This adds basic building blocks required for ID_DFR1 CPU register which
provides top level information about the debug system in AArch32 state.
This is added per ARM DDI 0487F.a specification.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/cpu.h    |  1 +
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
 arch/arm64/kernel/cpuinfo.c     |  1 +
 arch/arm64/kvm/sys_regs.c       |  2 +-
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 464e828a994d..d9a78bdec409 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -33,6 +33,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64zfr0;
 
 	u32		reg_id_dfr0;
+	u32		reg_id_dfr1;
 	u32		reg_id_isar0;
 	u32		reg_id_isar1;
 	u32		reg_id_isar2;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ed49ae80f6e8..e0b3b5a33df3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -152,6 +152,7 @@
 #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
 #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
 #define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
+#define SYS_ID_DFR1_EL1			sys_reg(3, 0, 0, 3, 5)
 
 #define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
 #define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
@@ -751,6 +752,8 @@
 
 #define ID_DFR0_PERFMON_8_1		0x4
 
+#define ID_DFR1_MTPMU_SHIFT		0
+
 #define ID_ISAR0_DIVIDE_SHIFT		24
 #define ID_ISAR0_DEBUG_SHIFT		20
 #define ID_ISAR0_COPROC_SHIFT		16
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7fff9033fd6b..fafbab56bb8f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -378,6 +378,11 @@ static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_dfr1[] = {
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR1_MTPMU_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_zcr[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
 		ZCR_ELx_LEN_SHIFT, ZCR_ELx_LEN_SIZE, 0),	/* LEN */
@@ -448,6 +453,7 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_MVFR1_EL1, ftr_generic_32bits),
 	ARM64_FTR_REG(SYS_MVFR2_EL1, ftr_mvfr2),
 	ARM64_FTR_REG(SYS_ID_PFR2_EL1, ftr_id_pfr2),
+	ARM64_FTR_REG(SYS_ID_DFR1_EL1, ftr_id_dfr1),
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
@@ -641,6 +647,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
 		init_cpu_ftr_reg(SYS_ID_DFR0_EL1, info->reg_id_dfr0);
+		init_cpu_ftr_reg(SYS_ID_DFR1_EL1, info->reg_id_dfr1);
 		init_cpu_ftr_reg(SYS_ID_ISAR0_EL1, info->reg_id_isar0);
 		init_cpu_ftr_reg(SYS_ID_ISAR1_EL1, info->reg_id_isar1);
 		init_cpu_ftr_reg(SYS_ID_ISAR2_EL1, info->reg_id_isar2);
@@ -790,6 +797,8 @@ void update_cpu_features(int cpu,
 
 		taint |= check_update_ftr_reg(SYS_ID_DFR0_EL1, cpu,
 					info->reg_id_dfr0, boot->reg_id_dfr0);
+		taint |= check_update_ftr_reg(SYS_ID_DFR1_EL1, cpu,
+					info->reg_id_dfr1, boot->reg_id_dfr1);
 		taint |= check_update_ftr_reg(SYS_ID_ISAR0_EL1, cpu,
 					info->reg_id_isar0, boot->reg_id_isar0);
 		taint |= check_update_ftr_reg(SYS_ID_ISAR1_EL1, cpu,
@@ -875,6 +884,7 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_PFR1_EL1);
 	read_sysreg_case(SYS_ID_PFR2_EL1);
 	read_sysreg_case(SYS_ID_DFR0_EL1);
+	read_sysreg_case(SYS_ID_DFR1_EL1);
 	read_sysreg_case(SYS_ID_MMFR0_EL1);
 	read_sysreg_case(SYS_ID_MMFR1_EL1);
 	read_sysreg_case(SYS_ID_MMFR2_EL1);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index cb79b083f97f..50a281703d9d 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -362,6 +362,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	/* Update the 32bit ID registers only if AArch32 is implemented */
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
 		info->reg_id_dfr0 = read_cpuid(ID_DFR0_EL1);
+		info->reg_id_dfr1 = read_cpuid(ID_DFR1_EL1);
 		info->reg_id_isar0 = read_cpuid(ID_ISAR0_EL1);
 		info->reg_id_isar1 = read_cpuid(ID_ISAR1_EL1);
 		info->reg_id_isar2 = read_cpuid(ID_ISAR2_EL1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b784b156edb3..c78aa15aaac8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1457,7 +1457,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(MVFR2_EL1),
 	ID_UNALLOCATED(3,3),
 	ID_SANITISED(ID_PFR2_EL1),
-	ID_UNALLOCATED(3,5),
+	ID_SANITISED(ID_DFR1_EL1),
 	ID_UNALLOCATED(3,6),
 	ID_UNALLOCATED(3,7),
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

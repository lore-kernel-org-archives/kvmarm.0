Return-Path: <SRS0=SKDP=2A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E3C00454
	for <kvmarm@archiver.kernel.org>; Tue, 10 Dec 2019 12:02:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 717AC2077B
	for <kvmarm@archiver.kernel.org>; Tue, 10 Dec 2019 12:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 717AC2077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5C34AF46;
	Tue, 10 Dec 2019 07:02:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vqeY1VLE7sIW; Tue, 10 Dec 2019 07:01:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D50F4AF3A;
	Tue, 10 Dec 2019 07:01:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0DC64AED9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Dec 2019 07:01:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lyQrKAOtC7dO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Dec 2019 07:01:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08D24AF37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Dec 2019 07:01:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A006A113E;
 Tue, 10 Dec 2019 04:01:55 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FF063F6CF;
 Tue, 10 Dec 2019 04:01:54 -0800 (PST)
From: Andrew Murray <andrew.murray@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 2/3] KVM: arm64: limit PMU version to ARMv8.4
Date: Tue, 10 Dec 2019 12:01:45 +0000
Message-Id: <20191210120146.2942-3-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191210120146.2942-1-andrew.murray@arm.com>
References: <20191210120146.2942-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

ARMv8.5-PMU introduces 64-bit event counters, however KVM doesn't yet
support this. Let's trap the Debug Feature Registers in order to limit
PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.4.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  4 ++++
 arch/arm64/kvm/sys_regs.c       | 36 +++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6e919fafb43d..1b74f275a115 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -672,6 +672,10 @@
 #define ID_AA64DFR0_TRACEVER_SHIFT	4
 #define ID_AA64DFR0_DEBUGVER_SHIFT	0
 
+#define ID_DFR0_PERFMON_SHIFT		24
+
+#define ID_DFR0_EL1_PMUVER_8_4		5
+
 #define ID_ISAR5_RDM_SHIFT		24
 #define ID_ISAR5_CRC32_SHIFT		16
 #define ID_ISAR5_SHA2_SHIFT		12
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46822afc57e0..e0cd95ca41fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -668,6 +668,37 @@ static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
 	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
 }
 
+static bool access_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *rd)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, rd);
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	p->regval = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	p->regval = cpuid_feature_cap_signed_field_width(p->regval,
+						ID_AA64DFR0_PMUVER_SHIFT,
+						4, ID_DFR0_EL1_PMUVER_8_4);
+
+	return p->regval;
+}
+
+static bool access_id_dfr0_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			       const struct sys_reg_desc *rd)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, rd);
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	p->regval = read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
+	p->regval = cpuid_feature_cap_signed_field_width(p->regval,
+						ID_DFR0_PERFMON_SHIFT,
+						4, ID_DFR0_EL1_PMUVER_8_4);
+
+	return p->regval;
+}
+
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
@@ -1409,7 +1440,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	ID_SANITISED(ID_PFR0_EL1),
 	ID_SANITISED(ID_PFR1_EL1),
-	ID_SANITISED(ID_DFR0_EL1),
+	{ SYS_DESC(SYS_ID_DFR0_EL1), access_id_dfr0_el1 },
+
 	ID_HIDDEN(ID_AFR0_EL1),
 	ID_SANITISED(ID_MMFR0_EL1),
 	ID_SANITISED(ID_MMFR1_EL1),
@@ -1448,7 +1480,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	ID_SANITISED(ID_AA64DFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), access_id_aa64dfr0_el1 },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

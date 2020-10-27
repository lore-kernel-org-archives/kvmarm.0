Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8985C388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7519F21D24
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7519F21D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194164B3EA;
	Tue, 27 Oct 2020 13:26:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x4eZwAcjSekO; Tue, 27 Oct 2020 13:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A88944B33B;
	Tue, 27 Oct 2020 13:26:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F50D4B3EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yaTflpP1IsoB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F9F4B3D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9901115AD;
 Tue, 27 Oct 2020 10:26:18 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EE093F719;
 Tue, 27 Oct 2020 10:26:17 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 03/16] KVM: arm64: Hide SPE from guests
Date: Tue, 27 Oct 2020 17:26:52 +0000
Message-Id: <20201027172705.15181-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

When SPE is not implemented, accesses to the SPE registers cause an
undefined exception. KVM advertises the presence of SPE in the
ID_AA64DFR0_EL1 register, but configures MDCR_EL2 to trap accesses to the
registers and injects an undefined exception when that happens.

The architecture doesn't allow trapping access to the PMBIDR_EL1 register,
which means the guest will be able to read it even if SPE is not advertised
in the ID register. However, since it's usually better for a read to
unexpectedly succeed than to cause an exception, let's stop advertising the
presence of SPE to guests to better match how KVM emulates the
architecture.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d9117bc56237..aa776c006a2a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -244,6 +244,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	return REG_HIDDEN_GUEST | REG_HIDDEN_USER;
+}
+
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -1143,6 +1149,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val = cpuid_feature_cap_perfmon_field(val,
 						ID_AA64DFR0_PMUVER_SHIFT,
 						ID_AA64DFR0_PMUVER_8_1);
+		/* Don't advertise SPE to guests */
+		val &= ~(0xfUL << ID_AA64DFR0_PMSVER_SHIFT);
 	} else if (id == SYS_ID_DFR0_EL1) {
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
@@ -1590,6 +1598,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
+	{ SYS_DESC(SYS_PMSCR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSICR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSIRR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSFCR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSEVFR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSLATFR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMSIDR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBLIMITR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBPTR_EL1), .visibility = spe_visibility },
+	{ SYS_DESC(SYS_PMBSR_EL1), .visibility = spe_visibility },
+
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB111C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:33:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC48520716
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC48520716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 655084B0D9;
	Mon, 22 Jun 2020 07:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dbv9vhQd6oJ1; Mon, 22 Jun 2020 07:33:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB3704B0DB;
	Mon, 22 Jun 2020 07:33:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6814B0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eNzp2CNWvutM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 07:33:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 833D64B0DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CC2C106F;
 Mon, 22 Jun 2020 04:33:50 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CD313F71E;
 Mon, 22 Jun 2020 04:33:49 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/5] KVM: arm64: Move ACTLR_EL1 emulation to the sys_reg_descs
 array
Date: Mon, 22 Jun 2020 11:33:15 +0000
Message-Id: <20200622113317.20477-4-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622113317.20477-1-james.morse@arm.com>
References: <20200622113317.20477-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>
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

The only entry in the genericv8_sys_regs arrays is for emulation of
ACTLR_EL1. As all targets emulate this in the same way, move it to
sys_reg_descs[].

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/sys_regs.c            | 28 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs_generic_v8.c | 30 ----------------------------
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fb448bfc83ec..f8407cfa9032 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -242,6 +242,25 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_actlr(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
+
+	if (p->is_aarch32) {
+		if (r->Op2 & 2)
+			p->regval = upper_32_bits(p->regval);
+		else
+			p->regval = lower_32_bits(p->regval);
+	}
+
+	return true;
+}
+
 /*
  * Trap handler for the GICv3 SGI generation system register.
  * Forward the request to the VGIC emulation.
@@ -615,6 +634,12 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
 }
 
+static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 actlr = read_sysreg(actlr_el1);
+	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+}
+
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
@@ -1518,6 +1543,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(7,7),
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1957,6 +1983,8 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 0), Op2( 1), access_ctr },
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 1), access_actlr },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 3), access_actlr },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index a82cc2ccfd44..a7e21e61beea 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -19,44 +19,14 @@
 
 #include "sys_regs.h"
 
-static bool access_actlr(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	if (p->is_write)
-		return ignore_write(vcpu, p);
-
-	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
-
-	if (p->is_aarch32) {
-		if (r->Op2 & 2)
-			p->regval = upper_32_bits(p->regval);
-		else
-			p->regval = lower_32_bits(p->regval);
-	}
-
-	return true;
-}
-
-static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
-}
-
 /*
  * Implementation specific sys-reg registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
  */
 static const struct sys_reg_desc genericv8_sys_regs[] = {
-	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 };
 
 static const struct sys_reg_desc genericv8_cp15_regs[] = {
-	/* ACTLR */
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr },
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
-	  access_actlr },
 };
 
 struct kvm_sys_reg_target_table genericv8_target_table = {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

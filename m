Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82B2C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 16:19:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C61D20787
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 16:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C61D20787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159334B181;
	Tue, 26 May 2020 12:19:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5qUscLQa93p; Tue, 26 May 2020 12:19:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9FD84B167;
	Tue, 26 May 2020 12:19:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6154B118
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 12:19:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPeZrLOZDrkS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 12:19:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 958804B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 12:19:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 559F730E;
 Tue, 26 May 2020 09:19:15 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674C83F52E;
 Tue, 26 May 2020 09:19:14 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] KVM: arm64: Add emulation for 32bit guests accessing
 ACTLR2
Date: Tue, 26 May 2020 16:18:34 +0000
Message-Id: <20200526161834.29165-4-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200526161834.29165-1-james.morse@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
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

ACTLR_EL1 is a 64bit register while the 32bit ACTLR is obviously 32bit.
For 32bit software, the extra bits are accessible via ACTLR2... which
KVM doesn't emulate.

Signed-off-by: James Morse <james.morse@arm.com>
---
I'm not convinced this is endian safe, but it does match what
kvm_inject_undef32() do.

The alternative would be to always read the 64bit value, and generate
the 32bit offets like access_vm_reg() does.

 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/kvm/sys_regs_generic_v8.c | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32c8a675e5a4..5b7538663a8e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -185,6 +185,7 @@ enum vcpu_sysreg {
 #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
 #define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
 #define c1_ACTLR	(ACTLR_EL1 * 2)	/* Auxiliary Control Register */
+#define c1_ACTLR2	(c1_ACTLR + 1)	/* ACTLR top 32 bits */
 #define c1_CPACR	(CPACR_EL1 * 2)	/* Coprocessor Access Control */
 #define c2_TTBR0	(TTBR0_EL1 * 2)	/* Translation Table Base Register 0 */
 #define c2_TTBR0_high	(c2_TTBR0 + 1)	/* TTBR0 top 32 bits */
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 9cb6b4c8355a..ed77bbb48e64 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -30,6 +30,18 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_cp15_actlr(struct kvm_vcpu *vcpu,
+			      struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	p->regval = vcpu_cp15(vcpu, r->reg);
+	return true;
+
+}
+
 static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
@@ -46,7 +58,9 @@ static const struct sys_reg_desc genericv8_sys_regs[] = {
 static const struct sys_reg_desc genericv8_cp15_regs[] = {
 	/* ACTLR */
 	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr },
+	  access_cp15_actlr, NULL, c1_ACTLR },
+	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
+	  access_cp15_actlr, NULL, c1_ACTLR2 },
 };
 
 static struct kvm_sys_reg_target_table genericv8_target_table = {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

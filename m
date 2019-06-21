Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E18FC48BE3
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4EE220673
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4EE220673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9BA4A4FB;
	Fri, 21 Jun 2019 05:40:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6CTE9LzNaiDC; Fri, 21 Jun 2019 05:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 104184A530;
	Fri, 21 Jun 2019 05:40:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 743774A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PhOVz0+yk4tl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:40:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2CAE4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A60AF1478;
 Fri, 21 Jun 2019 02:40:02 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 524333F246;
 Fri, 21 Jun 2019 02:40:01 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 32/59] KVM: arm64: nv: Hide RAS from nested guests
Date: Fri, 21 Jun 2019 10:38:16 +0100
Message-Id: <20190621093843.220980-33-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

We don't want to expose complicated features to guests until we have
a good grasp on the basic CPU emulation. So let's pretend that RAS,
just like SVE, doesn't exist in a nested guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 34f1b79f7856..ec34b81da936 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -577,6 +577,14 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static bool trap_undef(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1601,13 +1609,15 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
+#define ID_SANITISED_FN(name, fn) {		\
 	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
+	.access	= fn,				\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 }
 
+#define ID_SANITISED(name) 	ID_SANITISED_FN(name, access_id_reg)
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -1700,6 +1710,21 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_id_aa64pfr0_el1(struct kvm_vcpu *v,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	u64 val;
+
+	if (!nested_virt_in_use(v) || p->is_write)
+		return access_id_reg(v, p, r);
+
+	val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	p->regval = val & ~(0xf << ID_AA64PFR0_RAS_SHIFT);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1791,7 +1816,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	ID_SANITISED(ID_AA64PFR0_EL1),
+	ID_SANITISED_FN(ID_AA64PFR0_EL1, access_id_aa64pfr0_el1),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -2032,6 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_VBAR_EL2), access_rw, reset_val, VBAR_EL2, 0 },
 	{ SYS_DESC(SYS_RVBAR_EL2), access_rw, reset_val, RVBAR_EL2, 0 },
 	{ SYS_DESC(SYS_RMR_EL2), access_rw, reset_val, RMR_EL2, 0 },
+	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
 	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

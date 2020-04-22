Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169CAC55189
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD16B217BA
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvbCvVFo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD16B217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB2D4B1A4;
	Wed, 22 Apr 2020 08:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZiGSYukAFYcn; Wed, 22 Apr 2020 08:21:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3F74B1A6;
	Wed, 22 Apr 2020 08:21:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 685C64B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eKD3c07RDwLt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:21:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BFA64B0DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9531C221EB;
 Wed, 22 Apr 2020 12:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587558085;
 bh=w1KXX+6GQ7cFF1e8qmsBxy/daj02ed6N9gs8z88iNaA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gvbCvVFoWA8wdN7bYhHfDz+qVy9XmuiwXlaj+4iuz9iRlZTmaExStENHW7BUMfrYZ
 1uQeAjPpmi6SDLikBGz6QBGkX5BPP2ocl+W5FHHJt+YN3NzuaJpgLcXfLnxRDvbA5j
 UoUjWtcfVCUNnCiWoDlCBjiZPNy0jW6ElK/6rOpc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE47-005UI7-VB; Wed, 22 Apr 2020 13:01:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 26/26] KVM: arm64: Parametrize exception entry with a target EL
Date: Wed, 22 Apr 2020 13:00:50 +0100
Message-Id: <20200422120050.3693593-27-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

We currently assume that an exception is delivered to EL1, always.
Once we emulate EL2, this no longer will be the case. To prepare
for this, add a target_mode parameter.

While we're at it, merge the computing of the target PC and PSTATE in
a single function that updates both PC and CPSR after saving their
previous values in the corresponding ELR/SPSR. This ensures that they
are updated in the correct order (a pretty common source of bugs...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/inject_fault.c | 75 ++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d3ebf8bca4b89..3dbcbc839b9c3 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -26,28 +26,12 @@ enum exception_type {
 	except_type_serror	= 0x180,
 };
 
-static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
-{
-	u64 exc_offset;
-
-	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
-	case PSR_MODE_EL1t:
-		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
-		break;
-	case PSR_MODE_EL1h:
-		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
-		break;
-	case PSR_MODE_EL0t:
-		exc_offset = LOWER_EL_AArch64_VECTOR;
-		break;
-	default:
-		exc_offset = LOWER_EL_AArch32_VECTOR;
-	}
-
-	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
-}
-
 /*
+ * This performs the exception entry at a given EL (@target_mode), stashing PC
+ * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
+ * The EL passed to this function *must* be a non-secure, privileged mode with
+ * bit 0 being set (PSTATE.SP == 1).
+ *
  * When an exception is taken, most PSTATE fields are left unchanged in the
  * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
  * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
@@ -59,10 +43,35 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
  * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
+static void enter_exception(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			    enum exception_type type)
 {
-	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-	unsigned long old, new;
+	unsigned long sctlr, vbar, old, new, mode;
+	u64 exc_offset;
+
+	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	if      (mode == target_mode)
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+	else if ((mode | 1) == target_mode)
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+	else if (!(mode & PSR_MODE32_BIT))
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+	else
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+
+	switch (target_mode) {
+	case PSR_MODE_EL1h:
+		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		break;
+	default:
+		/* Don't do that */
+		BUG();
+	}
+
+	*vcpu_pc(vcpu) = vbar + exc_offset + type;
 
 	old = *vcpu_cpsr(vcpu);
 	new = 0;
@@ -105,9 +114,10 @@ static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
 	new |= PSR_I_BIT;
 	new |= PSR_F_BIT;
 
-	new |= PSR_MODE_EL1h;
+	new |= target_mode;
 
-	return new;
+	*vcpu_cpsr(vcpu) = new;
+	vcpu_write_spsr(vcpu, old);
 }
 
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
@@ -116,11 +126,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
 
@@ -148,14 +154,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

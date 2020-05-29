Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3AAC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7F25207F9
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qiGX/GIO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7F25207F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0F2B4B1CF;
	Fri, 29 May 2020 12:03:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LtQXC+JD7Vxw; Fri, 29 May 2020 12:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE7F4B2BB;
	Fri, 29 May 2020 12:03:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 343A14B280
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L51kmL4nG-Qz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:03:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 035D34B273
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 34F4720814;
 Fri, 29 May 2020 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768224;
 bh=JoaO0OUIgw9ZfmDzivNnlpOdxdHTUTFlsCCG5N/VBLw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qiGX/GIOiodWTgqx3R/Z7+o7+0ieJYg8oB8nd6J3jmWLyOFZCsZ98lKE0UjwVIAVq
 exx/aV5hNOGEPPV+WAH39bXHPCjc6P4RrkR6JihntCFCgTZZItiVwPvpTfSOHIM/Em
 sZGxDMZTwNi7IERB0QC9uVoPCqy6IFXeT8g9AXy8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehSO-00GJKc-Lg; Fri, 29 May 2020 17:02:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 23/24] KVM: arm64: Parametrize exception entry with a target EL
Date: Fri, 29 May 2020 17:01:20 +0100
Message-Id: <20200529160121.899083-24-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/ptrace.h |  1 +
 arch/arm64/kvm/inject_fault.c   | 75 +++++++++++++++++----------------
 2 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index bf57308fcd63..953b6a1ce549 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -35,6 +35,7 @@
 #define GIC_PRIO_PSR_I_SET		(1 << 4)
 
 /* Additional SPSR bits not exposed in the UABI */
+#define PSR_MODE_THREAD_BIT	(1 << 0)
 #define PSR_IL_BIT		(1 << 20)
 
 /* AArch32-specific ptrace requests */
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 6aafc2825c1c..e21fdd93027a 100644
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
+static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      enum exception_type type)
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
+	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
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
+		vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
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
 
-	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
 
@@ -148,14 +154,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
-	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
-	vcpu_write_spsr(vcpu, cpsr);
+	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

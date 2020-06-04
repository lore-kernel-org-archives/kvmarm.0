Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC24FC433E4
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:34:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 813CB20823
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YR6CZ4In"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 813CB20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0D94B32B;
	Thu,  4 Jun 2020 09:34:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ggwJvwVpHkoc; Thu,  4 Jun 2020 09:34:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3516E4B35B;
	Thu,  4 Jun 2020 09:34:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A633B4B2FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ho9mAZDrYsJO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:34:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F8324B1EA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:34:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B0BDC207F5;
 Thu,  4 Jun 2020 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591277645;
 bh=oTpdh0V2Z95uY3LBT8s4QiNnX2wWztmbveBiUjivoGs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YR6CZ4InhWsUIB0fnTVAgtFWHZM0Q9V817LIfrnpJkEIN3cbTWbaHSqpkaGScFNAF
 dKit3INlFzUfog/sqPThe1V17GKxiCOkAU+HJ0Mj9RSzznP/Zn8zAOQKvR/mHDmhIa
 6qEZ+dO3rA3gYktLJj6oAvywWHIrYTn7S/Cnk4OM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jgq0S-000G3O-6u; Thu, 04 Jun 2020 14:34:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] KVM: arm64: Save the host's PtrAuth keys in
 non-preemptible context
Date: Thu,  4 Jun 2020 14:33:52 +0100
Message-Id: <20200604133354.1279412-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200604133354.1279412-1-maz@kernel.org>
References: <20200604133354.1279412-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 stable@vger.kernel.org, Will Deacon <will@kernel.org>
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

When using the PtrAuth feature in a guest, we need to save the host's
keys before allowing the guest to program them. For that, we dump
them in a per-CPU data structure (the so called host context).

But both call sites that do this are in preemptible context,
which may end up in disaster should the vcpu thread get preempted
before reentering the guest.

Instead, save the keys eagerly on each vcpu_load(). This has an
increased overhead, but is at least safe.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  6 ------
 arch/arm64/kvm/arm.c                 | 18 +++++++++++++++++-
 arch/arm64/kvm/handle_exit.c         | 19 ++-----------------
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a30b4eec7cb4..977843e4d5fb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -112,12 +112,6 @@ static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
 }
 
-static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
-{
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_disable(vcpu);
-}
-
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d6988401c22a..152049c5055d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -337,6 +337,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -370,7 +376,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	vcpu_ptrauth_setup_lazy(vcpu);
+	if (vcpu_has_ptrauth(vcpu)) {
+		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
+
+		__ptrauth_save_key(ctxt->sys_regs, APIA);
+		__ptrauth_save_key(ctxt->sys_regs, APIB);
+		__ptrauth_save_key(ctxt->sys_regs, APDA);
+		__ptrauth_save_key(ctxt->sys_regs, APDB);
+		__ptrauth_save_key(ctxt->sys_regs, APGA);
+
+		vcpu_ptrauth_disable(vcpu);
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index eb194696ef62..065251efa2e6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,31 +162,16 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
-
 /*
  * Handle the guest trying to use a ptrauth instruction, or trying to access a
  * ptrauth register.
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *ctxt;
-
-	if (vcpu_has_ptrauth(vcpu)) {
+	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_enable(vcpu);
-		ctxt = vcpu->arch.host_cpu_context;
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
-	} else {
+	else
 		kvm_inject_undefined(vcpu);
-	}
 }
 
 /*
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B14CCA47E
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:29:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE024B3FD;
	Fri, 10 Jun 2022 05:29:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mq7fU-BoU-47; Fri, 10 Jun 2022 05:29:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA254B3EE;
	Fri, 10 Jun 2022 05:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 326124B3B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uA9I-sCzLMxH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:28:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDAB74B2D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:28:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4A23C61EE1;
 Fri, 10 Jun 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C8C341CA;
 Fri, 10 Jun 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853336;
 bh=DG76y4Z939DqmsXiB0LyRZxGXoziZjzuonFMjVMbd1s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mV1+pNJwXcr/eehsrfRLTqydpbHqa3AudTItOikFcVO1n6sSIqaMBIfA0etHSK9r7
 ej6HtHHauFIyDYEus2kFXuwUwzmJypgIQzZb2I955WnXDplrDbneMDz+bo13jI6O/6
 I7EZ/Oey80Hm0rc1Oin3eJ+5EyT2UMMIGn6oaZS3xZ2eSwIUfAEfz6tso+LlQVpuNg
 fpn79Gna+qUkIKvVrboEYUeS7Fzjsr/zugEk2l41BUVhe7sUUCbvzWV51/aZ/du8s4
 bdt4+E90ZPQNe+jvdnGMa4lcWHNsZ5/UByZykw7IzfbLByPm5E6J3ytwPEVo5zzGB7
 DjCAeWRNBrQ9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawo-00H6Dt-Dz; Fri, 10 Jun 2022 10:28:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 03/19] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
Date: Fri, 10 Jun 2022 10:28:22 +0100
Message-Id: <20220610092838.1205755-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
TIF_FOREIGN_FPSTATE so that we can evaluate just before running
the vcpu whether it the FP regs contain something that is owned
by the vcpu or not by updating the rest of the FP flags.

We do this in the hypervisor code in order to make sure we're
in a context where we are not interruptible. But we already
have a hook in the run loop to generate this flag. We may as
well update the FP flags directly and save the pointless flag
tracking.

Whilst we're at it, rename update_fp_enabled() to guest_owns_fp_regs()
to indicate what the leftover of this helper actually do.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  1 -
 arch/arm64/kvm/fpsimd.c                 | 17 ++++++++++-------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++--------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 5 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 47a1e25e25bb..63103cc1bdc4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -462,7 +462,6 @@ struct kvm_vcpu_arch {
 
 #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
-#define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 #define KVM_ARM64_HOST_SME_ENABLED	(1 << 16) /* SME enabled for EL0 */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 6012b08ecb14..edbc0183c89b 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -107,16 +107,19 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Called just before entering the guest once we are no longer
- * preemptable. Syncs the host's TIF_FOREIGN_FPSTATE with the KVM
- * mirror of the flag used by the hypervisor.
+ * Called just before entering the guest once we are no longer preemptable
+ * and interrupts are disabled. If we have managed to run anything using
+ * FP while we were preemptible (such as off the back of an interrupt),
+ * then neither the host nor the guest own the FP hardware (and it was the
+ * responsibility of the code that used FP to save the existing state).
+ *
+ * Note that not supporting FP is basically the same thing as far as the
+ * hypervisor is concerned (nothing to save).
  */
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 {
-	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
-		vcpu->arch.flags |= KVM_ARM64_FP_FOREIGN_FPSTATE;
-	else
-		vcpu->arch.flags &= ~KVM_ARM64_FP_FOREIGN_FPSTATE;
+	if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
+		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 37d9f211c200..e54320384943 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -37,21 +37,9 @@ struct kvm_exception_table_entry {
 extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
-/* Check whether the FP regs were dirtied while in the host-side run loop: */
-static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
+/* Check whether the FP regs are owned by the guest */
+static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * When the system doesn't support FP/SIMD, we cannot rely on
-	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
-	 * abort on the very first access to FP and thus we should never
-	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
-	 * trap the accesses.
-	 */
-	if (!system_supports_fpsimd() ||
-	    vcpu->arch.flags & KVM_ARM64_FP_FOREIGN_FPSTATE)
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-				      KVM_ARM64_FP_HOST);
-
 	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6db801db8f27..a6b9f1186577 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -43,7 +43,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = vcpu->arch.cptr_el2;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
-	if (!update_fp_enabled(vcpu)) {
+	if (!guest_owns_fp_regs(vcpu)) {
 		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 		__activate_traps_fpsimd32(vcpu);
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 969f20daf97a..46f365254e9f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -55,7 +55,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (update_fp_enabled(vcpu)) {
+	if (guest_owns_fp_regs(vcpu)) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	} else {
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989B9C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9EC4B274;
	Sat, 28 May 2022 07:50:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s8LJ5OkSz05G; Sat, 28 May 2022 07:50:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00CED4B31E;
	Sat, 28 May 2022 07:50:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75104B2AA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vscetRzS0yNL for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:50:10 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49F3A4B337
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9B3DF60DB6;
 Sat, 28 May 2022 11:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4C6C34100;
 Sat, 28 May 2022 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738609;
 bh=NpBakX7cdbTDYtlAQuASsasX4nXhz/zUUw2STZWlQM0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kkx9bqMGIqJznB2TTE3J4p8PDLrZIUC8M77iMXcSxHIU/ech2vEAObNAQerS7DKem
 csHxEVSIkt5t96O8o9U6k2fedczMcW3yCKwwCw+eqKvkRl+Tm81TfI/h203BrzWq4S
 ueifVxVt21l8u6AxEoUUDE1E+jUY1m7ekbRdEuo3l92Aw8WwjRVr+hgFQxk+YTfsy+
 tS7GTfPBGkgPQU22XNOqjAe8oqYssWeZ7xC8WWdl1VPVs8eHIEHWhoDnNQIQ8OCVhb
 xiCgJE0ULo9GEOsjlDh4Jpa9Vbhelu5oQeJeQZGziELDDkqm6Av1iSW/cNG2Mq+zaA
 MuxPF7amx6rEw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumB-00EEGh-QV; Sat, 28 May 2022 12:38:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/18] KVM: arm64: Move vcpu SVE/SME flags to the state flag
 set
Date: Sat, 28 May 2022 12:38:20 +0100
Message-Id: <20220528113829.1043361-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
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

The two HOST_{SVE,SME}_ENABLED are only used for the host kernel
to track its own state across a vcpu run so that it can be fully
restored.

Move these flags to the so called state set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 +++++---
 arch/arm64/kvm/fpsimd.c           | 12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a426cd3aaa74..a28a2dca8767 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -507,6 +507,11 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
+/* SVE enabled for host EL0 */
+#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
+/* SME enabled for EL0 */
+#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
+
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
@@ -528,11 +533,8 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
-#define KVM_ARM64_HOST_SME_ENABLED	(1 << 16) /* SME enabled for EL0 */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
-
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 0d82f6c5b110..1f5238c80d27 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -79,9 +79,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.fp_state = FP_STATE_DIRTY_HOST;
 
-	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
+	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
 
 	/*
 	 * We don't currently support SME guests but if we leave
@@ -93,9 +93,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 * operations. Do this for ZA as well for now for simplicity.
 	 */
 	if (system_supports_sme()) {
-		vcpu->arch.flags &= ~KVM_ARM64_HOST_SME_ENABLED;
+		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu->arch.flags |= KVM_ARM64_HOST_SME_ENABLED;
+			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
 
 		if (read_sysreg_s(SYS_SVCR_EL0) &
 		    (SYS_SVCR_EL0_SM_MASK | SYS_SVCR_EL0_ZA_MASK)) {
@@ -165,7 +165,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
-		if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
+		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0,
 					 CPACR_EL1_SMEN_EL0EN |
 					 CPACR_EL1_SMEN_EL1EN);
@@ -194,7 +194,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
-		if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
+		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
 		else
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292FEC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D324B1E0;
	Fri, 10 Jun 2022 05:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uG-EJvKAlvin; Fri, 10 Jun 2022 05:35:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9798A4B3F1;
	Fri, 10 Jun 2022 05:35:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E094045D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yGnNZR53b6WJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:49 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0FEF4B2C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:48 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id EB96FCE3407;
 Fri, 10 Jun 2022 09:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5825EC34114;
 Fri, 10 Jun 2022 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853744;
 bh=JjEZYAcXIQ+YWI8Fs8DU+wJ647DInfWoIDUsAkl6PVs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bEoUE5Siva2Y13fo0LVjswRtelDmr69BIIOmvWKDtpVrBJUsVITajSOwHqagvph3N
 TgBZ/Rn3L/BqTOTviphQcbCmQ8Cdu0kJTastxSSG77/MRfXr4NfMWlBDNy1Vs9Pp15
 +PNLhYaBayG96+9COg+UF3jKs/3/sqUJ3qlFtQzgp2DkEiGGCEpeenHzwzvYhIvlpu
 jEqxuhr0v1MdwkRwmtFQ5I9F2xJy3fqGnyrA/3mRPul4epDaJXARA6G/RXBsc1Itfg
 4RIOfCegs73HvAnvtHVmnawcNPB7kWTtgHnU23PS1DF0TMYLYduDrXRcYD+Z7x+dah
 XqbnSzngzxeWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawq-00H6Dt-6V; Fri, 10 Jun 2022 10:28:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 10/19] KVM: arm64: Move vcpu SVE/SME flags to the state
 flag set
Date: Fri, 10 Jun 2022 10:28:29 +0100
Message-Id: <20220610092838.1205755-11-maz@kernel.org>
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

The two HOST_{SVE,SME}_ENABLED are only used for the host kernel
to track its own state across a vcpu run so that it can be fully
restored.

Move these flags to the so called state set.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 +++++---
 arch/arm64/kvm/fpsimd.c           | 12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4c7446400b77..4f147bdc5ce9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -515,6 +515,11 @@ struct kvm_vcpu_arch {
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
@@ -536,11 +541,8 @@ struct kvm_vcpu_arch {
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
index d397efe1a378..557a96f8e06a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -79,9 +79,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
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
 
 		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
 			vcpu->arch.fp_state = FP_STATE_FREE;
@@ -164,7 +164,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
-		if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
+		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0,
 					 CPACR_EL1_SMEN_EL0EN |
 					 CPACR_EL1_SMEN_EL1EN);
@@ -193,7 +193,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
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

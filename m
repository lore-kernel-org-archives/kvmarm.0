Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E61C433E9
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:13:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8E1A64F06
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:13:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8E1A64F06
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 651DE4B617;
	Tue, 16 Mar 2021 06:13:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aNrxXUVI-7cS; Tue, 16 Mar 2021 06:13:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8516A4B635;
	Tue, 16 Mar 2021 06:13:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 270CD4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vi9jq43WdirD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 06:13:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA88E4B5FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:13:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E477765031;
 Tue, 16 Mar 2021 10:13:36 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lM6hj-001uep-1q; Tue, 16 Mar 2021 10:13:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH 09/10] KVM: arm64: Save/restore SVE state for nVHE
Date: Tue, 16 Mar 2021 10:13:11 +0000
Message-Id: <20210316101312.102925-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316101312.102925-1-maz@kernel.org>
References: <20210316101312.102925-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com,
 daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 daniel.kiss@arm.com
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

Implement the SVE save/restore for nVHE, following a similar
logic to that of the VHE implementation:

- the SVE state is switched on trap from EL1 to EL2

- no further changes to ZCR_EL2 occur as long as the guest isn't
  preempted or exit to userspace

- on vcpu_put(), ZCR_EL2 is reset to its default value, and ZCR_EL1
  restored to the default guest value

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c                 | 15 ++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++----------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +--
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index b5f95abd23f5..cc6cdea69596 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -121,11 +121,22 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	local_irq_save(flags);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		if (guest_has_sve)
+		if (guest_has_sve) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
+			/* Restore the VL that was saved when bound to the CPU */
+			if (!has_vhe()) {
+				u64 zcr;
+
+				kvm_call_hyp(__kvm_reset_sve_vq);
+				zcr = vcpu_sve_vq(vcpu) - 1;
+				if (read_sysreg_el1(SYS_ZCR) != zcr)
+					write_sysreg_el1(zcr, SYS_ZCR);
+			}
+		}
+
 		fpsimd_save_and_flush_cpu_state();
-	} else if (host_has_sve) {
+	} else if (has_vhe() && host_has_sve) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
 		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d34dc220a1ce..777b9bfa4478 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -218,25 +218,19 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
-	bool vhe, sve_guest, sve_host;
+	bool sve_guest, sve_host;
 	u8 esr_ec;
+	u64 reg;
 
 	if (!system_supports_fpsimd())
 		return false;
 
-	/*
-	 * Currently system_supports_sve() currently implies has_vhe(),
-	 * so the check is redundant. However, has_vhe() can be determined
-	 * statically and helps the compiler remove dead code.
-	 */
-	if (has_vhe() && system_supports_sve()) {
+	if (system_supports_sve()) {
 		sve_guest = vcpu_has_sve(vcpu);
 		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
-		vhe = true;
 	} else {
 		sve_guest = false;
 		sve_host = false;
-		vhe = has_vhe();
 	}
 
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
@@ -245,31 +239,26 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		return false;
 
 	/* Don't handle SVE traps for non-SVE vcpus here: */
-	if (!sve_guest)
-		if (esr_ec != ESR_ELx_EC_FP_ASIMD)
-			return false;
+	if (!sve_guest && esr_ec != ESR_ELx_EC_FP_ASIMD)
+		return false;
 
 	/* Valid trap.  Switch the context: */
-
-	if (vhe) {
-		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
-
+	if (has_vhe()) {
+		reg = CPACR_EL1_FPEN;
 		if (sve_guest)
 			reg |= CPACR_EL1_ZEN;
 
-		write_sysreg(reg, cpacr_el1);
+		sysreg_clear_set(cpacr_el1, 0, reg);
 	} else {
-		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
-			     cptr_el2);
-	}
+		reg = CPTR_EL2_TFP;
+		if (sve_guest)
+			reg |= CPTR_EL2_TZ;
 
+		sysreg_clear_set(cptr_el2, reg, 0);
+	}
 	isb();
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
-		/*
-		 * In the SVE case, VHE is assumed: it is enforced by
-		 * Kconfig and kvm_arch_init().
-		 */
 		if (sve_host)
 			__hyp_sve_save_host(vcpu);
 		else
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f3d0e9eca56c..ef47abcef63f 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -41,9 +41,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
 	if (!update_fp_enabled(vcpu)) {
-		val |= CPTR_EL2_TFP;
+		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

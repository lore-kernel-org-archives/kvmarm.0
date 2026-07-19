Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D803803F7;
	Sun, 19 Jul 2026 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502651; cv=none; b=adWf5npkMRNehFSn7OLteNZ363ed9zyTShbnsaRDkcIwuAakx56iovKtE+1gRx+EjuWbgmAz6E8fc++Z1jPXhD0Dw5zLkjfVNR7Qexz9liJuxyqOkiPdvqcoAIBuLvVfb/TgMeMEMZ4GO7t0tyP/3/sXD3a8Ryo2ihqToX2N+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502651; c=relaxed/simple;
	bh=sk5UV4D8nxCJMJ3xILivF4E7O/FkNOR/tMjqIGqB6Y0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CtAzmbU4V6RD7vaKiRlazBBckTO0gwh1/96H4ynaCvTDXuC6xk+90LJW2ldGfpp+blxZlUMlsO1avmpzP1SxheRJoivVrjZoiesmAONiKZeIzTodVSjsgxn2BGpkMeUR46mJV1tCvBPltZKmtfHL9e1UEw8QjFQsv0lWp33tsLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7YH/ZeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7YH/ZeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D321F000E9;
	Sun, 19 Jul 2026 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502649;
	bh=/D7A+/K09S6yFl/i+7JwiO/DHtiAAbsIdjqdAGJ7jGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j7YH/ZeCcuUssPiRCEZVbO2hN8Ozd1nuiqVP2Q2dcGXfjTdSGryXl+fM2naIdrOCE
	 zA0ykelNAn1oRgI+6Egoyh0pq/l6avq5UeVdAE5QTIHEcOlZcU8GpFD7PHcAi30CcD
	 tRwF+RXGTzkfv2BOQy62rKHPxb0s5ujjXdZF1H9lU5oM0EkpGCH9dinLCmgQCLMzxj
	 KIm6n1zvu1ztdBdKWf10yII3J5vBS6qY1UJrjN7I/hiCzyK2AF5PYp0geizz7+pmn3
	 6x5+Tgkh+iZYbyXD3jMvHsWQE2CIKKgGH4+dnc55Fjg12FmoiD3x3mXbXlm6o7sUnU
	 1pSKgcvr3UC4A==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:39 +0100
Subject: [PATCH v13 12/32] KVM: arm64: Define internal features for SME
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-12-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3307; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sk5UV4D8nxCJMJ3xILivF4E7O/FkNOR/tMjqIGqB6Y0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkwTNOtFEXfazfu6PadtIzIGZDK6qlXVMYcs
 vpCNxtkJhqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZMAAKCRAk1otyXVSH
 0M9OB/0WkbYRiGnVCTEg8Nb8HLWnAa5UZu1OMM4e9pqP+1mMFRKuUdPlHivFhOAVBChGyZtGP3o
 GLObsc9YKmZ8Y7hlgTiiieWM9UKVsNLYDFrmSdeWeLsg3OTL4uolCGQT10UXGZ0ssSSXTyG3vL7
 Minw6VWRRJbsSH6XPkk2AGCBTunD5aYQStQAmdKANHxnjg+uatH6Dwspf5W7FQ6jX4gIbTry6Ya
 WtnJw9DPRzuPydn2qOvsMIAQJpUaAm/YgOjzRrwevVWpp/WyS/AWt1Cg9LW4+XDX6vQYvsu8O5e
 0hdJnvl271uo+mhfQLt86L0lcRqXLAZOeK//YnmEvRkXd8/2
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to simplify interdependencies in the rest of the series define
the feature detection for SME and its subfeatures.  Due to the need for
vector length configuration we define a flag for SME like for SVE.  We
also have two subfeatures which add architectural state, FA64 and SME2,
which are configured via the normal ID register scheme.

Also provide helpers which check if the vCPU is in streaming mode or has
ZA enabled.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  2 +-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b746b1a1e53..8e185e43fbff 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* SME exposed to guest */
+#define KVM_ARCH_FLAG_GUEST_HAS_SME			12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -1133,7 +1135,16 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu)	kvm_has_sve((vcpu)->kvm)
 #endif
 
-#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
+#define kvm_has_sme(kvm)	(system_supports_sme() &&		\
+				 test_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &(kvm)->arch.flags))
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define vcpu_has_sme(vcpu)	kvm_has_sme(kern_hyp_va((vcpu)->kvm))
+#else
+#define vcpu_has_sme(vcpu)	kvm_has_sme((vcpu)->kvm)
+#endif
+
+#define vcpu_has_vec(vcpu) (vcpu_has_sve(vcpu) || vcpu_has_sme(vcpu))
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
@@ -1650,6 +1661,28 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_sctlr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
 
+#define kvm_has_fa64(k)					\
+	(system_supports_fa64() &&			\
+	 kvm_has_feat((k), ID_AA64SMFR0_EL1, FA64, IMP))
+
+#define kvm_has_sme2(k)					\
+	(system_supports_sme2() &&			\
+	 kvm_has_feat((k), ID_AA64PFR1_EL1, SME, SME2))
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define vcpu_has_sme2(vcpu)	kvm_has_sme2(kern_hyp_va((vcpu)->kvm))
+#define vcpu_has_fa64(vcpu)	kvm_has_fa64(kern_hyp_va((vcpu)->kvm))
+#else
+#define vcpu_has_sme2(vcpu)	kvm_has_sme2((vcpu)->kvm)
+#define vcpu_has_fa64(vcpu)	kvm_has_fa64((vcpu)->kvm)
+#endif
+
+#define vcpu_in_streaming_mode(vcpu) \
+	(__vcpu_sys_reg(vcpu, SVCR) & SVCR_SM_MASK)
+
+#define vcpu_za_enabled(vcpu) \
+	(__vcpu_sys_reg(vcpu, SVCR) & SVCR_ZA_MASK)
+
 static inline bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b352cd323e30..ba8a3ed8f5ff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2028,7 +2028,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
 {
-	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
+	if (vcpu_has_sme(vcpu))
 		return 0;
 
 	return REG_HIDDEN;

-- 
2.47.3


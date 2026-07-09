Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA939769D;
	Thu,  9 Jul 2026 00:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558394; cv=none; b=aLZaLZgAeOnfJHH/X8L5F9W1jLPBHfdrKaEe/rwHOYM3ptk8gqclHiheDplmoTg0Dgt9tjiEF7/my/cYZDGGD1V32rFTh7qQDFomLMOrraErTB2fTQ53cJpgNbABA0P49MnU7mshCDd+x8YtZyHEq4VyMg7VebJTr0GaolbxJxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558394; c=relaxed/simple;
	bh=z7S7gabtTQubvf1C5BhMhuZ4burPUnffHou5hS57R50=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B6nlIUJ+vmhd9HCowHUonsZDXQfUuMFoc8evhx4QhkbU6gNApQmL6q5E6xGPCRC6V1T7oh3+7fvbxQUvAz6aE64a2h29x57v5q1x7OAk48UWt3J5MAS8I7x5OeE87NW6TzSEFANs1S4Cw3KB9IeO3WVhXMMjdci4Hdl52w0J9oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDtzWckI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDtzWckI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53CD1F00A3D;
	Thu,  9 Jul 2026 00:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558392;
	bh=I4xrVSbCp5yAA6Gucb4v+xBsvRi+5+69PJv2auOuOQs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RDtzWckIImoz+0bVJKP8OiK+6e2JGvXuF39Rg2l3dYqwd37jI0stPI0oQaL2us5ce
	 kpxoQQ/cUAtKz0ewuBiYXkWxq4q2IJ5lqjApTG9gF4Dm0rMCH/05g59mYEWuoOWGez
	 PjUhSIbAckua23kLlD3YNOxl5TYqeXqWiLR+JKfE7DCkdy+kclJEoVfaSfgLozfh5e
	 ypM+iNrtgLQkn4+JgUGHoNgQogm7bkMH8vU28G+pVtoT61tHT826PWXBucTMv5itMM
	 0+9uiw9CYTdQrzcuyTxitYdGtrRLwdOme0Y4/vGqcdKXvQLySrL8KKT8tzarzRkj9B
	 DUpC6iSSaaiEg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:45 +0100
Subject: [PATCH v11 08/29] KVM: arm64: Rename SVE finalization constants to
 be more general
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-8-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7699; i=broonie@kernel.org;
 h=from:subject:message-id; bh=z7S7gabtTQubvf1C5BhMhuZ4burPUnffHou5hS57R50=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDAEyPUczhM2dUTO8pSPmGcij6BoSUWMSPNQ
 c+mGFBJg9WJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wwAAKCRAk1otyXVSH
 0MBYB/4uQxRjVk7zyA0gBq4wAd7FknqnV5WNydBa6YG/9WtxLYLklSSD8BCcSY6ZPW1oiIzL0sU
 y0KGCNUEoSu7fgYnlXXe6IpuIHRVE0AACxzcal1ANdyZGcG3ZrlWzyQtAdE/V52dQmZTez8525r
 cJ2FGYUN0ydf5tUDcUsqarZXEn7/lP0Gkmby2fmcvIIDzFccnDS3k6iJ54KPLKBGKDHGI/8vChR
 pa1eRXTd6kbd09wANtKrLokHpxKEsKO3MW+ehz0xUbTnHgNGpQf+8KM7n427K6uDhISK+ntWznb
 B8i2ZT8Sw2xsWVIr+t7Cz7fw0VegpkTKAg3ToUJzrVkc2RB6
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Due to the overlap between SVE and SME vector length configuration
created by streaming mode SVE we will finalize both at once.  Rename the
existing finalization to use _VEC (vector) for the naming to avoid
confusion.

Since this includes the userspace API we create an alias
KVM_ARM_VCPU_VEC for the existing KVM_ARM_VCPU_SVE capability, existing
code which does not enable SME will be unaffected and any SME only code
will not need to use SVE constants.

No functional change.

Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 +++++---
 arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
 arch/arm64/kvm/guest.c            | 12 ++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
 arch/arm64/kvm/reset.c            | 20 ++++++++++----------
 5 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..8b746b1a1e53 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1037,8 +1037,8 @@ struct kvm_vcpu_arch {
 
 /* KVM_ARM_VCPU_INIT completed */
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
-/* SVE config completed */
-#define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
+/* Vector config completed */
+#define VCPU_VEC_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
 /* pKVM VCPU setup completed */
 #define VCPU_PKVM_FINALIZED	__vcpu_single_flag(cflags, BIT(2))
 
@@ -1133,6 +1133,8 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu)	kvm_has_sve((vcpu)->kvm)
 #endif
 
+#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
+
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
 	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
@@ -1505,7 +1507,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
+#define kvm_arm_vcpu_vec_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_VEC_FINALIZED)
 
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38a..83af99ca4e1b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -107,6 +107,12 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 
+/*
+ * An alias for _SVE since we finalize VL configuration for both SVE and SME
+ * simultaneously.
+ */
+#define KVM_ARM_VCPU_VEC		KVM_ARM_VCPU_SVE
+
 struct kvm_vcpu_init {
 	__u32 target;
 	__u32 features[7];
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b01d6622b872..0b789f73bf7c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -342,7 +342,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
 
-	if (kvm_arm_vcpu_sve_finalized(vcpu))
+	if (kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM; /* too late! */
 
 	if (WARN_ON(vcpu->arch.sve_state))
@@ -374,7 +374,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (max_vq < SVE_VQ_MIN)
 		return -EINVAL;
 
-	/* vcpu->arch.sve_state will be alloc'd by kvm_vcpu_finalize_sve() */
+	/* vcpu->arch.sve_state will be alloc'd by kvm_vcpu_finalize_vec() */
 	vcpu->arch.sve_max_vl = sve_vl_from_vq(max_vq);
 
 	return 0;
@@ -497,7 +497,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (ret)
 		return ret;
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
 	if (copy_to_user(uptr, (void *)vcpu->arch.sve_state + region.koffset,
@@ -523,7 +523,7 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (ret)
 		return ret;
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
 	if (copy_from_user((void *)vcpu->arch.sve_state + region.koffset, uptr,
@@ -599,7 +599,7 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
 	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
 		+ 1; /* KVM_REG_ARM64_SVE_VLS */
@@ -617,7 +617,7 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
 	/*
 	 * Enumerate this first, so that userspace can save/restore in
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3b2c4fbc34d8..9d7f632f01f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -454,7 +454,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	int ret = 0;
 
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
-		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
+		vcpu_clear_flag(vcpu, VCPU_VEC_FINALIZED);
 		return 0;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..0fae62a9eaef 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -92,7 +92,7 @@ static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
  * Finalize vcpu's maximum SVE vector length, allocating
  * vcpu->arch.sve_state as necessary.
  */
-static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_finalize_vec(struct kvm_vcpu *vcpu)
 {
 	void *buf;
 	unsigned int vl;
@@ -122,21 +122,21 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	}
 	
 	vcpu->arch.sve_state = buf;
-	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
+	vcpu_set_flag(vcpu, VCPU_VEC_FINALIZED);
 	return 0;
 }
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 {
 	switch (feature) {
-	case KVM_ARM_VCPU_SVE:
-		if (!vcpu_has_sve(vcpu))
+	case KVM_ARM_VCPU_VEC:
+		if (!vcpu_has_vec(vcpu))
 			return -EINVAL;
 
-		if (kvm_arm_vcpu_sve_finalized(vcpu))
+		if (kvm_arm_vcpu_vec_finalized(vcpu))
 			return -EPERM;
 
-		return kvm_vcpu_finalize_sve(vcpu);
+		return kvm_vcpu_finalize_vec(vcpu);
 	}
 
 	return -EINVAL;
@@ -144,7 +144,7 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
+	if (vcpu_has_vec(vcpu) && !kvm_arm_vcpu_vec_finalized(vcpu))
 		return false;
 
 	return true;
@@ -163,7 +163,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.ccsidr);
 }
 
-static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_reset_vec(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_has_sve(vcpu))
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
@@ -203,11 +203,11 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
+	if (!kvm_arm_vcpu_vec_finalized(vcpu)) {
 		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
 			kvm_vcpu_enable_sve(vcpu);
 	} else {
-		kvm_vcpu_reset_sve(vcpu);
+		kvm_vcpu_reset_vec(vcpu);
 	}
 
 	if (vcpu_el1_is_32bit(vcpu))

-- 
2.47.3


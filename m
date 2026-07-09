Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2030739C658;
	Thu,  9 Jul 2026 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558407; cv=none; b=EY3mHC9CMOazSnec657zI88OunicTZCJZ6FlrE8B3eauiDMJQHQMljLIb0rzqkfmw9Hlnf5hX4NSl5ScwuH96HLlya/0G6bXWVYRujopFRum3H78Cu+X5tm7ReFsK5wnCVRsrFnopJUqOLhnpe2/VjUT2epPzkP55yh8fASxGBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558407; c=relaxed/simple;
	bh=1sF/BYH85HO3kwSH/mqUWFa4CEl7bBw6DGcehely/x0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DXD4seLVoABRay4JyOQNUNCaNx1zBlQx/UvYGvSQ2/qC4eCUvFXv3LXGsjshjoIJJui0kWwQe/xjjaoe9ol4+zDqmCq4EXL2k6Ff1JlExS2/n8hXnJrqymnI4o6fzatUInQA1br9ffVJO9nyt9ex65pabiyr/rwuS9mo/0VOXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmB8c/3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmB8c/3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC22E1F00A3A;
	Thu,  9 Jul 2026 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558405;
	bh=5Bp5YL6dNxVcJS8w+5AZKzMfxgUu6n6EByDBPkemuIM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EmB8c/3TRJ7F4VMhXOJ4TqrpdWAphCItDTHoJmTBEDD06WE2Por5jCFtPdXRfKn57
	 esWqDCq1hYpJfyAf+mkKalso1M3p+7BZ9tMka2VgJPoXaS7GojiLO2S+L5tv/5pW2r
	 u/LqXHxqiPDvlsBOaVu0h+KXQ3NTnujJdkafsYwDjpGDicL2k5GwHLKaecDG+jjjSz
	 JK6AObdvhd3MixdA/AvRYpN9a732d2ROwr0tWPMtYK8mStiVvRgVuFoJ5JIvrtnpFr
	 Cw+FvikUYjDQPZghnc2PKkVQLLYNZPi/zX2RxQ0Ix9qalVy7Xs/SUejPJm4nKYuDOH
	 eMOh8y71Yeoxw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:48 +0100
Subject: [PATCH v11 11/29] KVM: arm64: Store vector lengths in an array
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-11-32799f66db9d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10749; i=broonie@kernel.org;
 h=from:subject:message-id; bh=1sF/BYH85HO3kwSH/mqUWFa4CEl7bBw6DGcehely/x0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDCn59p0Z/1iHIkVltpx2Refg6N/zU1/NCpS
 eI/tpXM7YeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wwgAKCRAk1otyXVSH
 0DcOB/96ZfVkp2DxiM+waoc3434pkZIAqJVqbH+rFcsn4TWkMzGFpmItvwVZ/f35X0OLCTN4+gX
 y7LRGjuwcnH3rSG5c/B2Zn8zy8BcE8aznQjjmTyu99MrlVXcJMgQMm4uH4HijH+uSofS2cnQpPZ
 CxLINHeNYv7FT862KSzpfKhVTRRnYQT3l+ew8HjwtKMMGdA2+nWmXVbDxPg0U0LesqHo4BkUIYG
 GLZ8piDRxHxlvlQ0+BRKsfEXAcCn8GV5i20JL8ps7h2TJJQYsX+hWyQDOHIunzk1XDou8pULe9z
 nxM7DO6aZ+clbq8OBEXOw5uxB2YFg8SnQnzg+4oIT78CW0gU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME adds a second vector length configured in a very similar way to the
SVE vector length, in order to facilitate future code sharing for SME
refactor our storage of vector lengths to use an array like the host does.
We do not yet take much advantage of this so the intermediate code is not
as clean as might be.

No functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 11 ++++++-----
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/include/asm/kvm_pkvm.h       |  2 +-
 arch/arm64/kvm/guest.c                  |  6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  7 ++++---
 arch/arm64/kvm/reset.c                  | 22 +++++++++++-----------
 8 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8e185e43fbff..5e071381ae5b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -77,8 +77,9 @@ enum kvm_mode kvm_get_mode(void);
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 #endif
 
-extern unsigned int __ro_after_init kvm_sve_max_vl;
-extern unsigned int __ro_after_init kvm_host_sve_max_vl;
+extern unsigned int __ro_after_init kvm_max_vl[ARM64_VEC_MAX];
+extern unsigned int __ro_after_init kvm_host_max_vl[ARM64_VEC_MAX];
+
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
@@ -857,7 +858,7 @@ struct kvm_vcpu_arch {
 	 */
 	struct arm64_sve_state *sve_state;
 	enum fp_type fp_type;
-	unsigned int sve_max_vl;
+	unsigned int max_vl[ARM64_VEC_MAX];
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
@@ -1100,7 +1101,7 @@ struct kvm_vcpu_arch {
 /* KVM is currently emulating an L2 to L1 exception */
 #define IN_NESTED_EXCEPTION	__vcpu_single_flag(sflags, BIT(9))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
 
 #define vcpu_sve_zcr_elx(vcpu)						\
 	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
@@ -1119,7 +1120,7 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
+#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4974492744cc..3d05533a0f67 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -150,7 +150,7 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
-extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
+extern unsigned int kvm_nvhe_sym(kvm_host_max_vl[ARM64_VEC_MAX]);
 extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
 extern unsigned int kvm_nvhe_sym(hyp_gicv3_nr_lr);
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 74fedd9c5ff0..d4d22acf2fe7 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -188,7 +188,7 @@ static inline size_t pkvm_host_sve_state_size(void)
 	if (!system_supports_sve())
 		return 0;
 
-	return SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl));
+	return SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]));
 }
 
 struct pkvm_mapping {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3ae751e72c95..2370bb0ad94e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -318,7 +318,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
 
-	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
+	if (WARN_ON(!sve_vl_valid(vcpu->arch.max_vl[ARM64_VEC_SVE])))
 		return -EINVAL;
 
 	memset(vqs, 0, sizeof(vqs));
@@ -356,7 +356,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (vq_present(vqs, vq))
 			max_vq = vq;
 
-	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
+	if (max_vq > sve_vq_from_vl(kvm_max_vl[ARM64_VEC_SVE]))
 		return -EINVAL;
 
 	/*
@@ -375,7 +375,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return -EINVAL;
 
 	/* vcpu->arch.sve_state will be alloc'd by kvm_vcpu_finalize_vec() */
-	vcpu->arch.sve_max_vl = sve_vl_from_vq(max_vq);
+	vcpu->arch.max_vl[ARM64_VEC_SVE] = sve_vl_from_vq(max_vq);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 18131e395e24..33729e218c0a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -493,7 +493,7 @@ static inline void __hyp_sve_save_host(void)
 	struct arm64_sve_state *sve_regs = *host_data_ptr(sve_regs);
 
 	ctxt_sys_reg(hctxt, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
-	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1, SYS_ZCR_EL2);
 	sve_save_state(sve_regs, true);
 	fpsimd_save_common(&hctxt->fp_regs);
 }
@@ -548,7 +548,7 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
 			write_sysreg_el2(zcr_el2, SYS_ZCR);
 		} else {
-			zcr_el2 = sve_vq_from_vl(kvm_host_sve_max_vl) - 1;
+			zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
 			write_sysreg_el2(zcr_el2, SYS_ZCR);
 
 			zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f4..14e24e257dcc 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -40,7 +40,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	sve_save_state(kern_hyp_va(vcpu->arch.sve_state), true);
 	fpsimd_save_common(&vcpu->arch.ctxt.fp_regs);
-	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1, SYS_ZCR_EL2);
 }
 
 static void __hyp_sve_restore_host(void)
@@ -57,7 +57,7 @@ static void __hyp_sve_restore_host(void)
 	 * that was discovered, if we wish to use larger VLs this will
 	 * need to be revisited.
 	 */
-	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1, SYS_ZCR_EL2);
 	sve_load_state(sve_regs, true);
 	fpsimd_load_common(&hctxt->fp_regs);
 	write_sysreg_el1(ctxt_sys_reg(hctxt, ZCR_EL1), SYS_ZCR);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9d7f632f01f8..d49f7f327adf 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -22,7 +22,7 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
-unsigned int kvm_host_sve_max_vl;
+unsigned int kvm_host_max_vl[ARM64_VEC_MAX];
 
 /*
  * The currently loaded hyp vCPU for each physical CPU. Used in protected mode
@@ -459,7 +459,8 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	}
 
 	/* Limit guest vector length to the maximum supported by the host. */
-	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
+	sve_max_vl = min(READ_ONCE(host_vcpu->arch.max_vl[ARM64_VEC_SVE]),
+			 kvm_host_max_vl[ARM64_VEC_SVE]);
 	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
@@ -473,7 +474,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 		goto err;
 
 	vcpu->arch.sve_state = sve_state;
-	vcpu->arch.sve_max_vl = sve_max_vl;
+	vcpu->arch.max_vl[ARM64_VEC_SVE] = sve_max_vl;
 
 	return 0;
 err:
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0fae62a9eaef..fee01c38fa13 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -32,7 +32,7 @@
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
-unsigned int __ro_after_init kvm_host_sve_max_vl;
+unsigned int __ro_after_init kvm_host_max_vl[ARM64_VEC_MAX];
 
 /*
  * ARMv8 Reset Values
@@ -46,14 +46,14 @@ unsigned int __ro_after_init kvm_host_sve_max_vl;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
-unsigned int __ro_after_init kvm_sve_max_vl;
+unsigned int __ro_after_init kvm_max_vl[ARM64_VEC_MAX];
 
 int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
-		kvm_sve_max_vl = sve_max_virtualisable_vl();
-		kvm_host_sve_max_vl = sve_max_vl();
-		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
+		kvm_max_vl[ARM64_VEC_SVE] = sve_max_virtualisable_vl();
+		kvm_host_max_vl[ARM64_VEC_SVE] = sve_max_vl();
+		kvm_nvhe_sym(kvm_host_max_vl[ARM64_VEC_SVE]) = kvm_host_max_vl[ARM64_VEC_SVE];
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need
@@ -61,16 +61,16 @@ int __init kvm_arm_init_sve(void)
 		 * order to support vector lengths greater than
 		 * VL_ARCH_MAX:
 		 */
-		if (WARN_ON(kvm_sve_max_vl > VL_ARCH_MAX))
-			kvm_sve_max_vl = VL_ARCH_MAX;
+		if (WARN_ON(kvm_max_vl[ARM64_VEC_SVE] > VL_ARCH_MAX))
+			kvm_max_vl[ARM64_VEC_SVE] = VL_ARCH_MAX;
 
 		/*
 		 * Don't even try to make use of vector lengths that
 		 * aren't available on all CPUs, for now:
 		 */
-		if (kvm_sve_max_vl < sve_max_vl())
+		if (kvm_max_vl[ARM64_VEC_SVE] < sve_max_vl())
 			pr_warn("KVM: SVE vector length for guests limited to %u bytes\n",
-				kvm_sve_max_vl);
+				kvm_max_vl[ARM64_VEC_SVE]);
 	}
 
 	return 0;
@@ -78,7 +78,7 @@ int __init kvm_arm_init_sve(void)
 
 static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
+	vcpu->arch.max_vl[ARM64_VEC_SVE] = kvm_max_vl[ARM64_VEC_SVE];
 
 	/*
 	 * Userspace can still customize the vector lengths by writing
@@ -99,7 +99,7 @@ static int kvm_vcpu_finalize_vec(struct kvm_vcpu *vcpu)
 	size_t reg_sz;
 	int ret;
 
-	vl = vcpu->arch.sve_max_vl;
+	vl = vcpu->arch.max_vl[ARM64_VEC_SVE];
 
 	/*
 	 * Responsibility for these properties is shared between

-- 
2.47.3


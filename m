Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB224446F5;
	Thu,  9 Jul 2026 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622473; cv=none; b=byCFWGtpGJA63KsrUfV0u2NUKwGF+VMzzXiAiP+AfZEvEPCMkk3AdkE4ZJ/Zd3xI6knDHx1bWoWCXQhux9tqX2VGTZMC5I7u+cFrs75i2vI8INsYKKqvPTm7Ce3a/yHA4yfZ+BfYlgr62QHxPknnu5MWnF7hhXStYqZZkCLf+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622473; c=relaxed/simple;
	bh=ZaSkLrGVVhyGTgWWCPCFYM3SkrZ1IhJvGyclXLH2+Gk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ToEfIHnGOCnJ+YYwSSjnmX2XzcRDq4pRyQJ7nM8UrHZzodKHZ7q0bSosh0dDEXfiOFSd7C/pGQYHrgiimP2XgqjZs43lq59hpzZTurQsDfjoRDD0J7kZmr94xWl0LxXw47QIeHAfODYVBoHMmegp1quCR6dbb5/a/JKlyOb1Cpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muKt2TjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muKt2TjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFAC1F00A3D;
	Thu,  9 Jul 2026 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622469;
	bh=lzhFuYQxcZJAxYenXQo/+7l7I2GvDTvsQr8LtVTrZj8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=muKt2TjL5F7NLrf5fE+Byxp4o4H5Y4QVgD5wAqCuGyPkfJI25zPD3PWemp750dcAG
	 D9sCDwiqupXpabwhmA8NVP21NeZfPRLRYYGD1QKLVSMXtKSB94OfrlPG5mbUmiCdJx
	 YC69hNQWlw5sNQHLjw6Z8JA1WS4jnsM2JETCD7VYl8hwY0edugflRQChatD3RlCJGY
	 b8hgDPWlYgLLuWx+iYP0cONX0Y+lGACZ4eTS7ka52niGt0jvEtgbtH6onXuPwQt2EC
	 GLJbwBN3Jth9h2VwpdFRrIJpQ/BlmA45nCUpfe6UaWhppKj6nDcM9+DyMJxI0/80dY
	 CLzp9grU51WTQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:35 +0100
Subject: [PATCH v12 14/29] KVM: arm64: Implement SME vector length
 configuration
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-14-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9943; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ZaSkLrGVVhyGTgWWCPCFYM3SkrZ1IhJvGyclXLH2+Gk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+r1A3kP0rV28MJAQYyKg/tnLz9XTE6wQjE5u
 JrJALX9iO+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q9QAKCRAk1otyXVSH
 0BWJB/91oDGduFQsOrJF58cW0d/jKRZVGgp/CX+r2QysiBXzh7I4JzKGzZosqY4krmOVxJIo7nn
 bC80gjkSqG0iWyf8FP3SUZcf1bOIs04j8NXuSCgvCzyuKFVMUvzHq17Htb2xKDK8JBxsVSIxW5p
 iS5uuj6KIlzb6qwn5USwBMyx/snvOMJtEwT9ahywcL4pOj42b53xu0K1O0zoC7WerEwfCpbvm3p
 wb2Mlo0RGvi2Szifd0Oml9IqSKHHdz8fOszHv7FJX+0Du6IZaX5g0IM2PkV496lYl6kIxZIRojQ
 w/G/mDFZBqxOTZSZ/UJFhUU57xL+FnSTZ0z1GVs5Iy0dklno
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME implements a vector length which architecturally looks very similar
to that for SVE, configured in a very similar manner.  This controls the
vector length used for the ZA matrix register, and for the SVE vector
and predicate registers when in streaming mode.  The only substantial
difference is that unlike SVE the architecture does not guarantee that
any particular vector length will be implemented.

Configuration for SME vector lengths is done using a virtual register as
for SVE, hook up the implementation for the virtual register.  Since we
do not yet have support for any of the new SME registers stub register
access functions are provided that only allow VL configuration.  These
will be extended as the SME specific registers, as for SVE.

Since vq_available() is currently only defined for CONFIG_SVE add a stub
for builds where that is disabled.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h   |  1 +
 arch/arm64/include/asm/kvm_host.h | 19 +++++++++-
 arch/arm64/include/uapi/asm/kvm.h |  7 ++++
 arch/arm64/kvm/guest.c            | 80 +++++++++++++++++++++++++++++++--------
 4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 0a3299142683..c3da16fdb158 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -542,6 +542,7 @@ static inline int sve_max_vl(void)
 	return -EINVAL;
 }
 
+static inline bool vq_available(enum vec_type type, unsigned int vq) { return false; }
 static inline bool sve_vq_available(unsigned int vq) { return false; }
 
 static inline void sve_user_disable(void) { BUILD_BUG(); }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5e071381ae5b..858341eb1e8f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -855,8 +855,15 @@ struct kvm_vcpu_arch {
 	 * low 128 bits of the SVE Z registers.  When the core
 	 * floating point code saves the register state of a task it
 	 * records which view it saved in fp_type.
+	 *
+	 * If SME support is also present then it provides an
+	 * alternative view of the SVE registers accessed as for the Z
+	 * registers when PSTATE.SM is 1, plus an additional set of
+	 * SME specific state in the matrix register ZA and LUT
+	 * register ZT0.
 	 */
 	struct arm64_sve_state *sve_state;
+	struct arm64_sme_state *sme_state;
 	enum fp_type fp_type;
 	unsigned int max_vl[ARM64_VEC_MAX];
 
@@ -1101,7 +1108,15 @@ struct kvm_vcpu_arch {
 /* KVM is currently emulating an L2 to L1 exception */
 #define IN_NESTED_EXCEPTION	__vcpu_single_flag(sflags, BIT(9))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
+#define vcpu_vec_max_vq(vcpu, type) sve_vq_from_vl((vcpu)->arch.max_vl[type])
+
+#define vcpu_sve_max_vq(vcpu)	vcpu_vec_max_vq(vcpu, ARM64_VEC_SVE)
+#define vcpu_sme_max_vq(vcpu)	vcpu_vec_max_vq(vcpu, ARM64_VEC_SME)
+
+#define vcpu_sve_max_vl(vcpu)	((vcpu)->arch.max_vl[ARM64_VEC_SVE])
+#define vcpu_sme_max_vl(vcpu)	((vcpu)->arch.max_vl[ARM64_VEC_SME])
+
+#define vcpu_max_vl(vcpu) max(vcpu_sve_max_vl(vcpu), vcpu_sme_max_vl(vcpu))
 
 #define vcpu_sve_zcr_elx(vcpu)						\
 	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
@@ -1120,7 +1135,7 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
+#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl(vcpu_sve_max_vl(vcpu))
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 83af99ca4e1b..15d53300914b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -354,6 +354,13 @@ struct kvm_arm_counter_offset {
 #define KVM_ARM64_SVE_VLS_WORDS	\
 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
 
+/* SME registers */
+#define KVM_REG_ARM64_SME		(0x17 << KVM_REG_ARM_COPROC_SHIFT)
+
+/* Vector lengths pseudo-register: */
+#define KVM_REG_ARM64_SME_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SME | \
+					 KVM_REG_SIZE_U512 | 0xfffe)
+
 /* Bitmap feature firmware registers */
 #define KVM_REG_ARM_FW_FEAT_BMAP		(0x0016 << KVM_REG_ARM_COPROC_SHIFT)
 #define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2370bb0ad94e..48e6b500f531 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -310,22 +310,20 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
 #define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
 
-static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+static int get_vec_vls(enum vec_type vec_type, struct kvm_vcpu *vcpu,
+		      const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
 	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
-	if (WARN_ON(!sve_vl_valid(vcpu->arch.max_vl[ARM64_VEC_SVE])))
+	if (WARN_ON(!sve_vl_valid(vcpu->arch.max_vl[vec_type])))
 		return -EINVAL;
 
 	memset(vqs, 0, sizeof(vqs));
 
-	max_vq = vcpu_sve_max_vq(vcpu);
+	max_vq = vcpu_vec_max_vq(vcpu, vec_type);
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
-		if (sve_vq_available(vq))
+		if (vq_available(vec_type, vq))
 			vqs[vq_word(vq)] |= vq_mask(vq);
 
 	if (copy_to_user((void __user *)reg->addr, vqs, sizeof(vqs)))
@@ -334,18 +332,16 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
-static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+static int set_vec_vls(enum vec_type vec_type, struct kvm_vcpu *vcpu,
+		       const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
 	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
 	if (kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM; /* too late! */
 
-	if (WARN_ON(vcpu->arch.sve_state))
+	if (WARN_ON(!sve_vl_valid(vcpu->arch.max_vl[vec_type])))
 		return -EINVAL;
 
 	if (copy_from_user(vqs, (const void __user *)reg->addr, sizeof(vqs)))
@@ -356,18 +352,18 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (vq_present(vqs, vq))
 			max_vq = vq;
 
-	if (max_vq > sve_vq_from_vl(kvm_max_vl[ARM64_VEC_SVE]))
+	if (max_vq > sve_vq_from_vl(kvm_max_vl[vec_type]))
 		return -EINVAL;
 
 	/*
 	 * Vector lengths supported by the host can't currently be
 	 * hidden from the guest individually: instead we can only set a
-	 * maximum via ZCR_EL2.LEN.  So, make sure the available vector
+	 * maximum via xCR_EL2.LEN.  So, make sure the available vector
 	 * lengths match the set requested exactly up to the requested
 	 * maximum:
 	 */
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
-		if (vq_present(vqs, vq) != sve_vq_available(vq))
+		if (vq_present(vqs, vq) != vq_available(vec_type, vq))
 			return -EINVAL;
 
 	/* Can't run with no vector lengths at all: */
@@ -375,11 +371,27 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return -EINVAL;
 
 	/* vcpu->arch.sve_state will be alloc'd by kvm_vcpu_finalize_vec() */
-	vcpu->arch.max_vl[ARM64_VEC_SVE] = sve_vl_from_vq(max_vq);
+	vcpu->arch.max_vl[vec_type] = sve_vl_from_vq(max_vq);
 
 	return 0;
 }
 
+static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	return get_vec_vls(ARM64_VEC_SVE, vcpu, reg);
+}
+
+static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	return set_vec_vls(ARM64_VEC_SVE, vcpu, reg);
+}
+
 #define SVE_REG_SLICE_SHIFT	0
 #define SVE_REG_SLICE_BITS	5
 #define SVE_REG_ID_SHIFT	(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS)
@@ -533,6 +545,40 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
+static int get_sme_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (!vcpu_has_sme(vcpu))
+		return -ENOENT;
+
+	return get_vec_vls(ARM64_VEC_SME, vcpu, reg);
+}
+
+static int set_sme_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (!vcpu_has_sme(vcpu))
+		return -ENOENT;
+
+	return set_vec_vls(ARM64_VEC_SME, vcpu, reg);
+}
+
+static int get_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
+	if (reg->id == KVM_REG_ARM64_SME_VLS)
+		return get_sme_vls(vcpu, reg);
+
+	return -EINVAL;
+}
+
+static int set_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	/* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
+	if (reg->id == KVM_REG_ARM64_SME_VLS)
+		return set_sme_vls(vcpu, reg);
+
+	return -EINVAL;
+}
+
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	return -EINVAL;
@@ -711,6 +757,7 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_FW_FEAT_BMAP:
 		return kvm_arm_get_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
+	case KVM_REG_ARM64_SME:	return get_sme_reg(vcpu, reg);
 	}
 
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
@@ -728,6 +775,7 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_FW_FEAT_BMAP:
 		return kvm_arm_set_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
+	case KVM_REG_ARM64_SME:	return set_sme_reg(vcpu, reg);
 	}
 
 	return kvm_arm_sys_reg_set_reg(vcpu, reg);

-- 
2.47.3


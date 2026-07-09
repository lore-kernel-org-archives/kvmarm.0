Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE87437478;
	Thu,  9 Jul 2026 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622498; cv=none; b=VHX3/UOuUH7Vv/0nCOI/QirmZ4pf4rZ4he6Pv7xOZgLoRjG0OVgPWweiVZRrrAfEJW5vqXZGljVNfFpnGTJzEBwoTsDgNzYbIqHFgZVNmzn7sGZV0h61ZtFQ6sSPLigJW5T2SSuMVFwTsiCmG+kUUbTL9NmzhTuJbJtu42ZmOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622498; c=relaxed/simple;
	bh=xLxlJPLqDSuT3BzgbokMn0PxDYZwCK7AxD2XRKqXdeI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Is0l2ExgKKhOcaZ0yZEbTMj9kL8ri8D+SQh5TsNu1FngHxoAJAZNlBbXbAXc3C+W4A+OruGNIcZP4658nNcNrVsb6/OFM6iAzQz7fNqdK7Xm0pWOdGjgExGouKbJTU/2+4RTBmxDcDPX3ty6XvycCzDpwB0nFH3TUeovuRvy4k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zda6x0mJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zda6x0mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FE1F000E9;
	Thu,  9 Jul 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622497;
	bh=uWFRDM+Io32xW+VhypJpKi1NlK0gVsSgLCMgEKdC5HI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zda6x0mJsPBLFasezouRcdvrKMHgutAyMXmesY7G3JWWfhrVnNiB/Ao/y0OC8d1JJ
	 PQoNkXGZlPFxheKISW4JnlHU4OU9ubF0cac3Q4iqO05RepuZH669mMtM0FOSdhqz2L
	 jBBUWwq0uxItW07baKK5UuicvXZpS64YoYJzmuVOSRGZ+z5lwzs4kRR6Rf9IVye+eY
	 LFdJL4rlGGptGa9hX8LrR+p6tl94B/Pi4FEw8A/BgeekmBrLSs/RRxdG9bJTDyLBxo
	 dlCN238lYZTUAX/tpO5kOXDMglgREoFj/onmTvWh0TJEBRR0A/7sZLzvmJbdCjIgki
	 pjttZk+o/ZK2w==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:41 +0100
Subject: [PATCH v12 20/29] KVM: arm64: Flush register state on writes to
 SVCR.SM and SVCR.ZA
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-20-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5358; i=broonie@kernel.org;
 h=from:subject:message-id; bh=xLxlJPLqDSuT3BzgbokMn0PxDYZwCK7AxD2XRKqXdeI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+r5F8QipAIMBO6Q09sPsqE2U7PJLdF3m/V0T
 LibAnM2wEWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q+QAKCRAk1otyXVSH
 0OQSB/0XoS5Y2E+udp8ouzf4dEN0zfUsqxind+iDfMKL78nZKhP9Ee/HpIUI3ya+0cM1+Q/KmQB
 Xtpd9j5A+LjVyAixjZLzcgpXDGRI/B3HHdGVUIhJIzLuzfL4JzzYwZO1DTdhi9jIVQ4eTsFAHB3
 /Ks5h7d3feiDUoRJD9j/K5lo50oDpFCrZaUPSkfRM1r5J9Zwq5828p0BNClc+zM2Dya5ZXgJbL9
 kWCSQvJySzBbUI7mLCcw1baVMfHISLMaWXsGDTSuohcNoj+jSh0qI3IdHVnaaJ9J7RpMdCeCljQ
 1x7YBFiCnv3nnlrTTrx0hWT3xOUFHkqdF05poMD4zyJdJCQQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Writes to the physical SVCR.SM and SVCR.ZA change the state of PSTATE.SM
and PSTATE.ZA, causing other floating point state to reset. Emulate this
behaviour for writes done via the KVM userspace ABI.

Setting PSTATE.ZA to 1 causes ZA and ZT0 to be reset to 0, these are stored
in sme_state. Setting PSTATE.ZA to 0 causes ZA and ZT0 to become inaccessible
so no reset is needed.

Any change in PSTATE.SM causes the V, Z, P, FFR and FPMR registers to be
reset to 0 and FPSR to be reset to 0x800009f.

Rather than introduce a requirement that the vector configuration be
finalised before writing to SVCR we check for this before updating the
SVE and SME specific state, when finalisation happens they will be
allocated with an initial state of 0.

Similarly in order to avoid ordering requirements between finalisation
and writes to the ID registers we always allocate space for ZT0 if the
hardware supports it, this is 512 bytes per vCPU.  The overwhelming
majority of practical systems with SME are expected to want use SME2,
there is very little practical reason to disable it other than for
feature testing, and the additional complexity seems more likely to lead
to bugs than deliver practical benefits.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h   |  2 ++
 arch/arm64/kvm/sys_regs.c         | 30 +++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35339cbf23f9..b78c039cb5ec 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1142,6 +1142,34 @@ struct kvm_vcpu_arch {
 
 #define vcpu_sve_state_size(vcpu) sve_state_size_from_vl(vcpu_sve_max_vl(vcpu))
 
+#define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
+
+#define sme_state_size_from_vl(vl, sme2) ({				\
+	size_t __size_ret;                                              \
+	unsigned int __vq;                                              \
+									\
+	if (WARN_ON(!sve_vl_valid(vl))) {                               \
+		__size_ret = 0;                                         \
+	} else {                                                        \
+		__vq = sve_vq_from_vl(vl);                              \
+		__size_ret = ZA_SIG_REGS_SIZE(__vq);                    \
+		if (sme2)                                               \
+			__size_ret += ZT_SIG_REG_BYTES;			\
+	}                                                               \
+									\
+	__size_ret;                                                     \
+})
+
+/*
+ * Always provide space for ZT0 to avoid ordering requirements with ID
+ * register writes and vector finalization.
+ */
+#define vcpu_sme_state_size(vcpu) ({					\
+	unsigned long __vl;						\
+	__vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];			\
+	sme_state_size_from_vl(__vl, system_supports_sme2());		\
+})
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4b96449e0ffa..b434320de1a7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1108,6 +1108,8 @@
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
 
+#define FPSR_RESET_VALUE	0x800009f
+
 #ifdef __ASSEMBLER__
 
 	.macro	mrs_s, rt, sreg
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c43cb1b8fb68..e8d3eceb0124 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1015,6 +1015,34 @@ static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static int set_svcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	u64 old = __vcpu_sys_reg(vcpu, rd->reg);
+
+	if (val & SVCR_RES0)
+		return -EINVAL;
+
+	if ((val & SVCR_ZA) && !(old & SVCR_ZA) &&
+	    kvm_arm_vcpu_vec_finalized(vcpu))
+		memset(vcpu->arch.sme_state, 0, vcpu_sme_state_size(vcpu));
+
+	if ((val & SVCR_SM) != (old & SVCR_SM)) {
+		memset(vcpu->arch.ctxt.fp_regs.vregs, 0,
+		       sizeof(vcpu->arch.ctxt.fp_regs.vregs));
+
+		if (kvm_arm_vcpu_vec_finalized(vcpu))
+			memset(vcpu->arch.sve_state, 0,
+			       vcpu_sve_state_size(vcpu));
+
+		__vcpu_assign_sys_reg(vcpu, FPMR, 0);
+		vcpu->arch.ctxt.fp_regs.fpsr = FPSR_RESET_VALUE;
+	}
+
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
+	return 0;
+}
+
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
@@ -3612,7 +3640,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    CTR_EL0_DminLine_MASK |
 		    CTR_EL0_L1Ip_MASK |
 		    CTR_EL0_IminLine_MASK),
-	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
+	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility, .set_user = set_svcr },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,

-- 
2.47.3


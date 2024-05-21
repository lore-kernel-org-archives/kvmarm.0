Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B12282EE
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309461; cv=none; b=k0o8YmNPW5SyGkcCdO8gJXSi1pzsHFWEDvrTiXDaNsHQ6A64acMHHyCZXJ/pQfjN3XZ1Jy22PCG1UXpSjbJFfI8HwX5zHdCdYncXiGfdEdEXvMcgqIY/Rsf228+DK7s9k03eUEZNIz5cWYUQ8al/K0OCdIeR5FU/60SFvDFje0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309461; c=relaxed/simple;
	bh=sG5cPVqQKKZ2UrUY0sXSh/kdciG0WljdB70LNukzjWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cdreNAIyWlq1rGapG97xI5WEVHGksLNT/CcqbdC7elpUXj7biP1av4x0UcgFmO23EHROaHJAM/GD6JnRRpNKfeOKoflwutx2m9chjpwZDsH1PWvc6rbi45WKkFpUyjTfyahsnOo+QebhifGR9x424yHd1KLUjg9WuJ+2JPIBIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSRkOBa9; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSRkOBa9"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-351bd229b88so6854275f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309458; x=1716914258; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=85bGMSlowZzBfuCbPakfKoUPdy/gnSBKkaxQDB/2giE=;
        b=GSRkOBa99jKB8D2aIG3w1dhtApdQwIjgWWNtxRc964vAZxIOay0QUOg+mv2L3UEuPO
         mFouVuxLduBuU9Cg2AO2GB3MmI7DL6pCVtdNoXhIwjHpSy7Bg6Rk24yMP7A2zUnrD9EX
         cdSmiiR9Rq3pO/vzJIXDT+jITIZRQ+LR3ZaWUpgMiLJSdcy9mW3P79cN26mFWWOhEZnM
         Bp1YSXfafaU+F2Ri0AJOktRr1u5IlvhJtDqIE2rztQLi5WmrjrRjA6Zj7IEplLDte+JZ
         iFijN4asPFCFKVHwt3we/mQ0fAPyEdOpyC+Mw2QIL2iV6f55cs3dwtuFWmappjiJitvC
         zmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309458; x=1716914258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85bGMSlowZzBfuCbPakfKoUPdy/gnSBKkaxQDB/2giE=;
        b=UBhFeUxDwjP5OQy8xw48zfktgwlDy+nVIuPcDJ3j+CoyqULNxDBAiYf9iX8pN43cpA
         sggq2/XJWAepDw5VIQSMKqzKoIFyEiRSjKkMEIItF4wdrivV7M+2ygl4b4qGjQ7bWVSd
         HP4wd4FEvmo3PKdIEF39zBmywugRD34pfzTBI4O10tkyFqyF9LIMZq1xDmoZDh1Mr4Dk
         DQ6wICi4gj2GhTUenuhzuWXlCmZtaihYqZoyjn+UE6UMVpxdxWulZ4KKlMwGSgApamZd
         wgpuPDjLBxlnJUNbPwKibs0xwHwf3nXwmk7hzQMlsrBin3UlRixSg0e+a8jkk7NB7YJs
         5fsg==
X-Gm-Message-State: AOJu0YyuEXkYXE7ZDbuuM8suZQWWI+XZQyqgFlGSVOYbsMENgeRo8Hco
	CUl2SHJ776cNMVDVuI1TFkEfDihCHCbN+Ws7fTgz79YuR1kMHpNx1t1cBBdc2q8mTxp+iF6E0Yl
	8d0NQA+ni+EuTwDka6es8aeER49PbPyHEy7qYOmZ0w7+G/KYbES5/ztQA9srX69J44eqz3dnMaS
	8zVCRb18/u4FTYQnZufbSvDMVn/PY=
X-Google-Smtp-Source: AGHT+IHKdsMsZ+FaU8d6GdgtiXG2/INcnjKqmptSmAvFqIqDOa30uJWlvX8TRNKfKGO7lkWH4hCDRZZYSA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e806:0:b0:354:c0a6:2824 with SMTP id
 ffacd0b85a97d-354c0a62abemr16962f8f.7.1716309457526; Tue, 21 May 2024
 09:37:37 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:19 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-7-tabba@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

When running in protected mode we don't want to leak protected
guest state to the host, including whether a guest has used
fpsimd/sve. Therefore, eagerly restore the host state on guest
exit when running in protected mode, which happens only if the
guest has used fpsimd/sve.

As a future optimisation, we could go back to lazy restoring
state at the host after exiting non-protected guests.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 53 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 16 +++++++-
 4 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1897b73e635c..2fa29bfec0b6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -320,6 +320,16 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static inline void __hyp_sve_save_host(void)
+{
+	struct user_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			 &sve_state->fpsr);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
 
 /*
@@ -356,7 +366,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/* First disable enough traps to allow us to update the registers */
 	reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
-	if (sve_guest)
+	if (sve_guest ||
+	    (is_protected_kvm_enabled() && system_supports_sve()))
 		reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	cpacr_clear_set(0, reg);
 	isb();
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index b07d44484f42..f79f0f7b2759 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -23,20 +23,66 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
+{
+	__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr);
+	sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+}
+
+static void __hyp_sve_restore_host(void)
+{
+	struct user_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			    &sve_state->fpsr);
+	write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
+}
+
+static void fpsimd_sve_flush(void)
+{
+	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+}
+
+static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		return;
+
+	cpacr_clear_set(0, (CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN |
+			    CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN));
+	isb();
+
+	if (vcpu_has_sve(vcpu))
+		__hyp_sve_save_guest(vcpu);
+	else
+		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
+
+	if (system_supports_sve())
+		__hyp_sve_restore_host();
+	else
+		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
+
+	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+}
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
+	fpsimd_sve_flush();
+
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	hyp_vcpu->vcpu.arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
@@ -54,10 +100,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
 	unsigned int i;
 
+	fpsimd_sve_sync(&hyp_vcpu->vcpu);
+
 	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
 
 	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
-	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 25e9a94f6d76..feb27b4ce459 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -588,6 +588,8 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	if (ret)
 		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
 
+	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 019f863922fa..5bf437682b94 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -184,7 +184,21 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
-	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	/*
+	 * Non-protected kvm relies on the host restoring its sve state.
+	 * Protected kvm restores the host's sve state as not to reveal that
+	 * fpsimd was used by a guest nor leak upper sve bits.
+	 */
+	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
+		__hyp_sve_save_host();
+
+		/* Re-enable SVE traps if not supported for the guest vcpu. */
+		if (!vcpu_has_sve(vcpu))
+			cpacr_clear_set(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN, 0);
+
+	} else {
+		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
-- 
2.45.0.215.g3402c0e53f-goog


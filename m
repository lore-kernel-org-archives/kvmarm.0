Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FF77118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417750; cv=none; b=ZzH7mknZUrsLa1I+g0vzzgFK+VwuG7AcJle1f8S49/LPZwsz9zEEcAvdb6gWlaIBZwfNGrADTfz8ZC5rUimCY/uZmm66lqJdh9VbnOeNQp7viWpGeoyHWDCXpfPJ/9yXvTAQkY6SSh/fbOMMQef5h6GJ+ihqwsHsxxo76VlcFMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417750; c=relaxed/simple;
	bh=8CCJ++ks8hfCp4+zHwEdu3ucPNQQruW3dyCVWZHyYlU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WKGg9mPkjDf8J49NfPNy6XjV4fk10dIJJAxuK7tgoeXjs7jxIKjNtuRdEbJ5Phw57TDo/x4wNYaIh0VCZNoPyS7nshukmzpAOHdFXOr740kH0mrDU9bCNhHkUB+hNPClvw+VuRsahRDydUisMp4pojapakiYMI1h2vpa/76RYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4SURuzOP; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4SURuzOP"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa72779f04so5132867276.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417748; x=1718022548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FEyeJmL4xqXhWC0VUASRrOzcgUp+0rDcqtc/2hrJXG8=;
        b=4SURuzOPIrxw2U7PrA81F/fNhSR0t65VRUg5OKim5M4FHdlGBrqKyOaMetJPuGcHC1
         VkAzBGFpqjZfW8qdCg3cWyP41oeVrqrfuLvIzA3SOflBVaUJRix/78kT1lWwFoYnbn8w
         xzk+ON2G0bWnAtQwgmY2em2KfJJZyQmy0Dq8k6eAFISge8r0O5KX6avzlqr1xtHa63XC
         M8+/lRCh7XImTrm3ENAqcnMs9MBVx2ZYeNtjdiDvDgpMMnih4cSEReb++j4AUVXJ/c2I
         uaVqXEdae4WDMGn69GH/COp8yPmirxjMcbM4kGZPC5tQ+x+fJxycp3YNM+qn9gLQHXPy
         WgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417748; x=1718022548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEyeJmL4xqXhWC0VUASRrOzcgUp+0rDcqtc/2hrJXG8=;
        b=MK3fIV7jYA9UupwbiQfDbwYi8yWF1ZF8zkSaZ6imwlJqwHM3KnEPEPQdQJQfbqEWJ8
         ern5wp00t5vpGQxKxn0Pn1Eln/w/5G4d+Z1b1YkG5rqv3GVc6E73n95YJzS2YJEOLnkI
         mTzBzDD9srab2bbWogoBQZu1SR7GHJ1g40a/Oin/i8IHcLgjUGvEoJKDTs0qa50UbLoJ
         BjkUoYGypsTREAVaGRCUOlXs+1Acc0P3nhwFxtGrgwdwoNSTBlCMd6Vnhndx80587oKO
         Aphfs8o5LCy2Kt5MTaugmSz6aJGrnm+6G4cLhR+xJjacvMxZ1AnCWuz03wY5mk6mcy8n
         X6Gg==
X-Gm-Message-State: AOJu0Yz2Coe+kUyy69v+xAssWkMRW/BAjoJb1yy0kcvgjZ2qocRG/3oh
	O/6Z5ir2sjLWsA8oPaZAqunwLk+I4HCmn3xZrpYvH1hg0XAR17U2mMwetRIgH4IcU0JBMcU+ICD
	o9i+O+KikbMdOlyAKOXdf3nHobm3i7KEyugfioK33EyyLcjlAqx2r+HBcLu+oBf4CkFIj+/MYvv
	YPHr8492swxIv3qwhI2M/CJqXwH/s=
X-Google-Smtp-Source: AGHT+IFsSDTQlCEI6ObxeycD35oNc21aG50lHWcaHx+Nnpd5PbFHCna4d1JhqEZdh3pKE2edG+su3pPFmg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1004:b0:dee:60e9:69f4 with SMTP id
 3f1490d57ef6-dfa73e30d5bmr2308756276.10.1717417748036; Mon, 03 Jun 2024
 05:29:08 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:48 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-7-tabba@google.com>
Subject: [PATCH v4 6/9] KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
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

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 67 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 16 +++++-
 4 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9b904c858df0..0c4de44534b7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -321,6 +321,17 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static inline void __hyp_sve_save_host(void)
+{
+	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			 &sve_state->fpsr,
+			 true);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
 
 /*
@@ -355,7 +366,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (sve_guest)
+	if (sve_guest || (is_protected_kvm_enabled() && system_supports_sve()))
 		cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
 	else
 		cpacr_clear_set(0, CPACR_ELx_FPEN);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f71394d0e32a..bd93b8a9e172 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -23,20 +23,80 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
+{
+	__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+	/*
+	 * On saving/restoring guest sve state, always use the maximum VL for
+	 * the guest. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
+	 */
+	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+}
+
+static void __hyp_sve_restore_host(void)
+{
+	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	/*
+	 * On saving/restoring host sve state, always use the maximum VL for
+	 * the host. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) host VL.
+	 *
+	 * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
+	 * supported by the system (or limited at EL3).
+	 */
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			    &sve_state->fpsr,
+			    true);
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
+	cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
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
+	/* Limit guest vector length to the maximum supported by the host.  */
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
@@ -54,10 +114,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
index 019f863922fa..bef74de7065b 100644
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
+			cpacr_clear_set(CPACR_ELx_ZEN, 0);
+
+	} else {
+		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
-- 
2.45.1.288.g0e0cd299f1-goog


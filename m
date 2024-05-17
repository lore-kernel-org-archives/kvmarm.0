Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C023524A5
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951915; cv=none; b=TFJKNVEpCtSFB84T9vNNBB0iFdVLGnzRUTuWM++9N+TfcM/fMSlyjGDrP4BoYoYlEBI8P7qSnkvB10FKlcDnnfGn0mHz9MDbI/mHfLAfkutkO6Zce264VXEOSOITyfT+m+OaNTXOulEwvZO88ysyRWkXwY8Gvd5V8o1chKynYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951915; c=relaxed/simple;
	bh=HJSSCrAZDaz+jaG/6Wk3nueGQkEiwqLAmgJwrk43k1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ThsKH5O9w5AR7BT7tFiiAoslvGLCXMu1A5hx6w7tsNMLdjOHgfBvywc9cXtBkvCHMuiJ1iIFizjZUKpJuc8/iSGQjOlPybVJrE8KH4QTe0uxfii4KTtyQT137hQ8xGs4xyX4pnof7NAg/vt2/tMAXoALTRovL//T4Px88V0p5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nsB4xWAP; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nsB4xWAP"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4202c2d397aso7615995e9.0
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951912; x=1716556712; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1jcmCioaU47BQUqNj4Io8ELy38KlZ7JhNNIg/6owaow=;
        b=nsB4xWAPmoEGboLk0cmaElEK4dNHeqEB3g90WAJKGpK09aJE3ujyhu5OQ+C2JHulsr
         tnEoTgmVWjKE339NEwb4fMm+FMUR2HlB8CqUD2m/10gW9LSmudkliZewf7QW6LtXaNLy
         0lQPgx7l2X6dsG/v3L9nzhvR2zmPPtEAJy9xFjDXe5T0PW/eOum6au/sBxO5+GI4VFrL
         qBiYa32IZpzmhdD8xUIYmTUjNdz/P/ZbuTakmHP+wU0NGjJfwXbDHZK80R6HY2SbPWhB
         Hg8SBbYjeAvVny5sv6dALd/sdU8B4j8HvhefQneN1tTR0ZkOKKSln+4yTaS98+bXsZZz
         fzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951912; x=1716556712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jcmCioaU47BQUqNj4Io8ELy38KlZ7JhNNIg/6owaow=;
        b=DVYTv/L4TzrLUdgTktc/2yRrW3hnE6GMkFxTaMh8wsHlcqfF8zjhXIKXYxcWfSmw0B
         cuX7RW6YCt1q+i7J2Q4OBnw5vm5I8XSYG1jgU4Onx7Q7X5Jf++NVQ4KiVgl2hotY5EOs
         c/k13zxOWi0UgzKKH+zbs980rMiUsI1g+z54kTR8T/uVXPaex2DNW/mBcXXogw57Fn+L
         T81+zhr2yr70m7GI2u7j1Xn8HOBhk+scBohUO/rw1Vekil2BGMJxuAs/kU5V2OwsY5jS
         AJzCk+4x6W0LaTDF9dyqSJYxz0hDJwoe+IAV/G51Al7siP9E1MezdYSyKAx2bTxjyZ3E
         YU5g==
X-Gm-Message-State: AOJu0Yz+P+RA/CXM/+OvRxTc999YYwPTLBtHVKQ6pPjEjpEGgzrfVGNn
	eQpxPHbaChHhQvUY/X1jZ8BDjaWQIfOA47Z9qDE6OetPSBVHgjk5QXOBIhdEZFcn6uKhxaT9/6P
	S6RBclBW7zeekQ8xMZUMQc1Rg2lsdv2qy6ELC4t/3wb/am3I2E18VhP7F7cHMIdPbBGnifOD23L
	3ZZ0gXYFYSeYm5KYLF3HuXWvja0Nc=
X-Google-Smtp-Source: AGHT+IGTq1aJJgU+6nzIj7xultzS3Ogaer8BHAweErlnBC7JlTgGmEujzdR+BuxGsFdtodwKy+Spfau0fg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:202:b0:41e:a768:1e5 with SMTP id
 5b1f17b1804b1-41fead6ac92mr1164305e9.8.1715951911134; Fri, 17 May 2024
 06:18:31 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:13 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-7-tabba@google.com>
Subject: [PATCH v1 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
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
 arch/arm64/kvm/hyp/include/hyp/switch.h | 10 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 57 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 18 +++++++-
 4 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d15272445db2..4dc620499e5d 100644
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
 static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu);
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d5c48dc98f67..8b9556f5dee3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -23,20 +23,70 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
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
+	if (has_hvhe())
+		sysreg_clear_set(cpacr_el1, 0,
+				 (CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN |
+				  CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN));
+	else
+		sysreg_clear_set(cptr_el2, CPTR_EL2_TZ | CPTR_EL2_TFP, 0);
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
 
@@ -54,10 +104,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
index 935f3db245e9..a2e1419f0f0f 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -114,7 +114,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __deactivate_fpsimd_sve_traps(struct kvm_vcpu *vcpu)
 {
-	bool clear_sve_traps = vcpu_has_sve(vcpu);
+	bool clear_sve_traps = vcpu_has_sve(vcpu) ||
+			       (is_protected_kvm_enabled() && system_supports_sve());
 	u64 reg;
 
 	if (has_hvhe()) {
@@ -205,7 +206,20 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
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
+		/* Re-enable SVE traps for guests that do not support it. */
+		if (!vcpu_has_sve(vcpu))
+			sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TZ);
+	} else {
+		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


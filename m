Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BE119D064
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797330; cv=none; b=nttLcSKRJZlOe1dXw7tK0Hq6wg7CYo6vZZwWYh+hfe4h9zqxOpCStb4saDAKpTCgpGs0DQDJqUskPq6xwrKFgTEB+9QkgjnZBBOIgjt4ng0pWunJ6So/zppB95JUyHbgh5chhAmnsFuNryP5tf+bGArXo1WnhWBcNWcx/zqb2WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797330; c=relaxed/simple;
	bh=ef82yeOA+Ze9F6wwdfLk9E6Y/ZKG2J2drDSuEvbFgVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b6la4owuQkluE/1najkVNS0dX/5VHtbZekzDkXjSHRuHeBPe+JvqAcRSLNEEi6KBOa5lR5RIOVsiwwcKNnGsvcN/JSDecTwfPj6t+UpVrMSzzCkxAijAiAwOC1G0KkSQA0GcebQuzJYimX838R7HyjjUAfGCfvGOWN5wS2rmWTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=30Wfd1Gn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="30Wfd1Gn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a90fecfeso6153805e9.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797327; x=1733402127; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=57d11+Vl+NAgbTWF6Laovcj658EA1KvcaSswzHFN5Sc=;
        b=30Wfd1Gnxd/YsOYoJxMjbLNDBRyCIepaHLwDcjeXkzYmEIpegh597+gA1xhALshSxJ
         pKuEPx9dlGWC4UArKZkEjYfqLvcQBfsg2P70WoYFAPzZ3PGSovVEc33X3kgDlz0OwLXu
         BUj8tzOtYQl/JnI/7Wi03hCS/n1M4DB7IQRlDEqwwmU+HRcJna3WyL39mxYXetpy0Ahm
         eaRa/2fSiqniyYd2B8Jt7n8acg3jDz4YM56uNqb+DfEFGyKWBbH8D4bFw78ZIi3RoyZY
         b60xN3W74Zo3N+S7lwWDmyw5E3b4l6nBSnkx88nnBky4k75FceHbUVfhCPd6CVQ/X8Ry
         5xFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797327; x=1733402127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57d11+Vl+NAgbTWF6Laovcj658EA1KvcaSswzHFN5Sc=;
        b=lp91zKcxLiCRdn4KEnI4Fk5aT8XH/17PAH8WbX4XDjzBh2S+mkAz6OHOTAjdA7oZdm
         iGOOabsoX5Ot/YRMmwmQCu533sMGrOK5bXV1EQto09US1SzSpdN6f+o77hNLMIcGE3VY
         6mIhiNUHW3/Qie4Bgr+IhzVTm33A90LpVwYqiCQyvc4EfQiCDcrJICw8Q0uEj1QHaFCG
         pxN9Vg3zstudqYzqgyM+RMZm/g4tM6XL1XrL8j49wLdFX+gju/l5ekudIf7P63WHglf0
         Msv8jd32xlzYpGfDWZLwEl9eTza//PeVKXcdtyBlNmSWDq25UrdjCdrJ0Q4IOTZkzAv+
         cgZg==
X-Gm-Message-State: AOJu0YwKGFtV1YnLhWNvMsxXp5GtkLbGh2796vgp0I1YdvwF1iVsbrd9
	OIkVF9vjC0FkuJLZx9jxrXxCMOcRF8XnsAsn48j9RFc7kOr3/ZwKJkmKUZuSeyD+5T//+WRLtKq
	61KUm53hsymwEuUiUM+XcHFxaD/roVexvLY+/WVdg7wC+8hCFE4lyPTQpL9S81FCo6RC7PC/VP9
	jPa+DLuaV6a/MlewBBj+Vi+lZ4PIQ=
X-Google-Smtp-Source: AGHT+IEr1xoBQ+AMfwaUDJbCQnvJc4u7kobWRqIBNJlAJlmGhT7c9r52bu+D34t0Rhg1fv/1GFQbpCtGCA==
X-Received: from wmsn30.prod.google.com ([2002:a05:600c:3b9e:b0:434:9ed7:8b97])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c07:b0:434:a4fe:cd71
 with SMTP id 5b1f17b1804b1-434a9dc50f1mr64327545e9.12.1732797327270; Thu, 28
 Nov 2024 04:35:27 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:05 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-6-tabba@google.com>
Subject: [PATCH v3 05/15] KVM: arm64: Initialize feature id registers for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The hypervisor maintains the state of protected VMs. Initialize
the values for feature ID registers for protected VMs, to be used
when setting traps and when advertising features to protected
VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 42 +++++++++++++++++--
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index d1e59b88ff66..69e26d1a0ebe 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -201,6 +201,7 @@
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 59ff6aac514c..4ef03294b2b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -381,6 +381,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
+	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
 
@@ -419,6 +420,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+
 	ret = pkvm_vcpu_init_traps(hyp_vcpu);
 	if (ret)
 		goto done;
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 59fb2f056177..1261da6a2861 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -204,8 +204,7 @@ static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
 	return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
 }
 
-/* Read a sanitized cpufeature ID register by its encoding */
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -240,10 +239,25 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	}
 }
 
+/* Read a sanitized cpufeature ID register by its encoding */
+u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+{
+	return pvm_calc_id_reg(vcpu, id);
+}
+
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		       struct sys_reg_desc const *r)
 {
-	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
+	struct kvm *kvm = vcpu->kvm;
+	u32 reg = reg_to_encoding(r);
+
+	if (WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags)))
+		return 0;
+
+	if (reg >= sys_reg(3, 0, 0, 1, 0) && reg <= sys_reg(3, 0, 0, 7, 7))
+		return kvm->arch.id_regs[IDREG_IDX(reg)];
+
+	return 0;
 }
 
 /* Handler to RAZ/WI sysregs */
@@ -448,6 +462,28 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+/*
+ * Initializes feature registers for protected vms.
+ */
+void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch *ka = &kvm->arch;
+	u32 r;
+
+	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return;
+
+	/*
+	 * Initialize only AArch64 id registers since AArch32 isn't supported
+	 * for protected VMs.
+	 */
+	for (r = sys_reg(3, 0, 0, 4, 0); r <= sys_reg(3, 0, 0, 7, 7); r += sys_reg(0, 0, 0, 0, 1))
+		ka->id_regs[IDREG_IDX(r)] = pvm_calc_id_reg(vcpu, r);
+
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+}
+
 /*
  * Checks that the sysreg table is unique and in-order.
  *
-- 
2.47.0.338.g60cca15819-goog


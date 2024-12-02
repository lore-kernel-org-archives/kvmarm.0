Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61F04C62B
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154477; cv=none; b=KpUBRn9BuV4xjNIqWB9vjJNfQgvw+yrFGMCzY03bkzcecId0SFub6HhfZfk8IcGKGMIDvEkNOweFWQvykO1FAjUleW6sewrJTcbUoGtcez8hOCFfAfrEonTLmfd/JEUMdbnheOrAoKVhsfaysG42arRzLBdS0PHUJq+TFhGpnZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154477; c=relaxed/simple;
	bh=ef82yeOA+Ze9F6wwdfLk9E6Y/ZKG2J2drDSuEvbFgVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GFn2Ij5c2S1UCOaN2ExXUw6zIzPnDeaJqHPbGStyJ7qTIJ434AvZYR+uAnDZCYIJiy98BNodeC7tqzFLtvaO/Rjp9ry/OnF4t0+QZwdxan2lC6s7RTT85yhpzjgAPpElFC/whr40s6/uHfxBSDGVpYZmsQuoFzYRQ5OTWME0nxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O5bTxwUT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O5bTxwUT"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a104896cso36172975e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154474; x=1733759274; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=57d11+Vl+NAgbTWF6Laovcj658EA1KvcaSswzHFN5Sc=;
        b=O5bTxwUTCZMRs+Yde6AMdB5XL9WDExQ6drPv68IbyA0qK0Z5kXqmv/PgaAWImaF8bD
         iywWI8/ZNjy9Q76w6Lo1CN8filaf/3JN+HKkq5fw6H46ZxN6UTZmSNNnoqV1vkUJb+ld
         /Qz4H8nUIStv1xwUcNBDrHhLSK1hORSozejrJRoFry5wKiF+VGinRdmT+RHUq79aZt85
         tHiIpABVrCcB/x1IqiH4pzAclrdHEwTGe0kqTIHpRNlW4MzO2znl5JQ1r6YkFrEt74ol
         gthZbt0K7NP5IDtfnpCKxFfUE2tI6vge1IlOcslaW37UpMh/NDf80xnQH4hXcjAzIV/s
         0hZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154474; x=1733759274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57d11+Vl+NAgbTWF6Laovcj658EA1KvcaSswzHFN5Sc=;
        b=FJPwNZBz13afNVT6tEIVuQlSEa2o8vvk1zyRN0gYrMTTjcfTja9OhOpKGtVxLj2Drl
         T9baqqlZAZbhg/8BYMantGgAAOYnGtE3H5r5r23r310wTFUL/HjevYW/7SJqBjayWYyQ
         46dSMFFeUpuEK+fQYTN4SN7yksWJkRYE4t23xkZn/TrD9PK4LCsTCykMokulHBB2VVmI
         DF3wGbnE38FzNnC1GoZOorKVv+3hG2q8cxpjH5piKeB6xGMqN2mm0lsLxWqwA7rVrHU7
         Xu6khEiaGVLEgdE0xeoUh4epwVSBUP75LKKUQuOUb7wbdi3tbN4OWBcqwGk7GN2XH3y2
         2/Og==
X-Gm-Message-State: AOJu0Yx4KV8kJRGkMpTZokiuXnU0C4Pei14QumWCELVe7xVc3Qa8B+Zu
	RswroBdvsGNZYsm3Vp6maFODVFKvV34NHRKNMkZXwr8irpBFZ316CGS+be5h8Nf8kX6DHZgn9r0
	0yGtuPZM8WuO0Z59aV76J/k4AqkiyLusNGNp+8mv7fBNQvd1nG0/9zPR176boswyATqbZeTMoxY
	gWAPSyhgCWkXua+9UsBJ0bFbs5JwE=
X-Google-Smtp-Source: AGHT+IEX7W6aLBuxPdDXg5idWYuhPush+WW2wT9LWR15gRkb5XnLTnQL1UMoLIX3aV+mT2vF0Pr+zZMq4A==
X-Received: from wmqm13.prod.google.com ([2002:a05:600c:4f4d:b0:434:a346:77e5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4686:b0:434:a923:9313
 with SMTP id 5b1f17b1804b1-434a9de55b4mr195058375e9.25.1733154474044; Mon, 02
 Dec 2024 07:47:54 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:32 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-6-tabba@google.com>
Subject: [PATCH v4 05/14] KVM: arm64: Initialize feature id registers for
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


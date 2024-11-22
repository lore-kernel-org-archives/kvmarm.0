Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C3E18FDB4
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273599; cv=none; b=niGsTPLq/K+bYsQ3abZ21IW9+HIG0eKO2h2ygaVC63L7By+Oba8l1JpL5Zol4pqrfFv6DIvJdf4Nd/VCo33OxnqIemzRLQH1IQwkz1/+rDsOKScrBaewx8o297Ied4rPbZBt7DrlFuAS/kc8PenlE1BCFGZzVkhQrKG7t9RiaGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273599; c=relaxed/simple;
	bh=n6qFK0CrIk0TBCrqn2/AXdNQJuycB+c0NMPTZcsVezM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VtwcEYshJrkK00GTJz/0frd2pVacj7iu1IPKaCMSFwuyPP7z+npe0gCRwmeShKoCZ+pbLONTrqid/n93vKw13Pq9hiPnsDagzeiDgCc/FCaU69yqoQZy0QKDSEzDSivipxd4aox/BRzatI3OFPV5/Gi6L3QdflQijdRf2MNUoa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDW0llhw; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XDW0llhw"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eedb7b9455so19483457b3.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273597; x=1732878397; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ME9UsezPGt4WGSKA1VLgt1h56+I05ddJ2XsR+2perQ=;
        b=XDW0llhwtDcHJDs2IinlvSYONhwsXGd2r0KDFnEYNYfIMpQ7lTRMvCkECLSn33Wy7y
         f2hdkgxLCHr6CPx3X47cVjGAEJ7AJr+TeyKYVdB8tA+CSIp+28xnxJSZo0jrNIM+fHDX
         FK5MIsVtK0REYmFLuw8GUDYPmYhFPayOa7Do7GKDkCxqIv0vTYcQudBHlPO8jcbwzGFr
         /8+2AQJ6TJonwLh7M0gA8aaAbWBCJWqWiCNx9Kw26P3DW7kxK5Is8G8pvBvGgsGiZeh7
         PeVaoicKeu4nndONS4jcZC7ErqM0HOkqzKWvKxlputOK9rx41//Tez8IMXy9XPn8MdPe
         eXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273597; x=1732878397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ME9UsezPGt4WGSKA1VLgt1h56+I05ddJ2XsR+2perQ=;
        b=KjMbhRQoCkfCXM+z7LjAScrG6XZGFsLQcOOOK+LSZGevAeuLGXT5RFYgV6r1CIb/V9
         tuY8ughY3MKmQLIMF1dWgc4FEVk+7IcX8n1zf8vx4JIgom7nOMeq9QjlHcAJZW3ZBi22
         9bwaXtBeumOuy3WXwwpJLXDURpQ0pKfSHj5gYnREoVAYhrhB2Y1NDmE1S8DxPBRPw+u4
         JlkFe3GOz2Tn+6qofYTipjTHUPzRPQaRJSfPKjG8BhdMnzW7wFVJC4b3Rn5Ks0NLPvO/
         BgUrRKuBjedvfThqnxJq/uBvcrbrnkRJN/tF3iI2eAe8uQDGPb/z+rHAUlUJ8vKKlDO7
         IUPQ==
X-Gm-Message-State: AOJu0YzYM5K5noT5EGk/pkUmSRaWVJuu2dNxJ7pVNckdPnflPaZW7B+f
	kaItUdZPs9WRqi5avniBqdSU66BNnMxr0Xkw3Wlg1ZPLacOPO4bi3ZUfCdBrF4sDEXgg92BnJOK
	e1sZcxSrzPAoIFAkPYsOmA2L1aJ44kys8meMC9CMfCvR/y2RfBpjpa62T1L1eS7qZwe2nEWWV9M
	FOTxLOLkWBwY2biQ3+5BFXudDz/qk=
X-Google-Smtp-Source: AGHT+IFUC+e6lyJm7zGvYcxKJA1IAW1b9/r6RFtf7kaaoJE5CoVHncZPv0RFttxq9UWxn9otjbK1Y2/pAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:2b07:0:b0:e38:1d14:64f4 with SMTP id
 3f1490d57ef6-e38f8b9ef19mr996276.6.1732273596763; Fri, 22 Nov 2024 03:06:36
 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:15 +0000
In-Reply-To: <20241122110622.3010118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-6-tabba@google.com>
Subject: [PATCH v2 05/12] KVM: arm64: Initialize feature id registers for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The hypervisor maintains the state of protected VMs. Initialize
the values for feature ID registers for protected VMs, to be used
when setting traps and when advertising features to protected
VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 54 +++++++++++++++++--
 3 files changed, 56 insertions(+), 3 deletions(-)

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
index 59fb2f056177..7008e9641f41 100644
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
+	if (reg >= sys_reg(3, 0, 0, 4, 0) && reg <= sys_reg(3, 0, 0, 7, 7))
+		return kvm->arch.id_regs[IDREG_IDX(reg)];
+
+	return 0;
 }
 
 /* Handler to RAZ/WI sysregs */
@@ -448,6 +462,40 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+/*
+ * Initializes feature registers for protected vms.
+ */
+void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
+{
+	const u32 pvm_feat_id_regs[] = {
+		SYS_ID_AA64PFR0_EL1,
+		SYS_ID_AA64PFR1_EL1,
+		SYS_ID_AA64ISAR0_EL1,
+		SYS_ID_AA64ISAR1_EL1,
+		SYS_ID_AA64ISAR2_EL1,
+		SYS_ID_AA64ZFR0_EL1,
+		SYS_ID_AA64MMFR0_EL1,
+		SYS_ID_AA64MMFR1_EL1,
+		SYS_ID_AA64MMFR2_EL1,
+		SYS_ID_AA64MMFR4_EL1,
+		SYS_ID_AA64DFR0_EL1,
+	};
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long i;
+
+	if (WARN_ON_ONCE(test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags)))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(pvm_feat_id_regs); i++) {
+		struct kvm_arch *ka = &kvm->arch;
+		u32 reg = pvm_feat_id_regs[i];
+
+		ka->id_regs[IDREG_IDX(reg)] = pvm_calc_id_reg(vcpu, reg);
+	}
+
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+}
+
 /*
  * Checks that the sysreg table is unique and in-order.
  *
-- 
2.47.0.371.ga323438b13-goog


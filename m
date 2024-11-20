Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B0F187859
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099991; cv=none; b=qXVm62OlaS7tVqy/PhpkaC79F0XDz77+NkEhHbIInT54zMLpP//Ygq0ovKgoMUak6IeSBpH0BHqVmILrwi94cO3eZx323GWjhlwDj6U7C6SBNoRa82SaDy9eDjl/Xu0OfhxStH5dlKqF/cR1VUbq06CfFG2JZxbsWCTbFcmdPYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099991; c=relaxed/simple;
	bh=GS3FoOP4JnEBckRiO0PdlQToElXW5MDFJyTqeqYS5ns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gxkDK+fEfbSLhrnbhLPdFJfn73iAwp0f0NunYJamYkZUGVAmX84blsaWLs57hqZciPVoKnQFKVCvkn0dbcR+UAtw05sRGc84wiVg5GiikNknJGmPvPHIAe2rY5pElHy+cE+dALIw6YQ9WRv8XssANLCDfk54V0OlxZldklq8yUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UOXDBkkH; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UOXDBkkH"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38249bf9e82so1320541f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099988; x=1732704788; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QHY9Vu/v9jt8ddodiBMVqHtuBE3iJsXdI0KJMy4Gh7I=;
        b=UOXDBkkH3PLhJODi+wFjQNEZRW2t3aqUq40UmSUvrXVoALp3wuS6M8jfHRB8l7s7EX
         ECpqXz5GV4FgQLmiD4CKa+Bt3g/xct4pDSgdK0DG5eoIfx6Hal9eoL6uHH+cBcHXcOUK
         KAIJc8JaI5GilF7k/tH7iJVOjAPDAczKlE9Ml1mC5ZrIktMV1h+k1fCGqXM6Zn1I4lyw
         N2QcdY66RUAaidnQHMb5s9DB9T+VXEtMkXsS2DQQ6nOIn2im6uz1tOtNwi1FldNB+E+E
         z9DCxBp50kdMDgvFZM5h413XUMe2Pps78hql92CPddr/atCPZ6hI4h9bzi3dQwoPjRQO
         UktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099988; x=1732704788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QHY9Vu/v9jt8ddodiBMVqHtuBE3iJsXdI0KJMy4Gh7I=;
        b=R028WzgdM9rFnDi0xe2R11A1J3MWQklrMHDjY8gkBD4iu1tHgSPexio8OQ2ybaHab4
         VzP72EUvXvpfbKmJFqyOyp/nTnewZQMAYv9cTC95inqA7PMlhJl6GftCeAvFWuHl/zWq
         n9k75xGtsNTkh+LqcdVywUsnFxSeILMw/xJwndacfEiL+gYe5lZk1OlPLfowcS/S4rZ5
         HG7x9Tz/6x6fpCrvUiBb2bgVXZpLlsr0hzAUi3wuWRd3GaxGsOQMMVhMBQ71UufJbedV
         AivSZJ3CcdrJSgx98P25orYH6/LbiZBv/3U6SAMy1nB2lPsfAS4xaxlXJdThU1QufGXU
         h2WA==
X-Gm-Message-State: AOJu0YxKdCRa4NOfqRbu0vwQ4ZW5tdUcDzX8sbZ4HfBb9vlsMoiU0Vq8
	HVVrByCiH/SJUbXubDuBhS3cRO8QGyvdouOsuhvyCqEp9iYQ/MuHFkjds9oRIezMtJbNI03Xib7
	Eh4Cj/kA5Bto/VWWPD8t/lO6xZHeTAxPo5M/mSbplWXmzGe+Ma7/iruMvOLbJu3puK0CvcgELzI
	aOn5sGE0Z5231+BwedMyLkJsfgR5o=
X-Google-Smtp-Source: AGHT+IEMk0vO8gq+mc70KsQSZzwvEYnnws8eHzciVbWjEdDjZE/bNjDj1WTwx+dXuNEtkZhkolH+TswqhQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4dcb:0:b0:37d:5299:c401 with SMTP id
 ffacd0b85a97d-38254b24bd4mr612f8f.7.1732099988221; Wed, 20 Nov 2024 02:53:08
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:47 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-6-tabba@google.com>
Subject: [PATCH v1 05/12] KVM: arm64: Initialize feature id registers for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

The hypervisor maintains the state of protected VMs. Initialize
the values for feature ID registers for protected VMs, to be used
when setting traps and when advertising features to protected
VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 55 ++++++++++++++++++-
 3 files changed, 57 insertions(+), 3 deletions(-)

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
index 59fb2f056177..7e93850a426f 100644
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
@@ -448,6 +462,41 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+/*
+ * Initializes feature registers for protected vms.
+ */
+void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
+{
+	/* List of feature registers to reset for protected VMs. */
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
2.47.0.338.g60cca15819-goog


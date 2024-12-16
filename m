Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E564A2AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346274; cv=none; b=HBmFx2FoRbqHfx1hPzIpSC+VWvw6Dhg6epf4P+0iAxdb8M1wvqI5inFoRUq2O6ersS5CccUoC6zI7zvujg2WhZCE38PkKBj/iAj+WJ1aZgtU5Uul4UDAD6JW7lb8mXL923FWDb1NmTtQGcPKmFNtbzFlnDclhjmFlTn4T3DbQ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346274; c=relaxed/simple;
	bh=GM91lnsXzDqaZac3HsP1/arTwG3ogtw1bIQJo6GngFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HRd2MCuXrtA5h3kbb1WeKcPrA0jGkfgt7CWQVpuunnyyAJkFX4vyBPQslBbbibpqX1s0CR7R94JltNUBAUZeToY0ZyPJysM4uIHucL9r4s8iSuO0vzKYOVioD9ggktZsyi1B2JSNnP3/kx5V2owd6IV5LU5omqxoXKToSVWK9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OnDgLgi3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OnDgLgi3"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so15455745e9.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346271; x=1734951071; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLNB90HFwi4SHqmi2KVXCppej9by7Sd91qe87vHnQQY=;
        b=OnDgLgi3mCeBEWfb+mNA6IWoCsTHc+VrJLQK9teeLF9RDoIdX9kUVvceJlNe5u1kSc
         TduWAKOFlVj7hDHZ3HFhZTthgh3wGG4ParjhvsE/GPrj8LtmuoCK9OXBaQu0t63UGsCi
         ZzGPu0Oaj4VCbrd0JrBn4DNvkrdt1ttn1EdiH/gWEmrP9T0t1T9oves4SJw3E+yNOLJP
         3DBuyusiSjfCQwX9l2Q04O1hM3Pp4ufv3aKxqp9Iyb+CfaV6itN9+/Pedxb6Wxq4y0eu
         8tue1RjesEZQsgaC8vXD3Xh89SNNIR74O9ph8AxzQrSq48Eq+bmaahecQQ0lSSz1iXB/
         rFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346271; x=1734951071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLNB90HFwi4SHqmi2KVXCppej9by7Sd91qe87vHnQQY=;
        b=PYg1crsOsnK1ZQviAnxCdWo1nlB1rOWFeSljZPOnNmSWrjqNKX+bcYJbFY0yp680RR
         Axc9Fx6xStS7NnGA5ETSk5AtfioJDeDvhmbQ5iq2OAuKq80AGgLMrZdGapowprTpXIek
         dBZ7eXAm6m19fOWOK2Bwzcq+h9O9gR0IBJB5Q8cKHiFVJ+QPKXOP/G44HNcj9XKXihfH
         UkFUDep/fCtwQWz7aukWeOapd6Y7Gz0u/124BSYMxgid0t++chp58LcGgwUfeiK9vBu0
         /xS7+uSRHQ3Zhr1jviqwPxZ508xcDKG/LmFjBcpzcOOlpHCmXSJonXhzTi/EEEWyG0oP
         G/iw==
X-Gm-Message-State: AOJu0YzGGUCvYGX2iQKadqkRbvdfsR2bbBCrl3qXbmXC+Tz7et6oiIQW
	y8NbaD1xH7T8fFccBmFTexC6Sna9CE8acDifovxFkYc99xuj0Ng/JkV2x8ptcPQMML/wQ1JyzP0
	aldvEOljz1M+mn8RZExFTTQzwWcKEawX4uvoBlOBVVSuh1TTglBo0HIMiv9k2DKruwgg8cc9IMj
	TC/Dcn5OBnxi46A7DJavlwxQ+EbjA=
X-Google-Smtp-Source: AGHT+IG/KnLxBYGmhyms4gK4RJktxiZAprOlwrWk3fRnjJVEGCGWz+NgSli5dOU7sAR+DbTv+TAWqw5bCQ==
X-Received: from wmol7.prod.google.com ([2002:a05:600c:47c7:b0:434:a471:130f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5254:b0:434:a902:97cd
 with SMTP id 5b1f17b1804b1-4362aa3f7damr97104285e9.12.1734346271261; Mon, 16
 Dec 2024 02:51:11 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:46 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-7-tabba@google.com>
Subject: [PATCH v5 06/17] KVM: arm64: Initialize feature id registers for
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
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  2 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 10 +++--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 44 +++++++++++++++++--
 4 files changed, 51 insertions(+), 6 deletions(-)

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
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 24a9a8330d19..698bc20ab80b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -47,6 +47,8 @@ struct pkvm_hyp_vm {
 	struct pkvm_hyp_vcpu *vcpus[];
 };
 
+extern hyp_spinlock_t vm_table_lock;
+
 static inline struct pkvm_hyp_vm *
 pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 59ff6aac514c..3014f3295d81 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -257,10 +257,10 @@ static pkvm_handle_t idx_to_vm_handle(unsigned int idx)
 
 /*
  * Spinlock for protecting state related to the VM table. Protects writes
- * to 'vm_table' and 'nr_table_entries' as well as reads and writes to
- * 'last_hyp_vcpu_lookup'.
+ * to 'vm_table', 'nr_table_entries', and other per-vm state on initialization.
+ * Also protects reads and writes to 'last_hyp_vcpu_lookup'.
  */
-static DEFINE_HYP_SPINLOCK(vm_table_lock);
+DEFINE_HYP_SPINLOCK(vm_table_lock);
 
 /*
  * The table of VM entries for protected VMs in hyp.
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
index 59fb2f056177..453a130b7a5d 100644
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
@@ -448,6 +462,30 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
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
+	hyp_assert_lock_held(&vm_table_lock);
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
2.47.1.613.gc27f4b7a9f-goog


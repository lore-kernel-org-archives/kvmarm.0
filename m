Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46EA4AE8DF;
	Thu, 24 Sep 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265957; cv=none; b=s+4AEbkvPoZ16+9SiLZmEPwWCeBUrtHRBWQWdObS3bRSKzAz07vydablmVimJF2dwQxGZqmYkB9EULVelJawh5TAFEwo08tk919i7VaeSDUJKOfOF6nwXj4B/4kj3xLhLSJmiez7h/4xdRllYtOB5dwYicZtezi2FVnu5TC9CUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265957; c=relaxed/simple;
	bh=E0gN5eJL+sVLkl6PPZuSbTVgK4lLcJZnmMqWJaO1rJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJTHdZ/nHO6Gurx3CR89qotPkqwOBobS6TARvNCe6Up26MU52NeypWgL6tv4QDRA7vg14U4JgPTwXCkJKZ1XZrKtK2dVkrakGhGH87+opg1+hsVnpGmZr5kwOxnOdNKAZFTNcyvYHcv0bH+83EXyovLDV3x7McSviG/Y7iGYdCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wku7+SWf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wku7+SWf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EFB1152B;
	Thu, 24 Sep 2026 09:05:51 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BC0713F86C;
	Thu, 24 Sep 2026 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265955; bh=E0gN5eJL+sVLkl6PPZuSbTVgK4lLcJZnmMqWJaO1rJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wku7+SWfUTbcLDGs9UepmHG5o2OCTOfpY8MwkfXZF1ZpX6vqIGI52hdVu2kg1S/Bd
	 D4QPz0Zmlsv5UzBaNVce/ZW+c9ztFGGlQIbF/9txhaYJMo9475Wi55Pj7EYjdoznLC
	 wrLfzRXDJPLyjM5xcJLHwAYoD8L9b9/XVB45RPi0=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v20 08/22] KVM: arm64: Add vcpu load/put call backs for flavors
Date: Thu, 24 Sep 2026 17:04:50 +0100
Message-ID: <20260924160504.853911-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add VM flavor specific handlers for VCPU load/put, in an effort to make it
easier to follow the code. pauth traps were removed from VMs running PKVM
as it is a no-op for them.

Based on a patch by Marc Zyngier

Suggested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - Order the vcpu ops by vm_flavor enum value
 - Rebase on the introduction of vcpu_put_mmu() wrapper in the previous patch
Changes since v17:
 - Use macro to initialize the per-flavor ops
 - Add a wrapper to initialise ops in the vcpu structure.
 - Add BUILD_BUG_ON for the array size
 - Remove irrelevant comment about the order of timer loading for !VHE
 - Use the explicti kvm_call_hyp_nvhe for nVHE flavor
 - Don't call nvhe_vcpu_put from pkvm_vcpu_put, open code them
 - Drop cpu argument for vcpu_load() callback. We set the cpu
   before the callbacks are invoked
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arm.c              | 138 +++++++++++++++++++++++-------
 2 files changed, 114 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 63bd1f76edb7b..9e1fa00d96f7c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -150,6 +150,11 @@ struct kvm_vmid {
 	atomic64_t id;
 };
 
+struct kvm_vcpu_ops {
+	void (*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+};
+
 struct kvm_s2_mmu {
 	struct kvm_vmid vmid;
 
@@ -855,6 +860,7 @@ struct vncr_tlb;
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
+	const struct kvm_vcpu_ops *vcpu_ops;
 
 	/*
 	 * Guest floating point state
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6393b2c1a65de..bcb78fc7676c5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -93,6 +93,7 @@ static const struct kvm_ioctl_cap_map vm_ioctl_caps[] = {
 	{ KVM_ARM_PREFERRED_TARGET, KVM_CAP_ARM_BASIC },
 };
 
+static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu);
 /*
  * Set *ext to the capability.
  * Return 0 if found, or -EINVAL if no IOCTL matches.
@@ -569,6 +570,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	mutex_unlock(&vcpu->mutex);
 #endif
 
+	kvm_init_vcpu_ops(vcpu);
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 
@@ -744,12 +747,9 @@ static void vcpu_load_pvtime(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void vhe_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	vcpu->cpu = cpu;
-
-	if (!is_protected_kvm_enabled())
-		vcpu_prepare_mmu(vcpu);
+	vcpu_prepare_mmu(vcpu);
 	/*
 	 * For VHE, the timer must be loaded before the vgic to correctly
 	 * set up physical interrupt deactivation in nested state (e.g. timer
@@ -759,26 +759,53 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	kvm_vcpu_load_fgt(vcpu);
+	kvm_vcpu_load_vhe(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+
+	vcpu_load_pvtime(vcpu);
+	vcpu_set_wfx_traps(vcpu);
+	vcpu_set_pauth_traps(vcpu);
+}
 
-	if (has_vhe())
-		kvm_vcpu_load_vhe(vcpu);
+static void nvhe_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	vcpu_prepare_mmu(vcpu);
+	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
+	kvm_vcpu_load_debug(vcpu);
+	kvm_vcpu_load_fgt(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+
+	vcpu_load_pvtime(vcpu);
+	vcpu_set_wfx_traps(vcpu);
+	vcpu_set_pauth_traps(vcpu);
+}
 
+static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
+	kvm_vcpu_load_debug(vcpu);
+	kvm_vcpu_load_fgt(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 
 	vcpu_load_pvtime(vcpu);
 	vcpu_set_wfx_traps(vcpu);
 
-	if (!is_protected_kvm_enabled())
-		vcpu_set_pauth_traps(vcpu);
+	kvm_call_hyp_nvhe(__pkvm_vcpu_load,
+			  vcpu->kvm->arch.pkvm.handle,
+			  vcpu->vcpu_idx, vcpu->arch.hcr_el2);
+	kvm_call_hyp_nvhe(__vgic_v3_restore_vmcr_aprs,
+			  &vcpu->arch.vgic_cpu.vgic_v3);
+}
 
-	if (is_protected_kvm_enabled()) {
-		kvm_call_hyp_nvhe(__pkvm_vcpu_load,
-				  vcpu->kvm->arch.pkvm.handle,
-				  vcpu->vcpu_idx, vcpu->arch.hcr_el2);
-		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
-			     &vcpu->arch.vgic_cpu.vgic_v3);
-	}
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	vcpu->cpu = cpu;
+	vcpu->arch.vcpu_ops->vcpu_load(vcpu);
 
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
@@ -786,30 +813,50 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.pid = pid_nr(vcpu->pid);
 }
 
-void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+static void vhe_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	if (is_protected_kvm_enabled()) {
-		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
-		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
-
-		/* __pkvm_vcpu_put implies a sync of the state */
-		if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
-			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
-	}
-
 	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
-	if (has_vhe())
-		kvm_vcpu_put_vhe(vcpu);
+	kvm_vcpu_put_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 
-	if (!is_protected_kvm_enabled())
-		vcpu_put_mmu(vcpu);
+	vcpu_put_mmu(vcpu);
+}
 
+static void nvhe_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_put_debug(vcpu);
+	kvm_arch_vcpu_put_fp(vcpu);
+	kvm_timer_vcpu_put(vcpu);
+	kvm_vgic_put(vcpu);
+	kvm_vcpu_pmu_restore_host(vcpu);
+	vcpu_put_mmu(vcpu);
+}
+
+static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kvm_call_hyp_nvhe(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
+	kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+
+	/* __pkvm_vcpu_put implies a sync of the state */
+	if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
+		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+
+	kvm_vcpu_put_debug(vcpu);
+	kvm_arch_vcpu_put_fp(vcpu);
+	kvm_timer_vcpu_put(vcpu);
+	kvm_vgic_put(vcpu);
+	kvm_vcpu_pmu_restore_host(vcpu);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.vcpu_ops->vcpu_put(vcpu);
 	vcpu_clear_on_unsupported_cpu(vcpu);
 	vcpu->cpu = -1;
 }
@@ -2149,6 +2196,37 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	}
 }
 
+static const struct kvm_vcpu_ops vhe_vcpu_ops = {
+	.vcpu_load = vhe_vcpu_load,
+	.vcpu_put = vhe_vcpu_put,
+};
+
+static const struct kvm_vcpu_ops nvhe_vcpu_ops = {
+	.vcpu_load = nvhe_vcpu_load,
+	.vcpu_put = nvhe_vcpu_put,
+};
+
+static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
+	.vcpu_load = pkvm_vcpu_load,
+	.vcpu_put = pkvm_vcpu_put,
+};
+
+#define KVM_VCPU_OPS(flavor, ops)		\
+	[(flavor)] = (ops)
+
+static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
+	KVM_VCPU_OPS(VM_NVHE, &nvhe_vcpu_ops),
+	KVM_VCPU_OPS(VM_VHE, &vhe_vcpu_ops),
+	KVM_VCPU_OPS(VM_PKVM, &pkvm_vcpu_ops),
+	KVM_VCPU_OPS(VM_PROTECTED_PKVM, &pkvm_vcpu_ops),
+};
+
+static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(arm64_vcpu_ops) != VM_FLAVOR_MAX);
+	vcpu->arch.vcpu_ops = arm64_vcpu_ops[vcpu->kvm->arch.vm_flavor];
+}
+
 static unsigned long nvhe_percpu_size(void)
 {
 	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
-- 
2.43.0


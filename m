Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898521C14
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 00:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727741845; cv=none; b=MYp60aXMnO1rM3P+cv/XRBK/h2Gd37IXgbTAga/vuv/DSBhWSR+GsPTTw8OtaekRRxXM+zHdkpf5Kk1I5pLtc453vHrMpMABsQV41hd1JkEiH+wEW1EeyDR7rGICGlJkBUERTegHDwhUvNqJVrK0diEGFLuxjAAHx+4qCD9StbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727741845; c=relaxed/simple;
	bh=bLfbWjEU/cxOEC+jjfINdBOgdgyoO55AdVBEf86f6O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3Nh/cKIZb70Yys9Z+meTgP+/N5gq/nJ3Do8IdeZHc+SSQlLggRV4BalwezI7GN620XSXQIwZMd5RnV7n4najxf+QSREwDNvyWvJ+/HPkzaNE6tJevUxba8rXyz37jxhaKpuj4pxaypq3lY1nbCrmXOPWQLNIEKrjubZz1lzFH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ws3+WZJ4; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ws3+WZJ4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727741841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddOVywaQCFkhEJhlSlZ2ys6WJ6EEhHfc6Tamb+l/61U=;
	b=Ws3+WZJ445KyMgJhqH40tvCPojqRpCIpex7PqoSSP4Pwytv80qCzM9pFvpDHYFU4uPBpAg
	kDl6Bpv58M+m52B26fdzrDyqpJ3qwdCOpSa7zfdBhe91PExuiAe7AGbDe8d6+7FTCl97YC
	rzKzbwbEA7Pl7acT+yNyFkYOHoMOESU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Treat stage-2 MMUs as refcounted generally
Date: Tue,  1 Oct 2024 00:17:07 +0000
Message-ID: <20241001001709.1303668-2-oliver.upton@linux.dev>
In-Reply-To: <20241001001709.1303668-1-oliver.upton@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nested stage-2 MMUs are assigned/released at the vcpu_load()/vcpu_put()
boundary. And, if the guest has more than 2*nr_vcpus in play then KVM
starts reclaiming nested MMUs. This has the effect of making the vCPU's
reference to the loaded hardware MMU volatile in preemptible code, as
the reference can be recycled at any time.

The fix for this issue is surprisingly straightforward, as nested MMUs
have refcounts already. Start pinning nested stage-2 MMUs by raising the
refcount where vcpu->arch.hw_mmu gets used, effectively guaranteeing
that lookup_s2_mmu() finds the same thing every time. Barring any bugs,
this shouldn't have any effect on the guarantee that an unused stage-2
exists at any time, as there are more MMUs than vCPUs capable of pinning
them.

If you haven't looked at the stage-2 abort path in a while, its picked
up plenty of warts, early returns and whatnot. Rather than explicitly
handle all the exit paths, take advantage of the new cleanups
infrastructure to bind the reference to a particular scope. Very nice.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  | 10 ++++++--
 arch/arm64/include/asm/kvm_mmu.h   | 37 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c               | 10 ++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c    |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  4 ++--
 arch/arm64/kvm/mmu.c               | 19 ++++++++-------
 arch/arm64/kvm/nested.c            | 14 ++++++-----
 11 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 329619c6fa96..268f69196380 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -685,8 +685,14 @@ struct kvm_vcpu_arch {
 	enum fp_type fp_type;
 	unsigned int sve_max_vl;
 
-	/* Stage 2 paging state used by the hardware on next switch */
-	struct kvm_s2_mmu *hw_mmu;
+	/*
+	 * Loaded stage-2 MMU context, this is **not** safe to dereference in
+	 * preemptible code as nested MMUs get attached at vcpu_load().
+	 *
+	 * Use the vcpu_hw_mmu 'class' instead to associate a pin on the loaded
+	 * MMU with a scope.
+	 */
+	struct kvm_s2_mmu *__hw_mmu;
 
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index cd4087fbda9a..a6379ca1b0d7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -358,5 +358,42 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
 static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
 #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
 
+static inline struct kvm_s2_mmu *vcpu_to_hw_mmu_unsafe(struct kvm_vcpu *vcpu)
+{
+	/* The nVHE hypervisor code is always non-preemptible */
+	if (!is_nvhe_hyp_code())
+		lockdep_assert_preemption_disabled();
+
+	return vcpu->arch.__hw_mmu;
+}
+
+static inline void kvm_get_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	if (kvm_is_nested_s2_mmu(kvm_s2_mmu_to_kvm(mmu), mmu))
+		atomic_inc(&mmu->refcnt);
+}
+
+static inline void kvm_put_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	if (kvm_is_nested_s2_mmu(kvm_s2_mmu_to_kvm(mmu), mmu))
+		atomic_dec(&mmu->refcnt);
+}
+
+static inline struct kvm_s2_mmu *vcpu_get_hw_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s2_mmu *mmu;
+
+	guard(preempt)();
+
+	mmu = vcpu_to_hw_mmu_unsafe(vcpu);
+	kvm_get_s2_mmu(mmu);
+
+	return mmu;
+}
+
+DEFINE_CLASS(vcpu_hw_mmu, struct kvm_s2_mmu *,
+	     kvm_put_s2_mmu(_T), vcpu_get_hw_mmu(vcpu),
+	     struct kvm_vcpu *vcpu)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e408..367f0d3d3194 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -481,7 +481,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
-	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	vcpu->arch.__hw_mmu = &vcpu->kvm->arch.mmu;
 
 	/*
 	 * This vCPU may have been created after mpidr_data was initialized.
@@ -581,7 +581,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_load_hw_mmu(vcpu);
 
-	mmu = vcpu->arch.hw_mmu;
+	mmu = vcpu_to_hw_mmu_unsafe(vcpu);
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
@@ -1169,10 +1169,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * making a thread's VMID inactive. So we need to call
 		 * kvm_arm_vmid_update() in non-premptible context.
 		 */
-		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
+		if (kvm_arm_vmid_update(&vcpu_to_hw_mmu_unsafe(vcpu)->vmid) &&
 		    has_vhe())
-			__load_stage2(vcpu->arch.hw_mmu,
-				      vcpu->arch.hw_mmu->arch);
+			__load_stage2(vcpu_to_hw_mmu_unsafe(vcpu),
+				      &vcpu->kvm->arch);
 
 		kvm_pmu_flush_hwstate(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 87692b566d90..8c823b1bc909 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -102,7 +102,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	/* Limit guest vector length to the maximum supported by the host.  */
 	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
 
-	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
+	hyp_vcpu->vcpu.arch.__hw_mmu	= vcpu_to_hw_mmu_unsafe(host_vcpu);
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 187a5f4d56c0..d26949892cd7 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -333,7 +333,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
 	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
 
-	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
+	hyp_vcpu->vcpu.arch.__hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 done:
 	if (ret)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc69106734ca..0189d592bb64 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -326,7 +326,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
-	mmu = kern_hyp_va(vcpu->arch.hw_mmu);
+	mmu = kern_hyp_va(vcpu_to_hw_mmu_unsafe(vcpu));
 	__load_stage2(mmu, kern_hyp_va(mmu->arch));
 	__activate_traps(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 48da9ca9763f..fcc10783b1f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -59,10 +59,10 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 		 * to be called from within __kvm_vcpu_run(), which ensures that
 		 * __hyp_running_vcpu is set to the current guest vcpu.
 		 */
-		if (mmu == vcpu->arch.hw_mmu || WARN_ON(mmu != host_s2_mmu))
+		if (mmu == vcpu_to_hw_mmu_unsafe(vcpu) || WARN_ON(mmu != host_s2_mmu))
 			return;
 
-		cxt->mmu = vcpu->arch.hw_mmu;
+		cxt->mmu = vcpu_to_hw_mmu_unsafe(vcpu);
 	} else {
 		/* We're in host context. */
 		if (mmu == host_s2_mmu)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c3995..c73969f0c687 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -245,7 +245,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
-	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
+	__load_stage2(vcpu_to_hw_mmu_unsafe(vcpu), &vcpu->kvm->arch);
 }
 
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 3d50a1bd2bdb..b21168ce7682 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -25,8 +25,8 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 
 	local_irq_save(cxt->flags);
 
-	if (vcpu && mmu != vcpu->arch.hw_mmu)
-		cxt->mmu = vcpu->arch.hw_mmu;
+	if (vcpu && mmu != vcpu_to_hw_mmu_unsafe(vcpu))
+		cxt->mmu = vcpu_to_hw_mmu_unsafe(vcpu);
 	else
 		cxt->mmu = NULL;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a509b63bd4dd..800cf3e7ecae 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1440,6 +1440,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
+	CLASS(vcpu_hw_mmu, mmu)(vcpu);
+
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1459,7 +1461,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (!fault_is_perm || (logging_active && write_fault)) {
 		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+						 kvm_mmu_cache_min_pages(mmu));
 		if (ret)
 			return ret;
 	}
@@ -1621,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	read_lock(&kvm->mmu_lock);
-	pgt = vcpu->arch.hw_mmu->pgt;
+	pgt = mmu->pgt;
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
@@ -1708,12 +1710,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
 	kvm_pte_t pte;
-	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
+	CLASS(vcpu_hw_mmu, mmu)(vcpu);
+
 	read_lock(&vcpu->kvm->mmu_lock);
-	mmu = vcpu->arch.hw_mmu;
 	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	read_unlock(&vcpu->kvm->mmu_lock);
 
@@ -1744,6 +1746,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int ret, idx;
 
+	CLASS(vcpu_hw_mmu, mmu)(vcpu);
+
 	esr = kvm_vcpu_get_esr(vcpu);
 
 	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
@@ -1757,7 +1761,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		/* Falls between the IPA range and the PARange? */
-		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
+		if (fault_ipa >= BIT_ULL(mmu->pgt->ia_bits)) {
 			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
 
 			if (is_iabt)
@@ -1809,8 +1813,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 * nothing to walk and we treat it as a 1:1 before going through the
 	 * canonical translation.
 	 */
-	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
-	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
+	if (kvm_is_nested_s2_mmu(vcpu->kvm, mmu) && mmu->nested_stage2_enabled) {
 		u32 esr;
 
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
@@ -1881,7 +1884,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
+	VM_BUG_ON(ipa >= kvm_phys_size(mmu));
 
 	if (esr_fsc_is_access_flag_fault(esr)) {
 		handle_access_fault(vcpu, fault_ipa);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f9e30dd34c7a..c5b61415b852 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -649,7 +649,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
 
 out:
-	atomic_inc(&s2_mmu->refcnt);
+	kvm_get_s2_mmu(s2_mmu);
 	return s2_mmu;
 }
 
@@ -664,19 +664,21 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
 {
 	if (is_hyp_ctxt(vcpu)) {
-		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+		vcpu->arch.__hw_mmu = &vcpu->kvm->arch.mmu;
 	} else {
 		write_lock(&vcpu->kvm->mmu_lock);
-		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
+		vcpu->arch.__hw_mmu = get_s2_mmu_nested(vcpu);
 		write_unlock(&vcpu->kvm->mmu_lock);
 	}
 }
 
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 {
-	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
-		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
-		vcpu->arch.hw_mmu = NULL;
+	struct kvm_s2_mmu *mmu = vcpu_to_hw_mmu_unsafe(vcpu);
+
+	if (kvm_is_nested_s2_mmu(vcpu->kvm, mmu)) {
+		kvm_put_s2_mmu(mmu);
+		vcpu->arch.__hw_mmu = NULL;
 	}
 }
 
-- 
2.46.1.824.gd892dcdcdd-goog


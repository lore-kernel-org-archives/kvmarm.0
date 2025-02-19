Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144111B4F21
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 22:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002872; cv=none; b=XEloiGcfxFJNlTBn1ClcAQHgsnGxhU+7dHFhrpTLUG/GdXpo09wA6N4RYW3QRRRys18h84Qgjq6O58IGXI1e+x8v9y5BV3eutYw0YI6V5x0rgXzMAHgPC7fufaRAZ8VEKwFOQr3l0rdp4GskDCQPvL0bPJsIaOLoWgfPAFNoPls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002872; c=relaxed/simple;
	bh=hEITRrgieNv/Ub1OlYS/X9nUC2LTusnvXfgFsRzkzgM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eFbrhGyVN3EZCcjJKwJz/0tBdkarCkkzWmCGQB4RRI3DOhpc2xgcDpLlGsl7QMIedZnSWyZjq4woSlTUEwhES92GEcO+QkZAxs4S9ljbh92dK9jY7dFKcTUTDw8eHTt2rI+DxNYfzDRfzbdmQvmVpt/RXD02WGFdZOTGG1JLY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nafVRmno; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nafVRmno"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740002867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ow+fKK+YhM2bEIFRB+vXisHYGskL142HuAanS/Q7uf0=;
	b=nafVRmnoCkdVZuoVmj57PK3/KOT07X29H8wWFSKJMtCbrpCHqXarwzPzZhO0j3WwszTPxI
	q3r6BhbJYJvfHlS8dfoVqMqKn0Jc+FsgF4/ENVFRKI8S63k9nsZoDD+V8FCFzf8vRPkfUw
	1peQ34oS9FXwkxGJWv9HhLCYoxeN3M4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH] KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
Date: Wed, 19 Feb 2025 14:07:37 -0800
Message-Id: <20250219220737.130842-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Vladimir reports that a race condition to attach a VMID to a stage-2 MMU
sometimes results in a vCPU entering the guest with a VMID of 0:

| CPU1                                            |   CPU2
|                                                 |
|                                                 | kvm_arch_vcpu_ioctl_run
|                                                 |   vcpu_load             <= load VTTBR_EL2
|                                                 |                            kvm_vmid->id = 0
|                                                 |
| kvm_arch_vcpu_ioctl_run                         |
|   vcpu_load             <= load VTTBR_EL2       |
|                            with kvm_vmid->id = 0|
|   kvm_arm_vmid_update   <= allocates fresh      |
|                            kvm_vmid->id and     |
|                            reload VTTBR_EL2     |
|                                                 |
|                                                 |   kvm_arm_vmid_update <= observes that kvm_vmid->id
|                                                 |                          already allocated,
|                                                 |                          skips reload VTTBR_EL2

Oh yeah, it's as bad as it looks. Remember that VHE loads the stage-2
MMU eagerly but a VMID only gets attached to the MMU later on in the
KVM_RUN loop.

Even in the "best case" where VTTBR_EL2 correctly gets reprogrammed
before entering the EL1&0 regime, there is a period of time where
hardware is configured with VMID 0. That's completely insane. So, rather
than decorating the 'late' binding with another hack, just allocate the
damn thing up front.

Attaching a VMID from vcpu_load() is still rollover safe since
(surprise!) it'll always get called after a vCPU was preempted.

Excuse me while I go find a brown paper bag.

Cc: stable@vger.kernel.org
Fixes: 934bf871f011 ("KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()")
Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              | 22 ++++++++++------------
 arch/arm64/kvm/vmid.c             | 11 +++--------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..e6e8b8970caa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1271,7 +1271,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 extern unsigned int __ro_after_init kvm_arm_vmid_bits;
 int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
-bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 646e806c6ca6..fafe42755031 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -559,6 +559,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
+	/*
+	 * Ensure a VMID is allocated for the MMU before programming VTTBR_EL2,
+	 * which happens eagerly in VHE.
+	 *
+	 * Also, the VMID allocator only preserves VMIDs that are active at the
+	 * time of rollover, so KVM might need to grab a new VMID for the MMU if
+	 * this is called from kvm_sched_in().
+	 */
+	kvm_arm_vmid_update(&mmu->vmid);
+
 	/*
 	 * We guarantee that both TLBs and I-cache are private to each
 	 * vcpu. If detecting that a vcpu from the same VM has
@@ -1138,18 +1148,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
-		/*
-		 * The VMID allocator only tracks active VMIDs per
-		 * physical CPU, and therefore the VMID allocated may not be
-		 * preserved on VMID roll-over if the task was preempted,
-		 * making a thread's VMID inactive. So we need to call
-		 * kvm_arm_vmid_update() in non-premptible context.
-		 */
-		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
-		    has_vhe())
-			__load_stage2(vcpu->arch.hw_mmu,
-				      vcpu->arch.hw_mmu->arch);
-
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 806223b7022a..7fe8ba1a2851 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -135,11 +135,10 @@ void kvm_arm_vmid_clear_active(void)
 	atomic64_set(this_cpu_ptr(&active_vmids), VMID_ACTIVE_INVALID);
 }
 
-bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 {
 	unsigned long flags;
 	u64 vmid, old_active_vmid;
-	bool updated = false;
 
 	vmid = atomic64_read(&kvm_vmid->id);
 
@@ -157,21 +156,17 @@ bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 	if (old_active_vmid != 0 && vmid_gen_match(vmid) &&
 	    0 != atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
 					  old_active_vmid, vmid))
-		return false;
+		return;
 
 	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
 
 	/* Check that our VMID belongs to the current generation. */
 	vmid = atomic64_read(&kvm_vmid->id);
-	if (!vmid_gen_match(vmid)) {
+	if (!vmid_gen_match(vmid))
 		vmid = new_vmid(kvm_vmid);
-		updated = true;
-	}
 
 	atomic64_set(this_cpu_ptr(&active_vmids), vmid);
 	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
-
-	return updated;
 }
 
 /*

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.39.5


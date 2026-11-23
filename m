Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446614;
	b=n1Hes4ceyseuYF+ezp/ssH9o9Dz1qh32be7mevoiskJ7IKiRvuX7vzWdG1zuT16uZYaO
	 qDivn7MH47JGwn4uuIIbVCrAZ4KbZvyAAyWRm62InAQIW6G5eQw0UVBritmKwDsGgISUG
	 JxFPqxVaSYUpSPVsL41bD4MT/7H00HCljuspIDPZ/f+wrtjk9yH+PunL3m4LKsAGhcPyQ
	 YCDkCO1j8DV9mddZCYyl3T3/4K3Lin+fZr9bxDtnxbgo7H6h4pLtkM+0GpBcwg6pixtX7
	 jnz139p4tOrTWC4k5QFC2Bh/Kx31QRFxT88W8erGrKn3vWg4tsCEWstaVmclEvnZweA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446614;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pcj3iR5Q/uD/43toBqFlh9vTlYdxRie3u4SrhRP2Apo=;
	b=NwVsfVC+wI1kdPUUHwY83q1qFhhGzGJJGe4xpaeUZDZ1Ph9DNoqO+ZMW/A5JyYUuY9fu
	 Gu9RHuDR6zVH3eOMmq7ii6L7YW85DriiKZaEt7JZlOBfyczZZos27hTIuDUGdp1LQAPSG
	 kgKouB1BONIhlw6mXTRUkvQX0BX78znIv90BBnfWDWz4Li/a9Na1yVECRuc3AqPbO6X+l
	 u5yrDZ/5XliHZq6t1i0uJ+rT/49c3vATqQ2v3qbLpYfZHL/SYa1qgqacrqYl1lgYPgFWY
	 OqYfPclVwz54fnCWtlgYsHOH/duULF4oNxGsHrKTjGFj7bEAYBYL8+v3cIE0l8uaIoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=L7r0aR5U;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E74606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3E74606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=L7r0aR5U
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 537A61476;
	Mon, 23 Nov 2026 07:10:10 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0B9023F632;
	Mon, 23 Nov 2026 07:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795446613; bh=aufnXj7ZWmuYwG8s29o0HdRWSyaK4nqqahpsQ6DgXPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7r0aR5Uj5elzPjTCDs45bPPlL/3ny6m03q4Luh2c0NkaC0TWYD8Gh7XGWo6A54TU
	 qX1izGVgksuJH4npvA/byai8Vy4vJisGgeMA5m/ztGHJN4vFvnZGMAR0/kMpkbWli/
	 KG1vW1NbUDFxynqIVCNiPhTD3cAt8ZFaLGQDGvHw=
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before first run
Date: Mon, 23 Nov 2026 15:09:15 +0000
Message-Id: <20261123150917.2679600-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123150917.2679600-1-justin.he@arm.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as KVM_ARM_VCPU_INIT has
completed. On arm64, however, kvm->arch.sysreg_masks, the trap
configuration, vncr_tlb and nested vGIC state are only set up on the
first KVM_RUN in kvm_arch_vcpu_run_pid_change().

Running the full vcpu_load() path before then reads unsanitised guest
sysregs and touches uninitialised nested state: get_s2_mmu_nested()
populates nested_mmus[] from raw VTTBR_EL2/VTCR_EL2/HCR_EL2 values, FGT
and HCRX_EL2 are written before kvm_calculate_traps() has run, and
kvm_vgic_load() can enter vgic_v3_load_nested() early. In particular, if
userspace creates an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac cleared to 0
(so vncr_tlb is never allocated), sets HCR_EL2.NV=1 and an EL1 PSTATE,
and calls KVM_PRE_FAULT_MEMORY, kvm_vcpu_load_hw_mmu() queues
KVM_REQ_MAP_L1_VNCR_EL2. The next KVM_RUN then dereferences a NULL
vncr_tlb in kvm_map_l1_vncr() with preemption disabled and kvm->mmu_lock
held for read:

  [   73.636014] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000078
  [   73.801972] pc : kvm_map_l1_vncr+0x48/0x2d0
  [   73.884820] Call trace:
  [   73.887253]  kvm_map_l1_vncr+0x48/0x2d0 (P)
  [   73.891422]  check_nested_vcpu_requests+0xb8/0x168
  [   73.896200]  check_vcpu_requests+0x2a0/0x428
  [   73.900458]  kvm_arch_vcpu_ioctl_run+0x2d8/0x6d8
  [   73.905062]  kvm_vcpu_ioctl+0x388/0xaf0

KVM_PRE_FAULT_MEMORY still needs generic vcpu_load() to set
kvm_running_vcpu for dirty-ring tracking in mark_page_dirty_in_slot(),
but kvm_arch_vcpu_pre_fault_memory() only walks and populates
&kvm->arch.mmu and does not use any hardware vCPU state. Skip the arch
vcpu_load()/vcpu_put() callbacks until vcpu_has_run_once() is true. In
KVM_RUN, vcpu->pid is set under vcpu->mutex right after
kvm_arch_vcpu_run_pid_change() succeeds and before
kvm_arch_vcpu_ioctl_run() calls vcpu_load().

Since kvm_running_vcpu can now be set without VHE state on the CPU, use
host_ctxt->__hyp_running_vcpu in VHE enter_vmid_context() (matching
nVHE) and check vcpu_has_run_once() in vgic_maintenance_handler().

Fixes: 34cfa9b3af17 ("KVM: arm64: Implement KVM_PRE_FAULT_MEMORY")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/arm.c            | 17 +++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c    |  3 ++-
 arch/arm64/kvm/vgic/vgic-init.c |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b81202..ef626fd13d8e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -811,6 +811,16 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
+
+	/*
+	 * KVM_PRE_FAULT_MEMORY calls vcpu_load() before the first KVM_RUN has
+	 * finalised the VM and vCPU state in kvm_arch_vcpu_run_pid_change().
+	 * Pre-faulting only populates the canonical stage-2 and needs no
+	 * hardware vCPU state on the CPU.
+	 */
+	if (unlikely(!vcpu_has_run_once(vcpu)))
+		return;
+
 	vcpu->arch.vcpu_ops->vcpu_load(vcpu);
 
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
@@ -862,8 +872,11 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.vcpu_ops->vcpu_put(vcpu);
-	vcpu_clear_on_unsupported_cpu(vcpu);
+	if (likely(vcpu_has_run_once(vcpu))) {
+		vcpu->arch.vcpu_ops->vcpu_put(vcpu);
+		vcpu_clear_on_unsupported_cpu(vcpu);
+	}
+
 	vcpu->cpu = -1;
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 33ac9a8c954e..98df0bb0a05c 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -20,11 +20,12 @@ struct tlb_inv_context {
 static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 			       struct tlb_inv_context *cxt)
 {
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	struct kvm_vcpu *vcpu;
 	u64 val;
 
 	local_irq_save(cxt->flags);
 
+	vcpu = host_data_ptr(host_ctxt)->__hyp_running_vcpu;
 	if (vcpu && mmu != vcpu->arch.hw_mmu)
 		cxt->mmu = vcpu->arch.hw_mmu;
 	else
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index c9991e24cb6b..cd413069b16e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -825,7 +825,7 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	 * Of course, NV throws a wrench in this plan, and needs
 	 * something special.
 	 */
-	if (vcpu && vgic_state_is_nested(vcpu))
+	if (vcpu && vcpu_has_run_once(vcpu) && vgic_state_is_nested(vcpu))
 		vgic_v3_handle_nested_maint_irq(vcpu);
 
 	return IRQ_HANDLED;
-- 
2.34.1


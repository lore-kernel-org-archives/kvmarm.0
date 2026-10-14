Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9494F052E
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 12:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982538; cv=none; b=N5lWDER347Ztx9qbOddSAEGJcVFW1QsV1I0ReCfcucG6c/PqkHAgiZd4C+suHrSOMDg6JBZdvSAOhvDSz0tOzKBXo5cT2vcEN2JwVRLaOqMXzZEsGWM83oF2pp/4QjiLIUIftbS4BxqFSynTmeGObmI5+qB1tybqiYMrowRm7FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982538; c=relaxed/simple;
	bh=e+MP2KA6xny3o+tRYZFFnshoyISqoWQeWDPwKAXnGkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pKudbS8qYwjg8O0hU3UsID1Ar1iBMCI3AU/GK19ehpQCAZPfTkoC3N+VOnfQVAA/KHO/cd2cxtacHxja72asAfTohg+/3aYuosDXrASNXw/MtAuQmkd6ZWSi0XYUJ0Dm/X1rFdlSvz2GQThN6nuqesocaJRJcYgufT3x/0LpaOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FcRRnnjT; arc=none smtp.client-ip=91.218.175.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FcRRnnjT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=e+MP2KA6xny3o+tRYZFFnshoyISqoWQeWDPwKAXnGkA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791982526; v=1; x=1792587326;
 b=FcRRnnjTXNZGdlK9P+Foh7cLqKvOm10EoSCY5ob9GFEFiEp5XHZD8C9tQJJuzTsEf40U7qBI
 3f91clEuroUsaIq8DzhJ2NpzuoIVh/sEFijyPO/Df/m8VHYmAfFciEwWa906wBnyFd4RmrvDQEI
 QpXBHViuhax3piLjWFV5DSHk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2f84a68d7f29c388;
	Wed, 14 Oct 2026 12:55:22 +0000
X-Mizu-Trace-ID: 2f84a68d7f29c388
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM
Date: Wed, 14 Oct 2026 13:55:10 +0100
Message-Id: <20261014125510.2928306-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261014125510.2928306-1-fuad.tabba@linux.dev>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All vCPUs of a VM share its VMID, so KVM flushes a physical CPU's TLBs
and I-cache for the VM whenever a different vCPU of that VM is loaded
there (vcpu_prepare_mmu()). Commit fce886a602073 ("KVM: arm64: Plumb the
pKVM MMU in KVM") moved pKVM guests, protected or not, onto the
hypervisor's stage-2 and VMID, and the host stopped flushing for them.
Nothing at EL2 flushes instead, so a vCPU can hit TLB and I-cache
entries that another vCPU of the same VM left on that CPU.

Track the last vCPU loaded on each physical CPU in the hyp VM, and flush
at EL2 in __pkvm_vcpu_load() when it changes.

Fixes: fce886a602073 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 21 ++++++++++++++++++---
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 9abfe6b7e942b..02c8fc7a10904 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
 	unsigned short refcount;
 	hyp_spinlock_t lock;
 
+	/* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
+	int *last_vcpu_ran;
+
 	/*
 	 * The vCPU initialised RUNNABLE: claimed under vm_table_lock,
 	 * released only if its own init fails.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d715aa942577e..f0b77236c871e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -827,11 +827,19 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
 	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int *last_ran;
 
 	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
 	if (!hyp_vcpu)
 		return;
 
+	/* TLBs and I-cache are private to each vCPU, see vcpu_prepare_mmu(). */
+	last_ran = &pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu)->last_vcpu_ran[hyp_smp_processor_id()];
+	if (*last_ran != vcpu_idx) {
+		__kvm_flush_cpu_context(hyp_vcpu->vcpu.arch.hw_mmu);
+		*last_ran = vcpu_idx;
+	}
+
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ac020d0501d2e..f18fa762746c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -489,10 +489,11 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 }
 
 static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
-			     unsigned int nr_vcpus, pkvm_handle_t handle)
+			     int *last_vcpu_ran, unsigned int nr_vcpus, pkvm_handle_t handle)
 {
 	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
 	int idx = vm_handle_to_idx(handle);
+	unsigned long cpu;
 
 	hyp_vm->kvm.arch.pkvm.handle = handle;
 
@@ -512,6 +513,10 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	mmu->vtcr = host_mmu.arch.mmu.vtcr;
 	mmu->arch = &hyp_vm->kvm.arch;
 	mmu->pgt = &hyp_vm->pgt;
+
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
+		last_vcpu_ran[cpu] = -1;
+	hyp_vm->last_vcpu_ran = last_vcpu_ran;
 }
 
 static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
@@ -887,6 +892,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 	size_t vm_size, pgd_size;
 	unsigned int nr_vcpus;
 	pkvm_handle_t handle;
+	int *last_vcpu_ran;
 	void *pgd = NULL;
 	int ret;
 
@@ -915,13 +921,19 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 		goto err_unpin_kvm;
 	}
 
+	last_vcpu_ran = hyp_alloc(array_size(hyp_nr_cpus, sizeof(*last_vcpu_ran)));
+	if (!last_vcpu_ran) {
+		ret = hyp_alloc_errno();
+		goto err_free_hyp_vm;
+	}
+
 	ret = -ENOMEM;
 
 	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
 	if (!pgd)
-		goto err_free_hyp_vm;
+		goto err_free_last_ran;
 
-	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
+	init_pkvm_hyp_vm(host_kvm, hyp_vm, last_vcpu_ran, nr_vcpus, handle);
 
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
 	if (ret)
@@ -938,6 +950,8 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
 	kvm_guest_destroy_stage2(hyp_vm);
 err_remove_mappings:
 	unmap_donated_memory(pgd, pgd_size);
+err_free_last_ran:
+	hyp_free(last_vcpu_ran);
 err_free_hyp_vm:
 	hyp_free(hyp_vm);
 err_unpin_kvm:
@@ -1112,6 +1126,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 		hyp_free(hyp_vcpu);
 	}
 
+	hyp_free(hyp_vm->last_vcpu_ran);
 	hyp_free(hyp_vm);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
-- 
2.39.5


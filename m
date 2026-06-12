Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641CC3D47BB
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281459; cv=none; b=n1yjitTsy8UUmxAtCooFfOTASSF0JEYtwQfgLy/9gwjlfWkq7furzHMr+gESG5OCGJhkKySTfRfYlhARziqOyu1M0Xe5813GF+0WEloGQcCY1/Q6zePTnNM7q04OCrCZ2cS5UtP2KPsest8mCnY6VmL6ZcsWRY3igPwtDIv3QHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281459; c=relaxed/simple;
	bh=QRDRXTCX50amxKD5gLh7D6OBaXCfaBfzgoB4N+6bbzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxP/+EuwSPe6iFf47y8Fhh440xIyAMrDhGVd/UK+yRKX1gSGhumZFsqdMyu+y2DYPIJ4M0+XJnJO+zj8cr7oUVu1nkS92900xZWFXVvqy77a6/WO+0hl2dJm8PNylMLnneMJExAtpT9BJqkOECi0AY+Z76k/+PiNTavPJ3C9zz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTLRl6S1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTLRl6S1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490a76757e5so9184605e9.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281456; x=1781886256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJahK7oX1jpIBSr/85+UyDd//PxGmbpfN024eZe1Ebc=;
        b=ZTLRl6S1wfc6GJkd+txbMXZt2AQK8FzNVoJxDDh1uVhJplB1GJeyoJ4oPhbop5Hpwp
         uGKmErBv+MuFEizkfrLpU0k1tkUQI4GB5Me0YN8jfn/iwMWDFYOm0hY+mJmH6wx7mrGB
         7JQwUSmoSjyfwaOLszh0vM4aM5+EBzWiL1AZt71qMS9gFOyZdDmJeSHOgVg3BFiLpNEV
         ugSZfvthRiv6c/PiHFtQgFGF7nrSczp5mxAAqDjXVCKR36rjEPMeUxdVtEwPPm7gyc+4
         jeuAy9aBsRLwsQ47+YZO9BV/Nl0PSILL991ql3pFbqM291uYsuwCIrtNDaQekyPEFjPq
         sK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281456; x=1781886256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mJahK7oX1jpIBSr/85+UyDd//PxGmbpfN024eZe1Ebc=;
        b=ExuKa3fxgOWoCWfLQ6J6Fdl3TnOv7278VP7Y0yjp3jidVtd3rAVbenkAzLvQojAPRn
         u1hFd8UpUh5lX6EgjHCq0b78MDWouqPQhpH9F28GKUK3OwbSlmGi8NR0nTq1pmJhIfam
         UALZ7sniYZHF8+oXsUmKTWO3nr4MQd93Ft/LD51QKPt6FoDFr5o90EuPxIV7dQvTTyMx
         eIjsoHLHGka4qQ0UY/0Zb9Y2IIWnagtHgt4VLvcVed5txYSfvGJLHhRCKVcioLrVQ+D3
         IyGEIt0H6yD+4609IuAfRG+PVVUBTthgcEaFWZ2q855OpWDljFhb+D5I7q639xVgb1sl
         DCIA==
X-Forwarded-Encrypted: i=1; AFNElJ/aT2mhAC+0XvuGDys2gzfFEv78dHM9+px1/gHE38Mt33i3vkaFLsM5LpvWmlwKmfFaplVSMzU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+3KuHXpeB4uuwuNZfPP2UksYfj2bgN0qpFzwwuuoxPWyDI4sY
	78Gy92xZ3MUPw76OXUo7u+QobvDuIHUoMj/5mSxkcOIIlDHy6jdlDM4w
X-Gm-Gg: Acq92OHjwUDkeABfbL0hPjR2PPj+LtIK3ey63Fp/PBmacr6FRbFhaN294BDb7xIX7lq
	6YJTGVQBbsG7dKuEQLuUkkUEjUrKN8Dbr+m8Ffceu7u8cyATb6EHQesv+PA4Vf8DIsOqSinKeXJ
	u94YDr+3fnxauscnQ4rJarLQv+SZEKYxqxNrYX0DWx9kpcnFlmebjfk7IUIp1PP3yRZdq735Oh+
	JYqqRw8NmorC2KJ5RFD9AQYzZC+dFsOnoff7I7pQS3AEWGTufPVR/IP2yqXh2mHDan2MX+hC1ki
	cx0xQUa829SnfMo9NIyXZgwd3rcCtxLKD6+Fa42Ia//8+nZ7jQ+vbx8MY94v2unEAq4rMD0yLLK
	e7nj/qmxzZ46KZ8KJ5exFf7/47eiv3M0MCnCJE7DKiEBGsfs5TbAJ89KKAW51kppZjKNeOZHVfE
	fY7mwCgRbALTGUrkGPFqUdQs8oTZQdYmd9Oli0sm18QV7WbORbtrzhf06gf6Ss+g==
X-Received: by 2002:a05:600c:4745:b0:490:bd66:e523 with SMTP id 5b1f17b1804b1-492200c04a9mr1802785e9.20.1781281455606;
        Fri, 12 Jun 2026 09:24:15 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm57620935e9.1.2026.06.12.09.24.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 09:24:15 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	corbet@lwn.net,
	vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com,
	Jack Thomson <jackabt@amazon.com>
Subject: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
Date: Fri, 12 Jun 2026 17:23:50 +0100
Message-ID: <20260612162354.73378-3-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260612162354.73378-1-jackabt.amazon@gmail.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add arm64 support for KVM_PRE_FAULT_MEMORY by synthesizing a read data
abort and routing it through the existing stage-2 fault handlers. Treat
the requested GPA as an IPA in the userspace-owned VM's memslot space
and always target the canonical stage-2, even if the vCPU last ran with
a nested/shadow MMU selected.

If the vCPU last ran in a nested context, switch to the canonical
stage-2 with the vCPU put/load helpers so VMID, VNCR and shadow-MMU
refcount state stay consistent. Leave the switch in place for the ioctl;
vcpu_put() at ioctl exit drops the hw_mmu and the next vcpu_load()
reselects the correct MMU from vCPU state.

Check existing mappings with a shared page-table walk under the MMU read
lock, and use the resulting walk level when constructing the synthetic
fault. Report poisoned pages through the ioctl return path with
-EHWPOISON instead of also queueing SIGBUS, and use the installed
mapping size to advance the prefault range.

Advertise KVM_CAP_PRE_FAULT_MEMORY on arm64. Protected VMs remain
unsupported: pKVM filters the capability, and the ioctl returns
-EOPNOTSUPP if invoked anyway.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 Documentation/virt/kvm/api.rst |  18 +++-
 arch/arm64/kvm/Kconfig         |   1 +
 arch/arm64/kvm/arm.c           |   1 +
 arch/arm64/kvm/mmu.c           | 162 +++++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 52bbbb553ce1..657e05656fa6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6462,7 +6462,7 @@ See KVM_SET_USER_MEMORY_REGION2 for additional details.
 ---------------------------
 
 :Capability: KVM_CAP_PRE_FAULT_MEMORY
-:Architectures: none
+:Architectures: x86, arm64
 :Type: vcpu ioctl
 :Parameters: struct kvm_pre_fault_memory (in/out)
 :Returns: 0 if at least one page is processed, < 0 on error
@@ -6470,11 +6470,14 @@ See KVM_SET_USER_MEMORY_REGION2 for additional details.
 Errors:
 
   ========== ===============================================================
+  EAGAIN     A memslot update raced with the ioctl before any page was
+             processed.
   EINVAL     The specified `gpa` and `size` were invalid (e.g. not
              page aligned, causes an overflow, or size is zero).
   ENOENT     The specified `gpa` is outside defined memslots.
   EINTR      An unmasked signal is pending and no page was processed.
   EFAULT     The parameter address was invalid.
+  EHWPOISON  A poisoned host page was encountered.
   EOPNOTSUPP Mapping memory for a GPA is unsupported by the
              hypervisor, and/or for the current vCPU state/mode.
   EIO        unexpected error conditions (also causes a WARN)
@@ -6494,7 +6497,14 @@ Errors:
 KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
 for the current vCPU state.  KVM maps memory as if the vCPU generated a
 stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
-CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
+CoW.  However, on x86, KVM does not mark any newly created stage-2 PTE as
+Accessed.  On arm64, newly created stage-2 PTEs are marked Accessed.
+
+On arm64, `gpa` is interpreted as an IPA in the userspace-owned VM's
+memslot address space.  If the vCPU most recently ran a nested guest, KVM
+still targets the VM's canonical stage-2, and does not interpret `gpa` as
+a nested guest IPA or target the nested/shadow stage-2 selected by the
+vCPU's last run state.
 
 In the case of confidential VM types where there is an initial set up of
 private guest memory before the guest is 'finalized'/measured, this ioctl
@@ -6507,9 +6517,9 @@ case, the ioctl can be called in parallel.
 
 When the ioctl returns, the input values are updated to point to the
 remaining range.  If `size` > 0 on return, the caller can just issue
-the ioctl again with the same `struct kvm_map_memory` argument.
+the ioctl again with the same `struct kvm_pre_fault_memory` argument.
 
-Shadow page tables cannot support this ioctl because they
+On x86, shadow page tables cannot support this ioctl because they
 are indexed by virtual address or nested guest physical address.
 Calling this ioctl when the guest is using shadow page tables (for
 example because it is running a nested guest with nested page tables)
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..6b89262e8ba7 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -24,6 +24,7 @@ menuconfig KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_VFIO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c6..dcb92bee13af 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -392,6 +392,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
 	case KVM_CAP_ARM_SEA_TO_USER:
+	case KVM_CAP_PRE_FAULT_MEMORY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c720f07cb82e..4bf048bbcf8b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1571,6 +1571,8 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_trans	*nested;
 	struct kvm_memory_slot	*memslot;
 	unsigned long		hva;
+	unsigned long		*page_size;
+	bool			prefault;
 };
 
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
@@ -1882,6 +1884,13 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 				      &s2vi->map_writable, &s2vi->page);
 	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
 		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
+			/*
+			 * When prefaulting, report the poison via -EHWPOISON
+			 * only; don't also queue a SIGBUS as the run path
+			 * does for the faulting vCPU thread.
+			 */
+			if (s2fd->prefault)
+				return -EHWPOISON;
 			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
 			return 0;
 		}
@@ -2053,6 +2062,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
+	if (s2fd->page_size && !ret)
+		*s2fd->page_size = mapping_size;
+
 	/*
 	 * Mark the page dirty only if the fault is handled successfully,
 	 * making sure we adjust the canonical IPA if the mapping size has
@@ -2757,3 +2769,153 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+/*
+ * Prefaulting always targets the canonical stage-2.  If the vCPU last ran
+ * in a nested context, swap in the canonical MMU via the vCPU put/load
+ * helpers so that preemption, VMID, VNCR fixmap and shadow-MMU refcount
+ * state stay consistent.
+ *
+ * The swap is deliberately not undone: nothing runs in between the
+ * per-page invocations of kvm_arch_vcpu_pre_fault_memory() except the
+ * generic prefault loop, and the vcpu_put() at ioctl exit discards
+ * vcpu->arch.hw_mmu anyway (see kvm_vcpu_put_hw_mmu()), so the next
+ * vcpu_load() re-derives the correct MMU from the vCPU's context.  If the
+ * prefault task is preempted in the meantime, kvm_vcpu_put_hw_mmu()
+ * keeps the canonical MMU in place for the reload.  Leaving the swap in
+ * place also bounds the cost to at most one put/load pair per ioctl,
+ * rather than two pairs per prefaulted page.
+ */
+static void kvm_pre_fault_load_canonical_mmu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_nv(vcpu) || vcpu->arch.hw_mmu == &vcpu->kvm->arch.mmu)
+		return;
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+}
+
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	struct kvm_vcpu_fault_info *fault_info = &vcpu->arch.fault;
+	struct kvm_vcpu_fault_info fault_backup = *fault_info;
+	s8 walk_level = KVM_PGTABLE_LAST_LEVEL;
+	unsigned long page_size = PAGE_SIZE;
+	struct kvm_memory_slot *memslot;
+	phys_addr_t gpa = range->gpa;
+	struct kvm_pgtable *pgt;
+	phys_addr_t end;
+	kvm_pte_t pte;
+	hva_t hva;
+	gfn_t gfn;
+	long ret;
+
+	if (vcpu_is_protected(vcpu))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Interpret range->gpa in the userspace-owned VM's IPA space, not in
+	 * any nested guest IPA space that may have been active on the vCPU's
+	 * last run.  Always target the canonical stage-2.
+	 */
+	kvm_pre_fault_load_canonical_mmu(vcpu);
+
+	if (gpa >= kvm_phys_size(vcpu->arch.hw_mmu)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	gfn = gpa_to_gfn(gpa);
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/*
+	 * A racing memslot deletion or move installs an invalid slot before
+	 * zapping stage-2.  Ask userspace to retry once the update settles.
+	 */
+	if (memslot->flags & KVM_MEMSLOT_INVALID) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	/*
+	 * pKVM stage-2 mappings aren't directly walkable from the host; let
+	 * the fault path handle both new and existing mappings.
+	 */
+	if (!is_protected_kvm_enabled()) {
+		pgt = vcpu->arch.hw_mmu->pgt;
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
+			ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, &walk_level,
+						   KVM_PGTABLE_WALK_SHARED);
+		}
+		if (ret)
+			goto out;
+
+		if (kvm_pte_valid(pte)) {
+			page_size = kvm_granule_size(walk_level);
+			if (!(pte & KVM_PTE_LEAF_ATTR_LO_S2_AF))
+				handle_access_fault(vcpu, gpa);
+			goto out_success;
+		}
+	}
+
+	/*
+	 * Synthesize a read translation fault for the canonical IPA, at the
+	 * level where the stage-2 walk currently ends (the last level under
+	 * pKVM, where stage-2 isn't walkable from the host).
+	 */
+	fault_info->esr_el2 = (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |
+		ESR_ELx_IL | ESR_ELx_FSC_FAULT_L(walk_level);
+	fault_info->hpfar_el2 = HPFAR_EL2_NS |
+		FIELD_PREP(HPFAR_EL2_FIPA, gpa >> 12);
+
+	struct kvm_s2_fault_desc s2fd = {
+		.vcpu		= vcpu,
+		.fault_ipa	= gpa,
+		.nested		= NULL,
+		.memslot	= memslot,
+		.page_size	= &page_size,
+		.prefault	= true,
+	};
+
+	/*
+	 * As in the run path, -EAGAIN from the abort handlers is treated as
+	 * progress: either a parallel fault installed the mapping, or a racing
+	 * invalidation is in flight and the next access will refault.
+	 */
+	if (kvm_slot_has_gmem(memslot)) {
+		ret = gmem_abort(&s2fd);
+	} else {
+		hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
+		if (kvm_is_error_hva(hva)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		s2fd.hva = hva;
+		ret = user_mem_abort(&s2fd);
+	}
+
+	if (ret < 0)
+		goto out;
+
+out_success:
+	end = ALIGN_DOWN(gpa, page_size) + page_size;
+	ret = min_t(u64, range->size, end - gpa);
+out:
+	/*
+	 * Restore the synthetic fault state so a subsequent KVM_RUN does not
+	 * observe it. kvm_handle_mmio_return() runs before guest entry can
+	 * refresh fault.esr_el2 from hardware, so leaving the synthetic ESR
+	 * in place would corrupt the completion of a pending MMIO exit.
+	 */
+	*fault_info = fault_backup;
+	return ret;
+}
-- 
2.43.0


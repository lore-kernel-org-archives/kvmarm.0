Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15A7411FBE;
	Wed,  7 Oct 2026 07:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358594; cv=none; b=suQTeSczqxYdAnzPjF4M8XYHtDgbFPTx93eK3b8WcRRjfC1uSy4AZkIw5Xu9IGzRjDKMLu/lvuaoNkE+8kX+L/eCAeymhNCGI0cTWhkc0akvvw4jLKcxbY4Uwkd9WSkdJlBYDgFlHEkVUddZRwBbPm6oIWfmKCasONUkUZfUyck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358594; c=relaxed/simple;
	bh=0gb74nQBq/JzVyjtCm7aK3IywJV1eC5WzOhXCz3ZtkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoeS2oqiaSxNBzSoxv/W1oipMVH0GvhxWDyFBBTPFPcI5IB60Xnv2X+WX8bQa0fK3rhDOtCOBc20pk2scuSK/cg8OqiEQbrkrDjI9cmycu5umWc9KBeDjtIC6bCl/ucvVLj3UGKeLImKNx4uCOXYSL94WsVuywcMoc8ZZF+lv2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PRQ7iD2y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PRQ7iD2y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED3981595;
	Wed,  7 Oct 2026 00:36:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A17913F763;
	Wed,  7 Oct 2026 00:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791358592; bh=0gb74nQBq/JzVyjtCm7aK3IywJV1eC5WzOhXCz3ZtkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRQ7iD2y9n0TY1SJqzCNWPn9s2JMUUI6MjUcLGNTmUulliF2CWeeT67xVoIgldfzt
	 LfKWJ7gO9vD3Or7/m87gVtb40yy34jQjzlJo+d/qEcjiNGPmPtSiMjVvZqsiw4Jcsu
	 CMSTeZ0InN5Tw5zEemE7+u1USJ/i4pxBS9eJJNrs=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v23 11/14] KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
Date: Wed,  7 Oct 2026 08:35:34 +0100
Message-ID: <20261007073537.2454351-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007073537.2454351-1-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_handle_guest_abort() repeatedly obtains the VM from vcpu->kvm.

Introduce a local kvm pointer and use it throughout the function. While
touching the code, fix the missing whitespace in the
kvm_is_nested_s2_mmu() call.

Suggested-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 65592feaa6a96..46d23483db4b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2284,6 +2284,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_trans nested_trans, *nested = NULL;
 	unsigned long esr;
 	phys_addr_t fault_ipa; /* The address we faulted on */
@@ -2304,7 +2305,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 * with an SEA.
 	 */
 	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
-	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
+	if (KVM_BUG_ON(ipa == INVALID_GPA, kvm))
 		return -EFAULT;
 
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
@@ -2339,7 +2340,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		return -EFAULT;
 	}
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	idx = srcu_read_lock(&kvm->srcu);
 
 	/*
 	 * We may have faulted on a shadow stage 2 page table if we are
@@ -2354,7 +2355,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 * nothing to walk and we treat it as a 1:1 before going through the
 	 * canonical translation.
 	 */
-	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
+	if (kvm_is_nested_s2_mmu(kvm, vcpu->arch.hw_mmu) &&
 	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
 		u32 esr;
 
@@ -2382,7 +2383,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	}
 
 	gfn = ipa >> PAGE_SHIFT;
-	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	memslot = gfn_to_memslot(kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -2446,7 +2447,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.hva		= hva,
 	};
 
-	if (kvm_vm_is_protected(vcpu->kvm)) {
+	if (kvm_vm_is_protected(kvm)) {
 		ret = pkvm_mem_abort(&s2fd);
 	} else {
 		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
@@ -2465,7 +2466,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	if (ret == -ENOEXEC)
 		ret = kvm_inject_sea_iabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 out_unlock:
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	srcu_read_unlock(&kvm->srcu, idx);
 	return ret;
 }
 
-- 
2.43.0


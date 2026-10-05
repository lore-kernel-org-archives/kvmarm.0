Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14255438019;
	Mon,  5 Oct 2026 09:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191330; cv=none; b=P4Fmsl2cckDa06MpiRek79wo2UGn6f87JUCUUkU/3el3vScMCVE/pBdLACm9ZKYx7SMMWTryA4vpJo01iYbexliRF1FGLRMNl15ETj19Z3NDXHkkLa1x3NV3jvcziyD3e4SFQwid8kVM42CcsKI7vLVXP3doVCJz6+niPLcrD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191330; c=relaxed/simple;
	bh=cMtJeGd9wHBnj+2Ow3IXsjUoLmqjWGOWu8bw9RwvM2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p44Jtipm3A9QWmO5kTwZ9yrPcUxzuQZ94JAQ/YuqusRG2+FgUJvQ7mYD3qUb6TF0YvJe16vs4HSmyRCUT7DU/hzhqHhrmulIS4NrQjBJF0TN6G9topHh6CqC8B5CfUoBmEiSZn7m5K2a0bpxoMXUhUFqW3iFYVj7YfBuxrj8JxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mdZOswwY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mdZOswwY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06A341576;
	Mon,  5 Oct 2026 02:08:43 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D06F3F66F;
	Mon,  5 Oct 2026 02:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191326; bh=cMtJeGd9wHBnj+2Ow3IXsjUoLmqjWGOWu8bw9RwvM2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdZOswwYwNPpyfuBA7TIDNgGxgQyqYYLgnqtu7Sp+H48pvU0ViPgBO64HWnqHoju6
	 pvOihOSzo28YKuzK5iPlNaeZ8Mw/vuzMjCeIJATi4G7upFDuP+NkmOf5b8KVQwezy7
	 fcvOXni2vpVbnqqG4yNeycr02jFZS6kHB1xzB9FE=
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
Subject: [PATCH v22 12/23] KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
Date: Mon,  5 Oct 2026 10:07:43 +0100
Message-ID: <20261005090754.2140522-13-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
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
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c046c76833876..9cc7fcde4dd0a 100644
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


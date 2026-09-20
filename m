Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3907F476CE6;
	Sun, 20 Sep 2026 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939778; cv=none; b=IKxKnIVS+vWFDL44c7XizEk1Ud4gJxKJcvGEv4+Z4mAQOX7prWhikngDn/Fqg4Xp2FIX7ken/9l5jKS9LixUmMHIGb1anjYqdAzwsfISWcaX37n1eS06eqpZcKOF+FAuxlqmUQY+uAszPX4YBcXbn4r/v9N2dJ+DDQu8pGLnQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939778; c=relaxed/simple;
	bh=9Tuhr5JbKm4gDZP6c3b3wk8mRxaL7WFWo5A7pESJCCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHunVk3it58jSZSa8rtGpX33CXLTTF8jAPY6gbEKTmf+hEcXk/VX0+Yhiqfep0JV/ElasjvwB/K/ZU4nFzdvs03Y4ZKlRMAXYmSl7KVmw6wbzOa4dcUadrmSypyXTrq6AHSnOFd+ObyP3gCc2VUKqXErvhkiSIpMzkf/Q/GsbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cedMT3eT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cedMT3eT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7BF216F3;
	Sun, 20 Sep 2026 14:29:29 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F15C3F632;
	Sun, 20 Sep 2026 14:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939773; bh=9Tuhr5JbKm4gDZP6c3b3wk8mRxaL7WFWo5A7pESJCCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cedMT3eTWvXiqVv9CbRKNwOI7/trtwnNcGHBEN6h2qDRVIZyAvgOh6UnjtByASpeu
	 BK2VdvFj1HVB8ImteYOFbDK4moqTX0RbCKzUI2j8ot+O2AwmtmIhu6pkOlUGBqT8WP
	 MT6ODjWZ97LK6/HaISePuNXEVLh8BRk75RbRxNVY=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v19 10/20] KVM: arm64: Abstract out memory abort handling
Date: Sun, 20 Sep 2026 22:28:35 +0100
Message-ID: <20260920212845.707-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the memory abort handling under VM specific s2 operation.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v18:
 - Ensure vm_mem_abort handler is always !NULL
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 38 +++++++++++++++++++------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7664d8b8cce5a..3211543a85b38 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -156,6 +156,7 @@ struct kvm_vcpu_ops {
 };
 
 struct kvm_gfn_range;
+struct kvm_s2_fault_desc;
 
 struct kvm_vm_s2_ops {
 	bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
@@ -166,6 +167,7 @@ struct kvm_vm_s2_ops {
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
 				      bool may_block);
+	int (*vm_mem_abort)(const struct kvm_s2_fault_desc *s2fd);
 };
 
 struct kvm_s2_mmu {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d97a4a1bca23f..cf293d09e940a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1742,7 +1742,7 @@ struct kvm_s2_fault_vma_info {
 	bool		map_non_cacheable;
 };
 
-static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int protected_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
@@ -2180,6 +2180,22 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache);
 }
 
+static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	int ret;
+	struct kvm_vcpu *vcpu = s2fd->vcpu;
+
+	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
+			!kvm_is_write_fault(vcpu) &&
+			!kvm_vcpu_trap_is_exec_fault(vcpu));
+
+	if (kvm_slot_has_gmem(s2fd->memslot))
+		ret = gmem_abort(s2fd);
+	else
+		ret = user_mem_abort(s2fd);
+	return ret;
+}
+
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
@@ -2287,6 +2303,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s2_trans nested_trans, *nested = NULL;
+	struct kvm *kvm = vcpu->kvm;
 	unsigned long esr;
 	phys_addr_t fault_ipa; /* The address we faulted on */
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
@@ -2448,19 +2465,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.hva		= hva,
 	};
 
-	if (kvm_vm_is_protected(vcpu->kvm)) {
-		ret = pkvm_mem_abort(&s2fd);
-	} else {
-		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
-				!write_fault &&
-				!kvm_vcpu_trap_is_exec_fault(vcpu));
-
-		if (kvm_slot_has_gmem(memslot))
-			ret = gmem_abort(&s2fd);
-		else
-			ret = user_mem_abort(&s2fd);
-	}
-
+	ret = kvm->arch.vm_s2_ops->vm_mem_abort(&s2fd);
 	if (ret == 0)
 		ret = 1;
 out:
@@ -2855,6 +2860,7 @@ static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
 	 * .vm_test_age_gfn
 	 * .vm_stage2_unmap_range
 	 */
+	.vm_mem_abort			= protected_vm_mem_abort,
 };
 
 static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
@@ -2863,6 +2869,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
 	.vm_age_gfn			= kvm_vm_age_gfn,
 	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
 	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
+	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
 static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
@@ -2871,6 +2878,7 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_age_gfn			= kvm_vm_age_gfn,
 	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
 	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
+	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
 #define KVM_VM_S2_OPS(flavor, ops)		\
@@ -2887,7 +2895,7 @@ static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
 	BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX);
 
 	kvm->arch.vm_s2_ops = arm64_vm_s2_ops[kvm->arch.vm_flavor];
-	if (WARN_ON(!kvm->arch.vm_s2_ops))
+	if (WARN_ON(!kvm->arch.vm_s2_ops || !kvm->arch.vm_s2_ops->vm_mem_abort))
 		return -EINVAL;
 	return 0;
 }
-- 
2.43.0


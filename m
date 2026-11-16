Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847496;
	b=4JN4mLafOdv0EYKfg6NYgu99g6zYFuL0gnrWoKx/MuGfjSdXKuYlRDdZi0K+6LS8Ub2a
	 QsVJPiI5CW/Vb5zc72KDYoj8VzuZf4vzNnB2Ityl3gqZWJtI6dIMBe3eFGRQNDHYbQfVO
	 EawhleRb7jUXKPun8SBuQ6qVZVzKXzpj7SiVxsN2vqPtbb+odFHlP23Zr/xccXho8u1Dn
	 vNZSvqTsfvqD0+xOIiBmQyf1hJga47s0QlQi9HOwXOohoVMds08LQ8mtyMaodS5csdQba
	 DJVm3Ldfza7WjqmePKMBQdy05IMYLpjx9cBvEnGvqsqNrHXfL4kogJ3eByGMGvmhTgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847496;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yF/V4RQcsz22ZXchQTYFWKlhLRQ49e9sOfQfIXFrF5U=;
	b=JFRiFnw7qhkXv/pcCCCJ3b2iErKcsYErD+4pF+T+zXPqN+BjyBvGAu1gr/NjCK0cTcNu
	 WIbO0U7xMoAAzBxcRZZwXcmA4z2a1DS9OQI/JfA9uFF9QgzKlnsDs4woe8/gzsk8UxkfN
	 yQpbFWmBVy2ueCJbNq0eMDCjdikHGqL1dyfCRkz4ghnJb/LtvdWrPqE6R0dBCYJAQuMW+
	 6FEMJAyAubuLc+qS87tEvucH2dHMcs9AAFZv+7VjWX7zBTXSyGsX4joUNh3ViFNRCIAEh
	 1S7JIX9nncmqwqYRBOxAIRnx4fKh4Cg72ro30fJ6Gk2BYwim0KydiQqUe4Siinl003Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hOkcz00+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD14606A332;
	Mon, 16 Nov 2026 16:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBD14606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hOkcz00+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 223C3143D;
	Mon, 16 Nov 2026 08:44:52 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73A843F882;
	Mon, 16 Nov 2026 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847495; bh=kYb0vllDY8D8xPF23SOdLAaWWaEXo/vzCyoXKEd1aPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOkcz00+JN4EvThhf6fcUB8LbE7ZNwy5bt+qTX/khfTPiAprz3gG0okZ1zCL5M6iM
	 iGXOkmSwj7SbyOJt1H3EGOF70QF8pv+fMz11QFYWus+if4V2ITQz+E8xS8OfBeDxsX
	 BWkCn+IUgEe3C9WcVFaVTwqmtGhFKZsvIrlSOfgw=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 07/11] KVM: Allow architectures to reject memslot changes before invalidation
Date: Mon, 16 Nov 2026 16:43:53 +0000
Message-ID: <20261116164358.142785-8-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116164358.142785-1-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Architectures may need to reject deletion of a memory slot without
changing the guest's memory mappings. Currently, KVM invalidates the slot
and calls kvm_arch_flush_shadow_memslot() before
kvm_arch_prepare_memory_region() can reject the request. On arm64, this
unmaps the slot from stage-2. Restoring the old memslot on failure does not
restore those mappings, so even a rejected deletion has side effects.

Add kvm_arch_validate_memory_region() and invoke it before invalidating
the slot, with slots_lock and slots_arch_lock held. The hook performs
validation only, allowing architectures to reject a request without
changing the memslot or its mappings. Provide a weak no-op implementation
for architectures that do not need early validation.

Move arm64's protected VM checks into the new hook so that unsupported
deletions and moves are rejected before stage-2 unmapping. Keep resource
preparation after invalidation, since invalidation drops slots_arch_lock
and allows concurrent updates to architecture-specific memslot metadata.

Assisted-by: LLM
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c     | 22 ++++++++++++++++------
 arch/arm64/kvm/pkvm.c    |  2 +-
 include/linux/kvm_host.h |  4 ++++
 virt/kvm/kvm_main.c      | 33 ++++++++++++++++++++++++++-------
 4 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9baf2352d2a8..759ac0453828 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2851,13 +2851,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	}
 }
 
-int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_memory_slot *old,
-				   struct kvm_memory_slot *new,
-				   enum kvm_mr_change change)
+int kvm_arch_validate_memory_region(struct kvm *kvm,
+				    const struct kvm_memory_slot *old,
+				    const struct kvm_memory_slot *new,
+				    enum kvm_mr_change change)
 {
-	hva_t hva, reg_end;
-	int ret = 0;
+	lockdep_assert_held(&kvm->slots_lock);
 
 	if (kvm_vm_is_protected(kvm)) {
 		/* Cannot modify memslots once a pVM has run. */
@@ -2872,6 +2871,17 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		}
 	}
 
+	return 0;
+}
+
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
+{
+	hva_t hva, reg_end;
+	int ret = 0;
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index a5145bd75d0c..f4db0e051d6a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -262,7 +262,7 @@ int pkvm_create_hyp_vm(struct kvm *kvm)
 	int ret = 0;
 
 	/*
-	 * Synchronise with kvm_arch_prepare_memory_region(), as we
+	 * Synchronise with kvm_arch_validate_memory_region(), as we
 	 * prevent memslot modifications on a pVM that has been run.
 	 */
 	mutex_lock(&kvm->slots_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f65728a713ec..15848221860f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1255,6 +1255,10 @@ int kvm_set_internal_memslot(struct kvm *kvm,
 			     const struct kvm_userspace_memory_region2 *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
+int kvm_arch_validate_memory_region(struct kvm *kvm,
+				    const struct kvm_memory_slot *old,
+				    const struct kvm_memory_slot *new,
+				    enum kvm_mr_change change);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf4cb586f140..3ef370d71818 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1682,6 +1682,20 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
 	slots->generation = gen;
 }
 
+/*
+ * Validate a memslot change before invalidation, which may irreversibly reclaim
+ * private guest memory. Called with slots_lock and slots_arch_lock held.
+ * Implementations must not modify memslot state or allocate resources; leave
+ * those operations to kvm_arch_prepare_memory_region().
+ */
+__weak int kvm_arch_validate_memory_region(struct kvm *kvm,
+					   const struct kvm_memory_slot *old,
+					   const struct kvm_memory_slot *new,
+					   enum kvm_mr_change change)
+{
+	return 0;
+}
+
 static int kvm_prepare_memory_region(struct kvm *kvm,
 				     const struct kvm_memory_slot *old,
 				     struct kvm_memory_slot *new,
@@ -1934,6 +1948,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 */
 	mutex_lock(&kvm->slots_arch_lock);
 
+	r = kvm_arch_validate_memory_region(kvm, old, new, change);
+	if (r)
+		goto unlock_err;
+
 	/*
 	 * Invalidate the old slot if it's being deleted or moved.  This is
 	 * done prior to actually deleting/moving the memslot to allow vCPUs to
@@ -1950,22 +1968,22 @@ static int kvm_set_memslot(struct kvm *kvm,
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		invalid_slot = kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
 		if (!invalid_slot) {
-			mutex_unlock(&kvm->slots_arch_lock);
-			return -ENOMEM;
+			r = -ENOMEM;
+			goto unlock_err;
 		}
 		kvm_invalidate_memslot(kvm, old, invalid_slot);
 	}
 
 	r = kvm_prepare_memory_region(kvm, old, new, change);
 	if (r)
-		goto err;
+		goto revert_slot;
 
 	if (change == KVM_MR_CREATE && (new->flags & KVM_MEM_GUEST_MEMFD)) {
 		r = kvm_gmem_commit_memory_region(kvm, new);
 		if (r) {
 			kvm_arch_free_memslot(kvm, new);
 			kvm_destroy_dirty_bitmap(new);
-			goto err;
+			goto unlock_err;
 		}
 	}
 
@@ -2000,7 +2018,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 
 	return 0;
 
-err:
+revert_slot:
 	/*
 	 * For DELETE/MOVE, revert the above INVALID change.  No modifications
 	 * required since the original slot was preserved in the inactive slots.
@@ -2009,9 +2027,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		kvm_activate_memslot(kvm, invalid_slot, old);
 		kfree(invalid_slot);
-	} else {
-		mutex_unlock(&kvm->slots_arch_lock);
+		return r;
 	}
+unlock_err:
+	mutex_unlock(&kvm->slots_arch_lock);
 	return r;
 }
 
-- 
2.43.0


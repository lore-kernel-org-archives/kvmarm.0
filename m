Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409136;
	b=lvD2pul8hNB/k61IeHoiFgnJKMdNJV1yqbuoTEJQPRyo1skc/OGOV/ddww6T95yNdB39
	 6yBXIGOsVXaAFEdxKX8nXXzWqbfkhVBCgZRTHYotpnQ8g9MYNy4v92euolhn49gXm6oEu
	 7QjvcVOajfvYVUZbb9qIkeV19IXTWkMYF9/HSLBDFDr+noenYffC8gvklwAeMnL2YNmXX
	 U8j93UXMFaoyZ3+g+0tyFABKeJjgKU5f+lfDsdXkDm2f4M3G88Yxqn5BWJ3t4AmemNih9
	 fCoTeOMK47zYblURu8fCwtD6cDunk7208145NG/rn3/ASf8akPK6zWZtZmMZ8pAvDjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409136;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+35/VIw120EtksuRZQNRBkWZeojJB0lJieLJNnkQ+Us=;
	b=DSmsF7EAVB3nsg+6XvdltVj8XjCzPe6pZM2dUaWuEK3fzxMjV3Whbi7CU0apk5QSIgBd
	 wllEE/wr6ECsiEzActwMohDUoJ07xfva2EbCvf48R2cqLdRC0iQfgr+n3SPn1tMdIT9Pa
	 4T4z9V8knnqt00kZMRFNM48xfyJuGvC/R0k8D3sB1S67bTTY1d2fIrtyzQ4ZSO8YOugTX
	 G0AODc3/LOai1MWg1c3XfgK9a2pWV70OAjBahsR+YN722cog9D/tTdMAZtrx6A3yoxPrH
	 QHPrLMjykxbAh6W3SV47V6ZyohKPy51U4tWwTX6Kzy5oaHdt0yshdp5aoy7+l5vj1WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pJ9h+EtN;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A7C606A8A9;
	Wed, 11 Nov 2026 14:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20A7C606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pJ9h+EtN
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B25E61576;
	Wed, 11 Nov 2026 06:58:52 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3BAE3F632;
	Wed, 11 Nov 2026 06:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409135; bh=1kcGk24+Xt8qjyfRn+nXorHBSpYyZ4/LOOK+Vrf2f5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJ9h+EtNgSwt73XZXIW4T8xbfd9i7POtWO9YA5zerUqpc/o72kNGe2LirBroVvrUk
	 oFzmu7u+EvZflkIJjCfnR+dJLbwXKqtN4lE03JoW5P3T/A2vZZRVN14xdR0LxTzOoR
	 0UUYPJO70ObyLlDOCvCZiioFw53B+Eq6cenay5fA=
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
Subject: [PATCH v2 09/12] KVM: Allow architectures to reject memslot changes before invalidation
Date: Wed, 11 Nov 2026 14:57:53 +0000
Message-ID: <20261111145758.217946-10-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
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
index be014f6c00e7..8c29ed204d61 100644
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


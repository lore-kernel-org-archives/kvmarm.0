Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2277C455623;
	Mon, 14 Sep 2026 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388846; cv=none; b=FIpVGWpGi5pnx7nMk0yZd034MEe4pdidx9JUVuEWw3xv8X9yiPIuwKj3+GL4zmiijf7A/wV6OmCLqs+uDpVOPjnpwtuIF26elgx/eyqFdlyY+YyQj6DAYS0lYArFI/vdUMujZn8CNSvsotTPrY0AIQYqyNE7pGJutZO9t3zVXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388846; c=relaxed/simple;
	bh=sxsR0neWhr2x3K2zdyfHuHOqlS6vpsw+7DVZOk50OYk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p25NuqVgQHEGSrTUEsnqSZ4zTwFhPaSdxzuTuTGIhQKpPYOGe4DE+93oXyfNkSXzS7GycLn7qCpnnkFNzHpZxZRWIz/u72HYW7OkxzWvwUEnN5OqLdBNM3gm/PFWvFrn2+PxUDQHUzD61zauabW+MKCssst9DLGRDK3Bev11gsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VT91QDfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VT91QDfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CED1F000FF;
	Mon, 14 Sep 2026 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388843;
	bh=ephBT7Ms4ZBAJjep/I2F/htnPClPVQpebuoaPNEXZb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VT91QDfE2BE1TM7B+x0FJjzqg6aZFfbRzXR+MFJitGKNOFlD5wtaONuroPHf5lfyH
	 nKtK3YzJ/wLUUh2SAL/Fh1zWB6PdbzQKxMSp37MzhNh4trxPcxvjSWzMa25jR7/8Wp
	 ehfHY2lbbYt7SH+CRBpd3pp9xaRPDHJJeApbFQlh4j8gvbgTfxgCVMxVpqyxOorU9Y
	 m3aAz3XvCt7WN8XMlJAsgQh1GAzwY6R8FqtleCqr1Mq6EcX2Xke6tPj5r8s3G3HH6O
	 G7SBV/82HngjxUiRtGNJrfY927GwrG7aIwVpCwMFBekPSScMpGa7Rl3njZPSEkPTM4
	 8QgusD7c3TFmg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:19 +0100
Subject: [PATCH v2 08/13] KVM: arm64: Pass walk flags to
 kvm_pgtable_get_leaf()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-8-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5556; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gnm60rg2wPySPU/+erDKmBvXy87LcivmTZpZyB37QFA=;
 b=kA0DAAoWz53NioHifxQByyZiAGqn5/Wg7ynwQorQwEyvD9T3MBQbe8zX88kxmp7R9m9IVvqmG
 Yh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmqn5/UACgkQz53NioHifxSgbwD+ITy+
 jbun0GGJMR7jRBBSZrGP2hqcngvchJQ22FiEsGkA/R4yVLn0+fLOJ9IabHGooa3zm8+sWj5MNLl
 TsW2KbUIC
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

From: Jack Thomson <jackabt@amazon.com>

Allow callers of kvm_pgtable_get_leaf() to specify the page-table walk
flags, in preparation for performing walks under the MMU read lock.

Reading a stage-2 leaf while only holding the read lock requires
KVM_PGTABLE_WALK_SHARED: parallel faults (which also only hold the read
lock) can unlink table pages and free them via RCU, so the walker must
be inside an RCU read-side critical section, which the shared walk flag
provides via kvm_pgtable_walk_begin().

All existing callers either hold the write lock, walk with interrupts
disabled, or run at hyp where shared walks are rejected; they keep the
current behaviour by passing no flags.

No functional change intended.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 10 +++++-----
 arch/arm64/kvm/hyp/pgtable.c          |  5 +++--
 arch/arm64/kvm/mmu.c                  |  2 +-
 arch/arm64/kvm/nested.c               |  2 +-
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..d0167f7dfbee 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -859,6 +859,8 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * @addr:	Input address for the start of the walk.
  * @ptep:	Pointer to storage for the retrieved PTE.
  * @level:	Pointer to storage for the level of the retrieved PTE.
+ * @flags:	Flags to control the page-table walk
+ *		(see struct kvm_pgtable_visit_ctx).
  *
  * The offset of @addr within a page is ignored.
  *
@@ -869,7 +871,8 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
-			 kvm_pte_t *ptep, s8 *level);
+			 kvm_pte_t *ptep, s8 *level,
+			 enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 39aa8911f62c..23a57312b981 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -532,7 +532,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	int ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -910,7 +910,7 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (guest_pte_is_poisoned(pte))
@@ -959,7 +959,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
 
 	guest_lock_component(vm);
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		goto unlock;
 
@@ -1315,7 +1315,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 		return -EPERM;
 	}
 
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -1544,7 +1544,7 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (!kvm_pte_valid(pte))
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..347eec3957d6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -298,12 +298,13 @@ static int leaf_walker(const struct kvm_pgtable_visit_ctx *ctx,
 }
 
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
-			 kvm_pte_t *ptep, s8 *level)
+			 kvm_pte_t *ptep, s8 *level,
+			 enum kvm_pgtable_walk_flags flags)
 {
 	struct leaf_walk_data data;
 	struct kvm_pgtable_walker walker = {
 		.cb	= leaf_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= flags | KVM_PGTABLE_WALK_LEAF,
 		.arg	= &data,
 	};
 	int ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index eae085a622ff..9c922b498adb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -866,7 +866,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 	 * IPI-ing threads).
 	 */
 	local_irq_save(flags);
-	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level, 0);
 	local_irq_restore(flags);
 
 	if (ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 17123f0b6dab..3488d5ad225b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -654,7 +654,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 		return 0;
 
 	tmp &= ~(sz - 1);
-	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
+	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL, 0))
 		goto again;
 	if (!(pte & PTE_VALID))
 		goto again;

-- 
2.55.0


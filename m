Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3CC54B1D5;
	Tue, 22 Sep 2026 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086751; cv=none; b=CnwLuk2/+GDHtT3b5LJDyTPEj8CpXLiWGbw1SsBmz3Ux2C6mcvF2QJ+7ZKyWhtn3HSNVcAyIs1NvND0b9JozX6CVFb7r3YgSznVpjD57XO97zcI5JiX+Ipehluv3ZGKlcm4TEStIkdnWnWrK9JoqJ86MozoE4CRNUg0Tzg7tUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086751; c=relaxed/simple;
	bh=obyzv3mORLW329YbufVohPm6ECACDfNcSshEr8H9Ty8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BtFVuPeiVlQQhVwz7hbLqK0KKOIMdksGhTvsWxQ7vBbhnDU47Q/T+tzdWmndev5TsTsnKf3gzS3k+rtJpedmuwfSP9siaephp3/LD+R/wD6yULgnaf+uOYO2yphAXw5AryBG85OPoCNK34gkzL5z6DQ7t0loxOWcwE027nKDox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di1uZSCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di1uZSCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32241F00898;
	Tue, 22 Sep 2026 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086749;
	bh=dv/6s+R//+VyGNqcWYhAfrHZ1/XEEYwz3ynoTBKGRfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Di1uZSCsiDONeMTMfLFEtbE585RrzH2I9xV+H4xuVJQS+surwFUafr8+7RP7mPf0v
	 0EnWZo8kQPBzb8+TFCyaB6cY5baV+NUGZEdLsKpz7gUo1RczaiTRH19lnCVU7JozTw
	 uASof4E8gC7VmqAlgBMRkvlo4jldL33l7Z2FqNlAUhQMshEKgg3uy6V/99pTVnGzkx
	 WkD/VsutI9BDrJlZDLqjI2zT/lMI3bfbf4AM/VGDUj3RbmuOgL0h2+L3nhTPWkpYtw
	 4BEsXJdzW3HJdC8gCrEl/jmsc/0yt1LDiaiUNGYal52+rDKx4t7wfkLPr3pr0vpPp9
	 1tAIIkCgZm9+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:18:03 +0100
Subject: [PATCH v3 09/14] KVM: arm64: Pass walk flags to
 kvm_pgtable_get_leaf()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-9-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6104; i=ljs@kernel.org;
 h=from:subject:message-id; bh=I+REGkngwLZnmIQKSN+hPGixnHf0cCSikRoaQXqReOg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29Uk+vGZw3XLTtYeN/QnyS+65/Ww7yOruz354d6ftp
 jPrIy5UdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAixqWMDEuM70woUC7bYiec
 EDH5lJjVLj9dHw9GW8GJYrctlpivmM3IsP8Vw/IkV2UP3ZlT70y70tKzYwrLzvWLllR/FlY5e9V
 0Fw8A
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
[ljs: fixup new kvm_pgtable_get_leaf() invocation]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 10 +++++-----
 arch/arm64/kvm/hyp/nvhe/mm.c          |  2 +-
 arch/arm64/kvm/hyp/pgtable.c          |  5 +++--
 arch/arm64/kvm/mmu.c                  |  2 +-
 arch/arm64/kvm/nested.c               |  2 +-
 6 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 20d12da3d28e..589db1d6405f 100644
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
index a6a47c1e058b..443ee433119e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -540,7 +540,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	int ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -930,7 +930,7 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (guest_pte_is_poisoned(pte))
@@ -979,7 +979,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
 
 	guest_lock_component(vm);
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		goto unlock;
 
@@ -1335,7 +1335,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 		return -EPERM;
 	}
 
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -1564,7 +1564,7 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (!kvm_pte_valid(pte))
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 29ab5ee9d57f..bcf2fd1ddd75 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -486,7 +486,7 @@ static int check_page_ownership(phys_addr_t phys)
 			return -EPERM;
 	}
 
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL, 0);
 	if (ret)
 		return ret;
 
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
index 2576b967d20e..6a85024eab69 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -895,7 +895,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 	 * IPI-ing threads).
 	 */
 	local_irq_save(flags);
-	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level, 0);
 	local_irq_restore(flags);
 
 	if (ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ec754a865a00..cd868af63b1b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -662,7 +662,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 		return 0;
 
 	tmp &= ~(sz - 1);
-	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
+	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL, 0))
 		goto again;
 	if (!(pte & PTE_VALID))
 		goto again;

-- 
2.55.0


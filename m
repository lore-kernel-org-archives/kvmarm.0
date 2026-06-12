Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1AF3845AE
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281457; cv=none; b=nkpnzJb3PEseYU7MIMht+cfYv8ElkR4C2pDqbJds97kE+UPZastsq9uLIW1T4Qet0kkDKdfF2+3BO2RQcFgH4+ift7ehLWq9hBre7V74d0cJvCmipEuiBmTHQ7hF5MXwu6AkEloC/iTNnFjwEtlyTQfhncMtem/hZYaGEWdYGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281457; c=relaxed/simple;
	bh=Ek5sg8ia7dHrpdcCzHmFxOvsiqSRhQeTCIZ4Fbont5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac0mz0tTMNgDyS0B/zbEk1PXPwTNhRCaCQFU9IztJuc9/h5D86nWo8oZ0MEciH8pfNKUFB7P+EZ9k1qi5FSc7O+PumN3Eq0Gll2WimOo0W67teZD7hXwUB28ObbTZr9M/NXsgOM7EPNCj61DwiXHiItMo0Vs2FzOUQ9K69QYc14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgTey4mY; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgTey4mY"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490bb83a3f6so9578875e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281454; x=1781886254; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdYyfsvx1DQaEQW7SfjjNGQD4l8zjElTcwX+OTVhZvA=;
        b=IgTey4mYByBoFiSCQEQl/niFT0e9QV6kTQs6/zvsvelb8n02IJyBKuEyR5PxTrZDeA
         K+uaG5JSlebqbmMuPZo5XABEk3mSQ1WcDlpoGRU4CJcLnm0tpWuEdkhFXGkP96q8HmFE
         iwNnEAdUS5tb9yYuROasDxSKknMxnY/T/KiQN8wA+bAbGBg4N/UZtWME3VXW7sow1MmN
         /ivoVL7W3jXBRzfIru3OBnQQZPa3QfzXAmmJ+0+LYAmLWGrSrZLRsLaE7QgZGZk9bKTM
         evIiQZu2c7a1O2BGAPkpj4INOoZzaD4n+QzR6sp95FIi5rKEHztu8a0VRFM2Ie/uPFRv
         9KNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281454; x=1781886254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tdYyfsvx1DQaEQW7SfjjNGQD4l8zjElTcwX+OTVhZvA=;
        b=X5IxnO9qSSrXjPPBLJNfctrAWTQyuSwRpM61FIMR+/OHyY9usrSTe/RAx5FbenfS+V
         YmioqBvU561qomjmQmSbSZS3FMziSK+utr5tiDDbTN0QehF7hQRsXgwT0YlixflN6q3b
         kzTL9jV+Zy+9FXrmUouwuswIHqEn0zQP6ro1kHvY7IgKCtzoNNsdD0RGH4Xsz3T4Raib
         Tl49LvNfGn0YqoVjnqHs83nF6Tnm+vookLKkkwLZNceEfSQFp49jPgKwXUP6sBpG8ghZ
         Q2rkU/xsTkwCqYP0aiyAaUYes0zMtWGffltapGZc8+9VX9TLtg4PJ1vTIKRkcinuOXqY
         Mjbg==
X-Forwarded-Encrypted: i=1; AFNElJ9qT5sSGpqTVTeeqlipOCd3HZ5UcGayxalvqVV0RaqVlXMItQN/8yZm6EoHxBw3cPGFnPBjAfc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMxUilPTPDF8Mk7zJaf5e6+CTJEfTQT+IIFq1lUMjkxbeIo2SR
	D1flaJHFOXRbxpoEiwqcXl9NzbAUD/d5srm5s/aymy9ZD8lFkzE6fh7d
X-Gm-Gg: Acq92OE3GuZT+6OZlH/yU4O85mh/Jhu+88CsiO/Qsy6aAMoCWa1n1SsdyXh9HCWlWcJ
	cTxLBtscx9Dj8POvxylFeHf612EyYwZO/uYhLa3L/Yooa3P/kl3udSOH6OqK2f77tpHFAo7cBb1
	9cR5kR8UkSXVd37w0peWb/wPRoIW9dGB3hMFXIUMi4f72soRwx8pi/97pKk8j7SQTEByUg/6zsF
	EtSWaJJYsVEOuM/VfCJnBZ3e1rz9VL8M7/2DXt9e8LN9IejSXIyA5iLlInOiaEN+tSIG//6ywj0
	/3m7B3DKEdUurJRRJlysyYekG+R7VJjUqy73/jmPpsrbQyeeJwq1otTXFaRCzLv+aQ+R0YNBlu+
	XMZXy1wpluqRK37YjK0kxR5RfSmCcUpKOVSizOlZjBWahFTg4Yxm1v/AHz6K5P7LAfXkeNDZQ32
	uVGAQBwN7ztcEZ67YZctioyZYvhG9DL+GB/rs1SL0jzlAtZ4rmpueMl4yo3cyhqQ==
X-Received: by 2002:a05:600c:3548:b0:490:ea8a:32d0 with SMTP id 5b1f17b1804b1-490ec501917mr49869245e9.20.1781281454334;
        Fri, 12 Jun 2026 09:24:14 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm57620935e9.1.2026.06.12.09.24.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 09:24:13 -0700 (PDT)
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
Subject: [PATCH v5 1/5] KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
Date: Fri, 12 Jun 2026 17:23:49 +0100
Message-ID: <20260612162354.73378-2-jackabt.amazon@gmail.com>
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
index 25f04629014e..3b765c9ff7e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -522,7 +522,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	int ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -890,7 +890,7 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (guest_pte_is_poisoned(pte))
@@ -939,7 +939,7 @@ int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 	ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
 
 	guest_lock_component(vm);
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		goto unlock;
 
@@ -1293,7 +1293,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 		return -EPERM;
 	}
 
-	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level, 0);
 	if (ret)
 		return ret;
 
@@ -1522,7 +1522,7 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
 	if (ret)
 		return ret;
 	if (!kvm_pte_valid(pte))
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..6a839a32e246 100644
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
index 4da9281312eb..c720f07cb82e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,7 +839,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 	 * IPI-ing threads).
 	 */
 	local_irq_save(flags);
-	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
+	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level, 0);
 	local_irq_restore(flags);
 
 	if (ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 38f672e94087..e45aed6d9e65 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -559,7 +559,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 		return 0;
 
 	tmp &= ~(sz - 1);
-	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
+	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL, 0))
 		goto again;
 	if (!(pte & PTE_VALID))
 		goto again;
-- 
2.43.0


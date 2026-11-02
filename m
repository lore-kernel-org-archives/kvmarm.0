Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652448;
	b=a7475GcXt+cG/GVjg2N+lcfQTxYVJzc4t0owdJh4gaINXJXQxt4pfGeJtaPBJ7a6EE3L
	 ki/INgxQplskKS5WMZ7iIwouUVQde0RXR5/HhChDizQJ+91iMP/kZUR4eZI1JNgf6u6K2
	 MtX7AUPVaulcN1sZXndDtNvOy69VKAqPbXVukPyORETvqKZrQCaWKI8XVD+iA0QVqxqXA
	 maR8SvIR0p2cDigQXWDZ3ojXpnKNf9+T2VcFFTw+TDfEswWl3wzqWBZj7kfRkqHgIU5ah
	 y1StCW0iTG7gu9XykrnHMsubUpcMIvC2NlhKWgswulW7pQ4x1IZGifgW2GL5dUNPujA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=pypvUQzOZRecF9C5F+7tuIBn1NBmciDOtiV+pevKLGc=;
	b=MVG/ENHqC8LNUVs0YQ3+/ftZIrabwJpMMK/KlXfr8Adld8kLqlNR9uiM3QBhywPFfLnj
	 uw/vDLQly5IdymXHx6jdXrzhtEjmbm0FZ8T+PZXDTXBJ2QWB5V4d8cH7BWUDOskrFD8DH
	 6qIaLOLmWfE3Tz4g1+flI/doWRlwQ6Q/SZ3T2aP6hET5IXC1jUeycHS9X55AKEEGGs2/Q
	 h7o7a7Efi1I/FyhvX8SVQbsUZLMDUzItv9YsrS2EByYahePvWVE/TZFHQ7aLy6voyqMYq
	 UhwChHCj6njbBAtx/g3UEZFduqvPOO6arIw9iPvm0D42/Imjs4b5gYhKFmF0lJZpDyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Gi/hLnkM";
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24F3606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C24F3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gi/hLnkM
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c7fe9736eso2994212f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652446; x=1794257246; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pypvUQzOZRecF9C5F+7tuIBn1NBmciDOtiV+pevKLGc=;
        b=Gi/hLnkMsotYAvf2FNCu7AyQL/WsfNP8jSZ9WkqCtOlW9mAbSDFFtUnq4rZqBpzxRE
         4/vaOuH7H6VrkeCHQVwFqjDHGft4PNE0Ulpmbkl2MUKV3mqlqicihI7fMh8UZSb+PNS8
         5zWUkY1yjrPTm29P8ji/yZfxV9MbE9F+ZonZcNLOEvrf9UToYq/wvV/tRxEUkdp29aoH
         A/Y7xl6NA6Tj8+Q9qEpwpY9to6+QOX6rQwTxZWRCoDVIy88+lNPwQdPsyHkzc/0ytFNY
         z9WK2KSIwHRhq0UoHL5ZiSx3n8Pftf8lEzKZXTWCJbPh/qNP5OGBMAgWOcXit387PA7X
         uB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652446; x=1794257246;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pypvUQzOZRecF9C5F+7tuIBn1NBmciDOtiV+pevKLGc=;
        b=c8xgMt2LNPJgvtcOyc7fsnNLkToqFJXT26A3r0oWYA8GYcAU8YmhkaF1zlFizTbOH9
         0UH776PMtvmmqABD/jWqsnCk5tFSUQlBYXFC4KOtqDSZ/+9/SQO63r+WfslpWQCEIWpC
         55eQSlXz/Wcx+7KYAH9G4Cq7dZpGnrtx96pxxnSKpp4cDKzqeamxEoZh0QmfrvJR5cUs
         2j6XMRkcjKCHXTDTPMLhdemjOEcbJuZCdd4+CxjWVkqVvNQlwJqer9VtH4XV9UzSpwhp
         5LscVRBsv1d2B1v/R+L4kcVko8gGKeLIHuVvl7wzUucXZO5xgB1pnnXTmDArWZhlpY8b
         ZP3w==
X-Forwarded-Encrypted: i=1; AKwUvBwD9/q8+v1MgNbVtrPS0py64/PJFEyHrAdiMMiXgeDOL27bitfBZ78IzvJ/1Boh+iny6aDUvrk=@lists.linux.dev
X-Gm-Message-State: APuU4Z8amCKTjiYTB/CuoxDiBXrzfLYzWLt3PYuY3F4XKMk/1wdyAtuH
	VvuCZTcqbrGY6lKVGu8KCFVuEjSGb00dqIO+3KFO/Hpn6khYbfGfICLFCPuVMH9K+qi0IO1Pt4U
	zXmGilTBM+hMhNOu3NrZKDg==
X-Received: from wrrs13.prod.google.com ([2002:a5d:424d:0:b0:48c:4508:e80a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:41d1:b0:48e:6a23:4a09 with SMTP id ffacd0b85a97d-48e6e50d8cdmr26999378f8f.54.1793652445911;
 Mon, 02 Nov 2026 12:47:25 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:28 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-24-vdonnefort@google.com>
Subject: [PATCH v3 23/23] KVM: arm64: Stage-2 huge mappings for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable PMD-sized stage-2 block mappings for protected VMs. This is
possible whenever the stage-1 mapping allows it, that is, if it is
itself backed by THPs.

When a THP is found, an entire PMD_SIZE mapping is donated to the guest,
unless it overlaps an existing mapping. The new PMD_SIZE mapping can
only be broken down via the HVC __pkvm_host_split_guest() which the
hypervisor can request with PKVM_HYP_REQ_SPLIT.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c  | 128 +++++++++++++++++++++++++++---------------
 arch/arm64/kvm/pkvm.c |  34 +++++++----
 2 files changed, 104 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..df8ec7c798dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1489,11 +1489,9 @@ static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s
 	if (map_size == PAGE_SIZE)
 		return true;
 
-	/* pKVM only supports PMD_SIZE huge-mappings for non-protected VMs */
-	if (is_protected_kvm_enabled()) {
-		if (vcpu_is_protected(s2fd->vcpu) || map_size != PMD_SIZE)
-			return false;
-	}
+	/* pKVM only supports PMD_SIZE huge-mappings */
+	if (is_protected_kvm_enabled() && map_size != PMD_SIZE)
+		return false;
 
 	size = memslot->npages * PAGE_SIZE;
 
@@ -1843,42 +1841,23 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	return ret;
 }
 
-static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int pkvm_pin_user_pages(const struct kvm_s2_fault_desc *s2fd,
+			       struct kvm_s2_fault_vma_info *s2vi)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
-	struct kvm_s2_fault_vma_info s2vi = {};
-	struct kvm_vcpu *vcpu = s2fd->vcpu;
-	struct kvm_pgtable *pgt = s2fd->mmu->pgt;
-	struct mm_struct *mm = current->mm;
-	struct kvm *kvm = vcpu->kvm;
-	void *hyp_memcache;
-	int ret;
+	long ret;
 
-	hyp_memcache = get_mmu_memcache(vcpu);
-	ret = topup_mmu_memcache(s2fd->mmu, hyp_memcache);
-	if (ret)
-		return -ENOMEM;
-
-	ret = kvm_s2_fault_get_vma_info(s2fd, &s2vi);
+	ret = kvm_s2_fault_get_vma_info(s2fd, s2vi);
 	if (ret)
 		return ret;
 
-	ret = account_locked_vm(mm, 1, true);
-	if (ret)
-		return ret;
-
-	mmap_read_lock(mm);
-	ret = pin_user_pages(s2fd->hva, 1, flags, &s2vi.page);
-	mmap_read_unlock(mm);
-
+	ret = pin_user_pages_unlocked(s2fd->hva, 1, &s2vi->page, flags);
 	if (ret == -EHWPOISON) {
 		kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
-		ret = 0;
-		goto dec_account;
+		return ret;
 	} else if (ret != 1) {
-		ret = -EFAULT;
-		goto dec_account;
-	} else if (!folio_test_swapbacked(page_folio(s2vi.page))) {
+		return -EFAULT;
+	} else if (!folio_test_swapbacked(page_folio(s2vi->page))) {
 		/*
 		 * We really can't deal with page-cache pages returned by GUP
 		 * because (a) we may trigger writeback of a page for which we
@@ -1893,26 +1872,83 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * pages backed by swap in the knowledge that the GUP pin will
 		 * prevent try_to_unmap() from succeeding.
 		 */
-		ret = -EIO;
-		goto unpin;
+		unpin_user_page(s2vi->page);
+		return -EIO;
 	}
 
-	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), PAGE_SIZE,
-				      page_to_phys(s2vi.page), KVM_PGTABLE_PROT_RWX,
-				      hyp_memcache, 0);
-	write_unlock(&kvm->mmu_lock);
-	if (ret) {
-		if (ret == -EAGAIN)
-			ret = 0;
-		goto unpin;
+	s2vi->pfn = page_to_pfn(s2vi->page);
+
+	ret = transparent_hugepage_adjust(s2fd, &s2vi->pfn, &s2vi->gfn);
+	if (ret < 0) {
+		unpin_user_page(s2vi->page);
+		return ret;
 	}
 
+	s2vi->vma_pagesize = ret;
+
 	return 0;
+}
+
+static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	struct kvm_s2_fault_vma_info s2vi = {};
+	struct kvm_vcpu *vcpu = s2fd->vcpu;
+	struct kvm_pgtable *pgt = s2fd->mmu->pgt;
+	struct mm_struct *mm = current->mm;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long unaccount;
+	void *hyp_memcache;
+	u64 size;
+	int ret;
+
+	hyp_memcache = get_mmu_memcache(vcpu);
+	ret = topup_mmu_memcache(s2fd->mmu, hyp_memcache);
+	if (ret)
+		return -ENOMEM;
+
+	ret = pkvm_pin_user_pages(s2fd, &s2vi);
+	if (ret == -EHWPOISON || ret == -EAGAIN)
+		return 0;
+	else if (ret)
+		return ret;
+
+	size = s2vi.vma_pagesize;
+
+	ret = account_locked_vm(mm, size / PAGE_SIZE, true);
+	if (ret)
+		goto unpin;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
+		ret = -EAGAIN;
+	} else {
+		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), size,
+					      __pfn_to_phys(s2vi.pfn), KVM_PGTABLE_PROT_RWX,
+					      hyp_memcache, 0);
+
+		/* undo transparent_hugepage_adjust() and try again */
+		if (ret == -E2BIG) {
+			u64 ipa = ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE);
+
+			size = PAGE_SIZE;
+			ret = pkvm_pgtable_stage2_map(pgt, ipa, size,
+						      page_to_phys(s2vi.page),
+						      KVM_PGTABLE_PROT_RWX,
+						      hyp_memcache, 0);
+		}
+	}
+	kvm_fault_unlock(kvm);
+
+	unaccount = (ret ? s2vi.vma_pagesize : s2vi.vma_pagesize - size) / PAGE_SIZE;
+	account_locked_vm(mm, unaccount, false);
+
 unpin:
-	unpin_user_page(s2vi.page);
-dec_account:
-	account_locked_vm(mm, 1, false);
+	if (ret) {
+		unpin_user_page(s2vi.page);
+		if (ret == -EAGAIN)
+			ret = 0;
+	}
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 58ca7ffa68e3..5aea9e9aef17 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -572,9 +572,8 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 			continue;
 
 		page = pfn_to_page(mapping->pfn);
-		WARN_ON_ONCE(mapping->nr_pages != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
-		account_locked_vm(kvm->mm, 1, false);
+		account_locked_vm(kvm->mm, mapping->nr_pages, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
 		kfree(mapping);
 	}
@@ -627,9 +626,17 @@ void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
 	WARN_ON_ONCE(!RB_EMPTY_ROOT(&pgt->pkvm_mappings.rb_root));
 }
 
+/*
+ * Return:
+ *  0		- Mapping successfully installed.
+ *  -EAGAIN	- Mapping already exists due to a concurrent vCPU fault race.
+ *  -E2BIG	- Mapping overlaps an existing smaller one.
+ *  -EFAULT	- Mapping overlaps an existing poisoned address.
+ *  < 0		- Other negative error code on invalid arguments or HVC failure.
+ */
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
-			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc, enum kvm_pgtable_walk_flags flags)
+			    u64 phys, enum kvm_pgtable_prot prot,
+			    void *mc, enum kvm_pgtable_walk_flags flags)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	struct pkvm_mapping *mapping = NULL;
@@ -639,20 +646,22 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
-	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr | size)))
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 
 	if (kvm_vm_is_protected(kvm)) {
-		/* Protected VMs are mapped using RWX page-granular mappings */
-		if (WARN_ON_ONCE(size != PAGE_SIZE))
-			return -EINVAL;
-
 		if (WARN_ON_ONCE(prot != KVM_PGTABLE_PROT_RWX))
 			return -EINVAL;
 
+		if (mapping && mapping->nr_pages == 1 && size > PAGE_SIZE)
+			return -E2BIG;
+
 		/*
 		 * We either raced with another vCPU or the guest PTE
 		 * has been poisoned by an erroneous host access.
@@ -662,10 +671,11 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return ret ? -EFAULT : -EAGAIN;
 		}
 
-		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, size / PAGE_SIZE);
+
+		/* Warn if -E2BIG is overloaded */
+		WARN_ON_ONCE(ret == -E2BIG);
 	} else {
-		if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
-			return -EINVAL;
 
 		/*
 		 * We either raced with another vCPU or we're changing between
-- 
2.56.0.385.gac671c819a-goog


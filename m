Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A0D5476CE
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082512; cv=none; b=b0doJ1lmzLlUVPMsVBdRY9rq6JFl7g7yP+CsJZE4Sy77lFqNLK3geT95Vkl6NJnEGh6kn1J3C40k7RkSbuS0DObXIjbOvB4zuDjtUOi4WsOk/q7ttiMsrUOpB3Hej8j8aprANau8dudEs+24UVzypv9X7yd78rWGa057pq7jH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082512; c=relaxed/simple;
	bh=Tho010afSR5e7M2RVrV8CHpMF5HcDnKnirdqutgi/Qc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IpFgOUZAza5OUXVycrZxmBaUd7anLGLL7gNmrjP0UpmS9BRjGisdjH9qEICL1ewAnqqeu/fOh3iz3t56qaqAcN1FtDSAt9G7WiHAvpKwgJ3SrE/uDKje8MyCRj5Vp/D+3BySBw8zPcQD2KHizrwFHOXMr/eEHVSiPhnTmAVB73E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3QjX1rW; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3QjX1rW"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e661c6440so23026635e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082509; x=1790687309; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oOKAAp8+OItHea6211ysyzU6E4IDtXCLElD0UjeYReI=;
        b=n3QjX1rW135BmN580Pb+arS2fjVTgSBoLe2wJTjqK1WjaaJ0/xsPAtwZaiPdUpDfIA
         igzXM2KvnmawCIx1UQVF0DxQYeBnsT/fyJQfEgBYWpzf4LSqdgueWzdaE21nxez5bji6
         7G7F4rfEgzz+RNIktje5HB9b35KzLCx2FDrgaitfN47VKHUX7GkClulzmacs4aXa37P1
         BuHh4ExWfS5Rr85J/KVPsuvkRFDUFKSl9odC8sZdlBfwxWNgFJ3EhpfvxUhQqGxo/uuc
         0h8F5p2XMjtA+TUfoXyVfCfmjVHnf4dWsmkIlcy7pn2C38N/jx5zaZN2HGkqrMNsWPYZ
         uPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082509; x=1790687309;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oOKAAp8+OItHea6211ysyzU6E4IDtXCLElD0UjeYReI=;
        b=FEq+eyLdV87OBOzonIVk5omQqs9WOERr0Vyyauw1/bw74XUiYiiDfqmavKNjk2ykBf
         r1bxV7jQ/hJn2RXfAAHEv5GFKtbs6tmRoGXNMaB4VSFGCpMwy/n/GylDV6OwCgL6QtyK
         yCwdUOyKIgCxtUKNZXekGHYwNTVYpvexyj+X1hhYbugqe6wp8HT8j67q3rA0o9y8+7K6
         ngtPHBHJ8GAt+nVmlXMJgc3HUG/xK3uMpVmKsy8hjMAoFWE3pNnzEP740hQDKdEgz0aN
         Blsd4d1RvFfLmUUTcbq/AswwzGCETfJrQwczVeeL1gX2TZu9S9tWsHrECEzMZrzFR3yW
         WHoQ==
X-Forwarded-Encrypted: i=1; AKwUvBygZTTxFG2dTVpDKLJpJhNfotho3bgPcw6NO5de82YCVjtmnRmIv5BdpSer/eeIPekSfQ2Q/uI=@lists.linux.dev
X-Gm-Message-State: AFuF++l1ToxznH9pw9JAIf2O3h++oKbAebz+mOYA6SpK12TVLwKW7zBB
	XYSA7wLaJ5oV/4u2m59Y1ZbqCVQb/SSYbBpS6kuCvnGgeu+9ZQwz5+3feVUEZVaMmBOSVPaBdpe
	aBll9F1HH0DyMxnJDmudY7A==
X-Received: from wmbf23.prod.google.com ([2002:a05:600c:5957:b0:49d:6bb2:d0f4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a14:b0:49d:7f5:4cdd with SMTP id 5b1f17b1804b1-49fc574be1dmr194770765e9.27.1790082509065;
 Tue, 22 Sep 2026 06:08:29 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:18 +0100
In-Reply-To: <20260922130821.1666713-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-4-vdonnefort@google.com>
Subject: [PATCH v1 3/6] KVM: arm64: Move pkvm_mem_abort()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Move pkvm_mem_abort() below kvm_s2_fault_get_vma_info() so it can
resolve stage-2 fault VMA metadata without forward declarations.

No functional change intended.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c | 138 +++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9dfaf4f277b5..242f63066252 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1706,75 +1706,6 @@ struct kvm_s2_fault_vma_info {
 	bool		map_non_cacheable;
 };
 
-static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
-{
-	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
-	struct kvm_vcpu *vcpu = s2fd->vcpu;
-	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
-	struct mm_struct *mm = current->mm;
-	struct kvm *kvm = vcpu->kvm;
-	void *hyp_memcache;
-	struct page *page;
-	int ret;
-
-	hyp_memcache = get_mmu_memcache(vcpu);
-	ret = topup_mmu_memcache(vcpu, hyp_memcache);
-	if (ret)
-		return -ENOMEM;
-
-	ret = account_locked_vm(mm, 1, true);
-	if (ret)
-		return ret;
-
-	mmap_read_lock(mm);
-	ret = pin_user_pages(s2fd->hva, 1, flags, &page);
-	mmap_read_unlock(mm);
-
-	if (ret == -EHWPOISON) {
-		kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
-		ret = 0;
-		goto dec_account;
-	} else if (ret != 1) {
-		ret = -EFAULT;
-		goto dec_account;
-	} else if (!folio_test_swapbacked(page_folio(page))) {
-		/*
-		 * We really can't deal with page-cache pages returned by GUP
-		 * because (a) we may trigger writeback of a page for which we
-		 * no longer have access and (b) page_mkclean() won't find the
-		 * stage-2 mapping in the rmap so we can get out-of-whack with
-		 * the filesystem when marking the page dirty during unpinning
-		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
-		 * without asking ext4 first")).
-		 *
-		 * Ideally we'd just restrict ourselves to anonymous pages, but
-		 * we also want to allow memfd (i.e. shmem) pages, so check for
-		 * pages backed by swap in the knowledge that the GUP pin will
-		 * prevent try_to_unmap() from succeeding.
-		 */
-		ret = -EIO;
-		goto unpin;
-	}
-
-	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
-				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
-				      hyp_memcache, 0);
-	write_unlock(&kvm->mmu_lock);
-	if (ret) {
-		if (ret == -EAGAIN)
-			ret = 0;
-		goto unpin;
-	}
-
-	return 0;
-unpin:
-	unpin_user_pages(&page, 1);
-dec_account:
-	account_locked_vm(mm, 1, false);
-	return ret;
-}
-
 static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 				     struct kvm_s2_fault_vma_info *s2vi,
 				     struct vm_area_struct *vma)
@@ -2235,6 +2166,75 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
+	struct kvm_vcpu *vcpu = s2fd->vcpu;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct mm_struct *mm = current->mm;
+	struct kvm *kvm = vcpu->kvm;
+	void *hyp_memcache;
+	struct page *page;
+	int ret;
+
+	hyp_memcache = get_mmu_memcache(vcpu);
+	ret = topup_mmu_memcache(vcpu, hyp_memcache);
+	if (ret)
+		return -ENOMEM;
+
+	ret = account_locked_vm(mm, 1, true);
+	if (ret)
+		return ret;
+
+	mmap_read_lock(mm);
+	ret = pin_user_pages(s2fd->hva, 1, flags, &page);
+	mmap_read_unlock(mm);
+
+	if (ret == -EHWPOISON) {
+		kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
+		ret = 0;
+		goto dec_account;
+	} else if (ret != 1) {
+		ret = -EFAULT;
+		goto dec_account;
+	} else if (!folio_test_swapbacked(page_folio(page))) {
+		/*
+		 * We really can't deal with page-cache pages returned by GUP
+		 * because (a) we may trigger writeback of a page for which we
+		 * no longer have access and (b) page_mkclean() won't find the
+		 * stage-2 mapping in the rmap so we can get out-of-whack with
+		 * the filesystem when marking the page dirty during unpinning
+		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
+		 * without asking ext4 first")).
+		 *
+		 * Ideally we'd just restrict ourselves to anonymous pages, but
+		 * we also want to allow memfd (i.e. shmem) pages, so check for
+		 * pages backed by swap in the knowledge that the GUP pin will
+		 * prevent try_to_unmap() from succeeding.
+		 */
+		ret = -EIO;
+		goto unpin;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
+				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
+				      hyp_memcache, 0);
+	write_unlock(&kvm->mmu_lock);
+	if (ret) {
+		if (ret == -EAGAIN)
+			ret = 0;
+		goto unpin;
+	}
+
+	return 0;
+unpin:
+	unpin_user_pages(&page, 1);
+dec_account:
+	account_locked_vm(mm, 1, false);
+	return ret;
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
-- 
2.55.0.1082.g2b9226bbc0-goog


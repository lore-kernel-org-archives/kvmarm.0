Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E935FF63
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826856; cv=none; b=cAEmT51Wyx4Yuy13ng0ltNq9AC/ad98QxquAERiiWgeUUU8nsMkfyjYJye9m/j8aXC3BIxagfkhnWXUBWS8QCjh7XmfYZ6VZvoPt7RcF0dAr6vGTIa65e6vTF4cGk+Sm9IgqVSGCWxoO9pbu4ku9PENEmPt8bezi8sEOUL5M0bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826856; c=relaxed/simple;
	bh=yYkwoz6p2c9KJC10PuGWPN5cZRUoVCbtirTqbhv0Lyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkthu3WnkKn78lBzO2V53bu/+LQRedUOYzyuN6eRDurQVR+eVclaF7OFAcrdUyPIcHMhVx2p72eQp4+QtnBkK+Ts0kwSGkUiMXiZ0VxYBg0qBMKd3QMEyiSaD2j13hE0kNwn0eaOnIQEeqDapeGEnUP4Skw+klLhfTpK949MW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCXvcM+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCXvcM+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00B8C116C6;
	Mon, 19 Jan 2026 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826856;
	bh=yYkwoz6p2c9KJC10PuGWPN5cZRUoVCbtirTqbhv0Lyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCXvcM+UPjydjBb7u9K2GDWhb0T7Ct7MbAEc+RUEZpgLApY0F3PlGvfbda3Gnr68s
	 Jrjl8eFFLhS7G1wI4x9We4GchP2uVsAi+VlI1g9YrXC4o6+FKGZO4QjutkvMWpuBJS
	 IbwRRSxJww9SGEJSOp40u3/8pXCoQmPbgwTtbvjqBaVVGLr9b8BGSjYukDi4H1CGKd
	 w9rBh3zr0bKg2bgW/AuErb+t5RL7h/y1iNRLtKfHbHvKz+/wFjdZFSCAy3OQZXn8Me
	 uCfWUCdrO0ENTWOuotboqwV55aUplbhNk9YN6A8xDIkXLQWOYQXQldme1JkHdFNJpK
	 Yunxj8aZcRkrw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 14/35] KVM: arm64: Handle aborts from protected VMs
Date: Mon, 19 Jan 2026 12:46:07 +0000
Message-ID: <20260119124629.2563-15-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new abort handler for resolving stage-2 page faults from
protected VMs by pinning and donating anonymous memory. This is
considerably simpler than the infamous user_mem_abort() as we only have
to deal with translation faults at the pte level.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 89 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 81 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a23a4b7f108c..b21a5bf3d104 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1641,6 +1641,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return ret != -EAGAIN ? ret : 0;
 }
 
+static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		struct kvm_memory_slot *memslot, unsigned long hva)
+{
+	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct mm_struct *mm = current->mm;
+	struct kvm *kvm = vcpu->kvm;
+	void *hyp_memcache;
+	struct page *page;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &hyp_memcache);
+	if (ret)
+		return -ENOMEM;
+
+	ret = account_locked_vm(mm, 1, true);
+	if (ret)
+		return ret;
+
+	mmap_read_lock(mm);
+	ret = pin_user_pages(hva, 1, flags, &page);
+	mmap_read_unlock(mm);
+
+	if (ret == -EHWPOISON) {
+		kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
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
+	ret = pkvm_pgtable_stage2_map(pgt, fault_ipa, PAGE_SIZE,
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
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -2190,15 +2258,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
-			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
+	if (kvm_vm_is_protected(vcpu->kvm)) {
+		ret = pkvm_mem_abort(vcpu, fault_ipa, memslot, hva);
+	} else {
+		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
+				!write_fault &&
+				!kvm_vcpu_trap_is_exec_fault(vcpu));
 
-	if (kvm_slot_has_gmem(memslot))
-		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
-				 esr_fsc_is_permission_fault(esr));
-	else
-		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-				     esr_fsc_is_permission_fault(esr));
+		if (kvm_slot_has_gmem(memslot))
+			ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+					 esr_fsc_is_permission_fault(esr));
+		else
+			ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+					     esr_fsc_is_permission_fault(esr));
+	}
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.52.0.457.g6b5491de43-goog


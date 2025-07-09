Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F302949E5
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058826; cv=none; b=IaCCfCXA8vQgUKmtQ0B9x/x0MCjsXFP6PrsICK9ADo+2E5TNauKKRyR4qbXE90sVC/RerkLKM6/uFfqyJqbPQCl3h6w3JFXkBc16iln+EDnBk+qNOEEgpz4HwIfjhTcxJvQraubcp0KzZKcXaYTC1cGNbmYNA/mnSxyIbhHEgzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058826; c=relaxed/simple;
	bh=/lyEC/CHrOlmUB4RO/dGwgjcSgugjLslHA/OSikH3iU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U6yaRJFd7DSLdzubcjuaGuFmlovlc76qG4cilrmJXEF5uTG3xVRoK1mTXtyaQTNBXD43ORG/G2q1jUyeZB2foJrxs4udlbuUYGBuzFfaUSNlx4ngP6sMKQ9PjGc7Hg9Ko/E9Jzxe8WBvQUdKGlEOdwrgO8FOoRBcQVQJ5F437Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qrxn6WYb; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qrxn6WYb"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a579058758so2291102f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058823; x=1752663623; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M+QCqIPuYfpNuxA4wweiCJLHxy17OhUl3W9TlqbPqcY=;
        b=Qrxn6WYbRuyuBgLuWYUe/usOR1aCSz5oDcNMzSijkCJzgzhvQ0T2CSWO3rYRh7f47/
         nk0UBjKy7BNVz/ogw105Eq1HmjrroNIAcOxdA5pMIwz+lgaG1T54IpmpXFqLbNQ69eeO
         xpCR2621dGIVmWe2xS5tqk8mIKOdv/DcGGtGBP9bhRjl0H7E0HaHifjO/VffeqaS2YPZ
         jgTyQASwtyD6o+sWihgzYo95/mNPgvDylJNNKKgxrAVpR3g0k2o4WOBRblRQNTRpVfJu
         CcL9CsWmuInwn/0Ltjipv1/Zpxi4et9tCFNUDaQcNfru244LnzXOM5IcyjRr9hz8rEes
         xftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058823; x=1752663623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+QCqIPuYfpNuxA4wweiCJLHxy17OhUl3W9TlqbPqcY=;
        b=qa89g0R/MeoQSBeImNSFCqHe91xj3Z2AzIpjazLzK+210mjeALyMHNRI6IVzVcJfgu
         ijvcAgYDHarLEyuJ4YPQoRyLRI3OMkxPLzAKdkIIhicOxFfGrlqbzdb5SrSAtJ4SFrfQ
         xKkh4A4C+9owVKjXSo84+ti4Eu02FIdFCCIBjDtXv1j1kQtxzBB4wlgxwZSYNyo8dHNT
         u6EE5E/HR3ToI59qsnxBBB1kFR6NwvJKiO1Fh4NVYtycy1tLws1jJzQ5NdO/W7JqSOf7
         rng6/AZVd4crjawtxVHyxr8hC4XuyTiJSAIu3vXDyEg+A+XvpMjZ2ZLaZY35gYkYsqAJ
         zY1g==
X-Forwarded-Encrypted: i=1; AJvYcCXn3i4ZTpV2Os7MQVwRfUuZCa6hCx8UUU2opU6hQKlmExLQCRbq+bF4z3UBZVCH+IDjbM0mAEY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzry5wEIvczIAGmlj7tqc9bTq5dDYtUJPjyPtkkxZi/f8bMSmLp
	8VZ5dGAwRQAWdp0DhEjAipMDTTwL2RAwrQNqZpxxX17acFkifB0OYBQV8sVtRVAY64vytevZnWx
	XGQ==
X-Google-Smtp-Source: AGHT+IEM/pEma3Sd9qaIbeLMaRF9FjzoCSs8lhQkRdTlI2IxORmEAPPSn935X/OEjBNHP0I9VmmcSxrzDA==
X-Received: from wmbhe12.prod.google.com ([2002:a05:600c:540c:b0:450:d104:29f8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c8:b0:3b5:e31e:5bb6
 with SMTP id ffacd0b85a97d-3b5e458893emr1540506f8f.42.1752058822807; Wed, 09
 Jul 2025 04:00:22 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:42 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-17-tabba@google.com>
Subject: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 architecture support for handling guest page faults on memory
slots backed by guest_memfd.

This change introduces a new function, gmem_abort(), which encapsulates
the fault handling logic specific to guest_memfd-backed memory. The
kvm_handle_guest_abort() entry point is updated to dispatch to
gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
determined by kvm_slot_has_gmem()).

Until guest_memfd gains support for huge pages, the fault granule for
these memory regions is restricted to PAGE_SIZE.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 58662e0ef13e..71f8b53683e7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool write_fault, exec_fault, writable;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct page *page;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+
+	if (write_fault && exec_fault) {
+		kvm_err("Simultaneous write and execution fault\n");
+		return -EFAULT;
+	}
+
+	if (is_perm && !write_fault && !exec_fault) {
+		kvm_err("Unexpected L2 read permission error\n");
+		return -EFAULT;
+	}
+
+	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY);
+
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault ||
+	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	     (!nested || kvm_s2_trans_executable(nested))))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	kvm_fault_lock(kvm);
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+						 __pfn_to_phys(pfn), prot,
+						 memcache, flags);
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1536,7 +1608,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1963,8 +2035,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.50.0.727.gbf7dc18ff4-goog


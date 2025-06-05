Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558992749F9
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137916; cv=none; b=SuL1bAuUs+0/YKMTBvKF381T5TkddLRyO19ma6azvhm9plQxxq9k4En1ZmWSgdHqUHSuaaBm0ZZx/T/4biCzcn3zYuS0pLVJc4TJ6rfem0eAH8OEAMGcbL4ZUwToMMwoHF+VTLwJB7BRvxgxg3hlUWJRMzoRnGu1pScTGcdMXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137916; c=relaxed/simple;
	bh=j3r7Coku7j3Jd+pKg8DvBXPHSPEHnnoo2Ks6Ban0GCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tn+QbUwPsfwLGfNFk2w8PD1kksXC1guDRVSQ2AP1pX5rggPISp5UgHz/aZpRR7g7rrZX8ZxN2hF/B8+eyJaiSgOcfmikx476Yu2MkRHUJ2hd3q8bdW+srhQdZNB5+vLqlTukkTsykx7ul3l57zwconT3kDEF3uZoPTg9rayOe3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D+CLk+zJ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D+CLk+zJ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4517abcba41so6486385e9.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137912; x=1749742712; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NPZBE5PTGW9kWBzPk02s4iKZXmTT2aIVBFlSN4SanJw=;
        b=D+CLk+zJTt3hnvoe829c9n7l0dM5dfKUM8m9oPXiVfMz8Q8IjjkfVk1hyIKeO0UHLe
         3Iy/4D0jYJtCV+rlpvUoiQ3S7ys+gwUENdAGzXwor3hsHMpJAQ3U9mU3GdbstDR0XM3u
         iw++9/jVOarduMnt5kkVnJxR3tF/tCSXugRzuVKcUbt9NBFMfH4+hcTfzaIfPN3VAuLL
         ETKq5AMw5AMTQkQp4yWzBgb3kJS/yR3fWcljqQR6xd93wiFzwV0GLnn8f5a4DblRS+Pa
         r4Vl5oYadfG7LY6QpgHDif0msZwJPiPXcsSpDgSoF3gzhBgQG8+ADxlYMXywDPEJhkZq
         EXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137912; x=1749742712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NPZBE5PTGW9kWBzPk02s4iKZXmTT2aIVBFlSN4SanJw=;
        b=iffq3sbvy592T3A9oPEIflgs8Cs7IUkBDqNqfpI6MOg7FmF/MEm9DPmy45Rly/6zoP
         OossocfjZxx5U/SkjDjNjQ39J13v0G46v8s8R9dYW/DVfnOm41jCnoXZx/dSbxJ4kzbB
         V2ZwfaZtqzZQ5nOOTObXBWpwS+5ge92ZO9p7f4GKrU8s5U6SdVxM64XwN1+IIjU7nVoE
         Qc2p5sUqs7xddYeDldbNoQru2I6LLmwbnUt2Qbsgt4bwN2+5st3DKEROrysLuf+NLbVz
         m1rUOttawuOWzJRkTRitUHEXqrVNeuT9XfhV0paiJ3lb08nA+APAQD+r2IOOXMyKkV7W
         zLaw==
X-Forwarded-Encrypted: i=1; AJvYcCVJWzWkxML11gh/T9XVPBB/fset3rj1yWl0qwOJ6oe5LE1Av42FOJwtIO+4dtO3Or8uVC9h264=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLm0BlppC9nprzlnpmRuoJz3VbvnzCQpKVyPYSn4c0DBpUs2Se
	3DW3xp88Ou93SgRtGOBM/T8iIGScCAIkfGxq21QIRVyxNREAX22myO2PSwpFNr9CvHun0yXvkll
	gCg==
X-Google-Smtp-Source: AGHT+IGMJty4mR+w6Q7W1YmFTUSwU16vv8WAlkYUzsCh1k98WN49+HkHCW9IHOZiu4FjckwQZIFoRzzqew==
X-Received: from wmbdt15.prod.google.com ([2002:a05:600c:630f:b0:440:595d:fba9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3595:b0:43d:7588:667b
 with SMTP id 5b1f17b1804b1-451f0a88e69mr92705785e9.10.1749137911624; Thu, 05
 Jun 2025 08:38:31 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:56 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-15-tabba@google.com>
Subject: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest page faults
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

Add arm64 support for handling guest page faults on guest_memfd backed
memslots. Until guest_memfd supports huge pages, the fault granule is
restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ce80be116a30..f14925fe6144 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool logging, write_fault, exec_fault, writable;
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
+	ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	logging = memslot_is_logging(memslot);
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
+	writable = !(memslot->flags & KVM_MEM_READONLY) &&
+		   (!logging || write_fault);
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
+	if (is_perm) {
+		/*
+		 * Drop the SW bits in favour of those stored in the
+		 * PTE, which will be preserved.
+		 */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
+	} else {
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+					     __pfn_to_phys(pfn), prot,
+					     memcache, flags);
+	}
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
@@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
2.49.0.1266.g31b7d2e469-goog


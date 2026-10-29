Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287802;
	b=pASrqyTXeJvndReAXUd4Wvn46mq53xFOvIDnrKZTcV1roydUJWZMO1qr0QkyH02AmZ+h
	 z9C4GWyY5FJPuwEW1LRpb5jYab1dpt/dKmfeGdT9lGmZfX10pQw3ci/tifU9G5zVfprPJ
	 YXmm+UpOtyAeRKf7ZpknpdOyFkxFBOhoLMB5G9hRv/VX7S/1SS09nAGHRTaO3UoNEJgrg
	 VIfDLJHATdkX/5aoB3s5qgt3z/Z47B27eWBgp4TCEpjfFkJRIUnRBOfhjOX5O7eTA/FYr
	 S/YV+RddoJNtE3LI50XAcRJnDmitw+R6pzpxHZj8WRUxrr5ThLgNOvRI/OtFQNDXMng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287802;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4uo4YwZye5gbwG4LR+me6BP44T84OykPaJHKbYTcGKA=;
	b=wgc8O3qW4oslsPCDCPcr7+SSNLlXHWUpj+9JDjOfJ04GQ3/buy6wU5V1dkU20JPht5Ko
	 HPAjMALD/4lMtuvhunOoRh90GF5WOSD0d3/Az3K7bFVZu3vJ3lImJE7Ddp94QDNPs/baB
	 ScMefqZbG+jCpy0N7O3h0wg6WKErzh8am/mIsfxQsSm0nN9iarwO+L47QyH89Xa+w8u3u
	 uPoPkwka2rrvDWymFce6mf8fLhp3a9QhGjUM6iO/GTotvb9H17GJ4WfHJVpdpqOPFCFwJ
	 /25fz6EgaAmMCcBqdR3qeJP8I64sgwJTQ9D8WI/ISyRWI45WS/b9KrdcBhyCsNoMEtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="XZoYqSH/";
	arc=none smtp.remote-ip=91.218.175.105
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AA760A262A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 15:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5AA760A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XZoYqSH/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=la7E0PWX7gnalEHWFdRBnWD3MsgOWAc+7PnzT7S9dEs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793287799; v=1; x=1793892599;
 b=XZoYqSH/aQZxkCrLSCy//P1p6IxM8xGicTQUKfRs6DhKhsCoLR7vUNmXoR7DXAk+IY1Kz+m1
 8t4fznkRl005Twkt3hEWMLvn26zd/omJrEJN565kpgb7OrlvZhcGaS2ND7zcVuNAQkx9BaYzWyX
 XI/YS5MSmQDQY9Qh93mLonL0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8a1ab3f95cac30d7;
	Thu, 29 Oct 2026 15:29:59 +0000
X-Mizu-Trace-ID: 8a1ab3f95cac30d7
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	qperret@google.com,
	weilin.chang@arm.com,
	tabba@google.com
Subject: Re: [PATCH v2 22/22] KVM: arm64: Stage-2 huge mappings for protected VMs
Date: Thu, 29 Oct 2026 15:29:59 +0000
Message-ID: <20261029152959.3552746-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135053.146435-23-vdonnefort@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com> <20260911135053.146435-23-vdonnefort@google.com>
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

Hi Vincent,

On Fri, 11 Sep 2026 14:50:53 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
[...]
> @@ -513,17 +512,23 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
[...]
> +                /*
> +                 * If a huge mapping overlaps an existing PAGE_SIZE one,
> +                 * then the VMM has played games with the stage-1. Abort.
> +                 */
> +                if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
> +                        return -EFAULT;

A guest can hit this on its own, without the VMM touching its stage-1.
I ran into it while porting your unposted v3 to android18-7.3, and v3
has the same race. A pVM shares one page of a 2M block, and another
vCPU touches the block during the split's break-before-make. The host
sizes that fault at 2M from the THP, but under the mmu_lock it finds
the split's PAGE_SIZE mappings.

I made the following change in the android18-7.3 port. It maps just
the faulting page, since retrying alone re-faults forever if the VMM
puts a fresh THP behind a partly mapped block. If you're happy with it,
can you fold it into v3?

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 70b002eb17e05..72fc2577f51cd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1921,6 +1921,7 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
+	u64 size;
 	int ret;
 
 	hyp_memcache = get_mmu_memcache(vcpu);
@@ -1936,13 +1937,21 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret)
 		goto unpin;
 
+	size = s2vi.vma_pagesize;
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
 		ret = -EAGAIN;
 	} else {
-		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), s2vi.vma_pagesize,
+		ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), size,
 					      __pfn_to_phys(s2vi.pfn), KVM_PGTABLE_PROT_RWX,
 					      hyp_memcache, 0);
+		/* The block may hold PAGE_SIZE mappings from a split: map the page alone. */
+		if (ret == -EAGAIN && size > PAGE_SIZE) {
+			size = PAGE_SIZE;
+			ret = pkvm_pgtable_stage2_map(pgt, ALIGN_DOWN(s2fd->fault_ipa, size), size,
+						      page_to_phys(s2vi.page), KVM_PGTABLE_PROT_RWX,
+						      hyp_memcache, 0);
+		}
 	}
 	kvm_fault_unlock(kvm);
 	if (ret) {
@@ -1953,6 +1962,9 @@ static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		goto unpin;
 	}
 
+	if (size != s2vi.vma_pagesize)
+		account_locked_vm(mm, (s2vi.vma_pagesize - size) / PAGE_SIZE, false);
+
 	return 0;
 unpin:
 	unpin_user_page(s2vi.page);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8a74df9f9fec3..6b5df4595f6a6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -650,14 +650,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return -EINVAL;
 
 		/*
-		 * If a huge mapping overlaps an existing PAGE_SIZE one,
-		 * then the VMM has played games with the stage-1. Abort.
-		 */
-		if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
-			return -EFAULT;
-
-		/*
-		 * We either raced with another vCPU or the guest PTE
+		 * We either raced with another vCPU, a block overlaps the
+		 * PAGE_SIZE mappings of a guest-driven split, or the guest PTE
 		 * has been poisoned by an erroneous host access.
 		 */
 		if (mapping) {

Cheers,
/fuad

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795789721;
	b=o+pJdDeZDfvZpUztyuUqpXB75/voCR+USbNtQRXL+/Y6GCKJvebcF2L/35q4VPpDFGRX
	 iN9CjeqLeYlIA+anQbvsZvlBK1hMIcjfh9BF28UiNHY4kpDft3wQFDP9awLJVU4nNkUxV
	 1Js0xUxjrBt/7oLhqgFVnu0Jf8hmMTWymEFUkk+c+h0gHDemYBpbEQF7kdBDUbCIgg9u5
	 EiH/xC/97dZTpoUDSxXi2hr9oHeiYZfrwP9cevEUb2Pca+o6i+bpoXUN1VLGUMzwqBGrK
	 zdpeiZFLGgR7TYqOblKSiWOpUpyrpSYmpcwejt4E2XiyFpPNczb4YpKRQPj4KzY5JzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795789721;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=TjVvH8NZqlBve9bypwBIcPsakGhfaX78G28bM4dn8ZY=;
	b=tnIRjQONMvR9Q+h/S7gdGJBkokdN99hk6txQJ9KRqVJpfCB1fq4msZ+/CCyZ2/DHW85h
	 8cZ//n+DKBButc3mC/CZBmCsiDP/5mu0GkJh1mskUQx7m2929iROKzFH2YjYyyU8kKS05
	 EpCEcLmJQbSJnPXzzxV1k6CI3Y4LJ51iDDaGZQyEDGy6wr5tFC4mMT1TPrYAyKS7x+krr
	 qunKPkxdAIT2Fm06X5kktL5ECIl4YC8/NLTBa/Y58b0Wsh1uhn7sMxuWJ2cP/4Fs3C6Nq
	 PWuuQmgrO8BsMbKQNyKBiLBmD2CmWiuXF6KnRscctR4gbzUTDr/8Kpe2A3Ce6v4AL1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DJLnuq5r;
	arc=none smtp.remote-ip=95.215.58.74
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA7606B401
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 14:28:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BDA7606B401
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DJLnuq5r
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LlRJdcs2tH2PBRhiheJnivWS5Dj9upnmbgY2TWeD+iQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795789717; v=1; x=1796394517;
 b=DJLnuq5r/I4dQ9dXom2tD2xpCJ7hGrk2a70EGiSarbdEK02gxfA/8M3n+Eekp9SqWq+8YBuG
 x/BFHNJ9L8uIxUxo82xhLQ/tKXO3RrV/swXIhlis463eibPM6b5HFLwL2qId4SpytkN942gBUSj
 PVTwtxdWBvFuPfB/OWqP3W2Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bdd05ed73b3b6aea;
	Fri, 27 Nov 2026 14:28:37 +0000
X-Mizu-Trace-ID: bdd05ed73b3b6aea
X-Migadu-Flow: FLOW_OUT
Message-ID: <d2b6e735-a685-4e79-bb39-2fb75ebecd09@linux.dev>
Date: Fri, 27 Nov 2026 14:28:32 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
To: Marc Zyngier <maz@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Leonardo Bras <leo.bras@arm.com>
Cc: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, rkeilty@meta.com, atish.patra@linux.dev,
 dgreid@meta.com, Lorenzo Stoakes <ljs@kernel.org>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <86wlpzycnn.wl-maz@kernel.org>
 <563d2406-dcfe-43b6-8f21-2a7694f1f266@linux.dev>
 <86v75jy48c.wl-maz@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <86v75jy48c.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 26/11/2026 07:58, Marc Zyngier wrote:
> On Thu, 26 Nov 2026 14:32:04 +0000,
> Usama Arif <usama.arif@linux.dev> wrote:
> 
> [nonsense deleted]
> 
>>> Now, to the patch itself: I see no reason to special-case this. If
>>> kvm_mmu_cache_min_pages() is an indication of what is needed, then
>>> this macro should be driven by it, or the whole allocator take it into
>>> account. And then you adjust it by whatever fudge factor seems
>>> appropriate.
>>>
>>
>> Completely agree! [1] does that: no page-size special case, and
>> a capacity of KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL for every
>> page size.  It can't track kvm_mmu_cache_min_pages()
>> at runtime: the vCPU's cache is shared by the canonical and NV shadow
>> MMUs, and its capacity must stay fixed. So it has to cover the largest
>> minimum, which stage-2 caps at 3, and 4 is that plus one page of fudge.
> 
> Of course it can. That's not exactly rock science to add, rather than
> relying on another set of bad heuristics.

You're right, it can. __kvm_mmu_topup_memory_cache() fixes a cache's
capacity at its first refill, but nothing requires that to be a
compile-time constant. Does something like the patch below work for
you? Each VM records twice the largest kvm_mmu_cache_min_pages() of its
stage-2s as they are initialised, and every top-up passes that to
__kvm_mmu_topup_memory_cache(), as the eager-split cache already does.


> And this must cover more
> than a single mapping per top-up, because that has a ripple effect on
> the speed at which we can split large blocks (funnily enough, people
> care about that stuff).
> 
> 	M.
> 

With twice the minimum, each refill covers at least two worst-case
maps. I asked a LLM to comeup with a way to time for block splitting and pagefaults
and I found it reasonable, I have attached the results in the commit message.

Does a factor of 2 sound reasonable to everyone?

If this looks ok, happy to send as v2.


From dad1d43f1c2dcb8ffbc8084ec19467731e8548f4 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Fri, 27 Nov 2026 06:07:35 -0800
Subject: [PATCH] KVM: arm64: Size the stage-2 memcache from
 kvm_mmu_cache_min_pages()

When fewer than kvm_mmu_cache_min_pages() pages are left, a stage-2
fault that may need new tables refills the vCPU's memcache to
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, 40 on arm64. A map allocates at most
one table per level below the preallocated root, which is
kvm_mmu_cache_min_pages() and at most 3 pages. Only vCPU destruction
frees the memcache, so whatever a refill leaves unused stays allocated:
up to 2.5 MiB per vCPU with 64 KiB pages. On a 64 KiB host running 101
VMs with 4 vCPUs and 1 GiB each, the memcaches held 986 MiB, against
25 MiB of stage-2 tables in use.

Size the memcache at twice the largest kvm_mmu_cache_min_pages() of the
VM's stage-2s instead, so that each refill covers at least two
worst-case maps. With NV, the vCPU's memcache also feeds the shadow
stage-2s, and a memcache's capacity can't change once used, so record
the largest value as each stage-2 is initialised. The VM's stage-2 is
set up at VM creation and the first shadow stage-2s by the first
KVM_ARM_VCPU_INIT, before any vCPU can fault, and later shadow stage-2s
have the same size. kvm_phys_addr_ioremap()'s temporary memcache uses
the same capacity, so arm64 no longer uses the value of
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.

With a 48-bit IPA, the capacity is 4 pages with 16 KiB and 64 KiB pages
and 6 with 4 KiB pages; with the default 40-bit IPA, 2 and 4. On the
host above and on a production host also running 101 VMs with 4 vCPUs
each, both with 64 KiB pages and 48-bit IPA VMs:

                     memcaches                saved
                     before      after
  host above         986 MiB     81 MiB       905 MiB
  production host    869 MiB     <= 101 MiB   >= 768 MiB

A memcache now refills at most once every two tables, as a capacity of
4 does with 4 KiB pages and a 48-bit IPA. Measured that way, per fault
for the median vCPU, one VM at a time:

                                        40           4
  2M blocks split under dirty logging   4.9-5.1 us   4.9-5.0 us
  1G block split, then refaulted        2.7-2.8 us   2.8 us
  every fault allocating a table        4.0-4.1 us   3.7-4.1 us

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  |  2 ++
 arch/arm64/include/asm/kvm_types.h |  1 +
 arch/arm64/kvm/mmu.c               | 19 +++++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb1300e..515869c190c66a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -413,6 +413,8 @@ enum kvm_arm_vm_flavor {
 
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
+	/* Capacity of the vCPU stage-2 memcaches, see kvm_init_stage2_mmu() */
+	int mmu_page_cache_capacity;
 	const struct kvm_vm_s2_ops *vm_s2_ops;
 
 	enum kvm_arm_vm_flavor vm_flavor;
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index 9a126b9e2d7c99..68472a593578f3 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_ARM64_KVM_TYPES_H
 #define _ASM_ARM64_KVM_TYPES_H
 
+/* Enables the generic MMU memory caches; arm64 passes its own capacity. */
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
 
 #endif /* _ASM_ARM64_KVM_TYPES_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 042dc53267cb36..cd0605cce45d2a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1045,7 +1045,7 @@ static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
  */
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
 {
-	int cpu, err;
+	int cpu, err, capacity;
 	struct kvm_pgtable *pgt;
 
 	/* Initialize the VM ops for the VM instance for the first time */
@@ -1086,6 +1086,15 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		goto out_free_pgtable;
 
 	mmu->pgt = pgt;
+
+	/*
+	 * The vCPU memcaches serve all of the VM's stage-2s and can't be
+	 * resized once used, so make them cover two maps on the deepest one.
+	 */
+	capacity = 2 * kvm_mmu_cache_min_pages(mmu);
+	if (capacity > kvm->arch.mmu_page_cache_capacity)
+		kvm->arch.mmu_page_cache_capacity = capacity;
+
 	if (is_protected_kvm_enabled())
 		return 0;
 
@@ -1317,8 +1326,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	guest_ipa &= PAGE_MASK;
 
 	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
-		ret = kvm_mmu_topup_memory_cache(&cache,
-						 kvm_mmu_cache_min_pages(mmu));
+		ret = __kvm_mmu_topup_memory_cache(&cache,
+						   kvm->arch.mmu_page_cache_capacity,
+						   kvm_mmu_cache_min_pages(mmu));
 		if (ret)
 			break;
 
@@ -1669,10 +1679,11 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
 
 static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
 {
+	int capacity = kvm_s2_mmu_to_kvm(mmu)->arch.mmu_page_cache_capacity;
 	int min_pages = kvm_mmu_cache_min_pages(mmu);
 
 	if (!is_protected_kvm_enabled())
-		return kvm_mmu_topup_memory_cache(memcache, min_pages);
+		return __kvm_mmu_topup_memory_cache(memcache, capacity, min_pages);
 
 	return topup_hyp_memcache(memcache, min_pages);
 }
-- 
2.53.1-Meta



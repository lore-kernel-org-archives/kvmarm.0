Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629339;
	b=hD2eZGp0BXNroglWJ4EjjPo8tDrDMrKV2kPKsEyMJyO5DUo8/a2YcDTEKVyl7qB+F5/b
	 9NPg15LYO5dUOyil9eaRsJBFsb2cauxqCmUNN2WbwpLzD/pa2xeZY4UtSwJQLKF5KZKBp
	 QjdtOn0pmmycbbzrE8fN85mUu46yGkUCG454NDIh61L3ULN68CBBArNOgNOJ6v4fK0lNO
	 Ql7nSaDLouTaHbX82BS9z07G2AhRPGoXS3YvAkq+vtNz7SDDg5O1EKXzOEtA/g/QSSFA2
	 TBNbgG3b88ZGGZJrY4pW9a7aD+36RqqNyak4AkeSBku3H6CL7PnaFRmPeLrKnASIK9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629339;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=fFXM4VsY0RTQVbWn8ye8maJPr7lIP431CErzs/ruNGg=;
	b=eYNR94etWLW17nS3mclLsC4U078FARPBXjeABUWrUfa2i4riCvg7qhSGEFaG8lsK+1VJ
	 rAB7Ukp5QASkFiC7kn+56qiCwfe0HOAAzWT0N9Lw4OPUyUhCRAVf6uPlzrr4zHuqa9EoP
	 ddQQDEgdP7Xsr2+utSVCv9MwlmuqUbHJWabOA+BAsv0GJEUqvJkw0ba1+FdzUfus93WlF
	 rk/k73JLnQRoQlk4HHUZ9S1b1BYxqYe4wPmNZT0pwj8yq+H/pCm2C86tjb6YBvQUDgrKB
	 GaRDqEF/tvBZd0IQ/K50iGY17C7fvnFtoYy+AnVa4E6jjmTi+wc9tDUUQPVSya5SXiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ty4nHO3Y;
	arc=none smtp.remote-ip=91.218.175.83
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DFA606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 17:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4DFA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ty4nHO3Y
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=NN4WGVbOnaTjrSCMn4KsfQluXPMA9ZIKbvqBw1KnXg0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795629335; v=1; x=1796234135;
 b=ty4nHO3YTMkCilwppIsWWTiBpDP/NWZdwrJq6CSGCK3KX66vVYz3q+IlV5X0foqKtuF4upRx
 iXnvVBz9wy4kZJ0UivlMoHnOw2GCSov7iwzhlKPANH0XLIy4OvCMmsnmQmCb+vH/UT5jKgWHHv4
 y8kQtKqybL2hu0B1mIfN53zY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8be7eac4ebc51b04;
	Wed, 25 Nov 2026 17:55:31 +0000
X-Mizu-Trace-ID: 8be7eac4ebc51b04
X-Migadu-Flow: FLOW_OUT
Message-ID: <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
Date: Wed, 25 Nov 2026 17:55:29 +0000
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
To: Leonardo Bras <leo.bras@arm.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com,
 rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <awcXhk885lqDRAHy@LeoBrasDK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/11/2026 09:14, Leonardo Bras wrote:
> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
>> When a stage-2 fault may need new page tables, KVM first tops up the
>> vCPU's page cache: if it holds fewer pages than the fault might need, it
>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
>> 40. Unused pages stay in the cache until the vCPU is destroyed.
>>
>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
>> used. Stage-2 has at most three levels and the root is preallocated, so
>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
>> table pages to map all of its memory, while its four vCPU caches get
>> filled with 160.
>>
>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
>> each, the caches were still 86% full. The memory used:
>>
>>                         before      after
>>   per-vCPU capacity     2.5 MB     512 KB
>>   all 404 vCPUs         869 MB     <= 202 MB
>>
>> Let's lower the capacity to 8 with 64 KiB pages, In the production
>> usecase above, it frees at least 667 MB. That still covers the two-page
>> minimum and leaves room for several table allocations per refill. 4 KB
>> and 16 KB pages keep 40.
>>
>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
>> but it is topped up before every page it maps, so 8 is sufficient there
>> as well. The pKVM hypervisor memcache and the eager split cache don't
>> use this capacity.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
>> --- a/arch/arm64/include/asm/kvm_types.h
>> +++ b/arch/arm64/include/asm/kvm_types.h
>> @@ -2,7 +2,12 @@
>>  #ifndef _ASM_ARM64_KVM_TYPES_H
>>  #define _ASM_ARM64_KVM_TYPES_H
>>  
>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
>> +#ifdef CONFIG_ARM64_64K_PAGES
>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
>> +#else
>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
>> +#endif
>>  
>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
>>  
>> -- 
>> 2.53.1-Meta
>>
> 
> Hi Usama,
> 

Hello Leonardo,

> Have you tried to reproduce this issue in v7.4-rc1 or newer?

Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
Lorenzo's pre-fault series, and I A/B tested it there.

On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
in one page needs a single stage-2 table page, yet the vCPU caches hold
640 pages (40 MiB). With the patch they hold 127 pages.

> 
> IIUC Lorenzo Stoakes introduced a change that would cause the memcache to 
> skip topup if the cache contains a minimum of ~4 pages, so it can possibly 
> improve that issue.

I don't think that part is new. __kvm_mmu_topup_memory_cache() has
returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
guest abort that is the same MMU, so nothing changes here.

With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.

> 
> Although I can see that when it's below that minimum it fills the whole 
> capacity (40) of the cache.
> 

Right, and that is the problem. Skipping the top-up avoids refilling
the cache, but nothing ever drains it. A vCPU's first fault fills its
cache to 40. Each last-level table covers 512 MiB, so a guest needs very
few table pages, and most vCPUs never drop below min. The remaining
pages stay allocated until the vCPU is destroyed, which is why the
production caches were still 86% full.

The patch keeps the early return and only lowers how far a refill goes.

Thanks,
Usama

> In any case, Lorenzo, could you advise?
> 
> CC:Lorenzo Stoakes (ARM) (ljs@kernel.org) 
> 
> Thanks,
> Leo


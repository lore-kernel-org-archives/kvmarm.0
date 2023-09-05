Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5F190
	for <kvmarm@lists.linux.dev>; Tue,  5 Sep 2023 00:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693872385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctjGCSVV1Mw0Mkmv3OOE9v0dAfdBcP8EwbosiY07fHI=;
	b=aNblCPg2ngGyorZzrJBmeJLMoYsGVpNoqgLejXgJsgyvFgk35C9OT0zm4mAUpENVQCq8y2
	XRo6dhvHK19LB7OvU2UWvtnh3Q88zr7w4vqeOAKApPEo89n4PljGP34I2tBgC75B3UBYOy
	H22anG0m+nPAWLpw0n05m4NLri+kC7A=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-GoBMCn2nO2SlhqoHO76QVQ-1; Mon, 04 Sep 2023 20:06:23 -0400
X-MC-Unique: GoBMCn2nO2SlhqoHO76QVQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1befca4fdfaso2324362fac.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 17:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693872383; x=1694477183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctjGCSVV1Mw0Mkmv3OOE9v0dAfdBcP8EwbosiY07fHI=;
        b=UCH2qnBGmv4OZ2hf00gat/sEsNuKuhHn/JWHZyt/cuc3M2gkrT1yuGJ4cGCLYXITy2
         MQ8FX1IlphD06QuHAdByz6EAJ9xt1rOVH/5VcC04Cb/wF/hInM8C5sa3BzlNgMWkUesM
         3CJ/VuEf1Bo/oM+ZGqDDzqi2aNszz71D+Hg7wBEUqZUym+6/npow9iECA/50VVEVrG9+
         giE7VDlGctpsNtgIRWqJ1imQH5IbtOVrQFG20DSShMO63hwzAW0N371nh6otmwaC7wN6
         I/pGdRwN6dL9Tp/XJAdaptwBejfFNqTu7uKUGvWsf+QQ67bAdu2lLlY3N/y4rNO/uO1m
         /q9Q==
X-Gm-Message-State: AOJu0Yx1lSTWM7wTCjQs0oQ17L3Szm0JTfTjFCkHE1VOhc77z0O3hFLV
	f+OLihqE4O64t5I/wIffMYpRsmAjTTII6MwMVTgGWHwS7h39gUR/ipPQghMmljmlSQzTkjjWy6e
	g72Xbv8f8L8V+FkKw
X-Received: by 2002:a05:6870:42c3:b0:1b7:8836:95c9 with SMTP id z3-20020a05687042c300b001b7883695c9mr16424693oah.42.1693872382847;
        Mon, 04 Sep 2023 17:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKsvmSGD3Nc/pB6nmmEd98OMHA91yexnlCd3hiRC4uYGgFBz9gXrj6pmZGiVOBquHcuVkzkg==
X-Received: by 2002:a05:6870:42c3:b0:1b7:8836:95c9 with SMTP id z3-20020a05687042c300b001b7883695c9mr16424669oah.42.1693872382484;
        Mon, 04 Sep 2023 17:06:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id l19-20020a639853000000b00565a0e66c79sm8077164pgo.72.2023.09.04.17.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 17:06:21 -0700 (PDT)
Message-ID: <0f93a015-4f10-b53e-f67f-a84db43ca533@redhat.com>
Date: Tue, 5 Sep 2023 10:06:14 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] KVM: arm64: Fix soft-lockup on relaxing PTE permission
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
 ricarkol@google.com, tabba@google.com, bgardon@google.com,
 zhenyzha@redhat.com, yihyu@redhat.com, shan.gavin@gmail.com
References: <20230904072826.1468907-1-gshan@redhat.com>
 <ZPWPoEgBETeI1um1@linux.dev>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ZPWPoEgBETeI1um1@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 9/4/23 18:04, Oliver Upton wrote:
> On Mon, Sep 04, 2023 at 05:28:26PM +1000, Gavin Shan wrote:
>> We observed soft-lockup on the host in a specific scenario where
>> the host on Ampere's Altra Max CPU has 64KB base page size and the
>> guest has 4KB base page size, 64 vCPUs and 13GB memory. The guest's
>> memory is backed by 512MB huge pages via hugetlbfs. All the 64 vCPUs
>> are simultaneously trapped into the host due to permission page faults,
>> to request adding the execution permission to the corresponding PMD
>> entry, before the soft-lockup is raised on the host. On handling the
>> parallel requests, the instruction cache for the 512MB huge page is
>> invalidated by mm_ops->icache_inval_pou() in stage2_attr_walker() on
>> 64 hardware CPUs. Unfortunately, the instruction cache invalidation
>> on one CPU interfere with that on another CPU in the hardware level.
>> It takes 37 seconds for mm_ops->icache_inval_pou() to finish in the
>> worst case.
>>
>> So we can't scale out to handle the permission faults at will. They
>> need to be serialized to some extent with the help of a interval tree,
> 
> Parallel permission faults is not the cause of the soft lockups
> you observe. The real issue is the volume of invalidations that are
> happening under the hood.
> 
> Take a look at __invalidate_icache_guest_page() -- we invalidate the
> icache by VA regardless of the size of the range. 512M / 64b = 8388608
> invalidation operations. Yes, multiple threads doing these invalidations
> in parallel makes the issue more pronounced as they bottleneck at the
> Miscellaneous node in the interconnect, but we should really do
> something about our invalidation strategy instead.
> 
> The approach you propose adds a fairly complex serialization mechanic
> _and_ unfairly penalizes systems that do not require explicit icache
> invalidation (i.e. FEAT_DIC).
> 
> I have a patch for the invalidation issue that I've been needing to
> send out for a while, could you please give this a go and see if it
> addresses the soft lockups you observe? If so, I can clean it up and
> send it as a patch. At minimum, MAX_TLBI_OPS needs to be renamed to hint
> at the common thread (DVM) between I$ and TLB invalidations.
> 

I generally agree with you that the issue is caused by hardware limitation
where too much time is needed to invalidate the instruction cache for a 512MB
huge page. The parallel invalidation on multiple CPUs make it worse. Actually,
the issue was reported from our downstream kernel, after the feature to support
the parallel page fault handling is included. It's to say, we didn't see the
issue (soft-lock on the host) when the page fault handlers are serialized.

Yeah, my patch has too much complex and FEAT_DIC is disregarded. FEAT_DIC isn't
available on Ampere's Alter and Alter-Max CPU. FEAT_IDC is supported on these
two CPU models though.

Thanks a lot for your patch, which looks much simplified. With it, I don't see
the soft-lockup issue again. However, we potentially have icache thrashing issue
since all icache lines are invalidated by icache_inval_all_pou(). So I think it's
critical to choose a sensible threshold (MAX_TLBI_OPS). I measured the consumed
time for various operations on Ampere's Altra and Altra-max models like below, which
may be helpful for you to choose a sensible threshold (MAX_TLBI_OPS).

   Operation               Altra           Altra Max
   -------------------------------------------------
   icache_inval_all_pou        153us          71us
   icache_inval_pou(64KB)       18us           8us
   icache_inval_pou(512MB) 1130744us       579132us

> --
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 96a80e8f6226..fd23644c9988 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -117,6 +117,7 @@ alternative_cb_end
>   #include <asm/cache.h>
>   #include <asm/cacheflush.h>
>   #include <asm/mmu_context.h>
> +#include <asm/tlbflush.h>
>   #include <asm/kvm_emulate.h>
>   #include <asm/kvm_host.h>
>   
> @@ -224,15 +225,38 @@ static inline void __clean_dcache_guest_page(void *va, size_t size)
>   	kvm_flush_dcache_to_poc(va, size);
>   }
>   
> +static inline u32 __icache_line_size(void)
> +{
> +	u8 iminline;
> +	u64 ctr;
> +
> +	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
> +				    "movk %0, #0, lsl #16\n"
> +				    "movk %0, #0, lsl #32\n"
> +				    "movk %0, #0, lsl #48\n",
> +				    ARM64_ALWAYS_SYSTEM,
> +				    kvm_compute_final_ctr_el0)
> +		     : "=r" (ctr));
> +
> +	iminline = SYS_FIELD_GET(CTR_EL0, IminLine, ctr);
> +	return 4 << iminline;
> +}
> +
>   static inline void __invalidate_icache_guest_page(void *va, size_t size)
>   {
> +	size_t nr_lines = size / __icache_line_size();
> +
>   	if (icache_is_aliasing()) {
>   		/* any kind of VIPT cache */
>   		icache_inval_all_pou();
>   	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
>   		   !icache_is_vpipt()) {
>   		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> -		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
> +		if (nr_lines > MAX_TLBI_OPS)
> +			icache_inval_all_pou();
> +		else
> +			icache_inval_pou((unsigned long)va,
> +					 (unsigned long)va + size);
>   	}
>   }
>   

I'm not sure if it's worthy to pull the @iminline from CTR_EL0 since it's almost
fixed to 64-bytes. @size is guranteed to be PAGE_SIZE or PMD_SIZE aligned. Maybe
we can just aggressively do something like below, disregarding the icache thrashing.
In this way, the code is further simplified.

     if (size > PAGE_SIZE) {
         icache_inval_all_pou();
     } else {
         icache_inval_pou((unsigned long)va,
                          (unsigned long)va + size);
     }                                                          // parantheses is still needed

---

I'm leveraging the chance to ask one question, which isn't related to the issue.
It seems we're doing the icache/dcache coherence differently for stage1 and stage-2
page table entries. The question is why we needn't to clean the dcache for stage-2,
as we're doing for the stage-1 case?

   // stage-1 page table                                       // stage-2 page table
   __set_pte_at                                                invalidate_icache_guest_page
   __sync_icache_dcache                                        __invalidate_icache_guest_page
   sync_icache_aliases                                         icache_inval_pou
   caches_clean_inval_pou                                        invalidate_icache_by_line  // !ARM64_HAS_CACHE_DIC
   caches_clean_inval_pou_macro
     dcache_by_line_op          // !ARM64_HAS_CACHE_IDC
     invalidate_icache_by_line  // !ARM64_HAS_CACHE_DIC

Thanks,
Gavin


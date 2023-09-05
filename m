Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5130FC0F
	for <kvmarm@lists.linux.dev>; Tue,  5 Sep 2023 22:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693952796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P53xpZIm8SYrhpnm0HNoTp/sm01rAuTkQ8t2oErEkPI=;
	b=NCeeIw2K+Ola+33rD3jTZdKcxAQOZDY7T2NxyUbmPuRZQjAaUYHwy7g/ryjBdQx0s/79J2
	xJ/IVLemrE2DpVFnmNMMfjb5M897l3UzzjggzeLycG2sA5r6ipTxti63YKLJBeFf8Ikrlu
	jIYxn/Z3/4uck4mobJehs2ha3DbK5to=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-jkI3lRU5MPiC0GmevFbhhg-1; Tue, 05 Sep 2023 18:26:35 -0400
X-MC-Unique: jkI3lRU5MPiC0GmevFbhhg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-68beecae979so3418201b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Sep 2023 15:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693952794; x=1694557594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P53xpZIm8SYrhpnm0HNoTp/sm01rAuTkQ8t2oErEkPI=;
        b=fnBgq9miGN+LeVnguUrk8VDhgrfEoydLOddqth1c2du60436JVpg7JWhTLeN38X5t1
         TUtLZR9A46UAeQ0gvHnyIJibv9f5Gdm4lXXYe0oCBPpmjAOxUfIXvQyI/pu3knunVOPL
         79KwYcx93wYGoQAhTAzNHj5UYqbtMIbLx1UhzBu6PykAvlVfnE7WnvO+wYt3G72mfQ/M
         50wIh7zZIlVphGrueXc07EdUMRDCCLu/U3aFOpopXbxw/x3N5fNSP5+sjx8Z4nnsAF+I
         mYSv16DlluWOxGslmsxxGX94VPwSmvUhTg8HyaAsch+QNdXtSt93mO54vh4OCQvzzFht
         D8iQ==
X-Gm-Message-State: AOJu0Yz+pUI/W9Q3xEZyQA8M14lLB97UFcorsFMLcmzzQQAn6X7s68Pu
	kHr1rPTgNhiN2KK/zsGqSsHuS0g+fbDEDtK8UV325Bi0r61WJ6HtNN3b4S/X7eDaBZWboq4zcS/
	ZJoHs8wv4J+CjQjfC
X-Received: by 2002:a05:6a00:3004:b0:68a:667d:2294 with SMTP id ay4-20020a056a00300400b0068a667d2294mr12146775pfb.20.1693952794240;
        Tue, 05 Sep 2023 15:26:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWGLSbbVgl4oER7MTTjh+tIpR83rtWk1znrzrNTRird3DNTKYmXWbbdS1zxNOXBaAI2jhXrA==
X-Received: by 2002:a05:6a00:3004:b0:68a:667d:2294 with SMTP id ay4-20020a056a00300400b0068a667d2294mr12146768pfb.20.1693952793954;
        Tue, 05 Sep 2023 15:26:33 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id a30-20020a63705e000000b0056f8b44058csm9780336pgn.12.2023.09.05.15.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 15:26:32 -0700 (PDT)
Message-ID: <bfdafdc5-4abf-a387-0857-e8cb84e4b3d7@redhat.com>
Date: Wed, 6 Sep 2023 08:26:24 +1000
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
 <0f93a015-4f10-b53e-f67f-a84db43ca533@redhat.com>
 <ZPduJ08GKaKXwIhM@linux.dev>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ZPduJ08GKaKXwIhM@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/6/23 04:06, Oliver Upton wrote:
> On Tue, Sep 05, 2023 at 10:06:14AM +1000, Gavin Shan wrote:
> 
> [...]
> 
>>>    static inline void __invalidate_icache_guest_page(void *va, size_t size)
>>>    {
>>> +	size_t nr_lines = size / __icache_line_size();
>>> +
>>>    	if (icache_is_aliasing()) {
>>>    		/* any kind of VIPT cache */
>>>    		icache_inval_all_pou();
>>>    	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
>>>    		   !icache_is_vpipt()) {
>>>    		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
>>> -		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
>>> +		if (nr_lines > MAX_TLBI_OPS)
>>> +			icache_inval_all_pou();
>>> +		else
>>> +			icache_inval_pou((unsigned long)va,
>>> +					 (unsigned long)va + size);
>>>    	}
>>>    }
>>
>> I'm not sure if it's worthy to pull the @iminline from CTR_EL0 since it's almost
>> fixed to 64-bytes.
> 
> I firmly disagree. The architecture allows implementers to select a
> different minimum line size, and non-64b systems _do_ exist in the wild.
> Furthermore, some implementers have decided to glue together cores with
> mismatched line sizes too...
> 
> Though we could avoid some headache by normalizing on 64b, the cold
> reality of the ecosystem requires that we go out of our way to
> accomodate ~any design choice allowed by the architecture.
> 

It seems I didn't make it clear enough. The reason why I had the concern
to avoid reading ctr_el0 is we read ctr_el0 for twice in the following path,
but I doubt if anybody cares. Since it's a hot path, each bit of performance
gain will count.

   invalidate_icache_guest_page
   __invalidate_icache_guest_page   // first read on ctr_el0, with your code changes
   icache_inval_pou(va, va + size)
   invalidate_icache_by_line
     icache_line_size               // second read on ctr_el0


>> @size is guranteed to be PAGE_SIZE or PMD_SIZE aligned. Maybe
>> we can just aggressively do something like below, disregarding the icache thrashing.
>> In this way, the code is further simplified.
>>
>>      if (size > PAGE_SIZE) {
>>          icache_inval_all_pou();
>>      } else {
>>          icache_inval_pou((unsigned long)va,
>>                           (unsigned long)va + size);
>>      }                                                          // parantheses is still needed
> 
> This could work too but we already have a kernel heuristic for limiting
> the amount of broadcast invalidations, which is MAX_TLBI_OPS. I don't
> want to introduce a second, KVM-specific hack to address the exact same
> thing.
> 

Ok. I was confused at the first glance since TLB isn't relevant to icache.
I think it's fine to reuse MAX_TLBI_OPS here, but a comment may be needed.
Oliver, could you please send a formal patch for your changes?

>> I'm leveraging the chance to ask one question, which isn't related to the issue.
>> It seems we're doing the icache/dcache coherence differently for stage1 and stage-2
>> page table entries. The question is why we needn't to clean the dcache for stage-2,
>> as we're doing for the stage-1 case?
> 
> KVM always does its required dcache maintenance (if any) on the first
> translation abort to a given IPA. On systems w/o FEAT_DIC, we lazily
> grant execute permissions as an optimization to avoid unnecessary icache
> invalidations, which as you've seen tends to be a bit of a sore spot.
> 
> Between the two faults, we've effectively guaranteed that any
> host-initiated writes to the PA are visible to the guest on both the I
> and D side. Any CMOs for making guest-initiated writes coherent after
> the translation fault are the sole responsibility of the guest.
> 

Nice, thanks a lot for the explanation.

Thanks,
Gavin





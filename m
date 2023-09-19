Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2EB1FAE
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 06:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695105725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfSKiKasFq+oxT2rx/srAsLPU3hbAgwW8pkV6FGayr8=;
	b=FXk34G74+AeSXCQamompZNU9iCRvvqmns/c1FU2RRvAzXYq4YMRuMgQ8h8hz4pYD3GX00p
	dtQGMbUbhAB2lelMlvGfJii92p1zliMhDkWsMhjlr/U2N4awHXY8HXATu15ZHlS8PmzYz4
	+P5DBysZQCa7IrIfEEqfHG/CEcVkniY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-wvOctLvkMVi6wDpYQraqjw-1; Tue, 19 Sep 2023 02:42:04 -0400
X-MC-Unique: wvOctLvkMVi6wDpYQraqjw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-578137b42b7so2978238a12.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 23:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695105723; x=1695710523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfSKiKasFq+oxT2rx/srAsLPU3hbAgwW8pkV6FGayr8=;
        b=aYTSersX9s3tQ3rvVqpjDSOeeNPJRX4bcTYnZSPSSKclQEZOw2htCkU3QP6OELeW1H
         QWDqrKTs1APPeQ5f4a37oYS4a2ZRh7tINzcbYEN2YeYfVbN12dh9WdGNpwPkO0bPFSbT
         QuNs2zmWw73b+4pSte7trGgBHaMUWv7z9fSkJIBhm9XU95nYVIDBEkpHlSgCz3HtUKVO
         6J9LV1fa5gbbH0llOHs434db08lpkVwOqafYi5Ch1TbBbTR4XseHhIyoQjNW2Zre5pPg
         Tv2dilKhR7qXIxi+e5PwgNPWLBbDf2MwTnPJBJIS6c3vPeeX51T6ciHmQMTH0ylHcd68
         RZNA==
X-Gm-Message-State: AOJu0YzQ3dw7BYuL8qUyfl36x8f3rcP4RJxM7jq8RFqp8dUeZTrlatMh
	jKzsx21zocKlVMi7tYszSv6VuAEg70pwAGomBAF//KHUVV1T0aZP+hgzowvvUYjOdS7rXOOYK2h
	6IYlpLHWqMAJ9kY01
X-Received: by 2002:a05:6a20:394f:b0:14c:d105:2a59 with SMTP id r15-20020a056a20394f00b0014cd1052a59mr12035861pzg.55.1695105723145;
        Mon, 18 Sep 2023 23:42:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmYyJcHC8nCfDgXeO6VK9BWCzoON13QVa7+v62XLxFcfaX3slPM5UY2/wiFaxzBYhBK+9BQg==
X-Received: by 2002:a05:6a20:394f:b0:14c:d105:2a59 with SMTP id r15-20020a056a20394f00b0014cd1052a59mr12035847pzg.55.1695105722843;
        Mon, 18 Sep 2023 23:42:02 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090341ca00b001bbb7af4963sm9298281ple.68.2023.09.18.23.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 23:42:01 -0700 (PDT)
Message-ID: <fa586ba6-0fb3-cf70-9e4b-97ca4fec82d6@redhat.com>
Date: Tue, 19 Sep 2023 16:41:54 +1000
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
 <bfdafdc5-4abf-a387-0857-e8cb84e4b3d7@redhat.com>
 <ZPipBOzdM9lj/uO9@linux.dev>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ZPipBOzdM9lj/uO9@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Hi Oliver,

On 9/7/23 02:29, Oliver Upton wrote:
> On Wed, Sep 06, 2023 at 08:26:24AM +1000, Gavin Shan wrote:
> 
> [...]
> 
>> It seems I didn't make it clear enough. The reason why I had the concern
>> to avoid reading ctr_el0 is we read ctr_el0 for twice in the following path,
>> but I doubt if anybody cares. Since it's a hot path, each bit of performance
>> gain will count.
>>
>>    invalidate_icache_guest_page
>>    __invalidate_icache_guest_page   // first read on ctr_el0, with your code changes
>>    icache_inval_pou(va, va + size)
>>    invalidate_icache_by_line
>>      icache_line_size               // second read on ctr_el0
> 
> That can be addressed by shoving the check deep into
> invalidate_icache_by_line, which would benefit _all_ use cases of
> I-cache invalidation by VA. I haven't completely made up my mind about
> that, though, because of the consequences of a global invalidation.
> 

Yes, of course.

>>>> @size is guranteed to be PAGE_SIZE or PMD_SIZE aligned. Maybe
>>>> we can just aggressively do something like below, disregarding the icache thrashing.
>>>> In this way, the code is further simplified.
>>>>
>>>>       if (size > PAGE_SIZE) {
>>>>           icache_inval_all_pou();
>>>>       } else {
>>>>           icache_inval_pou((unsigned long)va,
>>>>                            (unsigned long)va + size);
>>>>       }                                                          // parantheses is still needed
>>>
>>> This could work too but we already have a kernel heuristic for limiting
>>> the amount of broadcast invalidations, which is MAX_TLBI_OPS. I don't
>>> want to introduce a second, KVM-specific hack to address the exact same
>>> thing.
>>>
>>
>> Ok. I was confused at the first glance since TLB isn't relevant to icache.
>> I think it's fine to reuse MAX_TLBI_OPS here, but a comment may be needed.
>> Oliver, could you please send a formal patch for your changes?
> 
> Yeah, I think I may have said it before, but this thing needs to be
> called 'MAX_DVM_OPS'. I-cache invalidations and TLB invalidations become
> DVMOps (Distributed Virtual Memory) in terms of CHI, which pile up at the
> miscellaneous node in the mesh.
> 
> Give me a day or two to convince myself of the right way to go about
> this and I'll send out what I have.
> 

Ok. 'MAX_DVM_OPS' sounds good and it's a new name to me anyway. Oliver,
please let me know if you don't have time for this and need me to file
the formal patches, based on your codes :)

Thanks,
Gavin


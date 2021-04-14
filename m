Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39F0C43460
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 15:12:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 115C5613CC
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 15:12:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 115C5613CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671824B498;
	Wed, 14 Apr 2021 11:12:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ii5zrRjaD5g9; Wed, 14 Apr 2021 11:12:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482CF4B5A6;
	Wed, 14 Apr 2021 11:12:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F2C4B5A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 11:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TFb9jMqoAbz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 11:12:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A792A4B498
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 11:12:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618413136;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OvGZLtj/JZR18KhKppCpw2o1u6Vet6Jv6a+C3P66ArY=;
 b=Z35UkNKBkIK0hGHpQD8SHKm76+gdePDQ0HKztJG4P5Eq50Ylen3jHjl9dcIn05dnSjnstK
 ptk6XpYM1j94A1mdeYcSXuFmmdKrQ5N4uAfXbPPeD25l1LWIn8epjeuBOIjVf6ZYFrvp5U
 m5Gx0uMbVhM2n7oonL0zWifv4P8t0ws=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-t5LCx8aSNRG-gMqPDJCw2A-1; Wed, 14 Apr 2021 11:12:14 -0400
X-MC-Unique: t5LCx8aSNRG-gMqPDJCw2A-1
Received: by mail-wr1-f69.google.com with SMTP id
 n4-20020a5d51c40000b02900f3fe975f03so1205413wrv.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 08:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:organization:subject
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=OvGZLtj/JZR18KhKppCpw2o1u6Vet6Jv6a+C3P66ArY=;
 b=DoJd/hvYHgCwRnMiNyJfxWfvO3nOoR58g0pIWfsdUmlzQomuJcUSaP+4kFZh6pfyoN
 z2v97QWxJKccfnncqLDnaHmKu7UE2fOdckMWclPYlLNy6NlliUe7CJaEhy+Yhxk99Jcp
 EFyjm8oUxb+l1J9qTs59BBon3IElvhKxCDpfN1OGSKoL2Ka4kflcHf59jFlm42q0R/ie
 rYGwozdWTlk7n/vccz7E07BU5Wje2SeFFrM5fnnYBGm4Ynt85m2TQs1rZXCtaJSFwY5g
 5JBJG3WzVdM+7a6HADffOw04aDME8VNHfOXFG1z8jUrBrnPE29FtFOeZWgi1eddQ5Etu
 oowg==
X-Gm-Message-State: AOAM533DCsVh866Nfg5VaS0JVwbdD1lzOKF6NNc+o0QqrCzGqC++l91M
 kO4wwdN/wFaDA1prkKjlJ2onQ7qKJ9/IsX/EVxBBLk/mBGBEutr+GpzQ8/khj19FC5NhFVvni2s
 8Nbr/YMW7ipNbK3jF/K2hroxk
X-Received: by 2002:a1c:f614:: with SMTP id w20mr3490017wmc.70.1618413133030; 
 Wed, 14 Apr 2021 08:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwpIn8nv9v5Y/Dtcv6mOc3r8te/FMqBM0g0pALidkDsp7h2aVJV3ZZM5WuTLB2ksnnlanbKw==
X-Received: by 2002:a1c:f614:: with SMTP id w20mr3489987wmc.70.1618413132740; 
 Wed, 14 Apr 2021 08:12:12 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6470.dip0.t-ipconnect.de. [91.12.100.112])
 by smtp.gmail.com with ESMTPSA id z14sm334347wrt.54.2021.04.14.08.12.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 14 Apr 2021 08:12:12 -0700 (PDT)
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-2-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC/RFT PATCH 1/3] memblock: update initialization of reserved
 pages
Message-ID: <0c48f98c-7454-1458-15a5-cc5a7e1fb7cd@redhat.com>
Date: Wed, 14 Apr 2021 17:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407172607.8812-2-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 07.04.21 19:26, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The struct pages representing a reserved memory region are initialized
> using reserve_bootmem_range() function. This function is called for each
> reserved region just before the memory is freed from memblock to the buddy
> page allocator.
> 
> The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> values set by the memory map initialization which makes it necessary to
> have a special treatment for such pages in pfn_valid() and
> pfn_valid_within().

I assume these pages are never given to the buddy, because we don't have 
a direct mapping. So to the kernel, it's essentially just like a memory 
hole with benefits.

I can spot that we want to export such memory like any special memory 
thingy/hole in /proc/iomem -- "reserved", which makes sense.

I would assume that MEMBLOCK_NOMAP is a special type of *reserved* 
memory. IOW, that for_each_reserved_mem_range() should already succeed 
on these as well -- we should mark anything that is MEMBLOCK_NOMAP 
implicitly as reserved. Or are there valid reasons not to do so? What 
can anyone do with that memory?

I assume they are pretty much useless for the kernel, right? Like other 
reserved memory ranges.


> 
> Split out initialization of the reserved pages to a function with a
> meaningful name and treat the MEMBLOCK_NOMAP regions the same way as the
> reserved regions and mark struct pages for the NOMAP regions as
> PageReserved.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>   mm/memblock.c | 23 +++++++++++++++++++++--
>   1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index afaefa8fc6ab..6b7ea9d86310 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2002,6 +2002,26 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>   	return end_pfn - start_pfn;
>   }
>   
> +static void __init memmap_init_reserved_pages(void)
> +{
> +	struct memblock_region *region;
> +	phys_addr_t start, end;
> +	u64 i;
> +
> +	/* initialize struct pages for the reserved regions */
> +	for_each_reserved_mem_range(i, &start, &end)
> +		reserve_bootmem_region(start, end);
> +
> +	/* and also treat struct pages for the NOMAP regions as PageReserved */
> +	for_each_mem_region(region) {
> +		if (memblock_is_nomap(region)) {
> +			start = region->base;
> +			end = start + region->size;
> +			reserve_bootmem_region(start, end);
> +		}
> +	}
> +}
> +
>   static unsigned long __init free_low_memory_core_early(void)
>   {
>   	unsigned long count = 0;
> @@ -2010,8 +2030,7 @@ static unsigned long __init free_low_memory_core_early(void)
>   
>   	memblock_clear_hotplug(0, -1);
>   
> -	for_each_reserved_mem_range(i, &start, &end)
> -		reserve_bootmem_region(start, end);
> +	memmap_init_reserved_pages();
>   
>   	/*
>   	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
> 


-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

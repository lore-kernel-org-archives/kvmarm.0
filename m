Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E28C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 07:49:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE41861433
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 07:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE41861433
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6287D4B27E;
	Wed, 21 Apr 2021 03:49:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B8JEYmMd68o7; Wed, 21 Apr 2021 03:49:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DE94B397;
	Wed, 21 Apr 2021 03:49:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 864D44B289
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 03:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDX2GZGsvXqM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 03:49:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276D54B27E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 03:49:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618991373;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JAnhPgTmK2rneM8QtGU7sZ7Ohw+rHF0KbVh21PjcnDI=;
 b=Z1scvjfyTGEFEJj8utyrbIMLZfJcpFxFFRjRl45UASROb/3/SaITYTEf7jA5M2/pdWDHbl
 dgfeZJsivOrXMCXSlkByuL6gxpvhkobEOAWbq6WMBQNzwQOs+L9+WPMrIG2pWJcXHpUbHk
 f01ykr7oU2FP+80Euj/qQvjSOd7cuRI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-CaGzWsDPPwWGXshJ8fHRCg-1; Wed, 21 Apr 2021 03:49:26 -0400
X-MC-Unique: CaGzWsDPPwWGXshJ8fHRCg-1
Received: by mail-ed1-f71.google.com with SMTP id
 y10-20020a50f1ca0000b0290382d654f75eso14547113edl.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 00:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=JAnhPgTmK2rneM8QtGU7sZ7Ohw+rHF0KbVh21PjcnDI=;
 b=Msw7GYah22L8x6HqGB2QVFvZfV2InbMVm6wZq8NhpWXkN77DtBClsgysAnAbtcoLlW
 mxmB5abMkZf39PdFZk0eZRZiTiuehF2UT4x0ioxlokwmLrML14q4CP15Jc2UKdI2xVAV
 nJMwN4JW2BCX0+OMwpw2+WBSrzdRRvBezBnBSmc720xMEDXVF3G6AVXDc0rqCKIuBrE2
 TcIIXNl/FmzkGUplbXVtPs/RMhy5l1icbuHg+1zt0a+Dp2BrqItzJXUDt23C16SpHhjd
 l6GMOYM67qps+ObwZywjtsNbUqCAq/qFdTCGY0jsqGT29qkK3DsWhh60BPEMT7iJBrLn
 lqMQ==
X-Gm-Message-State: AOAM532xpzcHpofjutF0B5WbggfhMXyQoAIcFzpMNA+LJVfAmJrm3ja1
 iTk3mLSNJlDGSYoWY7rYZ3t7KLvh3dOfm8PqPJ7Trzj/Bx0aunKKGBFMG/HOU/KlfbgxpDDGUwg
 NovO4/m72udLuxCQAoRozy1hX
X-Received: by 2002:a05:6402:78d:: with SMTP id
 d13mr36472244edy.277.1618991365288; 
 Wed, 21 Apr 2021 00:49:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPQEw8LMNntsFe7QRyIPhtcWOmJcDhJxCGo22DUKTe+vv1GhR0JyZ5rACKKiobJsNfEOkgTA==
X-Received: by 2002:a05:6402:78d:: with SMTP id
 d13mr36472231edy.277.1618991365082; 
 Wed, 21 Apr 2021 00:49:25 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64b8.dip0.t-ipconnect.de. [91.12.100.184])
 by smtp.gmail.com with ESMTPSA id t1sm1510968eju.88.2021.04.21.00.49.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 21 Apr 2021 00:49:24 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] memblock: update initialization of reserved pages
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-3-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <752fd822-6479-53f1-81fb-24b55500e963@redhat.com>
Date: Wed, 21 Apr 2021 09:49:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421065108.1987-3-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
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

On 21.04.21 08:51, Mike Rapoport wrote:
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
> 
> Split out initialization of the reserved pages to a function with a
> meaningful name and treat the MEMBLOCK_NOMAP regions the same way as the
> reserved regions and mark struct pages for the NOMAP regions as
> PageReserved.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>   include/linux/memblock.h |  4 +++-
>   mm/memblock.c            | 28 ++++++++++++++++++++++++++--
>   2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 5984fff3f175..634c1a578db8 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -30,7 +30,9 @@ extern unsigned long long max_possible_pfn;
>    * @MEMBLOCK_NONE: no special request
>    * @MEMBLOCK_HOTPLUG: hotpluggable region
>    * @MEMBLOCK_MIRROR: mirrored region
> - * @MEMBLOCK_NOMAP: don't add to kernel direct mapping
> + * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
> + * reserved in the memory map; refer to memblock_mark_nomap() description
> + * for futher details
>    */
>   enum memblock_flags {
>   	MEMBLOCK_NONE		= 0x0,	/* No special request */
> diff --git a/mm/memblock.c b/mm/memblock.c
> index afaefa8fc6ab..3abf2c3fea7f 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -906,6 +906,11 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
>    * @base: the base phys addr of the region
>    * @size: the size of the region
>    *
> + * The memory regions marked with %MEMBLOCK_NOMAP will not be added to the
> + * direct mapping of the physical memory. These regions will still be
> + * covered by the memory map. The struct page representing NOMAP memory
> + * frames in the memory map will be PageReserved()
> + *
>    * Return: 0 on success, -errno on failure.
>    */
>   int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
> @@ -2002,6 +2007,26 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
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
> @@ -2010,8 +2035,7 @@ static unsigned long __init free_low_memory_core_early(void)
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

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

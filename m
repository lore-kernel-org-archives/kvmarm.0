Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820BCC433ED
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:15:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0B226113B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0B226113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC174B9FC;
	Thu,  8 Apr 2021 01:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lypprc+BIi31; Thu,  8 Apr 2021 01:15:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3804E4BA0F;
	Thu,  8 Apr 2021 01:15:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307F14B9F1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:15:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIJSQ4EbiDTO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 01:15:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35254B9E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:15:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E8331424;
 Wed,  7 Apr 2021 22:15:31 -0700 (PDT)
Received: from [10.163.67.84] (unknown [10.163.67.84])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AA923F73D;
 Wed,  7 Apr 2021 22:15:28 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC/RFT PATCH 1/3] memblock: update initialization of reserved
 pages
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-2-rppt@kernel.org>
Message-ID: <064dad68-ca9f-14d3-7859-5321001fbca4@arm.com>
Date: Thu, 8 Apr 2021 10:46:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210407172607.8812-2-rppt@kernel.org>
Content-Language: en-US
Cc: David Hildenbrand <david@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 4/7/21 10:56 PM, Mike Rapoport wrote:
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

This would definitely need updating the comment for MEMBLOCK_NOMAP definition
in include/linux/memblock.h just to make the semantics is clear, though arm64
is currently the only user for MEMBLOCK_NOMAP.

> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  mm/memblock.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index afaefa8fc6ab..6b7ea9d86310 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2002,6 +2002,26 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  	return end_pfn - start_pfn;
>  }
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
>  static unsigned long __init free_low_memory_core_early(void)
>  {
>  	unsigned long count = 0;
> @@ -2010,8 +2030,7 @@ static unsigned long __init free_low_memory_core_early(void)
>  
>  	memblock_clear_hotplug(0, -1);
>  
> -	for_each_reserved_mem_range(i, &start, &end)
> -		reserve_bootmem_region(start, end);
> +	memmap_init_reserved_pages();
>  
>  	/*
>  	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED971C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:12:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F049610F7
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 05:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F049610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 921824BA2A;
	Thu,  8 Apr 2021 01:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fr5fbPU25rTW; Thu,  8 Apr 2021 01:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62DC74BA02;
	Thu,  8 Apr 2021 01:12:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D6D4B9EE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yGHQ0AKeiqUP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 01:11:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95404B9EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 01:11:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3EE81424;
 Wed,  7 Apr 2021 22:11:58 -0700 (PDT)
Received: from [10.163.67.84] (unknown [10.163.67.84])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29B6E3F73D;
 Wed,  7 Apr 2021 22:11:54 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 3/3] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-4-rppt@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <7bc09505-72f1-e297-40a9-639b3e9b1c61@arm.com>
Date: Thu, 8 Apr 2021 10:42:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210407172607.8812-4-rppt@kernel.org>
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
> The arm64's version of pfn_valid() differs from the generic because of two
> reasons:
> 
> * Parts of the memory map are freed during boot. This makes it necessary to
>   verify that there is actual physical memory that corresponds to a pfn
>   which is done by querying memblock.
> 
> * There are NOMAP memory regions. These regions are not mapped in the
>   linear map and until the previous commit the struct pages representing
>   these areas had default values.
> 
> As the consequence of absence of the special treatment of NOMAP regions in
> the memory map it was necessary to use memblock_is_map_memory() in
> pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
> generic mm functionality would not treat a NOMAP page as a normal page.
> 
> Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
> the rest of core mm will treat them as unusable memory and thus
> pfn_valid_within() is no longer required at all and can be disabled by
> removing CONFIG_HOLES_IN_ZONE on arm64.

But what about the memory map that are freed during boot (mentioned above).
Would not they still cause CONFIG_HOLES_IN_ZONE to be applicable and hence
pfn_valid_within() ?

> 
> pfn_valid() can be slightly simplified by replacing
> memblock_is_map_memory() with memblock_is_memory().

Just to understand this better, pfn_valid() will now return true for all
MEMBLOCK_NOMAP based memory but that is okay as core MM would still ignore
them as unusable memory for being PageReserved().

> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/arm64/Kconfig   | 3 ---
>  arch/arm64/mm/init.c | 4 ++--
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e4e1b6550115..58e439046d05 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>  	def_bool y
>  	depends on NUMA
>  
> -config HOLES_IN_ZONE
> -	def_bool y
> -
>  source "kernel/Kconfig.hz"
>  
>  config ARCH_SPARSEMEM_ENABLE
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 258b1905ed4a..bb6dd406b1f0 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
>  
>  	/*
>  	 * ZONE_DEVICE memory does not have the memblock entries.
> -	 * memblock_is_map_memory() check for ZONE_DEVICE based
> +	 * memblock_is_memory() check for ZONE_DEVICE based
>  	 * addresses will always fail. Even the normal hotplugged
>  	 * memory will never have MEMBLOCK_NOMAP flag set in their
>  	 * memblock entries. Skip memblock search for all non early
> @@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
>  		return pfn_section_valid(ms, pfn);
>  }
>  #endif
> -	return memblock_is_map_memory(addr);
> +	return memblock_is_memory(addr);
>  }
>  EXPORT_SYMBOL(pfn_valid);
>  
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

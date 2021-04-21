Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2363EC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 10:48:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CBB86144F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 10:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CBB86144F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0894B4BA;
	Wed, 21 Apr 2021 06:48:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tuqSmMiKK6Ys; Wed, 21 Apr 2021 06:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1348C4B4CE;
	Wed, 21 Apr 2021 06:48:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF9C4B4B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 06:48:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uhWp5t6polEe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 06:48:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A29124B49B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 06:48:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C4FA113E;
 Wed, 21 Apr 2021 03:48:34 -0700 (PDT)
Received: from [10.163.74.228] (unknown [10.163.74.228])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A00AE3F73B;
 Wed, 21 Apr 2021 03:48:29 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v2 1/4] include/linux/mmzone.h: add documentation for
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-2-rppt@kernel.org>
Message-ID: <d31ff896-ea1c-d47c-0d11-34fdcd3b7ad8@arm.com>
Date: Wed, 21 Apr 2021 16:19:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210421065108.1987-2-rppt@kernel.org>
Content-Language: en-US
Cc: David Hildenbrand <david@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 4/21/21 12:21 PM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Add comment describing the semantics of pfn_valid() that clarifies that
> pfn_valid() only checks for availability of a memory map entry (i.e. struct
> page) for a PFN rather than availability of usable memory backing that PFN.
> 
> The most "generic" version of pfn_valid() used by the configurations with
> SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
> suitable place for documentation about semantics of pfn_valid().
> 
> Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  include/linux/mmzone.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 47946cec7584..961f0eeefb62 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1410,6 +1410,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>  #endif
>  
>  #ifndef CONFIG_HAVE_ARCH_PFN_VALID
> +/**
> + * pfn_valid - check if there is a valid memory map entry for a PFN
> + * @pfn: the page frame number to check
> + *
> + * Check if there is a valid memory map entry aka struct page for the @pfn.
> + * Note, that availability of the memory map entry does not imply that
> + * there is actual usable memory at that @pfn. The struct page may
> + * represent a hole or an unusable page frame.
> + *
> + * Return: 1 for PFNs that have memory map entries and 0 otherwise
> + */
>  static inline int pfn_valid(unsigned long pfn)
>  {
>  	struct mem_section *ms;
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

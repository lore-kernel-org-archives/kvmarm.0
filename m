Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EF0C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:18:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E46296120E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E46296120E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDBC4BA4E;
	Thu,  8 Apr 2021 02:18:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZgDgT4tasMwr; Thu,  8 Apr 2021 02:18:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4B54BA18;
	Thu,  8 Apr 2021 02:18:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34CCC4B62F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:18:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pJHgUr6DRIbm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 02:18:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A91C4B627
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:18:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 111BD610E6;
 Thu,  8 Apr 2021 06:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617862686;
 bh=D25A47pHXo5M0XVHRMAlv9F2o8wUhKGIRqNCPd2GVIc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=f9WtSPzU8GfleqgMagOrPW6QHdltbXgThsO4oWjrX16rmkJYXoeZ1mboF/jEf9JBw
 z16CMkGV25K2UCjvOiAoHMKVIqmJ8DJ1zwPvQiPCAWaQC9dP2RIRqZxFfCfs08Gky0
 F65vrzVc3NOk7WNP2hvIwk/BGAmWoQ7yDYyxxzGOHA9GtgBk8MRMlg5LCIlB+x4oUV
 5klr0VJ9s/EX3Me2zaPK/3Jb0C1eIgWIcdhcpYjRoNJIU4pGj7Lyj8YmYswFisl0jx
 7Ohrbn8rDh1ExWdu1Y5HLNf4OaGcgcJ2Tn4XqLHdDuMNpPEov90n1P35u+Cv7EyuuW
 lr1G1VATC2HTw==
Date: Thu, 8 Apr 2021 09:17:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC/RFT PATCH 3/3] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YG6gFi5/3O2OsYYH@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-4-rppt@kernel.org>
 <7bc09505-72f1-e297-40a9-639b3e9b1c61@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7bc09505-72f1-e297-40a9-639b3e9b1c61@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 08, 2021 at 10:42:43AM +0530, Anshuman Khandual wrote:
> 
> On 4/7/21 10:56 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The arm64's version of pfn_valid() differs from the generic because of two
> > reasons:
> > 
> > * Parts of the memory map are freed during boot. This makes it necessary to
> >   verify that there is actual physical memory that corresponds to a pfn
> >   which is done by querying memblock.
> > 
> > * There are NOMAP memory regions. These regions are not mapped in the
> >   linear map and until the previous commit the struct pages representing
> >   these areas had default values.
> > 
> > As the consequence of absence of the special treatment of NOMAP regions in
> > the memory map it was necessary to use memblock_is_map_memory() in
> > pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
> > generic mm functionality would not treat a NOMAP page as a normal page.
> > 
> > Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
> > the rest of core mm will treat them as unusable memory and thus
> > pfn_valid_within() is no longer required at all and can be disabled by
> > removing CONFIG_HOLES_IN_ZONE on arm64.
> 
> But what about the memory map that are freed during boot (mentioned above).
> Would not they still cause CONFIG_HOLES_IN_ZONE to be applicable and hence
> pfn_valid_within() ?

The CONFIG_HOLES_IN_ZONE name is misleading as actually pfn_valid_within()
is only required for holes within a MAX_ORDER_NR_PAGES blocks (see comment
near pfn_valid_within() definition in mmzone.h). The freeing of the memory
map during boot avoids breaking MAX_ORDER blocks and the holes for which
memory map is freed are always aligned at MAX_ORDER.

AFAIU, the only case when there could be a hole in a MAX_ORDER block is
when EFI/ACPI reserves memory for its use and this memory becomes NOMAP in
the kernel. We still create struct pages for this memory, but they never
get values other than defaults, so core mm has no idea that this memory
should be touched, hence the need for pfn_valid_within() aliased to
pfn_valid() on arm64.
 
> > pfn_valid() can be slightly simplified by replacing
> > memblock_is_map_memory() with memblock_is_memory().
> 
> Just to understand this better, pfn_valid() will now return true for all
> MEMBLOCK_NOMAP based memory but that is okay as core MM would still ignore
> them as unusable memory for being PageReserved().

Right, pfn_valid() will return true for all memory, including
MEMBLOCK_NOMAP. Since core mm deals with PageResrved() for memory used by
the firmware, e.g. on x86, I don't see why it won't work on arm64.
> > 
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >  arch/arm64/Kconfig   | 3 ---
> >  arch/arm64/mm/init.c | 4 ++--
> >  2 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index e4e1b6550115..58e439046d05 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
> >  	def_bool y
> >  	depends on NUMA
> >  
> > -config HOLES_IN_ZONE
> > -	def_bool y
> > -
> >  source "kernel/Kconfig.hz"
> >  
> >  config ARCH_SPARSEMEM_ENABLE
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index 258b1905ed4a..bb6dd406b1f0 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
> >  
> >  	/*
> >  	 * ZONE_DEVICE memory does not have the memblock entries.
> > -	 * memblock_is_map_memory() check for ZONE_DEVICE based
> > +	 * memblock_is_memory() check for ZONE_DEVICE based
> >  	 * addresses will always fail. Even the normal hotplugged
> >  	 * memory will never have MEMBLOCK_NOMAP flag set in their
> >  	 * memblock entries. Skip memblock search for all non early
> > @@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
> >  		return pfn_section_valid(ms, pfn);
> >  }
> >  #endif
> > -	return memblock_is_map_memory(addr);
> > +	return memblock_is_memory(addr);
> >  }
> >  EXPORT_SYMBOL(pfn_valid);
> >  
> > 

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

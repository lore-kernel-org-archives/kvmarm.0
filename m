Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE940C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 05:52:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61EF861419
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 05:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61EF861419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1D14B381;
	Wed, 21 Apr 2021 01:52:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pGivqR0QkDCv; Wed, 21 Apr 2021 01:52:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B224B369;
	Wed, 21 Apr 2021 01:52:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EEA74B369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 01:52:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GphBCDiraTaF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 01:52:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCE7E4B35E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 01:52:38 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D42916140C;
 Wed, 21 Apr 2021 05:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618984357;
 bh=g72o3X3Q6Y/a2mSNpa0HjIO9b/1mdQbo0EaTxru/zZU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lDwRsR/E5mE9ve2Akk/3k+XO8YXnjrfevy9BmPLxs+lWkLg/W8jvzL1dYtVYW+3Rf
 c0TNDace3LJilMFVznrYeCRDwGrbHzJWGhCicEdzHL6l8Ssmr+GPd2k1tR0J/Oz8gY
 HNlkCXKomx+V/ot9YHj+QTDszjYr8FZyUKXC3ov3JbPn6ar8+9fn4C2rsNGgfwD1xK
 jxVIemH8Bz2l6DRPlexUeyQ5bNbq1sXxlzRv+Ip3azOMMDa2+YNNQtjVpoPrF/KHOO
 C7w6maQQFuV4pFX+kZC5rXtQY8I5cntBPjYPkw4E8WX1mZ5dZcqHIin3LRMZrwh4pk
 FPk4mfTeux5gA==
Date: Wed, 21 Apr 2021 08:52:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v1 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YH+9nbDkPyVav3xn@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-5-rppt@kernel.org>
 <8e7171e7-a85c-6066-4ab6-d2bc98ec103b@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8e7171e7-a85c-6066-4ab6-d2bc98ec103b@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
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

On Tue, Apr 20, 2021 at 06:00:55PM +0200, David Hildenbrand wrote:
> On 20.04.21 11:09, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The arm64's version of pfn_valid() differs from the generic because of two
> > reasons:
> > 
> > * Parts of the memory map are freed during boot. This makes it necessary to
> >    verify that there is actual physical memory that corresponds to a pfn
> >    which is done by querying memblock.
> > 
> > * There are NOMAP memory regions. These regions are not mapped in the
> >    linear map and until the previous commit the struct pages representing
> >    these areas had default values.
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
> > 
> > pfn_valid() can be slightly simplified by replacing
> > memblock_is_map_memory() with memblock_is_memory().
> > 
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >   arch/arm64/Kconfig   | 3 ---
> >   arch/arm64/mm/init.c | 4 ++--
> >   2 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index e4e1b6550115..58e439046d05 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
> >   	def_bool y
> >   	depends on NUMA
> > -config HOLES_IN_ZONE
> > -	def_bool y
> > -
> >   source "kernel/Kconfig.hz"
> >   config ARCH_SPARSEMEM_ENABLE
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index c54e329aca15..370f33765b64 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
> >   	/*
> >   	 * ZONE_DEVICE memory does not have the memblock entries.
> > -	 * memblock_is_map_memory() check for ZONE_DEVICE based
> > +	 * memblock_is_memory() check for ZONE_DEVICE based
> >   	 * addresses will always fail. Even the normal hotplugged
> >   	 * memory will never have MEMBLOCK_NOMAP flag set in their
> >   	 * memblock entries. Skip memblock search for all non early
> > @@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
> >   		return pfn_section_valid(ms, pfn);
> >   }
> >   #endif
> > -	return memblock_is_map_memory(addr);
> > +	return memblock_is_memory(addr);
> >   }
> >   EXPORT_SYMBOL(pfn_valid);
> > 
> 
> What are the steps needed to get rid of custom pfn_valid() completely?
> 
> I'd assume we would have to stop freeing parts of the mem map during boot.
> How relevant is that for arm64 nowadays, especially with reduced section
> sizes?

Yes, for arm64 to use the generic pfn_valid() it'd need to stop freeing
parts of the memory map.

Presuming struct page is 64 bytes, the memory map takes 2M per section in
the worst case (128M per section, 4k pages). 

So for systems that have less than 128M populated in each section freeing
unused memory map would mean significant savings.

But nowadays when a clock has at least 1G of RAM I doubt this is relevant
to many systems if at all.

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

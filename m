Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBC95BACE
	for <kvmarm@lists.linux.dev>; Mon, 29 Jan 2024 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706528526; cv=none; b=K6dG8K3C5SyU1+HCEtJxWd/iCDbIOZVlb7zMaPzaR1SF9alfdJlDaQMZWI0aV/WkU9xMUlffCkIFT4xVWKB5TLW7aIwzbpJ6Z6teCS4rKDmh9E19TPUHUSK+9Y4Lln7MGT8Nlj2JQWg+eB9VlfSvD1Ae8s2UDcb7i5ZLXjAvT80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706528526; c=relaxed/simple;
	bh=FkFZgG4NX2Z1MIleaUvoUwxX/KFV84CBNe8KsqtTFdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+or8psBmxSicIT43MMATIwbN0vSGygNf6nMwxoFK9hDSZo95WZB8WI9y3rglwgnp9gdwskwJw4YHmjSucpxAxNGhk06KmJUPKKypmRv+4I6p+JV0ZemjEGv8FR4jjSofMqZKcsdmq8Ju3wG1VlxLYaFY5R9f/8BOyfyikyfNUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEEA71FB;
	Mon, 29 Jan 2024 03:42:47 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86CCD3F5A1;
	Mon, 29 Jan 2024 03:41:58 -0800 (PST)
Date: Mon, 29 Jan 2024 11:41:55 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev,
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	bristot@redhat.com, vschneid@redhat.com, mhiramat@kernel.org,
	rppt@kernel.org, hughd@google.com, pcc@google.com,
	steven.price@arm.com, vincenzo.frascino@arm.com, david@redhat.com,
	eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/35] mm: page_alloc: Add gfp_flags parameter to
 arch_alloc_page()
Message-ID: <ZbePA2dGE6Vs-58t@raptor>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
 <20240125164256.4147-2-alexandru.elisei@arm.com>
 <de0c74b3-0c7d-4f21-8454-659e8b616ea7@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de0c74b3-0c7d-4f21-8454-659e8b616ea7@arm.com>

Hi,

On Mon, Jan 29, 2024 at 11:18:59AM +0530, Anshuman Khandual wrote:
> 
> On 1/25/24 22:12, Alexandru Elisei wrote:
> > Extend the usefulness of arch_alloc_page() by adding the gfp_flags
> > parameter.
> 
> Although the change here is harmless in itself, it will definitely benefit
> from some additional context explaining the rationale, taking into account
> why-how arch_alloc_page() got added particularly for s390 platform and how
> it's going to be used in the present proposal.

arm64 will use it to reserve tag storage if the caller requested a tagged
page. Right now that means that __GFP_ZEROTAGS is set in the gfp mask, but
I'll rename it to __GFP_TAGGED in patch #18 ("arm64: mte: Rename
__GFP_ZEROTAGS to __GFP_TAGGED") [1].

[1] https://lore.kernel.org/lkml/20240125164256.4147-19-alexandru.elisei@arm.com/

Thanks,
Alex

> 
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > 
> > Changes since rfc v2:
> > 
> > * New patch.
> > 
> >  arch/s390/include/asm/page.h | 2 +-
> >  arch/s390/mm/page-states.c   | 2 +-
> >  include/linux/gfp.h          | 2 +-
> >  mm/page_alloc.c              | 2 +-
> >  4 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> > index 73b9c3bf377f..859f0958c574 100644
> > --- a/arch/s390/include/asm/page.h
> > +++ b/arch/s390/include/asm/page.h
> > @@ -163,7 +163,7 @@ static inline int page_reset_referenced(unsigned long addr)
> >  
> >  struct page;
> >  void arch_free_page(struct page *page, int order);
> > -void arch_alloc_page(struct page *page, int order);
> > +void arch_alloc_page(struct page *page, int order, gfp_t gfp_flags);
> >  
> >  static inline int devmem_is_allowed(unsigned long pfn)
> >  {
> > diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
> > index 01f9b39e65f5..b986c8b158e3 100644
> > --- a/arch/s390/mm/page-states.c
> > +++ b/arch/s390/mm/page-states.c
> > @@ -21,7 +21,7 @@ void arch_free_page(struct page *page, int order)
> >  	__set_page_unused(page_to_virt(page), 1UL << order);
> >  }
> >  
> > -void arch_alloc_page(struct page *page, int order)
> > +void arch_alloc_page(struct page *page, int order, gfp_t gfp_flags)
> >  {
> >  	if (!cmma_flag)
> >  		return;
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index de292a007138..9e8aa3d144db 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -172,7 +172,7 @@ static inline struct zonelist *node_zonelist(int nid, gfp_t flags)
> >  static inline void arch_free_page(struct page *page, int order) { }
> >  #endif
> >  #ifndef HAVE_ARCH_ALLOC_PAGE
> > -static inline void arch_alloc_page(struct page *page, int order) { }
> > +static inline void arch_alloc_page(struct page *page, int order, gfp_t gfp_flags) { }
> >  #endif
> >  
> >  struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 150d4f23b010..2c140abe5ee6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1485,7 +1485,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
> >  	set_page_private(page, 0);
> >  	set_page_refcounted(page);
> >  
> > -	arch_alloc_page(page, order);
> > +	arch_alloc_page(page, order, gfp_flags);
> >  	debug_pagealloc_map_pages(page, 1 << order);
> >  
> >  	/*
> 
> Otherwise LGTM.

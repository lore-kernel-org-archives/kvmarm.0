Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2604A5FB84
	for <kvmarm@lists.linux.dev>; Mon, 29 Jan 2024 11:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706528557; cv=none; b=OGflYisCrKcIclGjwLv6+0oKCbFCXvdKLkt4JA68erwPE9H6dOP6mMgIG41S/CiGK+V9/nOv5OQM4n3/xROvtNZ0oxE5XsRloX/y6292r9N6+rRIBZ32TOOv8l2+X+xwuSAImBrX9Q7xbX76p3z7pxlzIS9zAfHoXlgu1DN3YVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706528557; c=relaxed/simple;
	bh=+HjbdWH9I+QsFsEdWw5aw/RdwzKx/Ajp4cb1tu3el6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSNU/t0zm0Y9wSUF8/Z4BlicJEqKfTo/YB/Mbu2rWITKM9uWqOJ5xlD+6ho9rpxC5JDWCdS/Jcf0uXzDct1FrIiAFMOypM+/iJM3kKEtEe3W524vERfm9+NR7WCCt6Z9CZVFHFQ7TSfvPrDDkCpXBuqX9ttw20EO+BKKO/Wc66Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 542A3DA7;
	Mon, 29 Jan 2024 03:43:17 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C3433F5A1;
	Mon, 29 Jan 2024 03:42:27 -0800 (PST)
Date: Mon, 29 Jan 2024 11:42:25 +0000
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
Subject: Re: [PATCH RFC v3 02/35] mm: page_alloc: Add an arch hook early in
 free_pages_prepare()
Message-ID: <ZbePIfOUGvTyUmPo@raptor>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
 <20240125164256.4147-3-alexandru.elisei@arm.com>
 <8d1c6b04-105e-4fb2-b514-1c5dea0fcce6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d1c6b04-105e-4fb2-b514-1c5dea0fcce6@arm.com>

Hi,

On Mon, Jan 29, 2024 at 01:49:44PM +0530, Anshuman Khandual wrote:
> 
> 
> On 1/25/24 22:12, Alexandru Elisei wrote:
> > The arm64 MTE code uses the PG_arch_2 page flag, which it renames to
> > PG_mte_tagged, to track if a page has been mapped with tagging enabled.
> > That flag is cleared by free_pages_prepare() by doing:
> > 
> > 	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > 
> > When tag storage management is added, tag storage will be reserved for a
> > page if and only if the page is mapped as tagged (the page flag
> > PG_mte_tagged is set). When a page is freed, likewise, the code will have
> > to look at the the page flags to determine if the page has tag storage
> > reserved, which should also be freed.
> > 
> > For this purpose, add an arch_free_pages_prepare() hook that is called
> > before that page flags are cleared. The function arch_free_page() has also
> > been considered for this purpose, but it is called after the flags are
> > cleared.
> 
> arch_free_pages_prepare() makes sense as a prologue to arch_free_page().  

Thanks!

> 
> s/arch_free_pages_prepare/arch_free_page_prepare to match similar functions.

The function free_pages_prepare() calls the function arch_free_pages_prepare().
I find that consistent, and it makes it easy to identify from where
arch_free_pages_prepare() is called.

Thanks,
Alex

> 
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > 
> > Changes since rfc v2:
> > 
> > * Expanded commit message (David Hildenbrand).
> > 
> >  include/linux/pgtable.h | 4 ++++
> >  mm/page_alloc.c         | 1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index f6d0e3513948..6d98d5fdd697 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -901,6 +901,10 @@ static inline void arch_do_swap_page(struct mm_struct *mm,
> >  }
> >  #endif
> >  
> > +#ifndef __HAVE_ARCH_FREE_PAGES_PREPARE
> 
> I guess new __HAVE_ARCH_ constructs are not being added lately. Instead
> something like '#ifndef arch_free_pages_prepare' might be better suited.
> 
> > +static inline void arch_free_pages_prepare(struct page *page, int order) { }
> > +#endif
> > +
> >  #ifndef __HAVE_ARCH_UNMAP_ONE
> >  /*
> >   * Some architectures support metadata associated with a page. When a
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2c140abe5ee6..27282a1c82fe 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1092,6 +1092,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
> >  
> >  	trace_mm_page_free(page, order);
> >  	kmsan_free_page(page, order);
> > +	arch_free_pages_prepare(page, order);
> >  
> >  	if (memcg_kmem_online() && PageMemcgKmem(page))
> >  		__memcg_kmem_uncharge_page(page, order);

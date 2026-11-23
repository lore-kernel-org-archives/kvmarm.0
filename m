Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795449328;
	b=UbUotpVw4BpzjKfjVimT4FMos3fgwpIPMe2YHxG0n+1JdwdtmPAHmExb74n9D52R6TZg
	 UlfRPgN5F4mOtGsCSsoGUVVAoLv64GdIGaOormcCevsDA9ZgRcBqC6jcReiDiR91RZ1VL
	 27l+YaxLJQ3vfJ/eFgM2Yq7KvW3s6Eg7FogFlMXvvwf16Lh4AHJp9gOp7ReuCqY+LVRTW
	 ABiouepM6i1XldHDh+EUqxADU1oBLyrznmoYFdQw3Q5HTlbKQ0Zfa6EfNFWk89uoyBvJC
	 5VtecJYHKpdPbhtG4H5KKVKqTTyJ5uMA+fSFskpWKQsKx387o6qxyyCxBJqlIBVFr8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795449328;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=GRu77aryqF5vVEWWZxA71y1DXs5B7lSaSAU/I9inw/c=;
	b=Gq6O4fK78nzvddNN3b2p/2v7SnfL7ut73qr4kQi8j8CD1GY0QU1Rc0TbT/K8Yx5LNVML
	 oeF+iO9I1GPeAoCjq2qFZkA/w06arcN6ckxSOeDlX/M4kBR5J4FcmcDTI6KQcfhbTBC9I
	 KSXTeZfWycFMHi714NrqUrNpVLM83dDpevaiXX+eof56h3UMdW4jZsJk1EBsBvUSbQKAq
	 2mgMdfypTSoKNKHtAoHgkcivSriNM7vuNzvnH0fNiGcpL5OC0IR66FwzDcYKukxlWr836
	 1qIKxkjpm7CCAVLeMJhTPKFm6Fl3yVqq9K3cM7toFOMcaTDLW9riCdilTPqMIhwS4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bvXXNaJh;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691A2606A32C;
	Mon, 23 Nov 2026 15:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 691A2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bvXXNaJh
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A5B4143D;
	Mon, 23 Nov 2026 07:55:24 -0800 (PST)
Received: from e142392.arm.com (e142392.arm.com [10.2.213.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F8FE3F632;
	Mon, 23 Nov 2026 07:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795449327; bh=qIDUTgZPRjOyoHLV/9Mx1bnUgGWSH9B5CMYDf/w+HDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvXXNaJhs+yditcVabcGrX8VJiyTVfNW2IufiKxWUuj+XksExvOwZrndSo3mxT60d
	 wbs/SHh76PGFuLny1aEMbleWmCQ3EjBdbQSCVbGkyFPSuscgxQHA38cQA6WQrujpig
	 jQUpI+4WmOrSdKs0RHNe7GYXMdZzkDOGlWiOBf9o=
Date: Mon, 23 Nov 2026 15:55:20 +0000
From: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [RFC 11/12] arm64: tlbid: Pass domain to TLBI instructions
Message-ID: <kgq3yuat6i5p2qm4444ssak74e5xfy7uqftxtxukehttv46kbu@l6mcq4jhogfd>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-12-kristina.martsenko@arm.com>
 <20261001125453.BBD291F000FF@smtp.kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001125453.BBD291F000FF@smtp.kernel.org>

On Thu, Oct 01, 2026 at 12:54:52PM +0000, sashiko-bot@kernel.org wrote:
> > @@ -418,12 +437,13 @@ static inline void flush_tlb_all(void)
> >  
> >  static inline void flush_tlb_mm(struct mm_struct *mm)
> >  {
> > -	unsigned long asid;
> > +	unsigned long arg;
> >  
> >  	dsb(ishst);
> > -	asid = __TLBI_VADDR(0, ASID(mm));
> > -	__tlbi(aside1is, asid);
> > -	__tlbi_user(aside1is, asid);
> > +	arg = __TLBI_VADDR(0, ASID(mm));
> > +	arg |= get_tlbid_domain(mm);
> 
> [Severity: High]
> Is this barrier sufficient to prevent subsequent MMU Loads from reordering
> before the domain Store?
> 
> The implementation of TLB invalidation domain tracking relies on a Dekker-like
> synchronization between PTE updates and CPU context switches. The dsb(ishst)
> used here acts as a Store-Store barrier.
> 
> Since ARM64's weakly ordered memory model allows subsequent Loads (like reading
> the tlbid_domains bitmap) to be reordered before preceding Stores (like the
> PTE update), could both threads miss each other's updates?
> 
> This might cause a TLB invalidation to skip a CPU that subsequently caches a
> stale page table entry, potentially leading to memory corruption or
> use-after-free in user space. Would a Store-Load barrier like dsb(ish) be
> required here?

I think the current barrier should be sufficient, since a DSB ST is
stronger than a Store-Store barrier. If I’ve understood correctly then
the PTE update should be "DSB-ordered-before" the domain bitmap read.

> 
> [ ... ]
> 
> > @@ -626,6 +661,7 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
> >  {
> >  	struct mm_struct *mm = vma->vm_mm;
> >  	unsigned long asid, pages;
> > +	int domain;
> >  
> >  	pages = (end - start) >> PAGE_SHIFT;
> >  
> > @@ -634,21 +670,23 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
> >  		return;
> >  	}
> >  
> > -	if (!(flags & TLBF_NOBROADCAST))
> > +	if (!(flags & TLBF_NOBROADCAST)) {
> >  		dsb(ishst);
> > -	else
> > +		domain = get_tlbid_domain(mm);
> 
> [Severity: High]
> Similarly, is the dsb(ishst) barrier here sufficient for range TLB
> invalidations?
> 
> Just as in flush_tlb_mm(), this Store-Store barrier may fail to prevent the
> Load of tlbid_domains from reordering before the PTE Store.

Same as above.

> 
> > diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
> > index b44fab2dca20d..c748e710e2ee9 100644
> > --- a/arch/arm64/mm/tlbid.c
> > +++ b/arch/arm64/mm/tlbid.c
> 
> [ ... ]
> 
> > @@ -31,6 +59,14 @@ void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu)
> >  
> >  	for (int i = 0; i < BITS_TO_U64(domain_count); i++)
> >  		atomic64_and(cpu_domains[cpu][i], &mm->context.tlbid_domains[i]);
> > +
> > +	/*
> > +	 * Pairs with the DSB before reading tlbid_domains in the TLBI paths.
> > +	 * Either a concurrent PTE update is visible to this CPU before it uses
> > +	 * the mm, or the PTE updater observes the reduced domain bitmap and
> > +	 * includes this CPU in its TLBI.
> > +	 */
> > +	dsb(ishst);
> >  }
> 
> [Severity: High]
> Is this barrier sufficient on the domain-update side of the Dekker-like
> synchronization?
> 
> As with the PTE-update side, dsb(ishst) is a Store-Store barrier. Could this
> allow subsequent Loads (like executing a speculative page table walk) to
> reorder before the preceding domain bitmap Store?
> 
> If both the PTE updater and the domain updater use Store-Store barriers, the
> Dekker-like synchronization lacks the necessary Store-Load ordering,
> potentially leading to missed TLB invalidations.

As above, I think the current barrier is sufficient, since the domain
bitmap write is DSB-ordered-before the PTE read.

Thanks,
Kristina

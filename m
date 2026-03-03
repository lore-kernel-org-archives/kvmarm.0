Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DEB4921A2
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552723; cv=none; b=Vg5Yg/VzSEDTSLHxIr65aRVajB9PjNfYTduW7ScKTcsTEWN+NuS1jDOvvKecvOkzJJdKllGoJODwbcx9rvzM+LYQHqFCoQQkVfJgIaPPQBkMCHAOExpFleADddDNLSSVtLpCgnT2XdZiVFGUOsLtQiIiN3iW+3buDxQLTD9PJMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552723; c=relaxed/simple;
	bh=+qYGDeAo5eegZCpqIhfrWXuC4f7UNhUIlijkWimNlEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cO8wpsRl1HQwLDfBV1HEBCAzrnlrnd9O8Ggu3d+mqvsOSz1PpHZPmfeniKF3tlafbb0b1giVBPZ+cvugpYZ4SLHp5ORfLK4KcijLD50f18N27Ibi8BEkGSR7ijsUsup8rfpRTnz8cn7wGaIVKp4GV16Z4RI0Wboo0L0fuIFbJWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 201F4339;
	Tue,  3 Mar 2026 07:45:14 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EE8F3F73B;
	Tue,  3 Mar 2026 07:45:18 -0800 (PST)
Date: Tue, 3 Mar 2026 15:45:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	James Clark <james.clark2@arm.com>
Subject: Re: [PATCH] arm64: Implement clear_pages()
Message-ID: <aacCCwgvo2J8CCEI@arm.com>
References: <20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org>
 <aab0SvA0dU0R0pnl@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab0SvA0dU0R0pnl@willie-the-truck>

On Tue, Mar 03, 2026 at 02:46:34PM +0000, Will Deacon wrote:
> On Tue, Mar 03, 2026 at 11:06:13AM +0100, Linus Walleij wrote:
> > On QEMU:
> > 
> > Before this patch:     After this patch:
> > 2.38 GB/s              2.41 GB/s
> 
> I really don't think we should pay attention to performance under QEMU
> as it doesn't necessarily have any correlation with real hardware.

I agree.

> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> > index b39cc1127e1f..916a3e7c9a19 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -20,7 +20,18 @@ struct page;
> >  struct vm_area_struct;
> >  
> >  extern void copy_page(void *to, const void *from);
> > -extern void clear_page(void *to);
> > +extern void clear_pages_asm(void *addr, unsigned int nbytes);
> > +
> > +static inline void clear_pages(void *addr, unsigned int npages)
> > +{
> > +	clear_pages_asm(addr, npages * PAGE_SIZE);
> > +}
> > +#define clear_pages clear_pages
> 
> Hmm. From what I can tell, this just turns a branch in C code into a
> branch in assembly, so it's hard to correlate that meaningfully with
> the performance improvement you see.
> 
> If we have CPUs that are this sensitive to branches, perhaps we'd be
> better off taking the opposite approach and moving more code into C
> so that the compiler can optimise the control flow for us?

I think it's more than the loop branch - the whole DCZID_EL0 read to
decide whether to use DC ZVA or STNP. I wonder why we didn't do that
with an alternative than always read the sysreg.

That said, I wouldn't mind rewriting this in C if the numbers don't get
worse. It is a bit more involved if we keep the DC ZVA use, though with
alternatives maybe not that bad (mte_set_mem_tag_range() is an example
of doing something similar in C but for clear page we don't need to deal
with unaligned boundaries).

-- 
Catalin

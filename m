Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034D73A7848
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773058381; cv=none; b=g90TPns3GoUSzcPfb055wCBfY7+vvUrCkSKMlLz3TBmTP1IlzVZ5DR5I9RWRVajBHDxHg0At5prLP2C5NYyvTiy0VzzmH/All7UaNYJzD1/tc9dYhGae29SXqRYoeqdLhKuXnWkAHstDvusYEH2N/xzHELxRq+SfWz+5qY29wV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773058381; c=relaxed/simple;
	bh=OVtISJ0/6MCJjqVazF9ABFS3+ZX0x5ipY7A66yKqREo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4+HqwXEFNonZBCacJheRmtihXSGnNisSCgsx2qaNHhOF1tocNGqhUAekb4pxvVIPo473VSdPAwKo7rULfp4vYBCT8Z8Wby4M2IUSPwMglduHKM4LIHHTL+eDq7BsOdKiz04RnjQPDcMBvg3IdskWK6rciu92okOnHnf+oDHWM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63551516;
	Mon,  9 Mar 2026 05:12:51 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B3983F7BD;
	Mon,  9 Mar 2026 05:12:56 -0700 (PDT)
Date: Mon, 9 Mar 2026 12:12:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] arm64: tlb: Use __tlbi_sync_s1ish_kernel() for
 kernel TLB maintenance
Message-ID: <aa65QbpFfAcdqDaQ@J2N7QTR9R3>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-2-catalin.marinas@arm.com>
 <aabeUlR3QcBg7GmM@J2N7QTR9R3.cambridge.arm.com>
 <aaloumkRhnlu7gux@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaloumkRhnlu7gux@arm.com>

On Thu, Mar 05, 2026 at 11:27:54AM +0000, Catalin Marinas wrote:
> On Tue, Mar 03, 2026 at 01:12:50PM +0000, Mark Rutland wrote:
> > On Mon, Mar 02, 2026 at 04:57:54PM +0000, Catalin Marinas wrote:

> > > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> > > index 1416e652612b..19be0f7bfca5 100644
> > > --- a/arch/arm64/include/asm/tlbflush.h
> > > +++ b/arch/arm64/include/asm/tlbflush.h
> > > @@ -191,6 +191,12 @@ static inline void __tlbi_sync_s1ish(void)
> > >  	__repeat_tlbi_sync(vale1is, 0);
> > >  }
> > >  
> > > +static inline void __tlbi_sync_s1ish_kernel(void)
> > > +{
> > > +	dsb(ish);
> > > +	__repeat_tlbi_sync(vale1is, 0);
> > > +}
> > > +
> > >  /*
> > >   * Complete broadcast TLB maintenance issued by hyp code which invalidates
> > >   * stage 1 translation information in any translation regime.
> > > @@ -299,7 +305,7 @@ static inline void flush_tlb_all(void)
> > >  {
> > >  	dsb(ishst);
> > >  	__tlbi(vmalle1is);
> > > -	__tlbi_sync_s1ish();
> > > +	__tlbi_sync_s1ish_kernel();
> > >  	isb();
> > >  }
> > 
> > The commit message is correct that flush_tlb_all() is only used for
> > kernel mappings today, via flush_tlb_kernel_range(), so this is safe.
> 
> Unfortunately, it's also used by the core code -
> hugetlb_vmemmap_restore_folios() (and another function in this file).

Sorry, I missed that.

AFAICT even with that it's only used for kernel mappings, though it's
not clear to me exactly what the xen balloon driver is doing.

> > However, the big comment block around line 200 says:
> > 
> > 	flush_tlb_all()
> > 		Invalidate the entire TLB (kernel + user) on all CPUs
> > 
> > ... and:
> > 
> > 	local_flush_tlb_all()
> > 		Same as flush_tlb_all(), but only applies to the calling CPU.
> > 
> > ... where the latter is used for user mappings (upon ASID overflow), so
> > I think there's some risk of future confusion.
> 
> Ignoring this erratum, the statements are still correct for arm64 as it
> flushes both kernel and user, though I see what you mean w.r.t. its
> intended use.

My concern was just in the presence of this erratum, since we skip the
workaround in flush_tlb_all() by calling __tlbi_sync_s1ish_kernel().

As below, I agree this doesn't need to change now.

> > To minimize the risk that flush_tlb_all() gets used for user mappings in
> > future, how about we rename flush_tlb_all() => flush_tlb_kernel_all(), and
> > update those comments:
> > 
> > 	flush_tlb_kernel_all()
> > 		Invalidate all kernel mappings on all CPUs.
> > 		Should not be used to invalidate user mappings.
> > 
> > 	local_flush_tlb_all()
> > 		Invalidate all (kernel + user) mappings on the calling CPU.
> > 
> > Note: I chose flush_tlb_kernel_all() rather than flush_tlb_all_kernel()
> > __flush_tlb_kernel_{pgtable,range}, with 'kernel' before the operation/scope.
> 
> I'm fine to update the comments but, for backporting, I'd not change the
> function name as it will have to touch core code. Ideally we should go
> around and change the other architectures to follow the same semantics
> (I briefly looked at x86 and powerpc and they also seem to use
> flush_tlb_all() only for kernel mappings).
> 
> So, I think it's better to do this cleanup separately ;).

That's fair enough, and my ack stands even without any changes.

Mark.

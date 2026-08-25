Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB2547ECFD;
	Tue, 25 Aug 2026 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787667258; cv=none; b=OGXvaCQEnGwB+0DaoWeaphszqc7mrld/CgA2bP2eDIQgRj/JQ3Q4KZ3+Q+EAnPYUFm/jPoeMWrjabhyXZTb/henoyJXfgHLzzZPGcZdQLJlm7Io148j4sn6tSq/z0hhFJSY0T1FaWUQwpfohpfwx4RArRlUooDzXoe7ZFCz/ICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787667258; c=relaxed/simple;
	bh=XRIscIXaD5vIvH6+iqcx7pb+M+ri08I77vRPy0sM7Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rnsiwk+0aHoG+oly7duVDfDwrR274O/L/C4IOVul2rnmG0vFBZK+NGClonjFtcFt+69Gm6ozvzD8vnmm0EV3ap0NA8cHNP2ImiP3csHgqytXxT0zXmWZecxJSwsjGMbOBYNSno++ekrxnHPgWNHkEsa83XlEav6eikxWiIiolmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9U5B/c5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9U5B/c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638CB1F000E9;
	Tue, 25 Aug 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787667257;
	bh=iCeVjNoZeobF60+OH4Nxi54oTDRZSmQHMdE6lHiYi/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e9U5B/c5Tbvg9ISAr9IFwB1IXb7zjhZHukAHa3SyRZ/d2f1dbw63p+/43201hCitK
	 NxLA4LM2MeZvvTaeqMHs9uFyXW1m8sT/8Zi5DwlUm9caSuznGIjhihbu1QoOS0Fy0X
	 xE4gCZrS4QlUNLxSUoiak3gCCatNzymwHhULrfdQfDTaKs/Iatuhm3AuTtlbCmLNma
	 pwfrVUwdYcfj7ZQaNt8XExNUHIuD3yFcMDHdz1No0Edr4PQq7VVIQgERf4NxDISpDK
	 7SY0xfLjZnzDAmHtm9JDOocMwRmYmgXN0zSctl4ivzWNxLLWHIyUNsGmdd7l/NFCiK
	 6lWz72nSiKUwA==
Date: Tue, 25 Aug 2026 15:14:12 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <ao2jNDv8tOjnimEH@willie-the-truck>
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
 <aoypji6EJ8zToWvh@arm.com>
 <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>

On Mon, Aug 24, 2026 at 11:29:54PM +0100, Fuad Tabba wrote:
> On Mon, 24 Aug 2026 at 21:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > On Mon, Aug 24, 2026 at 07:41:55PM +0100, Fuad Tabba wrote:
> > > +/*
> > > + * Reading GMID_EL1 when the kernel has disabled MTE traps to EL2, and the raw
> > > + * ID_AA64PFR1_EL1 reflects neither CONFIG_ARM64_MTE nor the cmdline override.
> > > + */
> > > +static inline bool gmid_el1_accessible(u64 pfr1)
> > > +{
> > > +     if (!IS_ENABLED(CONFIG_ARM64_MTE))
> > > +             return false;
> > > +
> > > +     pfr1 &= ~id_aa64pfr1_override.mask;
> > > +     pfr1 |= id_aa64pfr1_override.val;
> > > +
> > > +     return id_aa64pfr1_mte(pfr1);
> > > +}
> >
> > Can this function not use __read_sysreg_by_encoding() directly and not
> > get an argument at all? We'd get the override from that function rather
> > than open-coding it here.
> 
> Like this?
> 
>       static inline bool gmid_el1_accessible(void)
>       {
>               if (!IS_ENABLED(CONFIG_ARM64_MTE))
>                       return false;
> 
>               return
> id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));
>       }
> 
> > Eventually, once we get Suzuki's clamping fix,
> > it also ensures we won't be able to bump the MTE version to unsafe
> > values (but that's a different fix from this one).
> 
> Agreed it's separate, but v3 applies the override without checking
> that the CPU has MTE2, so id_aa64pfr1.mte=2 on a CPU without it reads
> a GMID_EL1 that isn't there. On the boot CPU that's before the
> override is sanitised. Should I check the raw register before applying
> the override, until the clamp lands?

At which point, why don't we bite the bullet and implement Suzuki's
idea so that __read_sysreg_by_encoding() does what you want more generally?

https://lore.kernel.org/all/afc5bd00-28ca-413b-b047-ee53589c285d@arm.com/

> > If you are worried about additional trapping of the MRS, we should go
> > for Will's improvement to always read the cached values in
> > __read_sysreg_by_encoding().
> 
> Not worried :) __cpuinfo_store_cpu() has already read ID_AA64PFR1_EL1
> a few lines up.

But if you go with __read_sysreg_by_encoding() then you'd still be
reading it (and trapping) twice, no?

Will

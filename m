Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381B417A597
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108586; cv=none; b=Ui6dWUhaJBMrEn8AYxR3+6paHwZ/nZ1IxyD/ifW71f6G62vXL7m0Zw1Ua3H8u84kg9vwlAub/ely/2pWwbJzDr1RK7BaR99yx45EXCSxe1jri1iKlWXf7PHtjuihefy6rjcfJ0nooH0DCVTYX7lsgeuU8GYvzpbJ46h1tGfpUxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108586; c=relaxed/simple;
	bh=P95R96UawHpxOFKIYKMHOffApWhcgo8/qTxupcaIBNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJMIgi6I8PhLsqfbEfVJvBS4Jq9PQfi8q7mRwF8nyRl01oylmoeOPzmoP4x3XaQQIsAR4Yb//A8gjKm797wvyQdE8FY9/x8EdWMLw5lFV8ZthlBiO1ZDhg06yaadhxgh6KvJnsLgpeMYM9XTgKc7MPkyia/+5VVRR5xnYuCOs5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B597C1480;
	Fri, 13 Dec 2024 08:50:11 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.1.196.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15C1F3F5A1;
	Fri, 13 Dec 2024 08:49:41 -0800 (PST)
Date: Fri, 13 Dec 2024 16:49:39 +0000
From: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
	corbet@lwn.net, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Message-ID: <20241213164939.GD30314@mazurka.cambridge.arm.com>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-3-miko.lenczewski@arm.com>
 <87cyhxs3xq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cyhxs3xq.wl-maz@kernel.org>

On Thu, Dec 12, 2024 at 08:25:53AM +0000, Marc Zyngier wrote:
> Ah, so this is where this is hiding. I missed it in my review of patch
> #1 yesterday.
> 
> On Wed, 11 Dec 2024 16:01:38 +0000,
> Mikołaj Lenczewski <miko.lenczewski@arm.com> wrote:
> > 
> > The Break-Before-Make cpu feature supports multiple levels (levels 0-2),
> > and this commit adds a dedicated BBML2 cpufeature to test against
> > support for.
> > 
> > In supporting BBM level 2, we open ourselves up to potential TLB
> > Conflict Abort Exceptions during expected execution, instead of only
> > in exceptional circumstances. In the case of an abort, it is
> > implementation defined at what stage the abort is generated, and
> 
> *IF* stage-2 is enabled. Also, in the case of the EL2&0 translation
> regime, no stage-2 applies, so it can only be a stage-1 abort.
> 
> > the minimal set of required invalidations is also implementation
> > defined. The maximal set of invalidations is to do a `tlbi vmalle1`
> > or `tlbi vmalls12e1`, depending on the stage.
> > 
> > Such aborts should not occur on Arm hardware, and were not seen in
> > benchmarked systems, so unless performance concerns arise, implementing
> 
> Which systems? Given that you have deny-listed *all* half recent ARM
> Ltd implementations, I'm a bit puzzled.
> 

I had tested on an earlier series of the patchset that didn't introduce
the MIDR checks (has_bbml2() only read the claimed level of support),
but otherwise had the same implementation.

> >
> > +static inline bool system_supports_bbml2(void)
> > +{
> > +	/* currently, BBM is only relied on by code touching the userspace page
> > +	 * tables, and as such we are guaranteed that caps have been finalised.
> > +	 *
> > +	 * if later we want to use BBM for kernel mappings, particularly early
> > +	 * in the kernel, this may return 0 even if BBML2 is actually supported,
> > +	 * which means unnecessary break-before-make sequences, but is still
> > +	 * correct
> 
> Comment style, capitalisation, punctuation.
> 
> > +	if (!system_supports_bbml2())
> > +		return do_bad(far, esr, regs);
> > +
> > +	/* if we receive a TLB conflict abort, we know that there are multiple
> > +	 * TLB entries that translate the same address range. the minimum set
> > +	 * of invalidations to clear these entries is implementation defined.
> > +	 * the maximum set is defined as either tlbi(vmalls12e1) or tlbi(alle1).
> > +	 *
> > +	 * if el2 is enabled and stage 2 translation enabled, this may be
> > +	 * raised as a stage 2 abort. if el2 is enabled but stage 2 translation
> > +	 * disabled, or if el2 is disabled, it will be raised as a stage 1
> > +	 * abort.
> > +	 *
> > +	 * local_flush_tlb_all() does a tlbi(vmalle1), which is enough to
> > +	 * handle a stage 1 abort.
> 
> Same comment about comments.
> 

Will fix.

Kind regard,
Mikołaj

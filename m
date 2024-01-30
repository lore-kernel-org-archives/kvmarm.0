Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE1866B47
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614446; cv=none; b=eWpsvO9Wia33pk8104VtAreONG52QJS3Yf/tyqyqCyRa4dlKx+rETBmToPQJvNkmu5kgO1vFvVZXpgjH5SjCnImRqvuJAXbgwODdyOI6io7gWyhaRakFUt92zyppCOXxln7cSYTCGvXmLnDgyUsssifLG2BwKbcPlc03NQJcDeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614446; c=relaxed/simple;
	bh=ENHOs+CW95ZPp9vhiJaKUnrUPARMC0OGRwPXzpMiOI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HT5URA5W/Vj5MUzkB4jVg59zTdZIujuL/aMAIetrmevcDi0CnVjGePx5iYtb7lqEiNMP53hm39OjgWP84GOgpS3jAFhaADuFZFeQnh7mVQt5osfakAelqMu9QlPae313G1+0grKRhzoxXigX7dhR+1XlYZ/gcJvPRRMLfeEPiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bt0HK8ZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bt0HK8ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF385C433F1;
	Tue, 30 Jan 2024 11:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706614445;
	bh=ENHOs+CW95ZPp9vhiJaKUnrUPARMC0OGRwPXzpMiOI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bt0HK8ZIlMnNtUOzr3tDObL0npWlvAFDrimIyIeUrMNN6tBbJhzu+tAtqF/ROYxwm
	 iL2uH0zpcSkmzajPoNvOpCm3oyJpiGHhDZHAOu4PcLhOd/5iIaIdQaEEZmiuBnmJ8p
	 NoMUHt4CpddsxJfBHLa8SAxG8yA+eVlM2Rj7YFfzekmo60n0n4mIUshzeRuNYOrDF3
	 Adp5x1++nWSo0RxTevrzBH+UOMo2+XoJfHjt8zaDpo674j7E+wyM+jFoHL7/qntK4G
	 VMIUjB7YOqPCbc3f8959fG4EsvqYdwpJR7VoNRCAywYNP4DU8MS+thUy7Xs6+/WQ2g
	 sB3dRGHrZdg2g==
Date: Tue, 30 Jan 2024 11:34:00 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 02/13] arm64: cpufeatures: Correctly handle signed
 values
Message-ID: <20240130113359.GA13551@willie-the-truck>
References: <20231127114559.990314-1-maz@kernel.org>
 <20231127114559.990314-3-maz@kernel.org>
 <20231211122416.GA25277@willie-the-truck>
 <86a5pfafbv.wl-maz@kernel.org>
 <87plyau44c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plyau44c.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jan 09, 2024 at 11:40:19AM +0000, Marc Zyngier wrote:
> On Mon, 08 Jan 2024 17:46:12 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Mon, 11 Dec 2023 12:24:16 +0000,
> > Will Deacon <will@kernel.org> wrote:
> 
> [...]
> 
> > > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > > index 646591c67e7a..bc8787f28ffd 100644
> > > > --- a/arch/arm64/kernel/cpufeature.c
> > > > +++ b/arch/arm64/kernel/cpufeature.c
> > > > @@ -140,12 +140,42 @@ void dump_cpu_features(void)
> > > >  	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
> > > >  }
> > > >  
> > > > +#define __ARM64_MAX_POSITIVE(reg, field)				\
> > > > +		((reg##_##field##_SIGNED ?				\
> > > > +		  BIT(reg##_##field##_WIDTH - 1) :			\
> > > > +		  BIT(reg##_##field##_WIDTH)) - 1)
> > > > +
> > > > +#define __ARM64_MIN_NEGATIVE(reg, field)  BIT(reg##_##field##_WIDTH - 1)
> > > 
> > > I'm struggling to grok these two macros. For example, let's say I have a
> > > 4-bit signed field. In that case, the maximum positive value is 7 (0b0111)
> > > and the minimum negative value is -8 (0b1000), but the macros above appear
> > > to give 0b1000 for both.
> > 
> > Crap. Well spotted. The signed maximum needs to be further adjusted
> > like this:
> 
> Actually, scratch that. The original code is correct and does return
> 0b0111 for the max of a signed 4 bit value, and 0b1000 for the min.
> The clue is in the bracketing (the '- 1' is applied to the result of
> the conditional expression in the max case).

Gah, sorry, that trailing '- 1' really caught me out with the formatting!

Will

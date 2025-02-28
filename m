Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DCB25EFBA
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740737658; cv=none; b=dfrdfNC1/CDxDq+KpSN3rLcOuJCoGBrSs/LGvJIrHBagEz9yJVnA7V2xrMASXebK6CeTrHNW132A9f3+6ySpjNFCFOSnGxdbuR50DGI9X+Vi0H3DSrfkl900dLCaumDqNLfXlFeuo3Q2dxMU+PFYDJ3tvA9qDF/uUOG7IiTpF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740737658; c=relaxed/simple;
	bh=1wHUJlnA2J9ceqlZpRg96NnodH22XjBdYrS2WJ/LA5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzC5WwBfTw3GgCv/dlvJ/dEemtEXM+xkwyfW0NvJIry9WBTU0Nh8cAmnyzvF3j6ZYycBhccK9fMPp5xdI/bSaGz/DEVyS6v8e1VXCrWpGnj6yH+lA2eL0mq1eRPXf2KRdIdA3yToHx7dXLFaJKlbWwdgJKETXOYKWr/fBkLh5v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C51D1688;
	Fri, 28 Feb 2025 02:14:31 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F29493F6A8;
	Fri, 28 Feb 2025 02:14:15 -0800 (PST)
Date: Fri, 28 Feb 2025 10:14:11 +0000
From: Leo Yan <leo.yan@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, ahmed.genidi@arm.com,
	ben.horgan@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
	oliver.upton@linux.dev, will@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Initialize HCR_EL2.E2H early
Message-ID: <20250228101411.GE2157064@e132581.arm.com>
References: <20250227180526.1204723-1-mark.rutland@arm.com>
 <20250227180526.1204723-2-mark.rutland@arm.com>
 <20250228092955.GC2157064@e132581.arm.com>
 <86y0xqpfpj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y0xqpfpj.wl-maz@kernel.org>

On Fri, Feb 28, 2025 at 09:43:20AM +0000, Marc Zyngier wrote:

[...]

> On Fri, 28 Feb 2025 09:29:55 +0000,
> Leo Yan <leo.yan@arm.com> wrote:
> >
> > Hi Mark,
> >
> > On Thu, Feb 27, 2025 at 06:05:25PM +0000, Mark Rutland wrote:
> >
> > [...]
> >
> > > +.macro init_el2_hcr        val
> > > +   mov_q   x0, \val
> > > +
> > > +   /*
> > > +    * Compliant CPUs advertise their VHE-onlyness with
> > > +    * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
> > > +    * can reset into an UNKNOWN state and might not read as 1 until it has
> > > +    * been initialized explicitly.
> >
> > For ID_AA64MMFR4_EL1.E2H0 < 0 case, the code actually clears the
> > HCR_EL2.E2H bit.
> >
> > Hence, the comment should be corrected as: "... it can reset into an
> > UNKNOWN state and might not read as 0 until it has been initialized
> > explicitly".
> 
> The comment is just fine. It is the code that is wrong, as it avoids
> setting E2H when E2H0 < 0 while we want the exact opposite behaviour.
> 
> As a result, 'b.lt' really should be a 'b.ge'. Or the original code
> kept as is.

Thanks for correcting.

> > > +    *
> > > +    * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
> > > +    * don't advertise it (they predate this relaxation).
> > > +    *
> > > +    * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
> > > +    * indicating whether the CPU is running in E2H mode.
> > > +    */
> >
> > I think it is even better to clear the HCR_E2H bit first. This can
> > avoid any dependency on the passed parameter 'val'.
> 
> What are you trying to avoid? A random value passed as a parameter to
> the macro?

Yes, an unexpected value passed to the macro is a concern.

If the intentaion here is only to set the HCR_EL2.E2H bit when E2H0 < 0,
we don't need to cosndier other configurations and current code is just
fine?

Thanks,
Leo

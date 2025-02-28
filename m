Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF33B258CE4
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 09:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736381; cv=none; b=H3KAseaR/9QzufdSzN2dW8m7qtyHMP0slZQkw6UcbMBn+r91oejvygBW862fPRBXzjg7NOBPuVOm/rSdEATVlGr4OBUkwVCqkrwxvKiv2W1LuIWQUYE7+fq7xjVC0Fzfl+yt230kRKsEEXSI6o16y+sDxqDHGlZTGQdyVj00r30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736381; c=relaxed/simple;
	bh=LYzyvqEhsyFMPwHErLIri74hLBq4WHu4ylJX6mLmXAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QI7HbyPS3JZb971tcoFyI0iq3789Wmc2GRwcTsLV+grd+Q3m1B8ZPDHor2jOCM+XcddJc/Nrtum96OodZdvSXi5QYFRaHfjVkhNJXq/MgnpxcPNHGmiMO6sY5OYjYbuhbGfbNKUGCw45+wnC/M8CwMSDB/Y15DhpZF2/UL9qnVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 081AE1515;
	Fri, 28 Feb 2025 01:53:14 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2523A3F6A8;
	Fri, 28 Feb 2025 01:52:57 -0800 (PST)
Date: Fri, 28 Feb 2025 09:52:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	ahmed.genidi@arm.com, ben.horgan@arm.com, catalin.marinas@arm.com,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev, will@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Initialize HCR_EL2.E2H early
Message-ID: <Z8GHclusYN3CX5m2@J2N7QTR9R3>
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
> On Fri, 28 Feb 2025 09:29:55 +0000,
> Leo Yan <leo.yan@arm.com> wrote:
> > 
> > Hi Mark,
> > 
> > On Thu, Feb 27, 2025 at 06:05:25PM +0000, Mark Rutland wrote:
> > 
> > [...]
> > 
> > > +.macro init_el2_hcr	val
> > > +	mov_q	x0, \val
> > > +
> > > +	/*
> > > +	 * Compliant CPUs advertise their VHE-onlyness with
> > > +	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
> > > +	 * can reset into an UNKNOWN state and might not read as 1 until it has
> > > +	 * been initialized explicitly.
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

Ugh, yes. I got confused and got the condition backwards.

Either works. Using 'b.ge' is closer to my intention -- I found the
'tbz' of the sign bit somewhat surprising and that needed a longer line
after the lable name changed.

Would you like me to respin, or would you be hapy to fix up when
applying?

Mark.

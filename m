Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEF27DA63
	for <kvmarm@lists.linux.dev>; Thu, 15 Aug 2024 12:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725510; cv=none; b=kXpcosEDBrLEN4jDTKTFvCcMKRE031tEqTGOnqZEG0LwEatan0cRM1bIWFcvrZRJuDTIr0K/luohbRljP8VDeTypqXQOJYeyXzCE/4wYmXS89DvxSKsL7y0yEF+Umm7Leax6uTX5iI5Oydyj2E+QMpp5co05WqONl6PicIugFOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725510; c=relaxed/simple;
	bh=vxokwVKRC/ZjP7QtuLy9v1HzFLSZ3GmX7HyimwoV+9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaDaQRht/DuqjtC8ZIcNKnjoFHObCoQsXLhPP501kr7Ey2iPiwVZHRjNgyG6HUgC0YZCXsq6DOvjMAsNj5GXCRCNPZ8krzrHGDgXsLiQTQQFF/Kudo3wcdzIsTmbOx0Szph3LOqcyZNT/jVll/3RMqzLHAcYZjt3fFH3DdsV2e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hY3Sh26G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hY3Sh26G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF369C32786;
	Thu, 15 Aug 2024 12:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723725509;
	bh=vxokwVKRC/ZjP7QtuLy9v1HzFLSZ3GmX7HyimwoV+9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hY3Sh26GyS42VNN7GQpJaKFlECAWRTfBj0vGGtrNR/d6TgGtpWiK3A+UYiIOAmAPL
	 wu9y6YFKUvlD0IZOzINUBmn2Vr7j+YeEtDIW2wQQtCFOgcMjGYp45J3oRs02GP/P9J
	 qTeplbo8XYe35spa7EMil6gx3WD5ixik9NmGAc5KBVtr6xet00s/uKHr3X6dEe8Ul+
	 rcpLNkmX+/gs4wYr3LDxfpxnjubtKYheQ1B55wx7On/7e5h6SHpL0dyEr9OjrHKmUW
	 zytj65YPwDn9xMX+EvqWEOqgDe3mXiAOt1K3zFY29ScKCmIxhxH0bvqTkAFJkc/Ria
	 xaUyLurlom2iQ==
Date: Thu, 15 Aug 2024 13:38:20 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBI uses correct VMID after
 changing context
Message-ID: <20240815123820.GA21495@willie-the-truck>
References: <20240814123429.20457-1-will@kernel.org>
 <20240814123429.20457-3-will@kernel.org>
 <86ttfnz0xe.wl-maz@kernel.org>
 <20240815120803.GA21444@willie-the-truck>
 <86o75uynk5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o75uynk5.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Aug 15, 2024 at 01:31:54PM +0100, Marc Zyngier wrote:
> On Thu, 15 Aug 2024 13:08:03 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > > Is there an actual path within pKVM that causes a guest TLBI to be
> > > followed by a host __kvm_tlb_flush_vmid() *without* a CSE? I can't
> > > convinced myself that such a path exist in the current upstream code
> > > base.
> > 
> > I think you're right that this can't happen upstream. We see the issue
> > in Android when reclaiming pages from a guest during teardown. That
> > amounts to unmapping pages from the guest, poisoning them and mapping
> > them back into the host. Mapping them into the host can then trigger
> > table -> block conversion and the associated TLB invalidation wasn't
> > effective because it was still using the guest VMID.
> > 
> > We can carry this patch in Android if you prefer, but given that
> > {enter,exit}_vmid_context() are upstream, it would be nice to land the
> > fix so that we don't run into this bug again in future (it took some
> > debugging!).
> 
> I think it is definitely worth addressing, and given that this is nVHE
> only, an extra CSE isn't going to show on the radar.
> 
> The question is more whether this is 6.11 or 6.12 material. If that's
> not an immediate fix for upstream, I'm tempted to queue it for 6.12.
> 
> Does this work for you?

6.12 is absolutely fine, thank you!

Will

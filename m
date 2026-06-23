Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199373955DD;
	Tue, 23 Jun 2026 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245329; cv=none; b=aVpYYnfRh5R/TuzkDG69N8QDZrNU+8VQGR4vCP2Uw1mld0cD5/NfEG+21FSNK1K+M0UWBrJyJ+pmqe/o43VphLDjG5//YVYktkdhiDNeYuBUcQKIKRpVHYNAwLHkOCnrgDZ7quv9BdiKkqbY1IsZCK4TDWhIGmVPNxgjUQdHZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245329; c=relaxed/simple;
	bh=cj/USVJ6VVdYo0NQQmMJUzVIhTYlL52OK+OEkxS/Q/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FU/PoS39h4zvyUhP6SVwYWJdIdjW8gdaMe65i2Cc/75nN1vh0A5HnOvWxenF11yS1g12n8oVIvnlJSOO+iblzvUuKZHI8V+2LScmOCgXGNI0/oQkAb4ReqrdEAQdYqa1PUxf66PCPwKYelNtaI54u2bfc9RnrVBIzD1cRmIxF7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHHgbYOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHHgbYOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584FB1F000E9;
	Tue, 23 Jun 2026 20:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245327;
	bh=CGmTT+5Sry8TV0Aj4VBTCzQBYznrl1LqVFOb01dCG6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WHHgbYOYDjbdDPNCiSNYV8aKkmismfcWQlgHUbKGGXEM1GvRCVJCgGsKOhv2EpxLR
	 t0le9tUctUthoZqHz6hp0VX6oFIqEncQQ4xGgqAzCfRKH0qfX/tftbQesPsWZA2xYC
	 K7x825rbV62T72sKJjsRgUkeqE7xV9edx68BkbVSP1d2Diwu95GJSSKQkOzIk7kZOw
	 gt2boHvl/V3/NqsuTTreZV9GbBuLMDTVNvKFbdTh8AGIofp3M9ANQjUzwH96en5ndi
	 yFOJM1V/1Abjdz9tuqAZqNCi97/mDF8G8/5HUe05SdF14uhD8QvKiUIA5Vtd9MWB18
	 eYyHbnG4y4YnQ==
Date: Tue, 23 Jun 2026 13:08:46 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Message-ID: <ajrnzgRRb4SK673x@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-9-oupton@kernel.org>
 <20260623185533.79A841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623185533.79A841F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 06:55:33PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] DBM incorrectly grants write permission to "No access" stage-2 pages, breaking nested guest isolation.
> --
> 
> commit 99b59d5177f5650f344f4c618e4c4dcd2d5d6d1c
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: nv: Treat DBM as writable at stage-2
> 
> This commit modifies the stage-2 permission computation to treat the DBM bit
> as granting write permission when hardware dirty state is enabled.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> [ ... ]
> > @@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
> >  		break;
> >  	}
> >  
> > +	/*
> > +	 * Descriptors with the DBM bit set while hardware dirty state are
> > +	 * considered writable, even though certain accesses (like AT instructions)
> > +	 * don't actually update the dirty state.
> > +	 *
> > +	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
> > +	 * for the access and just treat DBM as writable here.
> > +	 */
> > +	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> > +		s2ap |= BIT(1);
> 
> [Severity: Critical]
> If s2ap is initially 0b00 (No access), this unconditional OR operation will
> upgrade it to 0b10 (Write-only) in compute_s2_permissions(). Does this
> inadvertently bypass stage-2 memory protections if an L1 hypervisor maps a
> page as No access but leaves the DBM bit set?
> 
> Without verifying that read access is already granted via s2ap & BIT(0),
> this logic grants write permission to a No access page, allowing an L2 guest
> to write to memory explicitly protected by the L1 hypervisor.

This is wrong.

R_XZFQH defines a descriptor with DBM set that would otherwise generate
a write permission fault as writable-clean. That means the descriptor
grants write permission and hardware can relax it to writable-dirty
depending on the access.

Thanks,
Oliver

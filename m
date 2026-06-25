Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD96E2D77F5;
	Thu, 25 Jun 2026 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416088; cv=none; b=C7BxT7cq2DZluirVhSUIM+0oq7u95db559BPXKwwGNyJZw/Yp91XV9VuzYEqF5lDFB/9kerOVH+YcF8TD4vdiMXTn3DTWnALAqZ559+JELvxcL+lGihbxo21BvARgyDp4iEAI9l9rTqptFLGjq9n1pCKMk6wUs1fX7MyHIG2tRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416088; c=relaxed/simple;
	bh=Myehi31H7mnPLagwcAuIcBHBIG55nemcmIQ57wsz4FY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzsAx/OD99AQSzjfkJzrbgL6+3lcBCI3PMAvgFlVU9QuS2XvKqe1lRmkUoIqSTj2IoUsaVtGnDI/l0zjsdqsc4XNueuyRv/ewT+9AfSwqomoPjxfKgeJV/uDe3JhakXcpsyDrTtxZ9Up3JjkXxqbkMgZcRDSQt+6CvAzhsZ/gck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhQZSt1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhQZSt1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646781F000E9;
	Thu, 25 Jun 2026 19:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416087;
	bh=FprtAscsD/i3zGAxb2tXLxIJWJAJDgRyOvrOgLJs4SU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KhQZSt1YmA9XCE/7rCTrd+I4barZ1zeX2iAzSIOOdR7rT9onRjH9iU7tdkqJTo9vJ
	 ab9257K3ArtgF9i8z9DUuIblhKCbfHDYaYfFtp1yBfIeQAxfjXtF+jXzmbstTniJ7M
	 SsYKsPXGSWFacrn1g8Eou5L6vrBy/S+r9z6lTxiQfRoCFWLaAv/UGSNWTGazoYtlUZ
	 ku2X00XXswBQUZ011m5rOa6kf/pcHNCQHy9l7rPTu0Y4wUUy3FdJXLjP5tjtscQSC9
	 xF9b9/1OroS3dlCLMt5zdsHUxjjEMq5sVjpQWMe6eVlpZbH17ClgGB2s+J0IVPnHqL
	 cJtOKVgBwjodg==
Date: Thu, 25 Jun 2026 12:34:46 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/2] KVM: arm64: Only consider S1PTW a write fault if
 HA is set
Message-ID: <aj2C1na3fc_BlvuC@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-2-oupton@kernel.org>
 <20260624204025.519861F000E9@smtp.kernel.org>
 <ajxFe5N2CXySmLbU@kernel.org>
 <86echur5g9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86echur5g9.wl-maz@kernel.org>

On Thu, Jun 25, 2026 at 04:43:34PM +0100, Marc Zyngier wrote:
> On Wed, 24 Jun 2026 22:00:43 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > On Wed, Jun 24, 2026 at 08:40:24PM +0000, sashiko-bot@kernel.org wrote:
> > > > +	/*
> > > > +	 * The architecture sucks; assume that the S1PTW fetched for write if
> > > > +	 * HA is enabled at stage-1. Note that hardware updates to dirty state
> > > > +	 * and table AF are predicated on HA=1 (DDI0487 M.a D24.2.194; R_SNVTX).
> > > > +	 */
> > > > +	if (kvm_vcpu_abt_iss1tw(vcpu))
> > > > +		return effective_tcr_ha(vcpu);
> > > 
> > > [Severity: High]
> > > Does unconditionally treating S1PTW faults as writes when HA is enabled break
> > > guests that use pre-populated page tables in read-only memslots?
> > > 
> > > If a guest populates its page tables with the Access Flag already set, places
> > > them in an RO memslot, and enables HA in its TCR, the hardware only needs read
> > > access during a walk.
> 
> Correct, this is a consequence of R_HDTRB.

While not _directly_ related, this does seem at odds with the
implications of R_JCXVS.

I.e. when HD is set, the PTW can speculatively fetch the S2 translation for
write before knowing if the S1 descriptor is actually subject to an
update per R_HDTRB.

It obviously all still fits together (permission checks are later down
the line), just weird is all. Anyway...

> I've been chewing on that one for a bit, and came up with the
> following argument:
> 
> - We're missing one of Read or Write because of L1's doing, and L1
>   needs to do *something* about it. We don't need to find out about HA
>   in the guest, we just need to forward the fault (and it is probably
>   enough to check that we're in a nested context).

We still need to account for host-induced permission faults, e.g. dirty
tracking or an RO memslot getting mapped into the L2. So I think we
still need to evaluate R+W before forwarding to the L1.

Looking ahead to HAFDBS, for this to work we will need to use a liberal
interpretation of R_JCXVS at the time of the initial translation fault
and always walk with intent for write.

Basically, there seems to be a subtle difference arising between writes
as observed from the nested MMU and writes as observed at the virtual
endpoint (memslot). Funny how something as straightforward as the access
flag can be so headache inducing :)

> - We have checked that HA==1, derived from that that we need R+W, and
>   we're missing the Write permission because the page is marked RO
>   (assuming that KVM still maps with Read permission by default):
> 
>   - either it is "opportunistically" RO (dirty tracking, page never
>     written to), and we flip it to RW, rince, repeat.
> 
>   - or it is hard-wired to RO at the memslot level, and the only
>     possibility is that the PTW is trying to perform an atomic access
>     (as per R_HDTRB), which we should be able to reject with an
>     "Unsupported atomic hardware update fault".
> 
> Thoughts?

All aboard :) I've just been staring at dirty state crap for too long. I
really like the unsupported atomic fault over our current behavior of
injecting an SEA.

I'll fold all of this into v3.

Thanks,
Oliver

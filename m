Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF1B3B6BFA;
	Fri, 31 Jul 2026 19:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785524729; cv=none; b=ipChOZblWs4ukaFXOkxWAq7+yomIxeOaU+KKw5/PY0Kk+EQLWuJgDEPvKsWdI7MDKyuhpteLG8MFA1zre0JzaKnOvf0Xi4OaN4DG3JnulVoIWpKwnFJX/0dP8CTbCQPxWlAnXB2DqTue/8VHyMxPCvSGUyBhGptuUcDUkzthH08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785524729; c=relaxed/simple;
	bh=Lx054CG9dIzBqszzJAHgFm0MywIatCpgMOlKkkTlTnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZuhn5BY6qEuwzU0Z5nAhJLsufpcI/bChMRSjn/HfWKgqOltsnk9Pg9YMK0cfBob9VHwVNHljjWvfCR2S/IZxv7XEaQ9OUp1Ogbs0AHkHmpoVqY2uvRXpphR9QqsuOxV8W40MtYVak8xgnEzGBW8yq9lfKWuruwcYGj+B1uefIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLcEbxJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLcEbxJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E750F1F00AC4;
	Fri, 31 Jul 2026 19:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785524728;
	bh=xTvdhsBpOd7JIOK6/OSC6kWUmgECXFbgK/UrghGZEEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NLcEbxJOl8MNq7AhCfiQ210nRKnVN/YTK5UryuGbAQcZPT0hwLXmp/NY+B1/w5uwK
	 xhSMoC+VVwYojs70W/tkka/7RXEH7ilbPIsdwj8rHBH57xoTNtXYT6BbMw15wDv3tD
	 HoWs76ecUsUOVon7rXZ5sARUs3x87GtR/DhkaqVcJE8lYtvS+2de4QzFs31TTDx+DG
	 uQz/T51qsfrrlPT38G2YZ5Z+jOf1ae8BeJJCKAs1DUS3LwpYgYe5ZO84mYEdXTpmP6
	 ByttCZOzg7IXABrWnuwtXhO2SuqqUcNbHKwqpxpFv+ebTOOiAn8USvc4QoixGxQRbm
	 /wZ5/B6/c7eAw==
Date: Fri, 31 Jul 2026 12:05:26 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, sashiko-reviews@lists.linux.dev,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dirty
 logging faults
Message-ID: <amzx9rqqU58QZBMU@kernel.org>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
 <20260717130317.1953574-4-fuad.tabba@linux.dev>
 <20260717131537.71F531F000E9@smtp.kernel.org>
 <CA+EHjTzZxa7Yb2GJhbJdtnTgGoiPTmSAotWTF7S7acq6M_trwg@mail.gmail.com>
 <87cxwkr8k0.wl-maz@kernel.org>
 <amxKgJ1cCHO97trp@kernel.org>
 <86cxw3d0ts.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cxw3d0ts.wl-maz@kernel.org>

On Fri, Jul 31, 2026 at 09:23:43AM +0100, Marc Zyngier wrote:
> > FEAT_BBML3 shifts responsibility onto the implementation to reconcile
> > multihit due to mapping granularity changes. A hypervisor could choose
> > to do eager page splitting at the beginning of dirty logging and elide
> > TLBIs.
> 
> Sure. We just don't advertise BBML3. and I'm not even sure we always
> can emulate it.

Well, we'd at minimum need supporting hardware since the feature must
also exist at stage-1.

> > 
> > > I think the latent bug here is the way we always walk L1's S2 on S2
> > > fault, irrespective of the fault type, and that feels wrong. This is
> > > ignoring the fact that we already have a TLB (the shadow S2) for this
> > > mapping, and rewalk anyway. Since we now find valid permissions, we
> > > take it at face value and try to install this new translation (which
> > > could point to a different OA, and even bigger problem).
> > > 
> > > So ideally we'd simply tell the guest to bugger off, but we need to
> > > solve a few problems first:
> > > 
> > > - some permission faults are caused by the host rather than the guest
> > >   (dirty logging, HAFDBS), and we need to treat those specially.
> > > 
> > > - we need to rebuild an ESR based on the content of our TLB, not L1's
> > >   S2, which is not always easy to obtain (we have some limited TTL
> > >   caching in the shadow S2, but that's not always reliable).
> > > 
> > > All of this strongly intersects with Wei-Lin's reverse map, and
> > > Oliver's HAFDBS support.
> > > 
> > > Oliver?
> > 
> > Hmm, I'm more of the mind that we should just keep the memcache topped
> > up for any fault because clearly the prediction has gotten out of sync
> > with what happens later down the line. We're bound to screw it up again.
> > 
> > Generating faults solely based on the TLB seems to be at odds with
> > supporting FEAT_ETS* in the shadow stage-2 and practically means we
> > need to re-walk for most stage-2 aborts anyway. And as you point out, I
> > need to do this for HAFDBS dirty state updates.
> > 
> > BBML3 and ETS2/3 aren't terribly high priority but I'd rather not paper
> > over a rather straightforward KVM bug by making design decisions that
> > limit our feature set for nested.
> 
> My problem here is not the top-up of the memcache, but the fact that
> the OA may have changed in L1's S2. This potentially result in an
> inconsistent S2, and in the future a wonky reverse map. So I'm not
> advocating we paper over anything. It's exactly the opposite.

AIUI the bug is that a change in mapping granularity (but not
necessarily OA) can cause a shadow stage-2 permission fault to remap at
a finer granularity and allocate table pages. This seems like something
we will eventually have to deal with for BBML3.

OTOH, I completely agree with you about changes to the OA. We should
synthesize a TLB conflict abort and let the L1 clean up the mess.

I was actually thinking about hardening the stage-2 map path, rejecting
valid->valid conversions that result in a change of the OA. We'll want
to have that anyway as Mostafa is adding support for BBML3, that error
could be propagated as a TLB conflict abort to the L1.

Thanks,
Oliver

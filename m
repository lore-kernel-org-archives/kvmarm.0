Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F3B3D3D0E
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643649; cv=none; b=IEcxJmxZBkNl6RKBLz2w8e9QEYckryBmAlonheF4v552kp7xBH9liDnCeDahnq/F79nyx442A+YfVkIQH8YYeNdK3uH4L+2Nw5fbeSZXwFQQdDN+9nEKvIP70Qv30KOflOSv5rTDyiR/5Y0wM72ay/VabXeM78LCURuH5ddOSE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643649; c=relaxed/simple;
	bh=AMxmjZ0JJMyuWIJbXGv/0gigEXN79Nbqmvzf7orMYUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OfQZ2N01EOLkA+g6plOPsrr/iBq16dVMvE4MY5qzh/56iB82IHZZm9r6o36GQjxWmQpS0NBy6Ie2/g60XqS1xBKWE9YyA3v7tmX3s4ac+lsthBsvf7F8c0xiQPsrbdYWajIdWBrSLf3TEL+agD1b75l+fH5GBqN+nX8h2sV8tco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GQeWcJ7z; arc=none smtp.client-ip=95.215.58.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GQeWcJ7z"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AMxmjZ0JJMyuWIJbXGv/0gigEXN79Nbqmvzf7orMYUk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787643645; v=1; x=1788248445;
 b=GQeWcJ7zwb+ZeFrgZMU3Im0eIP6p/LrSTaH2/Z6c+UkTxkCcrKsQUNubDsrR8PzvIvfOXdMd
 4VLWjB4kA9muG11v6cmQ2xj/4Av5cVv7VUJGLgn9T89gbMaKx0iGlLew/dGY56thBV2qogXhyd0
 BiRI1UPp0HRLRzdGWv8TyFU4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f49.google.com (209.85.167.49)
	by smtp.migadu.com with ESMTPS id 85a4997ad05521aa;
	Tue, 25 Aug 2026 07:40:45 +0000
X-Mizu-Trace-ID: 85a4997ad05521aa
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3667e87.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 00:40:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrjnFzr6qTEF7BaZpTRrfAmRRf9qKMDy4SFTNiGMvKtPjgtSU8wTQo0iS5jCI4kNdhbf9rvwVM=@lists.linux.dev
X-Gm-Message-State: AFuF++kEcVjP5tC72rUBo0RjKt9SisZ8qoLhRfbCuFpO6d+2gf2RKDFz
	OmdJsvxfaGrDSsvxM+HvchJYh+wf5LdxcYB0H7562qeU4YIjSWqYBq7Na3IiP7+7UGB6pnbu7Xt
	pbLCHesXXgRD4MN52wTquDxuzI1zc0SnThMCb9fbd
X-Received: by 2002:a05:6512:3d8a:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b49de860a1mr48950e87.5.1787643640199; Tue, 25 Aug 2026
 00:40:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com> <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
 <aoxzjag7xr_emuvX@google.com> <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
 <ao1CspwFUHyhj0dE@google.com>
In-Reply-To: <ao1CspwFUHyhj0dE@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 08:40:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz3Fua-vSezqu3ennb1bZpUjCopE0Ud8N3ssFUrRGNZ-A@mail.gmail.com>
X-Gm-Features: AcwNN1XR0Ts6IcRX1i_REvmjYK54tavPxfSvDfmqMn9S4xm5Sn-f6fGyHQGFKMo
Message-ID: <CA+EHjTz3Fua-vSezqu3ennb1bZpUjCopE0Ud8N3ssFUrRGNZ-A@mail.gmail.com>
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Aug 2026 at 08:22, Vincent Donnefort <vdonnefort@google.com> wrote:
...
> > > > Nothing marks the pages a top-up just put in allocator->mc as spoken
> > > > for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
> > > > so a shrink with target 1 hands back the lot. Land that between a
> > > > top-up and the retry it was for, and the retry asks again, and
> > > > pkvm_call_hyp_req() goes round.
> > >
> > > Sorry, I am not sure I follow here.
> > >
> > > IIRC, the shrinker will only reclaim half of what is available. So the pressure
> > > should be proportional to what is available and limit races with topup!
> >
> > It's the ordering, not the amount.
>
> Do you think we should first try to reclaim from the mapped pages before
> draining the allocator->mc?
>
> Mapped pages are more valuable hence why I have started with allocator->mc.
>
> But, it is true it might make sense. It is unlikely to have pages left unused
> into that mc. If that mc has been topped-up that's because it is about to be
> allocated from...

I think that would work, as long as the ULONG_MAX drain at the tail of
hyp_allocator_reclaim() is bounded too. The memcache is LIFO, so the
pages hyp_allocator_unmap() stages sit on top of the top-up ones, and
draining just what the chunk loop reclaimed leaves the rest alone.

It would still fall through to the top-up pages once the chunks run
out, which is where your last point comes in. hyp_allocator_map() only
raises a request when it finds the mc empty, so pages sitting in there
are ones a top-up just put there for a retry. Could the reclaim leave
them alone altogether, and drop the mc.nr_pages term v4 added to
hyp_allocator_reclaimable(), which is what advertises them to the
shrinker?

> >
> > topup and its retry are separate hypercalls, lock dropped between
> > them, so a shrink on another CPU can slip in, right? .
> > hyp_allocator_reclaim() drains allocator->mc, where the topup pages
> > sit, before any chunk, so half still comes out of them first: a target
> > of 1 fails the retry.
>
> I do not see where a target == 1 fails.

It's the retry that fails, not the reclaim. With target == 1,
hyp_allocator_drain_memcache() pops one page and target is done, so
the chunk loop never runs. But the top-up was sized to the exact
shortfall, so the retry now runs the mc dry one page early, sets
topup_needed = 1, returns -ENOMEM again, and pkvm_call_hyp_req() goes
round for another top-up.

Nothing errors out, it just doesn't converge for as long as the
shrinker keeps pace.

Keep in mind, I am not as familiar with this code as you are. So I
might be completely off here :)

Cheers,
/fuad

> >
> > >
> > > However now looking at it. I wonder if I don't want to ratelimit here the number
> > > of pages reclaimed in one go to limit the time spent at EL2. Especially we do
> > > all that with the allocator lock taken...
> >
> > Ratelimiting would cap the time under the lock, but it wouldn't stop a
> > concurrent shrink from taking the topup pages, would it?
>
> Yes, my only intent is to avoid blocking at EL2 for too long.
>
> --
> Vincent
>
> >
> > Cheers,
> > /fuad
> >
> >
> > >
>
> [...]

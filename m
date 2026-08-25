Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C963DDAF4
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646025; cv=none; b=UdURa/FWpsxrWqOnaR89PuuX09feGIuhhii93wYYgO8h1hn2zQ6Pq+/uBQOILp0TbjBCb/6VsganHm6vl+M2e+4blltKx771fHQSTVyFSAeq+DGabQHGE1kDNGZXnaDr/dCd+hewdooJ0GK7OZ0X/u/NuOaCr3z+jp4wkykgJYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646025; c=relaxed/simple;
	bh=PCxjARyUOywlxJav+2bqyRMhgPnP4himW5Fa7+YHPWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehg82CsLb4nQ0Eo7rFKgNuxotWe+0tYDNixVo+tUwE4gNvVawz1YENV+KRlOgEZA+gJgg8U1skycYzkC22M2AmFdEt5m+2EZBe0O5V7zZSNZ21HTMaduIrwuD9DUq/40cfGhBCYhO2ARsWxwO5ipyThwku0wE7pIoBvI8WFIkco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEigIVVw; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEigIVVw"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so40526955e9.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 01:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787646021; x=1788250821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jBT/Ei0w7i+5f+yzzveDHn/UEUbkZyWiKFpbaa3Ox/g=;
        b=HEigIVVwht9Yj3XWmZIiHuczfNEAzBWrXr3t2x695Oow3mljRTeWUQXWWIVoINqrXz
         tiTCNTw3p9HQmQjb+q8vqu8C9b2DtPzcXNqo9HVjKwDOmuEwWyoRAsVqv7fiLnZwLW/y
         tAruD45HMRYzW/+mRW7Vj/k9nUlAJS2FakGLbr7Drp81atCluiea0801MNy5aoq+YuF8
         WWO/SwrQZ5LdBREudGMYFs4Fruku6ipCUNM6yy6RZJuvZzJ+Bh8TABwrRCHNhIer69QK
         l4qOEwKl9BAnxuU2brnczasN2aeMm1Kjt641CXyBscK9EN2sGYlr4ku2wqMszFXpD9mp
         4HYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787646021; x=1788250821;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jBT/Ei0w7i+5f+yzzveDHn/UEUbkZyWiKFpbaa3Ox/g=;
        b=VNAs5RoKDCf1ydqqyAiQsT9h2mWn3NEmCZ8Yr4Lq2iP1Zi7Q0UMFBEHu5/mQ0adB8Q
         DhCbIRIbB88j3A3vlRc76tcFSMd1CZHOo33IAzsabpESmT2z0gTYYJ0Zy8NEQJW45JD+
         xor4LoBIHm3lDmD4KpeszOEt1Daewwm8IL87kU83o1Dj0vwbAwR/3ICUcDkDyPMgNSN4
         DEquIXL/3CU0bDYO+aVCBGm+JGEx4Ofaoks5T+2zpaFAKfNgJK0k8nZ5bNdsGZF1weXK
         tApklC/sTBgjrdjxpZI7gEm/qKhyPMmfpjrrPMq/7zooMOJ9dLq029w8QgChguKvVhli
         7mPg==
X-Forwarded-Encrypted: i=1; AHgh+Rqspw10biJP603zf2QcuDoiRAM4B5tAsMozo5mcERcaGjCXmRX7SFE8soNTwIB34pr0Rf2gtdk=@lists.linux.dev
X-Gm-Message-State: AFuF++l4G9alDCHXTALxqBaN15PuYAyZa69oht/y8It0RZV3Bg5FCZZA
	3ZxIXAmZOXjgykTn+qoYymarwMuAKm6dc4MRdNBy7eS2lHgMJQsRCWpuLLgIfQDWWg==
X-Gm-Gg: AR+sD13swYlP79tKv5mTatcI06DGY6B4V93gZ1JeHuyHa/UyVqnc7D5ubN//MS277JD
	GByMdUVJQgB2VPTUfgv9zk7xpGN863+1rsKm/z1LajFIVoGoQtXmhHvAA77LkTXIca7ozc7InKg
	JqcpJjGGg8o5PZuZqFViUnutBobP5IcTjl/+2xAXzk0zA/3KNRHC0gufxeai9IDkP3UnRxbaGMc
	qVaCS8c5S+lg2mMYNeKnYaa29pr+veR/DUkWo+HpyD0zR7G81NgAzBPsKs2DDa8/zN24tW+1EtI
	ZJEPIK9sOHAkud11mYADMSRdVQP+TommXTktGZc+7OBG0JVZY/D1ArfgN/RW8JoiOa1QbjkUiDX
	qjRx6h9zwkqCFXMZY6XApyyVCPzgfqL76nEeiICammfESUBPgh1Juz+2OlO2ecEXPMRkoxnM/IL
	WPlTvrkZszTYZFidlXQZx4whZ5sGN8XQ4TAORyIenLCd9RRUwaIJXrT7YIcr7SeVaRE6jS+woom
	hukk9FzNLhfFTSAQnOhYremi/67kbc5xR/KC6iEoms=
X-Received: by 2002:a05:600c:1552:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-499c19ad953mr287526895e9.3.1787646019982;
        Tue, 25 Aug 2026 01:20:19 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499d65c326esm18696375e9.10.2026.08.25.01.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 01:20:18 -0700 (PDT)
Date: Tue, 25 Aug 2026 09:20:15 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
Message-ID: <ao1QPyLXVGuH1XLn@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com>
 <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
 <aoxzjag7xr_emuvX@google.com>
 <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
 <ao1CspwFUHyhj0dE@google.com>
 <CA+EHjTz3Fua-vSezqu3ennb1bZpUjCopE0Ud8N3ssFUrRGNZ-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz3Fua-vSezqu3ennb1bZpUjCopE0Ud8N3ssFUrRGNZ-A@mail.gmail.com>

On Tue, Aug 25, 2026 at 08:40:03AM +0100, Fuad Tabba wrote:
> On Tue, 25 Aug 2026 at 08:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> ...
> > > > > Nothing marks the pages a top-up just put in allocator->mc as spoken
> > > > > for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
> > > > > so a shrink with target 1 hands back the lot. Land that between a
> > > > > top-up and the retry it was for, and the retry asks again, and
> > > > > pkvm_call_hyp_req() goes round.
> > > >
> > > > Sorry, I am not sure I follow here.
> > > >
> > > > IIRC, the shrinker will only reclaim half of what is available. So the pressure
> > > > should be proportional to what is available and limit races with topup!
> > >
> > > It's the ordering, not the amount.
> >
> > Do you think we should first try to reclaim from the mapped pages before
> > draining the allocator->mc?
> >
> > Mapped pages are more valuable hence why I have started with allocator->mc.
> >
> > But, it is true it might make sense. It is unlikely to have pages left unused
> > into that mc. If that mc has been topped-up that's because it is about to be
> > allocated from...
> 
> I think that would work, as long as the ULONG_MAX drain at the tail of
> hyp_allocator_reclaim() is bounded too. The memcache is LIFO, so the
> pages hyp_allocator_unmap() stages sit on top of the top-up ones, and
> draining just what the chunk loop reclaimed leaves the rest alone.
> 
> It would still fall through to the top-up pages once the chunks run
> out, which is where your last point comes in. hyp_allocator_map() only
> raises a request when it finds the mc empty, so pages sitting in there
> are ones a top-up just put there for a retry. Could the reclaim leave
> them alone altogether, and drop the mc.nr_pages term v4 added to
> hyp_allocator_reclaimable(), which is what advertises them to the
> shrinker?

There's nothing that prevents a users from topping-up the allocator mc... but to
never actually use the memory. That's why I think it is better to drain it.

> 
> > >
> > > topup and its retry are separate hypercalls, lock dropped between
> > > them, so a shrink on another CPU can slip in, right? .
> > > hyp_allocator_reclaim() drains allocator->mc, where the topup pages
> > > sit, before any chunk, so half still comes out of them first: a target
> > > of 1 fails the retry.
> >
> > I do not see where a target == 1 fails.
> 
> It's the retry that fails, not the reclaim. With target == 1,
> hyp_allocator_drain_memcache() pops one page and target is done, so
> the chunk loop never runs. But the top-up was sized to the exact
> shortfall, so the retry now runs the mc dry one page early, sets
> topup_needed = 1, returns -ENOMEM again, and pkvm_call_hyp_req() goes
> round for another top-up.
> 
> Nothing errors out, it just doesn't converge for as long as the
> shrinker keeps pace.
> 
> Keep in mind, I am not as familiar with this code as you are. So I
> might be completely off here :)

Ha yes, a concurrent topup with shrinking wouldn't cooperate well and I am not
sure how better we can do. But note the shrinker always "scans" half of the
reclaimable memory. So it is unlikely a user needs to top it up during
shrinking: if we reclaim hyp allocator memory that's because there's plenty
unused!

But I am happy to start with the memory mapped into the allocator and then if
necessary finish with the allocator->mc: if there are memory in allocator->mc
that's probably because a topup is pending.

-- 
Vincent

> 
> Cheers,
> /fuad
> 
> > >
> > > >
> > > > However now looking at it. I wonder if I don't want to ratelimit here the number
> > > > of pages reclaimed in one go to limit the time spent at EL2. Especially we do
> > > > all that with the allocator lock taken...
> > >
> > > Ratelimiting would cap the time under the lock, but it wouldn't stop a
> > > concurrent shrink from taking the topup pages, would it?
> >
> > Yes, my only intent is to avoid blocking at EL2 for too long.
> >
> > --
> > Vincent
> >
> > >
> > > Cheers,
> > > /fuad
> > >
> > >
> > > >
> >
> > [...]

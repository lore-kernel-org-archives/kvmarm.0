Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB963E51EF
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647135; cv=none; b=Jz9H/b0itckPTTS1BV2rGcs+eFnK8QsAapQQN04/WAL/heMK77zulLAAuTTvmf2iP/2prOQCtUQcRRHX59xsCSZ0so6Lyme5yeIIuksWj5G67ZOXG6tmO/S/w5RHS9k69+Hq/Bzdguz+zf0N09ei4m0C2yHX/8xYh5xq/uWcoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647135; c=relaxed/simple;
	bh=ZkEyccE1SP4/O8FRxuMTjwZTWvb3WH5wHagpAHgazS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0m29c3+d8ybl6SWRaJ6iuvPR+GKINoneynUGj2XJ8o3kvz71WleKdH+2UnUTmaukg6H/fsJcVabWsb9Qkf9aaLkfpccVZdw1ZcoQGCcMTshbUt9v+x/zhFWgz1upNvZ8l6Ry+dS5Vj2rAaQ6oqCBgczgvazI2Y6L530x3U1xIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MmsGmhnr; arc=none smtp.client-ip=95.215.58.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MmsGmhnr"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZkEyccE1SP4/O8FRxuMTjwZTWvb3WH5wHagpAHgazS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787647130; v=1; x=1788251930;
 b=MmsGmhnri+5vlJsN04OHRZxwt/rImBtKjM+7pU9Q+4j7ozrepuPyyoy9PCm8gF5mDAtwK1Np
 cvtD9hVydAiohxMCxf4NeTyvgOlMaG0QdwC4zy2JvxLM1aFYZx3ZsoTqvlENToIncYfuVAJMhTF
 HhkrOkArfzwRdrTu6bi6bIN8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f46.google.com (209.85.167.46)
	by smtp.migadu.com with ESMTPS id 819e7b110bb3ff4f;
	Tue, 25 Aug 2026 08:38:50 +0000
X-Mizu-Trace-ID: 819e7b110bb3ff4f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so4589e87.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 01:38:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoIgqfCj4S1U4IMBDoBWpGd3+/mQJoXGQmp07/gu1Q1uQBFMsmZvB1LRUZHmN2ulpIoyYfwgrs=@lists.linux.dev
X-Gm-Message-State: AFuF++mfTL+B4C4De57w3Whq/Bj+6PtRqF6qO3pBiftMIr6Z89R1spHX
	w4a2Llgf7S3DMilUS65ge+yVzYORi7cRzKNiJQGe8KU38PZkjq0JxdkcFA79BQpvYA0n3mWwIXO
	ldXh+d4eO2uyzpTZi1sbuQMTJdPoilRuytn7C96DY
X-Received: by 2002:a05:6512:3d8a:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b49de33a82mr59200e87.2.1787647125805; Tue, 25 Aug 2026
 01:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com> <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
 <aoxzjag7xr_emuvX@google.com> <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
 <ao1CspwFUHyhj0dE@google.com> <CA+EHjTz3Fua-vSezqu3ennb1bZpUjCopE0Ud8N3ssFUrRGNZ-A@mail.gmail.com>
 <ao1QPyLXVGuH1XLn@google.com>
In-Reply-To: <ao1QPyLXVGuH1XLn@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 09:38:09 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyLPzuV7rfm4f6MOBDB-rCg=s413yiJUmb2o8pS6u9aYg@mail.gmail.com>
X-Gm-Features: AcwNN1XQLeBQ7u9EOQoGMHte78AwqW0cwF4cJoFF4AYKd0NiyQxRZAlxD9ORrkU
Message-ID: <CA+EHjTyLPzuV7rfm4f6MOBDB-rCg=s413yiJUmb2o8pS6u9aYg@mail.gmail.com>
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Aug 2026 at 09:20, Vincent Donnefort <vdonnefort@google.com> wrote:
...
> > It would still fall through to the top-up pages once the chunks run
> > out, which is where your last point comes in. hyp_allocator_map() only
> > raises a request when it finds the mc empty, so pages sitting in there
> > are ones a top-up just put there for a retry. Could the reclaim leave
> > them alone altogether, and drop the mc.nr_pages term v4 added to
> > hyp_allocator_reclaimable(), which is what advertises them to the
> > shrinker?
>
> There's nothing that prevents a users from topping-up the allocator mc... but to
> never actually use the memory. That's why I think it is better to drain it.

Agreed, that settles it.

...

> > It's the retry that fails, not the reclaim. With target == 1,
> > hyp_allocator_drain_memcache() pops one page and target is done, so
> > the chunk loop never runs. But the top-up was sized to the exact
> > shortfall, so the retry now runs the mc dry one page early, sets
> > topup_needed = 1, returns -ENOMEM again, and pkvm_call_hyp_req() goes
> > round for another top-up.
> >
> > Nothing errors out, it just doesn't converge for as long as the
> > shrinker keeps pace.
> >
> > Keep in mind, I am not as familiar with this code as you are. So I
> > might be completely off here :)
>
> Ha yes, a concurrent topup with shrinking wouldn't cooperate well and I am not
> sure how better we can do. But note the shrinker always "scans" half of the
> reclaimable memory. So it is unlikely a user needs to top it up during
> shrinking: if we reclaim hyp allocator memory that's because there's plenty
> unused!
>
> But I am happy to start with the memory mapped into the allocator and then if
> necessary finish with the allocator->mc: if there are memory in allocator->mc
> that's probably because a topup is pending.

Sounds good. Would the tail ULONG_MAX drain need bounding too, so it
doesn't empty the mc regardless?

Thanks!
/fuad

>
> --
> Vincent
>
> >
> > Cheers,
> > /fuad
> >
> > > >
> > > > >
> > > > > However now looking at it. I wonder if I don't want to ratelimit here the number
> > > > > of pages reclaimed in one go to limit the time spent at EL2. Especially we do
> > > > > all that with the allocator lock taken...
> > > >
> > > > Ratelimiting would cap the time under the lock, but it wouldn't stop a
> > > > concurrent shrink from taking the topup pages, would it?
> > >
> > > Yes, my only intent is to avoid blocking at EL2 for too long.
> > >
> > > --
> > > Vincent
> > >
> > > >
> > > > Cheers,
> > > > /fuad
> > > >
> > > >
> > > > >
> > >
> > > [...]

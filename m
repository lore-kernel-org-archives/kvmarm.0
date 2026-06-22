Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6FD398915
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 09:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782120534; cv=none; b=e2L+KxuCgbXWNzGCV7/jNDpHs26OPfP1Op1/7ZdOtsPs2mVe9NqghSqoNd2e7yQhScP0ebbM3JvKlLNHOafgb5AYS4ZseqzA6XVLwTNI+s2QHTGFp38UfjwprEq22RnX9UX8Ri6aHkz0SQpDG/VU5s7wmOYf/rligJz8EFPs0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782120534; c=relaxed/simple;
	bh=7LEgMI4CoHOl8BmYIolkgw6bU3M5d39i+qkLjhPfMtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TwvX6o5UinfPVwvOZURKnpL4y6NgCZSncE9cpCbKCIjsGmicra1icaNUoCCxqazK7/WrnJ2FvXfuJBSUJ9qQ0OliwFXG/PnS96jY4YTrhAZtjR9jY21itgtFMwDCk7Eo04iLeV57w+wN6Vg9nudAdRPPEJJZhMnXSXcHyQPhAhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B9/zX2Sa; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B9/zX2Sa"
X-Forwarded-Encrypted: i=1; AFNElJ+ILUpJEcQtXkw7YeRVmCjDJHADH5mMfoxLhf2HvL4Kpritf55AP3g5HC+WQ42cMp49mKlZn20=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782120530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXXrkGGgWhMIxTmpAsu5SnOrXuzavCRXBgQ6EasiET8=;
	b=B9/zX2SaWr/wJaKytl7c3qKDaE7MYbhJ6M6PaJGt4H6DWQ1FgohB2aOB0lLe4uMUqWLS2m
	Q4CJojhX2sislVsxzlhOdml8tL2aEkv/HpKnOeeibljWlK2+GmixKPNKRhiP+SlxGqX7Jn
	HQRS3rFQt+MtcO5SQo20QgHykZZvaso=
X-Gm-Message-State: AOJu0Yw4NNWdZLvulfjx7ohyu9of7ZmIqKQFPJnc+l0vP6jncBFrBXHg
	W3YPneWIcAlze0fuXbeGaR5ouJ1XyMnSKkvHgolk6uE1fqAv4RhprVcHw4I2QTo2GDG06NwP+pL
	b2eq7xDkPiRUDbKofPA8CBhXZ7Qllq52EB2rmLogR
X-Received: by 2002:a05:622a:11c5:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-519e891bc2bmr19956431cf.9.1782120518257; Mon, 22 Jun 2026
 02:28:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CA+EHjTzdCf2waY_Qc+GWzA-MuKG=_XjQ4Hzn3HJ6Yi0NfB_CzQ@mail.gmail.com>
 <ajVyJa-mZmYGzt6o@kernel.org> <867bnsrw8p.wl-maz@kernel.org>
In-Reply-To: <867bnsrw8p.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 22 Jun 2026 10:28:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTywWT=76DGzwk_U+LOYti9mCQkSchfMhmWSJ7GnwLfVmQ@mail.gmail.com>
X-Gm-Features: AVVi8CcsrRulZuehrngXQzNj8CDiaAyyd5kQgVa9vm6W5H90fk0n_xb0uv_APbw
Message-ID: <CA+EHjTywWT=76DGzwk_U+LOYti9mCQkSchfMhmWSJ7GnwLfVmQ@mail.gmail.com>
Subject: Re: Sashiko review emails to the list
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, KVMARM <kvmarm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Thanks for your feedback.

On Sun, 21 Jun 2026 at 12:03, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 19 Jun 2026 17:45:25 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> >
> > Hey,
> >
> > On Fri, Jun 19, 2026 at 03:19:05PM +0100, Fuad Tabba wrote:
> > > Hi folks,
> > >
> > > I really like Sashiko and find it very useful. It's flagged real bugs
> > > in series I and others have posted to the list (e.g. [1][2][3]), and I
> > > run it locally before sending, which has saved me a few respins.
> > >
> > > That said, it's been posting a lot lately, so it seemed worth asking
> > > how the review emails to the list are working out, and whether we
> > > should change anything.
> >
> > So this is entirely my fault since I added the email configuration for
> > the kvmarm list. Sashiko has been finding some truly nasty bugs, posting
> > on-list is the easiest way to get attention from the right folks to get
> > things fixed.
>
> I don't mind this. Having Sashiko to tell me that something is off is
> great, but we collectively need to learn how to treat the feedback.
>
> > With that being said, the signal to noise ratio hasn't been ideal.
>
> There are a few things that did it for me:
>
> - hallucinations that are close enough to reality that you spend
>   significant amount of time debunking it. Being creative about
>   specifications is particularly annoying.
>
> - the whole "I found a preexisting issue" is great, but leads to an
>   avalanche of patches that themselves trigger cross-reporting
>   (patch fixing issue A triggers a report for issue B, and the
>   reciprocal happens as well). This is overwhelming and we need to
>   better manage this.
>
> - Related to the above, I see a flurry of activity following a review
>   from Sashiko, resulting in unrelated patches that distract from the
>   issue at hand. I reckon that *we* could do a better job keeping the
>   initial patch series focused, and once that is solved, work on the
>   tangential stuff that Sashiko may have reported. At the moment, it's
>   hard to see the wood for the tree.
>
> - We also often end-up with point fixes match the reported issue, but
>   that don't address more general issues. That's even more noise.
>
> My conclusion is that while Shashiko reviews can often be flawed, most
> of the problems are with the way we deal with the reports. No, I don't
> have a magic solution, but that's something to think about.
>
> >
> > > These fixes will take a while to land, so the question is what to do
> > > meanwhile. Some options, and surely others:
> > >
> > >   - Leave it as-is while the fixes propagate.
> > >   - Stop the emails but keep the reviews on sashiko.dev, so people can
> > > look rather than have them pushed.
> > >   - Disable the emails until the noise is down to a reasonable level,
> > > then re-enable.
> >
> > This sounds like the right approach. I'd like to re-enable emails once
> > we're happy with the quality of reviews.
>
> I'd like to see how the fixes improve the situation, and re-evaluate
> in a couple of weeks.

The PR I sent to review-prompts should significantly reduce ARM ARM
hallucinations, based on local testing. It will take a while to
percolate to review-prompts then to Sashiko though.

If you see any recurring arm64 or KVM issues, please let me know. I've
spent many hours and tokens setting up the subsystem prompts for these
and fixing them later, so I have the evals and benchmarks ready to go.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

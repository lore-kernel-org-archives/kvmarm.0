Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D607D2F7EE1
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 06:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616988; cv=none; b=XuKaUEodZRtBoau6xsWgXOFprNwUoniTiYSNwEgp6PGNNz7EyGK4H2kt+oGKHnUGjR6wIvf3g7AY9sYy9hegUlPm3sf8qPGOkgDSo7tT/iIr1In5i7ZLlknMutHachLwb3Pn4I/sJ/xZsgW5uTkFHvJEt0AsyVP3iyetivzEaAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616988; c=relaxed/simple;
	bh=sC0S1N2yFqjRIN0ocmkrWoUWAUSI5cXd8cW3SC/0B1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ne7imGiL2wTct3JNjD53nlgdHJViF/cQEl1wK2VM/uvLAK9bby+ibFzstVkb6b3JUs1kbote/Nyfaj/NYBsbyn1qmX/ceZU3VU02Kl5K+Kv1ddj2aQUTIgMxrwCo4MnE+FaisMS14rQIenXk0/7LD328Jtq44NVDeQGe4O0w5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R6gzQFJI; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R6gzQFJI"
X-Forwarded-Encrypted: i=1; AHgh+RpDOwlHTBVm3D3fCN46d+s3cL2Qi16bUouAyysxwqyR4YcgZee/C7YtGQ6vrJlokKyey3A1Xdw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784616982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dng0D5LmCvrsd1dFzlRFdI/AiQQJYWNLnRmiefMWl50=;
	b=R6gzQFJIPZbStl8e4gTuj8wv779ZPhq8CrPEyvbUr4Ot89etMh81BKq+6cSgcFDXBrLScr
	xb/MUahVkEeu/VInRxY5HoOYyxa71bD/7MTys1nQrvmYnbw4fiiO6SqxzaVzAvVZME/dKP
	5jEbN/y/YEO3piMHKl6img2ihgb7DM8=
X-Gm-Message-State: AOJu0YyB2FlW1Yj9Ejz2P8AfoHIiKUzOO8l4kVfAEk0Q5pTM7oL+VOI5
	2y++AtadNCKKCwDC2QnbQ+JaVu6gt2P7D+L64a4I/I096zdRKjMiMO0Gyxq7UpgyKhs2kainI0N
	l9KxoLqWJcdq+BRxrGNkzulN5BGfcpv1vRpnTxIo5
X-Received: by 2002:a05:622a:1aa5:b0:51c:7a8b:c3fe with SMTP id
 d75a77b69052e-526029b57ffmr9582531cf.23.1784616969557; Mon, 20 Jul 2026
 23:56:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715105100.3178255-1-vdonnefort@google.com>
 <CA+EHjTyVRn8BR7bLBo5m_k9m1VNv95y4h+WTJvz86FTf+=XeFg@mail.gmail.com> <861pcwg7gz.wl-maz@kernel.org>
In-Reply-To: <861pcwg7gz.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 07:55:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx37wqMhtxEfLA8THzzN12gdjXePghsp3np0cF=-yzOgA@mail.gmail.com>
X-Gm-Features: AUfX_my9yqYDGBjg5j0aB1I0HAfJDwnSN1DrdFI-vBsU6uoCyf_tm7w3OsT4aYA
Message-ID: <CA+EHjTx37wqMhtxEfLA8THzzN12gdjXePghsp3np0cF=-yzOgA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Fix hyp_trace clock disabling
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 21 Jul 2026 at 07:52, 'Marc Zyngier' via kernel-team
<kernel-team@android.com> wrote:
>
> On Mon, 20 Jul 2026 20:45:00 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > Hi Vincent,
> >
> > On Wed, 15 Jul 2026 at 11:51, Vincent Donnefort <vdonnefort@google.com> wrote:
> > >
> > > Fix the disable path in hyp_trace_clock_enable(), which fell through to
> > > re-initialize and reschedule the clock after cancelling the work. Return
> > > early instead.
> > >
> > > While at it, cleanup hyp_trace_clock::lock which is unused and
> > > hyp_trace_clock::running which is redundant: the trace_remote framework
> > > already serializes calls to the callback enable_tracing.
> >
> > Although the cleanup and the fix are to the same commit, could this be
> > split into the fix and the lock/running cleanup as a separate patch?
> > Since b22888917fa41 is already in a released kernel, the fix will
> > likely go to stable, and it'd be nice to keep that backport to just
> > the behavioural change.
>
> Not sure I get what you mean here. From what I can see, this patch
> fully applies to b22888917fa41. Given that this is the third version
> for something that trivial (two from Vincent, one from you), can we
> please agree on *something* quickly?

No strong preference from my side. The fix and the cleanup are
correct, I just thought combining them in one commit might be less
than ideal. If that's not an issue:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

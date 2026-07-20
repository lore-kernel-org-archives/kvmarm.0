Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837FD449983
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784570394; cv=none; b=NAqyUa3fIAlBztrbCecIcGQXgbps6mtnkEXeaePl0AkaJsRcDPLbbwZwr2TSqsIX2wofxNtLdGpOMWG7i5Lmvcn/K7tChkQ9o1okMlwCGyjxerodksaD3VhUoXYOeh2uPIFZxiSyecw3Ls5olG58Z3IO/58BXkhhCjp/nEHA9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784570394; c=relaxed/simple;
	bh=eJV/QKPRl0nQ58CX6raU94v8GT2LbNVT4nHU4Cu9Qxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajcXjdzlCp7dB44TErAZuqBYw4WBVjxVmbsTxKMa6usd8JBBEhPNAcjyIbQeBvd4F4/5CJu6bzBW+T3214QYeeZkjPBxJn378uJSCEQ2s6HxNnA8LrRMX7+Ep6rGsSAuFEwLSGpv1beLbycCYafd2kDxVRJ4xR9AXME+HOTnVyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BuqRmuxX; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BuqRmuxX"
X-Forwarded-Encrypted: i=1; AHgh+Rr0Hh1xDz47bnpTX7vLyQRToHKAnOEDMDNF+Z96wWFNgzDvSdGU3FjJwR0NbqWwiS4+bCvCtjQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784570386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSjjs1T/fGlvzcUytES43w/zoIxeAWRYz4e8PGpL2fc=;
	b=BuqRmuxXl+mvltlRSnUDam+gsIEEa9aNoqBHOws9Sxnf1FUsCCXMLR5eX+0dTiHcR75j6K
	AVAWgd7Rh3xnTydhqV929I/dPssn7Y/iG+VEbRvWGM8rNEbD39WKs+lNlRyZaXZuJSox/W
	3Klowie+srl8IWZusaZG7fvKaNpGvzc=
X-Gm-Message-State: AOJu0YwhFGKuxlAMybAtRlgYOvFXz3qRU6+HjaAem2z7YUpUncoUWunQ
	YXgqTgly4sBr4A7UfsleB6ObBMCTZUdpHNwvUzVPzk0nsb5RQtfq3ToOA7GcVCgCoR74Xbh/vVs
	ag8asXE7VX3NYeYvN9OnzloSzcK63rnedL7ZkIY/I
X-Received: by 2002:a05:622a:2b47:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-525fcfa53f6mr4668601cf.0.1784570378553; Mon, 20 Jul 2026
 10:59:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720161343.1367007-10-fuad.tabba@linux.dev> <20260720172923.E4F161F000E9@smtp.kernel.org>
In-Reply-To: <20260720172923.E4F161F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 18:59:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyOWhWRo=W0dp5qdBOLnaQMB9WW0Y8MOYDnJR_qHCs3AA@mail.gmail.com>
X-Gm-Features: AUfX_mwcTtHzH5EdgVipRg09TkTHSMSuxIF002h3-f_9PAq_fJ2tY675UvpwgRI
Message-ID: <CA+EHjTyOWhWRo=W0dp5qdBOLnaQMB9WW0Y8MOYDnJR_qHCs3AA@mail.gmail.com>
Subject: Re: [PATCH v1 09/11] KVM: arm64: Type-check hypercall arguments at
 the caller
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 18:29, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Disabling the hypervisor trace clock fails to stop the backgroun=
d clock synchronization worker.
> --
>
> --- Patch [9]: [PATCH v1 09/11] KVM: arm64: Type-check hypercall argument=
s at the caller ---
> commit 171ebbffa4142a86e7fab981732cd83df6923869
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Type-check hypercall arguments at the caller
>
> This commit replaces the untyped kvm_call_hyp_nvhe macro with typed stubs
> generated for each declared hypercall. This ensures that hypercall argume=
nts
> are checked for correct number and types at compile time.
>
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2411b4c32932c..7fe0e8feb7d7c 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
>
> [ ... ]
>
> [Severity: High]
> This is a pre-existing issue, but I noticed a logic error in this same fi=
le
> in hyp_trace_clock_enable() when tracing is disabled:
>
> arch/arm64/kvm/hyp_trace.c:hyp_trace_clock_enable() {
> ...
>         if (!enable) {
>                 cancel_delayed_work_sync(&hyp_clock->work);
>                 hyp_clock->running =3D false;
>         }
> ...
>
> Does this accidentally restart the background clock synchronization worke=
r
> instead of stopping it?

Yes. I will send a separate patch to fix this, as you noted, it's not
introduced by this series.


/fuad

>
> Without a return statement inside the if (!enable) block, execution appea=
rs
> to continue down the function. This would cause the worker to be inadvert=
ently
> re-initialized and restarted, leaving the background task running and mak=
ing
> periodic __tracing_update_clock hypercalls indefinitely after tracing has
> been disabled.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.14=
01272-1-fuad.tabba@linux.dev?part=3D9

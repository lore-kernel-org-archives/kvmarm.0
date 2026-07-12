Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0A2475CB
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 19:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783884659; cv=none; b=OLdn+VN0Vz0YnoEadyEtNG8NGSqxUiL6pclQZ3a8OaJEN7+1IgAfvg8a6+pl7jsZ38vjczNxOdXrgajspvZiOI3wLQ2p7ZguXAXnNDY7DqsF1IyzaXIHOkq5mDnnsKsl+ub7otnm7r5JuK4+GLaiGe/VkhLrMO4bfPaqi4p4Rxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783884659; c=relaxed/simple;
	bh=o+MnApJF0K/rBlhJ76yNJ3o104qnTxxEUWgkX+I5Mzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ediH1IYpdgPgQXGs5hWectKMHHPd9noXBk9YRpjybvvXUOKTC5sqhfYQIEIeZoySNXACo14ID6vbuOaxajINRcCjcw06qBhvJKe/4XxKBRio65WZtEc8nIaoIp98K8g2twv+8GJlelKBxZBV2thb0C+gWgs/xMTI1AjT5LZPyr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xIkLFgLY; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xIkLFgLY"
X-Forwarded-Encrypted: i=1; AHgh+Rpa9dWUj81H7waTJow7jr+P9uucY0FVlXj7ZfjbAlg0FsJKZNrHNQ78ppvGtQ9+dmcIR6QNEZ0=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783884654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ErBKgtp+mZ9BxO2ANkGEg2e2c554PPZZFYhSFk8hs4c=;
	b=xIkLFgLYP146zNgo3CShY6KwNSseM3jAZGig0ZA0LqIXsoyNGo3Erk1o+PXQWly75i2ClI
	3pJBpOqwQG0KvrsxEvf9iMb/t3uo1jajmYEWSPwWcwCCCXmedCG3ITL3ctCESIh/sXWKR0
	Iv76rn8vBRJ5Iyv1UlddIT2f6it1KLk=
X-Gm-Message-State: AOJu0YyFhCex5zzxVfsFNyUd0ltMIp5fiM6EpUF6Hkrb/lfUoLP1cfQQ
	mImONDJVF8lGYqJLs3iMCpSpKwCS8L9hMqz2yxGbpAoKCrZsnXHuX2JDqs/D/rWJa4ZYjf313Rm
	kFD3rE946+kX2tWg4BGnEdqb0fJdFodhxHVYcl1Lk
X-Received: by 2002:ac8:5a47:0:b0:51c:97f:83a9 with SMTP id
 d75a77b69052e-51cc046e6fbmr9964881cf.1.1783884639780; Sun, 12 Jul 2026
 12:30:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260712153835.2264905-1-smostafa@google.com> <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
In-Reply-To: <alPox2BDk4Il0s9t@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 12 Jul 2026 20:30:02 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
X-Gm-Features: AUfX_mxsRm47NFDH8jthhba-6RAh8a8HdvP8KKBSTLBL_9PSzFB7aArWc0wKLI4
Message-ID: <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Sun, 12 Jul 2026 at 20:19, Mostafa Saleh <smostafa@google.com> wrote:
>
> Hi Fuad,
>
> On Sun, Jul 12, 2026 at 05:19:22PM +0100, Fuad Tabba wrote:
> > Hi Mostafa,
> >
> > On Sun, 12 Jul 2026 at 16:38, Mostafa Saleh <smostafa@google.com> wrote=
:
> > >
> > > When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> > > defines a static inline stub for trace_clock().
> > >
> > > However, trace_clock() is already declared as an extern function in
> > > linux/trace_clock.h which is pulled in EL2 compilation.
> >
> > The rename itself looks correct and complete: all three sites (the
> > declarations and stubs in nvhe/clock.h, the definitions in clock.c,
> > and the two callers in trace.c) are updated, and no other reference to
> > the old names remains under arch/arm64/kvm.
> >
> > Two small things...
> >
> > >
> > > If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> > > is disabled (by including it manually in setup.c) it will cause:
> > > In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> > >
> > > ./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declar=
ation of =E2=80=98trace_clock=E2=80=99 follows non-static declaration
> > >
> > >    14 | static inline u64 trace_clock(void) { return 0; }
> > >
> > >       |                   ^~~~~~~~~~~
> > >
> > > on GCC and a linker error on LLVM (it seems to change the linkage to
> > > global)
> > >
> > > Although that is not a problem at the moment, as no other files
> > > include <nvhe/clock.h>. That does not seem to be the intent of
> > > this code and that will cause issues with more users as the SMMUv3
> > > driver.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > >
> > > --
> >
> > git am only treats a three-dash "---" line as the scissors; the "--"
> > here is two dashes, so mailinfo keeps everything above the diffstat.
> > Worth a "---" on the repost so the note stays out of the log.
> >
>
> ops, I will fix that.
>
>
> > > I did not add Fixes tag as this is currently dormant and not breaking
> > > anything.
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm=
/hyp/include/nvhe/clock.h
> > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > @@ -6,11 +6,11 @@
> > >  #include <asm/kvm_hyp.h>
> > >
> > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch=
_cyc);
> > > -u64 trace_clock(void);
> > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 e=
poch_cyc);
> > > +u64 hyp_trace_clock(void);
> >
> > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > already has a struct hyp_trace_clock and static helpers
> > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > of the same clock. No actual collision, so this is only a readability
> > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > things. Maybe you'd want to consider a different name, but naming is
> > hard :)
>
> Yes, that shouldn't be a problem,  I just added hyp_ prefix, but I
> am ok with any suggestions!

Didn't I say naming is hard? :) How about, el2_? Not really happy with
that either tbh... but can't think of a better one...

/fuad

>
> Thanks,
> Mostafa
>
> >
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> >
> > Test: builds fine with the different config enables.
> >
> > Cheers,
> > /fuad

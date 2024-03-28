Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC14200DE
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 10:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711621820; cv=none; b=tPwtGCJpABIoC7wMdvl7QexVatlFk+fdci4H3SB4+8xEoTCqVdUrOlcwvZnRHY/PssFCNKP651GvxcHTbvYqEY+O0ty/97uvpo4rmfLYYqI3ey7Mol5dDIc7z3hQq5bk3opdAipkmbeqyisBZvgVxYVpPitsDppE8j4W0i2xXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711621820; c=relaxed/simple;
	bh=IgHYWK2ExRPZDTN/hLBd6JLOwfML660stcDwa/LKV/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncTPDAnfldle3VCwrpVudwBxKCeclVxfxpuWwUKfAfIuMITXoJyQMWmkpeDyC0IPic5L432Vjz4Y9pNadYh6YM4k39T49NCz/HSCASb1p0GdLjjAeyKNNm54nYtwQ7fffIDdUMODzUouJ6eBQlaj17YzwW2Hdr/M1LpL7BE9EjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nDCsEmJ4; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nDCsEmJ4"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-563cb3ba9daso752392a12.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 03:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711621817; x=1712226617; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zm7UhGPLU4UMFzlv9xAHTMrvOq2hNK4t2z9KZhDSxt0=;
        b=nDCsEmJ4IUYTJQfphE8X6cKEWQZbgCjJAR/xH++DsNm0H8yUCCr439dQ13OTMHDQAP
         Ygcr01kvifmbp9TGomxpTwpAoswCqdHRXCzaXWRiXYedGgJg3Ei7YjejdKyKWI2wOppS
         gaAj04TUMl0Ld6PvpA+PMEaxGzfg8eME7enz8FPy3eRVu/0ZDa1C4jhfpDAMMjjcY07f
         OXPSrZGVZCqt6NrrqplOPjdHFBbSWNsWgQeBxnlu4nZtc49YRH1yG+SeJ520WOKUcaJi
         OWM+alzAoR9tJHR2xvHTAK+TtsTYxEdPWnaSeaSFUx+g6KmNPZ2BgXiWHqe/dekpFfZT
         VCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711621817; x=1712226617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zm7UhGPLU4UMFzlv9xAHTMrvOq2hNK4t2z9KZhDSxt0=;
        b=vJLsnAqgtkXoTyKU5WXPXmJ6zOk7dtLXqV+IzbD4lDbj2kZHXm3MkIKMbu5kIqkIIS
         D6g29wa0Pws0TIrSGnV5lAdsc1GSvyEqUIH8KiObOJVm3GJTQTURl0Y5oGFG2t+078Ms
         VT69SASXwEN3/nThLjsNlFAxn5LoKCxrdCgnJPAUzKWIsC1QEedBjnkD5ZUZlw7Ok2UZ
         gdrR6EQQqNtOdnLyg8/9F+VrTHFPj6KOooNPArstXQDNOJzXpbIHpAcqLfaD8x+R7YJw
         s9jGOsy7c1Ctb1+c23bPzoqBgok1wXs8/Qvxe05BMtMGWcy2LrrjPs3XuuUsy6r9fgS6
         QVLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmp2zyhQo/SCFtVGQf2hmbRll+EMrhTnBzbC3ItrsaEoZwOuYEVg8ncVo0Re4bdC4G4Y7CWP/Xxwm79ibMhouYP9JjhCyT
X-Gm-Message-State: AOJu0Yw8ZyHPVvcYbwbiibME34qNspPbV89b1inT2dUme5LFsm3f0l6X
	YIBSTx+yPXbOog+ckaTk87xHQGN2GP9/CuLtJRnOe7bS0TP0K/gveO0d3b96ng==
X-Google-Smtp-Source: AGHT+IHrzxVcayJwAymJeYjWNVkfBVqo8DMj23IPGaMRV9u8xUSwyjBPTm+iXUeqd1BagXZOXD7/pA==
X-Received: by 2002:a50:d503:0:b0:568:b95f:5398 with SMTP id u3-20020a50d503000000b00568b95f5398mr1875841edi.38.1711621816064;
        Thu, 28 Mar 2024 03:30:16 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id x1-20020a056402414100b00568d7b0a21csm657536eda.61.2024.03.28.03.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 03:30:14 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:30:08 +0000
From: Quentin Perret <qperret@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	bristot@redhat.com, vschneid@redhat.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
Message-ID: <ZgVGsKoAoW4YwQD_@google.com>
References: <Zf2W-8duBlCk5LVm@google.com>
 <gsntjzlqax63.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntjzlqax63.fsf@coltonlewis-kvm.c.googlers.com>

Hi Colton,

On Monday 25 Mar 2024 at 20:12:04 (+0000), Colton Lewis wrote:
> Thanks for the feedback.
> 
> Quentin Perret <qperret@google.com> writes:
> 
> > On Friday 22 Mar 2024 at 14:24:35 (+0000), Quentin Perret wrote:
> > > On Tuesday 19 Mar 2024 at 16:43:41 (+0000), Colton Lewis wrote:
> > > > Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
> > > > runqueue depth. This is so they can be passed through if the runqueue
> > > > is shallow or the CPU has support for direct interrupt injection. They
> > > > may be always trapped by setting this value to 0. Technically this
> > > > means traps will be cleared when the runqueue depth is 0, but that
> > > > implies nothing is running anyway so there is no reason to care. The
> > > > default value is 1 to preserve previous behavior before adding this
> > > > option.
> 
> > > I recently discovered that this was enabled by default, but it's not
> > > obvious to me everyone will want this enabled, so I'm in favour of
> > > figuring out a way to turn it off (in fact we might want to make this
> > > feature opt in as the status quo used to be to always trap).
> 
> Setting the introduced threshold to zero will cause it to trap whenever
> something is running. Is there a problem with doing it that way?

No problem per se, I was simply hoping we could set the default to zero
to revert to the old behaviour. I don't think removing WFx traps was a
universally desirable behaviour, so it prob should have been opt-in from
the start.

> I'd also be interested to get more input before changing the current
> default behavior.

Ack, that is my personal opinion.

> > > There are a few potential issues I see with having this enabled:
> 
> > >   - a lone vcpu thread on a CPU will completely screw up the host
> > >     scheduler's load tracking metrics if the vCPU actually spends a
> > >     significant amount of time in WFI (the PELT signal will no longer
> > >     be a good proxy for "how much CPU time does this task need");
> 
> > >   - the scheduler's decision will impact massively the behaviour of the
> > >     vcpu task itself. Co-scheduling a task with a vcpu task (or not) will
> > >     impact massively the perceived behaviour of the vcpu task in a way
> > >     that is entirely unpredictable to the scheduler;
> 
> > >   - while the above problems might be OK for some users, I don't think
> > >     this will always be true, e.g. when running on big.LITTLE systems the
> > >     above sounds nightmare-ish;
> 
> > >   - the guest spending long periods of time in WFI prevents the host from
> > >     being able to enter deeper idle states, which will impact power very
> > >     negatively;
> 
> > > And probably a whole bunch of other things.
> 
> > > > Think about his option as a threshold. The instruction will be trapped
> > > > if the runqueue depth is higher than the threshold.
> 
> > > So talking about the exact interface, I'm not sure exposing this to
> > > userspace is really appropriate. The current rq depth is next to
> > > impossible for userspace to control well.
> 
> Using runqueue depth is going off of a suggestion from Oliver [1], who I've
> also talked to internally at Google a few times about this.
> 
> But hearing your comment makes me lean more towards having some
> enumeration of behaviors like TRAP_ALWAYS, TRAP_NEVER,
> TRAP_IF_MULTIPLE_TASKS.

Do you guys really expect to set this TRAP_IF_MULTIPLE_TASKS? Again, the
rq depth is quite hard to reason about from userspace, so not sure
anybody will really want that? A simpler on/off thing might be simpler.

> > > My gut feeling tells me we might want to gate all of this on
> > > PREEMPT_FULL instead, since PREEMPT_FULL is pretty much a way to say
> > > "I'm willing to give up scheduler tracking accuracy to gain throughput
> > > when I've got a task running alone on a CPU". Thoughts?
> 
> > And obviously I meant s/PREEMPT_FULL/NOHZ_FULL, but hopefully that was
> > clear :-)
> 
> Sounds good to me but I've not touched anything scheduling related before.

Do you guys use NOHZ_FULL in prod? If not that idea might very well be a
non-starter, because switching to NOHZ_FULL would be a big ask. So,
yeah, I'm curious :)

Thanks,
Quentin

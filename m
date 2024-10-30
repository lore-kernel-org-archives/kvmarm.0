Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC82144C0
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730306194; cv=none; b=t6rtfF4XPHIC3nEYg+LHLXUMekPTHl6LSGgEQ8qvJGH6txWFkNeq82wTBg4Mw8+EFi/nGDopCqqA4tBGCmgI+hijwRGXcO7XGWZNwTE//brwzrujzhgjuRjXT96rNkA+nn93D512bXF7XgHuQ+0eSjroJyV8FQxx1AS93D7uIqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730306194; c=relaxed/simple;
	bh=zCHrmiaT0aQkEzgBzKBRTHVHsnCbnwygmYP/jN0u0D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PtlHaZrceBHfE3W9Z26x6YO8j4uhX/3OJy9VF3hISx60OJNMoZV9Hz7pWa2avUDOiJVBRqn+FPZtCfhR85o6Ks2b0uPaCM8uL0aZyQhQD5cg9ysPCcGHABGGRM6dC8cQYRZM0D8kWIqAAGyMhzDkGI6YUz+BhLVoi9cMA1KA2l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jwOoSRMt; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jwOoSRMt"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-460969c49f2so3031cf.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 09:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730306191; x=1730910991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ohhnavrPr5+YUgso4iG8u5sjXey4qTkemT4mrkrez4=;
        b=jwOoSRMtt8k/ykjKt2ws4gQ7w56MpJ54KMeRvv0OlTtIUT1W64VERgo8+G9qx95hbh
         fZs9XdM5PSW1ui0Imn8/I2UAgV12RIDBw3yIBBSax3+Iu+x/8KXhmYj7ucFpYKZ+zIGf
         6b6rSQdDkBjMXJeAsgTmCrUQFhJhWhScDpIy90PyTXuer8fG7F2OPqsekalK7Ai96Anx
         Jv4keSBVfkYN8TtfYTXE44cOWELvGBMPCK3RqCRBQ+q5ml1LKxohetgSjmTSn9JpzXT7
         fkmOCG81DbohheGMoin1IDuWg+jignySz7/YV5Mct6W4FMS6vu081Fh3swipY2Zl0w1x
         VZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730306191; x=1730910991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ohhnavrPr5+YUgso4iG8u5sjXey4qTkemT4mrkrez4=;
        b=JhVpY1Q5aPnFfxXEhG0upOcDeOodYgalAjF4thScOxQk6xFd31T3Qp2l7y4h3gAfxj
         F/Kwu5ZpSKgGVL+qDfVIx6QQzUVJCBOKESQDqIPUgtdLiNMgBepsKdqXK+3H7VEbzDAs
         biTevYhPNaqUnCFMEo0y8jWDml1yw7O55TD+QrB9/Ob1uZ3XENsa6je2HrMdabiZQCUn
         m09JLt3yqFhN5paP/htvyXfHInxFZreI0IBfbczLlt927M7ZEdZqr4sqIYwM9ZT0/6P4
         pr/Eq5mCEJYhlpW4i9YPB4vGAnoCSe2akiYm1UJnUTsCXtA2EyDYSE+7z/GkbyZmbqeG
         x6hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdDzLycf5dL8nNkx03piRosLwkD7JeLI9SJoAzP8qjXP0xJdaKupRI4gmCoyg0J+xZzJhn4Ww=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnAYTt918DtLMlDou/M4iavPtouAR9jrKZ5UJUjEmGPVHcyusD
	KufqH9Ktsi/ZIPD9WijahoX0yPpq+duGa092d1jqsPrwy4fisZwCVMgZzqplCPDmuYpcPEVNvpe
	aScIlN5xAxmoeRPq9NwETNIflG+j/l4jxG6hk
X-Gm-Gg: ASbGncusSh7M76T2meavzgZoRgFHOW/jcXfn9ob6aYw8ZCZ+uWyxGUX/EXBuodq/hKJ
	BOnmF7ShfUX7uww1cekzbHz6KsnRRQOuJBEUZHdhnl/JmwZh4KqbOSMi8ObKuBA==
X-Google-Smtp-Source: AGHT+IFBqNAhnZpINWYimOajsOUR5Hu7mWheBmruaCmzYI1pEkwMAvJVmKH+JkRRcQ8aMk7aGSnF9I1hvN2lZQ7/bOk=
X-Received: by 2002:a05:622a:cb:b0:461:3083:dbac with SMTP id
 d75a77b69052e-46166cf428fmr8624631cf.5.1730306190820; Wed, 30 Oct 2024
 09:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
 <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com>
 <865xpa3fwe.wl-maz@kernel.org> <CAJHc60xQNeTwSBuPhrKO_JBuikqZ7R=BM5rkWht3YwieVXwkHg@mail.gmail.com>
 <87iktat2y8.wl-maz@kernel.org>
In-Reply-To: <87iktat2y8.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 30 Oct 2024 09:36:19 -0700
Message-ID: <CAJHc60w7edpTSG2VA52m96BP6Eayg2jEc=9nt_b_kJFnOoQxfw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 1:22=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 30 Oct 2024 00:16:48 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Tue, Oct 29, 2024 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> =
wrote:
> > >
> > > On Tue, 29 Oct 2024 17:06:09 +0000,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.or=
g> wrote:
> > > > >
> > > > > On Mon, 28 Oct 2024 23:45:33 +0000,
> > > > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > > > >
> > > > > Did you have a chance to check whether this had any negative impa=
ct on
> > > > > actual workloads? Since the entry/exit code is a bit of a hot spo=
t,
> > > > > I'd like to make sure we're not penalising the common case (I onl=
y
> > > > > wrote this patch while waiting in an airport, and didn't test it =
at
> > > > > all).
> > > > >
> > > > I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
> > > > test the change and noticed no failures.
> > > > Any specific test you want to try out?
> > >
> > > My question is not about failures (I didn't expect any), but
> > > specifically about *performance*, and whether checking the flag
> > > without a static key can lead to any performance drop on the hot path=
.
> > >
> > > Can you please run an exit-heavy workload (such as hackbench, for
> > > example), and report any significant delta you could measure?
> >
> > Oh, I see. I ran hackbench and micro-bench from kvm-unit-tests (which
> > also causes a lot of entry/exits), on Ampere Altra with kernel at
> > v6.12-rc1, and see no significant difference in perf.
>
> Thanks for running this stuff.
>
> > timer_10ms                          231040.0                          9=
02.0
> > timer_10ms                         234120.0                            =
914.0
>
> This seems to be the only case were we are adversely affected by this
> change.
Hmm, I'm not sure how much we want to trust this comparison. For
instance, I just ran micro-bench again a few more times and here are
the outcomes of timer_10ms for each try with the patch:

Tries                                             total ns
               avg ns
---------------------------------------------------------------------------=
--------
1_timer_10ms                             231840.0                          =
905.0
2_timer_10ms                             234560.0                          =
916.0
3_timer_10ms                             227440.0                          =
888.0
4_timer_10ms                             236640.0                          =
924.0
5_timer_10ms                             231200.0                          =
903.0

Here's a few on the baseline:

Tries                                             total ns
               avg ns
---------------------------------------------------------------------------=
--------
1_timer_10ms                             231080.0                          =
902.0
2_timer_10ms                             238040.0                          =
929.0
3_timer_10ms                             231680.0                          =
905.0
4_timer_10ms                             229280.0                          =
895.0
5_timer_10ms                             228520.0                          =
892.0


> In the grand scheme of thins, that's noise. But this gives us
> a clear line of sight for the removal of the in-kernel interrupts back
> to userspace.
Sorry, I didn't follow you completely on this part.

Thank you.
Raghavendra

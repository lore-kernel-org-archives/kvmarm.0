Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294611549E
	for <kvmarm@lists.linux.dev>; Wed, 20 Dec 2023 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EczIQb/L"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2cc2238f597so60852921fa.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 22:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703055015; x=1703659815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IloV9gHlRpc9SD2YCXR7E/7T42jMVfD74Pty8sLbHvY=;
        b=EczIQb/LL6qNEs0cmixyqI6OI4EnGsomxWZDfZEGobOZrdhtfHjn1UtnnGxRcT0tJ9
         JNzvC4zlCy19N5y3NvWcX2ikgjpuyKyEeWgWLwLM7TmSrDqO2tNzg8ijAUyBiLK8APDq
         323TPXBUpObgERxvFo1gSp1JIAk8ZWZF7sM9TF/09jTGAxAVwUJrq/A+57ViI3S8Bb1j
         c0Uk6e+KH0HGU3bwtce8aSRkHe3+qQidMEylxqmMMznOxstdmoZKXxXgzPxJRZ645eaZ
         MWz3Zdrtoc+LtxD5CdWCe2SLBFM+CvMpLKpnqlFjJ95afr0s4UkkanU1rJB4OnBm6odP
         h5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703055015; x=1703659815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IloV9gHlRpc9SD2YCXR7E/7T42jMVfD74Pty8sLbHvY=;
        b=pCwXNBj1JMzAyK7HoD2QvscVebOQShAYwXlpK28+dsis8YMfdYblOwRD2ihDoAoe1y
         61diHfbMKUJpeYyiocTxYFVxaFyTjowIPOVHOPh0sX7eY3w2TZLJ00+1gqdaS9ZxkEMM
         3lAqav4vAm2tjftOpFBhmAy1ooC3f/eklvv8OO+3IbjSIrC9LBN0PUyhqRj7NDLwLThe
         pc8TEuRaglfXb+eU2a0CH7Lj+elHwa+s0xQ5kYrYvtoej16hFCCjtMYs6+TWFMoF5Bce
         ZVAQddWH4u6iQ405DGSDEOSg/GM0p6G5WkbqlExQ18lDqm+aJfhtzSSRfFbIh4IdBhl+
         K33g==
X-Gm-Message-State: AOJu0Yy6iW55JvllzGzbzddXCkfpres2gSES+szXeJMPJvnwN2+VFFHQ
	Hx3S6SRLngBdkX2396/z1wOp6FAn3+U6gJoF1O0=
X-Google-Smtp-Source: AGHT+IGyXIZ1XsWlabej49gCsPyJXlY+x34WunG9S1gzJ848CgF23IrFQFyfhwjo//9JKJAadF2riryatJZtvHVMNgc=
X-Received: by 2002:a2e:b0dc:0:b0:2cc:895c:5de3 with SMTP id
 g28-20020a2eb0dc000000b002cc895c5de3mr338259ljl.207.1703055014949; Tue, 19
 Dec 2023 22:50:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1702371136.git.haibo1.xu@intel.com> <0343a9e4bfa8011fbb6bca0286cee7eab1f17d5d.1702371136.git.haibo1.xu@intel.com>
 <8734vy832j.wl-maz@kernel.org>
In-Reply-To: <8734vy832j.wl-maz@kernel.org>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 20 Dec 2023 14:50:03 +0800
Message-ID: <CAJve8onc0WN5g98aOVBmJx15wFBAqfBKJ+ufoLY+oqYyVL+=3A@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] KVM: selftests: Enable tunning of err_margin_us
 in arch timer test
To: Marc Zyngier <maz@kernel.org>
Cc: Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Greentime Hu <greentime.hu@sifive.com>, 
	wchen <waylingii@gmail.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Heiko Stuebner <heiko@sntech.de>, Minda Chen <minda.chen@starfivetech.com>, 
	Samuel Holland <samuel@sholland.org>, Jisheng Zhang <jszhang@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 2:22=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 12 Dec 2023 09:31:20 +0000,
> Haibo Xu <haibo1.xu@intel.com> wrote:
> > > @@ -216,6 +221,9 @@ static bool parse_args(int argc, char *argv[])
> >               case 'm':
> >                       test_args.migration_freq_ms =3D atoi_non_negative=
("Frequency", optarg);
> >                       break;
> > +             case 'e':
> > +                     test_args.timer_err_margin_us =3D atoi_non_negati=
ve("Error Margin", optarg);
> > +                     break;
>
> So your error margin is always unsigned...
>

The error margin was supposed to be a non-negative [0, INT_MAX].
(May be need to define a Max for the input, instead of INT_MAX)

> >               case 'o':
> >                       test_args.counter_offset =3D strtol(optarg, NULL,=
 0);
> >                       test_args.reserved =3D 0;
> > diff --git a/tools/testing/selftests/kvm/include/timer_test.h b/tools/t=
esting/selftests/kvm/include/timer_test.h
> > index 968257b893a7..b1d405e7157d 100644
> > --- a/tools/testing/selftests/kvm/include/timer_test.h
> > +++ b/tools/testing/selftests/kvm/include/timer_test.h
> > @@ -22,6 +22,7 @@ struct test_args {
> >       int nr_iter;
> >       int timer_period_ms;
> >       int migration_freq_ms;
> > +     int timer_err_margin_us;
>
> ... except that you are storing it as a signed value. Some consistency
> wouldn't hurt, really, and would avoid issues when passing large
> values.
>

Yes, it's more proper to use an unsigned int for the non-negative error mar=
gin.
Storing as signed here is just to keep the type consistent with that
of timer_period_ms
since there will be '+' operation in other places.

        tools/testing/selftests/kvm/aarch64/arch_timer.c
        /* Setup a timeout for the interrupt to arrive */
         udelay(msecs_to_usecs(test_args.timer_period_ms) +
             test_args.timer_err_margin_us);

Thanks,
Haibo

>         M.
>
> --
> Without deviation from the norm, progress is not possible.

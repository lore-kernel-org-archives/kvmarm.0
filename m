Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5A74696
	for <kvmarm@lists.linux.dev>; Thu, 21 Dec 2023 02:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cb9u+eG6"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2cc6d9b4c6aso2880811fa.3
        for <kvmarm@lists.linux.dev>; Wed, 20 Dec 2023 18:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703127533; x=1703732333; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bBzkO/x8C7pW+ybw+V7AQ5yP+2vx9qyk2y1ClRHSZw=;
        b=Cb9u+eG65OluRUJaLlXL2sidFalyEAiJcz0hhtSbrECmK+S73DlzoO9c1rF4vm/vH+
         tFLSwEWQByNZbf8V3XZGme3awnn4wEUOVKASIsKff9EuUQFB/6svItK4gn0cuIH9+we8
         qc2cZUzEYNuBD00eXk9B/yK3OqeL+/ornelO2kg8f5Pq7nt7R/9n/nJwOJ1tJypCJQb8
         wyULrSEk+FLh6x1LgBZYBK4igmuaz2BcYchzp4EkU2tfp8BJqVZPTYYTjyafm0a9olLV
         bdfKJ0RyEvEWOvl+TY9CmoPt4oXRKmY7E5VURQjdhifjbJOYVRrfR6CC0eda0fp43LK5
         3myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703127533; x=1703732333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bBzkO/x8C7pW+ybw+V7AQ5yP+2vx9qyk2y1ClRHSZw=;
        b=S4XkPVkAwojrIQlqq+R1JqEDBM9he5t1M5hmOK1zodYWSZEd2hNvOaPqpHpzoaAdrK
         7nvFlAaQuilJitlq4w03zaeGnBi8bIzYWiDBmdzRr802KTHR0aYz6hQ7ng2k6PQQmk99
         ormVZaYPcce5t7RR2q4w2lmGYrBYWWk/pLLSn7SN4H/+Vpi6+3S3N8F/W8CU3SrPd6+k
         EoDyW9xvKTfWwUCUS7LQvKMbb4RstgG4/xv6ZANt94EApa1wbhLQXveP/QRU7/+QK4Hg
         lCtRrFkAFC5POxx8HSzRPRYFq578Qw/uVp3z+Sq/79wRxH0lheg1pTJavoLFj+9edxre
         gosQ==
X-Gm-Message-State: AOJu0YxvnR2ND4iNoLQj3TD1VV/AOx/ee1TrwN9wc4mruxBKstELhXvz
	wN5knJykBnutdFPjw6vpDqalAgkhRjIAuPaztDY=
X-Google-Smtp-Source: AGHT+IGJHPrvnGt2Ru34bEuu9VEKW4Ddr4y1BwS+bbHJIUMRrvHhhF9Knr8M3TPrt5vBdMTPh9CciXS8rGxFOeFA2n4=
X-Received: by 2002:a2e:95d2:0:b0:2cc:7c8c:574b with SMTP id
 y18-20020a2e95d2000000b002cc7c8c574bmr1956176ljh.77.1703127532313; Wed, 20
 Dec 2023 18:58:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1702371136.git.haibo1.xu@intel.com> <0343a9e4bfa8011fbb6bca0286cee7eab1f17d5d.1702371136.git.haibo1.xu@intel.com>
 <8734vy832j.wl-maz@kernel.org> <CAJve8onc0WN5g98aOVBmJx15wFBAqfBKJ+ufoLY+oqYyVL+=3A@mail.gmail.com>
 <f98879dc24f948f7a8a7b5374a32bc04@kernel.org> <CAJve8ona7g=LxW1YeRB_FqGodF973H=A3b2m8054gmzK=Z7_ww@mail.gmail.com>
 <87zfy5t1qt.wl-maz@kernel.org>
In-Reply-To: <87zfy5t1qt.wl-maz@kernel.org>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 21 Dec 2023 10:58:40 +0800
Message-ID: <CAJve8o=nTsAwwgSib4vOLXjOWSMV2+J+BFsUZ57OdAK7eW8q8A@mail.gmail.com>
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

On Wed, Dec 20, 2023 at 9:58=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 20 Dec 2023 13:51:24 +0000,
> Haibo Xu <xiaobo55x@gmail.com> wrote:
> >
> > On Wed, Dec 20, 2023 at 5:00=E2=80=AFPM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On 2023-12-20 06:50, Haibo Xu wrote:
> > > > On Wed, Dec 20, 2023 at 2:22=E2=80=AFAM Marc Zyngier <maz@kernel.or=
g> wrote:
> > > >>
> > > >> On Tue, 12 Dec 2023 09:31:20 +0000,
> > > >> Haibo Xu <haibo1.xu@intel.com> wrote:
> > > >> > diff --git a/tools/testing/selftests/kvm/include/timer_test.h b/=
tools/testing/selftests/kvm/include/timer_test.h
> > > >> > index 968257b893a7..b1d405e7157d 100644
> > > >> > --- a/tools/testing/selftests/kvm/include/timer_test.h
> > > >> > +++ b/tools/testing/selftests/kvm/include/timer_test.h
> > > >> > @@ -22,6 +22,7 @@ struct test_args {
> > > >> >       int nr_iter;
> > > >> >       int timer_period_ms;
> > > >> >       int migration_freq_ms;
> > > >> > +     int timer_err_margin_us;
> > > >>
> > > >> ... except that you are storing it as a signed value. Some consist=
ency
> > > >> wouldn't hurt, really, and would avoid issues when passing large
> > > >> values.
> > > >>
> > > >
> > > > Yes, it's more proper to use an unsigned int for the non-negative e=
rror
> > > > margin.
> > > > Storing as signed here is just to keep the type consistent with tha=
t
> > > > of timer_period_ms
> > > > since there will be '+' operation in other places.
> > > >
> > > >         tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > >         /* Setup a timeout for the interrupt to arrive */
> > > >          udelay(msecs_to_usecs(test_args.timer_period_ms) +
> > > >              test_args.timer_err_margin_us);
> > >
> > > But that's exactly why using a signed quantity is wrong.
> > > What does it mean to have a huge *negative* margin?
> > >
> >
> > Hi Marc,
> >
> > I agree that negative values are meaningless for the margin.
> > If I understand correctly, the negative margin should be filtered by
> > assertion in atoi_non_negative().
>
> No. Please.
>
> atoi_non_negative() returns a uint32_t, which is what it should do.
> The bug is squarely in the use of an 'int' to store such value, and it
> is the *storage* that turns a positive value into a negative one.
>

Thanks for the detailed info!

May I understand that your concern is mainly for a platform with 64bit int =
type,
which may trigger the positive to negative convert?

If so, I think we may need to do a clean up for the test code since
several other
places have the same issue.

Regards,
Haibo

>         M.
>
> --
> Without deviation from the norm, progress is not possible.

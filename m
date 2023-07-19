Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6F1BB20
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 21:16:49 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b9ed206018so23875ad.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 14:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689801409; x=1690406209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBJj2LL0pM4tkw5oGrSPDiIzepbTgsFXALya9co7OzU=;
        b=W6OMSkAAUHEcMC412H0lAQ3j8Wn4AhrIEwRhYSYVuxLpiOCbfR46pbNCWs36E7yHLb
         5UVJGnc9+6mX2OpE3q8S7+xNH/IYoxOT3PaeBp2xWoDyDyHIWrgVLSHjNxHaYkQ8jDkf
         WYEqlXjA2c78z7kIxII3WCpUyAVyV2/xBxEaRCRfsPXZspG8XQxzK/5o7xgrYLIioUtf
         uyEhVJ/lHOfIF8jZhsA0KmLH8s/73qzjxi9GhT/D50ZC7gj2d0NhTQ03OxaNEAktJFV8
         iiFOOvx1G48+CpG1qT2hcgz3UpXZkAg0ijbJYKqPmM7ULVc0VY4YyhKq2sxJ/29vjUOR
         wUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689801409; x=1690406209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBJj2LL0pM4tkw5oGrSPDiIzepbTgsFXALya9co7OzU=;
        b=J6w4N2KSJdfofy1lgvgBZOGtMTrWCxbnwD66NJQsvQKLs2O7xfNawNQogoRvuHJqh0
         dyMxvx1M9HoMTZ1aJx86acDk6REk3Om89wqgrE8p39M0FsW655c1i33V5cj1NXlYLRX4
         x/JAceIVU8Lc6w3bAjNp7KMIl05E1o2LGYcHre5wb46DQHFcfGLnCqduyZ44uS2JQmR4
         DC5hVzZBsWQLKKgojOGyDsgsw81gn3fHvMXxGtzo9RyAd1li8P5IQQGMsRlQVlYNpohx
         tscbmvkv/za53VWRIDxOl835wys1uJ0clhUIhlVabAVqwfEJ5z4PL0OMWSD+KUMXp1V/
         WEIQ==
X-Gm-Message-State: ABy/qLbuxHBgATdqJ+jbTsocDrXtH1KgfnOs947NWRpKH7UBXi0jZCm0
	mGYidh3RJZ4odqQ3aQPainU+Zl5h1ZpqwVPlzQ1G8A==
X-Google-Smtp-Source: APBJJlHKlzwdoYmK+M09bgH3YtAqDj8/AuZu+WjFw6IiL5hGhp/FOj8omZxrBHxg8mWcQ3OEO3r9j9Evb539urogo0Y=
X-Received: by 2002:a17:902:f9cf:b0:1b8:89fd:61ea with SMTP id
 kz15-20020a170902f9cf00b001b889fd61eamr21553plb.1.1689801408973; Wed, 19 Jul
 2023 14:16:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230719175400.647154-1-rananta@google.com> <ZLhMDapXa2djVzf0@linux.dev>
In-Reply-To: <ZLhMDapXa2djVzf0@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 19 Jul 2023 14:16:36 -0700
Message-ID: <CAJHc60x3X1OCQGsfvuWg-6niMfASkZwXJtyfZ5KMac0-=r4uXw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix CPUHP logic for protected KVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Reiji Watanabe <reijiw@google.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 19, 2023 at 1:48=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Jul 19, 2023 at 05:54:00PM +0000, Raghavendra Rao Ananta wrote:
> > For protected kvm, the CPU hotplug 'down' logic currently brings
> > down the timer and vGIC, essentially disabling interrupts. However,
> > because of how the 'kvm_arm_hardware_enabled' flag is designed, it
> > never re-enables them back on the CPU hotplug 'up' path. Hence,
> > clean up the logic to maintain the CPU hotplug up/down symmetry.
>
> Correct me if I am wrong, but this issue exists outside of cpu hotplug,
> right? init_subsystems() calls _kvm_arch_hardware_enable() on all cores,
> which only sets up the hyp cpu context and not the percpu interrupts.
> Similar issue exists for the cpu that calls do_pkvm_init().
>
Ah, perhaps I looked at the from a different perspective, but this
makes sense too.

> I'll also note kvm_arm_hardware_enabled is deceptively vague, as it only
> keeps track of whether or not the hyp cpu context has been initialized.
> May send a cleanup here in a bit.
>
> Perhaps this for the changelog:
>
>   KVM: arm64: Fix hardware enable/disable flows for pKVM
>
>   When running in protected mode, the hyp stub is disabled after pKVM is
>   initialized, meaning the host cannot enable/disable the hyp at
>   runtime. As such, kvm_arm_hardware_enabled is always 1 after
>   initialization, and kvm_arch_hardware_enable() never enables the vgic
>   maintenance irq or timer irqs.
>
>   Unconditionally enable/disable the vgic + timer irqs in the respective
>   calls, instead relying on the percpu bookkeeping in the generic code
>   to keep track of which cpus have the interrupts unmasked.
>
Sure, we can use this for v2.

Thanks,
Raghavendra
> > Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
> > Reported-by: Oliver Upton <oliver.upton@linux.dev>
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 14 ++++----------
> >  1 file changed, 4 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c2c14059f6a8..010ebfa69650 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *dis=
card)
> >
> >  int kvm_arch_hardware_enable(void)
> >  {
> > -     int was_enabled =3D __this_cpu_read(kvm_arm_hardware_enabled);
> > -
> >       _kvm_arch_hardware_enable(NULL);
> >
> > -     if (!was_enabled) {
> > -             kvm_vgic_cpu_up();
> > -             kvm_timer_cpu_up();
> > -     }
> > +     kvm_vgic_cpu_up();
> > +     kvm_timer_cpu_up();
> >
> >       return 0;
> >  }
> > @@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *dis=
card)
> >
> >  void kvm_arch_hardware_disable(void)
> >  {
> > -     if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> > -             kvm_timer_cpu_down();
> > -             kvm_vgic_cpu_down();
> > -     }
> > +     kvm_timer_cpu_down();
> > +     kvm_vgic_cpu_down();
> >
> >       if (!is_protected_kvm_enabled())
> >               _kvm_arch_hardware_disable(NULL);
> > --
> > 2.41.0.487.g6d72f3e995-goog
> >
>
> --
> Thanks,
> Oliver

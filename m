Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E146D184F
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 05:26:18 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id o6so13562894vsq.10
        for <kvmarm@lists.linux.dev>; Wed, 22 Feb 2023 21:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXEnUJIuw3DsBBpeEas97UQaCI4+fKGVwu8RQPcIlxs=;
        b=ebfMrTiO8jVZApxkACFGkW19OKcseaGjzh5HjIfu8MAU62l8YkK9wYnBFkU6I+6zuE
         AUDCEHsZSZ9mbCKKWNPTplXuqS87aYdUMgEd5/HJTFPzZF9uHLGfh+f//SGkFgG2WUUC
         VMrPZXwgvdZQ0a9Rdfoin9rPnC9lwtXHaGCdiIAVtUZ+zDzePE60bEA2n80H6qz2mPub
         YZRSOEb//hMVhNQrFI5fjyJOTZ5EPIveLNi+6mlZv8sUqb9Y6C+ziwSJjuW7/BuocHT5
         ypJ99wrjoFqAACPuG1lbl4B3N9wqDvRcpL/jBCfwY1kMxbLPNuarGmvnmO4vjdaXxv4a
         SkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXEnUJIuw3DsBBpeEas97UQaCI4+fKGVwu8RQPcIlxs=;
        b=L3n6inKoUuRWvPw0akcOTIee3arpTT/PRUu9Nr5fLi55CuBNBkXD6gO667F/XiGnlJ
         CZs2J/BY/CYkdhuikrXs2BPvU1Dr5muVezggnA8DFT89Fe0wHos2wnOTuEX3Yb49fQE5
         JMuZLMWDqqNXbhceT014i28Kok5XYXq267Vq1XMMKriSDjz8aUvvIi4SAvMqpXPWSOVK
         sY512+tyfhP5dvApHc/+YBYN5z2u8g09bq64yKUG7lVONKpct8JNzpXXShAKbbCbZd+0
         cLwEfNMSylPEqNCdU2WpO/4JuuiRbEO80hw9oV9/2fH88OTvNZKz1UqbAELyWlAyXisx
         IsJg==
X-Gm-Message-State: AO0yUKWgEkon0tVyFdcN6Tui1qTl6LX5elWODlVIJyqd9uTP8+WdAFUo
	senWpic3UlRH9GzqDlhBz7aaLvcSMxyte7Zkyts6/Q==
X-Google-Smtp-Source: AK7set/r/f8pGhkIjYGiLVLtcsnWRFxpAmGZdfZxTguMU1aVP5zVqu1WLV5ZRnN+vLq9szVFT6NHenS4YuDGWsM46AY=
X-Received: by 2002:a05:6102:108f:b0:41e:d8b5:ee40 with SMTP id
 s15-20020a056102108f00b0041ed8b5ee40mr553492vsr.26.1677129977589; Wed, 22 Feb
 2023 21:26:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
 <Y+9EUeUIS/ZUe2vw@linux.dev> <Y++kiJwUIh55jkvl@google.com>
In-Reply-To: <Y++kiJwUIh55jkvl@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 22 Feb 2023 22:25:41 -0700
Message-ID: <CAOUHufYVWvEG=EMBEffnurQhJSb5WN75NVVXPhWghWFR9Aa94A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2023 at 9:00=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 17, 2023, Oliver Upton wrote:
> > Hi Yu,
> >
> > scripts/get_maintainers.pl is your friend for getting the right set of
> > emails for a series :) Don't know about others, but generally I would
> > prefer to be Cc'ed on an entire series (to gather context) than just an
> > individual patch.
>
> +1
>
> >
> > On Thu, Feb 16, 2023 at 09:12:28PM -0700, Yu Zhao wrote:
> > > This patch adds kvm_arch_test_clear_young() for the vast majority of
> > > VMs that are not pKVM and run on hardware that sets the accessed bit
> > > in KVM page tables.
>
> At least for the x86 changes, please read Documentation/process/maintaine=
r-tip.rst
> and rewrite the changelogs.

I see -- will remove "this patch".

> > > It relies on two techniques, RCU and cmpxchg, to safely test and clea=
r
> > > the accessed bit without taking the MMU lock. The former protects KVM
> > > page tables from being freed while the latter clears the accessed bit
> > > atomically against both the hardware and other software page table
> > > walkers.
> > >
> > > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h       |  7 +++
> > >  arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
> > >  arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
> > >  arch/arm64/kvm/arm.c                    |  1 +
> > >  arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
> > >  arch/arm64/kvm/mmu.c                    | 77 +++++++++++++++++++++++=
+-
> > >  6 files changed, 141 insertions(+), 46 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> > > index 35a159d131b5..572bcd321586 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -1031,4 +1031,11 @@ static inline void kvm_hyp_reserve(void) { }
> > >  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> > >  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
> > >
> > > +/* see the comments on the generic kvm_arch_has_test_clear_young() *=
/
>
> Please eliminate all of these "see the comments on blah", in every case t=
hey do
> nothing more than redirect the reader to something they're likely already=
 aware of.
>
> > > +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> > > +static inline bool kvm_arch_has_test_clear_young(void)
> > > +{
> > > +   return IS_ENABLED(CONFIG_KVM) && cpu_has_hw_af() && !is_protected=
_kvm_enabled();
> > > +}
>
> ...
>
> > Also, I'm at a loss for why we'd need to test if CONFIG_KVM is enabled.
> > My expectation is that we should provide an implementation that returns
> > false if !CONFIG_KVM, avoiding the need to repeat that bit in every
> > single implementation of the function.
>
> mm/vmscan.c uses kvm_arch_has_test_clear_young().  I have opinions on tha=
t, but
> I'll hold off on expressing them until there's actual justification prese=
nted
> somewhere.
>
> Yu, this series and each patch needs a big pile of "why".  I get that the=
 goal
> is to optimize memory oversubscribe, but there needs to be justification =
for
> why this is KVM only, why nested VMs and !A/D hardware are out of scope, =
why yet
> another mmu_notifier hook is being added, etc.

I totally agree.

This is an optimization, not a bug fix. It can't be justified without
performance numbers from some common use cases. That burden of proof
clearly rests on me -- I will follow up on that.

For now, I want to make sure the methodical part is clear:
1. We only have limited resources and we need to prioritize major use cases=
.
2. We can only improve one thing at a time and we can't cover
everything at the same time.
3. We need to focus on the return on investment and the future.

I hope everyone by now agrees with my "the vast majority of VMs ..."
assertion. If not, I'm happy to revisit that [1]. If so, the next step
would be whether we want to focus on the vast majority first. I think
this naturally answers why the nested VMs and !AD h/w are out of
scope, at the moment (I didn't spell this out; probably I should in
v2). After we have taken the first step, we probably can decide
whether there is enough resource and demand to cover the low return on
investment part (but complexity but less common use cases).

[1] https://lore.kernel.org/linux-mm/20230217041230.2417228-1-yuzhao@google=
.com/

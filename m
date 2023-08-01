Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB217E
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 00:43:06 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-40c72caec5cso134011cf.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690850585; x=1691455385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wz5PQDI2T5JD79/VqNSh8cAHB4+Dq2pKqfYEsmYHYJc=;
        b=MFYDUohPKYqzUjmRdIik4Kf/M1i09cRnmwx/ISJELixqxj8gzvM0dEKMXyxYAMFbw3
         ReLM/cPUTz05PxclkqkBgVsoeT/7EH3dALymU5TM8n9AYViSu4kpjQw8g9TlIr5lYEdx
         STtN0tXmEUrwz4qA3H7UDuyRNjk2yzkj4bwdACzU8bzIwG8V1u6MRimG2rWhgHRiWHYy
         eXQ8o14YblAtdc0/rR4R99744OZdbLElco3n3qUL5oyzjog5namRFGU6L/NVq+oZEqqn
         QLVsLJdbOWotDUgFVkV6iklP9yVqIk7HEQLLekRiuMLcq+3DzGurl/ToVlHLeESVGYUY
         hxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690850585; x=1691455385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wz5PQDI2T5JD79/VqNSh8cAHB4+Dq2pKqfYEsmYHYJc=;
        b=TIP+C3pdUAs5rhlPndWcXi4/6MmbjXszPMGi+8axURBwvVzate0OKSd5cuEBvV9iO6
         KytK3JFgZrVTYQIiE99auBX676UdsgfwdmrldfTjd4d5gM2q5F0KnJzyeDdkm43J2U4N
         e3/Bv4S8H0notQqDpOS8eCB/jyHH4Nmi+g+d0ZP85IB1b5zEYNHNl/auktH0B1v8znV6
         gHkIJO92sWguTtlR57om9zW85NuZIRRiAc3AjB+75LrFejMY/4Ji/U2zHdECw8MvtSCx
         SPBD7kPF2mh9pJ1etshhKlb9ZUf6yGTIiLc4ckMZgoHJ+v4pmxP7hRLf0b4PwI47Ret8
         ekkg==
X-Gm-Message-State: ABy/qLYAoP/cwrblxcH8wHFrq4tuxnL1f98nU6XypOvn5Gs6/DeGoDgd
	oVr00CSNl9wHQFm4Wl6+K6HDKNey57VUc5DFyK+eTg==
X-Google-Smtp-Source: APBJJlGp1HM0IIW5HWYh0WPnS7cydIdnyyIPn3xHA78fZgN1YFWKwQ3DKE5js9J5XfPxG82YjMXnoKhazzIIIJsIP5M=
X-Received: by 2002:a05:622a:1447:b0:3f4:f0fd:fe7e with SMTP id
 v7-20020a05622a144700b003f4f0fdfe7emr530327qtx.3.1690850585401; Mon, 31 Jul
 2023 17:43:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
 <ZMgqueePlmKvgUId@google.com>
In-Reply-To: <ZMgqueePlmKvgUId@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 17:42:54 -0700
Message-ID: <CAJHc60xM+KsUKxtoqORnpzrRke4T-sob2uLJRMvBKwruipxnpw@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 31, 2023 at 2:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 31, 2023, Raghavendra Rao Ananta wrote:
> > On Thu, Jul 27, 2023 at 3:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Sat, 22 Jul 2023 03:22:40 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > From: David Matlack <dmatlack@google.com>
> > > >
> > > > Rename kvm_arch_flush_remote_tlb() and the associated macro
> > > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() an=
d
> > > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
> > > >
> > > > Making the name plural matches kvm_flush_remote_tlbs() and makes it=
 more
> > > > clear that this function can affect more than one remote TLB.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> > > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > > ---
> > > >  arch/mips/include/asm/kvm_host.h | 4 ++--
> > > >  arch/mips/kvm/mips.c             | 2 +-
> > > >  arch/x86/include/asm/kvm_host.h  | 4 ++--
> > > >  include/linux/kvm_host.h         | 4 ++--
> > > >  virt/kvm/kvm_main.c              | 2 +-
> > > >  5 files changed, 8 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/a=
sm/kvm_host.h
> > > > index 04cedf9f8811..9b0ad8f3bf32 100644
> > > > --- a/arch/mips/include/asm/kvm_host.h
> > > > +++ b/arch/mips/include/asm/kvm_host.h
> > > > @@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm=
_vcpu *vcpu, int cpu) {}
> > > >  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {=
}
> > > >  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)=
 {}
> > > >
> > > > -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> > > > -int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> > > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > > +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > >
> > > How about making this prototype global? I don't see a point in having
> > > it per-architecture, specially as you are adding arm64 to that mix in
> > > the following patch.
> > >
> > We can make it global, but I'm not sure what was the intention of the
> > original author. My guess is that he was following the same style that
> > we have for some of the other kvm_arch_*() functions
> > (kvm_arch_free_vm() for example)?
>
> Heh, KVM has a *lot* of code that was written with questionable style.  I=
 agree
> with Marc, I can't think of a single reason not to have the definition in=
 common
> code.  Declaring the function doesn't preclude a "static inline" implemen=
tation,
> and we could even keep the prototype under an #ifdef, e.g.
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d3ac7720da9..5ac64f933547 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlb(struct =
kvm *kvm)
>  {
>         return -ENOTSUPP;
>  }
> +#else
> +int kvm_arch_flush_remote_tlb(struct kvm *kvm);
>  #endif
>
>  #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
>
Thanks for the suggestions; I can go with a common declaration. Along
with that, do we want to keep defining
__KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS in the arch code that supports it or
convert it into a CONFIG_?

- Raghavendra

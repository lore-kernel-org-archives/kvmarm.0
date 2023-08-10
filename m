Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E211877
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 22:34:12 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-407db3e9669so51361cf.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691706851; x=1692311651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iczog4wlh1DjFLdMSzEvmMOPilWHUZVQiRjWpcVknB4=;
        b=epAa0LKnKl5u66Y9RbFdhV8Lv5Y/bmCosxzVw0hc7/eKhboiaA24S7kWFOsvT3d/6v
         R5IFwTcqvp9Hl6i35RRRje6JKgkiqfcZXUhHwrDZqwjImCaIXKPw6fnTz3qawFl9qWaN
         y1BRsMkYdM/Vkm71K//EAIh0oMZ2T+tki5MWNLYHdhoMwDETGGk0C72DSKPpcNtdVI/n
         6LbzVP/Y6nqhT0KZCcZ0oV8L7F4BxrgoCsvYOMX2D/8fZYXweyhURULxqXDrb/hulRuS
         zA+fdeTbAiZsAJP20VaE+kk7PO04ERwsCiYM4LqdhVp0INromfUBIr5ctl+cNBTnxFca
         OXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691706851; x=1692311651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iczog4wlh1DjFLdMSzEvmMOPilWHUZVQiRjWpcVknB4=;
        b=lINpGygIxGCRZmB23VtxEJRBR5j66G+GQ3449skel1p4O+CaKhyeS+eVlxFTEeYcFY
         dfVwkR23k4hnKiwYx59FBEhQXVMWaJ1/2M2+CQDdLXqkkVX5yZXKW3TIs7ctNmK7jV93
         404rBnwcEzetSgm3Eks8vz4VE505hSrFyKxumOSH6jXrtTENBgqUcyJH1p9uuB+Ng+Xl
         Sa4hpFOfMyHruy+ea0u8NKtzps81glLxmNzi1UqeSwGqtx7jtKMEzVFSYdzMYr5ntmZy
         FfIziaUUHNY8Sm6WFpLTVqWz77A9yKOJyOzSJqs9lQgovX5JrUzOM7xz7tHq8FYIVVaL
         2Eag==
X-Gm-Message-State: AOJu0YyOBq2khCN1Yvi3/Qs8hFVtt3/UfvTETwv0FOV5cmwEoNgM8DWQ
	OiStuLaEii5gUATPh75UU/1Y3vUyVwruRBncuzjLQA==
X-Google-Smtp-Source: AGHT+IHAtNxlpUZmQoXEcDxVa2yk3p3K+PVD72RQhW5Mh60EHaBNEWbQ+TxSW7uZIaokAfbLajpQhvWaiqGPsEZ9Nws=
X-Received: by 2002:ac8:7d55:0:b0:3ef:3361:75d5 with SMTP id
 h21-20020ac87d55000000b003ef336175d5mr45398qtb.11.1691706851560; Thu, 10 Aug
 2023 15:34:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com> <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
 <ZNVfsxdYKu9Nt+j+@google.com>
In-Reply-To: <ZNVfsxdYKu9Nt+j+@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 10 Aug 2023 15:34:00 -0700
Message-ID: <CAJHc60w0By2Q+PCsfwReGXsN5zf5k1ww3Ov4m9Eb-pFH-UKBDg@mail.gmail.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
To: Sean Christopherson <seanjc@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> > On Thu, Aug 10, 2023 at 5:26=E2=80=AFAM Shaoqin Huang <shahuang@redhat.=
com> wrote:
> > > On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> > > >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > >>> index e3f968b38ae97..ade5d4500c2ce 100644
> > > >>> --- a/include/linux/kvm_host.h
> > > >>> +++ b/include/linux/kvm_host.h
> > > >>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlb=
s(struct kvm *kvm)
> > > >>>    {
> > > >>>        return -ENOTSUPP;
> > > >>>    }
> > > >>> +#else
> > > >>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > > >>>    #endif
> > > >>>
> > > >>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> > > >>
> > > >> Is the declaration inconsistent to that in arch/x86/include/asm/kv=
m_host.h?
> > > >> In order to keep them consistent, I guess we need move kvm_arch_fl=
ush_remote_tlbs()
> > > >> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' need=
s to be dropped.
> > > >>
> > > > Unsure of the original intentions, I didn't want to disturb any
> > > > existing arrangements. If more people agree to this refactoring, I'=
m
> > > > happy to move.
> > >
> > > This is amazing to me. This change can be compiled without any error
> > > even if the declaration inconsistent between the kvm_host.h and x86's
> > > header file.
> > >
> > > I'm curious which option make it possible?
> > >
> > After doing some experiments, I think it works because of the order in
> > which the inline-definition and the declaration are laid out. If the
> > 'inline' part of the function comes first and then the declaration, we
> > don't see any error. However if the positions were reversed, we would
> > see an error. (I'm not sure what the technical reason for this is).
> >
> > Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.c
> > as a non-inline function.
>
> No need, asm/kvm_host.h _must_ be included before the declaration, otherw=
ise the
> declaration wouldn't be made because __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS wo=
uldn't
> be defined.  I.e. we won't run into issues where the non-static declarati=
on comes
> before the static inline definition.
>
> C99 explicitly covers this case:
>
>   6.2.2 Linkages of identifiers
>
>   ...
>
>   If the declaration of a file scope identifier for an object or a functi=
on contains the storage-
>   class specifier static, the identifier has internal linkage.
>
>   For an identifier declared with the storage-class specifier extern in a=
 scope in which a
>   prior declaration of that identifier is visible if the prior declaratio=
n specifies internal or
>   external linkage, the linkage of the identifier at the later declaratio=
n is the same as the
>   linkage specified at the prior declaration. If no prior declaration is =
visible, or if the prior
>   declaration specifies no linkage, then the identifier has external link=
age.
>
> In short, because the "static inline" declared internal linkage first, it=
 wins.
Thanks for sharing this! I can keep the 'static inline' definition as
is then. However, since a later patch (patch-05/14) defines
kvm_arch_flush_remote_tlbs_range() in arch/x86/kvm/mmu/mmu.c, do you
think we can move this definition to the .c file as well for
consistency?

Thank you.
Raghavendra


Raghavendra

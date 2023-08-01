Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268A7E
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 00:40:11 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3460770afe2so30585ab.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690850410; x=1691455210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQaJrQRUIiWVDCsAsh3n8+ThLFrN8Bh/awGWXHsDQe0=;
        b=aVcAiHgZKSA41yfjau5sn0kLRmUefICGRUqWSxWFrJPabknpsf37xFnhkfkJC3slWo
         91oO/teCA7rEBLT9/jqVl0I3w0vKM+fMIl1YqCUbA/rjydkD0AR/YZFtYf6nH1izkSrF
         xKBFggrAYblDXn/jMHHkbJNvSG33lwajusV8jSWSvb0c4Lz2rapmmWQHsqY/ONVhpByE
         3XGtvM20VEgq7GbSzk7nxPKs8B3a5rMkGJmSBlg5uTV3XP2hOeCTee2K4YqKZoAzNQKt
         QrhnKxe+2Bc1BuNej97Pv2MDvN4e/17QXLgjAzxwLeABWuygJ1AgQBF7RM3ubeWKOPly
         cxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690850410; x=1691455210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQaJrQRUIiWVDCsAsh3n8+ThLFrN8Bh/awGWXHsDQe0=;
        b=TcD+wnio/ZDi95fmUFnQSyh63Hjj0evkQ5eGW/S7iknD9AUqwXgquiD2PQSC+4E48V
         e6iOWgJn7fw55kK6RDg4kbEPKYsRhKuze4P4c2xYgQBj6ABxZIcQaxbs/mEpHurVnhW1
         qdX4pwinqnHosuC4FQNoWqKTlJiSm4RhbznPpgwtUWwh+KVEBZKS9T0EfxUyohwQXowi
         JPSHmc4SU/GLOrIXtxsb438f8I+7/vtZ72orD+s7mRVgKqk5HZdkn/e3M4v8Kuc/Ia7G
         FImTNO2jj7e69KCSqhVLP1+tq1HRNWIG7J7fetdsEji/P36GkLn9Jw4tKr9DqqNlv/rP
         AuqA==
X-Gm-Message-State: ABy/qLYEYzqdfFbSyQQiL/vJeDM9SboIlX75PXJNQpFarWS+G47bctXd
	jhQ+AfoHlKfA1PDvSRvIUQL7ykL06PjQCjt1beHmQQ==
X-Google-Smtp-Source: APBJJlFeLAtZrNblceba5ioTZ4DaE3CnKkiRezjalaS8wXUAU6iXNC2RzAxTccCohDa4D2H3S0/XfoB4jVHw7a5eXhQ=
X-Received: by 2002:a05:6e02:1a09:b0:349:290:74e3 with SMTP id
 s9-20020a056e021a0900b00349029074e3mr626628ild.23.1690850410184; Mon, 31 Jul
 2023 17:40:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-5-rananta@google.com>
 <ZMgtwp/YCZciRvdr@google.com>
In-Reply-To: <ZMgtwp/YCZciRvdr@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 17:39:58 -0700
Message-ID: <CAJHc60xsNtnOpc8=XV_102A2sEESk=Scfhj7ktjNepQp2exw_A@mail.gmail.com>
Subject: Re: [PATCH v7 04/12] KVM: Allow range-based TLB invalidation from
 common code
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 31, 2023 at 2:55=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Sat, Jul 22, 2023, Raghavendra Rao Ananta wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..eb88d25f9896 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_tlb=
s_range(void)
> >       return kvm_x86_ops.flush_remote_tlbs_range;
> >  }
> >
> > -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > -                              gfn_t nr_pages)
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
>
> Please keep "nr_pages", I have a very strong preference for that over jus=
t "pages"
> as the "nr_" makes it super obvious that it's a single number, as opposed=
 to an
> array of pages or something.
>
Sure, I'll revert back to 'nr_pages'.

- Raghavendra
> And it doesn't truly matter, but IMO the gfn_t type is more appropriate s=
ince
> the gfn and the number of pages need to have the same type.

Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D9D1F187
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 20:17:46 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5169f614977so1824266a12.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 13:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686255464; x=1688847464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFfOuXxs8iGOdfT2qhI1JEq3SXtax8RxnY5/Fc1nskw=;
        b=tOrPL690XMDizppt1902CZdnVhRRGiAVY2h6pQOMPMquGW96yGqxA0WIbSxFO2hzYj
         QJWnaa2e9gObU8AZ2JFs1RnUAEJIDlYvyz3Vk0eN8oMhXzeUPdODFYrHIciSsxP+IkvB
         jQwIzPalMrRq9DKz/4lf8td/DpbRjoc5ifdZhGCvIzaMTootBnpupjCsIyoRUICz4e/t
         s7DCsNccifNfK4D9fga3PZMYqo8cjQOHa1g5+0GmjGcyvRnrUycsTbOan/Dr+m5rK0cw
         99nId16qyeJxOEnOuTWeiopCyGHCtsnDGSzjOlTPx/PNiWyaKL9qyVPA3bhi1oIBq4wV
         bWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686255464; x=1688847464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFfOuXxs8iGOdfT2qhI1JEq3SXtax8RxnY5/Fc1nskw=;
        b=hBiQYnB62nicvL7lDM+1MKugsaEfEkwg0Zo1GV6h6fzki6kpIqmsoAflsmaweUjGBw
         XENxSIiiM9bi6+RcBAPGa0wJ5aAkiNWYDgRR+6M46MCM2xE/eHS6CSaVBBZHbFZJXBj3
         tGm27i/KW2r8CsjPdJ92bhSxh2lQ9lHrQcbtupMqPgjRBBMKAov66oSI3ECtM25+Mwkx
         n+pvsoCXAlvKzO1UXW4LcPQ0kXPzuFC2eQXIYSCPYc+a3X9j5b15LrMlh1GOb8X5lPGE
         7X8+4/EqGbDN+0XY3ypGfjjlO6LVFLgP05yr7Wms6uFC3Sj3B4Q1UAM5FHsjpcYe6RUD
         Nqag==
X-Gm-Message-State: AC+VfDwUaMu9EUrW47YjdX8XZuvE2uOqlaF2QgcSV3oM6u+plY6R3oDO
	CXkr6qqISMdH+ie604xmyRsbrqQ5MRa1NVvkm0tvtg==
X-Google-Smtp-Source: ACHHUZ5rIRRCqsHv8Mj5sYTFvVoPuCCGYYh1ahL9p64lBD/iRVAni/xzcUb+JGKF5FFtYateiNco/3eYHVsT49XamTA=
X-Received: by 2002:a17:907:c13:b0:973:d846:cd5d with SMTP id
 ga19-20020a1709070c1300b00973d846cd5dmr154165ejc.74.1686255464184; Thu, 08
 Jun 2023 13:17:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com> <20230602160914.4011728-10-vipinsh@google.com>
 <20230605223520.00007fbd.zhi.wang.linux@gmail.com> <ZH9tQjQk7QLyhUQR@google.com>
 <20230607203711.000054ae.zhi.wang.linux@gmail.com>
In-Reply-To: <20230607203711.000054ae.zhi.wang.linux@gmail.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Thu, 8 Jun 2023 13:17:08 -0700
Message-ID: <CAHVum0dtZ2wW+itsOE=a7wwATu4VcGN-dQH1zF7Pz1LYy7J4UQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/16] KVM: arm64: Document the page table walker
 actions based on the callback's return value
To: Zhi Wang <zhi.wang.linux@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 7, 2023 at 5:37=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com> =
wrote:
>
> On Tue, 6 Jun 2023 10:30:42 -0700
> Vipin Sharma <vipinsh@google.com> wrote:
>
> > On Mon, Jun 05, 2023 at 10:35:20PM +0800, Zhi Wang wrote:
> > > On Fri,  2 Jun 2023 09:09:07 -0700
> > > Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > > Document what the page table walker do when walker callback functio=
n returns
> > > > a value.
> > > >
> > > > Current documentation is not correct as negative error of -EAGAIN o=
n a
> > > > non-shared page table walker doesn't terminate the walker and conti=
nues
> > > > to the next step.
> > > >
> > > > There might be a better place to keep this information, for now thi=
s
> > > > documentation will work as a reference guide until a better way is
> > > > found.
> > > >
> > >
> > > After reading the whole patch series, I was thinking it might be a go=
od
> > > time to improve the way how the visitor function and page table walke=
r
> > > talk to each other. The error code is good enough before, but its mea=
ning
> > > seems limited and vague when the visitor function wants to express mo=
re about
> > > what exactly happens inside. I am not sure if it is a good idea to co=
ntinue
> > > that way: 1. found a new situation. 2. choosing a error code for visi=
tor
> > > function. 3. walker translates the error code into the situation to
> > > handle. 4. document the error code and its actual meaning.
> > >
> > > Eventually I am afraid that we are going to abuse the error code.
> >
> > I agree that error numbers are not sufficient and this will become more
> > difficult and cumbersome for more cases in future if we need different
> > behavior based on different error codes for different visitor functions=
.
> >
> > >
> > > What about introducing a set of flags for the visitor function to exp=
ress
> > > what happened and simplify the existing error code?
> > >
> >
> > If I understood correctly what you meant, I think this will also end up
> > having the same issue down the line, we are just switching errors with
> > flags as they might not be able to express everything.
> >
> > "Flags for visitor function to express what happened"  - This is what
> > ret val and errors do.
> >
>
> Thanks so much for the efforts of the sample code.
>
> But when the "ret val" is an error code for pgtable matters, It turns vag=
ue.
> We have -EAGAIN to represent "retry" and "-ENONET" to represent PTE not t=
here,
> and they seems end up with different behaviors in different types of pgta=
ble
> walk. That is what I feels off.
>
> visitor_cb has two different requirements of returning the status: 1)
> something wrong happens *not* related to the pgtable, e.g. failing to
> allocate memory. 2) something happens related to the pgtable. e.g PTE doe=
sn't
> exists.
>
> For 1) It is natural to return an error code and the caller might just ba=
il out
> via its error handling path.
>
> I think the core problem is: the two different usages are mixed and they =
don't
> actually fit with each other. 2) is requiring more details in the future =
other
> than a simple error code.
>
>
> For 2) I think it is better have a set of flags. the name of the flags ca=
n
> carry more explicit meanings than error code. E.g.:
>
> ------------------
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/as=
m/kvm_pgtable.h
> index 4cd6762bda80..b3f24b321cd7 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -204,6 +204,15 @@ enum kvm_pgtable_walk_flags {
>         KVM_PGTABLE_WALK_HANDLE_FAULT           =3D BIT(4),
>  };
>
> +struct kvm_pgtable_walk_status {
> +       union {
> +               u8 raw;
> +               struct {
> +                       unsigned retry:1;
> +                       unsigned stop:1;
> +                       unsigned ignore:1;
> +                       /* more to come */
> +               };
> +       };
> +};
> +
>  struct kvm_pgtable_visit_ctx {
>         kvm_pte_t                               *ptep;
>         kvm_pte_t                               old;
> @@ -213,8 +222,10 @@ struct kvm_pgtable_visit_ctx {
>         u64                                     end;
>         u32                                     level;
>         enum kvm_pgtable_walk_flags             flags;
> +       struct kvm_pgtable_walk_status          *status;
>  };
>
>  typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_c=
tx *ctx,
>                                         enum kvm_pgtable_walk_flags visit=
);
>
> ----------------
>
> Visitor functions sets the flags via ctx->status and kvm_pgtable_walk_xxx=
 can
> check the bits in the ctx to decide what to do for the next.
>
> I can cook a patch for re-factoring this part if we think it is a good id=
ea.
>

This can also be one option. I will wait till others also weigh in on
how to make walkers and callbacks work together for more use cases.

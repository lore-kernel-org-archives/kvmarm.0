Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F376AB6
	for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 12:21:10 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b01d3bb571so16467335ad.2
        for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 05:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685362870; x=1687954870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1Xvm17u+rCjsDQtsTRP4IW4hFNIZBwFcy3OF7utEfQ=;
        b=Iztf9BjgqoBy2nQa3hkO+Tngf5xL010erKXp2+fhMwz3aX9O/8sSXatTJ3RNWPKclo
         g2l+VY5BGH9IhFLnqtVx86UQ73tyBQSH9LS5AvJDga5jLPu3osDLC/hgypHvEYpHJSAs
         hQivyn1v/BqgEftAJZygsVyp9VbYp1ODqY+9qjs7zM8XiFp83jqB0CATWAzDoEC1+sxC
         QKr/Bfh3+hjkXgFSx0wr57sFBwgsOOltT3nqi8RjRAMiS3KN0hlaGn+104yyCuexGKSn
         4IBQLshG/UjbrGgRrJGUbvnm66TINLet3rtQUncCJXsvkeug+HzRBpXvwAjx/02XD5G3
         6Z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685362870; x=1687954870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1Xvm17u+rCjsDQtsTRP4IW4hFNIZBwFcy3OF7utEfQ=;
        b=Ua6+oKGcxs3icX+glHh0fpmZaGgHbbFCQeJAu/iAee0ZodDf3Twv1TeYvoEVC/3s/O
         fCirgbP4d+ZMU8EIi37Jv4g7SVLpYcGmus3glLxJ93LIbJ9vac9gVNl8i11bCRNVNjx4
         LLH39NviU0iAP3tKehvUpEqsB9PLtrJBy3FshLnjVcr3mCdj53gDZyaA25m19qgfN6e5
         6VCaauxwpqfksDCY+39J0VvvCInzY9vsXupfxVtUgd7J5u03dS6jeCqIpwQJTlDS7Odj
         rjZOTzr0AMr+Pu1YqWRsV5v5AID1Rah4BkxBO7cPI3vkT0DVX8oaCPJpsAv1oOaI5a/s
         ReZw==
X-Gm-Message-State: AC+VfDyJY1dJ5WaQUKq13sCnheD/E77QVVpOkOAWmfuTMrYzt4KROJ+J
	FupMNu3QyiiwcupnI5lr74SZwkHpDPXEQEhNZ40=
X-Google-Smtp-Source: ACHHUZ6OkV3SZbwpjCqJa57IyIdEql6pFjbanDcFk7ZJ7Rj1kSsJag0dj6+D0yo7FilJN1xbZcoFIMZn3k8nj6DrI08=
X-Received: by 2002:a17:902:8218:b0:1af:bcf7:2bd8 with SMTP id
 x24-20020a170902821800b001afbcf72bd8mr8700574pln.52.1685362869847; Mon, 29
 May 2023 05:21:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1684999824.git.haibo1.xu@intel.com> <da390e6200e838fce320a2a43b2f87951b4e0bbb.1684999824.git.haibo1.xu@intel.com>
 <20230525-2bab5376987792eab73507ac@orel> <CAJve8o=5ji5D-S8k+GaGd7sH7KXNWxDaWhD3jyxtHizKSMtjbA@mail.gmail.com>
 <20230529-7b3e41e6aca55f9e90dd6cd3@orel>
In-Reply-To: <20230529-7b3e41e6aca55f9e90dd6cd3@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 29 May 2023 20:20:58 +0800
Message-ID: <CAJve8o=wX+Lb84YeGBa9anp+eZnrgvTW6AOVgoeUnHZu7eWswA@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: riscv: selftests: Add get-reg-list test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 3:08=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, May 27, 2023 at 12:39:57PM +0800, Haibo Xu wrote:
> > On Fri, May 26, 2023 at 1:18=E2=80=AFAM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> > > On Thu, May 25, 2023 at 03:38:35PM +0800, Haibo Xu wrote:
> ...
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.a6),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.a7),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s2),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s3),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s4),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s5),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s6),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s7),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s8),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s9),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s10),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.s11),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.t3),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.t4),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.t5),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(regs.t6),
> > >
> > > ...all the above would just be indices rather than named registers. I
> > > guess that's better for these registers.
> > >
> >
> > You mean to show it as KVM_REG_RISCV_CORE_REG(regs.regs[0]) ...
> > KVM_REG_RISCV_CORE_REG(regs.regs[31])?
> >
>
> I'm OK with these registers using their names in this list, it does look
> better. However the original idea for these lists was that they would be
> generated from print_reg(). In this case, print_reg() is generating them
> with their number instead of name. Either print_reg() could learn how to
> generate their names by handling the offset ranges of each register type,
> e.g.
>
> switch (reg_off) {
> case 10 ... 17:
>    strdup_printf("... KVM_REG_RISCV_CORE_REG(regs.a%d),", reg_off - 10);
>
> or we can use the numbers here in this list, or we can leave it as you
> have it (i.e. done manually).
>

I agree that the print_reg() should print the register name instead of
the register offset.
It may be better to manually encode/decode the register offset to name
case by case
in the print_reg() since we just need to handle it once. Will update it in =
v3.

Thanks,
Haibo

> Thanks,
> drew

Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62AF17EF
	for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 01:55:27 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f86dbce369so4323998e87.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 18:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687312525; x=1689904525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wz+JcRD5iqUFNC0O0Ru60ZgS8tD+DjfgbMM6b7JgDDE=;
        b=I4Xks4H0f9hjuiTto0xGg2qYpfM1NZn0dyFE3RFSgjOTxwdHLkw2aJFM6SQ4UPOBl2
         dNK6TDWAZALS3CRzxzO+dpAo1U9mCItEUs562QTVmbmesDW2NSyCOoPgJOgoYQAz7I81
         HLw63JGcQ4kMncWwX/yetxeXc4t9tZnic1kQbgvD1AUCJKn28T1HFnucS8Q2s7Nx+DQZ
         f8U5MS+CPM3LZ1R10maFt1FXao1Rfu9UuLwRlmRiKcyG4Eu87O2mrDltGfJ0J9bBeZ4/
         piitDPizcx0RsJDQqHWespeaFg6I0iuKgvJ4MSz6hINYPHYT0FU7ayv5Ygm+4xicdr1J
         wVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687312525; x=1689904525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wz+JcRD5iqUFNC0O0Ru60ZgS8tD+DjfgbMM6b7JgDDE=;
        b=dGJVlG23g/AAKugj9Kb9sZmXm28uSgCFrrJF6h5TgSOUQjukAo9Couhaca4UqSazZn
         Ez5TZLz+fZzlNt9VW7+/FFruV2m1CDckrAz+eaGZ0eXBeWOHjLsgqiXIxo95+BUJK2w1
         gksIWBnzTUNGWji0vKOKRq98rxTG8bmqDx4M7ZCoh15KN5LKhUmsUbWZY/Ai0sFMaJqJ
         DrIPMcF6sxlUiYD58IJFB0WwOIjeujvwiGQykDROdpwettpFQ9aORoIHfJiNPMJyVbuN
         +9v3/XLxGQNGZzRkbk3M+sorS7Xz66hxi9m9JY/zJzEVox0KCVi0IeqrvyGpJkkQMB1E
         xVPg==
X-Gm-Message-State: AC+VfDxromNK48u2EuI1mND9nRqC0FQqfe6GSXFFO3XAqFIdCrOfm+RE
	7dE5e0khFHfWKmXXGPlus+fkUqvJINPRFaxpZko=
X-Google-Smtp-Source: ACHHUZ6wY9wkDAsQKF4/pJB6A70/338sp9DCerB/qo1fiLgVSLjXYq0d7uPy8bn+2oY5S0+fhyThzcL/uGhJOGcqvb4=
X-Received: by 2002:a05:6512:1cd:b0:4f9:573a:689d with SMTP id
 f13-20020a05651201cd00b004f9573a689dmr610014lfp.37.1687312525203; Tue, 20 Jun
 2023 18:55:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1686275310.git.haibo1.xu@intel.com> <8cd4ce50f5f4a639f4508085959aae222d4d4386.1686275310.git.haibo1.xu@intel.com>
 <20230609-fba04b424a4d46574e04e587@orel> <CAJve8okjRZEt6_6SB9EWm+6c7utpExzenfWo2T1N-J6G9w9czQ@mail.gmail.com>
 <20230620-95ce8ab70956a72b9da3a31a@orel>
In-Reply-To: <20230620-95ce8ab70956a72b9da3a31a@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 21 Jun 2023 09:55:13 +0800
Message-ID: <CAJve8onNFfHFcvAGkbtnxjzqgfq4geL1zOwJEc8Xzc=NHVDrFg@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] KVM: riscv: selftests: Add get-reg-list test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Gardon <bgardon@google.com>, 
	David Matlack <dmatlack@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2023 at 6:44=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Tue, Jun 20, 2023 at 06:05:59PM +0800, Haibo Xu wrote:
> > On Fri, Jun 9, 2023 at 9:35=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > On Fri, Jun 09, 2023 at 10:12:18AM +0800, Haibo Xu wrote:
> > > > +static struct vcpu_reg_list aia_config =3D {
> > > > +     .sublists =3D {
> > > > +     BASE_SUBLIST,
> > > > +     AIA_REGS_SUBLIST,
> > > > +     {0},
> > > > +     },
> > > > +};
> > > > +
> > > > +static struct vcpu_reg_list fp_f_d_config =3D {
> > > > +     .sublists =3D {
> > > > +     BASE_SUBLIST,
> > > > +     FP_F_REGS_SUBLIST,
> > > > +     FP_D_REGS_SUBLIST,
> > > > +     {0},
> > > > +     },
> > > > +};
> > > > +
> > > > +struct vcpu_reg_list *vcpu_configs[] =3D {
> > > > +     &zicbo_config,
> > > > +     &aia_config,
> > > > +     &fp_f_d_config,
> > > > +};
> > > > +int vcpu_configs_n =3D ARRAY_SIZE(vcpu_configs);
> > > > --
> > > > 2.34.1
> > > >
> > >
> > > I see we have a bit of a problem with the configs for riscv. Since we
> > > don't disable anything we're not testing, then for any test that is
> > > missing, for example, the f and d registers, we'll get output like
> > > "There are 66 new registers. Consider adding them to the blessed reg
> > > list with the following lines:" and then a dump of all the f and d
> > > registers. The test doesn't fail, but it's messy and confusing. Ideal=
ly
> > > we'd disable all registers of all sublists not in the config, probabl=
y
> > > by starting by disabling everything and then only reenabling the ones
> > > in the config.
> > >
> > > Anything that can't be disabled is either a KVM bug, i.e. we should
> > > be able to disable it, because we can't expect every host to have it,
> > > or it needs to be in the base register sublist (meaning every host
> > > will always have it).
> > >
> >
> > HI Andrew,
> >
> > I found several multi-letters ISA EXT(AIA/SSTC etc) were not allowed
> > to be disabled.
> > Is it a bug? shall we fix it=EF=BC=9F
>
> Extensions that a guest could use (regardless of whether or not the host
> described it in the guest's isa string), because the instructions or CSR
> accesses don't trap, can't truly be disabled. So, it's not a bug to
> prohibit disabling them and indeed the test cases should actually ensure
> disabling them fails.
>

So these kinds of ISA_EXT_* regs should be in the base reg list, right?

Thanks,
Haibo

> Thanks,
> drew

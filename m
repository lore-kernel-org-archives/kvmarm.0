Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0612F8BF8
	for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 08:45:31 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b46f5f4d79so46838121fa.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 01:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687337130; x=1689929130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYIw9zUPZWZ2o+QN5fG2PRt2gO03dubW8fyBAMQKZLE=;
        b=qCW19/pbsOnWIPKRDK74psGxSYvuSBgLbZKbYaLkXRj8HGXRWFkCqN6ysyA2wMI1sJ
         M6Hu+XCvThIRolfER9vvD7qSoYNTz3tVirW3vUlmab7wwpnKgtxoVWzjEA1w75vgmdaC
         zPZiauwtpHfapncsJTrYOmxGzcTKOZaIAI7qf6hWfpPBVAjNDBCSVIswVtTQsbrFTdUl
         vFZJP+LgHa3YlMETckvBWqL7D/wG/w+eIHVRbEMh11gqKkTNQiU0QhPhQP0VVbyp7fAf
         nZLmNVSvaQsw2l3vcfsWOUqoXgQ083lQn7APLu//1YLpw8Mb+mOvlFL8bvKE3ftwMG16
         VEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687337130; x=1689929130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lYIw9zUPZWZ2o+QN5fG2PRt2gO03dubW8fyBAMQKZLE=;
        b=dgD7FQVJycChvYSCDrOxkiSSGrK1hDzzK5J0TmAQuew3skJLHT101fwCoZHgUdKaE6
         jthgdD7iLsdoLOXS+d4o4JltVxbYhYOQMv3eKsUh7n7HeNZEFC1gKu5EM7wQJPD32vUJ
         DKlSsXBEuYaJZWxwtjcJ5gFadWBKlZRT+wnXqlgYeu4GRo7QDCdBKvRJqSY0z0C90jwM
         K+FDT3v0jv0OdI71GXhPsHYwiliYQvcL3yNCEvFsvRc++Z4pdIydsL+0xiJOqZDVhx4z
         6bLFZeT7GlTCnmUQ/FjejubK7w4rQfgr12ZAMuQS1cKn7w/KpdjcKaLu4QltgXvmEyPT
         hY2Q==
X-Gm-Message-State: AC+VfDzTFkVDHWfFzHv11TP4LzRTfsO4FdnYz/Yn5OmsLMFfiYGwdZUa
	XLXUg7wqkq6cDAPgMGpEQIA/kbl3Nk3/GmOHF+A=
X-Google-Smtp-Source: ACHHUZ4BrKigQscUYyAgK2m2X7YOR2aGI6Htk1A+97xpwtjx/lbr6R6ahZTgONsoUBJEA53I5JDdW30GyqH39ENS4FU=
X-Received: by 2002:a05:651c:10b0:b0:2b4:7910:36a3 with SMTP id
 k16-20020a05651c10b000b002b4791036a3mr3026730ljn.0.1687337129513; Wed, 21 Jun
 2023 01:45:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1686275310.git.haibo1.xu@intel.com> <8cd4ce50f5f4a639f4508085959aae222d4d4386.1686275310.git.haibo1.xu@intel.com>
 <20230609-fba04b424a4d46574e04e587@orel> <CAJve8okjRZEt6_6SB9EWm+6c7utpExzenfWo2T1N-J6G9w9czQ@mail.gmail.com>
 <20230620-95ce8ab70956a72b9da3a31a@orel> <CAJve8onNFfHFcvAGkbtnxjzqgfq4geL1zOwJEc8Xzc=NHVDrFg@mail.gmail.com>
 <20230621-37ea9461250036cc2ec8c544@orel>
In-Reply-To: <20230621-37ea9461250036cc2ec8c544@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 21 Jun 2023 16:45:18 +0800
Message-ID: <CAJve8omtMhHvH1huOanu+UfsJLZxGnFs6=pnuZzGvm1O1wbw+g@mail.gmail.com>
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

On Wed, Jun 21, 2023 at 3:30=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Wed, Jun 21, 2023 at 09:55:13AM +0800, Haibo Xu wrote:
> > On Tue, Jun 20, 2023 at 6:44=E2=80=AFPM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> > > On Tue, Jun 20, 2023 at 06:05:59PM +0800, Haibo Xu wrote:
> > > > On Fri, Jun 9, 2023 at 9:35=E2=80=AFPM Andrew Jones <ajones@ventana=
micro.com> wrote:
> > > > >
> > > > > On Fri, Jun 09, 2023 at 10:12:18AM +0800, Haibo Xu wrote:
> > > > > > +static struct vcpu_reg_list aia_config =3D {
> > > > > > +     .sublists =3D {
> > > > > > +     BASE_SUBLIST,
> > > > > > +     AIA_REGS_SUBLIST,
> > > > > > +     {0},
> > > > > > +     },
> > > > > > +};
> > > > > > +
> > > > > > +static struct vcpu_reg_list fp_f_d_config =3D {
> > > > > > +     .sublists =3D {
> > > > > > +     BASE_SUBLIST,
> > > > > > +     FP_F_REGS_SUBLIST,
> > > > > > +     FP_D_REGS_SUBLIST,
> > > > > > +     {0},
> > > > > > +     },
> > > > > > +};
> > > > > > +
> > > > > > +struct vcpu_reg_list *vcpu_configs[] =3D {
> > > > > > +     &zicbo_config,
> > > > > > +     &aia_config,
> > > > > > +     &fp_f_d_config,
> > > > > > +};
> > > > > > +int vcpu_configs_n =3D ARRAY_SIZE(vcpu_configs);
> > > > > > --
> > > > > > 2.34.1
> > > > > >
> > > > >
> > > > > I see we have a bit of a problem with the configs for riscv. Sinc=
e we
> > > > > don't disable anything we're not testing, then for any test that =
is
> > > > > missing, for example, the f and d registers, we'll get output lik=
e
> > > > > "There are 66 new registers. Consider adding them to the blessed =
reg
> > > > > list with the following lines:" and then a dump of all the f and =
d
> > > > > registers. The test doesn't fail, but it's messy and confusing. I=
deally
> > > > > we'd disable all registers of all sublists not in the config, pro=
bably
> > > > > by starting by disabling everything and then only reenabling the =
ones
> > > > > in the config.
> > > > >
> > > > > Anything that can't be disabled is either a KVM bug, i.e. we shou=
ld
> > > > > be able to disable it, because we can't expect every host to have=
 it,
> > > > > or it needs to be in the base register sublist (meaning every hos=
t
> > > > > will always have it).
> > > > >
> > > >
> > > > HI Andrew,
> > > >
> > > > I found several multi-letters ISA EXT(AIA/SSTC etc) were not allowe=
d
> > > > to be disabled.
> > > > Is it a bug? shall we fix it=EF=BC=9F
> > >
> > > Extensions that a guest could use (regardless of whether or not the h=
ost
> > > described it in the guest's isa string), because the instructions or =
CSR
> > > accesses don't trap, can't truly be disabled. So, it's not a bug to
> > > prohibit disabling them and indeed the test cases should actually ens=
ure
> > > disabling them fails.
> > >
> >
> > So these kinds of ISA_EXT_* regs should be in the base reg list, right?
> >
>
> Ah, this is getting a bit messy. We don't want all these extensions in a
> "base", which represents extensions for all possible hosts, because the
> extensions are optional, but, we can't remove them from get-reg-list
> output by disabling them, since they can't be disabled. It seems we
> need the concept of "base", which is the common set expected on all hosts=
,
> and also the concept of "this host's base". I'm struggling to think of
> a nice way to deal with that. A first thought is to both add these types
> of registers to their own extension-specific sublists and to filter_reg()=
.
> I think that will keep them from being reported as new registers in every
> test, but also allow detection of them going missing when they're
> extension is present.
>

Yes, I was also stuck with the mess!

I was trying one way to only include `disable not allowed` regs to the
base reg list and
only check errno for disable(set 0) operation.

I will also try your suggestion and let you know the results soon!

Thanks,
Haibo

> Thanks,
> drew

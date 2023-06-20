Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700F68464
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 10:06:13 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b47354c658so34639381fa.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 03:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687255571; x=1689847571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtXc4PCbTDlAHZAVqhvtwaRICGJ6lazGNb1ljaV+Ftw=;
        b=ldW/ylsuWZH3AXZueyYlRT0nh9Gl/MhIKISAju1Ir5dsyEDOYv8I/dKPmBee/odzkK
         SDbVl0f1M1Z+H7UtPcorlVsRZ1YEUg+5forY69CwXp/YyhIvg9aUPWStKrGV2gmYsZNf
         NowMzGu9Th8C8x1f9CVWdoHwEa07JlDa8276RyVLTkeEuOuDgoqnuPXbaJN0RQp9CxTN
         scEmXUBZ0g6uTFZ/EWqPVXJUnHpeqXlZJ82NBJRiFQfJgWE85T8UqdlMfqHEootOMNc4
         iiLGC6mmOBawCmItBjo8MjcoUJOAgAXU+CIrdSEtjUQzRSJ6ljr4Z5qpcnpXOjSwCxRp
         vlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687255571; x=1689847571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wtXc4PCbTDlAHZAVqhvtwaRICGJ6lazGNb1ljaV+Ftw=;
        b=YpV10uUXx2nHZbGcksGUXxSg9kQHFWTUsKhp32OZhixRz+u0s2StOqLOJPn1lNgb+1
         bdwBBLhmf3MHY4nDwlCMdOwu+oe3OqhUWw3h86D1lS/QUeh5iJOWM5dtmH/3H8Ljjesw
         9P2vuCzd9+AafxPJWLurfiu4JhM7EIRbkie/mCl/f1dEurNq4l964RoYtwS0tWUVEuJk
         P5eiqSABKCy/LtPzPhLUqlU7sSHyMTfUiqnp+ddqro+s2Oxz20M2aElznGkVCM6IvVuY
         HPabmhzy49w8h+v0acy/SkRMLvUxTFLNNPgmfB6mnONJo3n84OIokLiMzRkXWw1kXM9p
         fOZw==
X-Gm-Message-State: AC+VfDw0HjH0qhzbky3Akgp6lBLR5VSKp0SkUpEQpJLakJ9ySPSRcP7w
	OdpyCSf6fRb9T2bwQ5bFo4p4OlMe2Bf4ULFn/wM=
X-Google-Smtp-Source: ACHHUZ7b29WcQEpJBxPgynKh2dxcEjQKO63R0QvBncBcn4CVZjBKqj6DvExU9PFON2qlRV1iXePc6q0qi5nDf7A9U3Q=
X-Received: by 2002:a2e:9b06:0:b0:2b1:dc7a:ebf2 with SMTP id
 u6-20020a2e9b06000000b002b1dc7aebf2mr7647520lji.17.1687255570896; Tue, 20 Jun
 2023 03:06:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1686275310.git.haibo1.xu@intel.com> <8cd4ce50f5f4a639f4508085959aae222d4d4386.1686275310.git.haibo1.xu@intel.com>
 <20230609-fba04b424a4d46574e04e587@orel>
In-Reply-To: <20230609-fba04b424a4d46574e04e587@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Tue, 20 Jun 2023 18:05:59 +0800
Message-ID: <CAJve8okjRZEt6_6SB9EWm+6c7utpExzenfWo2T1N-J6G9w9czQ@mail.gmail.com>
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

On Fri, Jun 9, 2023 at 9:35=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Fri, Jun 09, 2023 at 10:12:18AM +0800, Haibo Xu wrote:
> > +static struct vcpu_reg_list aia_config =3D {
> > +     .sublists =3D {
> > +     BASE_SUBLIST,
> > +     AIA_REGS_SUBLIST,
> > +     {0},
> > +     },
> > +};
> > +
> > +static struct vcpu_reg_list fp_f_d_config =3D {
> > +     .sublists =3D {
> > +     BASE_SUBLIST,
> > +     FP_F_REGS_SUBLIST,
> > +     FP_D_REGS_SUBLIST,
> > +     {0},
> > +     },
> > +};
> > +
> > +struct vcpu_reg_list *vcpu_configs[] =3D {
> > +     &zicbo_config,
> > +     &aia_config,
> > +     &fp_f_d_config,
> > +};
> > +int vcpu_configs_n =3D ARRAY_SIZE(vcpu_configs);
> > --
> > 2.34.1
> >
>
> I see we have a bit of a problem with the configs for riscv. Since we
> don't disable anything we're not testing, then for any test that is
> missing, for example, the f and d registers, we'll get output like
> "There are 66 new registers. Consider adding them to the blessed reg
> list with the following lines:" and then a dump of all the f and d
> registers. The test doesn't fail, but it's messy and confusing. Ideally
> we'd disable all registers of all sublists not in the config, probably
> by starting by disabling everything and then only reenabling the ones
> in the config.
>
> Anything that can't be disabled is either a KVM bug, i.e. we should
> be able to disable it, because we can't expect every host to have it,
> or it needs to be in the base register sublist (meaning every host
> will always have it).
>

HI Andrew,

I found several multi-letters ISA EXT(AIA/SSTC etc) were not allowed
to be disabled.
Is it a bug? shall we fix it=EF=BC=9F

Thanks,
Haibo

static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 {
     switch (ext) {
     case KVM_RISCV_ISA_EXT_A:
     case KVM_RISCV_ISA_EXT_C:
     case KVM_RISCV_ISA_EXT_I:
     case KVM_RISCV_ISA_EXT_M:
     case KVM_RISCV_ISA_EXT_SSAIA:
     case KVM_RISCV_ISA_EXT_SSTC:
     case KVM_RISCV_ISA_EXT_SVINVAL:
     case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
     case KVM_RISCV_ISA_EXT_ZBB:
         return false;
     default:
         break;
     }

     return true;
 }

> Thanks,
> drew

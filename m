Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CA4EA9
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 03:57:14 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2bd0d19a304so9304161fa.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 20:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694059032; x=1694663832; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UQs6noN/LuXhMaxtbcJru+m5+v+IlSKIcqynK+aM9Y=;
        b=A5TZQObb9Hs31U/3rV9PJPDpGWshGPnvasyFIzfvvzN73prdJcShUGbCj7RgmFt4+O
         vz8krOr0ma/r4IlYtc2GhHxxOdurd08klDLP2iZ/qmbPro0KaB3Uikwwq4K5XyYhm7FU
         MIBWuxKBSS1y0tZvy1l7NbmuvOtX+XaVu/1Ax8/4qCyYYeTlaJ31XabMVXg19f0eOfbj
         1hOp17XkK0TaHgCSTqF1JNr3l7spAYtkzIcOidW2OVq8Mem73rannefTF0yElm1WoQFo
         dyLzcmdxELaQdlAoxF9klHPHDMKTMrhP6OoUEzo8QO8n8I34Ff7u8/VCoVCWWvBcMGK9
         xcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694059032; x=1694663832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UQs6noN/LuXhMaxtbcJru+m5+v+IlSKIcqynK+aM9Y=;
        b=ZCZ4Vq0e2El8XJmzDa/d25S71gEQDf2HntLwvvOLLctqwae3lbfLh9BuRwQQ5K2jdw
         P4k8RnJm6zJ8yFMY+fFFJMAwwnWgRODWreHpFAXhoFAy8zoBhcKjEexFO7WhSXtUm1n2
         7r/bs4w1dDUlmmO2BDSDj9phKsi31jKvh7aNMJhazDn/2jRAevp5JGp58EPXCWF6NLVl
         jPhzib1Z2I7x+vDA4ZB5WCCPLVHT5Co2X8X8NElM6JFLyJXL3kvC1O3qiDaATenQLotI
         TCeYLCshfBX8j7co0nKNJYr87QGN81Gr1H+4D+zaPqxcipXwfevk8rmEMAnrAVEbnxPQ
         DrNQ==
X-Gm-Message-State: AOJu0YxY+mh5Nlm/LKJoqsy3dO7nhlb/gnXxuvqmSCkrj5EAb8L7DDMO
	sMsaWihMOehq4Tk3AxFyILw3GrWJ/jetTDD6oYU=
X-Google-Smtp-Source: AGHT+IGI6qgIYSsAicMI6I+r6ioP3/2vp5QnhFlwnPmei3QJDcCP4J/D9Z4FZEYYhTF0QZ1jr8qCxHSm6ZraniakZgA=
X-Received: by 2002:a2e:9c10:0:b0:2bc:b70d:9cb5 with SMTP id
 s16-20020a2e9c10000000b002bcb70d9cb5mr3530939lji.33.1694059032084; Wed, 06
 Sep 2023 20:57:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <b6ef1b031e3a581f481cf19a26623388163444b4.1693659382.git.haibo1.xu@intel.com>
 <20230904-aa8b0d8d23d391586686038a@orel> <CAJve8ok5cU+h1K+WJ+aDpB+u+PBo8XosUyyVbMGy-xR0XiWFdw@mail.gmail.com>
In-Reply-To: <CAJve8ok5cU+h1K+WJ+aDpB+u+PBo8XosUyyVbMGy-xR0XiWFdw@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 7 Sep 2023 11:57:00 +0800
Message-ID: <CAJve8om+dLcG+4trDfG1yx8vhj52RhPZrJoF-emWDX+OPM088A@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] KVM: riscv: selftest: Change vcpu_has_ext to a
 common function
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, wchen <waylingii@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Matlack <dmatlack@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Jim Mattson <jmattson@google.com>, Lei Wang <lei4.wang@intel.com>, 
	Vipin Sharma <vipinsh@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, Like Xu <likexu@tencent.com>, 
	Peter Gonda <pgonda@google.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, Paul Durrant <paul@xen.org>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 6, 2023 at 6:10=E2=80=AFPM Haibo Xu <xiaobo55x@gmail.com> wrote=
:
>
> On Mon, Sep 4, 2023 at 10:04=E2=80=AFPM Andrew Jones <ajones@ventanamicro=
.com> wrote:
> >
> > On Sat, Sep 02, 2023 at 08:59:29PM +0800, Haibo Xu wrote:
> > > diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools=
/testing/selftests/kvm/riscv/get-reg-list.c
> > > index d8ecacd03ecf..c4028bf32e3f 100644
> > > --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > @@ -44,20 +44,6 @@ bool check_reject_set(int err)
> > >       return err =3D=3D EINVAL;
> > >  }
> > >
> > > -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > > -{
> > > -     int ret;
> > > -     unsigned long value;
> > > -
> > > -     ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> > > -     if (ret) {
> > > -             printf("Failed to get ext %d", ext);
> > > -             return false;
> > > -     }
> > > -
> > > -     return !!value;
> >
> > get-reg-list will now assert on get-reg when an extension isn't present=
,
> > rather than failing the __TEST_REQUIRE(), which would do a skip instead=
.
> > We need both the return false version and the assert version.
> >
>
> Ok, Will keep this one for get-reg-list and add another one for
> arch-timer specific usage.
>

Just thought about it again, maybe we only need the "return false"
version for both get-reg-list
and arch-timer tests since if an extension was not available, the test
can be skipped with a message.

bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
{
       unsigned long value =3D 0;

       __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);

       return !!value;
}

> > > -}
> > > -
> > >  void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> > >  {
> > >       struct vcpu_reg_sublist *s;
> > > --
> > > 2.34.1
> > >
> >
> > Thanks,
> > drew

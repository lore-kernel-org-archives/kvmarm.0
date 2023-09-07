Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDED1C31
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 09:18:39 +0000 (UTC)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2bb9a063f26so12864401fa.2
        for <kvmarm@lists.linux.dev>; Thu, 07 Sep 2023 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694078317; x=1694683117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBBEzL7qY3uq6+ZqigJzuGuvME9kRMD/negQGQFd1kU=;
        b=ZljiZShQQbsUJq0lBzI+d0Xc1+JNkX59ueBX7SwQy8UwMKZ/0ReOFU+3zh6MGRBZGT
         5ovNjtUqqrKBYgZByLp86EQ42yYUgbNW5Nv9Y8SHf4KpJllvdv/7AUjsYxnQeln3Dfwp
         kz0Yadnob+27TZR/+p0aAHTlgfTJ1zGIZ17NkSsuzqfy7J5tXQF7k/y9/oGfxO7BsB0N
         LJ04HSkzrNyUvTLOJPxyr7HzbSpkaS9IzLY48fLeO+iEMA41040TRBG0fGFl+/sGA3dQ
         vp6xIOwPlTOJonehiJUGGZQp57dg18MTSC/I9ai2wwT/rW8aarj90bGzwVX6HUJqsWZc
         vtdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694078317; x=1694683117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBBEzL7qY3uq6+ZqigJzuGuvME9kRMD/negQGQFd1kU=;
        b=YSLr/hkfqcg3YGweYj+c6bPrJLYubHaMcAbW9juGVIdOaSv0QoZVyGmU+Ldr/Ss1ng
         PA8+XGJ4KAq6Whk2yWYqZo1tPnCgdae8mmDq23c/LmSodj2+U7f9BugVLNLF7NSH/vmb
         3WeRgAJTZe4zfTrWXlZJfVNYYTA1XK81Ic3cy1Up4rD77Q1LCFHhu4tAccrXoR+0B49B
         02etmXZ3RR10Bv9ytlBNB6wde4/A5khecsZMmhEuhwST5R0O70YyitNkeunSXdqjNCHv
         raF4l8AFe9fh8fzu6fsgwmwsyI/FzqAxl3z0eX9yL7cokDlRc7IlKTCJd9UmeNN+xOpQ
         xI7A==
X-Gm-Message-State: AOJu0YyURYDdFZL49c543mcktOl0WBiLfT7s9ZwfZpg7/mqNA0uOy0e2
	hq2V1MPw8W+ZYF7P4/t67HmlYOkcNHJg0oaOexo=
X-Google-Smtp-Source: AGHT+IF10+wenAf/r4lgyEOBY89UZGCOdwUC3J+LpxGhdoe1wYTW/cIeqheprklSo2IBVjz46fa7sLxs5xkSY5w4zLI=
X-Received: by 2002:a2e:804c:0:b0:2bc:c830:4cbb with SMTP id
 p12-20020a2e804c000000b002bcc8304cbbmr3729686ljg.45.1694078317171; Thu, 07
 Sep 2023 02:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <b6ef1b031e3a581f481cf19a26623388163444b4.1693659382.git.haibo1.xu@intel.com>
 <20230904-aa8b0d8d23d391586686038a@orel> <CAJve8ok5cU+h1K+WJ+aDpB+u+PBo8XosUyyVbMGy-xR0XiWFdw@mail.gmail.com>
 <CAJve8om+dLcG+4trDfG1yx8vhj52RhPZrJoF-emWDX+OPM088A@mail.gmail.com> <20230907-bde62d037a3aaeedfe31f964@orel>
In-Reply-To: <20230907-bde62d037a3aaeedfe31f964@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 7 Sep 2023 17:18:25 +0800
Message-ID: <CAJve8okJOHofRK=0VRG8QPetOgk_WexEui_3UtEKk+4x1iPwMA@mail.gmail.com>
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

On Thu, Sep 7, 2023 at 5:01=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Sep 07, 2023 at 11:57:00AM +0800, Haibo Xu wrote:
> > On Wed, Sep 6, 2023 at 6:10=E2=80=AFPM Haibo Xu <xiaobo55x@gmail.com> w=
rote:
> > >
> > > On Mon, Sep 4, 2023 at 10:04=E2=80=AFPM Andrew Jones <ajones@ventanam=
icro.com> wrote:
> > > >
> > > > On Sat, Sep 02, 2023 at 08:59:29PM +0800, Haibo Xu wrote:
> > > > > diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/t=
ools/testing/selftests/kvm/riscv/get-reg-list.c
> > > > > index d8ecacd03ecf..c4028bf32e3f 100644
> > > > > --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > > > +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > > > > @@ -44,20 +44,6 @@ bool check_reject_set(int err)
> > > > >       return err =3D=3D EINVAL;
> > > > >  }
> > > > >
> > > > > -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > > > > -{
> > > > > -     int ret;
> > > > > -     unsigned long value;
> > > > > -
> > > > > -     ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value=
);
> > > > > -     if (ret) {
> > > > > -             printf("Failed to get ext %d", ext);
> > > > > -             return false;
> > > > > -     }
> > > > > -
> > > > > -     return !!value;
> > > >
> > > > get-reg-list will now assert on get-reg when an extension isn't pre=
sent,
> > > > rather than failing the __TEST_REQUIRE(), which would do a skip ins=
tead.
> > > > We need both the return false version and the assert version.
> > > >
> > >
> > > Ok, Will keep this one for get-reg-list and add another one for
> > > arch-timer specific usage.
> > >
> >
> > Just thought about it again, maybe we only need the "return false"
> > version for both get-reg-list
> > and arch-timer tests since if an extension was not available, the test
> > can be skipped with a message.
> >
> > bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > {
> >        unsigned long value =3D 0;
> >
> >        __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> >
> >        return !!value;
> > }
>
> Yup, I had actually seen that when reviewing a later patch in this series=
,
> but I wasn't concerned if we added the assert type anyway, since we
> frequently end up with the two function types for KVM queries. If we don'=
t
> have a need for an assert type yet, then we don't need to introduce it.
> However, we should introduce the non-assert type as __vcpu_has_ext(),
> reserving the vcpu_has_ext() name for the assert type, per the kvm
> selftests naming convention.
>

Sure, thanks!

> Thanks,
> drew

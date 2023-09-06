Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA31C3A
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 10:10:38 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso53487361fa.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 03:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693995036; x=1694599836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfOqaeV+KknayCO8Oeiwloxt+zMetEN9D2laP149Llc=;
        b=qfCgpTE1skiOCzgjSKe7nhYFsqPebFi7rMKPillgUN54PaBiYzmn/xeueEwrWkh2Z9
         z7EdLaI5O6Mq/7bY45unYXjSzTmS0JCezjZLUKtItZQ2jOVvkaF1bOqvjX4HA4MMdn8u
         BnKkiKH794wsw5uITkopBIW3nBuNYdnU4Ao5rE6pWjpwhgAgZWNWT63/3xBU8T360W2G
         ZDnGSMPLVhsVHwMTzsZinixOsTCsGr/h6S944yw4CY458ZDuVyiXZkRqhP9fL18cpMNS
         6vWeSiFJQAgXWdAg4JTe3hm0dZ5v6ExU/AytriJyaYnOoQHKDJfjw2c3iv9VseQ8nb9d
         PwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693995036; x=1694599836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EfOqaeV+KknayCO8Oeiwloxt+zMetEN9D2laP149Llc=;
        b=fdqF9xVTrcaZU+lXGVPp2zQsvxZmR0VV8V/mAuQkksJPH5F7eB/nth75lK9o8QJ22/
         aABYWd0yZbhOpHs1GzuRpQrdK9gnomZnLZJQw5iIrxwYDBnn/1UMDQjkJwMoRcDasFrQ
         5eaWwm0hNevoxJQuAV6TNeTslTaTtoaNf8rYn7VRIixcQWzTGMlDOtbCSmaEpimMeEkk
         fdFv+B3h8chGWt/lf+O3OE/iKjxlSWN1MVqdTrss+B0TIbneRbZbINH0h0EhBvwGf+tM
         8KDJe1jAwFrnubNf3D2+S6+XtUwNuCiQlNCcBBTOO8gYIvnFuQNVPvD8OMB1CMjz+DdW
         z/Fg==
X-Gm-Message-State: AOJu0YxtELyeGNMjDMORaNiItqvNo3dnTTedHhn3NswTo0MqHc3dw1ET
	FOXFwLeGXeaLLDhaHH20UvuOU8vY2kYHx0Let8c=
X-Google-Smtp-Source: AGHT+IFgpGZUTmfvyaicrKry99f2uX/eh3DtKB8c/qKcmnkcHz7uwZYtn0qD9L1QTcGEetIJKq9wCp8WNJgZPbJB/RM=
X-Received: by 2002:a05:651c:104a:b0:2bd:180d:67b1 with SMTP id
 x10-20020a05651c104a00b002bd180d67b1mr1816321ljm.51.1693995035890; Wed, 06
 Sep 2023 03:10:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <b6ef1b031e3a581f481cf19a26623388163444b4.1693659382.git.haibo1.xu@intel.com>
 <20230904-aa8b0d8d23d391586686038a@orel>
In-Reply-To: <20230904-aa8b0d8d23d391586686038a@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 18:10:24 +0800
Message-ID: <CAJve8ok5cU+h1K+WJ+aDpB+u+PBo8XosUyyVbMGy-xR0XiWFdw@mail.gmail.com>
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

On Mon, Sep 4, 2023 at 10:04=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, Sep 02, 2023 at 08:59:29PM +0800, Haibo Xu wrote:
> > diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/t=
esting/selftests/kvm/riscv/get-reg-list.c
> > index d8ecacd03ecf..c4028bf32e3f 100644
> > --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > @@ -44,20 +44,6 @@ bool check_reject_set(int err)
> >       return err =3D=3D EINVAL;
> >  }
> >
> > -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > -{
> > -     int ret;
> > -     unsigned long value;
> > -
> > -     ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> > -     if (ret) {
> > -             printf("Failed to get ext %d", ext);
> > -             return false;
> > -     }
> > -
> > -     return !!value;
>
> get-reg-list will now assert on get-reg when an extension isn't present,
> rather than failing the __TEST_REQUIRE(), which would do a skip instead.
> We need both the return false version and the assert version.
>

Ok, Will keep this one for get-reg-list and add another one for
arch-timer specific usage.

> > -}
> > -
> >  void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> >  {
> >       struct vcpu_reg_sublist *s;
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

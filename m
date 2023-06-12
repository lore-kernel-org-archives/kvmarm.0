Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822B018AFF
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 09:44:39 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-39ce64700cbso177157b6e.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 02:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686563078; x=1689155078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxkf6jrO4dEZx2mwSY4xMRu+z/wFzxrSpMsDqPXhZ5o=;
        b=W66LBfOWiiTsiZ/jfv9BUP8aQ4UfXXP7S7asvtInvAZ0+41KbPzHcmy+DZbscCDnCs
         J0VsiXPFg7xu6lz+cGKwTFsn6EJM/iPxDuG/08DA0toBY3blImbX8Ar1cPBN6OUUkl1Z
         E5Cw5qfEpazhmrnDES7MzPWC29a6FXJRN0xcKUtwEf0++rZL5U/c9Enzu1vC8wFAQp3r
         Tla5PgbfaXjpxm9AM1Ffyu9eId7z9ELqBGA2mhu73RxrC0HdT5YzwA5jRvDu2hrLFPxF
         R3ssFuKYAfdKEjA/N3KJOTQ7/V0CejatMjwjb1g5llwpK/SGadIr9K6S1er5ehndO0OQ
         gnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686563078; x=1689155078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxkf6jrO4dEZx2mwSY4xMRu+z/wFzxrSpMsDqPXhZ5o=;
        b=D8MGKGMbtCI55kiaHFD0+i6snGTjaeWGyvq7QwIKiwo4LEsLKoRubm6WCQWaazViWM
         +LUx7NEQzTr9zVjpF2dfq9FbE8jju8jolYu0RPiu84I3RoheZdqD/EG1jACP4+CL3DIL
         yTkXyjEiAUk0xhd5tyqGKacaRBQwoCzWacw+mf23G5gQCEeJTEYmLqt6mAPCjpEEQ6hw
         dyp9IUBbabepSdJSiV+vmfB9C6cebb8vzLz1wVqBE6Y+2nSn/5fxop8c0DJ5OsORpbO4
         1VNDCu6USz6oW7ITGC3SXAHrrnhx7i45mbmr9gFJtEZyKnbyMr9A/GO9kLcp2Ept489j
         rtWg==
X-Gm-Message-State: AC+VfDwV0KRPJWhr4CnN4aCKuWzFcLyXkD5hn+jUXdOA2wnNe1mOcX9T
	kUEB4SNHhsy1M2+XpmFxMe71c79/vQiA4e+2ls4=
X-Google-Smtp-Source: ACHHUZ7x6+asQtR9uojrnXOYMbtxE9WXKqmvAG5Y58QN3Q+1M9AvT+ew0zEvisqgZmSNnEvIcddaaMqz+PXoYqJFll8=
X-Received: by 2002:a05:6808:189e:b0:396:40c4:a2ef with SMTP id
 bi30-20020a056808189e00b0039640c4a2efmr4005165oib.11.1686563078478; Mon, 12
 Jun 2023 02:44:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1686275310.git.haibo1.xu@intel.com> <73045958d9ab71d5266d012f1e13061afa8c5331.1686275310.git.haibo1.xu@intel.com>
 <20230609-05521f954b0485c69612f00b@orel> <CAJve8omPV_XgCSvw8POZwisb6uTOFMJU4FyAKArryui2SAsqtw@mail.gmail.com>
 <20230612-05314de3b73277af1ee729b0@orel>
In-Reply-To: <20230612-05314de3b73277af1ee729b0@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 12 Jun 2023 17:44:27 +0800
Message-ID: <CAJve8om8tjsXejtBWjuSg+kCUgfDdzq2AS2abC0qx9q2a7eSQw@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] KVM: riscv: selftests: Skip some registers set operation
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

On Mon, Jun 12, 2023 at 4:57=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, Jun 10, 2023 at 10:35:24AM +0800, Haibo Xu wrote:
> > On Fri, Jun 9, 2023 at 5:24=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > On Fri, Jun 09, 2023 at 10:12:17AM +0800, Haibo Xu wrote:
> > > > Set operation on some riscv registers(mostly pesudo ones) was not
> > > > supported and should be skipped in the get-reg-list test. Just
> > > > reuse the rejects_set utilities to handle it in riscv.
> > > >
> > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/get-reg-list.c | 20 +++++++++++++-----=
--
> > > >  1 file changed, 13 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/tes=
ting/selftests/kvm/get-reg-list.c
> > > > index c4bd5a5259da..abacb95c21c6 100644
> > > > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > > > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > > > @@ -211,16 +211,22 @@ static void run_test(struct vcpu_reg_list *c)
> > > >                       ++failed_get;
> > > >               }
> > > >
> > > > -             /* rejects_set registers are rejected after KVM_ARM_V=
CPU_FINALIZE */
> > > > +             /*
> > > > +              * rejects_set registers are rejected after KVM_ARM_V=
CPU_FINALIZE on aarch64,
> > > > +              * or registers that should skip set operation on ris=
cv.
> > > > +              */
> > > >               for_each_sublist(c, s) {
> > > >                       if (s->rejects_set && find_reg(s->rejects_set=
, s->rejects_set_n, reg.id)) {
> > > >                               reject_reg =3D true;
> > > > -                             ret =3D __vcpu_ioctl(vcpu, KVM_SET_ON=
E_REG, &reg);
> > > > -                             if (ret !=3D -1 || errno !=3D EPERM) =
{
> > > > -                                     printf("%s: Failed to reject =
(ret=3D%d, errno=3D%d) ", config_name(c), ret, errno);
> > > > -                                     print_reg(config_name(c), reg=
.id);
> > > > -                                     putchar('\n');
> > > > -                                     ++failed_reject;
> > > > +                             if ((reg.id & KVM_REG_ARCH_MASK) =3D=
=3D KVM_REG_ARM64) {
> > > > +                                     ret =3D __vcpu_ioctl(vcpu, KV=
M_SET_ONE_REG, &reg);
> > > > +                                     if (ret !=3D -1 || errno !=3D=
 EPERM) {
> > > > +                                             printf("%s: Failed to=
 reject (ret=3D%d, errno=3D%d) ",
> > > > +                                                             confi=
g_name(c), ret, errno);
> > > > +                                             print_reg(config_name=
(c), reg.id);
> > > > +                                             putchar('\n');
> > > > +                                             ++failed_reject;
> > > > +                                     }
> > >
> > > Thinking about this some more, shouldn't we attempt the set ioctl for
> > > riscv reject registers as well, but look for different error numbers?
> > >
> >
> > Yes, we can. Currently, 2 different errno(EOPNOTSUPP/EINVAL) would be
> > reported for the rejected registers in risc-v.
> > These 2 errnos can be handled specially like below:
> >
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c
> > b/tools/testing/selftests/kvm/get-reg-list.c
> > index 73f40e0842b8..f3f2c4519318 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -255,6 +255,15 @@ static void run_test(struct vcpu_reg_list *c)
> >                                                 putchar('\n');
> >                                                 ++failed_reject;
> >                                         }
> > +                } else {
> > +                                       ret =3D __vcpu_ioctl(vcpu,
> > KVM_SET_ONE_REG, &reg);
> > +                                       if (ret !=3D -1 || (errno !=3D
> > EINVAL && errno !=3D EOPNOTSUPP)) {
> > +                                               printf("%s: Failed to
> > reject (ret=3D%d, errno=3D%d) ",
> > +
> > config_name(c), ret, errno);
> > +
> > print_reg(config_name(c), reg.id);
> > +                                               putchar('\n');
> > +                                               ++failed_reject;
> > +                                       }
>
> Instead of duplicating the code Arm uses, we just need an errno check
> function, preferably one that takes the register as an input, so we
> can check for specific errnos for specific registers.
>
> >
> > One possible issue for the above change is that when new registers
> > that don't support sets were added, we need
> > to add them to the reject registers list, or the test would fail.
> >
> > Initially, in the v1 patch, the design was to just skip the EOPNOTSUPP
> > errno in set operations for all registers
> > since it's a known errno for registers that don't support sets. This
> > change cover all the registers even for future
> > new ones.
> >
> > What's your opinion?
>
> I think we should only do the get/set tests on present, blessed list
> registers, since if it's a new register we don't know its capabilities.
>
> So, instead of
>
>   for_each_reg(i) {
>      /* get/set tests */
>   }
>
> we do
>
>   for_each_present_blessed_reg(i) {
>      /* get/set tests */
>   }
>
> where we have
>
>  #define for_each_present_blessed_reg(i) \
>      for ((i) =3D 0; (i) < blessed_n; ++(i)) \
>          if (find_reg(reg_list->reg, reg_list->n, blessed_reg[i]))
>
>
> Changing run_test() to work this way should be a separate patch.
>

Good idea! let me have a try.

Thanks,
Haibo

> Thanks,
> drew

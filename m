Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA0110F
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 02:35:36 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-65314ee05c6so2103963b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 19:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686364535; x=1688956535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+cQ2OwbycVyxFVqiOSniKxXaS+hWOW1t5Cl7Mhvz3A=;
        b=Kb6eH8l3yhks8jc06qIZNQE1A8b6Q8s5z7YxYMQtG84G5idJNCwHY54K2aO+07BVS5
         kVtoqyGLMuNUelZqpalq41FDA8pNkYCcXjCVGGBapbfFqUJ4WSsdkvz7PCNssfTj/Xa8
         5MeFd1LjBHZo35Zu32oCkV1iO99HnUueFmuPioQlNu6KFlTDvjXnvErrqP+mmyAkZtbF
         gka37/1OCMSyGaD6KC6epfW2C0i/wirz53++DZI0bR0cNqJfWjqW/1PpEyU5NZDpv7O0
         CnKTY14bKBRCa5kXDZSvXPOsmMxbMOpwlAqTcIhkUC/6dIUhbTKPiD7sS5/BZgVX7Mvt
         xkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686364535; x=1688956535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+cQ2OwbycVyxFVqiOSniKxXaS+hWOW1t5Cl7Mhvz3A=;
        b=lEcRGBbcIWRDQHzz3jk/tiT/fXey+YmV/B819rvLkADCKrCsvPfkOoQ1w3S9DsPfOe
         j2madHOkTnv/dHTt6f0B2F2Ydq6lPseRaFCSgfIKewC155GF4uAcRaNF8U49mpu3RwVj
         6icErF/vpbo/fMsXcJs93lpxUMD9pXBHt4AJu+nqL2ZGqSkUeZip7d2jYs2PY+U6CM0O
         Gi52JwP5+ly0br9QOHGYzJ+a4BA4G28boLyPilKw+tKLlxFazsiPAuNVyVwc5BjK59de
         55/HqVtPuA3+yUezcZgpC8CsKFhFX0ye+CDgC2xjusvCpCd+Glkzx9gGGF266YRMP/lC
         9fjw==
X-Gm-Message-State: AC+VfDyIyPyq/3ps1UBTM4YoyDOIlpx0otwPOjw7ZLzV+XWFxPIif281
	jPJOvpdVtTa7jJyl1dEvo6vc2U+TdO5+xm3ugeg=
X-Google-Smtp-Source: ACHHUZ6rNnkh2m1Yt4Pj3/pGOqJ4UHP9zSc6CE3jFoWY+FrVfA5ENGv5ysmIcDXuIOSFDb9BxkKoP9BiytTg0kXa/dU=
X-Received: by 2002:a05:6a20:e616:b0:105:94e5:f5c5 with SMTP id
 my22-20020a056a20e61600b0010594e5f5c5mr2595006pzb.56.1686364535616; Fri, 09
 Jun 2023 19:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1686275310.git.haibo1.xu@intel.com> <73045958d9ab71d5266d012f1e13061afa8c5331.1686275310.git.haibo1.xu@intel.com>
 <20230609-05521f954b0485c69612f00b@orel>
In-Reply-To: <20230609-05521f954b0485c69612f00b@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Sat, 10 Jun 2023 10:35:24 +0800
Message-ID: <CAJve8omPV_XgCSvw8POZwisb6uTOFMJU4FyAKArryui2SAsqtw@mail.gmail.com>
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

On Fri, Jun 9, 2023 at 5:24=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Fri, Jun 09, 2023 at 10:12:17AM +0800, Haibo Xu wrote:
> > Set operation on some riscv registers(mostly pesudo ones) was not
> > supported and should be skipped in the get-reg-list test. Just
> > reuse the rejects_set utilities to handle it in riscv.
> >
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  tools/testing/selftests/kvm/get-reg-list.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing=
/selftests/kvm/get-reg-list.c
> > index c4bd5a5259da..abacb95c21c6 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -211,16 +211,22 @@ static void run_test(struct vcpu_reg_list *c)
> >                       ++failed_get;
> >               }
> >
> > -             /* rejects_set registers are rejected after KVM_ARM_VCPU_=
FINALIZE */
> > +             /*
> > +              * rejects_set registers are rejected after KVM_ARM_VCPU_=
FINALIZE on aarch64,
> > +              * or registers that should skip set operation on riscv.
> > +              */
> >               for_each_sublist(c, s) {
> >                       if (s->rejects_set && find_reg(s->rejects_set, s-=
>rejects_set_n, reg.id)) {
> >                               reject_reg =3D true;
> > -                             ret =3D __vcpu_ioctl(vcpu, KVM_SET_ONE_RE=
G, &reg);
> > -                             if (ret !=3D -1 || errno !=3D EPERM) {
> > -                                     printf("%s: Failed to reject (ret=
=3D%d, errno=3D%d) ", config_name(c), ret, errno);
> > -                                     print_reg(config_name(c), reg.id)=
;
> > -                                     putchar('\n');
> > -                                     ++failed_reject;
> > +                             if ((reg.id & KVM_REG_ARCH_MASK) =3D=3D K=
VM_REG_ARM64) {
> > +                                     ret =3D __vcpu_ioctl(vcpu, KVM_SE=
T_ONE_REG, &reg);
> > +                                     if (ret !=3D -1 || errno !=3D EPE=
RM) {
> > +                                             printf("%s: Failed to rej=
ect (ret=3D%d, errno=3D%d) ",
> > +                                                             config_na=
me(c), ret, errno);
> > +                                             print_reg(config_name(c),=
 reg.id);
> > +                                             putchar('\n');
> > +                                             ++failed_reject;
> > +                                     }
>
> Thinking about this some more, shouldn't we attempt the set ioctl for
> riscv reject registers as well, but look for different error numbers?
>

Yes, we can. Currently, 2 different errno(EOPNOTSUPP/EINVAL) would be
reported for the rejected registers in risc-v.
These 2 errnos can be handled specially like below:

diff --git a/tools/testing/selftests/kvm/get-reg-list.c
b/tools/testing/selftests/kvm/get-reg-list.c
index 73f40e0842b8..f3f2c4519318 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -255,6 +255,15 @@ static void run_test(struct vcpu_reg_list *c)
                                                putchar('\n');
                                                ++failed_reject;
                                        }
+                } else {
+                                       ret =3D __vcpu_ioctl(vcpu,
KVM_SET_ONE_REG, &reg);
+                                       if (ret !=3D -1 || (errno !=3D
EINVAL && errno !=3D EOPNOTSUPP)) {
+                                               printf("%s: Failed to
reject (ret=3D%d, errno=3D%d) ",
+
config_name(c), ret, errno);
+
print_reg(config_name(c), reg.id);
+                                               putchar('\n');
+                                               ++failed_reject;
+                                       }

One possible issue for the above change is that when new registers
that don't support sets were added, we need
to add them to the reject registers list, or the test would fail.

Initially, in the v1 patch, the design was to just skip the EOPNOTSUPP
errno in set operations for all registers
since it's a known errno for registers that don't support sets. This
change cover all the registers even for future
new ones.

What's your opinion?

Thanks,
Haibo
> Thanks,
> drew

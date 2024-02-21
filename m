Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193504C8A
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 02:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481603; cv=none; b=ftUuxU8sll47NeItm4SgZpTiCpG2jKA0oqLmIS9pr+w1Ig4jOpvmwzgAvmaBrjWFxyLUFCU17Z66UezoMaqlBdbvPROFLuoWfI8X6x6H+ZBHncjbkLAnGCdTW7FwLNI3yhFq9UijsotuZ4gxMFjVxB4YOIR43X/VqDAWs0KKerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481603; c=relaxed/simple;
	bh=VwMMVl1TDHBJEglnXRiz983bQqb39w+JHkpeXQTsGPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PNsrdqajlgXDvaf2eKG3ea4mpwjKsf6zH5Yzxl0BDNv4CE41NYu5nhPJsO2eakd99SPeAGxyzmZiPRruCeGEdXDb/X4wqmqMpSTqYJCkdk5FB5Sucj1nDCIx8eN5LTNMyg5Ljkj7DBToH8yIK6dgY0/Gck/IOYTxVrJ9A4wWUxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SSQUSueJ; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSQUSueJ"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-512cba0f953so1219549e87.2
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 18:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708481600; x=1709086400; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyL4+gid2LCVkf5A3UEC4DDd5q5l+TxrzdeM+WtCs/s=;
        b=SSQUSueJr4DisbTPaZO/7MRhav1g4rYCR3Uq/V2/5MQvkCKE61eryrSkuyyBibaKpk
         AdtZt5q0+7wpUyWUIMKjOVf0jhQVsWkseWyY1wDRpj0j+JKM58z2l/ydXi1PPPeU1W19
         KTUXTVPZ7loHIqYHmiWMlMCqXqAwGBg5JJAmXhg1/FrdxB3EF77qR0UQfo+oIYea4ymN
         WfC+K2USdefemh71zL8U3I9apCfpbosvltPozHeUw6EeORub+gVVI41HppdqfhOluiuH
         k7nvIPdh3G/kjohAni9ElDFvcWNDNr/D1NoEazx+gSoBMTTraJ6SDTJbHputzi1BSPNq
         WfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708481600; x=1709086400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyL4+gid2LCVkf5A3UEC4DDd5q5l+TxrzdeM+WtCs/s=;
        b=JPNlYiqItlwdFMr8Uk4eyeNx9u2bZq8ElGD9njbOpF+01WdE4VDWuDXQZZXa1NaBg7
         b171P9xYJgLYcm6otehn98/XYLNy/tTUy6JfVZX/eTmxiXh3a0Kj3kBF4acCtTPe3tUf
         mUBm3KrFJIbAMckZJIROcTEXhKJGd5l50hmbvApjDKCCD6ELo32sh7oWx9Vt5GF4Hv3j
         yQvgeWm3cnWc7snlz2gzIloo6FEFtYghQiF7FlCWrpCnRNgpUMpa4sJvqn3zhRr9xHt+
         oYVEMyczIL7PY+GTi7hk/uTOfliAlWDD2KsLZoAhXkfZ8zCU4wJUSMK/FPV82RMEPdf/
         eA3g==
X-Forwarded-Encrypted: i=1; AJvYcCV8pbu3xfkrsNWs55yNt63QtusIhh4NM1cljy5L07QDVobxrYLy6bx771F/bSEzjAxcBlplFqgIar4VuahCj9nZ5kPsd/EN
X-Gm-Message-State: AOJu0YwqUxXhh60sY8DglYeNRLuazZmpGb92wboesHZXrq7vKJkT8wTQ
	f69y4zB6/4f9CQRvMHLsfv60texoXMtebkk7ysYYOLa1hCzqorYP+h41LO8ulL8CIfA5fyt7VF3
	FE0mx0B5UD21UV/jXpR+G/l1V94o=
X-Google-Smtp-Source: AGHT+IHRdTziSrABqkKvSI9ZOcTbR2Q3vrcU+ABOUUUq5c2+ia7YA91JhISWBunQmlRCXavtuJjiR/cXOesvX0Bn5yk=
X-Received: by 2002:a05:6512:ba6:b0:512:bebf:1a with SMTP id
 b38-20020a0565120ba600b00512bebf001amr3977383lfv.57.1708481599992; Tue, 20
 Feb 2024 18:13:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
 <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
In-Reply-To: <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 21 Feb 2024 10:13:08 +0800
Message-ID: <CAJve8om2oOLg5-wKX7m7cBTgzwqiMcb35x=nDi1edY8evXjyMw@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
To: Atish Patra <atishp@atishpatra.org>
Cc: Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Jisheng Zhang <jszhang@kernel.org>, Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, 
	Like Xu <likexu@tencent.com>, Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 7:03=E2=80=AFAM Atish Patra <atishp@atishpatra.org>=
 wrote:
>
> On Mon, Jan 22, 2024 at 1:48=E2=80=AFAM Haibo Xu <haibo1.xu@intel.com> wr=
ote:
> >
> > Move vcpu_has_ext to the processor.c and rename it to __vcpu_has_ext
> > so that other test cases can use it for vCPU extension check.
> >
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  tools/testing/selftests/kvm/include/riscv/processor.h |  2 ++
> >  tools/testing/selftests/kvm/lib/riscv/processor.c     | 10 ++++++++++
> >  tools/testing/selftests/kvm/riscv/get-reg-list.c      | 11 +----------
> >  3 files changed, 13 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/to=
ols/testing/selftests/kvm/include/riscv/processor.h
> > index b68b1b731a34..bd27e1c67579 100644
> > --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > @@ -42,6 +42,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, ui=
nt64_t idx,
> >  #define RISCV_ISA_EXT_REG(idx) __kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
> >                                              idx, KVM_REG_SIZE_ULONG)
> >
> > +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> > +
> >  struct ex_regs {
> >         unsigned long ra;
> >         unsigned long sp;
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/=
testing/selftests/kvm/lib/riscv/processor.c
> > index 39a1e9902dec..dad73ce18164 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > @@ -15,6 +15,16 @@
> >
> >  static vm_vaddr_t exception_handlers;
> >
> > +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > +{
> > +       unsigned long value =3D 0;
> > +       int ret;
> > +
> > +       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> > +
> > +       return !ret && !!value;
> > +}
> > +
>
> Not sure what was the base patch on which this was rebased. The actual
> commit in the queue branch looks different.
>

This patch set was based on 6.7-rc8.

> https://github.com/kvm-riscv/linux/commit/5563517cc2012e3326411b360c9924d=
3f2706c8d
>
> Both seem to have the same bug though the tests fail now and require
> the following fix.
> The ext id should be uint64_t and we need to pass ext directly so that
> SBI extension tests can also pass.
>

It's weird that 6.7-rc8 has already included Andrew's change on the ISA ext=
 reg,
but this patch was not generated against his change.

commit bdf6aa328f137e184b0fce607fd585354c3742f1
Author: Andrew Jones <ajones@ventanamicro.com>
Date:   Wed Dec 13 18:09:58 2023 +0100

    RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs

Anyway, your changes were right. Please go ahead to include them when mergi=
ng.

Thanks,
Haibo

>
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -48,7 +48,7 @@ static inline uint64_t __kvm_reg_id(uint64_t type,
> uint64_t subtype,
> KVM_REG_RISCV_SBI_SINGLE, \
> idx, KVM_REG_SIZE_ULONG)
>
> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
>
> struct ex_regs {
> unsigned long ra;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c
> b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index 282587cd4bbc..ec66d331a127 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -15,12 +15,12 @@
>
> static vm_vaddr_t exception_handlers;
>
> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
> {
> unsigned long value =3D 0;
> int ret;
>
> - ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> + ret =3D __vcpu_get_reg(vcpu, ext, &value);
>
> return !ret && !!value;
> }
>
> With the above the fix, Both SBI/ISA extension tests pass.
> # ./get-reg-list
> sbi-base: PASS
> sbi-sta: PASS
> sbi-pmu: PASS
> sbi-dbcn: PASS
> aia: PASS
> fp_f: PASS
> fp_d: PASS
> 1..0 # SKIP - h not available, skipping tests
> smstateen: PASS
> sscofpmf: PASS
> sstc: PASS
> 1..0 # SKIP - svinval not available, skipping tests
> 1..0 # SKIP - svnapot not available, skipping tests
> 1..0 # SKIP - svpbmt not available, skipping tests
> zba: PASS
> zbb: PASS
> zbc: PASS
> 1..0 # SKIP - zbkb not available, skipping tests
> 1..0 # SKIP - zbkc not available, skipping tests
> 1..0 # SKIP - zbkx not available, skipping tests
> zbs: PASS
> zfa: PASS
> 1..0 # SKIP - zfh not available, skipping tests
> 1..0 # SKIP - zfhmin not available, skipping tests
> zicbom: PASS
> zicboz: PASS
> zicntr: PASS
> 1..0 # SKIP - zicond not available, skipping tests
> zicsr: PASS
> zifencei: PASS
> zihintntl: PASS
> zihintpause: PASS
> zihpm: PASS
>
>
> >  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> >  {
> >         return (v + vm->page_size) & ~(vm->page_size - 1);
> > diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/t=
esting/selftests/kvm/riscv/get-reg-list.c
> > index 25de4b8bc347..ed29ba45588c 100644
> > --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > @@ -75,15 +75,6 @@ bool check_reject_set(int err)
> >         return err =3D=3D EINVAL;
> >  }
> >
> > -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > -{
> > -       int ret;
> > -       unsigned long value;
> > -
> > -       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> > -       return (ret) ? false : !!value;
> > -}
> > -
> >  void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> >  {
> >         unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] =3D { 0 };
> > @@ -111,7 +102,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vc=
pu_reg_list *c)
> >                 __vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), 1);
> >
> >                 /* Double check whether the desired extension was enabl=
ed */
> > -               __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> > +               __TEST_REQUIRE(__vcpu_has_ext(vcpu, s->feature),
> >                                "%s not available, skipping tests\n", s-=
>name);
> >         }
> >  }
> > --
> > 2.34.1
> >
>
>
> --
> Regards,
> Atish

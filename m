Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CADFC18
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 05:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708926478; cv=none; b=EUyZvK6CcwJJnIFgHZFwgyJ+1qQkZkMAT1uo3yjhmDThxPpIZGsdLjw+gDOhfHJNLZUxbEsnc67JDaL6hvZh92bJZaZGKlzqevGI08LsA0H0CTjrXmjlC/dAKtSLLdj2dlKPxlsXyj+eKImdyKNRDwhJhkrEYwjsVN7kFsg3FBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708926478; c=relaxed/simple;
	bh=K5EhxfTyAeXjdOEJjG8brOnAyWwyn43VJQUtjt5uYys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O6vQM+7uPv0HX2FUHsCMe4KNAMl1ZPE58Y5frE2j1O2dYzRyJN9SPSRrjWtJYATzWA/KoicnWBn4NAvxsgpTMg7FOiUeEzetPBr1wFYnqsmA1DuLEIG3O6i/1Bs03d+FavabA40XjXksawMWvJhRboJHH6WrL7WlOW8HOgueYZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fFnEBPGP; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fFnEBPGP"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-512bde3d197so2105619e87.0
        for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 21:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708926474; x=1709531274; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9AaAZqwaMM3hlPPn5OnhezHOMjAT7L8+u/HDWjjaS8=;
        b=fFnEBPGPNYzmwO98OUpnRNIRPOEN2gQjrksoxOfBxpbb3lmGokbWuXSROdsnByaCR5
         MSjCBl4aNhF9MAbNQX9dPpVcdeMj2CTKpJUeWMOaKHwHFDO+r3yT0IR4nKGwiCAboiSa
         NJjgbXk9QjZgYpT2rqFPiWQw/vRB3lGOJfvmQ1bWbp4NQTw3E0OVLcdLNtQIYuUYNck+
         Fd0D/6adTS2UUa0/U7ClS3ecnnhgiGY6tA2yeU2gle4g9BmQ9K5My9xfK4VgSFN7FiHy
         Pp5OKUvxMh/K5S6E/393S9mJr4aIvy+V21ywapW2Cp+/op77bR2n/hoOq9NVbYL7Vgyp
         JL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708926474; x=1709531274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9AaAZqwaMM3hlPPn5OnhezHOMjAT7L8+u/HDWjjaS8=;
        b=RxDsP1NzlSBMJYkFJgoZXvdETFNRZPxoJ7d1cHOPwmEW4rjPcyjkXY3zbLdvzQREBq
         ISNBWoChutEE10rCBE9p0i5hFeDnL8UrPPGWve69D9jPTemns16EW1TgdPw2HcV55LNI
         1QnxSuU5+avvs5GNkmmuZ7H1piUCsEs5FkgtK8GalRVvwMks3KiJDYHzL/pIkDzvFNJB
         uYHZzWw2k4jPBZVuyytNpi6RKmkCoG+MZrGE17Im1jZNs7IzJ/AI1gQb32Yn66Fd8nrV
         VRPgFXDkV6f/atd2i9lP61H9raNi7CCJARYGGo8ni14xBdEltjNX/dNZwz0P5RN1dnps
         yY/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaUAxh/+4+iDxyIkNJk4aInMC6tUo/rTGqngnOip7lNwOmSmHklt473yaet4apSe5kNeCqgAE0/J10daMFsGkZPjhjgl9N
X-Gm-Message-State: AOJu0YxGFmywvFzPOVW4d413ORwkn7gn7kulEAwOSLsI5BDefgP5U+5n
	JpCWewpsGDJTVBwPgcyYnWUYGgfQSNSC9u6afqmpjV2YGpVY/g2ycXdJYsHf/46jJwk6lgQWsyD
	+R4Ksqs5GOUtULMdHoSJ4RJB8VHY=
X-Google-Smtp-Source: AGHT+IFxFgCdVShdGgyihbmMGEdbb3FMU62WepRd4W/KTlGzWNAcQNvEg4IXZJAq58ExfevYjpOnAjGeQM4aCs7o1so=
X-Received: by 2002:a05:6512:314d:b0:512:e1e3:cd2c with SMTP id
 s13-20020a056512314d00b00512e1e3cd2cmr2961307lfi.69.1708926474284; Sun, 25
 Feb 2024 21:47:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
 <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
 <CAJve8om2oOLg5-wKX7m7cBTgzwqiMcb35x=nDi1edY8evXjyMw@mail.gmail.com>
 <2c96c61a-2685-4cee-9cef-963ed833bf92@rivosinc.com> <CAAhSdy2TVSt=gCJRf78AzXNVFKy8MGJ+QspSEHeedT7GPAYkUQ@mail.gmail.com>
In-Reply-To: <CAAhSdy2TVSt=gCJRf78AzXNVFKy8MGJ+QspSEHeedT7GPAYkUQ@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 26 Feb 2024 13:47:42 +0800
Message-ID: <CAJve8onL5YB2w6duAr2H=8yJMh=SPsZCvgu+suhd=9U1_egHOg@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
To: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
	Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Guo Ren <guoren@kernel.org>, 
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

On Mon, Feb 26, 2024 at 1:20=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Wed, Feb 21, 2024 at 2:07=E2=80=AFPM Atish Patra <atishp@rivosinc.com>=
 wrote:
> >
> > On 2/20/24 18:13, Haibo Xu wrote:
> > > On Wed, Feb 21, 2024 at 7:03=E2=80=AFAM Atish Patra <atishp@atishpatr=
a.org> wrote:
> > >>
> > >> On Mon, Jan 22, 2024 at 1:48=E2=80=AFAM Haibo Xu <haibo1.xu@intel.co=
m> wrote:
> > >>>
> > >>> Move vcpu_has_ext to the processor.c and rename it to __vcpu_has_ex=
t
> > >>> so that other test cases can use it for vCPU extension check.
> > >>>
> > >>> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > >>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > >>> ---
> > >>>   tools/testing/selftests/kvm/include/riscv/processor.h |  2 ++
> > >>>   tools/testing/selftests/kvm/lib/riscv/processor.c     | 10 ++++++=
++++
> > >>>   tools/testing/selftests/kvm/riscv/get-reg-list.c      | 11 +-----=
-----
> > >>>   3 files changed, 13 insertions(+), 10 deletions(-)
> > >>>
> > >>> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h =
b/tools/testing/selftests/kvm/include/riscv/processor.h
> > >>> index b68b1b731a34..bd27e1c67579 100644
> > >>> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > >>> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > >>> @@ -42,6 +42,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type=
, uint64_t idx,
> > >>>   #define RISCV_ISA_EXT_REG(idx) __kvm_reg_id(KVM_REG_RISCV_ISA_EXT=
, \
> > >>>                                               idx, KVM_REG_SIZE_ULO=
NG)
> > >>>
> > >>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> > >>> +
> > >>>   struct ex_regs {
> > >>>          unsigned long ra;
> > >>>          unsigned long sp;
> > >>> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/to=
ols/testing/selftests/kvm/lib/riscv/processor.c
> > >>> index 39a1e9902dec..dad73ce18164 100644
> > >>> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >>> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >>> @@ -15,6 +15,16 @@
> > >>>
> > >>>   static vm_vaddr_t exception_handlers;
> > >>>
> > >>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > >>> +{
> > >>> +       unsigned long value =3D 0;
> > >>> +       int ret;
> > >>> +
> > >>> +       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value=
);
> > >>> +
> > >>> +       return !ret && !!value;
> > >>> +}
> > >>> +
> > >>
> > >> Not sure what was the base patch on which this was rebased. The actu=
al
> > >> commit in the queue branch looks different.
> > >>
> > >
> > > This patch set was based on 6.7-rc8.
> > >
> > >> https://github.com/kvm-riscv/linux/commit/5563517cc2012e3326411b360c=
9924d3f2706c8d
> > >>
> > >> Both seem to have the same bug though the tests fail now and require
> > >> the following fix.
> > >> The ext id should be uint64_t and we need to pass ext directly so th=
at
> > >> SBI extension tests can also pass.
> > >>
> > >
> > > It's weird that 6.7-rc8 has already included Andrew's change on the I=
SA ext reg,
> > > but this patch was not generated against his change.
> > >
> > > commit bdf6aa328f137e184b0fce607fd585354c3742f1
> > > Author: Andrew Jones <ajones@ventanamicro.com>
> > > Date:   Wed Dec 13 18:09:58 2023 +0100
> > >
> > >      RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs
> > >
> > > Anyway, your changes were right. Please go ahead to include them when=
 merging.
> > >
> >
> > I am not sure what happened. Probably, a merge conflict issue.
> >
> > I just realized I forgot to copy paste another fix in arch timer
> >
> > +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> > @@ -85,7 +85,7 @@ struct kvm_vm *test_vm_create(void)
> >          int nr_vcpus =3D test_args.nr_vcpus;
> >
> >          vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> > -       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0], KVM_RISCV_ISA_EXT_SSTC)=
,
> > +       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0],
> > RISCV_ISA_EXT_REG(KVM_RISCV_ISA_EXT_SSTC)),
>
> I have squashed this change into an existing commit in riscv_kvm_queue.
>
> Thanks,
> Anup
>

Thanks a lot, Anup!

> >
> >
> > > Thanks,
> > > Haibo
> > >
> > >>
> > >> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > >> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > >> @@ -48,7 +48,7 @@ static inline uint64_t __kvm_reg_id(uint64_t type,
> > >> uint64_t subtype,
> > >> KVM_REG_RISCV_SBI_SINGLE, \
> > >> idx, KVM_REG_SIZE_ULONG)
> > >>
> > >> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> > >> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
> > >>
> > >> struct ex_regs {
> > >> unsigned long ra;
> > >> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >> b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >> index 282587cd4bbc..ec66d331a127 100644
> > >> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> > >> @@ -15,12 +15,12 @@
> > >>
> > >> static vm_vaddr_t exception_handlers;
> > >>
> > >> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > >> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
> > >> {
> > >> unsigned long value =3D 0;
> > >> int ret;
> > >>
> > >> - ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> > >> + ret =3D __vcpu_get_reg(vcpu, ext, &value);
> > >>
> > >> return !ret && !!value;
> > >> }
> > >>
> > >> With the above the fix, Both SBI/ISA extension tests pass.
> > >> # ./get-reg-list
> > >> sbi-base: PASS
> > >> sbi-sta: PASS
> > >> sbi-pmu: PASS
> > >> sbi-dbcn: PASS
> > >> aia: PASS
> > >> fp_f: PASS
> > >> fp_d: PASS
> > >> 1..0 # SKIP - h not available, skipping tests
> > >> smstateen: PASS
> > >> sscofpmf: PASS
> > >> sstc: PASS
> > >> 1..0 # SKIP - svinval not available, skipping tests
> > >> 1..0 # SKIP - svnapot not available, skipping tests
> > >> 1..0 # SKIP - svpbmt not available, skipping tests
> > >> zba: PASS
> > >> zbb: PASS
> > >> zbc: PASS
> > >> 1..0 # SKIP - zbkb not available, skipping tests
> > >> 1..0 # SKIP - zbkc not available, skipping tests
> > >> 1..0 # SKIP - zbkx not available, skipping tests
> > >> zbs: PASS
> > >> zfa: PASS
> > >> 1..0 # SKIP - zfh not available, skipping tests
> > >> 1..0 # SKIP - zfhmin not available, skipping tests
> > >> zicbom: PASS
> > >> zicboz: PASS
> > >> zicntr: PASS
> > >> 1..0 # SKIP - zicond not available, skipping tests
> > >> zicsr: PASS
> > >> zifencei: PASS
> > >> zihintntl: PASS
> > >> zihintpause: PASS
> > >> zihpm: PASS
> > >>
> > >>
> > >>>   static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> > >>>   {
> > >>>          return (v + vm->page_size) & ~(vm->page_size - 1);
> > >>> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/too=
ls/testing/selftests/kvm/riscv/get-reg-list.c
> > >>> index 25de4b8bc347..ed29ba45588c 100644
> > >>> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > >>> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> > >>> @@ -75,15 +75,6 @@ bool check_reject_set(int err)
> > >>>          return err =3D=3D EINVAL;
> > >>>   }
> > >>>
> > >>> -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> > >>> -{
> > >>> -       int ret;
> > >>> -       unsigned long value;
> > >>> -
> > >>> -       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value=
);
> > >>> -       return (ret) ? false : !!value;
> > >>> -}
> > >>> -
> > >>>   void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c=
)
> > >>>   {
> > >>>          unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] =3D { 0=
 };
> > >>> @@ -111,7 +102,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struc=
t vcpu_reg_list *c)
> > >>>                  __vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature)=
, 1);
> > >>>
> > >>>                  /* Double check whether the desired extension was =
enabled */
> > >>> -               __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> > >>> +               __TEST_REQUIRE(__vcpu_has_ext(vcpu, s->feature),
> > >>>                                 "%s not available, skipping tests\n=
", s->name);
> > >>>          }
> > >>>   }
> > >>> --
> > >>> 2.34.1
> > >>>
> > >>
> > >>
> > >> --
> > >> Regards,
> > >> Atish
> >

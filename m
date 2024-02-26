Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E181B7E2
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 05:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708924803; cv=none; b=swDhl5S60mP+PZVOH4krVSV2Zae8mjvkY9maSIyxuOVzFYaoFwQfKfKfsBplFUgMI05r40XfFZw1l5DSXw5azYVXJxS4RfF2rNJ/OnU/q2R/OmmZYzGGMl6ftq2H71MjTCbKRephMW8HnkKCpgaOt7/EFCb0HPWB5zVFteliGNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708924803; c=relaxed/simple;
	bh=/PgP2P0hX/+bEV3aU0WEL7b5JNAP3+sF8FKj2czw6Ho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zd6RAwkEYvDuNoisf1GzYyiN0p+X3MQliTOmaU3G/xsTZGDfdtW3p4SyPsmsQaRknl33jBK6YEe5q8CzdAzwr+9GsGv1Asz210t6w32QqAVvQhX+8cxH8Ia+vSZiHXzhQchXlyN4sLJmpEXiq24cVlQSWoBlTBSjd8HzsvM1AbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=feFMyd6w; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="feFMyd6w"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bc332d3a8cso201707239f.2
        for <kvmarm@lists.linux.dev>; Sun, 25 Feb 2024 21:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1708924800; x=1709529600; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvD9c59bJDsB22IC2oo8c8Y8bED38e+VeFaxxSdJnPM=;
        b=feFMyd6wSLOV08wNsh3hpQmMYudTQovi+j9E29NuAFn1R4C4FasCuiILGQanP1FUlo
         JOpvLl288dcTsxUNSOG9bcwZ6b4ESwFr2jxFJB/gOvBmBQv9wqJOZRTrlksr7eBBc9ys
         xmUIhF6dP+VI3pzuxa0vPhsMu4Ek1jnbtFRY6VlRFp3McWUNUSe0JY4uv9uqxVhMOL2R
         CQ3P2MfwLVz0JEndP4aOezdlFOQpVGNWxWPIBtrBWvlOGT8fctpMnaKJPTWcecS9dvza
         cw+BQnuHGOZyVC+skiM+QJii7TUIC89MUHTdxLQl7G1rabXHIFsR3IY5bsVv9egfFT1+
         hPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708924800; x=1709529600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvD9c59bJDsB22IC2oo8c8Y8bED38e+VeFaxxSdJnPM=;
        b=BOiJlJUA7PRBbNsoXPoIY+4jqIxmowbiZDwh/BgM2ZTrIu+MLbttnun9T05izB0ebf
         XZUDX7y56FBwNobDHrbz9kG+KMj0MJ3wkLwx7+TgghPyY7DxNf00GEJmC6lsB9wGgRQi
         w2yPOJJxyCQCQwM/182rc4j6jbf12AlEEiA7HUqglmxYWPZfZd5uGHeMjS8aaQ6dJdS4
         LN5YSFYho/VSNq5+xcvbxEgh2p8w3uizPDTfCXDschcVGvM80wZRIOXqF6Muzr1z4Idt
         TihDMyXDTGQX6MYSPJyipIbYzKg98ztqV3AoXo19dSoqhWEug6e30HprGBNt2MDSbIcy
         m/0A==
X-Forwarded-Encrypted: i=1; AJvYcCXYvWLzX6XNJNNBH4kgGduYR6hnv2I08rw5+T+u/vA+t9QXa3NCpQdxnj414bTz4SqUDIlgub2nQHZcbz5suQ5Ji4EkCmIp
X-Gm-Message-State: AOJu0YwM+ImDxWG4bU0h/DOmS4A4XglXzmHczuxeA0XWOigSRBBwSIAi
	32vCiXtdvf3A1CpZPYSC3irlRRe7LaWriCYEiP3aEjamYyQZqxcQZGZr77vTxK3RL+l7X3ssaIt
	Rgv2tajaVTnIZGsGm6VgOtobIWw1kFRHFVtwcxg==
X-Google-Smtp-Source: AGHT+IFhPWWZbPSpZ41rJEGw9JQOC3MSyyZstWUE8ZQsGCxE1OndwcIjQLNxLORidft8I/HoA5DyZytqJFxaLx8Id3o=
X-Received: by 2002:a05:6e02:d0d:b0:364:216e:d1dc with SMTP id
 g13-20020a056e020d0d00b00364216ed1dcmr6656541ilj.22.1708924800237; Sun, 25
 Feb 2024 21:20:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
 <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
 <CAJve8om2oOLg5-wKX7m7cBTgzwqiMcb35x=nDi1edY8evXjyMw@mail.gmail.com> <2c96c61a-2685-4cee-9cef-963ed833bf92@rivosinc.com>
In-Reply-To: <2c96c61a-2685-4cee-9cef-963ed833bf92@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 26 Feb 2024 10:49:48 +0530
Message-ID: <CAAhSdy2TVSt=gCJRf78AzXNVFKy8MGJ+QspSEHeedT7GPAYkUQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
To: Atish Patra <atishp@rivosinc.com>
Cc: Haibo Xu <xiaobo55x@gmail.com>, Atish Patra <atishp@atishpatra.org>, 
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

On Wed, Feb 21, 2024 at 2:07=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> On 2/20/24 18:13, Haibo Xu wrote:
> > On Wed, Feb 21, 2024 at 7:03=E2=80=AFAM Atish Patra <atishp@atishpatra.=
org> wrote:
> >>
> >> On Mon, Jan 22, 2024 at 1:48=E2=80=AFAM Haibo Xu <haibo1.xu@intel.com>=
 wrote:
> >>>
> >>> Move vcpu_has_ext to the processor.c and rename it to __vcpu_has_ext
> >>> so that other test cases can use it for vCPU extension check.
> >>>
> >>> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> >>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >>> ---
> >>>   tools/testing/selftests/kvm/include/riscv/processor.h |  2 ++
> >>>   tools/testing/selftests/kvm/lib/riscv/processor.c     | 10 ++++++++=
++
> >>>   tools/testing/selftests/kvm/riscv/get-reg-list.c      | 11 +-------=
---
> >>>   3 files changed, 13 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/=
tools/testing/selftests/kvm/include/riscv/processor.h
> >>> index b68b1b731a34..bd27e1c67579 100644
> >>> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> >>> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> >>> @@ -42,6 +42,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, =
uint64_t idx,
> >>>   #define RISCV_ISA_EXT_REG(idx) __kvm_reg_id(KVM_REG_RISCV_ISA_EXT, =
\
> >>>                                               idx, KVM_REG_SIZE_ULONG=
)
> >>>
> >>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> >>> +
> >>>   struct ex_regs {
> >>>          unsigned long ra;
> >>>          unsigned long sp;
> >>> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tool=
s/testing/selftests/kvm/lib/riscv/processor.c
> >>> index 39a1e9902dec..dad73ce18164 100644
> >>> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> >>> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> >>> @@ -15,6 +15,16 @@
> >>>
> >>>   static vm_vaddr_t exception_handlers;
> >>>
> >>> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> >>> +{
> >>> +       unsigned long value =3D 0;
> >>> +       int ret;
> >>> +
> >>> +       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> >>> +
> >>> +       return !ret && !!value;
> >>> +}
> >>> +
> >>
> >> Not sure what was the base patch on which this was rebased. The actual
> >> commit in the queue branch looks different.
> >>
> >
> > This patch set was based on 6.7-rc8.
> >
> >> https://github.com/kvm-riscv/linux/commit/5563517cc2012e3326411b360c99=
24d3f2706c8d
> >>
> >> Both seem to have the same bug though the tests fail now and require
> >> the following fix.
> >> The ext id should be uint64_t and we need to pass ext directly so that
> >> SBI extension tests can also pass.
> >>
> >
> > It's weird that 6.7-rc8 has already included Andrew's change on the ISA=
 ext reg,
> > but this patch was not generated against his change.
> >
> > commit bdf6aa328f137e184b0fce607fd585354c3742f1
> > Author: Andrew Jones <ajones@ventanamicro.com>
> > Date:   Wed Dec 13 18:09:58 2023 +0100
> >
> >      RISC-V: KVM: selftests: Treat SBI ext regs like ISA ext regs
> >
> > Anyway, your changes were right. Please go ahead to include them when m=
erging.
> >
>
> I am not sure what happened. Probably, a merge conflict issue.
>
> I just realized I forgot to copy paste another fix in arch timer
>
> +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> @@ -85,7 +85,7 @@ struct kvm_vm *test_vm_create(void)
>          int nr_vcpus =3D test_args.nr_vcpus;
>
>          vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> -       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0], KVM_RISCV_ISA_EXT_SSTC),
> +       __TEST_REQUIRE(__vcpu_has_ext(vcpus[0],
> RISCV_ISA_EXT_REG(KVM_RISCV_ISA_EXT_SSTC)),

I have squashed this change into an existing commit in riscv_kvm_queue.

Thanks,
Anup

>
>
> > Thanks,
> > Haibo
> >
> >>
> >> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> >> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> >> @@ -48,7 +48,7 @@ static inline uint64_t __kvm_reg_id(uint64_t type,
> >> uint64_t subtype,
> >> KVM_REG_RISCV_SBI_SINGLE, \
> >> idx, KVM_REG_SIZE_ULONG)
> >>
> >> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> >> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
> >>
> >> struct ex_regs {
> >> unsigned long ra;
> >> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c
> >> b/tools/testing/selftests/kvm/lib/riscv/processor.c
> >> index 282587cd4bbc..ec66d331a127 100644
> >> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> >> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> >> @@ -15,12 +15,12 @@
> >>
> >> static vm_vaddr_t exception_handlers;
> >>
> >> -bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> >> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
> >> {
> >> unsigned long value =3D 0;
> >> int ret;
> >>
> >> - ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> >> + ret =3D __vcpu_get_reg(vcpu, ext, &value);
> >>
> >> return !ret && !!value;
> >> }
> >>
> >> With the above the fix, Both SBI/ISA extension tests pass.
> >> # ./get-reg-list
> >> sbi-base: PASS
> >> sbi-sta: PASS
> >> sbi-pmu: PASS
> >> sbi-dbcn: PASS
> >> aia: PASS
> >> fp_f: PASS
> >> fp_d: PASS
> >> 1..0 # SKIP - h not available, skipping tests
> >> smstateen: PASS
> >> sscofpmf: PASS
> >> sstc: PASS
> >> 1..0 # SKIP - svinval not available, skipping tests
> >> 1..0 # SKIP - svnapot not available, skipping tests
> >> 1..0 # SKIP - svpbmt not available, skipping tests
> >> zba: PASS
> >> zbb: PASS
> >> zbc: PASS
> >> 1..0 # SKIP - zbkb not available, skipping tests
> >> 1..0 # SKIP - zbkc not available, skipping tests
> >> 1..0 # SKIP - zbkx not available, skipping tests
> >> zbs: PASS
> >> zfa: PASS
> >> 1..0 # SKIP - zfh not available, skipping tests
> >> 1..0 # SKIP - zfhmin not available, skipping tests
> >> zicbom: PASS
> >> zicboz: PASS
> >> zicntr: PASS
> >> 1..0 # SKIP - zicond not available, skipping tests
> >> zicsr: PASS
> >> zifencei: PASS
> >> zihintntl: PASS
> >> zihintpause: PASS
> >> zihpm: PASS
> >>
> >>
> >>>   static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> >>>   {
> >>>          return (v + vm->page_size) & ~(vm->page_size - 1);
> >>> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools=
/testing/selftests/kvm/riscv/get-reg-list.c
> >>> index 25de4b8bc347..ed29ba45588c 100644
> >>> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> >>> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> >>> @@ -75,15 +75,6 @@ bool check_reject_set(int err)
> >>>          return err =3D=3D EINVAL;
> >>>   }
> >>>
> >>> -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> >>> -{
> >>> -       int ret;
> >>> -       unsigned long value;
> >>> -
> >>> -       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> >>> -       return (ret) ? false : !!value;
> >>> -}
> >>> -
> >>>   void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
> >>>   {
> >>>          unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] =3D { 0 }=
;
> >>> @@ -111,7 +102,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct =
vcpu_reg_list *c)
> >>>                  __vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), =
1);
> >>>
> >>>                  /* Double check whether the desired extension was en=
abled */
> >>> -               __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> >>> +               __TEST_REQUIRE(__vcpu_has_ext(vcpu, s->feature),
> >>>                                 "%s not available, skipping tests\n",=
 s->name);
> >>>          }
> >>>   }
> >>> --
> >>> 2.34.1
> >>>
> >>
> >>
> >> --
> >> Regards,
> >> Atish
>

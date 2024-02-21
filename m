Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993EC46B9B
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708520914; cv=none; b=LakiIqKHUyZDqBFNxIFk48rOPdDGFU5ZcuFbiRirWoRBYVc6AeFhKEclbI/DurOh8Tb52AHURTqO4qRUFD8taqoTjwQWVpRZFIf3RxMSOnwlcTFi3Wy8qNbDdohWKHRK53+ofZp0/ygZJHu7zyRr9nk/YzW/mUkpQEf+icMvmwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708520914; c=relaxed/simple;
	bh=mWIx9PFeZocge748YA69ilYWO8vp7pIz8+RNbYpKzr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hpNy2uQqVmFgBryzbGrgWFAKtUx/5AiUB6gg20rgBpVIp8C7dCFU2IJ/TtpxlmlxXr07bs6evthotrnzs0//JavtAuifV0VIV6ZQkDYFhWr1g/Lei/t238BO+XyTQXtvo48InCD3VeKWqzdQmMGU+j2j34ITGs41ZWd2D9a+qRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxCawtqz; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxCawtqz"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so87379381fa.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 05:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708520911; x=1709125711; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxTdzzSE56mojm4+aLf5g+MB1IpHlx8dtkV73gFQqhM=;
        b=jxCawtqzIheCSTDZjKVmyvx6i2MTL960pRwOopt4MSPVP+SALMRpbjgnR8/uJc/0Bk
         xUIwFrMXaOP/nMokuhO/HnMr+1uiZpnx0kl1Mrcz7XB+AafoaqshTLTTPX7fRn3WXl3K
         iSSL2UB1/HSiSxhszf8zD6Qui4sa8N5O4vxoxb90xkr6egSFICxBRSusw7OHfwBva2XB
         sGkQuUTkEF/djl5F1pCnYavqrzsk4ETMsp2GStHm/DPKpe/r+Y4gi/jDfaUNvJ6epXD4
         Pp9fVTP5pGYrBlVJrl/Tdju/Pw2n/8QYoUn14/aOq/KaM3UlW4N0SpiBy4yQmKNPb8ZR
         krmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708520911; x=1709125711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxTdzzSE56mojm4+aLf5g+MB1IpHlx8dtkV73gFQqhM=;
        b=xNCqZY/3cu0dWbVPb4lUZm+QuDmcKoAhhThG4dc0QjkwLthGWR3oeeyd+TR22DFZ/Z
         LzhCXExOQdmX7Zt6QKdLxNvAHr0R7alD4hGXeEZlKl0b31mwaLYyQqdefKB9wPZQiClM
         d30SyMl4VofRUJPCkKwQgpZ4k0D3n1QTJhp+0EijZeqbxOg8CLoMWg/mQbyey1jRuzio
         I7VM4VWqDAQbUvrckUu9P/IrPZg4Pgax0OC5yV1REhwXRhIdbSP8rQ3fPjK3rckTq7Mg
         ospHI0w6zE5biIU2CppXM+1gvAmjDsBUpjDBafWww+XYq+L0fPIvmlucaGvLtX61mx6d
         EOUg==
X-Forwarded-Encrypted: i=1; AJvYcCXYUgdEpynC1ZCqxmU8d36dAP8PF9DHrQuddfrjbtaEeQ6/1Jud1AgfA3AzAh0ojVM4sMZZjwriiqHRGNy9+V3DrYZovT5g
X-Gm-Message-State: AOJu0YzeW5br5xIt25zp0/JinkPEtV2K5LQTmePuGgRoU2PbsxrOYESd
	22BnRtV8agpXLcvpZSGz0KVppOL9Uf6I7ec/kLtYwQAs8ADQc3MVqcXhmCV1oASisysvu/5Bcaf
	JHjgxrZ/6NoCvIu8YEbWBdmAAh+c=
X-Google-Smtp-Source: AGHT+IEk4EjMAGYcW7Lzh75VAr5eflBXeC5jYHyhHnNqToNfa6pIH+DcVLj0qhM47mORzIqfli6g83qnltBwS3v9GvE=
X-Received: by 2002:a2e:6e08:0:b0:2d0:aa06:f496 with SMTP id
 j8-20020a2e6e08000000b002d0aa06f496mr12067305ljc.40.1708520910575; Wed, 21
 Feb 2024 05:08:30 -0800 (PST)
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
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 21 Feb 2024 21:08:19 +0800
Message-ID: <CAJve8omCZxsiP1jF0n5SBh0_U6q7Exj5A1ACFahWpdBoxohaMA@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
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

On Wed, Feb 21, 2024 at 4:37=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
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
>

Right Fix!
Please let me know if I need to rebase this patch series on your tree
and resent it.

Thanks,
Haibo

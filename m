Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C8154C03
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708470236; cv=none; b=YvvYP0EHRoSHHcIbReSb3txpzCAdvZP8EsaBdfRX/H0ZAwvAokFAxep0GDBi+sjMODXRCTVBVCQpSW7Mhm/WUyGJ4dMNN14x+Nn3fPM6mKv89RaGwpFNBypc0JvSSpVlpIJSSqvln75BT0SCOIxDw6IOfaeCCZvu2Gj7ChsR+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708470236; c=relaxed/simple;
	bh=mL0tHNbpRNJfM7MBgHBurNu693ubcSIDZDSiHBuy7vQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+kdXlTpy2rnF9Ypr7Y2AoWrrjQMIgaX8YOa3NHukxjuICIyeRHuhM9ABRUnX2gL+zJ/RRizDHibuv0RX0E5XYHV8isKJLc/b3mJy3ZrcyVF6lPRjoeVWKiVhsaMyw1Iem30FlM7F2Pod9NecOkt+hZSwe4mXRXhbCyv8TeX/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=Tc4MvWMQ; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="Tc4MvWMQ"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5129e5b8cecso5056254e87.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1708470232; x=1709075032; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqH0ROPbbtIdqXSURYkySpHgNfveY4dFLQe0qUwTePc=;
        b=Tc4MvWMQPyc2sSOSdlAJ7512/N3tfhonEzf8mAKGctnamRQRW04+o9m5J32xPJSyMv
         rdGzmrvLsCs1zgiLrw+mTuUguL43+rpBoKedCGKTa5SoZPhk/3TI97RaVpM2Mr3yh9VC
         WSqjZ6jhHzSyYJqCH5YTXbLCh6TGFjSfsFOoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708470232; x=1709075032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqH0ROPbbtIdqXSURYkySpHgNfveY4dFLQe0qUwTePc=;
        b=eXDDopaBu6RtcONpvFt092XxXZNSY407FM7xwuYKw0XpkUG/zRJE88lznOZNJM2Ow1
         IGWQ6AdmknIf3d7USImKwZcjPLHQxUIzBCCjxJteM5tP8B2tgie0e7HC3ZMZipOVRPmu
         L7FNdNjdysfpbWdNNSQSdq5EBZPC5JBdLnYTn+7uvVhe0URc/U3kIAV0FB+yIkj0Qc5h
         mCXecvgpP/21QggEIhQlt+dian0rN3zWY2b8Gx9blURsuQH7oxeEbzpAKyxN6Fwuy4Gz
         9xmHdb2vK0SEMIf4JG0CfUxYFaUoPe7DtZ4mPiMN8ptmlEaCCVhxEPDoT065as8GW1d7
         jnDA==
X-Forwarded-Encrypted: i=1; AJvYcCUtnzqcwkhllg0nTa9fkUESNNCTVwdBn9Wsho+gpJF/Pj1o0fw+Cx/1S6rrkUig4vrXk5qd7ylsp63xvTkBMuDkzbvN+xkT
X-Gm-Message-State: AOJu0YxV3NmvxHh0huWyOVNhCCjVdDhWv/vHBpnKnTBj6JKljGDWSaOy
	CQkZimJJ+YO826huUhY4m64tqYov8kxHHHSTjnW9yPSI0UdRd6ruBVorIFkUHHhYpHf7unis1tn
	wNnIENHJHKLUnVlyfje4ykoDoMPHn3FC3c3Aa
X-Google-Smtp-Source: AGHT+IHvIMp97EquM1HGvlF+EshWPYeFqFX2gVhb+xvtJN9u9TgHl4t/ylyvXaDa1s3oTu4/8hBS3HdAlZdC/VROf90=
X-Received: by 2002:a05:6512:3a8b:b0:512:a964:f222 with SMTP id
 q11-20020a0565123a8b00b00512a964f222mr7687790lfu.21.1708470231958; Tue, 20
 Feb 2024 15:03:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
In-Reply-To: <68856b86a93a4188558e5d0ebac0dd6aac8e404c.1705916069.git.haibo1.xu@intel.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Tue, 20 Feb 2024 15:03:40 -0800
Message-ID: <CAOnJCULwRTSnrQkR2o1P53R=tJ3TAxX+y+XRBesW6OFEzgFv2g@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] KVM: riscv: selftests: Change vcpu_has_ext to a
 common function
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, ajones@ventanamicro.com, 
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

On Mon, Jan 22, 2024 at 1:48=E2=80=AFAM Haibo Xu <haibo1.xu@intel.com> wrot=
e:
>
> Move vcpu_has_ext to the processor.c and rename it to __vcpu_has_ext
> so that other test cases can use it for vCPU extension check.
>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h |  2 ++
>  tools/testing/selftests/kvm/lib/riscv/processor.c     | 10 ++++++++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c      | 11 +----------
>  3 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tool=
s/testing/selftests/kvm/include/riscv/processor.h
> index b68b1b731a34..bd27e1c67579 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -42,6 +42,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint=
64_t idx,
>  #define RISCV_ISA_EXT_REG(idx) __kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
>                                              idx, KVM_REG_SIZE_ULONG)
>
> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
> +
>  struct ex_regs {
>         unsigned long ra;
>         unsigned long sp;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/te=
sting/selftests/kvm/lib/riscv/processor.c
> index 39a1e9902dec..dad73ce18164 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -15,6 +15,16 @@
>
>  static vm_vaddr_t exception_handlers;
>
> +bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> +{
> +       unsigned long value =3D 0;
> +       int ret;
> +
> +       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> +
> +       return !ret && !!value;
> +}
> +

Not sure what was the base patch on which this was rebased. The actual
commit in the queue branch looks different.

https://github.com/kvm-riscv/linux/commit/5563517cc2012e3326411b360c9924d3f=
2706c8d

Both seem to have the same bug though the tests fail now and require
the following fix.
The ext id should be uint64_t and we need to pass ext directly so that
SBI extension tests can also pass.


--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -48,7 +48,7 @@ static inline uint64_t __kvm_reg_id(uint64_t type,
uint64_t subtype,
KVM_REG_RISCV_SBI_SINGLE, \
idx, KVM_REG_SIZE_ULONG)

-bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext);
+bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);

struct ex_regs {
unsigned long ra;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c
b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 282587cd4bbc..ec66d331a127 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -15,12 +15,12 @@

static vm_vaddr_t exception_handlers;

-bool __vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
+bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
{
unsigned long value =3D 0;
int ret;

- ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
+ ret =3D __vcpu_get_reg(vcpu, ext, &value);

return !ret && !!value;
}

With the above the fix, Both SBI/ISA extension tests pass.
# ./get-reg-list
sbi-base: PASS
sbi-sta: PASS
sbi-pmu: PASS
sbi-dbcn: PASS
aia: PASS
fp_f: PASS
fp_d: PASS
1..0 # SKIP - h not available, skipping tests
smstateen: PASS
sscofpmf: PASS
sstc: PASS
1..0 # SKIP - svinval not available, skipping tests
1..0 # SKIP - svnapot not available, skipping tests
1..0 # SKIP - svpbmt not available, skipping tests
zba: PASS
zbb: PASS
zbc: PASS
1..0 # SKIP - zbkb not available, skipping tests
1..0 # SKIP - zbkc not available, skipping tests
1..0 # SKIP - zbkx not available, skipping tests
zbs: PASS
zfa: PASS
1..0 # SKIP - zfh not available, skipping tests
1..0 # SKIP - zfhmin not available, skipping tests
zicbom: PASS
zicboz: PASS
zicntr: PASS
1..0 # SKIP - zicond not available, skipping tests
zicsr: PASS
zifencei: PASS
zihintntl: PASS
zihintpause: PASS
zihpm: PASS


>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
>         return (v + vm->page_size) & ~(vm->page_size - 1);
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index 25de4b8bc347..ed29ba45588c 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -75,15 +75,6 @@ bool check_reject_set(int err)
>         return err =3D=3D EINVAL;
>  }
>
> -static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
> -{
> -       int ret;
> -       unsigned long value;
> -
> -       ret =3D __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
> -       return (ret) ? false : !!value;
> -}
> -
>  void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
>  {
>         unsigned long isa_ext_state[KVM_RISCV_ISA_EXT_MAX] =3D { 0 };
> @@ -111,7 +102,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu=
_reg_list *c)
>                 __vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), 1);
>
>                 /* Double check whether the desired extension was enabled=
 */
> -               __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> +               __TEST_REQUIRE(__vcpu_has_ext(vcpu, s->feature),
>                                "%s not available, skipping tests\n", s->n=
ame);
>         }
>  }
> --
> 2.34.1
>


--=20
Regards,
Atish

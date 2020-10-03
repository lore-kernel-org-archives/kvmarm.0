Return-Path: <SRS0=06hh=DK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E081C41604
	for <kvmarm@archiver.kernel.org>; Sat,  3 Oct 2020 12:29:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 951A1207DE
	for <kvmarm@archiver.kernel.org>; Sat,  3 Oct 2020 12:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLvU32BJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 951A1207DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3804B534;
	Sat,  3 Oct 2020 08:29:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Klm9-RdfHPd; Sat,  3 Oct 2020 08:29:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F1B64B208;
	Sat,  3 Oct 2020 08:29:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5394B208
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Oct 2020 08:29:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QeigxkmE2+yM for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Oct 2020 08:28:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3F454B098
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Oct 2020 08:28:58 -0400 (EDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BB589207FF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Oct 2020 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601728137;
 bh=pKYophhnbxUFQES3EiqNngBxHHAmupdd6XWFqclNWAI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ZLvU32BJYfuadXqfJNRDKD/SsfM05GDNgXEeoUtHP4ZaO5BBRrVrCzCK5PoxCs+5C
 JbZcB/QHXZrHNijJgyxrfwe9tSkOUJJGmowWNlbzn8Zm5PXU2Ac1n+fdt2V2tynuvI
 IN1wJd3GD08QllOa8z3lxjLY8j9PNkKLQ9v6QJkE=
Received: by mail-oi1-f171.google.com with SMTP id y123so391155oie.11
 for <kvmarm@lists.cs.columbia.edu>; Sat, 03 Oct 2020 05:28:57 -0700 (PDT)
X-Gm-Message-State: AOAM5337R4cYrRrDhH059K1b6g94UffmJYLDDVydvPD6exy0Iq9ZbjYz
 5FW44NYIkTNk6GUhzJxtRVZ+LGujNkhHKVdkpEs=
X-Google-Smtp-Source: ABdhPJw1IfL85GWfK5lkMrDYEsETT4Wj7yW42+CZ2a0USL2hm8jKBoFwV6zuWQL6EYYfxJsv/12M73peIKLvCCz0B0g=
X-Received: by 2002:a05:6808:8e5:: with SMTP id
 d5mr3842236oic.33.1601728137060; 
 Sat, 03 Oct 2020 05:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201003085604.7138-1-ardb@kernel.org>
 <20201003103042.rqtjfhcoyzrznqex@kamzik.brq.redhat.com>
In-Reply-To: <20201003103042.rqtjfhcoyzrznqex@kamzik.brq.redhat.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 3 Oct 2020 14:28:46 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE8KFa+FbpuAjXzefzPam9c+WTxZSawAVLsj6HQQmffgA@mail.gmail.com>
Message-ID: <CAMj1kXE8KFa+FbpuAjXzefzPam9c+WTxZSawAVLsj6HQQmffgA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: implement the TRNG hypervisor call
To: Andrew Jones <drjones@redhat.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 Leif Lindholm <leif@nuviainc.com>, Laszlo Ersek <lersek@redhat.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, 3 Oct 2020 at 12:30, Andrew Jones <drjones@redhat.com> wrote:
>
> Hi Ard,
>

Hi Drew,

Thanks for taking a look.

> On Sat, Oct 03, 2020 at 10:56:04AM +0200, Ard Biesheuvel wrote:
> > Provide a hypervisor implementation of the ARM architected TRNG firmware
> > interface described in ARM spec DEN0098. All function IDs are implemented,
> > including both 32-bit and 64-bit versions of the TRNG_RND service, which
> > is the centerpiece of the API.
> >
> > The API is backed by arch_get_random_seed_long(), which is implemented
> > in terms of RNDR currently, and will be alternatively backed by a SMC
> > call to the secure firmware using same interface after a future patch.
> > If neither are available, the kernel's entropy pool is used instead.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: Sami Mujawar <sami.mujawar@arm.com>
> > Cc: Andre Przywara <andre.przywara@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Laszlo Ersek <lersek@redhat.com>
> > Cc: Leif Lindholm <leif@nuviainc.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +
> >  arch/arm64/kvm/Makefile           |  2 +-
> >  arch/arm64/kvm/hypercalls.c       |  6 ++
> >  arch/arm64/kvm/trng.c             | 91 ++++++++++++++++++++
> >  include/linux/arm-smccc.h         | 31 +++++++
> >  5 files changed, 131 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 65568b23868a..f76164d390ea 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -688,4 +688,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> >  #define kvm_arm_vcpu_sve_finalized(vcpu) \
> >       ((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> >
> > +int kvm_trng_call(struct kvm_vcpu *vcpu);
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 99977c1972cc..e117d7086500 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> >        inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
> >        guest.o debug.o reset.o sys_regs.o \
> >        vgic-sys-reg-v3.o fpsimd.o pmu.o \
> > -      aarch32.o arch_timer.o \
> > +      aarch32.o arch_timer.o trng.o \
> >        vgic/vgic.o vgic/vgic-init.o \
> >        vgic/vgic-irqfd.o vgic/vgic-v2.o \
> >        vgic/vgic-v3.o vgic/vgic-v4.o \
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 550dfa3e53cd..70c5e815907d 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -62,6 +62,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               if (gpa != GPA_INVALID)
> >                       val = gpa;
> >               break;
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +     case ARM_SMCCC_TRNG_RND:
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_trng_call(vcpu);
> >       default:
> >               return kvm_psci_call(vcpu);
> >       }
> > diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> > new file mode 100644
> > index 000000000000..71f704075e4a
> > --- /dev/null
> > +++ b/arch/arm64/kvm/trng.c
> > @@ -0,0 +1,91 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (C) 2020 Arm Ltd.
> > +
> > +#include <linux/arm-smccc.h>
> > +#include <linux/kvm_host.h>
> > +
> > +#include <asm/kvm_emulate.h>
> > +
> > +#include <kvm/arm_hypercalls.h>
> > +
> > +#define ARM_SMCCC_TRNG_VERSION_1_0   0x10000UL
> > +
> > +#define TRNG_SUCCESS                 0UL
> > +#define TRNG_NOT_SUPPORTED           ((unsigned long)-1)
> > +#define TRNG_INVALID_PARAMETER               ((unsigned long)-2)
> > +#define TRNG_NO_ENTROPY                      ((unsigned long)-3)
> > +
> > +#define MAX_BITS32                   96
> > +#define MAX_BITS64                   192
> > +
> > +static const uuid_t arm_smc_trng_uuid __aligned(4) = UUID_INIT(
> > +     0x023534a2, 0xe0bc, 0x45ec, 0x95, 0xdd, 0x33, 0x34, 0xc1, 0xcc, 0x31, 0x89);
>
> Where does this UUID come from?
>

uuidgen

The only requirement for the UUID is that we can distinguish
implementations, in order to be able to disregard them if they are
known to have flaws.

You could make a case for passing the firmware's UUID if the calls are
relayed directly, but that would remove the caller's ability to avoid
the KVM on specifically.

> > +
> > +static int kvm_trng_do_rnd(struct kvm_vcpu *vcpu, int size)
> > +{
> > +     u32 num_bits = smccc_get_arg1(vcpu);
> > +     u64 bits[3];
> > +     int i;
> > +
> > +     if (num_bits > 3 * size) {
> > +             smccc_set_retval(vcpu, TRNG_NOT_SUPPORTED, 0, 0, 0);
>
> The spec says we should return "INVALID_PARAMETERS" when N > MAX_BITS.
> Of course "INVALID_PARAMETERS", with the 'S', doesn't exist in "Return
> codes", but I guess they meant "INVALID_PARAMETER", not NOT_SUPPORTED.
>

Will fix that.

> > +             return 1;
> > +     }
> > +
> > +     /* get as many bits as we need to fulfil the request */
> > +     for (i = 0; i < DIV_ROUND_UP(num_bits, 64); i++)
> > +             /* use the arm64 specific backend directly if one exists */
> > +             if (!arch_get_random_seed_long((unsigned long *)&bits[i]))
> > +                     bits[i] = get_random_long();
> > +
> > +     if (num_bits % 64)
> > +             bits[i - 1] &= U64_MAX >> (64 - (num_bits % 64));
> > +
> > +     while (i < ARRAY_SIZE(bits))
> > +             bits[i++] = 0;
> > +
> > +     if (size == 32)
> > +             smccc_set_retval(vcpu, TRNG_SUCCESS, lower_32_bits(bits[1]),
> > +                              upper_32_bits(bits[0]), lower_32_bits(bits[0]));
> > +     else
> > +             smccc_set_retval(vcpu, TRNG_SUCCESS, bits[2], bits[1], bits[0]);
> > +
> > +     memzero_explicit(bits, sizeof(bits));
> > +     return 1;
> > +}
> > +
> > +int kvm_trng_call(struct kvm_vcpu *vcpu)
> > +{
> > +     const __be32 *u = (__be32 *)arm_smc_trng_uuid.b;
> > +     u32 func_id = smccc_get_function(vcpu);
> > +     unsigned long val = TRNG_NOT_SUPPORTED;
> > +     int size = 64;
> > +
> > +     switch (func_id) {
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +             val = ARM_SMCCC_TRNG_VERSION_1_0;
> > +             break;
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +             switch (smccc_get_arg1(vcpu)) {
> > +             case ARM_SMCCC_TRNG_VERSION:
> > +             case ARM_SMCCC_TRNG_FEATURES:
> > +             case ARM_SMCCC_TRNG_GET_UUID:
> > +             case ARM_SMCCC_TRNG_RND:
> > +             case ARM_SMCCC_TRNG_RND64:
> > +                     val = TRNG_SUCCESS;
> > +             }
> > +             break;
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +             smccc_set_retval(vcpu, be32_to_cpu(u[3]), be32_to_cpu(u[2]),
> > +                              be32_to_cpu(u[1]), be32_to_cpu(u[0]));
>
> What if our host CPU is BE? We need to return these words in LE according
> to 5.3 of DEN0028C.
>

I hadn't looked at DEN0028C 5.3 at all, to be honest.

So we should interpret the whole uuid_t as __le32[4] not __be32[4],
switch to the appropriate accessors, and reverse the order of the
registers. That way, the first byte of the uuid_t will end up in the
least significant byte of W0, etc etc.

> > +             return 1;
> > +     case ARM_SMCCC_TRNG_RND:
> > +             size = 32;
> > +             fallthrough;
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_trng_do_rnd(vcpu, size);
> > +     }
> > +
> > +     smccc_set_retval(vcpu, val, 0, 0, 0);
> > +     return 1;
> > +}
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 15c706fb0a37..9c9decd329b7 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -99,6 +99,37 @@
> >                          ARM_SMCCC_OWNER_STANDARD_HYP,        \
> >                          0x21)
> >
> > +/* TRNG entropy source calls (defined by ARM DEN0098) */
> > +#define ARM_SMCCC_TRNG_VERSION                                       \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
> > +                        ARM_SMCCC_SMC_32,                    \
> > +                        ARM_SMCCC_OWNER_STANDARD,            \
> > +                        0x50)
> > +
> > +#define ARM_SMCCC_TRNG_FEATURES                                      \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
> > +                        ARM_SMCCC_SMC_32,                    \
> > +                        ARM_SMCCC_OWNER_STANDARD,            \
> > +                        0x51)
> > +
> > +#define ARM_SMCCC_TRNG_GET_UUID                                      \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
> > +                        ARM_SMCCC_SMC_32,                    \
> > +                        ARM_SMCCC_OWNER_STANDARD,            \
> > +                        0x52)
> > +
> > +#define ARM_SMCCC_TRNG_RND                                   \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
> > +                        ARM_SMCCC_SMC_32,                    \
> > +                        ARM_SMCCC_OWNER_STANDARD,            \
> > +                        0x53)
> > +
> > +#define ARM_SMCCC_TRNG_RND64                                 \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
> > +                        ARM_SMCCC_SMC_64,                    \
> > +                        ARM_SMCCC_OWNER_STANDARD,            \
> > +                        0x53)
> > +
> >  /*
> >   * Return codes defined in ARM DEN 0070A
> >   * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
> > --
> > 2.17.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

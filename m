Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8E1C55178
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 16:20:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64A1720786
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 16:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uABdt9+A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A1720786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 854194B83E;
	Thu,  5 Nov 2020 11:20:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s+-+9CRpk8zg; Thu,  5 Nov 2020 11:20:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 222934B83F;
	Thu,  5 Nov 2020 11:20:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B499D4B83A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 11:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xKhnxqjzjjKu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 11:20:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A0154B835
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 11:20:01 -0500 (EST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DE4682080D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604593200;
 bh=sS22vxIZDi4NOm8xudJ/5xxjz8Tzu4GxeBEAHP8gQoo=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=uABdt9+ASM5zp/5OFILqrZ12Jxjnlq6eN8ePajlX5Exvya89M5IMAabpz9iOK1CHC
 B7FwCROhmfPXXCahuThFMnuRjtXnkSOnHQXPNivyFn4MY0+S30lhK/YZB5c7mF18Bc
 Y85LfkAKENDcJia6TYkENhsGsr4/cPhMhyyIBcdc=
Received: by mail-ot1-f48.google.com with SMTP id f16so1849609otl.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 08:19:59 -0800 (PST)
X-Gm-Message-State: AOAM532JdVduh9S+RY8MYg3W3P1h1FCpldI9loGjiKCHZhT9F45tB4Rx
 sh28orAMOE2l1iQ6E5uOACf/8U8zztg5sMKenWA=
X-Google-Smtp-Source: ABdhPJw1mzFErJ+tdXRX5RrZ2rbqulpZ/JCjoTEM/bT2vIcmmQvQauCrxfHSQA9MFQBKus9VxJR60hZfXbO59H/WBmg=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr2149221otk.108.1604593199077; 
 Thu, 05 Nov 2020 08:19:59 -0800 (PST)
MIME-Version: 1.0
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-6-andre.przywara@arm.com>
 <56c0505297b4588b413ae57ee39b894f@misterjones.org>
In-Reply-To: <56c0505297b4588b413ae57ee39b894f@misterjones.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 5 Nov 2020 17:19:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH+YYWh+p-+XjAnC8CgwWrBCoGi6yRHfaH2-FHk1NP9YA@mail.gmail.com>
Message-ID: <CAMj1kXH+YYWh+p-+XjAnC8CgwWrBCoGi6yRHfaH2-FHk1NP9YA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: implement the TRNG hypervisor call
To: Marc Zyngier <maz@misterjones.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
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

On Thu, 5 Nov 2020 at 15:13, Marc Zyngier <maz@misterjones.org> wrote:
>
> On 2020-11-05 12:56, Andre Przywara wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Provide a hypervisor implementation of the ARM architected TRNG
> > firmware
> > interface described in ARM spec DEN0098. All function IDs are
> > implemented,
> > including both 32-bit and 64-bit versions of the TRNG_RND service,
> > which
> > is the centerpiece of the API.
> >
> > The API is backed by arch_get_unsigned_seed_long(), which is
> > implemented
> > in terms of RNDRRS currently, and will be alternatively backed by a SMC
> > call to the secure firmware using same interface after a future patch.
> > If neither are available, the kernel's entropy pool is used instead.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +
> >  arch/arm64/kvm/Makefile           |  2 +-
> >  arch/arm64/kvm/hypercalls.c       |  6 ++
> >  arch/arm64/kvm/trng.c             | 91 +++++++++++++++++++++++++++++++
> >  4 files changed, 100 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/kvm/trng.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> > b/arch/arm64/include/asm/kvm_host.h
> > index 781d029b8aa8..615932bacf76 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -652,4 +652,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu
> > *vcpu);
> >  #define kvm_arm_vcpu_sve_finalized(vcpu) \
> >       ((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> >
> > +int kvm_trng_call(struct kvm_vcpu *vcpu);
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 1504c81fbf5d..a510037e3270 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> > $(KVM)/eventfd.o \
> >        inject_fault.o regmap.o va_layout.o handle_exit.o \
> >        guest.o debug.o reset.o sys_regs.o \
> >        vgic-sys-reg-v3.o fpsimd.o pmu.o \
> > -      aarch32.o arch_timer.o \
> > +      aarch32.o arch_timer.o trng.o \
> >        vgic/vgic.o vgic/vgic-init.o \
> >        vgic/vgic-irqfd.o vgic/vgic-v2.o \
> >        vgic/vgic-v3.o vgic/vgic-v4.o \
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 25ea4ecb6449..ead21b98b620 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -71,6 +71,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               if (gpa != GPA_INVALID)
> >                       val = gpa;
> >               break;
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +     case ARM_SMCCC_TRNG_RND32:
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_trng_call(vcpu);
> >       default:
> >               return kvm_psci_call(vcpu);
> >       }
> > diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> > new file mode 100644
> > index 000000000000..5a27b2d99977
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
>
> SMCCC_RET_SUCCESS
>
> > +#define TRNG_NOT_SUPPORTED           ((unsigned long)-1)
>
> SMCCC_RET_NOT_SUPPORTED
>
> > +#define TRNG_INVALID_PARAMETER               ((unsigned long)-2)
>
> *crap*. Why isn't that the same value as SMCCC_RET_INVALID_PARAMETER?
> Is it too late to fix the spec?
>

The SMCC_RET_xxxx and TRNG_xxxx ID spaces are deliberately disjoint,
so that we can add TRNG result codes that are only relevant in the
contex of this ABI without having to modify the SMCCC spec.

> > +#define TRNG_NO_ENTROPY                      ((unsigned long)-3)
> > +
> > +#define MAX_BITS32                   96
> > +#define MAX_BITS64                   192
>
> Nothing seems to be using these definitions.
>

Indeed.

> > +
> > +static const uuid_t arm_smc_trng_uuid __aligned(4) = UUID_INIT(
> > +     0x023534a2, 0xe0bc, 0x45ec, 0x95, 0xdd, 0x33, 0x34, 0xc1, 0xcc, 0x31,
> > 0x89);
>
> I object to the lack of Easter egg in this UUID. Or at least one I can
> understand. ;-)
>
> > +
> > +static int kvm_trng_do_rnd(struct kvm_vcpu *vcpu, int size)
> > +{
> > +     u32 num_bits = smccc_get_arg1(vcpu);
> > +     u64 bits[3];
> > +     int i;
> > +
> > +     if (num_bits > 3 * size) {
> > +             smccc_set_retval(vcpu, TRNG_INVALID_PARAMETER, 0, 0, 0);
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
>
> I just wasted 3 minutes trying to understand what this was doing, only
> to
> realise this is clearing the [MAX_BITS:num_bits] range.
>
> How about using a bitmap instead? It would result in the exact same data
> structure, only much more readable (and no u64->unsigned long casts).
>

Good point.

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
> > +     const __le32 *u = (__le32 *)arm_smc_trng_uuid.b;
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
> > +             case ARM_SMCCC_TRNG_RND32:
> > +             case ARM_SMCCC_TRNG_RND64:
> > +                     val = TRNG_SUCCESS;
> > +             }
> > +             break;
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +             smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
> > +                              le32_to_cpu(u[2]), le32_to_cpu(u[3]));
> > +             return 1;
> > +     case ARM_SMCCC_TRNG_RND32:
> > +             size = 32;
> > +             fallthrough;
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_trng_do_rnd(vcpu, size);
> > +     }
> > +
> > +     smccc_set_retval(vcpu, val, 0, 0, 0);
> > +     return 1;
> > +}
>
> Thanks,
>
>          M.
> --
> Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

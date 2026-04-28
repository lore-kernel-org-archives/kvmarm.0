Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD9344B67D
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388204; cv=none; b=D92sSVWqqW8SrpkWK/RrThCu88VzZYgRiC2wzgQ+x0iLLcTMwxpYwvmqfT+XwNIjOmU8MJZ3thLU+qh+UZDf0/nBvH07rhcBqvF03IyTUtB8Oqu2HkUhL0RUKaNm3HEXiuAA+6JiCm7/GXy4qnaDX7hVWOgGq9jB3ZRiwnDYprQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388204; c=relaxed/simple;
	bh=X8gMWnnX4yynVYZQkh4AeYMeZ1urDtDjbPH/o72X4bc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PLXiJh1iIOsDt4l7hjNclLCOyMd10FNjmHDhf1uB2QSGIwBWk+aD/FC4Tzm83GX9NDEr7+66wVEp725zSg7yiLZnZi3Xr0hzzAdjLpHkVWeyJ8cr/XXlYHZ9SumfU8i4gdB4yo+8o/54mG15OOAI5Hbo5g86j/MOoOa6qv03dHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wQJlm8Fk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wQJlm8Fk"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ad135063so104904605e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1777388195; x=1777992995; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZI5euwIVJ9QjGGXPpUqegNn9IsxNW5sxSo5xHMvQY0=;
        b=wQJlm8Fk3vOilgLRDvi1WES3KXKeJmO+rIP+tNf/puYZ7/FA6dIDP3jpGBSPvIShTc
         2f55cvMY88T87dWaUxHkJ2JeFm69MCaF3XI2v6y36zcHSUH8f/7rsC1yZZrJSK5aEcKo
         iWRiGhupSWTjBkh2s7b3jE8xMO3aTcbrPwYdFqklDHpyuHDiz6u3y756BCXCCG+tcaW+
         Jnxc1ak7n/amvG5hUMIkOTkQsiA83IqL6GBhrpKXhjR5wh7dpX0HZJ0v4uUx3FndFomo
         97NP/dKEAeqQpYg3tEiC3Rf6m+/DtTY9wvEVZKx0AADXtAiE8TZZ+iBgKDodjzq3w7dT
         Wssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777388195; x=1777992995;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZI5euwIVJ9QjGGXPpUqegNn9IsxNW5sxSo5xHMvQY0=;
        b=jODrymFVvWuLVT3nfno9VUYMucdzIM1XzqR3KTfd15TmEBRH9Sg/UR+8tVtGRtPPGC
         dczQBjSJlFjx2p2iuU1O4VdbjG2Sd5lZaXjVFqKhRUtKXEqMT0Si86386K/fRAhHZAIz
         UQrzVIrva5Cw5cHziRPyYu4PUumdXHTOIB/x5Htbg3/64xoPv0QnMBWUVNCbJczc8S0f
         2FADMrAceCyryJfVcS/dH1Bp/dIkJ0wxMgWvz9SLtVgZv+H6AE1ucWM/mt/qwxd9CjMx
         YGuThYzfJ5EIhjlueTUjenszJdjBOZLQx38dWQZiQUKe1EX0fU+Hy+ofKb3GP1G3Z5Uh
         lMVw==
X-Forwarded-Encrypted: i=1; AFNElJ9g2dOteVhsQsCtN1kCTOjlQMEgWT4lAPeGC+vAVW0CZdojMQTirTJzigzcpOcKNl50Y5ecJSk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr8TK1dHyuW88Uy3hd/TVZDsfEexyPSZ/iyyHe4NxzTpq7rfHa
	Z7S2vwX2AOxBDCB4ciVK4W4XU+AolnVEUNiluC1MWM+dzREBMA6BIIeG+mNy7c+oopg=
X-Gm-Gg: AeBDietE3swe8D0b1HtjLU0l99PNusqFVuA5qt/g998GevAIezF2jpmrIPgly89FI/A
	S8toJi2/17Fm7jCVVWzUn0iR1qL5kz6TXDMqJ36peJMKwzlHr2a7hybEG0H9vAGt/7sA6TzyTnE
	FFE4il8BKCwYzlqQaSZdaF7XY9zYe0lBK99NzdZSUKNwMfNPpMamxamcvaJmKjsubhrW6KfC4ZJ
	v52hoGkH0Hn3wjspnZEL1Q7M35L8L9SF1ziA84jA2rhZlTqkUeulhqF1mLdCQo6n8wgfc26rZqX
	U3p9qLD9Hkc+DWkhbXwGW0v0LeR+Av13zYOXEAutEG9Gt6Yayzw2/wGY3OyTAuWRZAYPjYmAalO
	cCHFXz0QDGxlGIdvEQ9xruXSaw5gFsNInK2MW7pcr7EmdkrDTHndK/7MJAGph31L37kQ3SFgzRp
	12PzDkdcYB+EJYXX5XYaz2HtCWPVMHkr+ibw==
X-Received: by 2002:a05:600c:3f14:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-48a7b535a0dmr61415e9.18.1777388195308;
        Tue, 28 Apr 2026 07:56:35 -0700 (PDT)
Received: from draig.lan ([185.124.0.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a774c3ddfsm47637275e9.2.2026.04.28.07.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 07:56:34 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8317F5F7BC;
	Tue, 28 Apr 2026 15:56:33 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: qemu-devel@nongnu.org,  Andrew Jones <andrew.jones@linux.dev>,
  Alexandru Elisei <alexandru.elisei@arm.com>,  Eric Auger
 <eric.auger@redhat.com>,  "open list:ARM" <kvmarm@lists.linux.dev>,  "open
 list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] arm: add wfx test case
In-Reply-To: <20260428132657.GA591628@e124191.cambridge.arm.com> (Joey Gouly's
	message of "Tue, 28 Apr 2026 14:26:57 +0100")
References: <20260427130045.3669851-1-alex.bennee@linaro.org>
	<20260428132657.GA591628@e124191.cambridge.arm.com>
User-Agent: mu4e 1.14.1-pre3; emacs 30.1
Date: Tue, 28 Apr 2026 15:56:33 +0100
Message-ID: <87h5ovdtge.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Joey Gouly <joey.gouly@arm.com> writes:

> Hi,
>
> Few small comments.
>
> On Mon, Apr 27, 2026 at 02:00:45PM +0100, Alex Benn=C3=A9e wrote:
>> This is based on a similar test case I wrote for QEMU's tcg tests althou=
gh
>> obviously able to take advantage of kvm-unit-tests additional plumbing f=
or
>> dealing with the GIC and IRQs.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  arm/Makefile.arm64        |   1 +
>>  lib/arm64/asm/processor.h |   7 ++
>>  lib/arm64/asm/sysreg.h    |   3 +
>>  arm/wfx.c                 | 137 ++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg         |   5 ++
>>  5 files changed, 153 insertions(+)
>>  create mode 100644 arm/wfx.c
>>=20
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index a40c830d..52b3f35d 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -64,6 +64,7 @@ tests +=3D $(TEST_DIR)/cache.$(exe)
>>  tests +=3D $(TEST_DIR)/debug.$(exe)
>>  tests +=3D $(TEST_DIR)/fpu.$(exe)
>>  tests +=3D $(TEST_DIR)/mte.$(exe)
>> +tests +=3D $(TEST_DIR)/wfx.$(exe)
>>=20=20
>>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>>=20=20
>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>> index 32ddc1b3..2104036d 100644
>> --- a/lib/arm64/asm/processor.h
>> +++ b/lib/arm64/asm/processor.h
>> @@ -173,5 +173,12 @@ static inline bool system_supports_rndr(void)
>>  	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) !=3D =
0;
>>  }
>>=20=20
>> +static inline bool system_supports_wfxt(void)
>> +{
>> +	u64 id_aa64isar2_el1 =3D read_sysreg_s(ID_AA64ISAR2_EL1);
>> +
>> +	return ((id_aa64isar2_el1 >> ID_AA64ISAR2_EL1_WFxT_SHIFT) & 0xf) !=3D =
0;
>> +}
>> +
>>  #endif /* !__ASSEMBLER__ */
>>  #endif /* _ASMARM64_PROCESSOR_H_ */
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index f2d05018..cb96a649 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -77,6 +77,9 @@ asm(
>>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
>>  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
>>=20=20
>> +#define ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
>> +#define ID_AA64ISAR2_EL1_WFxT_SHIFT	0
>> +
>>  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
>>  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
>>=20=20
>> diff --git a/arm/wfx.c b/arm/wfx.c
>> new file mode 100644
>> index 00000000..912e50e6
>> --- /dev/null
>> +++ b/arm/wfx.c
>> @@ -0,0 +1,137 @@
>> +/*
>> + * WFX Instructions Test (WFI, WFE, WFIT, WFET)
>> + *
>> + * Copyright (c) 2026 Linaro Ltd
>> + *
>> + * SPDX-License-Identifier: GPL-2.0-or-later
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/processor.h>
>> +#include <asm/gic.h>
>> +#include <asm/timer.h>
>> +#include <asm/io.h>
>> +
>> +#define TIMEOUT 200000
>
> Instead of a hardcoded TIMEOUT, what about something similar to arm/timer=
.c:
>
> 	u64 time_10ms =3D read_sysreg(cntfrq_el0) / 100;

ok

>
>> +
>> +#define sev() asm volatile("sev" : : : "memory")
>> +#define sevl() asm volatile("sevl" : : : "memory")
>> +#define wfi() asm volatile("wfi" : : : "memory")
>> +#define wfe() asm volatile("wfe" : : : "memory")
>> +
>> +#define wfit(reg) \
>> +	asm volatile(".arch armv8.7-a\n\twfit %0" : : "r" (reg) : "memory")
>> +#define wfet(reg) \
>> +	asm volatile(".arch armv8.7-a\n\twfet %0" : : "r" (reg) : "memory")
>> +
>> +static void timer_handler(struct pt_regs *regs)
>> +{
>> +	/* Disable timer to stop IRQ from re-firing */
>> +	write_sysreg(0, cntv_ctl_el0);
>> +}
>> +
>> +static bool check_elapsed(uint64_t start, uint64_t threshold, const cha=
r *test, bool more)
>> +{
>> +	uint64_t end =3D read_sysreg(cntvct_el0);
>> +	uint64_t elapsed =3D end - start;
>> +	bool pass =3D more ? elapsed >=3D threshold : elapsed <=3D threshold;
>> +
>> +	report(pass, "%s (%ld ticks)", test, elapsed);
>> +
>> +	if (!pass) {
>> +		report_info("%s %s", test, more ? "woke too early" : "slept despite S=
EV");
>> +	}
>> +	return pass;
>> +}
>> +
>> +static void test_wfi(void)
>> +{
>> +	uint64_t start;
>> +
>> +	report_info("Testing WFI...");
>> +
>> +	start =3D read_sysreg(cntvct_el0);
>> +	write_sysreg(TIMEOUT, cntv_tval_el0);
>> +	write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
>> +	isb();
>> +
>> +	local_irq_enable();
>> +	wfi();
>> +	local_irq_disable();
>> +
>> +	check_elapsed(start, TIMEOUT, "WFI", true);
>> +}
>> +
>> +static void test_wfe(void)
>> +{
>> +	uint64_t start;
>> +
>
> I think a comment here would be good, just to say it's testing that a wfe
> doesn't sleep for a 'long' period with no pending events, or something li=
ke
> that?

ok

>
>> +	report_info("Testing WFE/SEV...");
>> +	sev();
>> +	start =3D read_sysreg(cntvct_el0);
>> +	wfe();
>> +	check_elapsed(start, TIMEOUT, "WFE/SEV", false);
>> +
>> +	report_info("Testing WFE/SEVL...");
>> +	sevl();
>> +	start =3D read_sysreg(cntvct_el0);
>> +	wfe();
>> +	check_elapsed(start, TIMEOUT, "WFE/SEVL", false);
>> +}
>> +
>> +static void test_wfit(void)
>> +{
>> +	uint64_t start, timeout;
>> +
>> +	report_info("Testing WFIT...");
>> +	start =3D read_sysreg(cntvct_el0);
>> +	timeout =3D start + TIMEOUT;
>> +	wfit(timeout);
>> +	check_elapsed(start, TIMEOUT, "WFIT", true);
>> +}
>> +
>> +static void test_wfet(void)
>> +{
>> +	uint64_t start, timeout;
>> +
>> +	report_info("Testing WFET...");
>> +	/* Ensure no pending events */
>> +	sev();
>
> Could this just be sevl here? Not that it really matters.

it could be - ideally I would extend the test case to work with -smp so
we can properly exercise that code path as well.

>
>> +	wfe();
>> +
>> +	start =3D read_sysreg(cntvct_el0);
>> +	timeout =3D start + TIMEOUT;
>> +	wfet(timeout);
>> +	check_elapsed(start, TIMEOUT, "WFET", true);
>> +}
>> +
>> +int main(void)
>> +{
>> +
>> +	if (gic_init() < 0) {
>> +		report_abort("GIC init failed");
>> +		return 1;
>> +	}
>> +
>> +	/* Install timer handler for WFI wake-up */
>> +	install_irq_handler(EL1H_IRQ, timer_handler);
>> +	gic_enable_defaults();
>> +
>> +	/* Enable Virtual Timer PPI */
>> +	gic_irq_set_clr_enable(27, true);
>
> Instead of hardcoding 27 here, you can use:
>
> 	u32 irq =3D current_level() =3D=3D CurrentEL_EL1 ? TIMER_VTIMER_IRQ : TI=
MER_HVTIMER_IRQ;=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> 	gic_irq_set_clr_enable(irq, true);
>
> Which also allows the test to run at EL2.

sounds good.

>
>> +
>> +	report_prefix_push("WFx");
>> +	test_wfi();
>> +	test_wfe();
>> +	report_prefix_pop();
>> +
>> +	if (system_supports_wfxt()) {
>> +		report_prefix_push("WFxT");
>> +		test_wfit();
>> +		test_wfet();
>> +	} else {
>> +		report_skip("WFxT instructions not supported");
>> +	}
>> +
>> +	return report_summary();
>> +}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 12fc4468..7adf96f2 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -339,3 +339,8 @@ groups =3D mte
>>  test_args =3D asymm
>>  qemu_params =3D -machine mte=3Don
>>  arch =3D arm64
>> +
>> +[wfx]
>> +file =3D wfx.flat
>> +groups =3D wfx
>> +arch =3D arm64
>
> Thanks,
> Joey

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

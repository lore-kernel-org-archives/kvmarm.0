Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F143C9453
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645284; cv=none; b=dRnFbzS4gBQ96Pda1UuZBbDefBb/QA90nICtbiU88nVBOBjpWODcH68v+Qhyi8gzz0oHJhLsz337IoInnkDCOnS0f7EONZq1YX89vpiR7z7WR4i+0VaR6NcSeHYvwx4cIy947Cca7FM63stsU2XAy0gavCu6B2/Z45ExnRFhyok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645284; c=relaxed/simple;
	bh=qAtodJ9TKmiZz4msSUj9WtzN6/ujAzAtgV0rPu56XbU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=m3uQ5/AZ2zvMNeae5VdWgEqdrahxqyIT6ztdqVsLab9F7L1Ghq6jPVAVC3uaVAvSV3K7cMKrM91xp28l0DDfD0FUYMa96EXkFtpK6rdTE8mp6q/zCbkZc4GvUAVHobJDDZvDBjNA1OX7crtxSvfyQHFjp2oVVatDQA/6lXniwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Aajq6OjV; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Aajq6OjV"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43d7badbd7dso959820f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 07:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1777645281; x=1778250081; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBnnGCpYSonyRl/RZZsL4XC/Tyffyj/BGojejPAjpWk=;
        b=Aajq6OjVCztJoBh70OQKO4f7GrKMK8UaAb8G25+6ugUuwDdFOe45m2lM5Wc1EIo08I
         NLLmK3BFyN8sfOUwmw/uj6lobo9l1aoNJgVtbMCXXf4ewUNV0sg91tybSmXqreXD9hhC
         2a9CJt0xsfBQdFJNgt2HQlTiUPNBnOyYxaVWXs7Oh/mKijRvQBEWstyKZdOWYkARoOUJ
         9AUWf0u/vmOYCIjSdh4CBAVnqmUVneC/CEqcQ7qs87DP9vWAbm4NHaR3Ne/eZOPvuD2N
         P5HtnKojAVHjhIkcUbL95zWN/wx9YmRKyjNrceZkToUmxJmdldWi+FU/Lnw/gurUbae8
         0X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777645281; x=1778250081;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBnnGCpYSonyRl/RZZsL4XC/Tyffyj/BGojejPAjpWk=;
        b=atGPGqQayIfpQERrRf2npjP15iOUpXhCPR1VMnj1CG5pRjt4ZcMiYISXzYaVN+OGxC
         qm+5+yYs6RiRjutriZnzcDXTIaEwzXzbNaQhpA1mTPqSQJcgbaKQ0VhkbvHi0w43jpDo
         HoIHsZai5ESL+F2TZLVmd+QZ6VjI3HqCfDIGRft3rX6Cyj4qyGB1Kv6235QJI++OyrHA
         diFqOUGLbIGPVqAnsDqx5cd38tBwzqDB+kG9IFoYnSYK768jcZFkH5hPDVrnvc1vClRU
         Yvz6mrEchO0WbDZv3IAcK+PSthiw3bWFWbbphzNsqZdi5fr9sR/bn6iYweAURL0ItV2q
         enAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+liFvPwoOerYo+6UOK0gg8AFoemS3x4/Hotqclu24ULBiVNkGCQrG8B4SX5O5deIDKDILPNEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhUJCsdByuep4dovcIkN9eoCwctERVHOdOEDHqzjJRweX+HIH6
	xsTXP37+k+NFg9E7vDfhkfIOWzQdLKvhBdXOM3XOlInqTEj/kaNA7eRxIkytUC3zbKo=
X-Gm-Gg: AeBDietxlrdJcK6G/6lM2eHfhoOyvG3PR7ju7nWrkgOMvkm+J60i04Ek5fmtozaNi5Y
	8DFTq2N2S1ddjyH2qnYMLXX8sasZ4sFUreBVUZZJhKJAgwReAwKsuelcAkB3hRpDYYoKkSIRzJl
	Hpv80IjNcxDaijDQF7b79Tj3BW0jPJ8juI5arWqUhUyW69M65KHxIQdun/tAOFZC84gPOF3ZwGT
	u8FFbZXPz2W06tAse7VDppdVL4ZJWdsq4F+NjCEK3L2mQRZpfuip0zGbZTmPlHLQrLIoWYhXUc/
	laJ8GiAPn2qgDWsRIa6D07clvjA/lVddt28JPg0ptdxYYGrsqxSBHETNxB2ddRhqav4nYp2JzyN
	ZbMH83UzhN7efsicwkVnEhWwoQIKgtYTKWaplVicTAYFvfVZY/gKRgX8hbsT0gf257EFZLbl/qK
	Jh8lmTiCljg0vRYz7NZTkPLE8Dng09AG2rCQ==
X-Received: by 2002:a5d:5d83:0:b0:43f:e413:f6fd with SMTP id ffacd0b85a97d-44a83318609mr5106522f8f.0.1777645281205;
        Fri, 01 May 2026 07:21:21 -0700 (PDT)
Received: from draig.lan ([185.124.0.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a986aa3a5sm5802041f8f.26.2026.05.01.07.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 07:21:20 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8A2A75F8FC;
	Fri, 01 May 2026 15:21:19 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: qemu-devel@nongnu.org,  Andrew Jones <andrew.jones@linux.dev>,  Eric
 Auger <eric.auger@redhat.com>,  "open list:ARM" <kvmarm@lists.linux.dev>,
  "open list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] arm: add wfx test case
In-Reply-To: <afSnVJLe7HrB6ISS@raptor> (Alexandru Elisei's message of "Fri, 1
	May 2026 14:15:14 +0100")
References: <20260427130045.3669851-1-alex.bennee@linaro.org>
	<afSnVJLe7HrB6ISS@raptor>
User-Agent: mu4e 1.14.1-pre3; emacs 30.1
Date: Fri, 01 May 2026 15:21:19 +0100
Message-ID: <87zf2jcisg.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Hi Alex,
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
>
> It is customary for the interrupt handler to ack the interrupt at the GIC=
 level.
>
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
>
> Consider this scenario:
>
> 	local_irq_enable();
> 	// CPU takes the interrupt, handles it and returns.
> 	wfi(); <- CPU now waits forever for an interrupt that will never come
>
> The proper way to do it on baremetal would be:
>
> 	local_irq_disable();
> 	// Program timer to fire
> 	wfi();
> 	// Timer fires, GIC asserts the interrupt, WFI completes
> 	local_irq_enable();
> 	// CPU handles the interrupt
> 	check_elapsed(..)
>
> But this is not baremetal. KVM can decide not to trap WFI (look at
> arch/arm64/kvm/arm.c::kvm_arch_vcpu_load() -> kvm_vpcu_should_clear_twi()=
). In
> that case, the WFI might complete due a host interrupt, and check_elapsed=
() will
> fail because the timer hasn't yet fired.
>
>> +	local_irq_disable();
>> +
>> +	check_elapsed(start, TIMEOUT, "WFI", true);
>> +}
>> +
>> +static void test_wfe(void)
>> +{
>> +	uint64_t start;
>> +
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
>
> I haven't thought about this too much, but it looks to me like the same
> situation with WFI can happen with WFE
>
> Also, kvm-unit-tests() makes use of WFE and SEV for multithreading, and t=
he fact
> that multithreaded tests work at all might be taken as proof enough that =
the two
> instructions are correctly implemented.

So I'm using kvm-unit-test to exercise QEMU's TCG modelling of the
instructions, see:

  Message-ID: <20260430104434.1482407-1-alex.bennee@linaro.org>
  Date: Thu, 30 Apr 2026 11:44:27 +0100
  Subject: [PATCH v4 0/7] target/arm: fully model WFxT instructions for A-p=
rofile

So while I'm confident the current modelling doesn't cause issues
(because we basically treat it as a NOP) I wanted to check the various
modes behave as they should with the above patches.

I can limit the test to TCG only if it is likely to fail under KVM.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

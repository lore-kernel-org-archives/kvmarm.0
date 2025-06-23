Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596C2D0267
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703143; cv=none; b=mzQf7ebm5yV8//h7YxQKboCS8NqR6/ccLpDug0rlkXw/jwqY3cDD8Ss9IjBpP13+1Y52eQt94RkuAHulfznkIMbW4gBhp1fMx2coS25P2rZQY2/LKJRhGp5vygocInNzdxdE2aDIb5KyGCdUlivV69Goa1ttFGUM0Cmiot2Wp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703143; c=relaxed/simple;
	bh=2JKqhfr5wu8jd5BKk3NpO7rpJrVsAeJ0qnUtDbuCOi4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UJCBIms2642vyG8btnmF2gV/6XqgUjP9LFn+q6SV75ta/3sfQh0YMzaazB/5IYxNBNZiMvHz+vhGVVQIj/rkhzfo66n7vjWIJuibnszjX8Q+Lt+KfW0u0+GiDVZVaqD7DxeWAErQr5nF261ZCrJreo8s7L8DOaJ/bv30wFP2pyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CVMFjQpa; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CVMFjQpa"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc9ee4794so66680125ab.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 11:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750703139; x=1751307939; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x/yRTajGyCYDVao/uBe3yoYTQK0CCPZeD6lCEoWPGDQ=;
        b=CVMFjQparaByblgAS68FtMuB+lIFnjH7NUxDgOeXvMZJvbSIUZIR+6WF6L4DNBdsoI
         E996yhD7z1Ob79S9aEp/IRAu5KGww53u6AFtFT0pW6hNTMBQ/GQzZ1gY1iNI7ls0Za1j
         fC6f8gdG9bJCAtWR8g1mMbGubI7EiR5IK6Dy+b+T4oiCGtLcAJCVQ/U58U+dsD+AsnQc
         vAt6Ulk0q9wvV6Dil9SSfOTCStFJBAti78w01KOaFFBZsA6ypR1d/YF//1ORQKzuysU3
         fjKANVGY+19+CoqFyr86ucRCt3oxQBusu1KIMYrDIXtPkq0HZQ22BdUaEKFcLAfwUAeK
         NfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750703139; x=1751307939;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/yRTajGyCYDVao/uBe3yoYTQK0CCPZeD6lCEoWPGDQ=;
        b=iF/9hdGBSuOUjDKABOrNQAvuLhNBeXzMyQ8+JR7AwdWxUW+R7FFDuLFc+EqEHyLI93
         gInVvZDxbpXplqo1sFIZmnDwOnIwfNChB577zPVu9XSy+P942vdXuZqR+pFWcXHm0SM8
         13F6+jQ9cW2LBlbHlLp6zBWPIEIBRphY+feKAsmvTh1xOhZN1cRQvIT4vdkpq4Z0Yw02
         eWBS21WIwTzTf/b5im1pkTmfBYt53Ad/Q209jzoALuS6l7//mRb/3O+qmDyxan3Dh+r1
         3J6JnLdzr9kRjpt27iM6Rp6T6rHCk8DQD/gt3nJrZycMY3yfSRDuTaF6otKwQcSTR+S0
         wO3g==
X-Forwarded-Encrypted: i=1; AJvYcCWab3CWgjP+Xq3jjFFVsGCjIjLb2qgFxj7901KdeQwPrDYIcgObh3CVNalIoru6hLPXjpYr/0s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFP80m0QEtr7II8QP+9at0Ua7b3oIzcez4hT+X69BRluymvDjR
	MbnoR8LumKYoiVnT0KT5X6iDg14ubFpoGYJ2ARt+KPL5ju+vPw6cVz+zXuwX35obP6rLhhGOroy
	dbI/Vg89E/mKVeCEPeXL6GQKSHQ==
X-Google-Smtp-Source: AGHT+IGB4/D8wn12ZeTFWeXtrV3NuVvtA1SOelvWAjyyu6UmZAX76nv7r6P9O4AsImXh2Otv+muKbiEPiY/O85sZZA==
X-Received: from ilbbr10.prod.google.com ([2002:a05:6e02:23ca:b0:3dd:7629:ec3a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:170d:b0:3dd:e7d6:18bb with SMTP id e9e14a558f8ab-3de38cbfd28mr144801735ab.17.1750703139323;
 Mon, 23 Jun 2025 11:25:39 -0700 (PDT)
Date: Mon, 23 Jun 2025 18:25:38 +0000
In-Reply-To: <aFYAXjzICzgmSyLI@linux.dev> (message from Oliver Upton on Fri,
 20 Jun 2025 17:44:14 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntqzza9uxp.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 01/23] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Jun 20, 2025 at 10:13:01PM +0000, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/kernel/cpufeature.c | 8 ++++++++
>>   arch/arm64/tools/cpucaps       | 1 +
>>   arch/arm64/tools/sysreg        | 6 +++---
>>   3 files changed, 12 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/kernel/cpufeature.c  
>> b/arch/arm64/kernel/cpufeature.c
>> index b34044e20128..278294fdc97d 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -548,6 +548,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
>>   };

>>   static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
>>   	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>> @@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities  
>> arm64_features[] = {
>>   		.matches = has_cpuid_feature,
>>   		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>>   	},
>> +	{
>> +		.desc = "Allow MDCR_EL2.HPMN = 0",

> This feedback still stands...

> 		.desc = "HPMN0",

> [*] https://lore.kernel.org/kvm/aD4ijUaSGm9b2g5H@linux.dev/

Sorry for ignoring your previous feedback. I looked at the other .desc
fields and they had more descriptive English, so I think this one should
be more than "FEAT_HPMN0" for consistency.

If you insist I'll change it.

>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_HPMN0,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>> +	},
>>   #ifdef CONFIG_ARM64_SME
>>   	{
>>   		.desc = "Scalable Matrix Extension",

Here's one example.

>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>> index 10effd4cff6b..5b196ba21629 100644
>> --- a/arch/arm64/tools/cpucaps
>> +++ b/arch/arm64/tools/cpucaps
>> @@ -39,6 +39,7 @@ HAS_GIC_CPUIF_SYSREGS
>>   HAS_GIC_PRIO_MASKING
>>   HAS_GIC_PRIO_RELAXED_SYNC
>>   HAS_HCR_NV1
>> +HAS_HPMN0
>>   HAS_HCX
>>   HAS_LDAPR
>>   HAS_LPA2
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 8a8cf6874298..d29742481754 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -1531,9 +1531,9 @@ EndEnum
>>   EndSysreg

>>   Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
>> -Enum	63:60	HPMN0
>> -	0b0000	UNPREDICTABLE
>> -	0b0001	DEF
>> +UnsignedEnum	63:60	HPMN0
>> +	0b0000	NI
>> +	0b0001	IMP
>>   EndEnum
>>   UnsignedEnum	59:56	ExtTrcBuff
>>   	0b0000	NI
>> --
>> 2.50.0.714.g196bf9f422-goog


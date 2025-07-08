Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22DE21B9F1
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752014079; cv=none; b=ZjV8bnL5SNeHT/rjyHUTyi9FWRKyAeIJeCw3t/7TPYezumAz9m1Gc72oYbjp3wUuGzDUjX3lmoBf2kA2OZKEBBUsQWGTt6q+x+KfmADUaZCuGWpMQ/6Rv1bs8metNP8IUA94f2+03DuBgHSKk89AhhlSwLm3qXGppIQoMqZlNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752014079; c=relaxed/simple;
	bh=02xDzJQPlhBq0RU8lcHj/2RG+qyIWz4nKYd1naozQns=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ALyB0HzeF6RqEXlHFd49dpOPi07donrGdC5XAuDEDEZ4xRz/vJKCkJxqXrNRI7lLJ6jrA2CeyoP/+VtMPkc42QhZKN//yKrm6Bd7x9omLz8urn4SmnXUghFjb496Al0+h7+9FEvY7xqpYWOFxF3eux8sVZY+gfTf4Af3iCha8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ivf/KMDf; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ivf/KMDf"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddd90ca184so36942195ab.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Jul 2025 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752014077; x=1752618877; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/9FFTs3Hz/7yNjDy98C2EAojjbwb0TEz5q962JZJd0=;
        b=Ivf/KMDf+lRGRwRCzJ6B5BhGmJ4xnjg4FmrvDetA6StOXhOS7E/5xlmROhm5Hb+fHY
         55FfTPr+gtv0nZNoFU/NPRwRMiAJooblQCFpwLH5CSXcicqGIFT3MvKWZ4N7lY/Yg9x0
         TZXE6YsdN7o+GgmRxjRg+Vp1XCDUmmQn+ZOToegX5BAvfnlSR/BYcgfAfakPmfQaNUyN
         Y1RyQmmAflwv5veEbYrkxgfPGU6iaAf0Xf4LsnF8CNeU4Oo+8jb3kdRzD3V5ZNcp2iuX
         vM9Md0hbZY68QTaOxxZud0j8aXUSgKglYZ8sXu81S0iqZX9TJZxLKA/1AYCQ4/f10qEK
         2iwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752014077; x=1752618877;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/9FFTs3Hz/7yNjDy98C2EAojjbwb0TEz5q962JZJd0=;
        b=e/x+Dn5c6119TQC7v5pLTYmCDq6jYXxn0kfxmCn8mx2xlyTLHZpGNavEcyMMYrJh66
         nhIH0ESplJxGmoCsu1skzLkgKRaF0vT2uxt3GPQ0oMSAZncW+AyT2p2SvSnssjrhk0i4
         3D1sAIhx+1Zd2UK4GK1NlbPpXPSise8X/KUbY3T+Watb5w3QMiTIf/RRk1Zb5d/JjJ44
         CkSS34g1c1kK1hExKXZB2I/yV9ChK/aoQubEGMeDfE0uHbLn/ag86EBPG7aY/w8txBxc
         BtwR+AvFmpxVO+50mos8HowAJL9vSfm8YjC3troan0BJOQNiMncBFVJbPq85f9fOIcVY
         jixg==
X-Forwarded-Encrypted: i=1; AJvYcCVMmxukrUpAdjleQNh6jWdbxja5iqq3UNjdo01LzxuPSEBgxGVR69Fd7i4qPoqdHGGH2DmIN18=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjKu9U6bFlPYnTrXDDq+gYQu/afpIa4nhVzJpzo80zchCTCkGz
	2ec5omnj8rGR7Q4E/luk26iMNB1CluCz3wAi1bXLVQI6Dqq8nEYocRbrFFLcCNFuHXq4oy2JJXs
	2UU5g8b+Xds4pXKkUkkr0odN8kg==
X-Google-Smtp-Source: AGHT+IHW+RfduRT7VliGk050iQEqjU318xPGArkYZW5dZzAyyRBuwQAaT6oV8zuk0wkHYQ4WnuckwA/hmtfDS9hyaw==
X-Received: from ilfg10.prod.google.com ([2002:a05:6e02:198a:b0:3df:30df:d2c4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:339f:b0:3e0:4564:4ef9 with SMTP id e9e14a558f8ab-3e166ffbeb5mr5390855ab.4.1752014077049;
 Tue, 08 Jul 2025 15:34:37 -0700 (PDT)
Date: Tue, 08 Jul 2025 22:34:35 +0000
In-Reply-To: <aGvwLIAN8rhxtA_V@J2N7QTR9R3> (message from Mark Rutland on Mon,
 7 Jul 2025 17:05:00 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt34b61fd0.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 01/22] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Mark Rutland <mark.rutland@arm.com> writes:

> On Thu, Jun 26, 2025 at 08:04:37PM +0000, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

> I agree it's appropriate to mark ID_AA64DFR0_EL1.HPMN0 as an
> UnsignedEnum. It follows the usual ID scheme per ARM DDI 0487 L.a
> section D24.1.3, and zero means not present, so it must be unsigned.

> Likewise, the value renames (UNPREDICTABLE => NI and DEF => IMP) look
> fine to me.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> I have one minor nit below, but either way:

> Acked-by: Mark Rutland <mark.rutland@arm.com>

Thank you Mark

>> ---
>>   arch/arm64/kernel/cpufeature.c | 8 ++++++++
>>   arch/arm64/tools/cpucaps       | 1 +
>>   arch/arm64/tools/sysreg        | 6 +++---
>>   3 files changed, 12 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/kernel/cpufeature.c  
>> b/arch/arm64/kernel/cpufeature.c
>> index b34044e20128..73a7dac4b6f6 100644
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
>> +		.desc = "FEAT_HPMN0",

> Minor nit, but we can drop the "FEAT_" prefix here, for consistency with
> other features (e.g. E0PD, FPMR).

> Mark.

Will do.

>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_HPMN0,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>> +	},
>>   #ifdef CONFIG_ARM64_SME
>>   	{
>>   		.desc = "Scalable Matrix Extension",
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
>> 2.50.0.727.gbf7dc18ff4-goog


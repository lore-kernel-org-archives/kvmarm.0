Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834A72E0B45
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753120838; cv=none; b=PSDvgv3k+YPqlrkbX6gvSqMcK9ouSO7vsGyQqjwHQTK1fEHkpI4RSRPD0cgL6CLgnI78n0T+bCRsp5hfDRQHM4R0wrO1ArDRPHYUytC4WtryVRwPkLXVf6haLJy58V70FhqdZei9tQRYp2t3IT5Gm/4TTu38NNgV1j2NDQynwqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753120838; c=relaxed/simple;
	bh=ogWkNfeO1YSnAXmvtt1kCOSLkwjDSK4GK17SpTnnPdE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=jUXlsW/lqcAOaKr2vXsRzjLQ6SBDrETANLGVxLsSaP1uRhPAa2RXlLW9m5w1hSgSq3D2GHf8YDcZqtztRSjH9lENCFqtJCbz6NHWm8u1fPn2D+iNTFTQ8VWR6zYjva2mrVw5iSfxe5c3RjXNkpy5V85k+C9ynYdrxeFY7xgr9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A0v8jvou; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0v8jvou"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86f4e2434b6so533186439f.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 11:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753120835; x=1753725635; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2krLqXbrvL69zHTI+OSB0Sx07egWNgje2ekoJXV//wU=;
        b=A0v8jvouTvjNcNZBKoRkgyeGgA9GBUu0QEWIE0ISary74TxNHatGS0EfnNMlnKEejC
         ksTfK4kVl6vzgwClfHYOrSyq5IAelj+CdH+iMtKhfEtcHaYmZLeJPKqzAgQU820lI4vW
         Z+BkMIBu2crXy0KqZyWr/cUnXDpsZdXNxfsiGllL56aAH7Mg5hpiikfOg7INtN+8NAdq
         NSLkY5sjUksqOMGo9byj9WWmsienF41xMFbYIbDAxtGf/KrknHpw1DCDBCFv5Qx+l3rN
         an+rklGkEcoFopAKW5FxhLnpMhPcmnSLW8vUcAqeIgQCih+GScZrhMyTrgWkqLfKkclA
         +pug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753120835; x=1753725635;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2krLqXbrvL69zHTI+OSB0Sx07egWNgje2ekoJXV//wU=;
        b=qp1OskaXNM/DWHAB8T8PK5LmI9aJfEnftWccvwmmMljbHhjOdQn7yuyEtlUH03Kvkj
         nRBp0ew/91Iu1hv/994v/IP8jG6dbefCpztYSRglZlsHM09sx7CYyctZh+QhXdXUgfp4
         fI/du95qQ8FLpzYKA3OW9bGYltlFEGeNvuLsPqiey0ZdKzSf908/X2FGgjvGp9g8tt9+
         L4wHqwhcEW7wG8T/tkJ5olAqi5P6K8HjaYqKPKQnbE3xeWW33ld7d2LtG69p6Ggz1mi4
         MW70YozbysdtzB8X9aSOKFg5ZLjK2y7ZJVCd+Lnq7I7HUqtpQlWEru8AFYivxdLWgSnr
         4OIw==
X-Forwarded-Encrypted: i=1; AJvYcCUjD5/3rF363GefOpr2nE7DskoKnrmptVLlnhwHkj0vl4FVhDG+sZR69z/riA+BiOWRIwtSggA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGR9MquwiQe3TYakhRWjJuPAo/QVGq4/eMkgbus8qYm5G8m02U
	tS/S05BrjGK9BDqSFZ1Ag+6YzOKlXtc6AEErBOrbT7eKNphSuVGhs9+5XeLBP/gtJB2WFYDqwLP
	S00qsgSgkc03BRUmiMBI/tC/xXg==
X-Google-Smtp-Source: AGHT+IEfZ2MrsGDQt2Apr+GHWZROOgLVqxxVZM8uTrkAEn6W6ybAfMfVvl1rXs9CqPRl3bXlJpF5OsombirkZgJ7Gg==
X-Received: from iobjk13.prod.google.com ([2002:a05:6602:720d:b0:87c:1d70:43be])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:2c0f:b0:86c:ee8b:c089 with SMTP id ca18e2360f4ac-879c291915bmr2390181339f.3.1753120835597;
 Mon, 21 Jul 2025 11:00:35 -0700 (PDT)
Date: Mon, 21 Jul 2025 18:00:34 +0000
In-Reply-To: <153b5191-c585-433e-9cf5-1ed19b9a7f5c@arm.com> (message from
 Suzuki K Poulose on Wed, 16 Jul 2025 00:22:16 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntseipa0fx.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 01/23] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Suzuki. Thanks for the review.

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 14/07/2025 23:58, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm64/kernel/cpufeature.c | 8 ++++++++
>>    arch/arm64/tools/cpucaps       | 1 +
>>    arch/arm64/tools/sysreg        | 6 +++---
>>    3 files changed, 12 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/kernel/cpufeature.c  
>> b/arch/arm64/kernel/cpufeature.c
>> index b34044e20128..f38d7b5294ec 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -548,6 +548,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
>>    };

>>    static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),

> This doesn't have to be FTR_STRICT. The kernel can deal with
> differences, by skipping to use HPMN0. We anyway rely on the
> system wide cap for using the feature.

Okay. I'll change it


> Otherwise,

> Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>



Thanks
>>    	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
>>    	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
>>    	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,  
>> ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>> @@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities  
>> arm64_features[] = {
>>    		.matches = has_cpuid_feature,
>>    		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>>    	},
>> +	{
>> +		.desc = "HPMN0",
>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_HPMN0,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>> +	},
>>    #ifdef CONFIG_ARM64_SME
>>    	{
>>    		.desc = "Scalable Matrix Extension",
>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>> index 10effd4cff6b..5b196ba21629 100644
>> --- a/arch/arm64/tools/cpucaps
>> +++ b/arch/arm64/tools/cpucaps
>> @@ -39,6 +39,7 @@ HAS_GIC_CPUIF_SYSREGS
>>    HAS_GIC_PRIO_MASKING
>>    HAS_GIC_PRIO_RELAXED_SYNC
>>    HAS_HCR_NV1
>> +HAS_HPMN0
>>    HAS_HCX
>>    HAS_LDAPR
>>    HAS_LPA2
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 8a8cf6874298..d29742481754 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -1531,9 +1531,9 @@ EndEnum
>>    EndSysreg

>>    Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
>> -Enum	63:60	HPMN0
>> -	0b0000	UNPREDICTABLE
>> -	0b0001	DEF
>> +UnsignedEnum	63:60	HPMN0
>> +	0b0000	NI
>> +	0b0001	IMP
>>    EndEnum
>>    UnsignedEnum	59:56	ExtTrcBuff
>>    	0b0000	NI

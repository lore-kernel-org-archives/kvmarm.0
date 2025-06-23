Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BEC278767
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703121; cv=none; b=fB8Rkea5z2YYH7xgMXY9/NEHR18KIRukYZe16rhSZNHf1iPOc04O+/Uv1TalrgHvGp31lfObrIoEg69wt2TV/iVf9l5KZzmJ0FDriFwPJp5pn+rfiLI4uPanc8zqTMXClteU6LthfeT6ZkmldM0t5N1ofnb9pTbnw5JEB49lkK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703121; c=relaxed/simple;
	bh=Ig5ipTdJADEoDAWoOphXIpyhS5e+nFJQDKH78u7uCTg=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Q9ycPmocmqhD0GbynegK1nXbnLMKeUjSLnPF74SddZX6r3HSSH7pod9K6szwzUmjLm+USqMnbcLnHmRuNyFY8a9aZchKl/xJYqzGGglsEabqujrqwpGdNNFU532uTM3lqCZt8un3egUU0BIg+9b3k/f/Z2GDQM78ahF7K2B2p+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgPBzb4n; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgPBzb4n"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddafe52d04so142285795ab.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750703118; x=1751307918; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fkKX/+jmAY5EI28pxMDSbALm6PmjD/WT98j0aaxzD8Y=;
        b=WgPBzb4nqbriUqFje9xBGrrlUTwpPHCPigTcUQMIkaDqjP4tP087Akk/0dCUgM4KRY
         ivmxD/1cE1775JOO/4okZKn5s75CUFyfyQQSSIroVvO824s9tJRXC14y6YjVHaEVlDr5
         w4khvrFjBD7RrCMr90nzZBBEuPrAMW/KVQWELKYhJqJh48g+ZU2Im0oCQDP2J9g/Nfbh
         67XB109MeODy6CeBNBEuk8hm6YWNEU1XTRgtnm8gCvLRWFRgMz1mDHOJ6TC/QlPrydC1
         YAaugzCuDle5oV2utn9snq+dTilffdLOMtcq1Qk9y/YaRHxeNR+qy4rLMmQM3Apf/HXp
         QGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750703118; x=1751307918;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkKX/+jmAY5EI28pxMDSbALm6PmjD/WT98j0aaxzD8Y=;
        b=PpmO0MG8HvJH6H4kvntIC7ISLzyfX9herJTINOxu+xKNP/eluCZX/4qFPrE7e1rN+k
         K/1XlGCaUdpxeXVvtDdh+PEHb04ttzmF8oiE/+NY7DpPphYiakooogQMg5tavgQRvM7f
         FeYzh+ND9oRZCq64b2h8O4sRWa1HmoVOOovvhcz+lMOXczzvFiVTL65Yby20mMBZxEgc
         rJRV7JeCHzRvwB1RTfmwLCT+inNTDvWhSDwkBk6U8cDEV23EyS6kDTBBqN4NOEsdFcay
         BzFNkHZiJObSoTYPg9nD6Sla7WGCGmPbIiY27IVX5/JoTRhvjx56d6pfx71OM0icSMDE
         eKBw==
X-Forwarded-Encrypted: i=1; AJvYcCU2Ptisw3qzMB3O4WBP9NCGLfomcRwkIu/cESOWybTV/Me7UNdI3wPnFUyRJGi60THp1CK4BZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvBPOw6wfZPe0P3j31/lZ4Kg1qnzz1BdcaT7rKsIQEX3jSXgHk
	oD74hlo29YC7lakAds9CU57yN58KLkTdqxlqqzuO39E7Q98rt5HyqQlJrYMFvdeB17MqhN+8Tnb
	YBiDLp2BZ6lDyePEdUzxCf4xSqw==
X-Google-Smtp-Source: AGHT+IGzBE7m3jRf0szvIWMcwTlET+uxa4mEBdZ8JNu6pA3Bo/Yc8zZA87zzxM+0+5qc5CYD+m3kIHDI/60f4MKLBA==
X-Received: from jay12.prod.google.com ([2002:a05:6638:c2dc:b0:4f0:9e8b:e246])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1806:b0:3de:1200:219f with SMTP id e9e14a558f8ab-3de38cda633mr149171615ab.22.1750703118062;
 Mon, 23 Jun 2025 11:25:18 -0700 (PDT)
Date: Mon, 23 Jun 2025 18:25:16 +0000
In-Reply-To: <aFYAq7GcSx4pTK9Y@linux.dev> (message from Oliver Upton on Fri,
 20 Jun 2025 17:45:31 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntsejq9uyb.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 03/23] arm64: cpufeature: Add cpucap for PMICNTR
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

Hi Oliver. Thanks for review.

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Jun 20, 2025 at 10:13:03PM +0000, Colton Lewis wrote:
>> Add a cpucap for FEAT_PMUv3_PMICNTR, meaning there is a dedicated
>> instruction counter as well as the cycle counter.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> I don't see this capability being used in this series.

> Thanks,
> Oliver

You are correct it isn't now. I'll take it out.

>> ---
>>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>>   arch/arm64/tools/cpucaps       | 1 +
>>   2 files changed, 8 insertions(+)

>> diff --git a/arch/arm64/kernel/cpufeature.c  
>> b/arch/arm64/kernel/cpufeature.c
>> index 278294fdc97d..85dea9714928 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2904,6 +2904,13 @@ static const struct arm64_cpu_capabilities  
>> arm64_features[] = {
>>   		.matches = has_cpuid_feature,
>>   		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
>>   	},
>> +	{
>> +		.desc = "PMU Dedicated Instruction Counter",
>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_PMICNTR,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64DFR1_EL1, PMICNTR, IMP)
>> +	},
>>   #ifdef CONFIG_ARM64_SME
>>   	{
>>   		.desc = "Scalable Matrix Extension",
>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>> index 5b196ba21629..6dd72fcdd612 100644
>> --- a/arch/arm64/tools/cpucaps
>> +++ b/arch/arm64/tools/cpucaps
>> @@ -47,6 +47,7 @@ HAS_LSE_ATOMICS
>>   HAS_MOPS
>>   HAS_NESTED_VIRT
>>   HAS_PAN
>> +HAS_PMICNTR
>>   HAS_PMUV3
>>   HAS_S1PIE
>>   HAS_S1POE
>> --
>> 2.50.0.714.g196bf9f422-goog


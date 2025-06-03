Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FEE223DD4
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 20:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748983832; cv=none; b=CUEtMl88r4oyWL8u3/Zt577S+fI/Q37g8DcOlNL7Y384/3kKBTTSxQnnAK5yCe+q+fHMPYxcmJWPJoQszfJpBVMd5jUM1pYRUgAXv4iZmYe5oqc3LNggnRYp8l6TGfDGZ2L4Ar7LDdV4zmBroY0tkuEKuHDB5kBthViLsnJL6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748983832; c=relaxed/simple;
	bh=1ORI/LqUz7dCfdMO8958T7FDJ2un7M0ICUmDzX9c648=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=eAlf6treq9nahgWB8lIgx7C5O0pQQNQlUZBsYzVQF6+vsNUvYDbVfLFlQ1V892cd7TNz3S4OwLnhkfqd7zMppS4/U4Kwv4QfJSxEQ6nk/urqhkTDN45reAIJ3MFP/iCMlToqfcJ2kTfPxVabPLM/WU/BraxfA3M9sQ+BuRn5paA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1YwCmJak; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1YwCmJak"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86cfe68a8bbso387678739f.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748983829; x=1749588629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3lsZMwRkh1UP98Tqde8+akeySm6v1iX6h0YAqQdmB3c=;
        b=1YwCmJak+pjSM2xZ50tkEomwzL5YLUkC4W0CZH7zpjeaJLmlzQDIEAqfKG6ygcdtoN
         DOuzfEa3gKQfBU8qKejrVVi2LGisn6eMsAH0nL7sg3yBMIMj+xfCyEUEY+nsV5V/bVWs
         7eXaIPgcskAlSUU0or0e0rvC4ToRWvvs3wVvul2QB3RXCbjJu0L6DP5h+QrmhfaATOCV
         Y+Wk3d13csyjbxCiE1KaZgFQYpYsBojOKg24nurH9VT3mNbDXHiiOH+IV0OhHAOq28yR
         Ir/If0Btz3YDvLyiw4yP4brUQsCS1ug2CK09qXHxD1LebC277KAYzoW+IVbFshnPWtjd
         LxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748983829; x=1749588629;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3lsZMwRkh1UP98Tqde8+akeySm6v1iX6h0YAqQdmB3c=;
        b=PJ/YntkQWgxvAc2tZMl78sN0dRK4yKDPGjhTg1GpsXALrc+n8GcDkIQ8oXPEhYogIZ
         7wJ+bI+jzzkXQXNoR1KH+lH3o4XqVGfIHuYaAar9YLO1HZoUa8j3N6Fzk46bL2ns6cic
         0HDswZ39SNq37w9dwPGWjjj8hfrLyZEf5qO6qepT4xWO+gjueenZrYDMV4Q4RYlqrdxm
         LZEm7O5LvnTU2rJCzWMdWeCeuCxNPX8capYE82LGk7uw4qpFsR5mn8WLc5hMeIhNM6CD
         VeYhPfHqmS+6oMqFuM8Ar1yMDGzGWtZv8/5azCfOv6ozcb3lDSFV5XoCR3v18ZhW6Ufm
         3CgA==
X-Forwarded-Encrypted: i=1; AJvYcCWS/A+E0UVom+HloQnMJBorvpLspDiR+ffhvQPFNXilOsdwFIA1HdtBGXF57fjZqlXMdXkZBqs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWStSbX+3tT31Q5uq/wou5WSNQArxv5GmjMvpE4RcKM0W75tdW
	WzLSapFFpulzBtNEhMeH1ehyos8e1gvnFRLrU+aC+fFeztxqdScRykI9sHpOL7Ym7PCB6YLMiB4
	8fihYCKyNbotz1JSJRFGSZGVW4g==
X-Google-Smtp-Source: AGHT+IE8lcweOrXzv1dJ7JnXQujzAi86ZbFeivqiLkC8HSJs78PXh7Mwa8lRBkCmnRTpW9aZv5V6w/tu2G1Ilng5MA==
X-Received: from ilbbf2.prod.google.com ([2002:a05:6e02:3082:b0:3dd:a279:72c1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1807:b0:3dc:8b29:30bc with SMTP id e9e14a558f8ab-3ddbedbef4cmr5429525ab.21.1748983829547;
 Tue, 03 Jun 2025 13:50:29 -0700 (PDT)
Date: Tue, 03 Jun 2025 20:50:28 +0000
In-Reply-To: <aD4ijUaSGm9b2g5H@linux.dev> (message from Oliver Upton on Mon, 2
 Jun 2025 15:15:41 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt7c1s35yj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 01/17] arm64: cpufeature: Add cpucap for HPMN0
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

Hi Oliver. Thanks for the speedy response.

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Mon, Jun 02, 2025 at 07:26:46PM +0000, Colton Lewis wrote:
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
>> index a3da020f1d1c..578eea321a60 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -541,6 +541,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
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
>> @@ -2884,6 +2885,13 @@ static const struct arm64_cpu_capabilities  
>> arm64_features[] = {
>>   		.matches = has_cpuid_feature,
>>   		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
>>   	},
>> +	{
>> +		.desc = "Hypervisor PMU Partitioning 0 Guest Counters",

> nit: just use the the FEAT_xxx name for the description (i.e. "HPMN0").

Okay

Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF425C80F
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 22:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752014293; cv=none; b=EzzN1p45QEdLx8GL4itMBJC3sFqeNDaNlQGDM0kLvOMtOJ5FRXsmOnOjzac5f7vOvsfG6oPSIIlExqZMbAYGjkQ4LEqLahElWPO72QlSJmxgHGXkYmrTbcYrfvBXIbIFGJYsayMSQWE1EM9Kef9dWISScJnyKfM0sGHWbdtH6W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752014293; c=relaxed/simple;
	bh=fPrGUiRoPzaB7mbeVkRZV0xHB6hD4FQCBeg/4YZtRxU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=hgwTzfIpIVeqiYNBKYHOxpfj+5pdBH1Ou0ntJ7RK4jJimF8QSz5WT/y0+U+wUciwvMxcnk8cb1cvTyNl0s169a4nBtSaZoE2ZYKbaXncma8d3BA0qYttilCiMuYuWuaKQuAAqX9boQf0FvQh19RozG7KZy5EggUojUMdXkGlPcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i1KJt2Gp; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i1KJt2Gp"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3e055be2288so44249915ab.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Jul 2025 15:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752014291; x=1752619091; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sSGE81kG8MSU1EuzRA4Ju+fw25jrq48Z8DcwNvLiEVI=;
        b=i1KJt2GptBaeMBHwomfp7E8H0CSuuY0H2jLqYOPmxeiSZDexK6fi9RKuVr6EFBR18V
         HqfD2j0hz0dxTui3XZ3ZKWkNeaTuzc9hSGqSZBUM3/bIbZm8X6tVZS2WUWGJMSb//dUl
         R0pWLUEGtTfpSWmH+9jlsZYeGBAZORT6N6+H/hbp+v8VGKYMgj1A++n8ofydui9gIeVL
         Af2BhZF2Pr18NvErBlBFP/3fAMkZoTRfFF+VMZGWw0YAqjZ3qo6lVhUU7kboVVh590F4
         pppvkUkKG29uMvh5m2Aw1lcRZfF2LGL12k8bUS96QWQxBtGQcBURCVzAfTzcLxdoMZPa
         oAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752014291; x=1752619091;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSGE81kG8MSU1EuzRA4Ju+fw25jrq48Z8DcwNvLiEVI=;
        b=a8Fz64aoK9+FriXiGRuim1fNL+8ngYW+4+lrnCgepUNUfbNYuGjeXVyvdJU/0XV2AN
         4CqjKMZcxGSZkzbBZ98bMedabUkXr6SgjfR8TpyAprjwH+6WuUIHE/N90uhfgBOHqU5N
         VlqHyho52L3JDFmzvPc43543+hIcrJVjUVm/rZG1NpigV1KPpQAM+kYJ1r1xjPfSdDA2
         km2ioTMkxXkFPEhx2YeGvGU9CNjQcg7ABqSc59tlkjU3TicnTI/x7oxOsDQ+eOaGXz32
         60QXAIlgZw0LSr9Ddk+ZThuKWCqJrvh4DM8igVCgcvey6htnap376A4ONWLRnmobl1uE
         mMUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTts/SQkoTfaQ6AzaoUts5caCzSEm0r9/0+WlTu4No6010uUvTJqQ56aXiNy+7uFmDLre1Ptw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbiTjvJ+N/c3CLb1y0xkLn+FR0C6Kdfm5BLOTq4ryNvaAAQxZK
	DUQf9PzybxmJNQOFriuVei5CnFje7w8VP3HEjR+n2Z/Spx7k6TQZmFOiHOnbQ/uyYAVlzTG4EUb
	s2lAtrmUEirV8zLFvhglGQbKVYg==
X-Google-Smtp-Source: AGHT+IElZSU1mvIYmkS4wS1+niCRVTirXhRKz2Czs2rKpnrIyPxUWzZESy39W+5ywF5yW6YiMbWYADPEahU+1UGQ7Q==
X-Received: from ilbea23-n1.prod.google.com ([2002:a05:6e02:4517:10b0:3df:34b7:24e5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1a8d:b0:3df:2f47:dc21 with SMTP id e9e14a558f8ab-3e16711a372mr4583915ab.22.1752014291170;
 Tue, 08 Jul 2025 15:38:11 -0700 (PDT)
Date: Tue, 08 Jul 2025 22:38:10 +0000
In-Reply-To: <aGv8vgrZTET0aXjQ@J2N7QTR9R3> (message from Mark Rutland on Mon,
 7 Jul 2025 17:58:38 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntzfdez4tp.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 07/22] perf: arm_pmuv3: Generalize counter bitmasks
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

> On Thu, Jun 26, 2025 at 08:04:43PM +0000, Colton Lewis wrote:
>> The OVSR bitmasks are valid for enable and interrupt registers as well as
>> overflow registers. Generalize the names.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> FWIW, this looks fine to me, so:

> Acked-by: Mark Rutland <mark.rutland@arm.com>

> Mark.

Thanks.
>> ---
>>   drivers/perf/arm_pmuv3.c       |  4 ++--
>>   include/linux/perf/arm_pmuv3.h | 14 +++++++-------
>>   2 files changed, 9 insertions(+), 9 deletions(-)

>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>> index 6358de6c9fab..3bc016afea34 100644
>> --- a/drivers/perf/arm_pmuv3.c
>> +++ b/drivers/perf/arm_pmuv3.c
>> @@ -513,7 +513,7 @@ static u64 armv8pmu_pmcr_n_read(void)

>>   static int armv8pmu_has_overflowed(u64 pmovsr)
>>   {
>> -	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
>> +	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
>>   }

>>   static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
>> @@ -749,7 +749,7 @@ static u64 armv8pmu_getreset_flags(void)
>>   	value = read_pmovsclr();

>>   	/* Write to clear flags */
>> -	value &= ARMV8_PMU_OVERFLOWED_MASK;
>> +	value &= ARMV8_PMU_CNT_MASK_ALL;
>>   	write_pmovsclr(value);

>>   	return value;
>> diff --git a/include/linux/perf/arm_pmuv3.h  
>> b/include/linux/perf/arm_pmuv3.h
>> index d698efba28a2..fd2a34b4a64d 100644
>> --- a/include/linux/perf/arm_pmuv3.h
>> +++ b/include/linux/perf/arm_pmuv3.h
>> @@ -224,14 +224,14 @@
>>   				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)

>>   /*
>> - * PMOVSR: counters overflow flag status reg
>> + * Counter bitmask layouts for overflow, enable, and interrupts
>>    */
>> -#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
>> -#define ARMV8_PMU_OVSR_C		BIT(31)
>> -#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
>> -/* Mask for writable bits is both P and C fields */
>> -#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C  
>> | \
>> -					ARMV8_PMU_OVSR_F)
>> +#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
>> +#define ARMV8_PMU_CNT_MASK_C		BIT(31)
>> +#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
>> +#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
>> +					 ARMV8_PMU_CNT_MASK_C | \
>> +					 ARMV8_PMU_CNT_MASK_F)

>>   /*
>>    * PMXEVTYPER: Event selection reg
>> --
>> 2.50.0.727.gbf7dc18ff4-goog


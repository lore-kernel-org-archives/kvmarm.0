Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665030FF04
	for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 23:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012730; cv=none; b=H4vY1WHouM52uKVq/U9C9ht3psgV0rYEHQQfOUZReugUNKJ8ILtVfYcnm5OlWvkTF5BhxPxjiIv6rpKktcdB6vaOAQEgrJzAb4SAuaZKc5oBrp9Bkf/pF+sz4jECWRSNH2nGg9dAvCSo5uCtpqaeV20XFJw9OtA3jWfoWlWcS1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012730; c=relaxed/simple;
	bh=0l/omZO1v8asiZJMEMWG7M0JnZi5IJrGYo3/p+gESCE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GRRihwM3sy0zFbrnLLc4p+KxruTdele/OXa6IPwT/f3vDbBYYDr97sBzc37IJRo8gSPirSLtf3HsLnYCLUM4+eBgTSILibOeKI6fEuvWC9uD6/VS2SbMJ2YGLY1WWkqpKN+X74m4AUOngPaY72R947A/btIGkL+ojhJDgcA2KJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTHmDjNc; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTHmDjNc"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c70930bdf4so13530031a34.2
        for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 15:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766012727; x=1766617527; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLCAorwrKlMW8FunTjt8zj7Va5wWm7XneVrIZBSPv24=;
        b=DTHmDjNcfbz08E+HQYGnlOHullCOhrTJ5CC/IHXovQfwd8/nifr2FSY05LtaqQ6m52
         /Lo9mLdbWWfR4QgBBMCpY4Tw4PJZUDqX0Z9CLtKm8R6vrNrxn5t+Yoq5qD/8c/tDWz9y
         Nckp/FgJt3VUmUHu+cmEoQGLyLV/Onf2ZwrYuIV12Ry/zquUP8qjxBDsDYh8yokfmALp
         H7qFF4bHK7ZFyGnwHy5AwdbbnGolVUF1h1gVxCYq0goQwubM9hx9G95DYTOBIpF8FZMN
         VP+e4ItUSBxKAe9r//mS/SFexdvrkI2bRI5F3rHvz+NWD6lZfyCWdfligQfBZzLdvaeD
         LdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766012727; x=1766617527;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GLCAorwrKlMW8FunTjt8zj7Va5wWm7XneVrIZBSPv24=;
        b=qA4UFihQDnv281O8KUg7LpsKzKaCc8+TxfznqDJUPCqpLd/I2UnAEPx7ixgSEqnerT
         kxfAwkVzR7PQMyPXgHLroOXgXA/aeKCBCnig23svUZ+aEhVfzQ//ocCmibInZ990qjWR
         E2K7ivs36FXOcCX8pMaieqPhEsibBUNdXYk3yeSA2Wd74wYn3fvnBR4O7wqEolXn3HFl
         CPrOeRks4a7WGaYZ+q3Mry1H088FH/ez60bZYn6ZmnT9ysNMsKbLQPW2wGQKBoShO3Qz
         /CddONcTX16EnLBBdYKuXcuss3rdjA/WOAQmLKsk6VXjjMG97akqSEMDf8nO+MBQf9XJ
         PunA==
X-Forwarded-Encrypted: i=1; AJvYcCVf31lQuPm4msIZO/sy62Ai5KHX4AyGXwwEDY6TOvApnZ64U6PMLbmNR1XnmWV72115QZ7Meo4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLoXUvTlw7LwsEXA+ILvIxpQtCD2OFXchqbztzvr3h1mQnQyDn
	tug/IIWZ0x53lioN70gmcBT8JIR8npTLgRfHCxGwnRdxGEwMwS1Ozc8hkxrb+cytavK/oPeZgFs
	uh7Lr1F6+CXb4Afj+UvHe4c0fKA==
X-Google-Smtp-Source: AGHT+IFeAgC0uw9c+8LafGLGz/f6/NPZAPXmK9qXp7aoSKF9A72AfmoYnPNSSr0uyMWXg523FecZ0oA8sQssQiXDkg==
X-Received: from ilbbo32.prod.google.com ([2002:a05:6e02:3420:b0:430:ccc7:4f1e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4815:b0:65c:fe5b:9f4d with SMTP id 006d021491bc7-65cfe5ba58emr301994eaf.47.1766012727236;
 Wed, 17 Dec 2025 15:05:27 -0800 (PST)
Date: Wed, 17 Dec 2025 23:05:26 +0000
In-Reply-To: <aUH_7yYZsmFlRvEc@kernel.org> (message from Oliver Upton on Tue,
 16 Dec 2025 16:57:19 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntzf7g1zgp.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 18/24] KVM: arm64: Enforce PMU event filter at vcpu_load()
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> Re-reading this patch...

> On Tue, Dec 09, 2025 at 08:51:15PM +0000, Colton Lewis wrote:
>> The KVM API for event filtering says that counters do not count when
>> blocked by the event filter. To enforce that, the event filter must be
>> rechecked on every load since it might have changed since the last
>> time the guest wrote a value.

> Just directly state that this is guarding against userspace programming
> an unsupported event ID.

Sure

>> +static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
>> +	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
>> +		ARMV8_PMU_EXCLUDE_EL1;
>> +	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
>> +	u8 i;
>> +	u64 val;
>> +	u64 evsel;
>> +
>> +	if (!pmu)
>> +		return;
>> +
>> +	for (i = 0; i < pmu->hpmn_max; i++) {

> Iterate the bitmask of counters and you'll handle the cycle counter 'for
> free'.

Will do.

> <snip>

>> +		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
>> +		evsel = val & kvm_pmu_event_mask(vcpu->kvm);
>> +
>> +		if (vcpu->kvm->arch.pmu_filter &&
>> +		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
>> +			val |= evtyper_set;
>> +
>> +		val &= ~evtyper_clr;
>> +		write_pmevtypern(i, val);

> </snip>

> This all needs to be shared with writethrough_pmevtyper() instead of
> open-coding the same thing.

Will do.

> Thanks,
> Oliver

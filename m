Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D41ACEBF
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 22:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738102111; cv=none; b=Tk0a/3oW0iUfuaCUaytXpWmB9vAqwvwQvUAK+PqeQWopjC7d6cQiwygQyRpZ1RbfOC9rHrUZXqCCjl2+2yGiiZeAPFjCmZbQ7LcBDqNjVcPl0VjjjonnZ3wN0L8SlYYsyfEQxrSlTyQByUntpp+FhF3pMsZZcceWDAy891QJSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738102111; c=relaxed/simple;
	bh=1pSDae9H0Z9Wy7nbC30Dx1r3vFM/TWo0P+jj11OmfgE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oUqa9FZKNMpJ9pek14tgTkvP2tpqg4jkf5LDqrICMutrfPKnO7F4tiijEcQJxJJRiGLJ+meC+ESqaeWtpM+6JTWh9Wr09HvqI2Iq6NSSiotKefIoIRKxoSwrL88rJTaboaw5ehn85f+Btv8GdQUI7jYhxW0VvCyQ5kcoPF9R/ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P9afWDyr; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P9afWDyr"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a814bfb77bso998035ab.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 14:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738102108; x=1738706908; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=89hZLr5aXjLsq7ose3Afpbjn+HbyOiqrZ9vNJOq3AHM=;
        b=P9afWDyrnhiQdovIpIxMeRtHQR6ZKIpGiphItxnamgVzMPynhkerglwSu+CTp5htQT
         Akc3/05zuEtU/z4tx9WUt9dTZrJZpNwWBLUhcR7rl3/hOMNz1Is0YesBtmANFib8Etzn
         hWY4vB1I08NbdZkjrY8DhCb4dyut8GqMwcQE81tLt9kfz8bBogOD7dYOtGu5BnKbWOtz
         b4og1DFUrnPlilHNJbZPs1lxTTwJKMQtInfrTvf8GtKUxQQ0mMaXTf3D9b+TaU6tJ4lX
         wuS74ORLBTnYgefxqWs+8gE0h8KlWI382RWzLNisNpJB3jwWGiDxN3oRhb/x5n7na4IQ
         qFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738102108; x=1738706908;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89hZLr5aXjLsq7ose3Afpbjn+HbyOiqrZ9vNJOq3AHM=;
        b=FxuscEwIIAI4kZQPsAY1aQaoe2gaaW/u4CHXLseXVgCYprVLnACQCUu4/Z4WE5Eic9
         eDvKIzf5LaHhj4/Gh33GtEZhr6lpG3vvYcNwpxQkJmR9iZIRGR1jj9L7OVQEzVCJYV2p
         RU9naaRVwhsX72DExcjxBR39keBzLH+HOlgYK2bJi4f56ewGTYhT/d2Th1VNVd/K/VoS
         3Lq0nLyXUIvJ4phS715x3tb+oDVMu8MIgfV6UQgY1fzt8H5yMczZQu9d9uoUISJNJkDg
         2Co6iSFy4xjkvrPOGNeCc+Wm91IOHcJkh5MnFU546oXoyKE1GQefhdCGK/sK8vXmaUJC
         Yhaw==
X-Forwarded-Encrypted: i=1; AJvYcCVRWJr6ZEhYfi3YDqDSBK/3unU2f0JVAgRF6w8TOlzOn/G/lF8oS3U2N8XomDrYzjzEzDvT0Uw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSdKpOMujB5AkAGDBjf+jE174+iXq20DpGKunHGn9HJjy2SuzQ
	asHVE5qKCW809CELrM0BQu6YnZDKfkwsEt0PD+0jOQ09Ohuxh4nJvpnniUGqYVwUeNabSYu+SRU
	iEkGB55saAYm7fYpDWfDG5g==
X-Google-Smtp-Source: AGHT+IH262EdRMOUfzaaFC5efE8ynNaUUswWXOS0wN+Xzq+rqcX3FXHUmWZPPPAck4fFF452iQ0uNkTrY1IgQzsCXA==
X-Received: from ilbbn5.prod.google.com ([2002:a05:6e02:3385:b0:3cf:fc72:43e3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:b43:b0:3ce:7da0:6fe2 with SMTP id e9e14a558f8ab-3cffdc2c9c7mr9678045ab.0.1738102108397;
 Tue, 28 Jan 2025 14:08:28 -0800 (PST)
Date: Tue, 28 Jan 2025 22:08:27 +0000
In-Reply-To: <87ikpzthjk.wl-maz@kernel.org> (message from Marc Zyngier on Tue,
 28 Jan 2025 09:27:11 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntbjvq382s.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to
 partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hey Marc, thanks for looking.

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 27 Jan 2025 22:20:27 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> For PMUv3, the register MDCR_EL2.HPMN partitiones the PMU counters
>> into two ranges where counters 0..HPMN-1 are accessible by EL1 and, if
>> allowed, EL0 while counters HPMN..N are only accessible by EL2.

>> Introduce a module parameter in the PMUv3 driver to set this
>> register. The name reserved_guest_counters reflects the intent to
>> reserve some counters for the guest so they may eventually be allowed
>> direct access to a subset of PMU functionality for increased
>> performance.

>> Track HPMN and whether the pmu is partitioned in struct arm_pmu.

>> While FEAT_HPMN0 does allow HPMN to be set to 0, this patch
>> specifically disallows that case because it's not useful given the
>> intention to allow guests access to their own counters.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm/include/asm/arm_pmuv3.h   | 10 +++++++
>>   arch/arm64/include/asm/arm_pmuv3.h | 10 +++++++
>>   drivers/perf/arm_pmuv3.c           | 43 ++++++++++++++++++++++++++++--
>>   include/linux/perf/arm_pmu.h       |  2 ++
>>   include/linux/perf/arm_pmuv3.h     |  7 +++++
>>   5 files changed, 70 insertions(+), 2 deletions(-)

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 2ec0e5e83fc9..49ad90486aa5 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -277,4 +277,14 @@ static inline u64 read_pmceid1(void)
>>   	return val;
>>   }

>> +static inline u32 read_mdcr(void)
>> +{
>> +	return read_sysreg(mdcr_el2);
>> +}
>> +
>> +static inline void write_mdcr(u32 val)
>> +{
>> +	write_sysreg(val, mdcr_el2);
>> +}
>> +

> This will obviously break the 32bit build.

Dang! I did compile with 32 bit arm but I used defconfig which I now
realize doesn't define CONFIG_ARM_PMUV3 even though 64 bit arm does.

>>   #endif
>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index 8a777dec8d88..fc37e7e81e07 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -188,4 +188,14 @@ static inline bool is_pmuv3p9(int pmuver)
>>   	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P9;
>>   }

>> +static inline u64 read_mdcr(void)
>> +{
>> +	return read_sysreg(mdcr_el2);
>> +}
>> +
>> +static inline void write_mdcr(u64 val)
>> +{
>> +	write_sysreg(val, mdcr_el2);
>> +}
>> +
>>   #endif
>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>> index b5cc11abc962..55f9ae560715 100644
>> --- a/drivers/perf/arm_pmuv3.c
>> +++ b/drivers/perf/arm_pmuv3.c
>> @@ -325,6 +325,7 @@ GEN_PMU_FORMAT_ATTR(threshold_compare);
>>   GEN_PMU_FORMAT_ATTR(threshold);

>>   static int sysctl_perf_user_access __read_mostly;
>> +static u8 reserved_guest_counters __read_mostly;

>>   static bool armv8pmu_event_is_64bit(struct perf_event *event)
>>   {
>> @@ -500,6 +501,29 @@ static void armv8pmu_pmcr_write(u64 val)
>>   	write_pmcr(val);
>>   }

>> +static u64 armv8pmu_mdcr_read(void)
>> +{
>> +	return read_mdcr();
>> +}
>> +
>> +static void armv8pmu_mdcr_write(u64 val)
>> +{
>> +	write_mdcr(val);
>> +	isb();
>> +}
>> +
>> +static void armv8pmu_partition(u8 hpmn)
>> +{
>> +	u64 mdcr = armv8pmu_mdcr_read();
>> +
>> +	mdcr &= ~MDCR_EL2_HPMN_MASK;
>> +	mdcr |= FIELD_PREP(ARMV8_PMU_MDCR_HPMN, hpmn);
>> +	/* Prevent guest counters counting at EL2 */
>> +	mdcr |= ARMV8_PMU_MDCR_HPMD;
>> +
>> +	armv8pmu_mdcr_write(mdcr);
>> +}
>> +
>>   static int armv8pmu_has_overflowed(u64 pmovsr)
>>   {
>>   	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
>> @@ -1069,6 +1093,9 @@ static void armv8pmu_reset(void *info)

>>   	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);

>> +	if (cpu_pmu->partitioned)
>> +		armv8pmu_partition(cpu_pmu->hpmn);
>> +

> Kaboom, see below.

>>   	/* The counter and interrupt enable registers are unknown at reset. */
>>   	armv8pmu_disable_counter(mask);
>>   	armv8pmu_disable_intens(mask);
>> @@ -1205,6 +1232,7 @@ static void __armv8pmu_probe_pmu(void *info)
>>   {
>>   	struct armv8pmu_probe_info *probe = info;
>>   	struct arm_pmu *cpu_pmu = probe->pmu;
>> +	u8 pmcr_n;
>>   	u64 pmceid_raw[2];
>>   	u32 pmceid[2];
>>   	int pmuver;
>> @@ -1215,10 +1243,19 @@ static void __armv8pmu_probe_pmu(void *info)

>>   	cpu_pmu->pmuver = pmuver;
>>   	probe->present = true;
>> +	pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());

>>   	/* Read the nb of CNTx counters supported from PMNC */
>> -	bitmap_set(cpu_pmu->cntr_mask,
>> -		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
>> +	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
>> +
>> +	if (reserved_guest_counters > 0 && reserved_guest_counters < pmcr_n) {
>> +		cpu_pmu->hpmn = reserved_guest_counters;
>> +		cpu_pmu->partitioned = true;

> Isn't this going to completely explode on a kernel running at EL1?

Trying to access an EL2 register at EL1 can do that. I'll add the
appropriate hypercalls.

> Also, how does it work in an asymmetric configuration where some CPUs
> can satisfy the reservation, and some can't?

The CPUs that can't read their own value of PMCR.N below what the
attempted reservation is and so do not get partitioned. Nothing changes
for that CPU if it can't meet the reservation.

>> +	} else {
>> +		reserved_guest_counters = 0;
>> +		cpu_pmu->hpmn = pmcr_n;
>> +		cpu_pmu->partitioned = false;
>> +	}

>>   	/* Add the CPU cycles counter */
>>   	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
>> @@ -1516,3 +1553,5 @@ void arch_perf_update_userpage(struct perf_event  
>> *event,
>>   	userpg->cap_user_time_zero = 1;
>>   	userpg->cap_user_time_short = 1;
>>   }
>> +
>> +module_param(reserved_guest_counters, byte, 0);
>> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
>> index 4b5b83677e3f..ad97aabed25a 100644
>> --- a/include/linux/perf/arm_pmu.h
>> +++ b/include/linux/perf/arm_pmu.h
>> @@ -101,6 +101,8 @@ struct arm_pmu {
>>   	void		(*reset)(void *);
>>   	int		(*map_event)(struct perf_event *event);
>>   	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
>> +	u8		hpmn; /* MDCR_EL2.HPMN: counter partition pivot */
>> +	bool	        partitioned;
>>   	bool		secure_access; /* 32-bit ARM only */
>>   #define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
>>   	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
>> diff --git a/include/linux/perf/arm_pmuv3.h  
>> b/include/linux/perf/arm_pmuv3.h
>> index d698efba28a2..d399e8c6f98e 100644
>> --- a/include/linux/perf/arm_pmuv3.h
>> +++ b/include/linux/perf/arm_pmuv3.h
>> @@ -223,6 +223,13 @@
>>   				 ARMV8_PMU_PMCR_X | ARMV8_PMU_PMCR_DP | \
>>   				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)

>> +/*
>> + * Per-CPU MDCR: config reg
>> + */
>> +#define ARMV8_PMU_MDCR_HPMN		GENMASK(4, 0)
>> +#define ARMV8_PMU_MDCR_HPME		BIT(7)
>> +#define ARMV8_PMU_MDCR_HPMD		BIT(17)
>> +

> I'd rather we find a way to use the existing definitions form the
> sysreg file rather than add more duplication.

Easy enough

> I also don't see how the kernel knows not to access the low-numbered
> counters at this point. Maybe in a later patch, I'll keep reading.

> 	M.

> --
> Without deviation from the norm, progress is not possible.

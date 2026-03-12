Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BD63368AD
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 22:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355148; cv=none; b=F84B9kMro8rbar77XOxOKliLpl1CHKK1ag5Xdh60c9LkUifLgHLt/v3XrxSKHqhtcjYqildVYLLUzp/pPKHas1UuJ5wZtl7FtOHydj64W3xdSaqifnIHCF1aMoed8BxyU5VbzzidWdL9Dc7+86Q60ceFNJGwLfs+szjEFOl9yJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355148; c=relaxed/simple;
	bh=EynIJtzdrCyScLBliL/fmRpWOlPioIlYu5lT4zbcsvg=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=WTFJpi8xD0kQYEU+eEuqin9RecAtLHTgQHIiqoYzcRM0zaQkWJNlKXCILuGCbNIxpWkyNsJY8GsUsKtnE22AfuPAABBfOE2V74P6/WajQ+wWTBCfg3nwDc1qI9TAQOZCMsbVwg7h3q0sA23j7HihpT44170Aq5CQZSzFSaZiIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pH5rRORY; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pH5rRORY"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-67bb5810407so22749031eaf.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 15:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773355146; x=1773959946; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IkDxS9fCpHHZ8XD7eD09vRf6IL+V4v6HCS03WBPRNsg=;
        b=pH5rRORYfhIqyacHiXjDjYiNdVwiU8+5794x94RHzipAdxmvB6kjd+bpVRJskgPcAh
         XoCqVZpY9q1rluFiw310f87/nu6+ZIlo0BLj3vKSxPKtFQNmLYO+eBcx3K0I2w23Gfsg
         C0D8dtmRpdYQgtLi+c2dWE9ScKeK3+GEztsjb6gYrgK5uUeo6+LYaBYBuGfq9LadmpcN
         ZklevwvsJP9KnuyWOwKYJSA4efc5UePhVd0BZ3bsLJeNZq56vDynO9MYWMu5JwMeS9IF
         awslVHc3V3s45Z17J58R2mkZ1yqE/G4S73sfnudAJgNSbBDJjBfM19Tuq56FrgVsZtxi
         LzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773355146; x=1773959946;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IkDxS9fCpHHZ8XD7eD09vRf6IL+V4v6HCS03WBPRNsg=;
        b=SPZjTaezUVyY90ACPLe8oFYRbP2W9YT0SBkoJjt6FJBfCq+wCjEJc2mh5IFmS0VzEg
         SzLA4hpLx0jqd0BFsfmF8mbW8o+Dnr+zNzSLM0iwutnp+OO9Djg4OkjX6i+UdsW8XhF1
         K48Kspjyvg5hg0UKcaqgk3Yv7fJBiPI8xRP2BQKnBmvqMIMFL5kf4wfoLtFGfaJY0Khr
         YYPU2d3biBClYZNlMliNFtBfv2Wq56o7MIIT3yisA772xu6cIy8ul+Lpo5c0lho+yiNE
         wfnA67ZEm/qOVTxouwptQF2N0Ci6rcpGDGYAq1zHO/ytfSTQYbCLrXhPNMZlFypLZtWO
         RVJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1UwdrrXxxWFRx8bOh5h+ZtI5lcx0TkCa9wW+2CjosLbJURMmDKtk4+UrS1m1UE/4YDuwUHTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZaUimcOcpPXaFMFAeSa0oPmUhyRxBv8bMAqwO6saI7vWoqSCl
	cFU3ahJ7bDuOGr8cdbvCx8RRr4EQ5DkOY+AOKPrWxUBWapXrScYyRk+fAGAoBkfvMjR0r9XFZYm
	z9jIStkb66geqvewafL24hFi6lA==
X-Received: from iobii3.prod.google.com ([2002:a05:6602:6b83:b0:963:ff03:1c17])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:180c:b0:67b:bd0e:cd5f with SMTP id 006d021491bc7-67bda9c04femr795812eaf.26.1773355145728;
 Thu, 12 Mar 2026 15:39:05 -0700 (PDT)
Date: Thu, 12 Mar 2026 22:39:04 +0000
In-Reply-To: <1e97d367-ae01-4cd2-8005-f690e6d7f72d@linaro.org> (message from
 James Clark on Wed, 11 Mar 2026 12:00:42 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcy18oepj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 06/19] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> On 09/02/2026 10:14 pm, Colton Lewis wrote:
>> If the PMU is partitioned, keep the driver out of the guest counter
>> partition and only use the host counter partition.

>> Define some functions that determine whether the PMU is partitioned
>> and construct mutually exclusive bitmaps for testing which partition a
>> particular counter is in. Note that despite their separate position in
>> the bitmap, the cycle and instruction counters are always in the guest
>> partition.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm/include/asm/arm_pmuv3.h | 18 +++++++
>>    arch/arm64/kvm/pmu-direct.c      | 86 ++++++++++++++++++++++++++++++++
>>    drivers/perf/arm_pmuv3.c         | 40 +++++++++++++--
>>    include/kvm/arm_pmu.h            | 24 +++++++++
>>    4 files changed, 164 insertions(+), 4 deletions(-)

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 154503f054886..bed4dfa755681 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -231,6 +231,24 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>    }

>>    static inline void kvm_vcpu_pmu_resync_el0(void) {}
>> +static inline void kvm_pmu_host_counters_enable(void) {}
>> +static inline void kvm_pmu_host_counters_disable(void) {}
>> +
>> +static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	return ~0;
>> +}
>> +
>> +static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	return ~0;
>> +}
>> +

>>    /* PMU Version in DFR Register */
>>    #define ARMV8_PMU_DFR_VER_NI        0
>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> index 74e40e4915416..05ac38ec3ea20 100644
>> --- a/arch/arm64/kvm/pmu-direct.c
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -5,6 +5,8 @@
>>     */

>>    #include <linux/kvm_host.h>
>> +#include <linux/perf/arm_pmu.h>
>> +#include <linux/perf/arm_pmuv3.h>

>>    #include <asm/arm_pmuv3.h>

>> @@ -20,3 +22,87 @@ bool has_host_pmu_partition_support(void)
>>    	return has_vhe() &&
>>    		system_supports_pmuv3();
>>    }
>> +
>> +/**
>> + * kvm_pmu_is_partitioned() - Determine if given PMU is partitioned
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Determine if given PMU is partitioned by looking at hpmn field. The
>> + * PMU is partitioned if this field is less than the number of
>> + * counters in the system.
>> + *
>> + * Return: True if the PMU is partitioned, false otherwise
>> + */
>> +bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>> +{
>> +	if (!pmu)
>> +		return false;
>> +
>> +	return pmu->max_guest_counters >= 0 &&
>> +		pmu->max_guest_counters <= *host_data_ptr(nr_event_counters);
>> +}
>> +
>> +/**
>> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the host-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in HPMN..N
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
>> +
>> +	if (!kvm_pmu_is_partitioned(pmu))
>> +		return ARMV8_PMU_CNT_MASK_ALL;
>> +
>> +	return GENMASK(nr_counters - 1, pmu->max_guest_counters);
>> +}
>> +
>> +/**
>> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the guest-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in 0..HPMN and the cycle and instruction counters.
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	return ARMV8_PMU_CNT_MASK_C & GENMASK(pmu->max_guest_counters - 1, 0);

> This should be an | instead of an & otherwise it's always zero. None of
> the passed through counters count anything with it like this, although
> the cycle counter always worked even with this issue.

> I'm not sure if the selftests that you added catch this? I didn't try
> running them but seems like checking for non zero counter values is a
> very easy thing to test.

I caught this myself and called it out here:

https://lore.kernel.org/kvmarm/gsntseaoogk7.fsf@coltonlewis-kvm.c.googlers.com/

The selftest didn't catch this, so you're right it's a good idea to check.

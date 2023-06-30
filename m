Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC4B168B4
	for <kvmarm@lists.linux.dev>; Fri, 30 Jun 2023 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688145342;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdTDhbZr4eQQTRSk7eayCEYmdszTgdjX7jCu+h7WTEM=;
	b=EQzIsnvsD54GlIYNfLNEqA/H04on3PWIi18eqe6CARt4ZNav2dMHON3ZsRjxMBYSaB6Tzx
	ZRSB1HI2i/jYetFTLqTTDScUYJVlv+5dPpICRRyQHMnTlDXbPVCb/3gKN2DGSawp1owrqx
	oOp5SfD9QB0hU0+du3ZvmHgnKrHrmwc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-MxA8HRRgM6Cyj_IT_IAa-g-1; Fri, 30 Jun 2023 13:15:41 -0400
X-MC-Unique: MxA8HRRgM6Cyj_IT_IAa-g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-314291caa91so37901f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 30 Jun 2023 10:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688145340; x=1690737340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdTDhbZr4eQQTRSk7eayCEYmdszTgdjX7jCu+h7WTEM=;
        b=XcvMfvMjwkqChsnWVodCEnBWUKDjarT0nINHxOQzTei7CB2ugcM+CfSHfEhgzIDLh1
         V2/t6BHu88gYpkg6/z7ncTwJ8oHAa6V+x/WtoqnnxVDpk85usLcVnBe3P0O26FwGl/Hp
         sOxiXEAkUNGssHJbXgqzKA3URYC5WYmN+MK2+nCIan1LecFNaFZNybe+30ClVzW7L6kV
         5oFi+R1d81qou2jxB/uUAHc8SWt1KP4mcjLkLIV2ecIw9QY0ncOnTfIXoa8gi87f3M3K
         +AXXoi/sZgO/n6waWwqXNNXYmDKOjdR4xHKu8ExK9INRIX6EBiUidZe3GlP4Fn/cghGT
         vl2w==
X-Gm-Message-State: ABy/qLa1yAVcwafb2+T+UvSAGen9HfiZv49G2xjg9ILrdFlsueT40NRE
	c1DShhqmQcBMUSkB/DoAyI0lk6EysUd5DIthAkN80ufEFo9CwMUjEJZnuqFzoUZTzT0DuXL+zIL
	lc0HDKxn436X0+/1c
X-Received: by 2002:a5d:63ca:0:b0:314:2594:7b9f with SMTP id c10-20020a5d63ca000000b0031425947b9fmr1537713wrw.11.1688145340110;
        Fri, 30 Jun 2023 10:15:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGYQtNnqxzBlUMaJpB4SLIl9agMNRhMzLKZKgZfHAAAO79NYFKr3eANPETkJIKzZ3Y9SRHyrA==
X-Received: by 2002:a5d:63ca:0:b0:314:2594:7b9f with SMTP id c10-20020a5d63ca000000b0031425947b9fmr1537691wrw.11.1688145339672;
        Fri, 30 Jun 2023 10:15:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h11-20020a1ccc0b000000b003fa8158135esm20167744wmb.11.2023.06.30.10.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 10:15:38 -0700 (PDT)
Message-ID: <829d87f7-2103-ef6f-5d3b-18aa8f8cb850@redhat.com>
Date: Fri, 30 Jun 2023 19:15:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
 mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
 <ZJ7_UrrBdgn6FB7-@monolith.localdoman>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZJ7_UrrBdgn6FB7-@monolith.localdoman>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 6/30/23 18:14, Alexandru Elisei wrote:
> Hi,
>
> On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
>> Add a new basic test that runs MEM_ACCESS loop over
>> 100 iterations and make sure the number of measured
>> MEM_ACCESS never overflows the margin. Some other
>> pmu tests rely on this pattern and if the MEM_ACCESS
>> measurement is not reliable, it is better to report
>> it beforehand and not confuse the user any further.
>>
>> Without the subsequent patch, this typically fails on
>> ThunderXv2 with the following logs:
>>
>> INFO: pmu: pmu-mem-access-reliability: 32-bit overflows:
>> overflow=1 min=21 max=41 COUNT=20 MARGIN=15
>> FAIL: pmu: pmu-mem-access-reliability: 32-bit overflows:
>> mem_access count is reliable
> Looks good:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Also ran the test on my rockpro64, with qemu and kvmtool. With kvmtool,
> when running on the little cores, min=max=250, but when running on the big
> cores, there was some deviation from that, I would say about 5 events,
> varying from run to run. I assume this is because the little cores are in
> order, and the big cores are out of order. Maybe the reason why you are
> seeing such a big difference between min and max on the ThunderX 2, the
> core might be speculating more aggressively.

thank you for your time. At least this new test outputting the min/max
will give interesting indications of what can be expected from the mem
access count precision on a given HW.
>
> Anyway:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

Eric
>
> Thanks,
> Alex
>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v2 -> v3:
>> - rename variables as suggested by Alexandru, rework the
>>   traces accordingly. Use all_set.
>>
>> v1 -> v2:
>> - use mem-access instead of memaccess as suggested by Mark
>> - simplify the logic and add comments in the test loop
>> ---
>>  arm/pmu.c         | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg |  6 +++++
>>  2 files changed, 65 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 0995a249..491d2958 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -56,6 +56,11 @@
>>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>>  
>>  #define ALL_SET_32		0x00000000FFFFFFFFULL
>> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
>> +
>> +#define ALL_SET(__overflow_at_64bits)				\
>> +	(__overflow_at_64bits ? ALL_SET_64 : ALL_SET_32)
>> +
>>  #define ALL_CLEAR		0x0000000000000000ULL
>>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>> @@ -67,6 +72,10 @@
>>   * for some observed variability we take into account a given @MARGIN
>>   */
>>  #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
>> +#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
>> +
>> +#define PRE_OVERFLOW2(__overflow_at_64bits)				\
>> +	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
>>  
>>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
>> @@ -744,6 +753,53 @@ static void test_chained_sw_incr(bool unused)
>>  		    read_regn_el0(pmevcntr, 0), \
>>  		    read_sysreg(pmovsclr_el0))
>>  
>> +/*
>> + * This test checks that a mem access loop featuring COUNT accesses
>> + * does not overflow with an init value of PRE_OVERFLOW2. It also
>> + * records the min/max access count to see how much the counting
>> + * is (un)reliable
>> + */
>> +static void test_mem_access_reliability(bool overflow_at_64bits)
>> +{
>> +	uint32_t events[] = {MEM_ACCESS};
>> +	void *addr = malloc(PAGE_SIZE);
>> +	uint64_t cntr_val, num_events, max = 0, min = pmevcntr_mask();
>> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
>> +	uint64_t all_set = ALL_SET(overflow_at_64bits);
>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>> +	bool overflow = false;
>> +
>> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>> +	    !check_overflow_prerequisites(overflow_at_64bits))
>> +		return;
>> +
>> +	pmu_reset();
>> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>> +	for (int i = 0; i < 100; i++) {
>> +		pmu_reset();
>> +		write_regn_el0(pmevcntr, 0, pre_overflow2);
>> +		write_sysreg_s(0x1, PMCNTENSET_EL0);
>> +		isb();
>> +		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +		cntr_val = read_regn_el0(pmevcntr, 0);
>> +		if (cntr_val >= pre_overflow2) {
>> +			num_events = cntr_val - pre_overflow2;
>> +		} else {
>> +			/* unexpected counter overflow */
>> +			num_events = cntr_val + all_set - pre_overflow2;
>> +			overflow = true;
>> +			report_info("iter=%d num_events=%ld min=%ld max=%ld overflow!!!",
>> +				    i, num_events, min, max);
>> +		}
>> +		/* record extreme value */
>> +		max = MAX(num_events, max);
>> +		min = MIN(num_events, min);
>> +	}
>> +	report_info("overflow=%d min=%ld max=%ld expected=%d acceptable margin=%d",
>> +		    overflow, min, max, COUNT, MARGIN);
>> +	report(!overflow, "mem_access count is reliable");
>> +}
>> +
>>  static void test_chain_promotion(bool unused)
>>  {
>>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>  		run_event_test(argv[1], test_basic_event_count, false);
>>  		run_event_test(argv[1], test_basic_event_count, true);
>> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
>> +		run_event_test(argv[1], test_mem_access_reliability, false);
>> +		run_event_test(argv[1], test_mem_access_reliability, true);
>>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>>  		run_event_test(argv[1], test_mem_access, false);
>>  		run_event_test(argv[1], test_mem_access, true);
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 5e67b558..fe601cbb 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -90,6 +90,12 @@ groups = pmu
>>  arch = arm64
>>  extra_params = -append 'pmu-mem-access'
>>  
>> +[pmu-mem-access-reliability]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +extra_params = -append 'pmu-mem-access-reliability'
>> +
>>  [pmu-sw-incr]
>>  file = pmu.flat
>>  groups = pmu
>> -- 
>> 2.38.1
>>


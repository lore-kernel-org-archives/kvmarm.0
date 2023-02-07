Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF9253A5
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675784758;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJfeQWowoNTHHyi6pKV2kY7wFhtNY5CB+H2FkVG4GJs=;
	b=SuQkGYIFGpeBNeZ0rZ9VZ2ZMbHXPq5HRRH/bRuXmWWl3GLKXL87lLzO+9OfTz64r8bn07Q
	jvb+L6gfEFJ7x5eGXS9Ta8OMf12F2HVbvI0ezz3RMc/Vi4Q7bklSMQ0OSP5ORsEJ7FWMfn
	L7Jc4q75l8njzwaZQRSmH2ZGK7bKs4Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-_gNkuVgrO--kk5z2I0_AOQ-1; Tue, 07 Feb 2023 10:45:56 -0500
X-MC-Unique: _gNkuVgrO--kk5z2I0_AOQ-1
Received: by mail-qk1-f200.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso10102550qko.11
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 07:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GJfeQWowoNTHHyi6pKV2kY7wFhtNY5CB+H2FkVG4GJs=;
        b=8J1paAL8vPtPE0OFWaWdyHYe76g3B/d9W3/UFB1yKbbB5PmJaH0wozfTHlUeeYqQcF
         cRxV32tBHbBNOM+cuOq8B8Ik8dsUAoUZlJotGTf1D2s3OWAHUZX9ODYEJHG6uSrGqkny
         dnF2Aok4SRUV6fF+EoSUQjDannr8FFM12zHuSHjr4+rNg3vh3+irV2HoojGkqZbmFxAq
         lSJNDYWpiRne9+QEprZI51n0b8G8nLdHIS09CibylM6f8bd/KaMg1psdbNa5SZIhuuMs
         utefKqHyDmf61l3tRPd/T7r3aqPOD++lFcqFryhhAWPptEwNQful/5lAkUpymrV4riRa
         34vQ==
X-Gm-Message-State: AO0yUKVE+zMuBZGOy6l9ufYmLpoxeGGqIfTuMnF2eFYJreEknQScGeTD
	rcEkkw0fp/smc+8GvphvPjqtmWUJcqqLzWb3TchT/jWX35HzaQXOo+sqA0ykFmDgTtFyl+9Z38e
	Hm46xvCaLdNhrKDtj
X-Received: by 2002:ac8:4e96:0:b0:3b6:38cf:1277 with SMTP id 22-20020ac84e96000000b003b638cf1277mr4879010qtp.64.1675784755807;
        Tue, 07 Feb 2023 07:45:55 -0800 (PST)
X-Google-Smtp-Source: AK7set9Ge3K7xXBwU+Sq3Q7a4Kd9jW1ZNPN0e0DKM364KWX7jmUBQJOerh3LAwBAlYzl5qnTVULI0Q==
X-Received: by 2002:ac8:4e96:0:b0:3b6:38cf:1277 with SMTP id 22-20020ac84e96000000b003b638cf1277mr4878978qtp.64.1675784755463;
        Tue, 07 Feb 2023 07:45:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id fv22-20020a05622a4a1600b003b646123691sm9700008qtb.31.2023.02.07.07.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:45:54 -0800 (PST)
Message-ID: <e119c970-8c3f-5d24-08a0-9dfb44fe4679@redhat.com>
Date: Tue, 7 Feb 2023 16:45:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/6] arm: pmu: Prepare for testing
 64-bit overflows
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-3-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-3-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 1/26/23 17:53, Ricardo Koller wrote:
> PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
> instead of 32. Prepare by doing these 3 things:
>
> 1. Add a "bool overflow_at_64bits" argument to all tests checking
>    overflows.
Actually test_chained_sw_incr() and test_chained_counters() also test
overflows but they feature CHAIN events. I guess that's why you don't
need the LP flag. Just tweek the commit msg if you need to respin.
> 2. Extend satisfy_prerequisites() to check if the machine supports
>    "overflow_at_64bits".
> 3. Refactor the test invocations to use the new "run_test()" which adds a
>    report prefix indicating whether the test uses 64 or 32-bit overflows.
>
> A subsequent commit will actually add the 64-bit overflow tests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arm/pmu.c | 99 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 60 insertions(+), 39 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 7f0794d..06cbd73 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -164,13 +164,13 @@ static void pmu_reset(void)
>  /* event counter tests only implemented for aarch64 */
>  static void test_event_introspection(void) {}
>  static void test_event_counter_config(void) {}
> -static void test_basic_event_count(void) {}
> -static void test_mem_access(void) {}
> -static void test_sw_incr(void) {}
> -static void test_chained_counters(void) {}
> -static void test_chained_sw_incr(void) {}
> -static void test_chain_promotion(void) {}
> -static void test_overflow_interrupt(void) {}
> +static void test_basic_event_count(bool overflow_at_64bits) {}
> +static void test_mem_access(bool overflow_at_64bits) {}
> +static void test_sw_incr(bool overflow_at_64bits) {}
> +static void test_chained_counters(bool unused) {}
> +static void test_chained_sw_incr(bool unused) {}
> +static void test_chain_promotion(bool unused) {}
> +static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -435,13 +435,24 @@ static uint64_t pmevcntr_mask(void)
>  	return (uint32_t)~0;
>  }
>  
> -static void test_basic_event_count(void)
> +static bool check_overflow_prerequisites(bool overflow_at_64bits)
> +{
> +	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
> +		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void test_basic_event_count(bool overflow_at_64bits)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
>  	uint32_t counter_mask;
>  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
> @@ -515,12 +526,13 @@ static void test_basic_event_count(void)
>  		"check overflow happened on #0 only");
>  }
>  
> -static void test_mem_access(void)
> +static void test_mem_access(bool overflow_at_64bits)
>  {
>  	void *addr = malloc(PAGE_SIZE);
>  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	pmu_reset();
> @@ -551,13 +563,14 @@ static void test_mem_access(void)
>  			read_sysreg(pmovsclr_el0));
>  }
>  
> -static void test_sw_incr(void)
> +static void test_sw_incr(bool overflow_at_64bits)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
>  	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>  	int i;
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	pmu_reset();
> @@ -597,7 +610,7 @@ static void test_sw_incr(void)
>  		"overflow on counter #0 after 100 SW_INCR");
>  }
>  
> -static void test_chained_counters(void)
> +static void test_chained_counters(bool unused)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
>  
> @@ -638,7 +651,7 @@ static void test_chained_counters(void)
>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
> -static void test_chained_sw_incr(void)
> +static void test_chained_sw_incr(bool unused)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
>  	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> @@ -691,7 +704,7 @@ static void test_chained_sw_incr(void)
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
>  
> -static void test_chain_promotion(void)
> +static void test_chain_promotion(bool unused)
>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>  	void *addr = malloc(PAGE_SIZE);
> @@ -840,13 +853,14 @@ static bool expect_interrupts(uint32_t bitmap)
>  	return true;
>  }
>  
> -static void test_overflow_interrupt(void)
> +static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
>  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
>  	void *addr = malloc(PAGE_SIZE);
>  	int i;
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	gic_enable_defaults();
> @@ -1070,6 +1084,27 @@ static bool pmu_probe(void)
>  	return true;
>  }
>  
> +static void run_test(const char *name, const char *prefix,
> +		     void (*test)(bool), void *arg)
> +{
> +	report_prefix_push(name);
> +	report_prefix_push(prefix);
> +
> +	test(arg);
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void run_event_test(char *name, void (*test)(bool),
> +			   bool overflow_at_64bits)
> +{
> +	const char *prefix = overflow_at_64bits ? "64-bit overflows"
> +						: "32-bit overflows";
> +
> +	run_test(name, prefix, test, (void *)overflow_at_64bits);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int cpi = 0;
> @@ -1102,33 +1137,19 @@ int main(int argc, char *argv[])
>  		test_event_counter_config();
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_basic_event_count();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_basic_event_count, false);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_mem_access();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_mem_access, false);
>  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_sw_incr();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_sw_incr, false);
>  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chained_counters();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chained_counters, false);
>  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chained_sw_incr();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chained_sw_incr, false);
>  	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chain_promotion();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chain_promotion, false);
>  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_overflow_interrupt();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_overflow_interrupt, false);
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}


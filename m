Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4A7C
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674505023;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V3+junlULVMF75LbBg2MY53y+N+veB8zNDWGNo4VFkw=;
	b=Mzeb0PXXcm7tfB+rsakGMsNtj3UiLTlaNg7pisjrEMQaB1WCssN1bw3MFs67nroQHky9UP
	IVaV8Ei1elyZUw8IkTyTGW5ooC5KgBOLOHIJkJgwRd1SGITdNsH3tTrb65ES19eo6dy7nX
	sz32Z7tF/lvXGKjjiybWlNoK5ia0OlE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-adRldDdsNL6YJZCu1e6P0A-1; Mon, 23 Jan 2023 15:16:54 -0500
X-MC-Unique: adRldDdsNL6YJZCu1e6P0A-1
Received: by mail-qk1-f200.google.com with SMTP id q21-20020a05620a0d9500b0070572ccdbf9so9603735qkl.10
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 12:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3+junlULVMF75LbBg2MY53y+N+veB8zNDWGNo4VFkw=;
        b=cLs+ZxJi9/lQ1KVYwdOvyI/cAo2uY5cxxsxUzR1IHbQBZHfQCstb7ali5XC2AiVNsJ
         SUpBbS/BVGiX+kKpyMUxnYThB9/ZPTGxmUoIJcHVm1btT4/Tnm6uCdytHhYIfN98DTGo
         yyNT/XSnWWzIyTdxrdfX4876wbZ64TXzUrLx0YWA6eSyyinqzckuzfs6JRN05iaOyUju
         1zX8RUR/05cvgx/ZLAJH6/F77u3A8xGxVPneCdWYWdjnRVa1QZV7y/8ReQC+kqOE8NPe
         m2BCXyQ3doZzZR0laSlmvhhF+fu/fTys5TyTZWc0TNMDm/wrbd7kmYhj8U1zMrSrhxFN
         np0w==
X-Gm-Message-State: AFqh2kq6sMoiFkYJkaJU3nKsYyAGKcG1XBowlTqFbC/Mz9+leLyuh3gQ
	37Qfw4Nx+HDoIXOwyKfKH5iQBoh9cqhJb0vPWTnFOJ56F6/AhhsO640WfGi3nRg79ZfUfm4vt9M
	SYD1PWg8mOGnAJco0
X-Received: by 2002:a05:622a:4209:b0:3b5:4aae:cb0b with SMTP id cp9-20020a05622a420900b003b54aaecb0bmr35735724qtb.22.1674505014033;
        Mon, 23 Jan 2023 12:16:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtZemXz++AKrwgeusa+BGaOwsCkHjVNtIxK/mnyMB/tGaIQ2uX5/GraXmIFnA5tIAnit1XFqQ==
X-Received: by 2002:a05:622a:4209:b0:3b5:4aae:cb0b with SMTP id cp9-20020a05622a420900b003b54aaecb0bmr35735700qtb.22.1674505013726;
        Mon, 23 Jan 2023 12:16:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h3-20020ac87143000000b003a6a19ee4f0sm9192819qtp.33.2023.01.23.12.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:16:53 -0800 (PST)
Message-ID: <13f3ef62-a399-eb04-2389-f25881d3eb1a@redhat.com>
Date: Mon, 23 Jan 2023 21:16:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-2-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230109211754.67144-2-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 1/9/23 22:17, Ricardo Koller wrote:
> PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> for overflowing at 32 or 64-bits. The consequence is that tests that check
> the counter values after overflowing should not assume that values will be
> wrapped around 32-bits: they overflow into the other half of the 64-bit
> counters on PMUv3p5.
>
> Fix tests by correctly checking overflowing-counters against the expected
> 64-bit value.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/pmu.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cd47b14..7f0794d 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -54,10 +54,10 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET			0xFFFFFFFF
> -#define ALL_CLEAR		0x0
> -#define PRE_OVERFLOW		0xFFFFFFF0
> -#define PRE_OVERFLOW2		0xFFFFFFDC
> +#define ALL_SET			0x00000000FFFFFFFFULL
> +#define ALL_CLEAR		0x0000000000000000ULL
> +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
>  #define PMU_PPI			23
>  
> @@ -419,6 +419,22 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
>  	return true;
>  }
>  
> +static uint64_t pmevcntr_mask(void)
> +{
> +	/*
> +	 * Bits [63:0] are always incremented for 64-bit counters,
> +	 * even if the PMU is configured to generate an overflow at
> +	 * bits [31:0]
> +	 *
> +	 * For more details see the AArch64.IncrementEventCounter()
> +	 * pseudo-code in the ARM ARM DDI 0487I.a, section J1.1.1.
> +	 */
> +	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
> +		return ~0;
> +
> +	return (uint32_t)~0;
> +}
> +
>  static void test_basic_event_count(void)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> @@ -538,6 +554,7 @@ static void test_mem_access(void)
>  static void test_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> +	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -572,9 +589,8 @@ static void test_sw_incr(void)
>  		write_sysreg(0x3, pmswinc_el0);
>  
>  	isb();
> -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> -	report(read_regn_el0(pmevcntr, 1)  == 100,
> -		"counter #0 after + 100 SW_INCR");
> +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
>  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -625,6 +641,8 @@ static void test_chained_counters(void)
>  static void test_chained_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
> +	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -666,9 +684,9 @@ static void test_chained_sw_incr(void)
>  
>  	isb();
>  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> -		(read_regn_el0(pmevcntr, 1) == 0) &&
> -		(read_regn_el0(pmevcntr, 0) == 84),
> -		"expected overflows and values after 100 SW_INCR/CHAIN");
> +	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
> +	       (read_regn_el0(pmevcntr, 1) == cntr1),
> +	       "expected overflows and values after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }


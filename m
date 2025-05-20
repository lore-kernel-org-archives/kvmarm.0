Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048A24169D
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747747468; cv=none; b=QD/KLfOJp5LGh3el6H75xfoaJSKjUwGC9FbBzSwW9rTrQsS1xfxo0wcc5dbzhtHvjbZSDKRK35c+QOmFV+SWJMvjn95mm1OZgUoO7ThNBh/h88i//5rfjeiMuy66Oa3LmOOSVcwmvAFXdrbL/SBWus4r5MNyspyhZ73cISaaAFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747747468; c=relaxed/simple;
	bh=EO7Bz8Z7ZpsEWzXQ/VGnf3r1ktTQqaVjzcs3ERWBOgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYs1qorE/7OIcXNQOIdb7LGlu6s1vhb5gYrGcFfxwh2uA3AHbe/Zfvgl9HME0bF+hML9yJM+DCZMYMgkDHoKnzXbrta/mrfOGsTgVhqkDMmipVyLKIf3MXevhc7hA5BDNUeGOyO5RHuoJPnoMgG5QPu2Zwm/OKJJWn0mEmCpjtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Crs+0BAy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Crs+0BAy"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43edb40f357so46591455e9.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 06:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747747465; x=1748352265; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mQHlbMiBxLSmXP52BL1UDUEb0aWb4op30nkibuEcEDI=;
        b=Crs+0BAyAbTA7dHTeZ7yoxUYNWxnjcRHtyQT+X41aNVwmzHa6jRmAEI9/08XVHAU49
         NXlE+jYPTVpde1CDGkyrqJLsO0OOT/vZ36k+Hv6B2Sy5i9D9+nGE1wL/fOzRF+lP7mqO
         KiucMDn3Km8nOjs18bXDUvaTWvoJndZgRyY07H7j560NLQzd5CYjeeQSlCHd53ZSlkla
         9Vz+phgi4MiMEjxr0idNRuFU7ZkZ/1dyGfENImnzVKxLLXl9crcrLbSGUb7FbYt8h8AT
         PSEIP4WCA85Yh103/Pkj0XIFaukty3BF6ODhriP/tv50PosRziEhp/g49O+/hDgiX5M6
         qDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747747465; x=1748352265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQHlbMiBxLSmXP52BL1UDUEb0aWb4op30nkibuEcEDI=;
        b=aE6qwnHSad4Hr95KbWUtY1GtNZcObvHanSS/0aNpQp7g2PGkJ+LpWcPqK5gPYRgm+d
         qFlDEGVa6mpt8Z1pz8G7SiMqO6Qf7XclHv2Krkw8QghpYFDrhocael83mI5FdVfUV/0K
         +1wXzOhNeazgddkr3fbyccSck5UmMYMnXllh3drDFyeVrL4oRU5KS13VLs6J+os/3UE2
         6mGwZpPvqZYOZaLpm0uUrk175edvoEmzKIUgT5lS0/fYFUX9ymeNQBKEAttuzxGxxH5L
         Z8YUULFAwhIljBCymOewkxgRbIJlQQrA7JNTYZyl8hNJhte93cIbHwFgDnz/BWQzOBHZ
         FvYw==
X-Forwarded-Encrypted: i=1; AJvYcCXweKYq/1+NgJ10tSJ6o57LUekh4vigtK0YLL6p1M2EsjQE/ml9qQ2VLl8A3cLvt4e3uLJ5QCI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx79uIpGRhIKT2L/bIV9LpJPgCb3zQXiV2S2uG/BlMG2juM7Fm3
	3UEVVcmZOjd0qDkxLvpSecZAHqsgN9SupouO3CxS7o6NWj9xAvmlFa2/Hy5MlnyJ+Xk=
X-Gm-Gg: ASbGnctHE/9FicARGU/tFtAz1uJkNqYMXGpQT2+mKeMw/UHtIWd7kHygdtS03PvtNa/
	IKiw+2s4tVnTZQyFFDBvumUM5RGUb/WQSbAb7qrnEAdVNyI0lf5BNe4xyEajZPmbf6qCct2e23Q
	TJOmXJq+Hl9Gq5iqD2P02uNr3GWKWRPCTGu9DcWftDV5F/AmY99p1B4Q51G40mipw9fFR3CtXFj
	i7lsD58mSKaeT60GWHO6tACOkbYIyciKML2l98xdjxbzqiMDIJICMohj16gnC8ywzUcl2mFt4Q9
	jNZhcR6ikHuBJMIksEuLh6MuYVDxCp7vjGXl3hTEntDiLBjMm/IS8eTI
X-Google-Smtp-Source: AGHT+IE3zELuhSN3TwYO27umiBhhWtesQN6BNGvzjaw7PU+Jb1bNssmWf19VcuZ1nvC7Yd9VZCvZug==
X-Received: by 2002:a05:600c:4f42:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-442fd60cb7bmr151310375e9.5.1747747464942;
        Tue, 20 May 2025 06:24:24 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca88735sm16788347f8f.69.2025.05.20.06.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 06:24:24 -0700 (PDT)
Message-ID: <25d64842-79c7-4d70-a5d7-08cd60208681@linaro.org>
Date: Tue, 20 May 2025 14:24:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] perf: arm_spe: Add support for filtering on data
 source
To: Leo Yan <leo.yan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-7-dd480e8e4851@linaro.org>
 <20250520114309.GO412060@e132581.arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250520114309.GO412060@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/05/2025 12:43 pm, Leo Yan wrote:
> On Tue, May 06, 2025 at 12:41:39PM +0100, James Clark wrote:
>> SPE_FEAT_FDS adds the ability to filter on the data source of packets.
>> Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
>> when any of the filter bits are set.
>>
>> Each bit maps to data sources 0-63 described by bits[0:5] in the data
>> source packet (although the full range of data source is 16 bits so
>> higher value data sources can't be filtered on). The filter is an OR of
>> all the bits, so for example setting bits 0 and 3 filters packets from
>> data sources 0 OR 3.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   drivers/perf/arm_spe_pmu.c | 31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
>> index 9309b846f642..d04318411f77 100644
>> --- a/drivers/perf/arm_spe_pmu.c
>> +++ b/drivers/perf/arm_spe_pmu.c
>> @@ -87,6 +87,7 @@ struct arm_spe_pmu {
>>   #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
>>   #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
>>   #define SPE_PMU_FEAT_EFT			(1UL << 8)
>> +#define SPE_PMU_FEAT_FDS			(1UL << 9)
>>   #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
>>   	u64					features;
>>   
>> @@ -232,6 +233,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
>>   #define ATTR_CFG_FLD_inv_event_filter_LO	0
>>   #define ATTR_CFG_FLD_inv_event_filter_HI	63
>>   
>> +#define ATTR_CFG_FLD_data_src_filter_CFG	config4	/* PMSDSFR_EL1 */
>> +#define ATTR_CFG_FLD_data_src_filter_LO	0
>> +#define ATTR_CFG_FLD_data_src_filter_HI	63
>> +
>>   GEN_PMU_FORMAT_ATTR(ts_enable);
>>   GEN_PMU_FORMAT_ATTR(pa_enable);
>>   GEN_PMU_FORMAT_ATTR(pct_enable);
>> @@ -248,6 +253,7 @@ GEN_PMU_FORMAT_ATTR(float_filter);
>>   GEN_PMU_FORMAT_ATTR(float_filter_mask);
>>   GEN_PMU_FORMAT_ATTR(event_filter);
>>   GEN_PMU_FORMAT_ATTR(inv_event_filter);
>> +GEN_PMU_FORMAT_ATTR(data_src_filter);
>>   GEN_PMU_FORMAT_ATTR(min_latency);
>>   GEN_PMU_FORMAT_ATTR(discard);
>>   
>> @@ -268,6 +274,7 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
>>   	&format_attr_float_filter_mask.attr,
>>   	&format_attr_event_filter.attr,
>>   	&format_attr_inv_event_filter.attr,
>> +	&format_attr_data_src_filter.attr,
>>   	&format_attr_min_latency.attr,
>>   	&format_attr_discard.attr,
>>   	NULL,
>> @@ -286,6 +293,9 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
>>   	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
>>   		return 0;
>>   
>> +	if (attr == &format_attr_data_src_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_FDS))
>> +		return 0;
>> +
>>   	if ((attr == &format_attr_branch_filter_mask.attr ||
>>   	     attr == &format_attr_load_filter_mask.attr ||
>>   	     attr == &format_attr_store_filter_mask.attr ||
>> @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
>>   	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
>>   		reg |= PMSFCR_EL1_FnE;
>>   
>> +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
>> +		reg |= PMSFCR_EL1_FDS;
>> +
>>   	if (ATTR_CFG_GET_FLD(attr, min_latency))
>>   		reg |= PMSFCR_EL1_FL;
>>   
>> @@ -430,6 +443,12 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
>>   	return FIELD_PREP(PMSLATFR_EL1_MINLAT, ATTR_CFG_GET_FLD(attr, min_latency));
>>   }
>>   
>> +static u64 arm_spe_event_to_pmsdsfr(struct perf_event *event)
>> +{
>> +	struct perf_event_attr *attr = &event->attr;
>> +	return ATTR_CFG_GET_FLD(attr, data_src_filter);
>> +}
> 
> Seems to me, arm_spe_event_to_pmsdsfr() is not needed as it does not do
> any conversion from event config to register value.  So simply read the
> field value in opened code would be fine.
> 
> I am fine to keep it and would leave SPE driver maintainers to decide
> which is preferring.  Otherwise, LGTM:
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> 

It's purely for consistency with the existing code. See 
arm_spe_event_to_pmsevfr() etc.

>> +
>>   static void arm_spe_pmu_pad_buf(struct perf_output_handle *handle, int len)
>>   {
>>   	struct arm_spe_pmu_buf *buf = perf_get_aux(handle);
>> @@ -788,6 +807,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
>>   	if (arm_spe_event_to_pmsnevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
>>   		return -EOPNOTSUPP;
>>   
>> +	if (arm_spe_event_to_pmsdsfr(event) &&
>> +	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
>> +		return -EOPNOTSUPP;
>> +
>>   	if (attr->exclude_idle)
>>   		return -EOPNOTSUPP;
>>   
>> @@ -857,6 +880,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
>>   		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
>>   	}
>>   
>> +	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
>> +		reg = arm_spe_event_to_pmsdsfr(event);
>> +		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
>> +	}
>> +
>>   	reg = arm_spe_event_to_pmslatfr(event);
>>   	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
>>   
>> @@ -1116,6 +1144,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
>>   	if (FIELD_GET(PMSIDR_EL1_EFT, reg))
>>   		spe_pmu->features |= SPE_PMU_FEAT_EFT;
>>   
>> +	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
>> +		spe_pmu->features |= SPE_PMU_FEAT_FDS;
>> +
>>   	/* This field has a spaced out encoding, so just use a look-up */
>>   	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
>>   	switch (fld) {
>>
>> -- 
>> 2.34.1
>>
> 


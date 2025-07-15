Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00FB1991D2
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 13:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584664; cv=none; b=nbsa6DZOT0Ux3vfKQ62HDqzCy5VqMnHRJMYQbErbpYjGBFAGhgsLVnNM+t83PhcPkZhTOOasrEMWNmTpkQob5C+06QR02u0156WAEvdVQsi6HR58EuBKEArw/fl92wPBhJB5Mq0dRpsvqlMT9ALJclqzvNsqf6aq8kO0pxrR4Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584664; c=relaxed/simple;
	bh=8de/+OVEmpgQ2MrKae7+4kNVlqKqrSROqzrJtp3x0GM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BACQm1DbCEle7ifnLmbqt++8rgVOOkpdUZejP6d3zv90fjETeFRM2Oc29C3eV+Hg7ahftP5MyTPvjA/1+a8ycysaxz/h1XyMx+bqFqMTA4JHDDp352aQzpp22Gc9MNRcBRGkEU3A/1x5HGwhuuOzT/RlRYpt0zm8dRkres57KP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MHZweLrp; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MHZweLrp"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-456108bf94bso17616995e9.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 06:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752584660; x=1753189460; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J89r7AvqyeIbrcgrXdArOfzh5yo/o2jaOib37mZOYIs=;
        b=MHZweLrpmslgzEUFXl4AmmtXAp2mQfgQfsxppX6IiseWeU1gOVZav4sQ8hZ+8zlBmt
         FOd0qgnFdneFzEbaWygmYxOZRs9fLFsRlYrCeHdWiaXKgiKluL+PL2I1qXRjv4FVsrfN
         xRFwXdS33G/E6crUAkAxpOz9/L8/pF475uceN7Cd/NwRNfGuloAbAHCAstKHF3au5nmf
         Q/sBw4IescVPJIKDfh5kgstFCXSSEtGY35UJrrhJTvKn1mHy+TV8QNQCUStqJ7d79XKb
         CPmxlSHXPVUz4GlLvqMaihm6OfTDuVEQwn1fu+xyMtVCIFZbg2PRI7ve1FSLkbMUt1gI
         075A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752584660; x=1753189460;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J89r7AvqyeIbrcgrXdArOfzh5yo/o2jaOib37mZOYIs=;
        b=pmSrc0je1Hiki2yxBqdTB0JsDA+aEwRcA7Ql7IGp8hCj7FK5WhUuWZhOyXQiEhEXqr
         X5qrw2PQEVjBdtdHElmRzcgZBWHTf4SIxFcDFc9+PvSB4jduXkDN0oHek2ZGIKohWByx
         WBumAFRUlhq+IsJADUx4T41vKf4AJJGrnbrw9E4//VdZu2YW/xbsTX+YxEcWD9idiC8j
         o7vyMUwniroOU4s0fbr6r43fjrXYr9BKPlNqnvTO2pIBpdEkcFp3Zy8b8q3cUl4uAL61
         s9hiOGioLv3IqVNbi9n759MEXXBoK8JFg0lFzCupSfybtnSplmUKIo/ZfvZTsTNEFOrf
         5sPw==
X-Forwarded-Encrypted: i=1; AJvYcCUqTnQwozs07SCVRnFhPQd56GEVBRqglMv2sYb05u7BMRcHqXboJNFCvjhXrhfK6RkQgyWJooI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFOI55ELX5+rwn41dUOM1Gb2vMYXYJkaPuv8YJuba83YKzKkxO
	6WJIYm/VOGLE1ZylHU8Acd2rw0LCohl6DTts9G0zLrkX7SfnAhv39SuRAjnVtDYsrgk=
X-Gm-Gg: ASbGncvlsXC8dr8V3YUsvblc2OpOHbJ4s5R+BBsPKqELA9qAq33gHMUbVG5lBtuHTBk
	jAMsswnwHXlWWPvwMM15xpkaekbCNByi3uuPS9JpXeZgxlnxTNVXvJg/0ou+C4WPEHg0B6cuzsf
	8gmb2YAs1xawvGJ/8o0aiNwQPf9RtAB1alLRMxgK8xgWByb2fCUZzVDph60xrwkqzh/o69P6roQ
	CIIsM9SycrKkZmKrZY0Z+SxTVmjMNARKB3ivbBjDWa+lixwL7BuOxhWaoE3Zxs/Gpbfde+22K1D
	RBApDIwvK0ivqFp8oH1iB67wnvB0beQ8149y+DDWbRFM5FUMjDPE7hKc3lTnfSNLw+/Jpnoj8PF
	LOz++BBC+FdaGSTgl/57LHzVR5eM=
X-Google-Smtp-Source: AGHT+IFtWJR4N1CKamdsyz9XjtkQHpkuQDX/87ZZ/cBBW4+sRrWYHFWFc00klxjEz4K5K+dv4kcPxw==
X-Received: by 2002:a05:6000:4612:b0:3a3:7ba5:960e with SMTP id ffacd0b85a97d-3b5f2e3e99dmr11999857f8f.59.1752584659975;
        Tue, 15 Jul 2025 06:04:19 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e332sm15169687f8f.79.2025.07.15.06.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:04:19 -0700 (PDT)
Message-ID: <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>
Date: Tue, 15 Jul 2025 14:04:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] perf: arm_spe: Add support for filtering on data
 source
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-7-71b0c9f98093@linaro.org>
 <aHUOig-kaRo15ZH5@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHUOig-kaRo15ZH5@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/07/2025 3:04 pm, Will Deacon wrote:
> On Thu, Jun 05, 2025 at 11:49:05AM +0100, James Clark wrote:
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
>> Reviewed-by: Leo Yan <leo.yan@arm.com>
>> Tested-by: Leo Yan <leo.yan@arm.com>
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
> 
> Is the polarity correct here? The description of PMSDSFR_EL1.S<m> suggests
> that setting bits to 1 _excludes_ the FDS filtering.
> 

Setting filter bits to 1 means that samples matching are included. 
Setting bits to 0 means that they are excluded. And PMSFCR_EL1.FDS 
enables filtering as a whole, so if the user sets any filter bit to 1 we 
want to enable filtering:

   PMSDSFR_EL1.S<m>

   0b0  If PMSFCR_EL1.FDS is 1, do not record load operations that have
        bits [5:0] of the Data Source packet set to <m>.

   0b1  Load operations with Data Source <m> are unaffected by
        PMSFCR_EL1.FDS.

I think it's all the right way around and it ends up being the same as 
the other filters in SPE. Because we're using any bit being set to 
enable the filtering, the only thing you can't do is enable filtering 
with a 0 filter, but I didn't think that was useful. See the previous 
discussion on this here: 
https://lore.kernel.org/all/5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org/

Reading the "Data source filtering" section in the docs change at the 
end might help too.

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
> 
> Same question here.
> 
> Will




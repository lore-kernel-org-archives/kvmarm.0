Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549591D5CC9
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765399; cv=none; b=cRZtidVjPdrWfqIy/ZsQbLZWa8TW9sDm4pmViorkl1vCHeYyzG2m+elXaFTOmwilmLPJM10d1UPfweo7yycAmLEg+cmiYJ7gkxdGy5svfVQIdzEzeAvi64SwxK5gw9Izl9ZtfZ98nsqE+gdxzFYBUW+BMfqG0wxSGnG9GTkdKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765399; c=relaxed/simple;
	bh=42i7QgR3Vm1XbHENgDUnhNUH1shHeEplaZfgHdiTnfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShPtMHjb16HVrKwLUw+aIlBmozhlUJyuaUgnnGiepL5behCzkca57iJwlV3QoqxY48Wc3WXu53qoJXmK93gKTJW9ulIgsKZAAui7/Cnqk2sEJGCkwwoSZWyH52344+rS4UFt5LymMuzTyAoEngqFNtbGZ4Vh22RpZHS7pWG3AjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ho8JjUzK; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ho8JjUzK"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4f379662cso817581f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 08:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752765394; x=1753370194; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9o9XStLuurpqMGv7dh7QCRhtG3mn+IMSEac9X1lSv4g=;
        b=ho8JjUzKcHmJm9OiKfqfl0bQqgd7bEpuOFjA6lH+XnFvlmvbgpKluJK/i4WvZgR7cG
         YC1ARgeJOlGV+Xo6O5BHTJdJdB171g5mCmU2XPiSkl6PBzqY9MMqcw9M8sTkqsfPMDMw
         BDmX8/8WKPBKZbxNoUoT08lEPLKPUMTmsvdxeYyCAxw44YOJ/9ym8/w7/BGJDPNyjd8d
         hm+QDcUgtrwFA3ngvXq7tciKAqyvhMOcNelG0WmNF5S10Tj6Gtlog+gu95I6aLdBar8b
         reXrYcf4bYW9bfSVtH7MzJFfk08BG91qtSEZI9daAYCaQgZgPsBVUmQFw5qWnXBiL/jL
         eatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765395; x=1753370195;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9o9XStLuurpqMGv7dh7QCRhtG3mn+IMSEac9X1lSv4g=;
        b=JRI4TS+pPO//iTTeyR9di1TY61MEdd+dO9/mJWPRBrmOUHH5ycTuPT4yvD/YuKuJdJ
         NHdO/xlulEopYbDyRZE7yhRwlVy2BuIvD6ekWB4wLpkZIFnOcMaDDmtZ09KpA4g1TbA4
         curCxCbaM2zbbeF/E/cfs2Df6xoOHRabTbbmd+WfSQJ087feO2qCd9m5208bNxPOqOBZ
         j4hcVVoIK9bNOOoNkcL+HX0oV0rrGqg4oX36YS+3WgjEJ+ASWHhsTTMaEiYJyuc/qXkQ
         ppH97P1Ks+MEbwBWUAULeCosuDHB1NaRvvYcfult1+0/xd79bWGBDuD3kK52AmiWay2u
         PEqA==
X-Forwarded-Encrypted: i=1; AJvYcCWolhFMtKeg79cYEaOn/1Ehvo6pGWO6XvEPC7mPXfe6m6PtCN8/QXzUJye3YD0Gg6+VnKpyntI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0KRTKXLQPj6+qrfxF+gdsPZWrngHdlz/Hvt0otQlhdHAkk8aO
	kHWs1vH+QCWHA3U+cv7afQhNWyvKcht5RWkmOg3UoPXBdaytGXaoK5F8f59geUPTcx0=
X-Gm-Gg: ASbGncs0SVAA/VOP+vmli6ElIgi/1BYOx/sR8x5YMGdGD4D5qi6JVdysV0eA8+Ky7GQ
	8t17TAKqTiovvyMmaaSk16C7HV1o24r5uRQc1yQnAGMAk4jVY7kl917QrNS3xhJi+y/M3HcoARK
	XDmtewuC5scRrvG2uy2bmPWU/8BdMafRTQiJqqqkH9DUtY1TN1lh2JgZ1l2/gfeqB1bG2HvtlBE
	ujgqCmw6lofbnwDv0ymiLyMj06FYeVcDUYJo4HAy56lAulPeIWUPV46KSQseDOb9/YcgrPGLHLV
	jowH59u1k95dWPOiRPJ+vRnk6j57JCNsJrYPfWkOEHIMtyDm/y6LTuJLqsfiJeu4GoJkp6jaDzl
	Iz2SFEWvSw4t3I0U41T05ytge1pI=
X-Google-Smtp-Source: AGHT+IEOgsXesc4WriF6B4s4UdXOC/523vChLTF14vUDuJL5EdaGCxaHdXKmwN46VtYnX5eN75Kjsw==
X-Received: by 2002:a05:6000:40d9:b0:3b4:4876:9088 with SMTP id ffacd0b85a97d-3b60e510003mr5758377f8f.46.1752765394479;
        Thu, 17 Jul 2025 08:16:34 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5f32ed100sm18096525f8f.0.2025.07.17.08.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 08:16:33 -0700 (PDT)
Message-ID: <ca99af3b-e358-4c2b-8d62-0b6c29984391@linaro.org>
Date: Thu, 17 Jul 2025 16:16:32 +0100
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
 <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>
 <aHkI5_IOV35L4YJa@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHkI5_IOV35L4YJa@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 17/07/2025 3:29 pm, Will Deacon wrote:
> On Tue, Jul 15, 2025 at 02:04:18PM +0100, James Clark wrote:
>> On 14/07/2025 3:04 pm, Will Deacon wrote:
>>> On Thu, Jun 05, 2025 at 11:49:05AM +0100, James Clark wrote:
>>>> @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
>>>>    	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
>>>>    		reg |= PMSFCR_EL1_FnE;
>>>> +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
>>>> +		reg |= PMSFCR_EL1_FDS;
>>>
>>> Is the polarity correct here? The description of PMSDSFR_EL1.S<m> suggests
>>> that setting bits to 1 _excludes_ the FDS filtering.
>>>
>>
>> Setting filter bits to 1 means that samples matching are included. Setting
>> bits to 0 means that they are excluded. And PMSFCR_EL1.FDS enables filtering
>> as a whole, so if the user sets any filter bit to 1 we want to enable
>> filtering:
>>
>>    PMSDSFR_EL1.S<m>
>>
>>    0b0  If PMSFCR_EL1.FDS is 1, do not record load operations that have
>>         bits [5:0] of the Data Source packet set to <m>.
>>
>>    0b1  Load operations with Data Source <m> are unaffected by
>>         PMSFCR_EL1.FDS.
>>
>> I think it's all the right way around and it ends up being the same as the
>> other filters in SPE. Because we're using any bit being set to enable the
>> filtering, the only thing you can't do is enable filtering with a 0 filter,
>> but I didn't think that was useful. See the previous discussion on this
>> here:
>> https://lore.kernel.org/all/5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org/
>>
>> Reading the "Data source filtering" section in the docs change at the end
>> might help too.
> 
> Sorry, but I still don't get it :/
> 
> afaict, if any of the bits in 'data_src_filter' are _zero_ then we
> should set PMSFCR_EL1.FDS. That also means that a mask of zero means all
> loads are filtered, which is what the architecture says and is what we
> should provide to userspace.
> 
> Will

We'd have to add another format flag to enable data source filtering 
then, because otherwise the default would be zero and people's samples 
would disappear.

But the only use cases I could think of were more like "I want to see 
samples from data source 1":

   -e arm_spe/data_src_filter=0x1/

Or "I want to see all data sources except 1":

   -e arm_spe/data_src_filter=0xfffffffe/

Filtering out all samples with any data source didn't seem to make sense 
to me, and I think you can already do that with the other filters 
(remove loads etc).

It would be a shame to be inconsistent and to add an enable flag just 
for that one case because the other filters in SPE are auto enabled for 
non-zero values. Although to be fair for PMSFCR.FT and others, zero 
filters are explicitly not allowed:

   If this field is set to 1 and the PMSFCR_EL1.{ST, LD, B} bits are all
   set to zero, it is CONSTRAINED UNPREDICTABLE whether no samples are
   recorded or the PE behaves as if PMSFCR_EL1.FT is set to 0

Seems like FDS doesn't end up as neat as the others, but IMO I can't see 
anyone needing a zero filter. I did discuss it with Leo and we decided 
that we could always add the enable flag at a later date if a use case 
turned up and it wouldn't be a breaking change.

But if you think it's there so it should be exposed I can add it.

James


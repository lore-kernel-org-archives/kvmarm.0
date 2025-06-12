Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE157221DB1
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717766; cv=none; b=dLm2RbIwH9Zq+8wcjBgCx58VGb1iXeT9Z4iyHpk7bO5phcrXINDxCiedESgOrPRRA7/5k1VYlOOV8g2JCcupFVfsc0uiiiOJAi4OfpEJlEcyVLl7HARTfC6ZDq9izFIHSCO7et0DZ9aNh896PZ2EEz3/l+o08k/tJxY2GGsXjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717766; c=relaxed/simple;
	bh=w6yjx7Dori93CG6sK3ncvH9uiqhy4vTnBe+XPdGSOr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3GR4tpSTGL0F/I6KO9I/q8QUM6Z/jg0g+Oso4l3IerflhEGtIDb9MbQDxOMQ7FCapKU3jLyxFoplCkC6k2HYXmiolKe1yiDGLiBLEQmQDUTFVqg+fuOddAe1ctK6eEDfyWwY1H/Hxkljw9ER7DPSjLnu8idoTc5ZcLSSn4Kcno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kEyTW+3B; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kEyTW+3B"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so626344f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 01:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749717761; x=1750322561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MXXMkVVqt6xR4uvFmH/ZMvt5aZcIpXe/yS2Xx6mdmS8=;
        b=kEyTW+3B9DnJd1mva1FJh23SMKFDEGZFcQwiasGlO+izyzBpFxRwoJhQ5x3YK5CkWx
         MienEhIbkA/NzYqe3xRI4ui2ZLSmu3bAR5kAQR6iGFyDVAz4+4bKexQlbu3qPZkP4Fg3
         JM/QN0QyLJEBz+sdfxYHZxk8eV64XIMoO1JCw9qI/OC5uiBKYlUDC7gG/uA6WC5z5BXt
         7sa2/QE35fQRVBb05SpatLtsfAmHyRgREA3JLQ7BDpsTKhKkAFiKhcbp8eT4K3A5We9C
         VHU6rKBAIwoXkCYxaLwZYSUbd13RcNtsPctUEdzVZVlvm++v8Yu8CMB7V3cKBNHKhkHZ
         gJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749717761; x=1750322561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MXXMkVVqt6xR4uvFmH/ZMvt5aZcIpXe/yS2Xx6mdmS8=;
        b=M7sVB1NXVBD/G2gX0viwJa6f9+pq4GZV2oKWakyGxFEpJo0BpLJvP47spojyH29qW4
         ID7fZZsWjMFPX+7TZYBNFOCbNah6LVSnxB2Wt3wGd5SHMWyiiXq5uBCuJCBQCLvcmLI6
         tPmzBGMTLfSNbFBjO15i5kNGLhGmYhFH+8Z+xomlmqH+9mTl0A8NdecrCayAMrXmK6DX
         TUTJ1jp/Z8o4OW3IUOoDe5H7H3kEfAa+gWsbejr25WBWsiTMKp6PMbZ/aQnn9uFUcT0O
         0sf08du4MzdLKXfJRkr7R3ogd/0ST+qAlUkSoHZKM+5BMwqt/DwpgU1ELkUdvxozoNOu
         8iew==
X-Forwarded-Encrypted: i=1; AJvYcCWIQkEoquLwoSIA+tEUMz15z2p81v3LyVWTnO9U7RNTCMsJiSJVnEZqIjygdzOIkgDPD+m9DQc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeQlxXe5UT00n3BCZBccaNOQAaSZxuT/VkN3wFJhtd7XzF6voX
	5b8DJTZc6rPIcv/TGYkphbZOcrwqaJnbeHrH4L1gHg0FD5JNjmAWn6Ie3L8kd9EiMVE=
X-Gm-Gg: ASbGncsOCZflMQLJeNO4oZKUrS4O2IgvBuuB8RZs3j7Btbj55kDdGspbGoZOMq5iiic
	aMdQ3HrwlK+0DJpTe3Q4LeLdywcFJR0HuEm0JGyaoDN3bfGHB9BgGBkvYD7+bXjrAQWB/dT0W27
	79HPL2WywUTDp2Zv6uTXpT/IFFJ7I4msqFuAMH8d0tTgy1l3UQc2LnQiGG5TN1tgOyq36JCE6A8
	zryttXkW1PDP1tE75+z9nSSp8XNDKxtCvqxgaSqAXYME38D7UaJTpIoQiuqvLDAlmRaZM6wpKII
	Mnxn1+Kj8ou9sJb+tiS6LiYXAZtmXjWKRjLaSIchjfCmosgTWg/yPtvjHDb7Lm8Y1MY=
X-Google-Smtp-Source: AGHT+IHRFPEqNYv7rElVTsM+/O2Bep9AczSNG7lUyxK1KtND+mFBsYtU9egUwJboJsW4Mk1sSOYf4w==
X-Received: by 2002:a05:6000:2411:b0:3a5:2fb2:35ac with SMTP id ffacd0b85a97d-3a5612946a2mr1683069f8f.24.1749717761081;
        Thu, 12 Jun 2025 01:42:41 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a5619ab86dsm1296971f8f.44.2025.06.12.01.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 01:42:40 -0700 (PDT)
Message-ID: <7b080e97-375d-4521-b167-d0c4256dc464@linaro.org>
Date: Thu, 12 Jun 2025 09:42:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
 <10f63976-afa7-4e1c-bec1-d9f2447d9c13@arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <10f63976-afa7-4e1c-bec1-d9f2447d9c13@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/06/2025 8:35 am, Anshuman Khandual wrote:
> On 05/06/25 4:19 PM, James Clark wrote:
>> FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
>> remove them from the previous version's RES0 bits using
>> PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
>> unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
> 
> Just wondering - why cannot all the new applicable filter bits be added
> explicitly for PMSEVFR_EL1_RES0_V1P4 without using exclude and include
> intermediaries.
> 

They could but there would be a lot of duplication. Each version tended 
to add only a few bits to the previous version. Also for consistency, 
they were already defined in this way. I didn't think there was much to 
gain by redefining the whole bitset just for this one, it's probably 
going to look just as messy.

>> E.g:
>>
>>    E[30], bit [30]
>>    When FEAT_SPEv1p4 is _not_ implemented ...
>>
>> FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
>> switch.
> A small nit - should FEAT_SPE_V1P3 addition be done in a previous patch
> as it is an already existing thing ?
> 

It's related to this patch because I change the default case. Before 
V1P3 hits 'default:' and returns PMSEVFR_EL1_RES0_V1P2. But now the 
highest supported is PMSEVFR_EL1_RES0_V1P4 for the default case so I 
need to add a case for V1P3 to keep it returning PMSEVFR_EL1_RES0_V1P2 
filters. There's no bug.

>>
>> Reviewed-by: Leo Yan <leo.yan@arm.com>
>> Tested-by: Leo Yan <leo.yan@arm.com>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/include/asm/sysreg.h | 7 +++++++
>>   drivers/perf/arm_spe_pmu.c      | 5 ++++-
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index f1bb0d10c39a..880090df3efc 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -358,6 +358,13 @@
>>   	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
>>   #define PMSEVFR_EL1_RES0_V1P2	\
>>   	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
>> +#define PMSEVFR_EL1_RES0_V1P4_EXCL \
>> +	(BIT_ULL(2) | BIT_ULL(4) | GENMASK_ULL(10, 8) | GENMASK_ULL(23, 19))
>> +#define PMSEVFR_EL1_RES0_V1P4_INCL \
>> +	(GENMASK_ULL(31, 26))> +#define PMSEVFR_EL1_RES0_V1P4	\
>> +	(PMSEVFR_EL1_RES0_V1P4_INCL | \
>> +	(PMSEVFR_EL1_RES0_V1P2 & ~PMSEVFR_EL1_RES0_V1P4_EXCL))
>>   
>>   /* Buffer error reporting */
>>   #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
>> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
>> index 3efed8839a4e..d9f6d229dce8 100644
>> --- a/drivers/perf/arm_spe_pmu.c
>> +++ b/drivers/perf/arm_spe_pmu.c
>> @@ -701,9 +701,12 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
>>   	case ID_AA64DFR0_EL1_PMSVer_V1P1:
>>   		return PMSEVFR_EL1_RES0_V1P1;
>>   	case ID_AA64DFR0_EL1_PMSVer_V1P2:
>> +	case ID_AA64DFR0_EL1_PMSVer_V1P3:
>> +		return PMSEVFR_EL1_RES0_V1P2;
>> +	case ID_AA64DFR0_EL1_PMSVer_V1P4:
>>   	/* Return the highest version we support in default */
>>   	default:
>> -		return PMSEVFR_EL1_RES0_V1P2;
>> +		return PMSEVFR_EL1_RES0_V1P4;
>>   	}
>>   }
>>   
>>
> 
> 
> 
> 


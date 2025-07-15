Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ECC2D8DBC
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 11:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752578593; cv=none; b=U/X1qOpcthbI1bohoitsSUb3/71tb+63qCY6srWelq9TMAxCsyehoF6TbyxXTcPS3el1i0Nhq1S+AI+VrgU4ghq3MQ9Q8kj8V+1ajmlU6OeFmwYbOHFdcxHAYm2eeT5a87c5fOj9GnmlEEish8/VN+rluMBqfi5SiMiZHAO1obg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752578593; c=relaxed/simple;
	bh=mhNykQkifGSKuraYqLYMQoQw6/eZOe4Mg3CeEcJvqi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4zsmh8pByTk2lPrJl1TjE2u2+tAad9BYJs4i05ay5ZpcdTlseeukLo0cAxlpn74wZD9t/pd6cXlh5Pq+ia9VEV5V28PjaJkpBJ4mX+crLdR+ZkSkHw7kuBBisRFbodjdmXy0Yl3yEETfUALOTSaqrMQulIoeoQbyyy88phC9cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TdYiLbcv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TdYiLbcv"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso2467884f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 04:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752578590; x=1753183390; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UnLmuhlpJIPCopV7crhcFtkC5B2uM5pzLBY6qzCT9Rk=;
        b=TdYiLbcvD3wXWtaDFI3pps0RLkhBz6kK7hp7/h0E5nM1kCkSWB7F3LsOXinVPXBNUz
         hRC7VQTwvnJn4nUj+ZbAVfRP0PX1YlMMn4qnp6/T9YFqxIMd38/9PEeqoNdaEXWvSrLg
         unFzMJiXwc1xoFy0dYDq0Z6cSkn8mBAUfiomFbcHevMgNuxv3ESj+GRwLgjmbwnd0Qvi
         QdP8zmtKQOl5J/mVFww/GcHVHGOVlDvIl/CYrWSRQICUj9Kju7+hXgu6RD4DeaBS7VyG
         wHgBmtTdY7MY6ZJHU/ARgUq6RJq3Axt5xFnNq6SEuuyS+IH9xV6IrQV7WwEE74X7Y3EC
         VCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752578590; x=1753183390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnLmuhlpJIPCopV7crhcFtkC5B2uM5pzLBY6qzCT9Rk=;
        b=usv2T7E1UU169cQXcoPwoDYPjpKlSR3eukE9naXyZETGq4ggNemRTBWE9cLFdqMral
         cAm/wEZX76IoqtXrN2TH9KPcQoi3U08CSih/UniNrug84TIY7MbuwmUfrsidVLyePOMc
         jfQdPT5INQNuxVN1w6d2ODXe1fVWiebk7qXVe3aYIT/+A1tbqD6e1PtWI1i5DPzBc/4h
         kpo0h0/ZN8KYnEwlXRAFy/dbxUz4Ba6ACA8dxJA09RXBnIC2UB2TEER/C7+nx9Qor3wi
         bQkGrLUCLbSSSsBYUW0nZBjf8nSRwZwpVCeyb1CoBDL7U6a5LuFGUjrSKU3LXyYXs1SZ
         8SZA==
X-Forwarded-Encrypted: i=1; AJvYcCXOVHJEvvAEVD2WAs94LfteaIJ+U2cs7X/k33oGj+oibMY/z5tmJbhWhmRmNFkklQrDsM9Sfj4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmZDBMbW2NGpFr3LuIf4ekrCkSwoFWmfFqa0ckSC+6MvTc0DV3
	vYyKMFbvpCYHQrX4s3WueL+Y1ILFG4mR7NEwYLoGubtz39g09i/2CzcNBBn4ycjxwtw=
X-Gm-Gg: ASbGncsCuQvWBBQbCkNqfe8GaCUneCYcDdqV0hbwl5kUSDxYdJrwx0HJkJt2T5OZ/R/
	nrPeTjoqCnHelZ1tBkARLQiO4flN3ZeI8lfFW79N7yC9/n5AV/+/8fAMAyClqFyBllRF1MP00fm
	PJtJnCaOIos/FGxNG5v2d18MJO/kgnPsM1ztk3zt1e9Vx2NB2IRd1vUC9hw0MjeNUqRm7+iTXNd
	u0PvqSUxwTI9VaGS1D+m2DgsjqqbSTgiR2Wsk1ix0ufC2hBTyLE184wyD7wcRYbSiRKkQdVowvJ
	hXt2/31LB7rv8xdhy/hcgnXBIE0Q/RmPqUAitTfGGIrK8dM/qMe6+ObRieqf5AWA6tMmI7UCFKz
	ihYpebDbXHSKBnCa42qSjnKgfalw=
X-Google-Smtp-Source: AGHT+IFUgsfz7Ex07AYDtS4oV0I5U/VvNBB0yugLcGoxcyClcNuZz5Pm27qy30apXU2xqduwfNqc/Q==
X-Received: by 2002:adf:9dc4:0:b0:3a5:42:b17b with SMTP id ffacd0b85a97d-3b5f18b3d0emr10973282f8f.29.1752578590122;
        Tue, 15 Jul 2025 04:23:10 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4561752340esm68968605e9.38.2025.07.15.04.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 04:23:09 -0700 (PDT)
Message-ID: <3578865d-a2c2-4cb6-9271-abf880403097@linaro.org>
Date: Tue, 15 Jul 2025 12:23:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
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
 <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
 <aHUFj9lH5bZwa4Z2@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHUFj9lH5bZwa4Z2@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/07/2025 2:26 pm, Will Deacon wrote:
> On Thu, Jun 05, 2025 at 11:49:00AM +0100, James Clark wrote:
>> FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
>> remove them from the previous version's RES0 bits using
>> PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
>> unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
>> E.g:
>>
>>    E[30], bit [30]
>>    When FEAT_SPEv1p4 is _not_ implemented ...
>>
>> FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
>> switch.
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
>> +	(GENMASK_ULL(31, 26))
>> +#define PMSEVFR_EL1_RES0_V1P4	\
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
> 
> See my reply [1] to Leo about this function, but I think we should just
> remove it.
> 
> Will
> 
> [1] https://lore.kernel.org/all/20250707-arm_spe_support_hitm_overhead_v1_public-v3-0-33ea82da3280@arm.com/

We're only refusing filters that we know for sure are RES0. Unless 
there's a mistake, the ones that are maybes are still up to userspace to 
decide whether it wants to use them or not.

I think it could be quite useful for some automated tool to fall back to 
another behavior if it needs an event that isn't implemented.

If they were _all_ defined as maybes like "When FEAT_SPEv1p4 is 
implemented or filtering on event 2 is optionally supported" then I 
would agree it's not definite enough to bother restricting them. But a 
lot of them are known for sure like "When FEAT_SPEv1p4 is not 
implemented ...", so I don't see the harm in preventing use of those.

Or as I mentioned in the other thread if we think we can probe the valid 
filters that would be even better.

Thanks
James


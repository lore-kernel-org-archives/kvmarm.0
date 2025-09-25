Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7D265CC2
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758807396; cv=none; b=upGYUMzCwyWadiuOnLikHQsPKN494FrWr93Ll7fZPd9AUrZLONN4Aguu2QXeYOLCNkjO77OojUP2NUkH1NMxbeefEt/CSx411IdpGzcapFYQVFV/uE+Zd0vswNw37IV7Z7t9qEamjXu8G6+XtU9mkHGMHpvaLhL7Og8ugHgld/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758807396; c=relaxed/simple;
	bh=sSqjP4cvcawLrblfY9/wyy/hyoTTAKgpnyDa32+hyZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cIoVInrDG7tXFL4ZB1755hq854teXPqR6zGuhYaJqzBjanelHR8F/ZSUvo2GaLAoU+DSskngScJ0/RKduZfJwjzHb7bDBebpZbgUCKNVrCeszG2zgKkyGW7ATXVRsqDmcdBa5Od2Hm2FCl5gJJov+QPcS5pHpO1GiEBnOBVLNfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=akcE4PzR; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="akcE4PzR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso788922f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 06:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758807393; x=1759412193; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fx9sm2SG/XPK/zOHzWrJwHUPoT7scPpd+/H8+WI3Eu8=;
        b=akcE4PzRSgphY0EWJbuQUdgkKgpDcdNpEnzyRPW477QZiURLpNSgjrw0klPj0SipXQ
         DKYSdFNukIjOUOldIox7vP/Tlz1xmwqpeExzHKKpsVxiVO1ftP74ZzPWcbSaSMenoGah
         29umUoN5QfapcEmM4P+APAGCRZaQvSX+l7kLHinaqKSrzZa2nELzGOYn7W1QwNSeLify
         ywk4dRYPTWcOKUr7AzdmkGPCs3vqTItEZUKoVEGE+uV7R9MG5ijVU0jNmehzvj7tsC+j
         ZoqSU4whP2S5/poErfQhQ+O8G66xcKDqfP3XcAB4AqN1f4GRI0Arc8kO7oYAbjpT2Dqf
         5Upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807393; x=1759412193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fx9sm2SG/XPK/zOHzWrJwHUPoT7scPpd+/H8+WI3Eu8=;
        b=AHt+S6VQ6MhFL7Gpy7ZUmd48Vo8WfOOQiQYNQOzsdHq5647pYlzW0M7LXWNprRDUCv
         JqP4YYt5HIFT2/PfIUm+wkLyf1PS5NyhSGD5k2TSDTmACSke1u2Wq7ieo30mM7I88Mh8
         4HtfProvDsAmpu1eIOp9y7Xtztnk6Kvj3KgUSAYMPFkl14q7iwOlNY9euLfjFSQ1sZDE
         K2G9Dyy2clx2S8ScruApeC3IMeaE22+RJCoLvOI1mWK4c1gBHE+B+mgHdJxy2RsmVuLU
         xSMR9r+NDaXlC3JVWzM0di9Cey8FfjD2vEerkC5lYVSekbClQlbCXfc3KyJOGqSQ6xun
         SO5A==
X-Forwarded-Encrypted: i=1; AJvYcCVGkrp2bdEYK8wKXA4N4L/ByWg7we/USlDbXAQ/mY78NVMCkJAuJOasZ2axyLG0UPa+I+cCEZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeOV8dAureZsuyY+8dm8mTYuuA9Lf7cl+YnDM00IsDpQ7wWtD1
	cTmxODiE0laJMtqMuI5wgEgOL3pW3j5W6vpJAjUJG2isV4kbJKh0vHNBDIUvoB80WAU=
X-Gm-Gg: ASbGncuCvzlgxVJn2RnEu2JcbceO+yCbsEBG4SuKpvRyYedYxve+uJZdAUlrzLHwP0v
	pcqljByiM6PTojoKFVg2fjC5vOcVGgQbDHB55TgZbc3w+m2f/pBdad1Lb8+iiYYFl9ibVxCsG73
	KbLMBqGww7BHrN4i24aSK98LPEC+EZf5NxPofbn6JVyVShN1U9mnHFCipsVeDaCYho39HeoIjE7
	7Os529VQT7Bjxh89uDjFY4XX0U6V+/rrR+mARNhl8oowkjp26RY9z7qo0+vhqIvIdLphwQxVDlr
	4ZtJRxx/vQfP7R/BM6tLkMntVPFrawTT+GKkfqhBVk6zV8CR2VvJk3AH8Z2VR2BuCGSuYksFMcj
	/wbLvjeXwAI+9swxo7WyxkfpF7FuT
X-Google-Smtp-Source: AGHT+IHR1VtsrqYdEOR5yfalGbybkOIcDKOqLqd1M8rHZFAAkkevuzTqFI72lGmxMsSzzCv1aIizeQ==
X-Received: by 2002:a05:6000:290b:b0:3ee:154e:4f9 with SMTP id ffacd0b85a97d-40e45a92e7emr3845371f8f.20.1758807392860;
        Thu, 25 Sep 2025 06:36:32 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb2eesm3203962f8f.12.2025.09.25.06.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 06:36:32 -0700 (PDT)
Message-ID: <4d5bf14a-0465-47b2-88c3-1bf85b008707@linaro.org>
Date: Thu, 25 Sep 2025 14:36:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/12] perf: Add perf_event_attr::config4
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
 <20250901-james-perf-feat_spe_eft-v8-8-2e2738f24559@linaro.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-8-2e2738f24559@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 01/09/2025 1:40 pm, James Clark wrote:
> Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
> packet using another 64-bits of event filtering control. As the existing
> perf_event_attr::configN fields are all used up for SPE PMU, an
> additional field is needed. Add a new 'config4' field.
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>   include/uapi/linux/perf_event.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 78a362b80027..0d0ed85ad8cb 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -382,6 +382,7 @@ enum perf_event_read_format {
>   #define PERF_ATTR_SIZE_VER6			120	/* Add: aux_sample_size */
>   #define PERF_ATTR_SIZE_VER7			128	/* Add: sig_data */
>   #define PERF_ATTR_SIZE_VER8			136	/* Add: config3 */
> +#define PERF_ATTR_SIZE_VER9			144	/* add: config4 */
>   
>   /*
>    * 'struct perf_event_attr' contains various attributes that define
> @@ -543,6 +544,7 @@ struct perf_event_attr {
>   	__u64	sig_data;
>   
>   	__u64	config3; /* extension of config2 */
> +	__u64	config4; /* extension of config3 */
>   };
>   
>   /*
> 


Hi Peter,

Did you get a chance to look at this? Patches 1-7 have been taken, just 
waiting on an ack to take this config4 change before taking the 
remaining ones.

Thanks
James


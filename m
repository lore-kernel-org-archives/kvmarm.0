Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA998285049
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289980; cv=none; b=MIkU0NJVfW5M/fGkc4qWstpWmP+L1CLz8ygocde8bAFb7ECPXUHXJKyEihE8qSqMQHEYNbDNvTHvyPIZwOWLMmJNGvEG9ITY1AThJmAoxRkoItF9KjjrYEdWt6XaBa9zwG/04qPBkC4Y0gvOmDxUFBoUWHxWS6nymXykgv/n0cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289980; c=relaxed/simple;
	bh=zAp7B/cd+BfVWsSs8Ec9IsdTrIVawQH9FTL4oc9BjqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7XT1zXBkXbfxSOp0bmIxdSNbTRz+mLy6XAVYUzVxXnUPyMVzqFhyTGuJfMGCbrCeyGpwYKW5tKX43mHY39z7kZ8788ZHNe6yjCUzMNB9HiiXTesNoHdoB8C++ihxWvqV9b1vnVmxHFku/6K5JjpNG/wKMPihSqFQyfJ72SZmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dXNMCQwK; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dXNMCQwK"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso21489415e9.2
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 06:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751289977; x=1751894777; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1LR7G+ibD4rgaTIYMC1yKY14KOB6Bt7LBBCN91SJpVU=;
        b=dXNMCQwK0w/B6qaJcTNkuC/3U+H230ZwIst35DlXlABcvA/LYx5D8C8ow8coENVopK
         ugvwHsm4uAKypbiTorhQj58l8ovGaD3G7M64pCKfeDhVkQCdh0DlBQw/uSGLMQcHRFxb
         NzBRothhaQBoJtdVaWpyC0VbAdNSXphW2y+mCqCcAJc7Fr1EUzr5q/+Jk8OtfJ6iw4Tz
         mN3zQfS6TEINVOfazyqyR0SAYwWFGgbjj7ORLRGXyQMhgMCEN8YCuK5R8l4DC9VAc0o+
         bfooXnMKZ9/58mp/JviiHBNcGG2y6KVLx5r3R+J2d3aIKUH039laFpVbptRYMcSVDbmR
         YSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751289977; x=1751894777;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1LR7G+ibD4rgaTIYMC1yKY14KOB6Bt7LBBCN91SJpVU=;
        b=tEarD2PxjSqMQ/WrL/VAOVrQLmajERqRKO2rmNYDIHxw9ev28ijAQVTEn81E1RtdQY
         226DMKHkLpIqyFzsF7aGc2FeEWCEkE6MPZq2RFp6Ootpv38+kyK92lJWXJDjm0ie2OoY
         rRCyCm7zf0aZOlF2Pdv0X8BwIsyO1FxILqenl8DhUZLv1uNguNMujnX+tpvahw758T8S
         Elbx5cVYzeHynqvsIzjtbGCcB7bbGB84lC6lJMyK/upLOAgb48KYdBgrAuY4/PaQh4nO
         8KpNJoprvCUr5nzxguvzPNE2ToIv/fky+9E/tHefTgJcAGBt+nyISxmJtp/vCXjIO3Fx
         yV1g==
X-Forwarded-Encrypted: i=1; AJvYcCWqoHb8eWFuU3zc43z6xYSOCYYvRAiI6ntmoFJDw8Oo8+qx6U/19VXwN6KIkg1W9aT3oFzYBEQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMpNVKgY75Kf7677YopPFxSfTlwrEGCLKbAGUvS8ugIbE71nLR
	FULP68jdqfL+F4d/4GpKqTK2dysPV3khEbnGMsSVQPBuqqd74taKj6T0ViK/+/ke/+U=
X-Gm-Gg: ASbGncs+HCwinF3bJY+5t2b/SRae+oBPV27It/pjJrrm9VabjkdiLiijAWcWv+OiCyf
	b06VoJQgx7tNw7opWNxt/qMN93rF+1fSzM8BGcs187Np/3irR1N+aktD/eFmmauFBfAN3DIB4Xj
	7cHiwZns5X6qpZ2rwV0h9idZa8ND+BbGU20n5tEKr0nInGnXM3lJ9I9NpEl4ihoQdsNPNAtG1bl
	ep3G4Q3xZxjzFarOigmlw6p7sPraQjA2UcIRMNmIrmm0Gsp2r4VPuvbUFzxlbr0fpE7uoQyGMj1
	6xAtFLH1B0jldDVsoP5LFkmPD5hzaH78TnOtAr/e0QA1tJBJBfZQN4jhxuUGOUQK7nU=
X-Google-Smtp-Source: AGHT+IHXyDPllAQfiCnHOhBWNnf3nw0YYqRMT7LLRAVDyR5oQC0yCAsnt4bSuJQio4g5UH+jS57AqA==
X-Received: by 2002:a05:600c:3ba1:b0:450:d04e:22d6 with SMTP id 5b1f17b1804b1-4538ee565damr129693165e9.7.1751289976911;
        Mon, 30 Jun 2025 06:26:16 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a3fe592sm132598425e9.21.2025.06.30.06.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 06:26:16 -0700 (PDT)
Message-ID: <5ecf74f6-08a0-474c-b0ff-32075af7ae03@linaro.org>
Date: Mon, 30 Jun 2025 14:26:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] perf: arm_spe: Armv8.8 SPE features
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 05/06/2025 11:48 am, James Clark wrote:
> Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
> filtering, and SPE_FEAT_FDS data source filtering. The features are
> independent can be applied separately:
> 
>    * Prerequisite sysreg changes - patches 1 - 2
>    * FEAT_SPEv1p4 - patch 3
>    * FEAT_SPE_EFT - patch 4
>    * FEAT_SPE_FDS - patches 5 - 8
>    * FEAT_SPE_FDS Perf tool changes - patches 9 - 11
> 
> The first two features will work with old Perfs but a Perf change to
> parse the new config4 is required for the last feature.
> 
> To:
> 
> ---
> Changes in v3:
> - Use PMSIDR_EL1_FDS instead of 1 << PMSIDR_EL1_FDS_SHIFT
> - Add VNCR offsets
> - Link to v2: https://lore.kernel.org/r/20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org
> 
> Changes in v2:
> - Fix detection of FEAT_SPE_FDS in el2_setup.h
> - Pickup Marc Z's sysreg change instead which matches the json
> - Restructure and expand docs changes
> - Link to v1: https://lore.kernel.org/r/20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org
> 
> ---
> James Clark (10):
>        arm64: sysreg: Add new PMSFCR_EL1 fields and PMSDSFR_EL1 register
>        perf: arm_spe: Support FEAT_SPEv1p4 filters
>        perf: arm_spe: Add support for FEAT_SPE_EFT extended filtering
>        arm64/boot: Enable EL2 requirements for SPE_FEAT_FDS
>        KVM: arm64: Add trap configs for PMSDSFR_EL1
>        perf: Add perf_event_attr::config4
>        perf: arm_spe: Add support for filtering on data source
>        tools headers UAPI: Sync linux/perf_event.h with the kernel sources
>        perf tools: Add support for perf_event_attr::config4
>        perf docs: arm-spe: Document new SPE filtering features
> 
>   Documentation/arch/arm64/booting.rst      |  11 ++++
>   arch/arm64/include/asm/el2_setup.h        |  14 +++++
>   arch/arm64/include/asm/sysreg.h           |   7 +++
>   arch/arm64/include/asm/vncr_mapping.h     |   2 +
>   arch/arm64/kvm/emulate-nested.c           |   1 +
>   arch/arm64/kvm/sys_regs.c                 |   1 +
>   arch/arm64/tools/sysreg                   |  13 +++-
>   drivers/perf/arm_spe_pmu.c                | 100 +++++++++++++++++++++++++++++-
>   include/uapi/linux/perf_event.h           |   2 +
>   tools/include/uapi/linux/perf_event.h     |   2 +
>   tools/perf/Documentation/perf-arm-spe.txt |  97 ++++++++++++++++++++++++++---
>   tools/perf/tests/parse-events.c           |  14 ++++-
>   tools/perf/util/parse-events.c            |  11 ++++
>   tools/perf/util/parse-events.h            |   1 +
>   tools/perf/util/parse-events.l            |   1 +
>   tools/perf/util/pmu.c                     |   8 +++
>   tools/perf/util/pmu.h                     |   1 +
>   17 files changed, 273 insertions(+), 13 deletions(-)
> ---
> base-commit: ec7714e4947909190ffb3041a03311a975350fe0
> change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99
> 
> Best regards,

Gentle ping, thanks


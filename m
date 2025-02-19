Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340F71F9410
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739981373; cv=none; b=FLN7BaUBuRKjsAhsJ1AIT/xm8KZIz6QPLABnvGDcXCb6iJGYLAqRojIWBL9zinyiBN59aF9ogB3ThemkbP7r6tF4QajxV1+cKkeotu3COsogZqC9PiHzzVywB2BhXfS/VBzgP6PCK3thFWjuVhuFAvNQh2M+ZyQdQ8tgCUQ+39M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739981373; c=relaxed/simple;
	bh=/lekqJfKGMjw1dQxyTeqadS7uFPIGjGMoohx7NzndQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RiMgEC8DuzCJDzcyX7c259HoeAXC4ryFdSeWgnvjo8l3kTwn44RIbLnY53Gueb1B+7jtl0RauOODNMZuHiVFPDRlH5nn5bgm1szlcJl+cgfzqWMP55w15M/OuDYVhR7FRKcfgsdOcWvlJf4fhpMjbrcEN6jlZxmaIrfenBLGR00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nxg36v2l; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nxg36v2l"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-439a1e8ba83so824785e9.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 08:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739981370; x=1740586170; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EdBoFnuhqMD4bPK9q59QOYbccPf40KzMHKr/84iucLw=;
        b=nxg36v2lJ97/Xgk04kGx9CV+M51uu6/oUQNJ35C2tDkSnM3nkP+BXq744GAGfZQMPf
         7Nwp/TJUSSLpOyyvhaG/BFq7f9jUkeD4awz0oMFc62JzsD6RH2v4cMiKi9dTZ4eTGP2L
         mSvUNt76OkWYDq49p638xrWu2u2hghYnAC525zwu2i2MUHUtD7ti6maMLVu4BKEf1kad
         aol2nCn6noZg+m+FH3y1us/n9IDkJGd3otCzCka8YVd4gibuQNX4GOCKjkfrxcJJTQVl
         eqN5SG3WlEk+ZVZO9hs/Br7vATLAJiYMhLPxTyy1MD97LyKOzw1D/MyKDYj2RnOLUnKC
         MwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739981370; x=1740586170;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EdBoFnuhqMD4bPK9q59QOYbccPf40KzMHKr/84iucLw=;
        b=REMCcWIr5y9NXCLF6FA6A8+Oe8zeBS2obNO9yurecG178ACGc+zMYp323ny+gku5+K
         AYwwjZfoHYPJ51FXNRa9IZN74NnqoW6lhcwSbI913D6YGQ1j+5SDu9w316gxb9L/rZOD
         O7DRdQTJz+V/GmVlAUGZwNJnfljmStTuVQ7d8iWD3dEeoRzfFMRbA69vdSBoUOFRfeG1
         OIbmBnilByb3Lmfiztd9Gdm3CUmJtOs5GeMD1szK0Q8gartk0MPfb318ffoONVwygtAy
         2Btu2LwW4/APGrzyCof1iJFHg7p/+qupFai69Hz5RM5aXPw1SAH2XezPjNFOTHS2pLvC
         33rg==
X-Forwarded-Encrypted: i=1; AJvYcCUGt0j56Zcjwe1T1CHP+1aWmlGzDePYerPvwysIBgCjExI/s7Qy0IEi86v2OhHvur55whmxAIA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw4WumzT8IFi2i3PjERmYyI3apxa/QfGrOIg5r2hzcWJFf3NSX
	noWfRMlfxikrhW+1JlzAQI9rlAV9m7F9h7snqv0rMnfclWDqlTtpj3lsK10vFwI=
X-Gm-Gg: ASbGncsoCv3PJpWGzwErH+9r0EA9yP/0BMhFNXfYf833ABa2Wsur/ypbaRHGUR+/1BA
	Cq3yQDytBMJjw1/Zh7zoC6An8MyupRDmNpKOImxAbhFXFuzQL+tnZ7T7Q+CezxCMo9I1fZtqqjW
	qXDxayngShOhqPe4n9rKqHJS6EoFUXkmVne8bU6oTXc5cck4VWSbqFbtzYfCuELM/ro/VCYCDzW
	eJbHWsOHMufDp70lKYpFtXDz4VzZccgE9ZlcK5qhTwiwy8TJq8Tz7MVKM6YUnCPKVYr47Rn/g9z
	/9ta5q/hcZ35rxzDTmGXD/QWiA==
X-Google-Smtp-Source: AGHT+IG87mSbuSo594YlU8iwWTPKAQqVV2chSBKXzyuZ7LJ3HKDzFEKHoFoqCd1APAlb8lVP4Vl8fQ==
X-Received: by 2002:a5d:64a3:0:b0:38f:50bd:ad11 with SMTP id ffacd0b85a97d-38f50bdadd5mr6657402f8f.5.1739981370330;
        Wed, 19 Feb 2025 08:09:30 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f561bee3esm3617686f8f.21.2025.02.19.08.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 08:09:29 -0800 (PST)
Message-ID: <f8f5b7bc-0219-4891-9ffd-f54102b90b45@linaro.org>
Date: Wed, 19 Feb 2025 16:09:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 00/11] arm64/perf: Enable branch stack sampling
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 18/02/2025 8:39 pm, Rob Herring (Arm) wrote:
> This series enables perf branch stack sampling support on arm64 via a
> v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> on BRBE can be found in the Arm ARM[1] chapter D18.
> 
> I've picked up this series from Anshuman. v19 and v20 versions have been
> reworked quite a bit by Mark and myself. The bulk of those changes are
> in patch 11.
> 
> Patches 1-7 are new clean-ups/prep which stand on their own. They
> were previously posted here[2]. Please pick them up if there's no issues
> with them.
> 
> Patches 8-11 add BRBE support with the actual support in patch 11.
> 
> A git branch is here[3].
> 
> [1] https://developer.arm.com/documentation/ddi0487/latest/
> [2] https://lore.kernel.org/all/20250107-arm-pmu-cleanups-v1-v1-0-313951346a25@kernel.org/
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/brbe-v20
> 
> v20:
>   - Added back some of the arm64 specific exception types. The x86 IRQ
>     branches also include other exceptions like page faults. On arm64, we
>     can distinguish the exception types, so we do. Also, to better
>     align with x86, we convert 'call' branches which are user to kernel
>     to 'syscall'.
>   - Only enable exceptions and exception returns if recording kernel
>     branches (matching x86)
>   - Drop requiring event and branch privileges to match
>   - Add "branches" caps sysfs attribute like x86
>   - Reword comment about FZP and MDCR_EL2.HPMN interaction
>   - Rework BRBE invalidation to avoid invalidating in interrupt handler
>     when no handled events capture the branch stack (i.e. when there are
>     multiple users).
>   - Also clear BRBCR_ELx bits in brbe_disable(). This is for KVM nVHE
>     checks if BRBE is enabled.
>   - Document that MDCR_EL3.SBRBE can be 0b01 also
> 

Tested-by: James Clark <james.clark@linaro.org>


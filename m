Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4FA1A0714
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953270; cv=none; b=sEzVMjS75FhDaIO1oIcHAmoeG6A1g2QAuhMsBsFPguhlYTL7CETOBfGapgOv/Bm303XK2BhAD0FfGccvNinxuyvkVTYm0s9HB9AGT45tABT9MSbI09SVPZBV7oknSYpDqh2RDRQ+sMadbPSy5MjV4telobC31gwMt6x/o/YHqnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953270; c=relaxed/simple;
	bh=bZSx3HFKC1zh1AZ8JeSjqrBjCw5FUvgyiaxevBr4EBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a0smvzj4SraglFlT1RuZNVRAT9iOnQwNIkoFcFxNN+bVYcS6aPSQ2v7043mXsna0JbTWxZz1zEZ2tDshlgfBhV+8DBTQ6PWy9h2d9ZDP7BpB/rvB3K/PZHe0yP3oZBYxJB1gu64hupmSluEY5VEpCC1AQ3Q6jzvnka5sLQkYDu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CbNhNlWV; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CbNhNlWV"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21f4a4fbb35so26190695ad.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 10:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738953268; x=1739558068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scCLt4lohbE1AQx25ta1VXQZLYDsS2XoZD8uXI6vaAo=;
        b=CbNhNlWVYCzhRgJT1aIb+kLxdeRrKAwYbX3LPToPfqEIp37GBN2C3iZI/8SX36okur
         JrLDGCL0cD8bjP6iYl9EzXyRa+/z0+4SEUcU78km1XeaUZEIHZLiAMuW8o+C4RcxhWob
         UhHdYnvVkzk5fX9La5wNzHb8NtGJ2Sv3EHykpDxdtpnNABjqJKV/Zw01X0oZ3ivkOuU6
         NpGfxzN4jUuWBQO6HLIu6hfmU0ZrexgAiegP5axB2JfMG4fFXabJNuuvFzOaKQZ/aJJD
         wrFiWnlKvWtQrSPOlKhehhL0E1zDqoCwWC6hcolOk+rpio/rcJbbbf8dHCoCw3TJWKb6
         DOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738953268; x=1739558068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scCLt4lohbE1AQx25ta1VXQZLYDsS2XoZD8uXI6vaAo=;
        b=uH5J/FBgj0e/yNtWpYv289H5kdTc0q/O6KMZbMOCLHNnwwQBE8RcV5BTMta8aRVCeV
         dGDfNWmjuDShBicTI6lCR7pf4Sgu3HSL0+gMbjkItJ+qpnIG35jyAeXcTOttZadLuRIV
         Ri/eFU8iBzkA6f5JZgxC6qxO3PRfdqdpcm+CffTP08wGl/l3XC1MqRv/qmcv+TFlPoA9
         9ugNZVmjaxb8rnFwvN0Xon4T5VoBSz7RiiryjIDLNA/LGz+4U1Hh8znQQa3HAe2IOXHZ
         tYjmTPXMMtENcCcz4UP/QmE1jmM6nHb9YVc196VDZaLs0iBYCLKZMD+45oyCFQ4KxRDz
         +ITQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZoN7SxrRQf5NFEnsxYp88d726vojoN/K1IVChg7p0AbPWec70TxtSJAor/xjdk9b/rP3q5AI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDaJohnrq4SGuavfxrokv1atYE4n+mPEyZrTEXPzN6LlljTPys
	8lZgUAs3p9goPgB9aUUjjsO7K+cYiaAvvvSxGk/CmcmV6fADu9ohk7Tk//FdFXoDQ1QFlwnIUAf
	7
X-Gm-Gg: ASbGncsaGPvOU4qi/ffkbXgJVL1zCrbrtDNSrhrNMJq7+IXSNyX1ClyC7G07PD638p8
	pOL4KXWBRXkX1AHQU7vFdVIR+manFfsLETtO6TCs1K3kHi7kRMgOw+PiwEDifwSN91ECsfyAymF
	Yqdl7W6JLRb92kJSqsZc8jfYA+DqWhx62L0AWM/TZJ5Sx9VbO0daYDxiTqjVrJTFRF9vfaCCzrf
	VnvfKBYaf4hvBO6Ox7ngf8nNy3i6QIsf15oheYTo9dalNH5G5pelWIyA7SytkWJkLPCYO04JeVY
	vzEHqJqDyg4uVflPNxwnY7cGkqTo7qjI/kbvJjGsiwVvaWxewGZIpVI=
X-Google-Smtp-Source: AGHT+IF4E+bXkGzgB25TTuHhb32sFVZR8LwtOcS0c6JqrZ4wfEs22TUpIhduVya7u9MYnQpsb/ePcA==
X-Received: by 2002:a17:902:d4c9:b0:21f:3352:8f64 with SMTP id d9443c01a7336-21f50158c3emr66489165ad.26.1738953268080;
        Fri, 07 Feb 2025 10:34:28 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f36535f0fsm33991975ad.56.2025.02.07.10.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 10:34:27 -0800 (PST)
Message-ID: <997aeb8d-ffb5-43f2-a6f4-767e66a19494@linaro.org>
Date: Fri, 7 Feb 2025 10:34:26 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/15] arm/cpu: Add sysreg definitions in cpu-sysregs.h
To: Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-2-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250207110248.1580465-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 03:02, Cornelia Huck wrote:
> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
> new file mode 100644
> index 000000000000..de09ebae91a5
> --- /dev/null
> +++ b/target/arm/cpu-sysregs.h
...
> +static const uint32_t id_register_sysreg[NUM_ID_IDX] = {

You can't place the data into a header like this.

> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 2213c277348d..4bbce34e268d 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -30,6 +30,7 @@
>   #include "qapi/qapi-types-common.h"
>   #include "target/arm/multiprocessing.h"
>   #include "target/arm/gtimer.h"
> +#include "target/arm/cpu-sysregs.h"

The data will be replicated into *every* user of cpu.h.

> +static inline uint64_t _get_idreg(uint64_t *idregs, uint32_t index)
> +{
> +    return idregs[index];
> +}
> +
> +static inline void _set_idreg(uint64_t *idregs, uint32_t index, uint64_t value)
> +{
> +    idregs[index] = value;
> +}

No leading underscores -- this is not a freestanding environment like the kernel.
We must respect the system implementation namespace.

> +/* REG is ID_XXX */
> +#define FIELD_DP64_IDREG(ARRAY, REG, FIELD, VALUE)              \
> +{                                                             \
> +    uint64_t regval = _get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX);   \
> +        regval = FIELD_DP64(regval, REG, FIELD, VALUE);                 \
> +    _set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, regval);             \
> +}
> +
> +#define FIELD_DP32_IDREG(ARRAY, REG, FIELD, VALUE)              \
> +{                                                             \
> +uint64_t regval = _get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX);       \
> +regval = FIELD_DP32(regval, REG, FIELD, VALUE);               \
> +_set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, regval);                 \
> +}
> +
> +#define FIELD_EX64_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_EX64(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define FIELD_EX32_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_EX32(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define FIELD_SEX64_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_SEX64(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define SET_IDREG(ARRAY, REG, VALUE)                            \
> +_set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, VALUE)
> +
> +#define GET_IDREG(ARRAY, REG)                                   \
> +_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX)

The casts look wrong, and seem very likely to hide bugs.
The macros should be written to be type-safe.

Perhaps like this:

#define FIELD_EX64_IDREG(ISAR, REG, FIELD) \
     ({ const ARMISARegisters *i_ = (ISAR); \
        FIELD_EX64(i_->idregs[REG ## _EL1_IDX], REG, FIELD); })


r~

Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C6634
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744700956; cv=none; b=RvRuG97K185lxC5JTWOyswp3qo/TFxkNTlsBbP7ZmraAkYZOSVub8V7DmuSnIpY5yyRrdITTpFiJ+pDH1o4GXTJk1F3wuJsIbcTviWNx1sYcOa7uiLZAIoQEvpOaufMzxYR2Jpp6CGUBA2//iGECPk/I/fhLVQHYcDxBrq6U5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744700956; c=relaxed/simple;
	bh=yCA2/Oc2+/ll1GPvTsVKPXe9bVmUlSF5TsF8fzSMEzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=svBg8/Td8qoK93UnMHmOXh0M4iSPljnGXZ+Xeyv5E52BH9ZT/Slyg7q6H3AtlEca2ccMKpIXQbsA82lANFzREHlXctZudEPZTDrLjaZ7njNtk1jK1SAgdM/lZgzI0ZiI7zXAfwVwng4zHyeTc8c8fXRQSZKRLJlt6PC8D05v+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cK5QkwgC; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cK5QkwgC"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d0618746bso39877355e9.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 00:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744700952; x=1745305752; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HQorS3qs/9wF+hxqJeIyqNgmDflvogIXAEEo0HyX7cg=;
        b=cK5QkwgCm+2XrT8rs9xuGEgRyBXxl2/xsgo/lYJzpS370niLd/8nRY+keGcgcih3js
         6Wle9eHTCC6j3dwk13GCZ1wqKOGgy7g3p9s8kh+Tq8CbNfkp7mjdnPlFkUh+mXzyBCRK
         Nmo+1Ud0XEYh3xY5UW4Apbn24wea82WBVlyjrExFGrF0RoWb6c7bHiuhen6jHsi8Punw
         AdDAM1sY25kDNE5L4KfbtDWzQFMQZYe+hG0CuGdLyMzPd/zGfJ0tAMV2rxxiD9OFpq0P
         kLY1yyIOvUvKLWZS6kT23lNIcYqtr71CAz/HyMFz1kcNt0j/8xIvIr+ZQC47hQWdLK98
         uV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744700952; x=1745305752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQorS3qs/9wF+hxqJeIyqNgmDflvogIXAEEo0HyX7cg=;
        b=XV5By9SSTwGvUaIhCrDoDwSr4tfxN6tdg7+Ud5EyrZa913yrpVUJ+4poBV8Xmy0GQ+
         iw+gQtyHRfBmgUaX52Lw5jLfShRbkz1JQ88vjGu7/Arx68YxL5obpXlutUb10yWEoBU0
         +6SnWkEdBg1sWIGPbHSvOSTzNssoHAzTsv/DpSRT49pSjCHt4iDzgqTFbwlQm5HuUVue
         3YqV5qjW/emfl+YDT2CCYj1GEeGZpnXaA8dhK/POuz82UuRsRViXfZle174AlrmRfWS1
         U+HbAOI35YTkJLOsU3xYc+YgxQCtNufydZGGzGKlUxG9wsmkv/fQyBoRnw2/J/CLbh05
         DsSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9NiAAJM8rVEbSSvvvlkDAiyQkihjhZsh9YnKySBdRr0EwJrMnLSbWJhnuNF+6vPW02Z4Z59U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxI9oMOd8ZS9cdJUxwj0Qt3yyo/BvYM6EuA4+Pe730JHmwTrVCg
	+RCtvSa4BpFniV7yVaPR3+u4D5o7o/AG3NC4pCh9zGJmeJJJFTTI3xNhaF/J0v4=
X-Gm-Gg: ASbGncsDWiGWISq5HsGj2nYVub/JwCi3XT/1yIY0Rjz1dqFLpj1gqSydzS9YjqwouWE
	Ompb0YcpNZ7KhKT/lipzb7AXrok3O90TThLCvCYqoKWlYIAdJWp/VYc5u9jXPcn8IScCaPnbe4W
	NzO010bimoxvE33q283vRPL4CD/uWWek3TOdghIGBwe0aRiLBgDFPG2grvV5yQV1DnEFI6TWnH+
	p0HMXD2zqQGfMQ8s40j2n0QvlT8PzxriTTBpUahVeKIk+Gzi5PHWcbdkbvKd9ZAXFIUtK1+1D1/
	+J25j0tewRbtKa6l+XhnLKF19SNBwQkvzH5qSsqD8REUQTcIhYwWM0qZe72hV1QFlnL+/hZJ9K6
	lTrlckJ4J
X-Google-Smtp-Source: AGHT+IEBCb9hNiit5aB+Gor1TQBCisecLYyLH9/Q7InmyAKhQNWL89req9MQk6VcoCy7HxiIPVKtng==
X-Received: by 2002:a05:600c:3acd:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-43f3a7d827emr146771465e9.0.1744700952548;
        Tue, 15 Apr 2025 00:09:12 -0700 (PDT)
Received: from [192.168.69.238] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f205ecc73sm201303415e9.8.2025.04.15.00.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 00:09:12 -0700 (PDT)
Message-ID: <0fb4cd74-bcbf-4063-bc3b-0e8359d04117@linaro.org>
Date: Tue, 15 Apr 2025 09:09:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] arm/cpu: Add sysreg properties generation
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-3-cohuck@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250414163849.321857-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/4/25 18:38, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> Introduce a script that automates the generation of system register
> properties definitions from a given linux source tree
> arch/arm64/tools/sysreg.
> 
> Invocation of
> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> in scripts directory additionally generates
> target/arm/cpu-sysreg-properties.c containing definitions for
> feature ID registers.
> 
> update-aarch64-sysreg-code.sh additionally calls
> gen-cpu-sysreg-properties.awk which is inherited from kernel
> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
> the original author of this script.
> 
> [CH: split off from original patch adding both sysreg definitions
>   and properties]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++++++++++++++++
>   scripts/update-aarch64-sysreg-code.sh |   5 +-
>   2 files changed, 329 insertions(+), 1 deletion(-)
>   create mode 100755 scripts/gen-cpu-sysreg-properties.awk
> 
> diff --git a/scripts/gen-cpu-sysreg-properties.awk b/scripts/gen-cpu-sysreg-properties.awk
> new file mode 100755
> index 000000000000..76c37938b168
> --- /dev/null
> +++ b/scripts/gen-cpu-sysreg-properties.awk
> @@ -0,0 +1,325 @@
> +#!/bin/awk -f
> +# SPDX-License-Identifier: GPL-2.0
> +# gen-cpu-sysreg-properties.awk: arm64 sysreg header generator
> +#
> +# Usage: awk -f gen-cpu-sysreg-properties.awk $LINUX_PATH/arch/arm64/tools/sysreg


> +BEGIN {

         print "/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n"

Should we keep copyright?

> +	print "#include \"cpu-custom.h\""
> +	print ""
> +	print "ARM64SysReg arm64_id_regs[NUM_ID_IDX];"
> +	print ""
> +	print "void initialize_cpu_sysreg_properties(void)"
> +	print "{"
> +        print "    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);"
> +        print ""
> +
> +	__current_block_depth = 0
> +	__current_block[__current_block_depth] = "Root"
> +}

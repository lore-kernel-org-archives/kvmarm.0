Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34119F438
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744701660; cv=none; b=D3SG25rnyO1d0GxtaaDDjVjWy7NHdT3+PNguIMDmWjdPgfgvyQn/iTFyFSUHEu7+HVUD7aazEu/izp9QHzkT9mm15IbOkup7+InO8VtLukQHu0j/L9cZytPVzz+wdSucj/UlM4ZYvnPnZgfCp6Jnxq4evMO/eC1YbvQWrjgqAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744701660; c=relaxed/simple;
	bh=V/v9GiZS9r3EuVryMhCHbZEpBTxV88G2h/o6ZO97E1A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LlAYy4BabB6Jn7eYjRtdzLr6jPVSibVSpkYkyhhqy0N4L0Wf8ugLz+G0jZ8rSJgdHCyBl71wUZV9CWc3S6O16QJkwAGEvSVqVnLFXSXcqJE7S5KU9EpvGVyMMJIogshnlzGFSxPF+QhStQiQT6YTUn11bRhTV2T3WdUfGUKffLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ax/0J/Ym; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ax/0J/Ym"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so54116505e9.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 00:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744701657; x=1745306457; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hH8+sIlY1RoZcJVObMFX4ZA0+K3VlclfSxJRg4vxEo4=;
        b=ax/0J/Ym5BlCyPCG3c4Swg4PME/IwFJCUqCl4P2yrJypBPrSbE8gdvYgLZwKUlNfnL
         sfzAqKeYVN4scf/UCdsjJPD14LkkLDbq7QEwtL9BVYxDXM6AK4fb2Q02jxIa/ZFfWx+y
         xTu4v36eONhqFRPFspTWCGyg7XkJyfuTp9yl3MZxf+y1roMxpTrYjxEH7TOWu2+qrXe5
         f8S5+nZIs/m6dOzN9ZpkDIEbL1SwPZFXfa5zpKBT8p3GdYbBl35DPkocHId+F3VVLcnM
         xMXh30zy6kyPPXNKg87XrLxjqqDShxvQO/+WQH3WBYTxQMRm37zU55FqjUxKFMmz4sTL
         TlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744701657; x=1745306457;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hH8+sIlY1RoZcJVObMFX4ZA0+K3VlclfSxJRg4vxEo4=;
        b=iE/q/3oSOP9QwiPzhw8yUp08yuGtblWywOCRH8Gc9tMtf4pK+6x+UAXvtlUsTnm8Ty
         2EThoEbqqE9xzWsq8gUUVTsmrIZ6Yqotn7Y/DKyMbNQsy1F7ud7t9i/xIsJ+CNv40f7B
         96nWw9Jn4oAC+2jNR9YlnkP0v+D1krZYgVSe7DJVgLRorNajLmL/9bx6Sfj47obVLBU2
         AAbcTwf/aE0vv9wxLCEPEmy5SfmDEuCyCC9nAQyaBXSv1sRpNsL2sPgiGAU7cVjWjZaP
         5Tp9yXgBMVCIssMIkKQ6WR7eEkLOoEQ0LArghRWl+caobGrvSjDhlt8J7qQYVnUUAROz
         C/oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXY9hsdFqT6js57vawHWvK8nKHxI2yZWhu8j88pgJ9pA6csNxrGp7nGbqz1YrWi/HNSK7heCJs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYunnBe5IpXE6iLxFeG6adHmAsigd1ujt2CXNVOrAdzHMUf537
	4Yl/huIC11yZLKX53MqCpfszDMYWylWY0bYNkuJPAFLOar7JkNniqTtcG3Gye+g=
X-Gm-Gg: ASbGncsEjdIxHJnMvHldNMZ1/YF2pK5z3OdafbMGIPoo5DeDFE9RtA7TcAIcoukGRoN
	HBRgD8C9XxUvbUqc+3RCpaziqwpOPg22b8oiwynOSGe2AvMa5IOQJxOWNAWPhOFxrdkB8lSvCpy
	xjT1Vj9mZtT/lzltbJiMim9qPdByqJ7P6aNl4YjAyc1KHuQGtKxtuewMfYvY8IRg6AfOn/nW1E1
	YgNJe1JXV9qpeqt46E/1YT3JrxLoY1cQK+wZIqfSsU4ObtlatHJrAXgiw4B8ZKU08xDmL2HJS1b
	/Rky7e0yqOnDlmGnBPIWCBGuBRJAJSvV2Nqu4S1aiDVeNBnkq59+uhZSs4UArwUtid1p+IkUqmP
	w1IIQQ8nd
X-Google-Smtp-Source: AGHT+IGMKQVqURwl9R+Cxj7iwnbtFUMFNP8OTb/dvkhY2+jVXZZuTDzVjeEZnPKZQibjq2fpiV5KdA==
X-Received: by 2002:a05:600c:1d83:b0:43c:f3e4:d6f7 with SMTP id 5b1f17b1804b1-43f3a9afdeamr152724645e9.31.1744701657130;
        Tue, 15 Apr 2025 00:20:57 -0700 (PDT)
Received: from [192.168.69.238] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f205ecb20sm201470335e9.3.2025.04.15.00.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 00:20:55 -0700 (PDT)
Message-ID: <823616d0-77d4-41b8-b8b4-a7830cb8d112@linaro.org>
Date: Tue, 15 Apr 2025 09:20:54 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] arm/cpu: Add sysreg properties generation
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
 <0fb4cd74-bcbf-4063-bc3b-0e8359d04117@linaro.org>
Content-Language: en-US
In-Reply-To: <0fb4cd74-bcbf-4063-bc3b-0e8359d04117@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/4/25 09:09, Philippe Mathieu-Daudé wrote:
> On 14/4/25 18:38, Cornelia Huck wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Introduce a script that automates the generation of system register
>> properties definitions from a given linux source tree
>> arch/arm64/tools/sysreg.
>>
>> Invocation of
>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>> in scripts directory additionally generates
>> target/arm/cpu-sysreg-properties.c containing definitions for
>> feature ID registers.
>>
>> update-aarch64-sysreg-code.sh additionally calls
>> gen-cpu-sysreg-properties.awk which is inherited from kernel
>> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
>> the original author of this script.
>>
>> [CH: split off from original patch adding both sysreg definitions
>>   and properties]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++++++++++++++++
>>   scripts/update-aarch64-sysreg-code.sh |   5 +-
>>   2 files changed, 329 insertions(+), 1 deletion(-)
>>   create mode 100755 scripts/gen-cpu-sysreg-properties.awk
>>
>> diff --git a/scripts/gen-cpu-sysreg-properties.awk b/scripts/gen-cpu- 
>> sysreg-properties.awk
>> new file mode 100755
>> index 000000000000..76c37938b168
>> --- /dev/null
>> +++ b/scripts/gen-cpu-sysreg-properties.awk
>> @@ -0,0 +1,325 @@
>> +#!/bin/awk -f
>> +# SPDX-License-Identifier: GPL-2.0
>> +# gen-cpu-sysreg-properties.awk: arm64 sysreg header generator
>> +#
>> +# Usage: awk -f gen-cpu-sysreg-properties.awk $LINUX_PATH/arch/arm64/ 
>> tools/sysreg
> 
> 
>> +BEGIN {
> 
>          print "/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n"
> 
> Should we keep copyright?

(if so, preferably as SPDX tag)

> 
>> +    print "#include \"cpu-custom.h\""
>> +    print ""
>> +    print "ARM64SysReg arm64_id_regs[NUM_ID_IDX];"
>> +    print ""
>> +    print "void initialize_cpu_sysreg_properties(void)"
>> +    print "{"
>> +        print "    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * 
>> NUM_ID_IDX);"
>> +        print ""
>> +
>> +    __current_block_depth = 0
>> +    __current_block[__current_block_depth] = "Root"
>> +}


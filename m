Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12932DA76A
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762981649; cv=none; b=Cmc47pJgVvUdzznHrB7yYw1jxg3yRHX8PpMS9HzoxDWmaEctQm57wHuepZQkqhcn1mHJMqDtkntoE/AHmPuVpyTfiJZmdma5c0gj2OmHUSEN6/RiAwbd2eT7I1eulep2N2jZYeHH8xs3DXRofU3ygMdDL1DT6Lnr791N+NrlqqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762981649; c=relaxed/simple;
	bh=Z2e8DoPZSUlsjdl9QhSqNgJm8pSP3JCCSTrBSJ21Zyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSxEOC3IR0Am2/K46Ni19ZIOwWVp/ReHiQ7Yqzqu7p8YQKCsOIPGQWSh7I1WUO7xfLOaL2i4kPLzH7dxZJG57CtIRATLAsGIVrseeH0+2poV9bIYrzPwZcKXKKdoHjbAoI8QfsPr+Eael3YKRUqx8v9eskNb4QfFSTcEPRkovC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fur7pORo; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fur7pORo"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b2e9ac45aso79634f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 13:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762981644; x=1763586444; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndvKFCJtXmZXWNjsWlnfM9pmpLT2hMmXPRvFvrdoK9k=;
        b=Fur7pORo769pA4pc5TIUThdKRk5X4YZ1Q/wiB1uR1FtmwWd5nvbBLIzN2AON4e1g2w
         M7/lyne+abQFlJYlxUXo1iRCpEbxqOWq6H5BxYF2EW4znJjiTZUmx6vvYL8hr2GbvPjW
         z0X77ceHU4j2hGxS7bGFEXeFSv1ExwZgprVTNgefTc9uJKsPNwt7FnKR7iXIE68WB1Er
         xFf8zGEI3jqaKyzqPdA5tSWADlLI8T/S+PDQuFUcapuQyPF31SfW/ST2urb7ZLaoWDte
         4Ko4YUw8Wzn/MLlz4DFd4Aw9Ic2+tRG/OQ/bzmGBOE2T5WRwHZRAPh0UTxrkad5sZJbH
         531w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762981644; x=1763586444;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndvKFCJtXmZXWNjsWlnfM9pmpLT2hMmXPRvFvrdoK9k=;
        b=lDthPuklOCgtElpM106GqPU/krrMG/NLhQD9r0v6ZTM6IoYH+2+UU71Wvjw5iUYwMq
         Y7qDrOgHE4NS2esUZsJdGvik1oQWqOY984KBYb6SPYrOgsMMUrNDLIfAA9mADJ49wJqu
         6xXl6xxF7ob6G9MIuYAWwPsefODZ4wW0czxO6iLoNf2hVF4mHbDN80eJ4AmVjkvo6n6q
         YwmEkn99tshCiCx3OXr/aHKiYHfncZm5rHmhgd49amtEwO3YU5nc6iihz9V79c2C+V9j
         wlCgHsnFuoZMW5Z5LOzjSydsPGMLLh/tqDZKetDvwyqrnt7SoYeMpxSLCbm4NSsUahR7
         aA5w==
X-Forwarded-Encrypted: i=1; AJvYcCVvoenIJE1u0P5lKkDcnQUT1eTkH784KzYc5t/rOjHKEHJWx+yYXp3DzdM+/G11EwOD8sCl5n8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+vKvzjeoBeDegsp2iAE/R8hDlDY6wP2AVhfsiS/rTE/qSU+sZ
	NT5vXH9aiuqGmR3imf5mUtG1HaIEcAD2LcrghOg+37opXtgP4KOoQfAeMLK9AX4WlJA=
X-Gm-Gg: ASbGncuqMTU368LoOD/rLfCvHxnVGb+cDdlxjyC9FUZa+Oe8x2cstXLO6sd1tnRjI/q
	HY6v1/SP+NeEPTGjgs0z/sNCFGSjIGqVUWBwhADvmG6/VujFIyip0jOgBQFuQHDC6eektjsEvcB
	1x/VwoT2/UMWSD8Xk7yIGL4MH3ZIFlJGED3IW5au3kB8G3gFp42ADudXGEKbu0m0MoD/lQehPIC
	GA/x12TOfb/50rwXAUOl8wbA2OyVfCgLVTlYiubz61Xm/6Vu/1yJlBLsrJm6v0MMktHDMhz4X3e
	uDLFVldcQlNKvvqesWZAMhhK+9V1QJftzgJu7c/uqQOymMy8lgnisKWPpx0p7vLM/JDiWdnhE51
	zsasbtykNxLZamXQYLlBBCsfOCcYFkPgf3oow0cQqRg2T2Hw0gKDwYoyfXWZODuvJ16iqnEo8Qf
	fKseG/L23lfCImhy6tnxMEB4xDkvIRIW602ek4BNqsmaI=
X-Google-Smtp-Source: AGHT+IGtaSx6QtlDHy/EycHh0/ZhW1Mmm/5WCyQeOiw9mC05LvLWss/kOLCaCs1PZ52vi6bPz95ITQ==
X-Received: by 2002:a05:6000:310b:b0:42b:3b4c:f411 with SMTP id ffacd0b85a97d-42b4bdb06f1mr4248875f8f.36.1762981643683;
        Wed, 12 Nov 2025 13:07:23 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2e96441dsm28506596f8f.23.2025.11.12.13.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 13:07:23 -0800 (PST)
Message-ID: <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Date: Wed, 12 Nov 2025 22:07:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251112181357.38999-3-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 12/11/25 19:13, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> 
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>   docs/system/arm/cpu-features.rst |  5 +++
>   target/arm/cpu.h                 |  6 +++
>   target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>   3 files changed, 74 insertions(+), 1 deletion(-)


> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..e91b1abfb8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>       ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>   }
>   
> +struct psci_version {
> +    uint32_t number;
> +    const char *str;
> +};
> +
> +static const struct psci_version psci_versions[] = {
> +    { QEMU_PSCI_VERSION_0_1, "0.1" },
> +    { QEMU_PSCI_VERSION_0_2, "0.2" },
> +    { QEMU_PSCI_VERSION_1_0, "1.0" },
> +    { QEMU_PSCI_VERSION_1_1, "1.1" },
> +    { QEMU_PSCI_VERSION_1_2, "1.2" },
> +    { QEMU_PSCI_VERSION_1_3, "1.3" },
> +    { -1, NULL },
> +};


> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                                kvm_steal_time_set);
>       object_property_set_description(obj, "kvm-steal-time",
>                                       "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");

Could we enumerate from psci_versions[] here?

>   }
Thanks,

Phil.

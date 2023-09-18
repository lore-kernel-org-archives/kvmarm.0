Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BEA4C86
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 05:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695014352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+VmGOP6k6PklzaSQw+Wb8ACfwVkFKcepFidWWf6BMLc=;
	b=BKS6YjD2aXwzMRiQc4ldVrLAmhX+l89Why7wG9jJquZ6Cu36z2Jz3C9Qo1g1WWwxTs6Uzx
	EZcmUpUd21HUJIkkNVBmcZsbNkQve6pMXV4bLJLkEHYY8LidZu2YKTS/y3LRYflBC2xrTm
	pfjE5N9wXdneBreOdXFMxsKa00ft2uo=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-uBXVzczSPCqqfcMSJKqdtw-1; Mon, 18 Sep 2023 01:19:11 -0400
X-MC-Unique: uBXVzczSPCqqfcMSJKqdtw-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1d6f163699bso1261645fac.2
        for <kvmarm@lists.linux.dev>; Sun, 17 Sep 2023 22:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695014350; x=1695619150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+VmGOP6k6PklzaSQw+Wb8ACfwVkFKcepFidWWf6BMLc=;
        b=IgRV/tj+xwI8jKqw64DTe3EBHMsjOjfYm8q4z5v3tZr2gn21mqBFqS3DMbtO6IPlLR
         h0wk+oxFrErdKfCqhE8BQLRBmNWYdvrNNaOoVZf/uxssixWuM9gJ86cUmdYnMBwoR9jL
         4MBktNllBK+WlvLwqUEui/frwviDxA0F46w78Po1Ks1lijnT/0w9bhoLpWsFKopLd/ah
         Cl+lzbqsFJzHCJkHSyLeSwiImNhQFji8ldxIYS80MaNglB4zyfVx3abFQ1txX2ywwmNN
         HH+vS5BsEfCetXD4EcUXe2ecRNcQeAbrVj4sQTOpIjKZL7kQzE2YlSmNury14YrDO7HB
         dxCg==
X-Gm-Message-State: AOJu0Yxcv+6f+siXQY4U2OZfO5hKQ2lvKInfyyrrGOEfmphjiikG7H3z
	icvwjZ+7cJ7amCPVRp7ny3UYUmC08gys8Zo0IZ0ZyAIRZ7AosoHBlZSkdM/FZPRwMN4ZjiZpC4Z
	MLAxVJj3lpzBenc2W
X-Received: by 2002:a05:6870:9191:b0:1d6:925:840d with SMTP id b17-20020a056870919100b001d60925840dmr9769138oaf.55.1695014350350;
        Sun, 17 Sep 2023 22:19:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgNPgTZtS/hsL5sJUv2LZbTkXkuBlyKD4NiO3GPGQyDZIhzwEA3s34zGbwVBHMpylSMNZ4ZQ==
X-Received: by 2002:a05:6870:9191:b0:1d6:925:840d with SMTP id b17-20020a056870919100b001d60925840dmr9769120oaf.55.1695014350060;
        Sun, 17 Sep 2023 22:19:10 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id mu13-20020a17090b388d00b0026596b8f33asm8145403pjb.40.2023.09.17.22.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 22:19:09 -0700 (PDT)
Message-ID: <2d0e2fd7-5a6e-04ef-578d-713d8e14c30c@redhat.com>
Date: Mon, 18 Sep 2023 15:19:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 17/35] ACPI: processor: Register all CPUs from
 acpi_processor_get_info()
To: James Morse <james.morse@arm.com>, linux-pm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
 Russell King <linux@armlinux.org.uk>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-18-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-18-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/14/23 02:38, James Morse wrote:
> To allow ACPI to skip the call to arch_register_cpu() when the _STA
> value indicates the CPU can't be brought online right now, move the
> arch_register_cpu() call into acpi_processor_get_info().
> 
> Systems can still be booted with 'acpi=off', or not include an
> ACPI description at all. For these, the CPUs continue to be
> registered by cpu_dev_register_generic().
> 
> This moves the CPU register logic back to a subsys_initcall(),
> while the memory nodes will have been registered earlier.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/acpi_processor.c | 13 +++++++++++++
>   drivers/base/cpu.c            |  2 +-
>   2 files changed, 14 insertions(+), 1 deletion(-)
> 

With the following nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index a01e315aa16a..867782bc50b0 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -313,6 +313,19 @@ static int acpi_processor_get_info(struct acpi_device *device)
>   			cpufreq_add_device("acpi-cpufreq");
>   	}
>   
> +	/*
> +	 * Register CPUs that are present.
> +	 * Use get_cpu_device() to skip duplicate CPU descriptions from
> +	 * firmware.
> +	 */
> +	if (!invalid_logical_cpuid(pr->id) && cpu_present(pr->id) &&
> +	    !get_cpu_device(pr->id)) {
> +		int ret = arch_register_cpu(pr->id);
> +
> +		if (ret)
> +			return ret;
> +	}
> +

The multiple lines of comments could be combined a bit:

	/*
	 * Register CPUs that are present. get_cpu_device() is used to
	 * skip duplicate CPU description from firmware.
          */

>   	/*
>   	 *  Extra Processor objects may be enumerated on MP systems with
>   	 *  less than the max # of CPUs. They should be ignored _iff
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index d31c936f0955..677f963e02ce 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -537,7 +537,7 @@ static void __init cpu_dev_register_generic(void)
>   {
>   	int i, ret;
>   
> -	if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES))
> +	if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES) || !acpi_disabled)
>   		return;
>   
>   	for_each_present_cpu(i) {

Some comments may be worthy, to explain why we need "!acpi_disabled" here.

Thanks,
Gavin


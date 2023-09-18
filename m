Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718E20E2
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 03:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695008030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHzH+a1yYhJkfNUv/Dy9j8VaViRqaOEkd87Y+pYRKHg=;
	b=Z62n5vaekOxsxE++HL43oPSSH4HWvpUxkKhWQOecIxcWF9DvMkSD4lzDyv/jxY4K4koo9X
	qtmIt05Smpg2rAbmP0DZQXoGlJYVkz0r5K8lJEfcEK3mj0UIjJ7tID+oPMjqjxArHATCtJ
	LFuyXWFg0BuipXka9kJ+c1QDgVN7X0g=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-ppgxhSBlNBihYL7R--nvXw-1; Sun, 17 Sep 2023 23:33:48 -0400
X-MC-Unique: ppgxhSBlNBihYL7R--nvXw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-274ac6d570aso1973485a91.2
        for <kvmarm@lists.linux.dev>; Sun, 17 Sep 2023 20:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695008027; x=1695612827;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHzH+a1yYhJkfNUv/Dy9j8VaViRqaOEkd87Y+pYRKHg=;
        b=jFZlFGKHxaWa57/Ycrlkn/ZGaLBaqMecyZ++OJ/DbBLLwxWj8lEGEChTw/aZpTp+a5
         Fq+7F1gtNiBVVhFtmsD18JO53yMqSWzwJUiRWTRs/W4wzApP4u0b0Yl0fxN08n60+wJi
         XhSKMzJQtWVJ7zfmuDTSwFleKmCz+/qfStqUQ/7Wj3mNUNCh8yTRm/GggP5lc8CyRsPK
         QWYXzO7aCl3t0lJErcVNz2vMqhAErnnYAMMlmXvI84jBiEAa1yhaXGbVQYaZQFp3C9zD
         wIGd6I0cX0bA2XfaqgzvdaOU+lwb3KrWeal6RWkHS+hpXZ99hyshn8zyEGHsNer1BK3a
         Rn3g==
X-Gm-Message-State: AOJu0Yyrywl0iK0xRrRXSzk6fjnmaWG5CEz9UZqj82XnOi3L+ApCysGf
	4mi4Q4CyqkK1vbEVDy39UROcFW2IPFLYgtgW/HLemxV7aKugSgyDfvl55akvh5g5dI78Ade0C5z
	LvXUo/jfPkr1Qc15h
X-Received: by 2002:a17:90b:890:b0:274:7de7:d6fa with SMTP id bj16-20020a17090b089000b002747de7d6famr7131229pjb.9.1695008027065;
        Sun, 17 Sep 2023 20:33:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdFVHnxmGek3zqSMDKaRzCcHQAQEv2cIpV7L2yNs7LNSqm4GiEBUNxLVrj5jEdjCAv9J4IOA==
X-Received: by 2002:a17:90b:890:b0:274:7de7:d6fa with SMTP id bj16-20020a17090b089000b002747de7d6famr7131213pjb.9.1695008026727;
        Sun, 17 Sep 2023 20:33:46 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a004800b0026b420ae167sm8825822pjb.17.2023.09.17.20.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 20:33:45 -0700 (PDT)
Message-ID: <2c23ab17-7516-e310-8b79-b8c5fc02984a@redhat.com>
Date: Mon, 18 Sep 2023 13:33:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 05/35] drivers: base: Print a warning instead of
 panic() when register_cpu() fails
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
 <20230913163823.7880-6-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-6-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/23 02:37, James Morse wrote:
> loongarch, mips, parisc, riscv and sh all print a warning if
> register_cpu() returns an error. Architectures that use
> GENERIC_CPU_DEVICES call panic() instead.
> 
> Errors in this path indicate something is wrong with the firmware
> description of the platform, but the kernel is able to keep running.
> 
> Downgrade this to a warning to make it easier to debug this issue.
> 
> This will allow architectures that switching over to GENERIC_CPU_DEVICES
> to drop their warning, but keep the existing behaviour.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/base/cpu.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 579064fda97b..d31c936f0955 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -535,14 +535,15 @@ int __weak arch_register_cpu(int cpu)
>   
>   static void __init cpu_dev_register_generic(void)
>   {
> -	int i;
> +	int i, ret;
>   
>   	if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES))
>   		return;
>   
>   	for_each_present_cpu(i) {
> -		if (arch_register_cpu(i))
> -			panic("Failed to register CPU device");
> +		ret = arch_register_cpu(i);
> +		if (ret)
> +			pr_warn("register_cpu %d failed (%d)\n", i, ret);
>   	}
>   }
>   

The same warning message has been printed by arch/loongarch/kernel/topology.c::arch_register_cpu().
In order to avoid the duplication, I think the warning message in arch/loongarch needs to be dropped?

Thanks,
Gavin


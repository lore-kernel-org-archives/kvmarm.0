Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D11215B2
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695084585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIURaVhU/G5DJJinyquD0ptYbPAZ38yx5KNcjiMal4E=;
	b=VdCdP4Se5ER7ZVXyUaqc8oGM+158m+Gf5Fithil/giFqcFZquPtsVieArBDRw81EPV1YIt
	KnRvBGoIvY7Zjgm6OfVEJtfEix+bh+qX4S20jC/B/IEPps0KG+gRw5DQy0QqXVc9p5n+aP
	ej2BBeYR1W2QASRTE8XsrNn3HRtVq+U=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-YGf7RuBXMtS3_sLVL9Hipg-1; Mon, 18 Sep 2023 20:49:41 -0400
X-MC-Unique: YGf7RuBXMtS3_sLVL9Hipg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-690c2fec489so207928b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695084581; x=1695689381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIURaVhU/G5DJJinyquD0ptYbPAZ38yx5KNcjiMal4E=;
        b=F+If7r5kmf+kHgWJ2Paio5z6Gs7dKL1wkjJljVbKqOq6RsnSlBqMVRfToBvsRSdnu1
         1fAkhrz45IkGpuIkjHB8tPC1AuhnrBkvU22JLxFyvuROXDHfkLFUTb2y43gYuo5POAAu
         cngidOSk3UTBTpwO5LNUssYZGOa/C/3C5Pl9Y9N/IR0KCQewTRQ/3ZDwOw3/3LXCSnum
         wjuweYINsLSUJOsQ1N/p3wnJLj/ZVxXRh96oXAFE2x092milubicAbTvtOELLLYYxPQK
         Cw1UjSFZyo/HCFhW/atLmjw4WDIpp7qFndiOTqHWbM/ChwH0ihpDvMw5M41BS0G/hFRF
         V3Ag==
X-Gm-Message-State: AOJu0YwyQ4ZLfIl0xLQPI5sTwTwwjpEEhT5W0yTsMsU2gGrA8XvkJMt/
	cRWik6Q+/gTUfXCExPe3eY4HcA7PboLXz/wVMa0d3ktmG8JiAcclfNJmXNh0UNLWH2Y2OJjW2rY
	a+zBcLL3MfXtGruoA
X-Received: by 2002:a05:6a00:13a9:b0:68a:6173:295b with SMTP id t41-20020a056a0013a900b0068a6173295bmr11687176pfg.2.1695084580789;
        Mon, 18 Sep 2023 17:49:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3oVg5VMiqyNQpSBftI/mkgS1m694rJEONxMKwBMkdMp9Ry/rErZrzBJO2CPP2aN+mnlKKqg==
X-Received: by 2002:a05:6a00:13a9:b0:68a:6173:295b with SMTP id t41-20020a056a0013a900b0068a6173295bmr11687156pfg.2.1695084580437;
        Mon, 18 Sep 2023 17:49:40 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id i13-20020aa787cd000000b0068fe76cdc62sm70310pfo.93.2023.09.18.17.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 17:49:39 -0700 (PDT)
Message-ID: <54c91de8-f0d2-787f-5710-2da1dfc80937@redhat.com>
Date: Tue, 19 Sep 2023 10:49:32 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 23/35] ACPI: Warn when the present bit changes but
 the feature is not enabled
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
 <20230913163823.7880-24-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-24-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/23 02:38, James Morse wrote:
> ACPI firmware can trigger the events to add and remove CPUs, but the
> OS may not support this.
> 
> Print a warning when this happens.
           ^^^^^^^
           error message
> 
> This gives early warning on arm64 systems that don't support
> CONFIG_ACPI_HOTPLUG_PRESENT_CPU, as making CPUs not present has
> side effects for other parts of the system.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/acpi_processor.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 

Maybe a warning message is enough, but a error message
is also fine, I think.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index 2cafea1edc24..b67616079751 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -188,8 +188,10 @@ static int acpi_processor_make_present(struct acpi_processor *pr)
>   	acpi_status status;
>   	int ret;
>   
> -	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU))
> +	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU)) {
> +		pr_err_once("Changing CPU present bit is not supported\n");
>   		return -ENODEV;
> +	}
>   
>   	if (invalid_phys_cpuid(pr->phys_id))
>   		return -ENODEV;
> @@ -462,8 +464,10 @@ static void acpi_processor_make_not_present(struct acpi_device *device)
>   {
>   	struct acpi_processor *pr;
>   
> -	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU))
> +	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU)) {
> +		pr_err_once("Changing CPU present bit is not supported");
>   		return;
> +	}
>   
>   	pr = acpi_driver_data(device);
>   	if (pr->id >= nr_cpu_ids)

Thanks,
Gavin


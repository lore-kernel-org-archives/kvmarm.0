Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C6531A91
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 04:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695098794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0md79eddiFVt37093ccE7iiQ7K8nZkLOgQESfCPy8Vw=;
	b=ABBcJbCglt1qxSif2IH5J3qgXYyXsxJaWfF3gBRp1dPh6ss73WMMOWAbl+ey1zKq2ZQVUs
	uLFgztIA8qetI/t/H6tYs1zxuUXVPiCDw6S12ftz0f8EI3VpWgl1tYFVayboLVpoORjp2E
	I3Ro9znR8eHFbfC3m2M6w7pXHJHP1EY=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-jaga0CqdOt-UJ-4UyFIGdg-1; Tue, 19 Sep 2023 00:46:33 -0400
X-MC-Unique: jaga0CqdOt-UJ-4UyFIGdg-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-57affb81485so1879540eaf.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 21:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695098791; x=1695703591;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0md79eddiFVt37093ccE7iiQ7K8nZkLOgQESfCPy8Vw=;
        b=kqrrojvSYOgq3BFCDmkkp95/8nIOT1ACD6PHqGBU4gy4SMVu7lZUEfA5WE7gdf/zPy
         NPbhlaIjN2fX14U9w2kKgoIACBlkGYgCxcYcKo/Wk4q/ZX90cufgK10ztaqq1xLTi8d/
         x384Ylns/zmWiy1DSXJJpRJZ9ZkrFwo4hSmapHnPuHKoNkI4mRDG3sFOhL6GhKUABlAG
         odpXPLp5tQDXPSp+L2+T4pim+W0AW4j4KkUYOOzT2fYVA6EgBtxNp7Gd8nzquWFw4+9I
         qIZLcnAAr0FCzG5lMbt9aMh+GnA90ykJSsZscr+TCzFWKZAcZm46KErwRT1jW2M0X+QQ
         pKTw==
X-Gm-Message-State: AOJu0Ywwf7WP9EbvY7BavTFZf+gLNdcIXoKNTltVh5NbPQe1mIXP/xoU
	K/ZoBkHRleka5CC0LU6WQyUGr8BStj7cpw0rcTqp84WxpFhQFuT3HhAN1dwXswGwVYGvXlJd+/9
	PRkIU3oRAzrPITSSYFG8AHpm4
X-Received: by 2002:a05:6358:249d:b0:134:e603:116e with SMTP id m29-20020a056358249d00b00134e603116emr9678040rwc.6.1695098791617;
        Mon, 18 Sep 2023 21:46:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKkoLP87+mw9T8TQ8bjb6RIWKH/vCCTjI0tHPFOvwV8K6Ynikd7+Ff2EaTqVQJl8SE4ves7A==
X-Received: by 2002:a05:6358:249d:b0:134:e603:116e with SMTP id m29-20020a056358249d00b00134e603116emr9678018rwc.6.1695098791296;
        Mon, 18 Sep 2023 21:46:31 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id d3-20020a633603000000b0057749dc8d3asm196597pga.47.2023.09.18.21.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 21:46:30 -0700 (PDT)
Message-ID: <ad068df5-d5b1-030a-af25-723cd5c3b854@redhat.com>
Date: Tue, 19 Sep 2023 14:46:22 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 32/35] ACPI: add support to register CPUs based on
 the _STA enabled bit
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
 <20230913163823.7880-33-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-33-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/14/23 02:38, James Morse wrote:
> acpi_processor_get_info() registers all present CPUs. Registering a
> CPU is what creates the sysfs entries and triggers the udev
> notifications.
> 
> arm64 virtual machines that support 'virtual cpu hotplug' use the
> enabled bit to indicate whether the CPU can be brought online, as
> the existing ACPI tables require all hardware to be described and
> present.
> 
> If firmware describes a CPU as present, but disabled, skip the
> registration. Such CPUs are present, but can't be brought online for
> whatever reason. (e.g. firmware/hypervisor policy).
> 
> Once firmware sets the enabled bit, the CPU can be registered and
> brought online by user-space. Online CPUs, or CPUs that are missing
> an _STA method must always be registered.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/acpi_processor.c | 31 ++++++++++++++++++++++++++++++-
>   1 file changed, 30 insertions(+), 1 deletion(-)
> 

With below nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index b67616079751..b49859eab01a 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -227,6 +227,32 @@ static int acpi_processor_make_present(struct acpi_processor *pr)
>   	return ret;
>   }
>   
> +static int acpi_processor_make_enabled(struct acpi_processor *pr)
> +{
> +	unsigned long long sta;
> +	acpi_status status;
> +	bool present, enabled;
> +
> +	if (!acpi_has_method(pr->handle, "_STA"))
> +		return arch_register_cpu(pr->id);
> +
> +	status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	present = sta & ACPI_STA_DEVICE_PRESENT;
> +	enabled = sta & ACPI_STA_DEVICE_ENABLED;
> +
> +	if (cpu_online(pr->id) && (!present || !enabled)) {
> +		pr_err_once(FW_BUG "CPU %u is online, but described as not present or disabled!\n", pr->id);
> +		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
> +	} else if (!present || !enabled) {
> +		return -ENODEV;
> +	}
> +
> +	return arch_register_cpu(pr->id);
> +}
> +

The message needs to be split up into multiple lines to make ./scripts/checkpatch.pl
happy:

	pr_err_once(FW_BUG "CPU %u is online, but described "
			   "as not present or disabled!\n", pr->id);

>   static int acpi_processor_get_info(struct acpi_device *device)
>   {
>   	union acpi_object object = { 0 };
> @@ -318,7 +344,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>   	 */
>   	if (!invalid_logical_cpuid(pr->id) && cpu_present(pr->id) &&
>   	    !get_cpu_device(pr->id)) {
> -		int ret = arch_register_cpu(pr->id);
> +		int ret = acpi_processor_make_enabled(pr);
>   
>   		if (ret)
>   			return ret;
> @@ -526,6 +552,9 @@ static void acpi_processor_post_eject(struct acpi_device *device)
>   		acpi_processor_make_not_present(device);
>   		return;
>   	}
> +
> +	if (cpu_present(pr->id) && !(sta & ACPI_STA_DEVICE_ENABLED))
> +		arch_unregister_cpu(pr->id);
>   }
>   
>   #ifdef CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC

Thanks,
Gavin


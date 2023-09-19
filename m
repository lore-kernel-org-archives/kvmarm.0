Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A1D15A3
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695084350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LM15K8pzy7YjRbxMXPWyKscBPIcWYYmbRagei3+odA0=;
	b=O0q0H9DdO8u/Uss9z210rVZOi94Cq51I9fG4FwXSvwTxT4TIIYHBnKONKcf4DD/fzXGuo0
	WFTwdomtInS86oINylx60fNtxjzpCULwsGsK6geXE5b+AnwBCBKZyHTkm8inWnn+T0oXZ9
	rrpcu7B855Rp2I4lKJdCIn5aALBla1A=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-vYvIST5ePF68tzFsKMxeQw-1; Mon, 18 Sep 2023 20:45:48 -0400
X-MC-Unique: vYvIST5ePF68tzFsKMxeQw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-690a0eedb2aso896694b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695084347; x=1695689147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LM15K8pzy7YjRbxMXPWyKscBPIcWYYmbRagei3+odA0=;
        b=k4Ejdy4+wlftiCKX6kfkcWtxfBjooEBm7cqV0IIKqOGRbFtGcTNxNxbfjEHf0mGylJ
         p7dYc0MWlEXLsCBr+4IXrRPVaFvdOMSbB8wD/ItkNNHG83H65FC61HFEtrtjAx4Z0bVB
         dyLIVaus+iyePMf1bnI94oujJTpoAumIzj8SZfnvxe54dZng0/sbpXRP8cibO3fuI6aP
         E0z3kSTYsJBHbIfUdtkW0TOqrNlfacXUFUx54PrEzM52WYqE6zVzxDbcpeQD+JdLnltY
         kYg4JQCQJIKPTSuEQsI9Kiqx6w/oq3eiA5K1AAtiB93H5pWGji5boETvTZeQG3+99Tt/
         81LA==
X-Gm-Message-State: AOJu0YxszttWuEpNnEHBjQiFsCJYEHtkXjQLYFNu/B4Lr6U9PqnZJu68
	btLMWHVWBoiSevy/ko967sknLVSHBFcNhCnsgqkfozqXR80mImzykjVcN6Y5Vn18LNE1rm5m6nw
	NrMFF6TiF+5kyjdRM
X-Received: by 2002:a05:6a20:e126:b0:12e:98a3:77b7 with SMTP id kr38-20020a056a20e12600b0012e98a377b7mr11802953pzb.59.1695084346999;
        Mon, 18 Sep 2023 17:45:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbRMohfrQfu8U6nIU99dVCswPBycZA0RmEkJtJ+RPQwK7z3RIdFfhgC8+/M21E5Fme0WVGHQ==
X-Received: by 2002:a05:6a20:e126:b0:12e:98a3:77b7 with SMTP id kr38-20020a056a20e12600b0012e98a377b7mr11802939pzb.59.1695084346690;
        Mon, 18 Sep 2023 17:45:46 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b001b06c106844sm8833025plr.151.2023.09.18.17.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 17:45:45 -0700 (PDT)
Message-ID: <518859b1-64a9-d723-963c-56c7f6fc2da1@redhat.com>
Date: Tue, 19 Sep 2023 10:45:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 22/35] ACPI: Check _STA present bit before making
 CPUs not present
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
 <20230913163823.7880-23-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-23-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/23 02:38, James Morse wrote:
> When called acpi_processor_post_eject() unconditionally make a CPU
> not-present and unregisters it.
> 
> To add support for AML events where the CPU has become disabled, but
> remains present, the _STA method should be checked before calling
> acpi_processor_remove().
> 
> Rename acpi_processor_post_eject() acpi_processor_remove_possible(), and
> check the _STA before calling.
> 
> Adding the function prototype for arch_unregister_cpu() allows the
> preprocessor guards to be removed.
> 
> After this change CPUs will remain registered and visible to
> user-space as offline if buggy firmware triggers an eject-request,
> but doesn't clear the corresponding _STA bits after _EJ0 has been
> called.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/acpi_processor.c | 31 +++++++++++++++++++++++++------
>   include/linux/cpu.h           |  1 +
>   2 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index 00dcc23d49a8..2cafea1edc24 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -457,13 +457,12 @@ static int acpi_processor_add(struct acpi_device *device,
>   	return result;
>   }
>   
> -#ifdef CONFIG_ACPI_HOTPLUG_PRESENT_CPU
>   /* Removal */
> -static void acpi_processor_post_eject(struct acpi_device *device)
> +static void acpi_processor_make_not_present(struct acpi_device *device)
>   {
>   	struct acpi_processor *pr;
>   
> -	if (!device || !acpi_driver_data(device))
> +	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU))
>   		return;
>   

In order to use IS_ENABLED(),

>   	pr = acpi_driver_data(device);
> @@ -501,7 +500,29 @@ static void acpi_processor_post_eject(struct acpi_device *device)
>   	free_cpumask_var(pr->throttling.shared_cpu_map);
>   	kfree(pr);
>   }
> -#endif /* CONFIG_ACPI_HOTPLUG_PRESENT_CPU */
> +
> +static void acpi_processor_post_eject(struct acpi_device *device)
> +{
> +	struct acpi_processor *pr;
> +	unsigned long long sta;
> +	acpi_status status;
> +
> +	if (!device)
> +		return;
> +
> +	pr = acpi_driver_data(device);
> +	if (!pr || pr->id >= nr_cpu_ids || invalid_phys_cpuid(pr->phys_id))
> +		return;
> +

Do we really need to validate the logic and hardware CPU IDs here? I think
the ACPI processor device can't be added successfully if one of them is
invalid.

> +	status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
> +	if (ACPI_FAILURE(status))
> +		return;
> +
> +	if (cpu_present(pr->id) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
> +		acpi_processor_make_not_present(device);
> +		return;
> +	}
> +}
>   
>   #ifdef CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC
>   bool __init processor_physically_present(acpi_handle handle)
> @@ -626,9 +647,7 @@ static const struct acpi_device_id processor_device_ids[] = {
>   static struct acpi_scan_handler processor_handler = {
>   	.ids = processor_device_ids,
>   	.attach = acpi_processor_add,
> -#ifdef CONFIG_ACPI_HOTPLUG_PRESENT_CPU
>   	.post_eject = acpi_processor_post_eject,
> -#endif
>   	.hotplug = {
>   		.enabled = true,
>   	},
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index a71691d7c2ca..e117c06e0c6b 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -81,6 +81,7 @@ struct device *cpu_device_create(struct device *parent, void *drvdata,
>   				 const struct attribute_group **groups,
>   				 const char *fmt, ...);
>   extern int arch_register_cpu(int cpu);
> +extern void arch_unregister_cpu(int cpu);

arch_unregister_cpu() is protected by CONFIG_HOTPLUG_CPU in the individual architectures,
for example arch/ia64/kernel/topology.c

>   #ifdef CONFIG_HOTPLUG_CPU
>   extern void unregister_cpu(struct cpu *cpu);
>   extern ssize_t arch_cpu_probe(const char *, size_t);

Thanks,
Gavin


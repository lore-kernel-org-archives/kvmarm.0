Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93144163
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695086592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8rZEMBXcWAsOd1JUxhybBTc4j/duZaFTPteC/Fr9lkM=;
	b=Jb0J9KD2H5NUEGxdUcXDXWGTu8JCrsmqKoWKi+MFcxHA9vbD72fpBoeWjZ466Y3FkOMyIa
	uvKg5qHvs0AeJWIp4+ErLqDyRI4oqruZP7v4aNmeNf4FsOG4LnAZ/gu/7R34Ava6jaHkNB
	KL53mN+mVBxm4YHHUh6atNL9ZTt69c8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-9JO0CLrjO5aLRFawxSF4Cg-1; Mon, 18 Sep 2023 21:23:08 -0400
X-MC-Unique: 9JO0CLrjO5aLRFawxSF4Cg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c387a09de4so41272135ad.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 18:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695086588; x=1695691388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rZEMBXcWAsOd1JUxhybBTc4j/duZaFTPteC/Fr9lkM=;
        b=JHRjCAXpURsl/i2pp++0mTPCDJMsEtb37KBS41pzpuY7gglWEtamHiENkyfe9Qln+J
         xqsrZmCcn0DKlawiRu/rSKcPr1OQWaWZUfzwKC5V+1sIQCTd1+utrgU/KEjk7LoSNKbp
         87NpIcteEvehI2DG05FVLZMhq5Yg+/isCNBw7HdqT3VxE60ATILWDpPcldmMjYcmlTwz
         hhsMIfCuPijH93MlXNOhtGMizMAICNok+gnbWok6MVj/nUOQ2g3GT3kdhfOXPuINvnRI
         gfaZ++nlO0gNXMmYX20bZNtMH/ktNIQo6z4zkAYMG8QKRwAMcNMhN1pnmT9s57ZzSEiB
         4PGQ==
X-Gm-Message-State: AOJu0YyXdvySdGSqJbtPjXU6xNXL1+YQG2u8vLADjD7gPpnIv1EEkJny
	oFECrgSP79gsoEmSDOYjsJHssp4KJL3jyepV+ZDWm4TA8lLQpRH4oXY0fX6YWJW3fMkOijktqHM
	KMDcj12PfruDZuePs
X-Received: by 2002:a17:902:d4c7:b0:1c3:c687:4793 with SMTP id o7-20020a170902d4c700b001c3c6874793mr10025111plg.63.1695086587826;
        Mon, 18 Sep 2023 18:23:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoDFw/kgFjKPQwWTf0Oet8p5HAvy+YamWqASTKA/sRdSVgiuLoUsA4+OwthgzDWlhTMjCURQ==
X-Received: by 2002:a17:902:d4c7:b0:1c3:c687:4793 with SMTP id o7-20020a170902d4c700b001c3c6874793mr10025086plg.63.1695086587495;
        Mon, 18 Sep 2023 18:23:07 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b001beef2c9bffsm8873509plg.85.2023.09.18.18.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 18:23:06 -0700 (PDT)
Message-ID: <f45820cf-3ea5-6f5a-7702-bb4b14811e56@redhat.com>
Date: Tue, 19 Sep 2023 11:23:00 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 28/35] arm64, irqchip/gic-v3, ACPI: Move MADT GICC
 enabled check into a helper
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
 <20230913163823.7880-29-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-29-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/23 02:38, James Morse wrote:
> ACPI, irqchip and the architecture code all inspect the MADT
> enabled bit for a GICC entry in the MADT.
> 
> The addition of an 'online capable' bit means all these sites need
> updating.
> 
> Move the current checks behind a helper to make future updates easier.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   arch/arm64/kernel/smp.c       |  2 +-
>   drivers/acpi/processor_core.c |  2 +-
>   drivers/irqchip/irq-gic-v3.c  | 10 ++++------
>   include/linux/acpi.h          |  5 +++++
>   4 files changed, 11 insertions(+), 8 deletions(-)
> 

With Jonathan and Russell's comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 960b98b43506..8c8f55721786 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -520,7 +520,7 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
>   {
>   	u64 hwid = processor->arm_mpidr;
>   
> -	if (!(processor->flags & ACPI_MADT_ENABLED)) {
> +	if (!acpi_gicc_is_usable(processor)) {
>   		pr_debug("skipping disabled CPU entry with 0x%llx MPIDR\n", hwid);
>   		return;
>   	}
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 7dd6dbaa98c3..b203cfe28550 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -90,7 +90,7 @@ static int map_gicc_mpidr(struct acpi_subtable_header *entry,
>   	struct acpi_madt_generic_interrupt *gicc =
>   	    container_of(entry, struct acpi_madt_generic_interrupt, header);
>   
> -	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +	if (!acpi_gicc_is_usable(gicc))
>   		return -ENODEV;
>   
>   	/* device_declaration means Device object in DSDT, in the
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index eedfa8e9f077..72d3cdebdad1 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -2367,8 +2367,7 @@ gic_acpi_parse_madt_gicc(union acpi_subtable_headers *header,
>   	u32 size = reg == GIC_PIDR2_ARCH_GICv4 ? SZ_64K * 4 : SZ_64K * 2;
>   	void __iomem *redist_base;
>   
> -	/* GICC entry which has !ACPI_MADT_ENABLED is not unusable so skip */
> -	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +	if (!acpi_gicc_is_usable(gicc))
>   		return 0;
>   
>   	redist_base = ioremap(gicc->gicr_base_address, size);
> @@ -2418,7 +2417,7 @@ static int __init gic_acpi_match_gicc(union acpi_subtable_headers *header,
>   	 * If GICC is enabled and has valid gicr base address, then it means
>   	 * GICR base is presented via GICC
>   	 */
> -	if ((gicc->flags & ACPI_MADT_ENABLED) && gicc->gicr_base_address) {
> +	if (acpi_gicc_is_usable(gicc) && gicc->gicr_base_address) {
>   		acpi_data.enabled_rdists++;
>   		return 0;
>   	}
> @@ -2427,7 +2426,7 @@ static int __init gic_acpi_match_gicc(union acpi_subtable_headers *header,
>   	 * It's perfectly valid firmware can pass disabled GICC entry, driver
>   	 * should not treat as errors, skip the entry instead of probe fail.
>   	 */
> -	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +	if (!acpi_gicc_is_usable(gicc))
>   		return 0;
>   
>   	return -ENODEV;
> @@ -2486,8 +2485,7 @@ static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_headers *hea
>   	int maint_irq_mode;
>   	static int first_madt = true;
>   
> -	/* Skip unusable CPUs */
> -	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +	if (!acpi_gicc_is_usable(gicc))
>   		return 0;
>   
>   	maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index b7ab85857bb7..e3265a9eafae 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -256,6 +256,11 @@ acpi_table_parse_cedt(enum acpi_cedt_type id,
>   int acpi_parse_mcfg (struct acpi_table_header *header);
>   void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
>   
> +static inline bool acpi_gicc_is_usable(struct acpi_madt_generic_interrupt *gicc)
> +{
> +	return (gicc->flags & ACPI_MADT_ENABLED);
> +}
> +
>   /* the following numa functions are architecture-dependent */
>   void acpi_numa_slit_init (struct acpi_table_slit *slit);
>   

Thanks,
Gavin


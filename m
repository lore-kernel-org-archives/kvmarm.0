Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418AB20F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682945678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgdmqBY0YjJMLmIVk6Rr3PdJT6nU128ngcp31lhBDX4=;
	b=ITPOAtNnpVNwNYr9ddPdxZD1NrpaKinEkaXqHPdsglvz/4PhFqGBxGem8FJJnk4q/unas5
	nN52H864GrUzAAHC98livPjh5HZq4ti78dzg8iQdg8otQ0N8Srva0+8AjdxcHSSCZh2YGV
	CWs9eCyK/r+bnOp51QyLUK4BaWG3yPY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-xwUP0QbfN1i5CNAuJ2rcCQ-1; Mon, 01 May 2023 08:54:36 -0400
X-MC-Unique: xwUP0QbfN1i5CNAuJ2rcCQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-517f0c08dfaso388864a12.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945675; x=1685537675;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgdmqBY0YjJMLmIVk6Rr3PdJT6nU128ngcp31lhBDX4=;
        b=RymatKt5veTaRWEL1mWEPmSo5QN6EhLH8kZtgbZoKfVSjYLk2YSh9T+XE0uQhSHdP5
         BMvTODN3PCunhVF7wAA3VDYRGBFXu156YsMMu/+3qFgDcyj8H2YOgdc/wk2euU3SaHi+
         q1aGzfDjx4rWj1Jm7pXCFYq1y/pyh77jwGDfRH4G9ITfejxwQqVbJu/WVsL6QsmGXZx8
         0IdbK6LxXBuoN6/kt/FpDaKBv+Fn8wuqPGJpRKlbDwLY58KRZNCBLwCIUso5PTtFFKht
         4tPtrxeyb+WAUddkuAjH1sYSFiDmSF8aryobJFiFzd9/DsKNq1Anj6W5kmkwEjy3vVHu
         BmCw==
X-Gm-Message-State: AC+VfDzEFodgVrTA0nf88AdrszaaoB+iXLwCRILtqWCAplM2iMBr3H38
	pxVcMVRoy2/l9cIl8LHY5Zm2MKY47JqFkktQnHeCoKLM+9e0egA5y+jmRwXDsGDuGS+iSdQkgDP
	F0MkTRQxh7vlyQmxF
X-Received: by 2002:a17:902:d481:b0:1a0:53ba:ff1f with SMTP id c1-20020a170902d48100b001a053baff1fmr16476725plg.0.1682945675718;
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4J+QM0YnCda+sWscx2w8AQROtBQpbpmp8HjRM9lsCt7CrVjf5kKI/bjaojW6SytadGqh2NNw==
X-Received: by 2002:a17:902:d481:b0:1a0:53ba:ff1f with SMTP id c1-20020a170902d48100b001a053baff1fmr16476709plg.0.1682945675446;
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902dac500b00199203a4fa3sm6381858plx.203.2023.05.01.05.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
Message-ID: <70a380b5-b97c-2e39-d91f-c1bfa76e1521@redhat.com>
Date: Mon, 1 May 2023 20:54:31 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 11/29] arm64: Add support for setting up
 the PSCI conduit through ACPI
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
 Andrew Jones <drjones@redhat.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-12-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-12-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the FADT to discover whether PSCI calls need to use smc or hvc
> calls. This change implements this but retains the default behavior;
> we check if a valid DT is provided, if not, we try to setup the PSCI
> conduit using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/Makefile.arm64 |  4 ++++
>   lib/acpi.h         |  5 +++++
>   lib/arm/psci.c     | 37 ++++++++++++++++++++++++++++++++++++-
>   3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 42e18e77..6dff6cad 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -25,6 +25,10 @@ cflatobjs += lib/arm64/processor.o
>   cflatobjs += lib/arm64/spinlock.o
>   cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>   
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs += lib/acpi.o
> +endif
> +
>   OBJDIRS += lib/arm64
>   
>   # arm64 specific tests
> diff --git a/lib/acpi.h b/lib/acpi.h
> index b714677e..ef4a8e1d 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -129,6 +129,11 @@ struct acpi_table_fadt {
>   	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
>   };
>   
> +/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
> +
> +#define ACPI_FADT_PSCI_COMPLIANT    (1)	/* 00: [V5+] PSCI 0.2+ is implemented */
> +#define ACPI_FADT_PSCI_USE_HVC      (1<<1)	/* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
> +
>   struct acpi_table_facs_rev1 {
>   	u32 signature;		/* ACPI Signature */
>   	u32 length;		/* Length of structure, in bytes */
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 9c031a12..bddb0787 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -56,7 +56,7 @@ void psci_system_off(void)
>   	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>   }
>   
> -void psci_set_conduit(void)
> +static void psci_set_conduit_fdt(void)
>   {
>   	const void *fdt = dt_fdt();
>   	const struct fdt_property *method;
> @@ -75,3 +75,38 @@ void psci_set_conduit(void)
>   	else
>   		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
>   }
> +
> +#ifdef CONFIG_EFI
> +
> +#include <acpi.h>
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +
> +	assert_msg(fadt, "Unable to find ACPI FADT");
> +	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> +		   "PSCI is not supported in this platform");
> +
> +	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
> +		psci_invoke = psci_invoke_hvc;
> +	else
> +		psci_invoke = psci_invoke_smc;
> +}
> +
> +#else
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif
> +
> +void psci_set_conduit(void)
> +{
> +	if (dt_available())
> +		psci_set_conduit_fdt();
> +	else
> +		psci_set_conduit_acpi();
> +}

-- 
Shaoqin


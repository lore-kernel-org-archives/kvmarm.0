Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325520F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682945728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1+TaR5oCB/ZW+nk2URwcl1uXQGFB/v6cUjv6KgffBaM=;
	b=Akoc6n7VYelzJafRg49nDi3ZlNZDJelEqEJkXA/Z6FvKXEBUVBZ5E/J4b92UAJkICjPsTJ
	Qoa03UC8CVZfjN39BiYWbD4HxtGbw/Vrk7nuRzLwOKm9jMsCgeyDqp/kWZ1djtf9Hn5/Rt
	eZoKFr5gPOiXfyfjQ3/zPb7zbLCKFTM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-Vl6zmNUwO92hRueSHy9izA-1; Mon, 01 May 2023 08:55:27 -0400
X-MC-Unique: Vl6zmNUwO92hRueSHy9izA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-24677161cf7so608678a91.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945726; x=1685537726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+TaR5oCB/ZW+nk2URwcl1uXQGFB/v6cUjv6KgffBaM=;
        b=LA6vm4mX2M76k4wnuOZ/4SnVBvi9lmxnLHQAM27tkBJWfJt1V3kDT/ct/+u1Ke2t1/
         mF/CPu2nw4kiwFw0qDHIXIa2gMZqP8zu1fyOCXxk5FplQCVctvJWhjEiyHiJKBnCwFgp
         +yQe+C+v7ZZUgPIeWD6YJmeFUkNolPpVv3i9DL6PNQfq6IOwjq1rb9X+9jQvb9LpX58u
         dBFmN+mFfTXjroiJSpm6tJx4xuNgj3jGhoTfvarnGJpkusOA/8ayqZNIGCqfECJ6/aRp
         nxRJZSVYMX5UWnTvQ9if4IbJXTgB2NEY2KWoPZyHqtT56/PulunfgMIDku/3lqfoE/zv
         WcEA==
X-Gm-Message-State: AC+VfDxGIgyjXT/qegf3kNnWY+zcEqi1MiXsAEF8+IPlrIRFOVGUCfCg
	589b0GoIGlUjsIkEVULxnoecEX6v3TpkaAdQ6SGwYmM1G9Xa0SsjO6TWgjaHz/yI64RLkWs0lRr
	D4VV1E46NhlB3BiSBKAJU3tHDgskGwA==
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17258719pzb.5.1682945725798;
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ67lH3AoGHejR5vkIwpaHeteJYpyTmHgkg6qoz0NH+VL8nz9qTF5Pa8GvcKpZNiN+UwOMExnQ==
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17258706pzb.5.1682945725502;
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w68-20020a636247000000b00520f4ecd71esm17144243pgb.93.2023.05.01.05.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
Message-ID: <e7407747-c0fb-7d6a-4a64-3d29fcdb72e4@redhat.com>
Date: Mon, 1 May 2023 20:55:21 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 12/29] arm64: Add support for
 discovering the UART through ACPI
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-13-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-13-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the SPCR to discover the serial port address range. This change
> implements this but retains the default behavior; we check if a valid
> DT is provided, if not, we try to discover the UART using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h   | 25 +++++++++++++++++++++++++
>   lib/arm/io.c | 34 +++++++++++++++++++++++++++++-----
>   2 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index ef4a8e1d..54ed9ef7 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -17,6 +17,7 @@
>   #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>   
>   #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
>   	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
> @@ -145,6 +146,30 @@ struct acpi_table_facs_rev1 {
>   	u8 reserved3[40];	/* Reserved - must be zero */
>   };
>   
> +struct spcr_descriptor {
> +	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
> +	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
> +	u8 reserved[3];
> +	struct acpi_generic_address serial_port;
> +	u8 interrupt_type;
> +	u8 pc_interrupt;
> +	u32 interrupt;
> +	u8 baud_rate;
> +	u8 parity;
> +	u8 stop_bits;
> +	u8 flow_control;
> +	u8 terminal_type;
> +	u8 reserved1;
> +	u16 pci_device_id;
> +	u16 pci_vendor_id;
> +	u8 pci_bus;
> +	u8 pci_device;
> +	u8 pci_function;
> +	u32 pci_flags;
> +	u8 pci_segment;
> +	u32 reserved2;
> +};
> +
>   #pragma pack(0)
>   
>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e1082..19f93490 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -29,7 +29,7 @@ static struct spinlock uart_lock;
>   #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>   static volatile u8 *uart0_base = UART_EARLY_BASE;
>   
> -static void uart0_init(void)
> +static void uart0_init_fdt(void)
>   {
>   	/*
>   	 * kvm-unit-tests uses the uart only for output. Both uart models have
> @@ -65,17 +65,41 @@ static void uart0_init(void)
>   	}
>   
>   	uart0_base = ioremap(base.addr, base.size);
> +}
> +
> +#ifdef CONFIG_EFI
> +
> +#include <acpi.h>
> +
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> +
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> +}
> +#else
> +
> +static void uart0_init_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif
> +
> +void io_init(void)
> +{
> +	if (dt_available())
> +		uart0_init_fdt();
> +	else
> +		uart0_init_acpi();
>   
>   	if (uart0_base != UART_EARLY_BASE) {
>   		printf("WARNING: early print support may not work. "
>   		       "Found uart at %p, but early base is %p.\n",
>   			uart0_base, UART_EARLY_BASE);
>   	}
> -}
>   
> -void io_init(void)
> -{
> -	uart0_init();
>   	chr_testdev_init();
>   }
>   

-- 
Shaoqin


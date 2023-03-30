Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158421C05
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 06:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680158807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2Lu2p8xaiftb4OTX9kXdBQYcEW+MwWgIlLGAAXm/D4=;
	b=K4QVMcFJ3/jYJuzooxh6oxMzXpi0WPWlPJFOlIn7NHg/R/lmYrdjMYMWznTwUXb6//HKMD
	x6Vww3PNwJw4Hs5eEtZ59LehWmCbBq3E0YvMttph77eHON52iYTlfry/HlXL57eXFNBExD
	KhXMd2M6tb+467SSvjEmDXwg9Hfoh2Y=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-iMgbulzXOyKax3xvsrFYcQ-1; Thu, 30 Mar 2023 02:46:46 -0400
X-MC-Unique: iMgbulzXOyKax3xvsrFYcQ-1
Received: by mail-pf1-f197.google.com with SMTP id x3-20020a62fb03000000b00622df3f5d0cso8431463pfm.10
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 23:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2Lu2p8xaiftb4OTX9kXdBQYcEW+MwWgIlLGAAXm/D4=;
        b=KYF+PVyaYvYvPfHC242E0g6z/9y90ke0kGMMg7N/SF/9R3g2xXdwGN5BdZ3/PSQrSx
         EIEpAIZXIDOWsf8nBHH1OomJPI5DeBhE7LalV7C78bGtRIjrD7zYtchV6dh4EsU72L2z
         T04wnPNY6e+breJ4iYZdN+ToeNvtOXYvJKr9YY78H+yNqlVrXttRQU3vr3PC7yQDGH0F
         PC5OkmvusS5ojd2qVkVLdXV9IhQ4buiAyv7mSbbvGkMAjINitdl1ksFU+l3Eko/bsfWT
         oDhRzvVqgr9KYRM4pY44sSiV4FJrflD6APf1i/Irdr9Kjv1wguYk1KzjTHcZjvSC+3kX
         KKVQ==
X-Gm-Message-State: AAQBX9eaxa0Yz1bxNoUErDVoSSCHTEwsX+jYLtGzFfHv1vRrkqhYWtOP
	z7z1zZxU17DklrmayOj4buD2r+/5BK7q+Yv666KH3NKq8YZ0wZvGQwhugzEwRv65sJP6I9ewcum
	1G1UIm7n+ofjoM/5T
X-Received: by 2002:a05:6a20:7da6:b0:c0:2875:9e8c with SMTP id v38-20020a056a207da600b000c028759e8cmr1213778pzj.1.1680158805444;
        Wed, 29 Mar 2023 23:46:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z42Ql+MfW3NYKeuJ6HJp+/RvlwL24iB52Wp06xn7wfu7g6k/pvbrNdoR2jKqhEQe0s8IMNaQ==
X-Received: by 2002:a05:6a20:7da6:b0:c0:2875:9e8c with SMTP id v38-20020a056a207da600b000c028759e8cmr1213758pzj.1.1680158804973;
        Wed, 29 Mar 2023 23:46:44 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x4-20020aa784c4000000b0062a7462d398sm12617428pfn.170.2023.03.29.23.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 23:46:44 -0700 (PDT)
Message-ID: <4af8a2c9-f808-f727-2185-277eb7ef7d77@redhat.com>
Date: Thu, 30 Mar 2023 14:46:39 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 16/30] arm64: Add support for gic initialization
 through ACPI
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-17-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-17-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nikos,

On 2/13/23 18:17, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the MADTs to figure out if it implements a GICv2 or a GICv3 and
> discover the GIC parameters. This change implements this but retains
> the default behavior; we check if a valid DT is provided, if not, we
> try to discover the cores in the system using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   lib/acpi.c     |   9 +++-
>   lib/acpi.h     |  46 +++++++++++++++-
>   lib/arm/gic.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   lib/libcflat.h |   1 +
>   4 files changed, 191 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/acpi.c b/lib/acpi.c
> index bbe33d08..760cd8b2 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -103,11 +103,12 @@ void *find_acpi_table_addr(u32 sig)
>   	return NULL;
>   }
>   
> -void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
> +int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
>   {
>   	struct acpi_table_madt *madt;
>   	struct acpi_subtable_header *header;
>   	void *end;
> +	int count = 0;
>   
>   	madt = find_acpi_table_addr(MADT_SIGNATURE);
>   	assert(madt);
> @@ -116,9 +117,13 @@ void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler
>   	end = (void *)((ulong) madt + madt->length);
>   
>   	while ((void *)header < end) {
> -		if (header->type == mtype)
> +		if (header->type == mtype) {
>   			handler(header);
> +			count++;
> +		}
>   
>   		header = (void *)(ulong) header + header->length;
>   	}
> +
> +	return count;
>   }
> diff --git a/lib/acpi.h b/lib/acpi.h
> index af02fd83..a2c0f982 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -184,6 +184,50 @@ struct acpi_madt_generic_interrupt {
>   	u16 spe_interrupt;	/* ACPI 6.3 */
>   };
>   
> +#define ACPI_MADT_ENABLED           (1)	/* 00: Processor is usable if set */
This macro has been defined in previous patch, so at here we don't need 
to add it again.

Thanks,
Shaoqin

> +
> +/* 12: Generic Distributor (ACPI 5.0 + ACPI 6.0 changes) */
> +
> +struct acpi_madt_generic_distributor {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u32 gic_id;
> +	u64 base_address;
> +	u32 global_irq_base;
> +	u8 version;
> +	u8 reserved2[3];	/* reserved - must be zero */
> +};
> +
> +/* Values for Version field above */
> +
> +enum acpi_madt_gic_version {
> +	ACPI_MADT_GIC_VERSION_NONE = 0,
> +	ACPI_MADT_GIC_VERSION_V1 = 1,
> +	ACPI_MADT_GIC_VERSION_V2 = 2,
> +	ACPI_MADT_GIC_VERSION_V3 = 3,
> +	ACPI_MADT_GIC_VERSION_V4 = 4,
> +	ACPI_MADT_GIC_VERSION_RESERVED = 5	/* 5 and greater are reserved */
> +};
> +
> +/* 14: Generic Redistributor (ACPI 5.1) */
> +
> +struct acpi_madt_generic_redistributor {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u64 base_address;
> +	u32 length;
> +};
> +
> +/* 15: Generic Translator (ACPI 6.0) */
> +
> +struct acpi_madt_generic_translator {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u32 translation_id;
> +	u64 base_address;
> +	u32 reserved2;
> +};
> +
>   /* Values for MADT subtable type in struct acpi_subtable_header */
>   
>   enum acpi_madt_type {
> @@ -254,6 +298,6 @@ struct acpi_table_gtdt {
>   
>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
>   void *find_acpi_table_addr(u32 sig);
> -void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
> +int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
>   
>   #endif
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 1bfcfcfb..8fc5596f 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -3,6 +3,7 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> +#include <acpi.h>
>   #include <devicetree.h>
>   #include <asm/gic.h>
>   #include <asm/io.h>
> @@ -120,7 +121,7 @@ int gic_version(void)
>   	return 0;
>   }
>   
> -int gic_init(void)
> +static int gic_init_fdt(void)
>   {
>   	if (gicv2_init()) {
>   		gic_common_ops = &gicv2_common_ops;
> @@ -133,6 +134,142 @@ int gic_init(void)
>   	return gic_version();
>   }
>   
> +#ifdef CONFIG_EFI
> +
> +#define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
> +#define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
> +#define ACPI_GICV3_DIST_MEM_SIZE	(SZ_64K)
> +#define ACPI_GICV3_ITS_MEM_SIZE		(SZ_128K)
> +
> +static int gic_acpi_version(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +	int version = dist->version;
> +
> +	if (version == 2)
> +		gic_common_ops = &gicv2_common_ops;
> +	else if (version == 3)
> +		gic_common_ops = &gicv3_common_ops;
> +
> +	return version;
> +}
> +
> +static int gicv2_acpi_parse_madt_cpu(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_interrupt *gicc = (void *)header;
> +	static phys_addr_t gicc_base_address;
> +
> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +		return 0;
> +
> +	if (!gicc_base_address) {
> +		gicc_base_address = gicc->base_address;
> +		gicv2_data.cpu_base = ioremap(gicc_base_address, ACPI_GIC_CPU_IF_MEM_SIZE);
> +	}
> +	assert(gicc_base_address == gicc->base_address);
> +
> +	return 0;
> +}
> +
> +static int gicv2_acpi_parse_madt_dist(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +
> +	gicv2_data.dist_base = ioremap(dist->base_address, ACPI_GICV2_DIST_MEM_SIZE);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_gicc(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_interrupt *gicc = (void *)header;
> +	static phys_addr_t gicr_base_address;
> +
> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +		return 0;
> +
> +	if (!gicr_base_address) {
> +		gicr_base_address = gicc->gicr_base_address;
> +		gicv3_data.redist_bases[0] = ioremap(gicr_base_address, SZ_64K * 2);
> +	}
> +	assert(gicr_base_address == gicc->gicr_base_address);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_dist(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +
> +	gicv3_data.dist_base = ioremap(dist->base_address, ACPI_GICV3_DIST_MEM_SIZE);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_redist(struct acpi_subtable_header *header)
> +{
> +	static int i;
> +	struct acpi_madt_generic_redistributor *redist = (void *)header;
> +
> +	gicv3_data.redist_bases[i++] = ioremap(redist->base_address, redist->length);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_its(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_translator *its_entry = (void *)header;
> +
> +	its_data.base = ioremap(its_entry->base_address, ACPI_GICV3_ITS_MEM_SIZE - 1);
> +
> +	return 0;
> +}
> +
> +static int gic_init_acpi(void)
> +{
> +	int count;
> +
> +	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR, gic_acpi_version);
> +	if (gic_version() == 2) {
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				     gicv2_acpi_parse_madt_cpu);
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> +				      gicv2_acpi_parse_madt_dist);
> +	} else if (gic_version() == 3) {
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> +				      gicv3_acpi_parse_madt_dist);
> +		count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
> +					      gicv3_acpi_parse_madt_redist);
> +		if (!count)
> +			acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +					      gicv3_acpi_parse_madt_gicc);
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
> +				      gicv3_acpi_parse_madt_its);
> +#ifdef __aarch64__
> +		its_init();
> +#endif
> +	}
> +
> +	return gic_version();
> +}
> +
> +#else
> +
> +static int gic_init_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif /* CONFIG_EFI */
> +
> +int gic_init(void)
> +{
> +	if (dt_available())
> +		return gic_init_fdt();
> +	else
> +		return gic_init_acpi();
> +}
> +
>   void gic_enable_defaults(void)
>   {
>   	if (!gic_common_ops) {
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index c1fd31ff..700f4352 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -161,6 +161,7 @@ extern void setup_vm(void);
>   #define SZ_8K			(1 << 13)
>   #define SZ_16K			(1 << 14)
>   #define SZ_64K			(1 << 16)
> +#define SZ_128K			(1 << 17)
>   #define SZ_1M			(1 << 20)
>   #define SZ_2M			(1 << 21)
>   #define SZ_1G			(1 << 30)

-- 
Shaoqin


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96D120F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682945406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3iw82CyMoD7YAxWR67GetD4g91TZa4Cu6O8orjFfOnI=;
	b=UcT8pwDXOjaJlzvOpH3SxgV9E0DO4i/2Yd8JIBJshk7hpfVXSBHgU1UhNA3kajjCKwthP/
	MHWye/4QB2kQy2Fxu4TsuBCv+6u/cBOoh9sEt+shA0jA6/a0yD53QCIMt8ABYjewqTyBuD
	+qnPyqLgrCxDBzsCZndPRtPByBCv35E=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-h_6ottoVMSasFpnBvKAXFA-1; Mon, 01 May 2023 08:50:05 -0400
X-MC-Unique: h_6ottoVMSasFpnBvKAXFA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1a6a5debce1so1242035ad.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945404; x=1685537404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3iw82CyMoD7YAxWR67GetD4g91TZa4Cu6O8orjFfOnI=;
        b=G4PGU27EO/BHF016YJIC8EMdlqFYnn8ZnjjATIp9uS4K7ckm4eRPTDzRNGXfbwg4Ev
         1nJDoxkLdYTjZvy+iFTjrBpEUXP0SupvncOlGEJJZ8q2iSZloubdxOaXFuaMP9+/Yxyc
         I0m65DxbRtlPssUJffTnjZ1TxM0sWKFK9AvWaf9+z2EFLrwnjlWT1rI54x8C5bEfE6c4
         SVaJBnt2OhdgDs+QdoXcvL1J5XPA0Wp0EqjSsHFiUCSRzdRAoSn/DUpkskBRNa3RRjbo
         c4JGK48SDwcKVyTGedpEPd4F/i9S48VNoAXugV6HBVnQeowM1TSWJ47pWAdPBj/QyVXg
         7bAA==
X-Gm-Message-State: AC+VfDx02oyRkwUf82PCj0YuhniYlS4xUWdbdCbxXmjKsOnLd27uspET
	bitlDCGA1NAF1UvGiYq9vLA1b7x5uYYVVcMeQ/XK8/Ejrwmvhv6MwTunkA9bvOQvudvkBDMj8me
	0d0JASXxpr3j+8oK1
X-Received: by 2002:a17:902:e884:b0:1a9:4b42:a5a2 with SMTP id w4-20020a170902e88400b001a94b42a5a2mr16958651plg.0.1682945404449;
        Mon, 01 May 2023 05:50:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hLsYhrpTS7TpKIxVEzd72XjAjayhEL9KdK5wFScygTsjWxQlOnV7x4nYisp+DEcuydj+m2w==
X-Received: by 2002:a17:902:e884:b0:1a9:4b42:a5a2 with SMTP id w4-20020a170902e88400b001a94b42a5a2mr16958630plg.0.1682945404121;
        Mon, 01 May 2023 05:50:04 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bi6-20020a170902bf0600b001a67a37beeesm446298plb.139.2023.05.01.05.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:50:03 -0700 (PDT)
Message-ID: <f7d456ec-becf-8461-8b5b-d76bbfe9d431@redhat.com>
Date: Mon, 1 May 2023 20:50:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 04/29] lib: Fix style for acpi.{c,h}
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-5-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-5-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> Manually fix style issues to make the files consistent with the kernel
> coding style.
> 
> Zero-length array members have been replaced with flexible array members
> (for details about the motivation, consult
> Documentation/process/deprecated.rst in the Linux tree, the section about
> zero-length and one-element arrays).
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> [ Alex E: changes other than indentation ]
> ---
>   lib/acpi.h | 18 +++++++++---------
>   lib/acpi.c | 16 ++++++++--------
>   2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index b67bbe19..2da49451 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -3,7 +3,7 @@
>   
>   #include "libcflat.h"
>   
> -#define ACPI_SIGNATURE(c1, c2, c3, c4)				\
> +#define ACPI_SIGNATURE(c1, c2, c3, c4) \
>   	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
>   
>   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
> @@ -11,9 +11,9 @@
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>   
> -#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
> -	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |		\
> -	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
> +#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
> +	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
> +	 ((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32))
>   
>   #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
>   
> @@ -34,20 +34,20 @@ struct rsdp_descriptor {	/* Root System Descriptor Pointer */
>   	u32 length;			/* Length of table, in bytes, including header */ \
>   	u8  revision;			/* ACPI Specification minor version # */	\
>   	u8  checksum;			/* To make sum of entire table == 0 */		\
> -	u8  oem_id [6];			/* OEM identification */			\
> -	u8  oem_table_id [8];		/* OEM table identification */			\
> +	u8  oem_id[6];			/* OEM identification */			\
> +	u8  oem_table_id[8];		/* OEM table identification */			\
>   	u32 oem_revision;		/* OEM revision number */			\
> -	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
> +	u8  asl_compiler_id[4];		/* ASL compiler vendor ID */			\
>   	u32 asl_compiler_revision;	/* ASL compiler revision number */
>   
>   struct acpi_table {
>   	ACPI_TABLE_HEADER_DEF
> -	char data[0];
> +	char data[];
>   };
>   
>   struct rsdt_descriptor_rev1 {
>   	ACPI_TABLE_HEADER_DEF
> -	u32 table_offset_entry[1];
> +	u32 table_offset_entry[];
>   };
>   
>   struct fadt_descriptor_rev1 {
> diff --git a/lib/acpi.c b/lib/acpi.c
> index 836156a1..3f87711a 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -11,9 +11,9 @@ void set_efi_rsdp(struct rsdp_descriptor *rsdp)
>   
>   static struct rsdp_descriptor *get_rsdp(void)
>   {
> -	if (efi_rsdp == NULL) {
> +	if (efi_rsdp == NULL)
>   		printf("Can't find RSDP from UEFI, maybe set_efi_rsdp() was not called\n");
> -	}
> +
>   	return efi_rsdp;
>   }
>   #else
> @@ -28,9 +28,8 @@ static struct rsdp_descriptor *get_rsdp(void)
>   			break;
>   	}
>   
> -	if (addr == 0x100000) {
> +	if (addr == 0x100000)
>   		return NULL;
> -	}
>   
>   	return rsdp;
>   }
> @@ -38,18 +37,18 @@ static struct rsdp_descriptor *get_rsdp(void)
>   
>   void *find_acpi_table_addr(u32 sig)
>   {
> -	struct rsdp_descriptor *rsdp;
>   	struct rsdt_descriptor_rev1 *rsdt;
> +	struct rsdp_descriptor *rsdp;
>   	void *end;
>   	int i;
>   
>   	/* FACS is special... */
>   	if (sig == FACS_SIGNATURE) {
>   		struct fadt_descriptor_rev1 *fadt;
> +
>   		fadt = find_acpi_table_addr(FACP_SIGNATURE);
>   		if (!fadt)
>   			return NULL;
> -
>   		return (void *)(ulong) fadt->firmware_ctrl;
>   	}
>   
> @@ -72,9 +71,10 @@ void *find_acpi_table_addr(u32 sig)
>   	end = (void *)rsdt + rsdt->length;
>   	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
>   		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> -		if (t && t->signature == sig) {
> +
> +		if (t && t->signature == sig)
>   			return t;
> -		}
>   	}
> +
>   	return NULL;
>   }

-- 
Shaoqin


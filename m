Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F48C20F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682945445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hmWKjTfPWozKNY5pZlEsns0HcCjw26XANhiIewwyQFg=;
	b=XXtF3tZRyrhcudgu9/bQUvjbYUb3qyes/voWdD33rUSpF9jzJzxozQSSrOThRoaf4bvxwf
	OPBPbDe5aZNNbH9gT6uo+89OM67xBZ+0iMKO1E4g/zV8WX5C6z0yENpTNp81C6d1pS9fPi
	t1TzSGwMEMcTR+m5M2cQ52nnz9szY9g=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-1wCO6ncVMn6yaZ68jcRekA-1; Mon, 01 May 2023 08:50:42 -0400
X-MC-Unique: 1wCO6ncVMn6yaZ68jcRekA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-63c8d6ba628so597769b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945441; x=1685537441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmWKjTfPWozKNY5pZlEsns0HcCjw26XANhiIewwyQFg=;
        b=LAPxZFlcIlUasWjoS+cKFb0Mqy/1uSPVpa3Q51lYTfkV9Kt/7tqUlkLMpaosJkwjPd
         0iHSuLr5PuBevztd/M3vVHJTIZ5I4p2ujJwN036bwMeT5f+INle+khhtQjjWDLGOvKQP
         HfM9Bbu0Sm4zR+8EJHpwU6hVkE8wiX/Bavac6YojzCorRVhcMirOM5PZYdj1HHgJSj/A
         LSaJ7tU5BKxVfCPdg8vxNLtYk5z4UzrzLKRttOLBuM9cJ/cxUUKpNa12DEcC2sP980IU
         W028tNj/vGQCoIgWibFmLoBL0aQdz1lv2UthBEhpZZXy6OTrIT8EqXAK2DH5a4md+J//
         QVbA==
X-Gm-Message-State: AC+VfDyKQwkhf3k/jXTaEFDu2lV0pgwi0wb3LOQVa96LsboZpb8TpHBH
	aiWt4POruGmiez6HF2AL6gYErKl4HGFD950/H9/rG+yuEMcgnh+Q0BsQABtoC4Tn8Gt2lJJkatk
	wbm6IhaiSeP8wgQYn
X-Received: by 2002:a05:6a00:1391:b0:635:4f6:2f38 with SMTP id t17-20020a056a00139100b0063504f62f38mr13612621pfg.2.1682945440804;
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6N+vED0Om8+7La0+7ffuM42KXD2f9atEzLTGfkptdleRUX13rQMQJnmeVIx5GtEqhGFFxQsQ==
X-Received: by 2002:a05:6a00:1391:b0:635:4f6:2f38 with SMTP id t17-20020a056a00139100b0063504f62f38mr13612606pfg.2.1682945440563;
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3-20020a628603000000b0063d666566d1sm19825093pfd.72.2023.05.01.05.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
Message-ID: <b3f7fd03-b5c3-41f3-149c-ac26a59ce9fe@redhat.com>
Date: Mon, 1 May 2023 20:50:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 08/29] lib/acpi: Add support for the
 XSDT table
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-9-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-9-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> XSDT provides pointers to other ACPI tables much like RSDT. However,
> contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
> pointers. ACPI requires that if XSDT is valid then it takes precedence
> over RSDT.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> [ Alex E: Use flexible array member for XSDT struct ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h |  6 ++++++
>   lib/acpi.c | 40 ++++++++++++++++++++++++++++++++--------
>   2 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 53e41c4b..74ba00ac 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -14,6 +14,7 @@
>   
>   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
>   #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
> +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>   
> @@ -56,6 +57,11 @@ struct acpi_table_rsdt_rev1 {
>   	u32 table_offset_entry[];
>   };
>   
> +struct acpi_table_xsdt {
> +	ACPI_TABLE_HEADER_DEF
> +	u64 table_offset_entry[];
> +};
> +
>   struct acpi_table_fadt_rev1 {
>   	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
>   	u32 firmware_ctrl;	/* Physical address of FACS */
> diff --git a/lib/acpi.c b/lib/acpi.c
> index 166ffd14..d35f09a6 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -37,7 +37,8 @@ static struct acpi_table_rsdp *get_rsdp(void)
>   
>   void *find_acpi_table_addr(u32 sig)
>   {
> -	struct acpi_table_rsdt_rev1 *rsdt;
> +	struct acpi_table_rsdt_rev1 *rsdt = NULL;
> +	struct acpi_table_xsdt *xsdt = NULL;
>   	struct acpi_table_rsdp *rsdp;
>   	void *end;
>   	int i;
> @@ -62,18 +63,41 @@ void *find_acpi_table_addr(u32 sig)
>   		return rsdp;
>   
>   	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
> -	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> -		return NULL;
> +	if (rsdt && rsdt->signature != RSDT_SIGNATURE)
> +		rsdt = NULL;
>   
>   	if (sig == RSDT_SIGNATURE)
>   		return rsdt;
>   
> -	end = (void *)rsdt + rsdt->length;
> -	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> -		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> +	if (rsdp->revision >= 2) {
> +		xsdt = (void *)rsdp->xsdt_physical_address;
> +		if (xsdt && xsdt->signature != XSDT_SIGNATURE)
> +			xsdt = NULL;
> +	}
>   
> -		if (t && t->signature == sig)
> -			return t;
> +	if (sig == XSDT_SIGNATURE)
> +		return xsdt;
> +
> +	/*
> +	 * When the system implements APCI 2.0 and above and XSDT is valid we
> +	 * have use XSDT to find other ACPI tables, otherwise, we use RSDT.
> +	 */
> +	if (xsdt) {
> +		end = (void *)xsdt + xsdt->length;
> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)(ulong) xsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	} else if (rsdt) {
> +		end = (void *)rsdt + rsdt->length;
> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
> +		}
>   	}
>   
>   	return NULL;

-- 
Shaoqin


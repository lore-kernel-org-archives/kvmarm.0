Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806DF8481
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 03:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695094760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBvJUlyaw2bkgeQrcu2quBogD5BtM2KTe/dcbAYZ1+c=;
	b=XRsOHo1xemZzdKUrTyBuUPUnVtHNLfi4LMok9ICS4ohNDi1j9iK8PErL35SMfmGdcQmhPM
	hta60y5U2Lu+UhpZC8kvzN6lWhJqp55szRXb/OF0t/TR0HRnJdw6L7Hocb3E4Z5yCKzkbw
	5QgbInSjNgxblMEkPnr9eVcnCxd14ZQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-mbg1igD6OSyHYQqavw6IfA-1; Mon, 18 Sep 2023 23:39:18 -0400
X-MC-Unique: mbg1igD6OSyHYQqavw6IfA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c44a2cbea0so20428775ad.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 20:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695094758; x=1695699558;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CBvJUlyaw2bkgeQrcu2quBogD5BtM2KTe/dcbAYZ1+c=;
        b=g8D19SCL7kMMbX7dSVkMLpcYB11K8ke5CHHX7sw26vH1xExPL0YewvYjIc2epcHOCb
         DbR7vWD2yamnMkr7fJvoK2+icTcNUncGS3hl2ydBr+47y/qcJsJrPRkeI3F/HPrMm4Ez
         ig/PYbMVA9295eEyzNVrMlTypFzeX1aK6mKRBNz62+iy03LIydWXLjR33674oWVthnfN
         DDCudy7ecXAk1cY5G9SV8ECR34NMj4Ze0b0SwodvIlawqcg10yzogwe/8vTJcQBW0FbZ
         jP3Z8LXFGs3rTEwhQ0BTrCyX2uPx9Avg5Lg6VooPRcL+mgxsAWZDvXwN1EPUYK9WXuLJ
         fMDw==
X-Gm-Message-State: AOJu0YySpuGjI1Lkgobe5117P4yim2dmPlPuogt4uGHbyId7xyH3F2P5
	5F25KfLQVWvjHYnOWl/1Yr6JFYpXFB6o/5K0rN1mRsSDXO18ze+Y5cRtc95x6T4zLDKPXVsXnu+
	CDNhwZiL+qotuu7v3
X-Received: by 2002:a17:902:ecca:b0:1c3:432f:9f69 with SMTP id a10-20020a170902ecca00b001c3432f9f69mr2008952plh.23.1695094757878;
        Mon, 18 Sep 2023 20:39:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaoSZiSFZ7Dx5QmHpQ853bVS36OFRusCjmGB2jt3hklfrALFF9t8rRDnMvZC9r997ICNVz6g==
X-Received: by 2002:a17:902:ecca:b0:1c3:432f:9f69 with SMTP id a10-20020a170902ecca00b001c3432f9f69mr2008930plh.23.1695094757591;
        Mon, 18 Sep 2023 20:39:17 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 20-20020a170902e9d400b001c567dcf22dsm2846570plk.281.2023.09.18.20.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 20:39:16 -0700 (PDT)
Message-ID: <31fa3aa7-c12c-3eb7-e9d2-5967a735ac78@redhat.com>
Date: Tue, 19 Sep 2023 13:39:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 29/35] irqchip/gic-v3: Don't return errors from
 gic_acpi_match_gicc()
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
 <20230913163823.7880-30-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-30-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/14/23 02:38, James Morse wrote:
> gic_acpi_match_gicc() is only called via gic_acpi_count_gicr_regions().
> It should only count the number of enabled redistributors, but it
> also tries to sanity check the GICC entry, currently returning an
> error if the Enabled bit is set, but the gicr_base_address is zero.
> 
> Adding support for the online-capable bit to the sanity check
> complicates it, for no benefit. The existing check implicitly
> depends on gic_acpi_count_gicr_regions() previous failing to find
> any GICR regions (as it is valid to have gicr_base_address of zero if
> the redistributors are described via a GICR entry).
> 
> Instead of complicating the check, remove it. Failures that happen
> at this point cause the irqchip not to register, meaning no irqs
> can be requested. The kernel grinds to a panic() pretty quickly.
> 
> Without the check, MADT tables that exhibit this problem are still
> caught by gic_populate_rdist(), which helpfully also prints what
> went wrong:
> | CPU4: mpidr 100 has no re-distributor!
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3.c | 18 ++++++------------
>   1 file changed, 6 insertions(+), 12 deletions(-)
> 

With below nits resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 72d3cdebdad1..0f54811262eb 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -2415,21 +2415,15 @@ static int __init gic_acpi_match_gicc(union acpi_subtable_headers *header,
>   
>   	/*
>   	 * If GICC is enabled and has valid gicr base address, then it means
> -	 * GICR base is presented via GICC
> +	 * GICR base is presented via GICC. The redistributor is only known to
> +	 * be accessible if the GICC is marked as enabled. If this bit is not
> +	 * set, we'd need to add the redistributor at runtime, which isn't
> +	 * supported.
>   	 */
> -	if (acpi_gicc_is_usable(gicc) && gicc->gicr_base_address) {
> +	if (gicc->flags & ACPI_MADT_ENABLED && gicc->gicr_base_address)
>   		acpi_data.enabled_rdists++;
> -		return 0;
> -	}
>   

	if (acpi_gicc_is_usable(gicc) && gicc->gicr_base_address) {
	

> -	/*
> -	 * It's perfectly valid firmware can pass disabled GICC entry, driver
> -	 * should not treat as errors, skip the entry instead of probe fail.
> -	 */
> -	if (!acpi_gicc_is_usable(gicc))
> -		return 0;
> -
> -	return -ENODEV;
> +	return 0;
>   }
>   
>   static int __init gic_acpi_count_gicr_regions(void)

Thanks,
Gavin


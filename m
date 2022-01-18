Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EED5C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 13:51:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F00408B3;
	Tue, 18 Jan 2022 08:51:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p8c4yfHTmOPK; Tue, 18 Jan 2022 08:51:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F2840BDF;
	Tue, 18 Jan 2022 08:51:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D739B40BDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:51:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WnrzpwLZ14O8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 08:51:10 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CABAE4087B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:51:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642513870;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wpyCOtx9cZBw2W9lEvvyvmRvXVUbY2PgYr7UeyQNzpU=;
 b=PH7LruYnbpr04NZXy+sP9isAV3IomL50Nio6wniI9b6HgSj9PP6Ed/eoQ9bCQQ192V596F
 YZqyQJUVI9z0j5lTlmaPe4nVHwyffYc9S/kHubo84XREGwatsKMwCBvr6BxpMNEgRIPrPD
 3ARoxsKu2N5MZ5+RDEZgClhNacomNCg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-QL8VScN1OMiHCMzJcUrvIA-1; Tue, 18 Jan 2022 08:51:09 -0500
X-MC-Unique: QL8VScN1OMiHCMzJcUrvIA-1
Received: by mail-wm1-f71.google.com with SMTP id
 r11-20020a1c440b000000b0034d79edde84so237120wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 05:51:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=wpyCOtx9cZBw2W9lEvvyvmRvXVUbY2PgYr7UeyQNzpU=;
 b=ZwhVhqOuGmUYRjsO49jZQeykWPo4Cq5ewdKbkYxXY95KmAAmSz49VjuyC9zasTq13q
 TcLpcebYeHDx0poTWrT0GshDbsrIyujlxHW3KL+z5g5MSb2c3+vwOMLhfhZwUVcCVzDw
 uMn/vqs4EemhIhD/+QF5WXeD5/ZAEpNIVkql1Zzr0F59Q+oF75sEmW9OLv9+LL9HsT38
 +9JMerSKNOmpCWwI23kj/zgTloDpZj5SQeAXHS0qnx9iF2odi+prxvklqmyBUp2wWT2Z
 P7YgcatFqI+oWh7EK+IdPEb/zZUZWALdWBV9P273Sg6sGEz1MRgWZDpnDJYw3cnNO6zd
 zKYw==
X-Gm-Message-State: AOAM533f3hHLgUDelGpmPVV5mNwPY/fw18smqB71jZv11Oq+T3MzC0W9
 CNSAHty8khDakLDVCZPOThmhudAMGHNnXDEax2Cv64EdwkulGtV26Q+dva26Rgca95DJHdjZ362
 T5MDRJd9pe1expz/oeBlve4DW
X-Received: by 2002:a5d:6811:: with SMTP id w17mr24307052wru.443.1642513867857; 
 Tue, 18 Jan 2022 05:51:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJww7Eh/gQpLsNa7olEtt9CE0FFbWLusG97SdWpRNeWF6JuwvRVy2BXBTMONwARUG2yJVu5AdQ==
X-Received: by 2002:a5d:6811:: with SMTP id w17mr24307033wru.443.1642513867609; 
 Tue, 18 Jan 2022 05:51:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id p4sm2596431wmq.40.2022.01.18.05.51.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Jan 2022 05:51:07 -0800 (PST)
Subject: Re: [PATCH v5 5/6] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220114140741.1358263-1-maz@kernel.org>
 <20220114140741.1358263-6-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <10f21d1f-7f95-d9ba-0803-9d11d461829a@redhat.com>
Date: Tue, 18 Jan 2022 14:51:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114140741.1358263-6-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 1/14/22 3:07 PM, Marc Zyngier wrote:
> In order to only keep the highmem devices that actually fit in
> the PA range, check their location against the range and update
> highest_gpa if they fit. If they don't, mark them as disabled.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a427676b50..053791cc44 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1712,21 +1712,43 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>          base = vms->memmap[VIRT_MEM].base + LEGACY_RAMLIMIT_BYTES;
>      }
>  
> +    /* We know for sure that at least the memory fits in the PA space */
> +    vms->highest_gpa = memtop - 1;
> +
>      for (i = VIRT_LOWMEMMAP_LAST; i < ARRAY_SIZE(extended_memmap); i++) {
>          hwaddr size = extended_memmap[i].size;
> +        bool fits;
>  
>          base = ROUND_UP(base, size);
>          vms->memmap[i].base = base;
>          vms->memmap[i].size = size;
> +
> +        /*
> +         * Check each device to see if they fit in the PA space,
> +         * moving highest_gpa as we go.
> +         *
> +         * For each device that doesn't fit, disable it.
> +         */
> +        fits = (base + size) <= BIT_ULL(pa_bits);
> +        if (fits) {
> +            vms->highest_gpa = base + size - 1;
> +        }
> +
> +        switch (i) {
> +        case VIRT_HIGH_GIC_REDIST2:
> +            vms->highmem_redists &= fits;
> +            break;
> +        case VIRT_HIGH_PCIE_ECAM:
> +            vms->highmem_ecam &= fits;
> +            break;
> +        case VIRT_HIGH_PCIE_MMIO:
> +            vms->highmem_mmio &= fits;
> +            break;
> +        }
> +
>          base += size;
>      }
>  
> -    /*
> -     * If base fits within pa_bits, all good. If it doesn't, limit it
> -     * to the end of RAM, which is guaranteed to fit within pa_bits.
> -     */
> -    vms->highest_gpa = (base <= BIT_ULL(pa_bits) ? base : memtop) - 1;
> -
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3FFC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 17:13:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8874B188;
	Mon, 10 Jan 2022 12:13:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ni4Saw6HpK9B; Mon, 10 Jan 2022 12:13:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9091E4B18A;
	Mon, 10 Jan 2022 12:13:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 606EE4B186
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 12:13:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id grblGkgO0opK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 12:13:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658D24B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 12:13:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641834780;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=03p6qi4vSMUKe6Ewm0O52FmVWNcm73cafj58jFWwUb4=;
 b=bTakLE8Hx4gqnMKrgnvWRY1QHa9kSrpK0XiqCHzdcOwKK4y+4F4AfGh5RLVqO8hfUcEEwT
 2xG0dmNxKdld+HfnI14jg9w3oIO510I0lyGnWnODnxIIz1fTScRwzJmw7RXG3kJnfV6pTP
 ULQluWSXqHXYLZ4mfKqWglDs86FWYJI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-1JeABUwZONu4greYJq4m0g-1; Mon, 10 Jan 2022 12:12:53 -0500
X-MC-Unique: 1JeABUwZONu4greYJq4m0g-1
Received: by mail-wm1-f71.google.com with SMTP id
 n14-20020a7bcbce000000b003488820f0d9so247824wmi.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 09:12:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=03p6qi4vSMUKe6Ewm0O52FmVWNcm73cafj58jFWwUb4=;
 b=qt6nb7DnwGzYdlNGwQEdHWUCpFLU7NidNVFe8pcjI2NyK9U9DtOhR0kztT3lqw9DA0
 sIIGN/+hlCkODV5HpGrLHp4Am1yPKy+voxov7UnJAV8tjkcLq5elxKmdifkLeKATDUNf
 TtR3ct5FXqT5h/OYiPAQDipDEi24txQ1qwhxtJIEeMq2jI1msv8+2oNTDGjCLNE8kLs3
 DfxXi5excbcDdQeVSWmUxkM0U31Ar/Op2hV4NWwpwdzuF9ZmkhQbLBNCf6wSS4b7g4xk
 w/OxljB4KesutQaEmSZmYzuNqtrlB54Zd5RcdDjoA5e5mViERgCOOvjjERfwHHRx3OHR
 fryA==
X-Gm-Message-State: AOAM5324LFriFxzxaTPV1i4/TCUCqUizneATWtj3wtZarArLJqDhpJPl
 lFYVeXvxKBt8ZP3KPasVKtNW3T08IIEf0vLXxt5kdzTW0rkbMnWU1u5eQ5Uyozf4sSWZtCnGCq1
 QscSCWKUaaN6105jlyJux4qPa
X-Received: by 2002:adf:fac3:: with SMTP id a3mr479976wrs.369.1641834772669;
 Mon, 10 Jan 2022 09:12:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCFLFbIA8AorqfaYxU8UpegcJfTTKDPwhDdvVaVfqi2b0Bh1NWQH0spzhztlk2tCbDCNxvvg==
X-Received: by 2002:adf:fac3:: with SMTP id a3mr479949wrs.369.1641834772216;
 Mon, 10 Jan 2022 09:12:52 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l6sm1383751wmq.22.2022.01.10.09.12.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 09:12:51 -0800 (PST)
Subject: Re: [PATCH v4 5/6] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-6-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <dad34b51-51e2-37cd-44cd-7ca7c4fe6129@redhat.com>
Date: Mon, 10 Jan 2022 18:12:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-6-maz@kernel.org>
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

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> In order to only keep the highmem devices that actually fit in
> the PA range, check their location against the range and update
> highest_gpa if they fit. If they don't, mark them them as disabled.
s/them them/them
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index db4b0636e1..70b4773b3e 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1711,21 +1711,43 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
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
> +            vms->highest_gpa = MAX(vms->highest_gpa, base + size - 1);
why do you need the MAX()?
> +        }
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
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

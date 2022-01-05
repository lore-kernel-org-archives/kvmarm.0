Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BD4C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 09:22:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C9F4B11B;
	Wed,  5 Jan 2022 04:22:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fm4uoryOevaH; Wed,  5 Jan 2022 04:22:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2D44B10E;
	Wed,  5 Jan 2022 04:22:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E084B10E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:22:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k63iuwdPhAFM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 04:22:44 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2E44B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:22:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641374563;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nJYdodG85/ccnAQTfgZ3AUnRmcUufSnMa1xnUl79IAI=;
 b=WOH/tIpdipa/9a1zK0+WHv6lBQylIuDl/irsaz1IX72tuDXiAEbpxYIjpCKUkI04msz4Wp
 qCL3xTiPElTR3M9BP0Bewm1y7G9fSAlgrbJyC9598aFcJiumdWuNE6Z2kuJ3uxefWO4oBQ
 rFruu0hl13CLs44nvKCGzocn4FwAyO0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-d1nOgMFgOVGFZofklyJr4g-1; Wed, 05 Jan 2022 04:22:42 -0500
X-MC-Unique: d1nOgMFgOVGFZofklyJr4g-1
Received: by mail-wr1-f71.google.com with SMTP id
 h12-20020adfa4cc000000b001a22dceda69so12328286wrb.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 01:22:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=nJYdodG85/ccnAQTfgZ3AUnRmcUufSnMa1xnUl79IAI=;
 b=MkiWiXGIrm45oeCrf3u842ILx7oBlUoZxJhr+GTX1rYb4TknjirWCZ1qAPJP7i0kPc
 m3k1zujLB4+vQsZmZWh7Kc6ah/Ic8PrYewyV0HVYXxjDCwIk3C/GvogTf9pboMWWPI4m
 oeQBRKAqaqQfkpfV3//mUJieL/GxXghLn+bnCpUNGkfq5WHp/8Qb/XzOfk0yCRyX37P8
 Q4fZHgapaeastSNvVQb8ips8qszIN1l56/YLasx7D7otySQtcgdLb+JRME0A5tMt7g5x
 5hluL50OdwdnLDHV8P20NpnNtyWFAxdiVxkWqrxJzYi56PRMihKYdQkYDhj+lJroBk0W
 GUVQ==
X-Gm-Message-State: AOAM531sQUd8v22EjqOz5o/l4oEyN24lCbVbUUeGBbqzH3lfyKpoZXc9
 /SKaNl1DxsPui7ki5tl/yS39SyQE78JwgByZ0Eb+1zez5+CTPL157D1eBAdekTeAJAaYGcm+4Au
 Ka8fbCzPHmv2sLe2hZkat2HbC
X-Received: by 2002:a05:600c:3d0f:: with SMTP id
 bh15mr2037732wmb.27.1641374561385; 
 Wed, 05 Jan 2022 01:22:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5u8kXW70952AOxAuw5ljL9wtKWvvP0ulgX5HpX3UhLV+slhtiBMxJ6UN+z0RstQQDzjW3tw==
X-Received: by 2002:a05:600c:3d0f:: with SMTP id
 bh15mr2037711wmb.27.1641374561183; 
 Wed, 05 Jan 2022 01:22:41 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id c7sm45516656wri.21.2022.01.05.01.22.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 05 Jan 2022 01:22:40 -0800 (PST)
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Date: Wed, 5 Jan 2022 10:22:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211227211642.994461-4-maz@kernel.org>
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

On 12/27/21 10:16 PM, Marc Zyngier wrote:
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit.
> Similarily, nothing seem to check that the memory is within
> the limit set by the highmem=off option.
>
> This leads to failures in virt_kvm_type() on systems that have
> a crippled IPA range, as the reported IPA space is larger than
> what it should be.
>
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum, and fail if we have memory
> crossing the 4GiB limit.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 8b600d82c1..84dd3b36fb 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    if (!vms->highmem &&
> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);

The memory is composed of initial memory and device memory.
device memory is put after the initial memory but has a 1GB alignment
On top of that you have 1G page alignment per device memory slot

so potentially the highest mem address is larger than
vms->memmap[VIRT_MEM].base + ms->maxram_size.
I would rather do the check on device_memory_base + device_memory_size
> +    }
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ?
> +                        base :
> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
As per the previous comment this looks wrong to me if !highmem.

If !highmem, if RAM requirements are low we still could get benefit from
REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
simply don't care? If we don't, why don't we simply skip the
extended_memmap overlay as suggested in v2? I did not get your reply sorry.

Thanks

Eric
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

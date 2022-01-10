Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D8BC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 15:31:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C756C4B10C;
	Mon, 10 Jan 2022 10:31:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KrKQuVnkoEMg; Mon, 10 Jan 2022 10:31:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74F624B152;
	Mon, 10 Jan 2022 10:31:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37D374B10C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:31:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5lUeGGU0S8qQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 10:31:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B60F4B108
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:31:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641828664;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hAsOCNUk4gJy3xfkTWxDnJ/ocn/Hng6/ay6Zh+ITS5o=;
 b=Rv63s3NnEwom4uzSU8nGGX7r7FajtSwPMLLU8OviAgLC7fl+/XrPRH4/CMlwkVqTwamwWH
 t2OJDeNkobi6dEzQF4b6TJHchvKEE8wBN7KzTysIcxKwAgSvLhe+pgdBnjLYW7iDiBWqIz
 3OA8nYvC6RccezD0eMJeYx/dKyWqhsE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-0hVKw9iHNNCysFP5bLPszw-1; Mon, 10 Jan 2022 10:31:01 -0500
X-MC-Unique: 0hVKw9iHNNCysFP5bLPszw-1
Received: by mail-wm1-f70.google.com with SMTP id
 m19-20020a05600c4f5300b00345cb6e8dd4so2249943wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 07:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=hAsOCNUk4gJy3xfkTWxDnJ/ocn/Hng6/ay6Zh+ITS5o=;
 b=sP3uhlV2O3F+z9PqRngryBHPWLtHShI/fmbvlkRrxSZ9JSubjFfYiotXtue90l2D3h
 SVrclFH2L/K05zl8HfIFWAfV2xgbxRaSnYdHp68wI/Yu+4WaBldlQrxuwgfF8fah0Gl6
 rEV5XoOOmbal9TCMXX7p14AGc8+51D2dHU8RafsIj6IAlqX1QEccU029zf6/AoVca1W5
 HiionX+o+OanpCUpNyPLOAsMdVqckWQXtvPeL4+ck1UO11g2d/P1TSkvwzGpmcLSgSg9
 BxD7lcmK2Rurt5N/qYPdOSFyVrfgt59az7DpOizbyQZFXWzgn7SO+H5nxXyUp84WNKGf
 tD+g==
X-Gm-Message-State: AOAM530NavgTn5O/JsgLY7/W4CQTs5k3Eo9pRmhjvkp+9BgMLiYdv8De
 6EvIKrcflnft34Zgshov2jBWx72JEO5+jJG1EMtN1E8CT2MU9f7sMhtzaa8b55oAcFTmMIYqTls
 jbhjHcz/bXxWgi49KHceTVw9F
X-Received: by 2002:a05:600c:34c4:: with SMTP id
 d4mr22837827wmq.53.1641828660522; 
 Mon, 10 Jan 2022 07:31:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ5PbKWG2o82UtfdwF8YlHmCQ3IAN9akDTuLFh8hqRxJQpStKQ1peYtx8PsS1Wl2ACmE2rXQ==
X-Received: by 2002:a05:600c:34c4:: with SMTP id
 d4mr22837815wmq.53.1641828660301; 
 Mon, 10 Jan 2022 07:31:00 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id g5sm7517121wrd.100.2022.01.10.07.30.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 07:30:59 -0800 (PST)
Subject: Re: [PATCH v4 3/6] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-4-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <a72846d6-d559-9f12-154f-20c04821747e@redhat.com>
Date: Mon, 10 Jan 2022 16:30:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-4-maz@kernel.org>
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 4d1d629432..57c55e8a37 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1663,7 +1663,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>  static void virt_set_memmap(VirtMachineState *vms)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>      int i;
>  
>      vms->memmap = extended_memmap;
> @@ -1690,7 +1690,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>  
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    if (!vms->highmem && memtop > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1707,7 +1711,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

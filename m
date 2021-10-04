Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EECC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:44:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02B2F61181
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 02B2F61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6BA74B201;
	Mon,  4 Oct 2021 05:44:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EfzabRT7ByOD; Mon,  4 Oct 2021 05:44:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B67644B252;
	Mon,  4 Oct 2021 05:44:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A704B201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:44:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DV-5ObY54S44 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:44:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C2B4B234
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:44:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633340675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SoUkTtOv9XP49TsrzDlI8hEqaw7q+N7J/SxBu7RAHCQ=;
 b=fHBHGlAQcH7HITOeeZSlw+Af8RP5uM/cjf3Wr82ThRUhaX6roe/OO4zVUFT3q4U9gjVfZ8
 uLFSbjKMy801VJu4JI9lwHfk1e5ULduBITt5HHWEprWmDnOoC7zAMWK0ve8aRpd0tEPwWR
 LtaCGYNqH3jl2HlmlYihGg2xAy86dzI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-fOb3_5rHOhmZUpoENWQksw-1; Mon, 04 Oct 2021 05:44:34 -0400
X-MC-Unique: fOb3_5rHOhmZUpoENWQksw-1
Received: by mail-wr1-f69.google.com with SMTP id
 r16-20020adfbb10000000b00160958ed8acso2682940wrg.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 02:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SoUkTtOv9XP49TsrzDlI8hEqaw7q+N7J/SxBu7RAHCQ=;
 b=1ajqmBS9+sBMXbwExh05xSX4DegGnd9oMMy2Ct6bhEQO5TbVOo/5wMfC30v2ygJa0F
 xIfn108L/yWll68uf2prvKYrKK41d7UesgfAONA4XoCdrIWkU16JVAeOmakovfAgPkfY
 ueNn9p2w56is223GQvv9s1FYiypcLBxaljsu04TQ9WGcoYCm0jZzTKbw07j9bmzbsxPr
 CLxmnBLxZXKM2aSUrEIDmf8GhcVcpc/EHrTjQrGW/b28uTG3xYyu3CTyCBPg/HSy5/AK
 qNTNkGvWODJw98NyxBVSFRYpLgopPsFiDAwNRLRQhy7GYJUcoI4ggqLquQsNVYneMsY4
 44nA==
X-Gm-Message-State: AOAM530pEZr7/XgPNKool3jp91nOW0Wy0xdU0MoQ+fame+1abJ3LOaUO
 oCLqKkSYnF3uZWOdkCTsMHe842DkNJeaGVpH59XoHGYTmfTCF7AHx6KxOll3qv7M8+Ca7kpChRa
 vqw5Bye1x8wN0iB0rOeh8Azi6
X-Received: by 2002:adf:9bc4:: with SMTP id e4mr13142425wrc.257.1633340673325; 
 Mon, 04 Oct 2021 02:44:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2LrCY7HSrjxs2GPwETmmHaFihgfaSnx78iosQ5U6+ikTJPgF0cMge7tL/mMpTCWF7VZGUEw==
X-Received: by 2002:adf:9bc4:: with SMTP id e4mr13142407wrc.257.1633340673145; 
 Mon, 04 Oct 2021 02:44:33 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id n17sm6794152wrw.16.2021.10.04.02.44.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 02:44:32 -0700 (PDT)
Date: Mon, 4 Oct 2021 11:44:31 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
Message-ID: <20211004094431.2dewqj3hf2vjiil7@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On Sun, Oct 03, 2021 at 05:46:03PM +0100, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index bcf58f677d..9d2abdbd5f 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1628,6 +1628,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    if (!vms->highmem &&
> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1657,7 +1662,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ?
> +                        base :
> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

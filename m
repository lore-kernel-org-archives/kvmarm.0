Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC05C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:12:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C97E6128A
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C97E6128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C474B238;
	Mon,  4 Oct 2021 06:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lxLXSnmBTr-L; Mon,  4 Oct 2021 06:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9E684B201;
	Mon,  4 Oct 2021 06:12:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB8D4B201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CySQYKnEXSXm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:12:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2825A4B1F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:12:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633342366;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rCPDv4QRNZ0a1fQs05Nas1A64qaGfmSB0iOlYE+QsHo=;
 b=SKdlgUJDWFvKUUcjDPy/0yFdzPt5H5M7Qz+4Dv/BdAkmDmovitjGDOV15x5naxqNFR17Uz
 mR3Rq1IoUEOKg+WdqApuaSoOjXNUUe1ju/35kWqes0w1wffF/5B3trqmuaz8Yl4LP8+/46
 mLarz/7WjwjoBwFm93gYGnFHgrJ2ru0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-ELi5s7vvOaqQVFDJw4PwnQ-1; Mon, 04 Oct 2021 06:12:43 -0400
X-MC-Unique: ELi5s7vvOaqQVFDJw4PwnQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 k5-20020a7bc3050000b02901e081f69d80so8000122wmj.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 03:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rCPDv4QRNZ0a1fQs05Nas1A64qaGfmSB0iOlYE+QsHo=;
 b=GUSsFrYIyHVfl98Zw5JnBMR7m5pq8J89uVHWcGd/LgPA32P8JzwmtHvg0T0Tf7cOxI
 8Wn/3haOZvqHBtwS3aDXDFCtIxHpyd8QEwqJSfF9xteq1sfvV9K+RkzaAHc9SSj3Thg+
 iV/Pra25ZiuxPoQ+OXaYiJGR834F4s/2ipK5iY3qUN23r0PP7breG8leX7zQlRYBGXH6
 QfoVjqCljWzSuotzPdAMUX5YKzQjoCYhoH4sS32vJs57DP9v2aKHv8ZsgxDG6OfY+Ijp
 V/75D/RPkR3M1La/P3ZY+LHgmihSVNBITyQWuWB/59T5+Ct72bbre7r3Sf/nt/4VQChb
 tnTw==
X-Gm-Message-State: AOAM530ATxhOcOtTX6svggg2UeE4eNnhrPm3QpR+sfYNAqD4dFAGGqVG
 kcnmERqZFaRPJkpyqtQ7yNDG/mjedFeo8Mxjq5Bbc8Grv8tKnKkjKiqNb4DEPiYVdCSD9mCy395
 cJn7gbk5f8iBUVSYZWvc/t+MF
X-Received: by 2002:adf:f946:: with SMTP id q6mr13123338wrr.437.1633342362083; 
 Mon, 04 Oct 2021 03:12:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSvhm+jWUInTDea5wEfwMr2LgnDYEZ4Lout+X2NLSfcGiX7+w+w//Bp93Dv3sbxAR10OUxnw==
X-Received: by 2002:adf:f946:: with SMTP id q6mr13123315wrr.437.1633342361923; 
 Mon, 04 Oct 2021 03:12:41 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id b16sm1605797wrw.46.2021.10.04.03.12.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 03:12:41 -0700 (PDT)
Date: Mon, 4 Oct 2021 12:12:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
Message-ID: <20211004101240.fdf2mty5jvnler33@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-6-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-6-maz@kernel.org>
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

On Sun, Oct 03, 2021 at 05:46:05PM +0100, Marc Zyngier wrote:
> Make sure both the highmem PCIe and GICv3 regions are disabled when
> they don't fully fit in the PA range.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a572e0c9d9..756f67b6c8 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1673,6 +1673,9 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>      if (base <= BIT_ULL(pa_bits)) {
>          vms->highest_gpa = base -1;
>      } else {
> +        /* Advertise that we have disabled the highmem devices */
> +        vms->highmem_ecam = false;
> +        vms->highmem_redists = false;
>          vms->highest_gpa = memtop - 1;
>      }
>  
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

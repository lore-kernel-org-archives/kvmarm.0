Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1FEC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:48:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD0806186A
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD0806186A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287AF4B485;
	Tue, 11 May 2021 04:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KZdt7VlxrDzt; Tue, 11 May 2021 04:48:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 040444B492;
	Tue, 11 May 2021 04:48:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22E514B3F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:48:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ApEGjIWwP1+s for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 04:48:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 724854B3F2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:48:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620722891;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
 b=irpWL9PTRrMKtO6LcENj6D06qy/fgSMjpned4iyZa3A2ZeeMea/uOnqaLivhSsvPDZy6pA
 QvczkwHWI6OaevAOdOJIcBJsgjx3lgxPGspYp9peL4hhxqonfP41nWzWesxKn4YGf1SAEn
 EOcCehYXyLGiprFFR9lAkax6GrieYTM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-VWmXtII7PMeQwuYRnoWTKg-1; Tue, 11 May 2021 04:48:08 -0400
X-MC-Unique: VWmXtII7PMeQwuYRnoWTKg-1
Received: by mail-wr1-f70.google.com with SMTP id
 r12-20020adfc10c0000b029010d83323601so8431505wre.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 01:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
 b=l9agfMRQo30FoTOKWhig6lhTm89E7rczrdaDy95Us/7vbJ1AbcM0ZYs8zfcTOKDJ1C
 obWDWzhVIkkd0hz7Bq9AFtzyg3PxpeCR8MOXhdyPjgVuwRRD8AW7XfggwUoaTUq45c8Y
 /kBWi1JlWv3lqXn4TVna5VugXXF9ZtgozZDzEk9FzYhJgGsLLPvpSXoVo3CaV7hGRtwf
 84qQvnlita5JoCNEoozKwstX67qa2vOCLi4EmXiMHzqFEXmqZXR25qjwF4wKaHhd5vhh
 bttMOdnG+snifex5Akmf001lMvasHp+AQ9DRoWoBYUBeCpr5dsA4aKmQj6pKMLms0uyv
 cRUA==
X-Gm-Message-State: AOAM531bP0L2KgWv/C09hR0x30qzPs2u4la9sm6dWzNcC23QPJxMnhAI
 27mwa12Xv+DFwd+d8ZQ//a8N8m02wNwpnxDAQMuap3lsANaLkB99lRRpWrbBcc2j3bpW37pA6hJ
 05b8W6IwCTvBIlMsJqP5qo9Nw
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902628wmh.42.1620722887591; 
 Tue, 11 May 2021 01:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSGeb9zeNJcEJc46A/MASJMpLh0cSVeptzLQX8/dyHTwjbhVOWjTy0K8ideXs9zrKhUkYH5w==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902599wmh.42.1620722887375; 
 Tue, 11 May 2021 01:48:07 -0700 (PDT)
Received: from redhat.com ([2a10:8004:640e:0:d1db:1802:5043:7b85])
 by smtp.gmail.com with ESMTPSA id l18sm26972171wrt.97.2021.05.11.01.48.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 May 2021 01:48:06 -0700 (PDT)
Date: Tue, 11 May 2021 04:48:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
Message-ID: <20210511044756-mutt-send-email-mst@kernel.org>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, jasowang@redhat.com, cohuck@redhat.com,
 stable@vger.kernel.org, alex.williamson@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, May 08, 2021 at 03:11:52PM +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  virt/lib/irqbypass.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index c9bb3957f58a..28fda42e471b 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer *prod,
>  	if (prod->add_consumer)
>  		ret = prod->add_consumer(prod, cons);
>  
> -	if (ret)
> -		goto err_add_consumer;
> -
> -	ret = cons->add_producer(cons, prod);
> -	if (ret)
> -		goto err_add_producer;
> +	if (!ret) {
> +		ret = cons->add_producer(cons, prod);
> +		if (ret && prod->del_consumer)
> +			prod->del_consumer(prod, cons);
> +	}
>  
>  	if (cons->start)
>  		cons->start(cons);
>  	if (prod->start)
>  		prod->start(prod);
> -err_add_producer:
> -	if (prod->del_consumer)
> -		prod->del_consumer(prod, cons);
> -err_add_consumer:
> +
>  	return ret;
>  }
>  
> -- 
> 2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

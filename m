Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C065C48BE6
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 08:16:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D2E761380
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 08:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D2E761380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058A349FB7;
	Mon, 14 Jun 2021 04:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UX1eTUeSYmwH; Mon, 14 Jun 2021 04:16:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AE149E72;
	Mon, 14 Jun 2021 04:16:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61C4406D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 04:16:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dxAdjnary8ua for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 04:16:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4C9405A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 04:16:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623658600;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NWYh+JN15Re9hA/u8sox/DeHyV8EZ/VNFeCGPr+FHI0=;
 b=TuE00gNfJRTKuF/jhXHSwoiKOFOKpqoVvrjfILVNkocf78FseCaqS0Kr2GyYbZXougvNHK
 TLWCf+ZOB6T73GlR3EZjx/PwxH0bvpUZEUhJqQfncknOGgFhsoQ/HB+MVqFbxmmDZtgKBA
 wzQzoMPmK7rhlIK4Z7YOJJmpV9sTw6s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-WxV_fI74NOWFE8K7PbbdiA-1; Mon, 14 Jun 2021 04:16:38 -0400
X-MC-Unique: WxV_fI74NOWFE8K7PbbdiA-1
Received: by mail-ed1-f69.google.com with SMTP id
 u26-20020a05640207dab02903935beb5c71so14019685edy.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 01:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NWYh+JN15Re9hA/u8sox/DeHyV8EZ/VNFeCGPr+FHI0=;
 b=WtPuBIYpsOsx+t0b8rlayH6ATUWA9tx2fXqwsBujPn/3dQLbe5KRKpvXPVkymQiN4O
 TKuDna9apOBRl/ecAaxEbOSGEzLpjYbH3MkjIDgjz9gXe7SlLFpuBz1dY1XGTsa1VYZG
 6ApKgJkgNnWBoTDUuD+B63Cnygm6x+4S8QoaV3tR+EFaUIwzHqF2c98xyG7Wwm3USRrZ
 k5RLNgfDgwQv/DMgKyNHycNYLCLtbvD2T/5Y+WTiL4p1S9Zx8EPNRYJUbQBi72Pqbk/N
 QV9ShzNevxejL+tz4H0H6mTYNA9vsyJjUUVbyruCEpu/cuAMyU/WPc+aMzaVhOzkIMBA
 GChQ==
X-Gm-Message-State: AOAM531ZxJzhGz/qTjtu6JKn8YbH5ypUZ0z/0aPFX0D434g0qOmNaAMe
 fREyopsEW8ibO6PdHjorNjGl9XSiqpn9Po3I+q7Q4YTztqP0zzutTN6boY1w5t8c7+CqZJYLYzX
 7tln1e6M/bFLtSrLP4sly0aAy
X-Received: by 2002:a05:6402:19b9:: with SMTP id
 o25mr15353515edz.192.1623658597247; 
 Mon, 14 Jun 2021 01:16:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/KTRQYhU+Vh3BamwYE6Ifgg3evkGYd7DRr9k1n6WQ3groQvMruoCvWoppWBg5CVzFipDzmA==
X-Received: by 2002:a05:6402:19b9:: with SMTP id
 o25mr15353493edz.192.1623658597033; 
 Mon, 14 Jun 2021 01:16:37 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id h26sm8017727edz.76.2021.06.14.01.16.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Jun 2021 01:16:36 -0700 (PDT)
Date: Mon, 14 Jun 2021 10:16:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Update kvmtool UART address
Message-ID: <20210614081635.4arskb7yjcsm33mn@gator.home>
References: <20210611152621.34242-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210611152621.34242-1-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Jun 11, 2021 at 04:26:21PM +0100, Alexandru Elisei wrote:
> kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher
> addresses") changed the UART address from 0x3f8 to 0x1000000. Update the
> UART early address accordingly when kvm-unit-tests is configured with
> --target=kvmtool.
> 
> Users of older kvmtool versions can still enjoy having a working early UART
> by configuring kvm-unit-tests with --earlycon=uart,mmio,0x3f8. Note that in
> this case --target=kvmtool is still recommended because it enables all
> erratas.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 4ad5a4bcd782..bd0c14edb777 100755
> --- a/configure
> +++ b/configure
> @@ -189,7 +189,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      if [ "$target" = "qemu" ]; then
>          arm_uart_early_addr=0x09000000
>      elif [ "$target" = "kvmtool" ]; then
> -        arm_uart_early_addr=0x3f8
> +        arm_uart_early_addr=0x1000000
>          errata_force=1
>      else
>          echo "--target must be one of 'qemu' or 'kvmtool'!"
> -- 
> 2.32.0
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

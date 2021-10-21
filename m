Return-Path: <SRS0=/McF=PJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAA7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 10:08:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 677AC610FF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Oct 2021 10:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 677AC610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C21534B18F;
	Thu, 21 Oct 2021 06:08:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bnIHRni7U0pP; Thu, 21 Oct 2021 06:07:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EBBE4B166;
	Thu, 21 Oct 2021 06:07:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE2F4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 06:07:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4lTtpNw8hK3y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Oct 2021 06:07:53 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 492B34B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 06:07:53 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id r10so119692wra.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Oct 2021 03:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=F1oNJbu4pHa0grSs6d/Ns7GwUCGiFMszmkl6//VgeII=;
 b=CngsNRHpP3xh6N7S6PHF34+fDeYjB5qMaxxKiYNqOUXnACoEzVHxqk0VkPKPnKHdvg
 hd4xZGhEWkmGTe3+vQq37jqfz+2B9jgU1f/k29IhjSEbTzNY7VEqfRaS4czCiwcWWGQH
 hXOGa460Fr6GCQuBFg4AjhGLfykL+N3ebKY/x9cgLPB6Ped+HppYo7wg08pEjqSiwrGp
 rn445z1qcoCtgA/5Sga/yWZjrpnftJ6gvgdJ62aFqCndEfK2v4R7Lp14sVp98mjJLlrY
 FFldqfowPeNnj06Bs88tiUuL2Aub10yszfkjfJtC0IAk+/dtVc1HWqv5Nos5Cep8XPMq
 FepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=F1oNJbu4pHa0grSs6d/Ns7GwUCGiFMszmkl6//VgeII=;
 b=bIsDN5h50cjYoU2LqpUljfTEyX28OUsbNQzLeiBvF41JGa8VOyMwRQJT/2NW3lII0a
 MXh+eokco1oYSijzNkmc6cmpKSlguYcSbOpwklLlij2xto4bRW68LJt4cXrG5mReqcWr
 NjDqHjBjy/VGoP+oEcgNjLu0qE9Qi9PHtINCYkKveDEp5qs9fjfZcR+0Ba71MCkDTcLd
 8emMWE+r6pPLDy1LUB5rqex9e8F21l5XjPpTaSgREpbK4jQObJlKfDIX33ex7XTENhe5
 j08UohsKtBRVyUUNzKKWNbNYISv/xFPG7/FgCCg3+PHGIK9QVg3akaqtyxZLmWpnAgky
 bCwA==
X-Gm-Message-State: AOAM531L52NUHzEtbK1oaGMcCne6KxRwFoe4Cs+19bvQGIoMpK2T+/gM
 9aHRkOhKBLzSyq6Yei5kOVK4WA==
X-Google-Smtp-Source: ABdhPJx0Ugn18uahMeYKsgvnxSDyUIvip8FsoCCPzC5FJhL12HE7Bbu4dUtEydRB1ms/fxFX8qmiVQ==
X-Received: by 2002:adf:a10f:: with SMTP id o15mr6411916wro.286.1634810872098; 
 Thu, 21 Oct 2021 03:07:52 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com.
 [34.76.131.216])
 by smtp.gmail.com with ESMTPSA id n12sm5422554wri.22.2021.10.21.03.07.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Oct 2021 03:07:51 -0700 (PDT)
Date: Thu, 21 Oct 2021 10:07:47 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 07/15] KVM: arm64: Introduce kvm_share_hyp()
Message-ID: <YXE7842op3n8+JXv@google.com>
References: <20211019121304.2732332-1-qperret@google.com>
 <20211019121304.2732332-8-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211019121304.2732332-8-qperret@google.com>
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Hi Quentin,

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0019b2309f70..0cc4b295e525 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -299,6 +299,17 @@ static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
>  	return 0;
>  }
>  
> +int kvm_share_hyp(void *from, void *to)
> +{
> +	if (is_kernel_in_hyp_mode())
> +		return 0;
> +
> +	if (kvm_host_owns_hyp_mappings())
> +		return create_hyp_mappings(from, to, PAGE_HYP);
> +
> +	return pkvm_share_hyp(kvm_kaddr_to_phys(from), kvm_kaddr_to_phys(to));

We should be careful about vmalloc memory here. kvm_kaddr_to_phys will
happily return the physical address but the range is not guaranteed to
be physically contiguous. It doesn't look like this series ever shares
vmalloc memory, but we should make it harder for users of this function
to shoot themselves in the foot.

One option would be to turn this into a loop and call pkvm_share_hyp on
each physical page. But since the hypervisor has no means of making
those pages virtually contigous anyway, probably not the right approach.

We could make it possible to share vmalloc buffer that fit into a page
and reject others. There we still need to be careful about the upper
bound because the way it's written now, 'to' can be treated as
exclusive and 'kvm_kaddr_to_phys(to)' would not always return the page
after 'kvm_kaddr_to_phys(from)'.

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

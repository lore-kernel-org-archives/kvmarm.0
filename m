Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F3FC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:32:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B01A9610E9
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B01A9610E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25BB14B0C2;
	Wed,  8 Sep 2021 17:32:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G8ZhptFb16CP; Wed,  8 Sep 2021 17:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 263BD4B0A0;
	Wed,  8 Sep 2021 17:32:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53FB44B0C0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:32:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UliHBLyzZxsR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 17:32:10 -0400 (EDT)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57ECA4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:32:10 -0400 (EDT)
Received: by mail-il1-f180.google.com with SMTP id x5so3865669ill.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 14:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uZbNrjLOwzJp4fFJM+cNQcKd8IqlQMB7ACTwfLqh720=;
 b=Ett/Xnj4B+RYOCHKQFGaJnIjhhXun6RIb3DCCgH1bOAdsvr1XprrI60dfFjcYLkjIp
 WDuayRb97yZhJ+qlb+s6kOSERJhp22DoEXbQrsXurJxcraxBKnTRu5o0SLLnlnoMoThC
 CNFW39GKXId+Xaa4y5B3i6sFIHm1vYXe00gc4VLRu3d7ixbnmZef4+VkRytJFizRYF3g
 r7dRh/qjXx3YrF0WrOYKOG8ipIrYjmOdkK9Lx3/4XJmw9g657fmFuWik1+invwtWyxFJ
 4nXC5Uq6b96hPvLEq5sl7I1C7Way6nZrGMbhwOv3v1FKKcXTaqxybkkw4Qk/07oFwv50
 vPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uZbNrjLOwzJp4fFJM+cNQcKd8IqlQMB7ACTwfLqh720=;
 b=OUfBNtUmZw/UMmtjq1SDjlieE8RZuRU8N2K43NvYTtDN9RvKHh2mj8M0L8x6BxWIKM
 aJg9DDk7wrFs4TK+zry325GlUrFFTsbvA4llkrrTXGf+kYbSHW9DGKagjQDZD7dkplgX
 qZw5TbifyI/1FurxWz2aGFyC911d0tYl3ewsDEaAhGLBuJkMlqOveSp73sx8UUfuwqQ7
 lrK7Z33+qcU0Y+Le9pZJOQfn5+HZ25GnRAu0m+qG0rP+1apVcHekaV1epcIbpzLltFTO
 gjdJSZNJ8Oie6ng0+pSR4bu7oL/nQ8wtGQuZcmMHOl7wOkIoRBMj5CfIYKykcywk2Gpw
 vV+Q==
X-Gm-Message-State: AOAM533U4rjzLDXh4NLHQ+45kDMYwz68LmzB1Vm+T7DTlEdTZ5YoXD1g
 QlABeN72n6LCAE7WErzW59eX3A==
X-Google-Smtp-Source: ABdhPJwciF/VAdAEbUH3mpVJJwTsflA3hfhOWENiEDiyry80B9MoAQJ2HWB2Fc1zl0RfhUmXiBz2sg==
X-Received: by 2002:a05:6e02:2145:: with SMTP id
 d5mr257650ilv.214.1631136729375; 
 Wed, 08 Sep 2021 14:32:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id b76sm184005iof.17.2021.09.08.14.32.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 14:32:08 -0700 (PDT)
Date: Wed, 8 Sep 2021 21:32:05 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTkr1c7S0wPRv6hH@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210908210320.1182303-2-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> Extend vgic_v3_check_base() to verify that the redistributor regions
> don't go above the VM-specified IPA size (phys_size). This can happen
> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> 
>   base + size > phys_size AND base < phys_size
> 
> vgic_v3_check_base() is used to check the redist regions bases when
> setting them (with the vcpus added so far) and when attempting the first
> vcpu-run.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83..5afd9f6f68f6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>  			rdreg->base)
>  			return false;

Can we drop this check in favor of explicitly comparing rdreg->base with
kvm_phys_size()? I believe that would be more readable.

> +
> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> +			kvm_phys_size(kvm))
> +			return false;
>  	}
>  
>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

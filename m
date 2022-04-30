Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4C3C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 21:32:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 833BC4B260;
	Sat, 30 Apr 2022 17:32:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IeJkt-AjgoPW; Sat, 30 Apr 2022 17:32:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF494B262;
	Sat, 30 Apr 2022 17:32:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1154B25F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 17:32:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VOPQyfb0cV4X for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Apr 2022 17:32:14 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA5A84B10C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 17:32:14 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id g21so12950493iom.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 14:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=6Dc326+1xtPNu80ribLvmOWmJsI+u5HwW/pN6DNiLdg=;
 b=BMDhYIWfw3HduEt7j5KU1o8O/B+WmLWME9DRVXpw+9VJzVQia/f2kl0Qz4UzNcEVh8
 fCk7Y7oogFoG8YokWaFmI30bM8f788SXMTbJu+jL/Lu1bajJ4ygKxPXpxS3INhE8lpI9
 qECtrk/Po6tesEuXtchgDVws9WJcG6sMwt1nyG2plOWi3DoKY7wBQoWzls/tTYeOTMaH
 7hHtRfjB7KGv1yxFV9PwCMxjC0abCIfYKUj2LmVtSHvyqx9q58dBUGxOiJ2LQQxSzIdF
 X/inLnmn2Havn1WIC0xlWVAJ7Z6P51rB+mDImAxVn9i8TX1lCgKqTcpa/YGMe1flxR6A
 9org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6Dc326+1xtPNu80ribLvmOWmJsI+u5HwW/pN6DNiLdg=;
 b=RpkD4GMjArT/jHpf0kqffZNfyb139ZNtvF7AXAWaK+KfaNx9MLF2l+B1vSudtJrZbK
 1OZISdo2vi4PSLD36L0tnsF3cft6vAKEQvqwUl8gTy/8K+a9/ezBaU/B9iHseuXBbSIj
 BUJLhNOTtYexjj6XuTdhQlLSoeB3Dtk29Nxl9r7nNsg5ANyTUwpUcSdwQj97dxsvAX24
 BEwsUT4Dt/XwMpVVBoRr6IQSybwE/PO2SWqWxkU39H/Mf7kwFdey1EDhnnU12OWvynfr
 z4yADpRW1ImTVIZ9tZxwcYLVNMlgozd8l5+Ly0kSg4OZuNWY2ye8M1va06pTD0mdvnkK
 vdvQ==
X-Gm-Message-State: AOAM533x0rS2MANrB3MZJa0ljPZC6kqPeDF2CJJGSw9+eNkLskfFFfP7
 75YFsP6lQ9V9r843DRKCJ6WDFQ==
X-Google-Smtp-Source: ABdhPJwBjP+hA4Oy4Q6UzY3bpDakQPq3HCE59R2PRNvu86H6zjx4Y1dXSMTznllxBSVIarfUAr9JCQ==
X-Received: by 2002:a5d:9249:0:b0:64c:8a57:b7ec with SMTP id
 e9-20020a5d9249000000b0064c8a57b7ecmr2038499iol.65.1651354333946; 
 Sat, 30 Apr 2022 14:32:13 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 188-20020a021dc5000000b0032b52f27d73sm883572jaj.57.2022.04.30.14.32.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 14:32:12 -0700 (PDT)
Date: Sat, 30 Apr 2022 21:32:09 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 14/18] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
Message-ID: <Ym2q2fUwPXNDcMjQ@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-15-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-15-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Gavin,

On Sun, Apr 03, 2022 at 11:39:07PM +0800, Gavin Shan wrote:
> This supports SDEI_EVENT_SIGNAL hypercall. It's used by guest
> to inject event, whose number must be zero to the specified
> vCPU. As the shared event isn't supported, calling vCPU is
> assumed to be the target.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index ebdbe7810cf0..e1f6ab9800ee 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -455,6 +455,48 @@ static unsigned long hypercall_mask(struct kvm_vcpu *vcpu, bool mask)
>  	return ret;
>  }
>  
> +static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *event;
> +	unsigned int num = smccc_get_arg(vcpu, 1);
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/*
> +	 * The event must be the software signaled one, whose number
> +	 * is zero.
> +	 */
> +	if (!kvm_sdei_is_sw_signaled(num)) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	spin_lock(&vsdei->lock);
> +
> +	/* Check if the vcpu has been masked */
> +	if (vsdei->masked) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto unlock;
> +	}

You should still be able to signal an event if the vCPU is masked. Just
means the bit will rot in the pending bitmap until the vCPU is unmasked.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

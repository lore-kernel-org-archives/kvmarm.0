Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BEDC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E048D4BAE8;
	Thu, 10 Nov 2022 09:51:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HJYfD7-mtNEp; Thu, 10 Nov 2022 09:51:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135374BB32;
	Thu, 10 Nov 2022 09:51:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 853264B895
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:02:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WncI1Ms7NfZr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 13:02:03 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47F124B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:02:03 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id
 c3-20020a1c3503000000b003bd21e3dd7aso10172745wma.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 10:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:from:to:cc:subject:date:message-id:reply-to;
 bh=VuTsw6+GkSRwP58GovhtYe/JYxk+oyo+mlW8nXi3XHk=;
 b=c9L+/2+mr+pVaf+wpuESBoLqmizXoqXWcAlhmtmu9t6DBk0yMBH8Uk0jEUCbKU9YLV
 5oDUYWjLaGbzaTXz8G2w1DM+iE3tFkI+D8wq4Yrz9k4pId5WbgjBNvanKY3J8Q69aQsm
 YQ/+H+U6bwxOh7QDA1Ntbys5xrUcQFdOE+3uIKnxEWq5TrZ0SAsQo9EHomlmfg6MPbGG
 EYezTniaGhsm8bPey5aoHm6x2YZmfb5kaKjPrEImej3mAzM3/4JF/9f0FsiDzjwDOVs6
 ZIFVtGSzxG+1xoFAEJxrHhJLcBqi6FqUpkbjnVeIu/92+M2eXVYBKfscHvgzjiIPc86Q
 EDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VuTsw6+GkSRwP58GovhtYe/JYxk+oyo+mlW8nXi3XHk=;
 b=mSYmY60m1/xMLGrYbAtzz29EoWR3sE3qLAUBlkNnwSn3GONWAUa1sPUeW7NC06bhn7
 4M9ZcNMLPce28eIJZnhtRMkUXx5JRCenq9UrJP57zlmrOq+Jl5FvPiMpK9NRL84YstIo
 qclRzSu6nsquT9nHcvKcPb0abPs/fpGr5F1cZthtFGCo54qN7VJZj6Hluz5y065GmCls
 MxDk6XKDCFSv/JwVY1WaPBDRnHezYJ/yXH4nWazG4ig9uJXAO2OVIGOSqnPk2KiihSHc
 yepjcwG+VPyWW5SMyp2/mQVMqYxxcZztGNuoo6Ik57zCCW91ULDyTtnXsJ7qfeFCO3HC
 Pv4Q==
X-Gm-Message-State: ACrzQf07/h9HVHvg3nA9kmAp64MEjbu9L5jRpozx97yMlV1trl5Rflq/
 G9MQHeupWpUjhbTvMv3esS4lIA==
X-Google-Smtp-Source: AMsMyM5nRAXExBmaX/9edNvRducHDs1nArzvmQSX0pCwzRaBpCURrnomLsO/Kxet7CldyN/wPn+q+w==
X-Received: by 2002:a05:600c:4fd5:b0:3cf:9e9b:68f5 with SMTP id
 o21-20020a05600c4fd500b003cf9e9b68f5mr9168709wmq.60.1667844122108; 
 Mon, 07 Nov 2022 10:02:02 -0800 (PST)
Received: from localhost ([95.148.15.66]) by smtp.gmail.com with ESMTPSA id
 n1-20020a5d4841000000b002366c3eefccsm7718037wrs.109.2022.11.07.10.02.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 10:02:01 -0800 (PST)
From: Punit Agrawal <punit.agrawal@bytedance.com>
To: Usama Arif <usama.arif@bytedance.com>
Subject: Re: [v2 3/6] KVM: arm64: Support pvlock preempted via shared structure
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-4-usama.arif@bytedance.com>
Date: Mon, 07 Nov 2022 18:02:01 +0000
Message-ID: <8735au3ap2.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, bagasdotme@gmail.com, maz@kernel.org,
 punit.agrawal@bytedance.com, linux@armlinux.org.uk, liangma@liangbit.com,
 steven.price@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Usama Arif <usama.arif@bytedance.com> writes:

> Implement the service call for configuring a shared structure between a
> VCPU and the hypervisor in which the hypervisor can tell whether the
> VCPU is running or not.
>
> The preempted field is zero if the VCPU is not preempted.
> Any other value means the VCPU has been preempted.
>
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst |  3 ++
>  arch/arm64/include/asm/kvm_host.h         | 18 ++++++++++
>  arch/arm64/include/uapi/asm/kvm.h         |  1 +
>  arch/arm64/kvm/Makefile                   |  2 +-
>  arch/arm64/kvm/arm.c                      |  8 +++++
>  arch/arm64/kvm/hypercalls.c               |  8 +++++
>  arch/arm64/kvm/pvlock.c                   | 43 +++++++++++++++++++++++
>  tools/arch/arm64/include/uapi/asm/kvm.h   |  1 +
>  8 files changed, 83 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/pvlock.c
>
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index 3e23084644ba..872a16226ace 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -127,6 +127,9 @@ The pseudo-firmware bitmap register are as follows:
>      Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
>        The bit represents the Precision Time Protocol KVM service.
>  
> +    Bit-2: KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK:
> +      The bit represents the Paravirtualized lock service.
> +
>  Errors:
>  
>      =======  =============================================================
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45e2136322ba..18303b30b7e9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -417,6 +417,11 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* Guest PV lock state */
> +	struct {
> +		gpa_t base;
> +	} pv;

Using "pv" for the structure isn't quite describing the usage well. It'd
be better to call it "pv_lock" or "pvlock" at the least.

[...]

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

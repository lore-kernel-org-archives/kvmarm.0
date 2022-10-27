Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8464DFA373D
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 07:38:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9AF4079D;
	Thu, 27 Oct 2022 03:38:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id knnhiAjSHhyl; Thu, 27 Oct 2022 03:38:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 595C640AEB;
	Thu, 27 Oct 2022 03:38:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 376234079D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 03:38:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HqdeN6a1B1ZW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 03:38:28 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B377E4040B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 03:38:28 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id h14so749802pjv.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 00:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=VKQSudBZvWki0+CLHG9r3IJk/dRwqSLfexPzsqrOL10=;
 b=x1Vidfs809+nxHcSntjvb/QuAdCG/z26RlTfItr4BZ9GE6g8GavghOayuC4MBT/FZB
 kT0kux16HUr9NO46eRsomZONq8pXnJ1jwrcuCz9YkE3UXxEttVvN4mLLBjIAVuOeXyGL
 QT4FGgxubG6/xLSAjLDBGs566fxEhoXOGphArVzf9Q1Rk9fBfBV3iz7OZX5TXob34wgq
 JrNW3q9mVdkUMnZNIu4+hptcIxzJ4/DY5YAN9coC9YrQQBsM6JjNRaoUMom6IjxOYGdG
 AXMkgiiwlFEB/PsR67CLg3fbtTfM+sUJhiYGsJik+BeQsyi6xwlii/IWNnYzzCstX0wt
 Yuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VKQSudBZvWki0+CLHG9r3IJk/dRwqSLfexPzsqrOL10=;
 b=PPNpo85CrH4n2HxFFiIR3yDgoteBnCLtIZ9yuS3+EZYjljGBP0NA/bfRUIhTvyASW+
 5T3OL/6XPC6clPvmmu69uteSzinWXhKUQ7RzgJU3KZx52S/7Ttj2EOUzoIEKGt2mT968
 CP5e0QGY24xNCv07EWd5+gFgcJrQvF9gNi8Zbf7oSXBLu2DRcC5sG+5oVfjoZMNK0rQf
 Afc8ryHoFqsxjJqiHAlYs3IIhDJ/gIsAXYXdACTGBn+k7+l0NtA/OYutCCuUP1mddnlq
 l7UMGLVD1YBcP4+pcQPIKoZVTjPvICS3ajpp06Voi5DRPxmTW5DxTeP81Jjg5SUbZ7Sk
 d0EA==
X-Gm-Message-State: ACrzQf3NIixxo4feS3Xuz2pXqalmNqPeVeHv5VOgcJlE909M/4YQo0OA
 4I8YZrLqrGhn+Y6Y+UudBr9KEw==
X-Google-Smtp-Source: AMsMyM6H1exe3qYH4Ks+/ZVGoyDVw8cDO6zYG/dyVO3aZTV3T/P8NAf+BoYHwqqdQxR4cjI0F5IXhg==
X-Received: by 2002:a17:902:f641:b0:17f:3633:5439 with SMTP id
 m1-20020a170902f64100b0017f36335439mr48542732plg.94.1666856307429; 
 Thu, 27 Oct 2022 00:38:27 -0700 (PDT)
Received: from [192.168.10.153]
 (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
 by smtp.gmail.com with ESMTPSA id
 y1-20020a17090264c100b00178ab008364sm548557pli.37.2022.10.27.00.38.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 Oct 2022 00:38:26 -0700 (PDT)
Message-ID: <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
Date: Thu, 27 Oct 2022 18:38:12 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
To: kvm@vger.kernel.org
References: <20221003235722.2085145-1-aik@ozlabs.ru>
From: Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20221003235722.2085145-1-aik@ozlabs.ru>
Cc: kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Paolo, ping?


On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> KVM on POWER9 has never implemented it - the compatibility mode code
> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> XIVE mode does not handle INTx in KVM at all.
> 
> This moved the capability support advertising to platforms and stops
> advertising it on XIVE, i.e. POWER9 and later.
> 
> This should cause no behavioural change for other architectures.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> ---
> Changes:
> v4:
> * removed incorrect clause about changing behavoir on MIPS and RISCV
> 
> v3:
> * removed all ifdeferry
> * removed the capability for MIPS and RISCV
> * adjusted the commit log about MIPS and RISCV
> 
> v2:
> * removed ifdef for ARM64.
> ---
>   arch/arm64/kvm/arm.c       | 1 +
>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>   arch/s390/kvm/kvm-s390.c   | 1 +
>   arch/x86/kvm/x86.c         | 1 +
>   virt/kvm/kvm_main.c        | 1 -
>   5 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2ff0ef62abad..d2daa4d375b5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
>   	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index fb1490761c87..908ce8bd91c9 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   #endif
>   
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +		r = !xive_enabled();
> +		break;
> +#endif
> +
>   	case KVM_CAP_PPC_ALLOC_HTAB:
>   		r = hv_enabled;
>   		break;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..7521adadb81b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
>   	case KVM_CAP_S390_MEM_OP_EXTENSION:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..2d6c5a8fdf14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VAPIC:
>   	case KVM_CAP_ENABLE_CAP:
>   	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 584a5bab3af3..05cf94013f02 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4447,7 +4447,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>   #endif
>   #ifdef CONFIG_HAVE_KVM_IRQFD
>   	case KVM_CAP_IRQFD:
> -	case KVM_CAP_IRQFD_RESAMPLE:
>   #endif
>   	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>   	case KVM_CAP_CHECK_EXTENSION_VM:

-- 
Alexey
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

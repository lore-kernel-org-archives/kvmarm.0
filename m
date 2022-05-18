Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE07C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 07:32:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6424B324;
	Wed, 18 May 2022 03:32:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L7+WtpGCxbF0; Wed, 18 May 2022 03:32:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2D24B319;
	Wed, 18 May 2022 03:32:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1105B4B308
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 02:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ygus0V+W-gz5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 02:27:49 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11BBE4B301
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 02:27:48 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id s14so862783plk.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 23:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=75xfyRYdtbbnySXqxmJnPbT1F8O/OC516UJoNDb3t+I=;
 b=rU4jPYNN5+avyZvAhBPhq7YZ6GjdV3WB7hpSv3vUe8rapXH3vJwLu4MUdpNlxV7Vc7
 AV8lrXHmL8UpJxDY3siQzlIi1kvlEXBUds9/aloM3MCUVjIMrI4iBAGYA3gy0JSQINos
 J2NLdYng7g+nuuokCoIgmaPM+rIZ4qqyHTrVrqikCReYskpXMfmVSw50Tuf7ydEKBM2g
 PUMz0bT1ksqn8xtF4/6i6km4yBy40ueQ2nK1Qg8YPCIwQ/sBVS9ZuWg1r+69cmGh3Cvg
 9pioG246hcisDKCTphyRZWV73OSMQekwe7OZpLnVyClkygpRM+XSdD6zw+4AQbzOaROG
 Zvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=75xfyRYdtbbnySXqxmJnPbT1F8O/OC516UJoNDb3t+I=;
 b=a2zy/vGTllZFytbCpSB10+Brm4dXxQR3rBwkBdu6EEalTS+8vGBmfqS/sIp6tDSZEk
 L9FG9YfIbGUqZDd+9UfMjiqPsV0NlrZCPO8VsWJqNSGKx8toSG7BgHf3qXA71EI7oBq8
 SIrCgvkcwBhRPEH2AMcwgXPbeVVr9d1bFg5ugPlPBKMWKSxsnz8uBiK/OGW47jV4uJPV
 hol9m3V1CtDmES3CS5o2A/Z7+R5w0YsAWSJhVmaWb5cEUqmUmOdYPee2drBjf/glWUAx
 5SKDm2BhCU7avgj6KLWMw7EwLxZEyebqkJ8MZbCbH/OJi8PXnIQ7k8IX4IlWuayD/r61
 9hUw==
X-Gm-Message-State: AOAM532ft8ISNQKSaakHYAjJP0FHZ+NUPfpWlIi+sTVR8w4J2K1Sn6da
 xthfQcZPZ4gzG5eqDJAcV3Wmbg==
X-Google-Smtp-Source: ABdhPJw8YU30pDANG+wArZ1ct34zmOOlVc4nOxwpHMfezBscu5qQRFfree+bbOiz/rSK3BWzuNhG2w==
X-Received: by 2002:a17:90b:4f87:b0:1dd:100b:7342 with SMTP id
 qe7-20020a17090b4f8700b001dd100b7342mr39908296pjb.64.1652855267956; 
 Tue, 17 May 2022 23:27:47 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au.
 [110.175.254.242]) by smtp.gmail.com with ESMTPSA id
 g3-20020a62f943000000b0050dc762815dsm895132pfm.55.2022.05.17.23.27.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 17 May 2022 23:27:47 -0700 (PDT)
Message-ID: <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
Date: Wed, 18 May 2022 16:27:41 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
Content-Language: en-US
To: kvm-ppc@vger.kernel.org
References: <20220504074807.3616813-1-aik@ozlabs.ru>
From: Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220504074807.3616813-1-aik@ozlabs.ru>
X-Mailman-Approved-At: Wed, 18 May 2022 03:32:09 -0400
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Fabiano Rosas <farosas@linux.ibm.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, linux-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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



On 5/4/22 17:48, Alexey Kardashevskiy wrote:
> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> KVM on POWER9 has never implemented it - the compatibility mode code
> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> XIVE mode does not handle INTx in KVM at all.
> 
> This moved the capability support advertising to platforms and stops
> advertising it on XIVE, i.e. POWER9 and later.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> 
> Or I could move this one together with KVM_CAP_IRQFD. Thoughts?


Ping?

> 
> ---
>   arch/arm64/kvm/arm.c       | 3 +++
>   arch/mips/kvm/mips.c       | 3 +++
>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>   arch/riscv/kvm/vm.c        | 3 +++
>   arch/s390/kvm/kvm-s390.c   | 3 +++
>   arch/x86/kvm/x86.c         | 3 +++
>   virt/kvm/kvm_main.c        | 1 -
>   7 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 523bc934fe2f..092f0614bae3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..0f3de470a73e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1071,6 +1071,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_READONLY_MEM:
>   	case KVM_CAP_SYNC_MMU:
>   	case KVM_CAP_IMMEDIATE_EXIT:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>   		r = 1;
>   		break;
>   	case KVM_CAP_NR_VCPUS:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 875c30c12db0..87698ffef3be 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -591,6 +591,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index c768f75279ef..b58579b386bb 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -63,6 +63,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_READONLY_MEM:
>   	case KVM_CAP_MP_STATE:
>   	case KVM_CAP_IMMEDIATE_EXIT:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>   		r = 1;
>   		break;
>   	case KVM_CAP_NR_VCPUS:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 156d1c25a3c1..85e093fc8d13 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -564,6 +564,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
>   	case KVM_CAP_S390_MEM_OP_EXTENSION:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c0ca599a353..a0a7b769483d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4273,6 +4273,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SYS_ATTRIBUTES:
>   	case KVM_CAP_VAPIC:
>   	case KVM_CAP_ENABLE_CAP:
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +#endif
>   		r = 1;
>   		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..885e72e668a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4293,7 +4293,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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

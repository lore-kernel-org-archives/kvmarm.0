Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D299C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:05:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA9B460E9B
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EA9B460E9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64836407F4;
	Thu, 12 Aug 2021 05:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sXoRA8eJGKWu; Thu, 12 Aug 2021 05:05:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F05E49E93;
	Thu, 12 Aug 2021 05:05:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C201440839
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:05:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lgYHuK4eEPqg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:05:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E143D407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:05:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628759105;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JgMWN7/eNl2nw6MdbRkVkIrc4drjFaFJaW8jw61Jzlk=;
 b=VkaZMFBnHG8t6faXW+wSIxKBhQ/7wpXJD1VHOSFwXelNS0d4Biu1k4qXvicixLa5bPRAja
 yT6CjXsZ98uzhLnjKVHOvNvt3hMSoMPvq1DyvB2X2K7UKwmO+sx/snv+DUftlgH3Kqu45n
 tMoyhQp8lMlc5lRhaPrE4cp32SHArBY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-koudisYJO0KbO_rNORYYAQ-1; Thu, 12 Aug 2021 05:05:02 -0400
X-MC-Unique: koudisYJO0KbO_rNORYYAQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 x18-20020a5d49120000b0290154e9dcf3dbso1602665wrq.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=JgMWN7/eNl2nw6MdbRkVkIrc4drjFaFJaW8jw61Jzlk=;
 b=gpSx2UIvOgqW5st4o0LYzXrQwQc5UavKq2aQvx0Jb9MjQyABeO0z2TX/6ISdH0ZtdK
 F4iIv9ge125KdIkbE+vSvnh1Km+QX15NF5fxjyr3FOx6AYnnQA1lpGSc81QWYU3juLSD
 RdC0tH90reK+Fu4hOBANfndSzhxfEZZx2Ms7ETFKishvXqFXuoMvVRSdetkynl1AjjNI
 MyfYMsuza9MCzLQKUMBs2qiqrMpuxWqGGpQzkNUiQ24DzqzP/159Ly54W8go1fe//pV+
 jEPigPLl3/hOUB2Rx45B3hElGmVGreswK8tl53XbAtvqKmeCfQlrVYl4PmRNRY3rHgk7
 oJ7w==
X-Gm-Message-State: AOAM530cS6ylLL0zzB4iDRiL8UVNQL77bpLLYhl1woa7rQqh+SlzBWGB
 gCmyAJWQtDqpgGwTb0zePWBLNmpH9FiNBCb+WgSVbUT67Pod8r8XMq+7/27YVt6GdLzbOiPV5GT
 +e4e6TcTcHpNjwPAMPmrg1hHS
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr2798702wrq.153.1628759100830; 
 Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw14l6W1wkrgjVxsT5cj4nrtOlS6mn0en/HDpnzJRRlmx+RwnP3XwnlZp0HL14993xrDLfaIA==
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr2798682wrq.153.1628759100598; 
 Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d8b.dip0.t-ipconnect.de. [79.242.61.139])
 by smtp.gmail.com with ESMTPSA id i21sm2300276wrb.62.2021.08.12.02.04.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 Aug 2021 02:05:00 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a
 struct page pointer
To: Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
References: <YRQcZqCWwVH8bCGc@google.com>
 <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
Date: Thu, 12 Aug 2021 11:04:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On 12.08.21 06:02, Hou Wenlong wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Refactor kvm_arch_vcpu_fault() to return 'struct page *' instead of
> 'vm_fault_t' to simplify architecture specific implementations that do
> more than return SIGBUS.  Currently this only applies to s390, but a
> future patch will move x86's pio_data handling into x86 where it belongs.
> 
> No functional changed intended.
> 
> Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>   arch/arm64/kvm/arm.c       |  4 ++--
>   arch/mips/kvm/mips.c       |  4 ++--
>   arch/powerpc/kvm/powerpc.c |  4 ++--
>   arch/s390/kvm/kvm-s390.c   | 12 ++++--------
>   arch/x86/kvm/x86.c         |  4 ++--
>   include/linux/kvm_host.h   |  2 +-
>   virt/kvm/kvm_main.c        |  5 ++++-
>   7 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..83f4ffe3e4f2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -161,9 +161,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	return ret;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index af9dd029a4e1..ae79874e6fd2 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1053,9 +1053,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>   	return -ENOIOCTLCMD;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index be33b5321a76..b9c21f9ab784 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -2090,9 +2090,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 02574d7b3612..e1b69833e228 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4979,17 +4979,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
>   #ifdef CONFIG_KVM_S390_UCONTROL
> -	if ((vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET)
> -		 && (kvm_is_ucontrol(vcpu->kvm))) {
> -		vmf->page = virt_to_page(vcpu->arch.sie_block);
> -		get_page(vmf->page);
> -		return 0;
> -	}
> +	if (vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET && kvm_is_ucontrol(vcpu->kvm))
> +		return virt_to_page(vcpu->arch.sie_block);
>   #endif
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   /* Section: memory related */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3cedc7cc132a..1e3bbe5cd33a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5347,9 +5347,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	return r;
>   }
>   
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>   {
> -	return VM_FAULT_SIGBUS;
> +	return NULL;
>   }
>   
>   static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 492d183dd7d0..a949de534722 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -995,7 +995,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg);
> -vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
> +struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 30d322519253..f7d21418971b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3448,7 +3448,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>   		    &vcpu->dirty_ring,
>   		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
>   	else
> -		return kvm_arch_vcpu_fault(vcpu, vmf);
> +		page = kvm_arch_vcpu_fault(vcpu, vmf);
> +	if (!page)
> +		return VM_FAULT_SIGBUS;
> +
>   	get_page(page);
>   	vmf->page = page;
>   	return 0;
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

But at the same time I wonder if we should just get rid of 
CONFIG_KVM_S390_UCONTROL and consequently kvm_arch_vcpu_fault().


In practice CONFIG_KVM_S390_UCONTROL, is never enabled in any reasonable 
kernel build and consequently it's never tested; further, exposing the 
sie_block to user space allows user space to generate random SIE 
validity intercepts.

CONFIG_KVM_S390_UCONTROL feels like something that should just be 
maintained out of tree by someone who really needs to hack deep into hw 
virtualization for testing purposes etc.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

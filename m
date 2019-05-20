Return-Path: <SRS0=onLC=TU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D03CC04AAC
	for <kvmarm@archiver.kernel.org>; Mon, 20 May 2019 13:43:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1497C20856
	for <kvmarm@archiver.kernel.org>; Mon, 20 May 2019 13:43:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1497C20856
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8A64A4A0;
	Mon, 20 May 2019 09:43:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g9VIUnEPz2wT; Mon, 20 May 2019 09:43:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2E5F4A4C3;
	Mon, 20 May 2019 09:43:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11C5E4A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 May 2019 09:43:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id edBclmvhr-TF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 May 2019 09:43:46 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7979F4A331
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 May 2019 09:43:46 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id d18so14692220wrs.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 May 2019 06:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=QfhVu7i0f7PGhiAFSRgiVL/qFyH0Mxci0ZH8NmzFfa0=;
 b=tjBz7KLCwUS3DZjRgDZhNNfesgttPN1yaxl0jm9DEz0TmIMfyN8EQ/lfX2cE1J15VJ
 uuMgul09r/lHmplo4L8hgwGmrFuXuqBfICZot62RYPdZPFrWjsAiko6RRQIji76mc5Fb
 V+bHauazFP20avYc/jHZNlc04ze6221D9z5Hze1ECHVFrA1SVa7MfZNEggIptnIbvVOK
 kOhJtEY5S2O4sqaJh6dfPIru4/dudusxXPZdNX3SD1RfDsK2rYNBHQHUUtbbmoFY4jUl
 Ch6OF0g0SM3dzLXO7IjGgJrJOWh/it+7LWtEJHfRHtu0fBGiUyC0ayYdxv1JoWhywHXd
 wQrA==
X-Gm-Message-State: APjAAAVczrUe52qEbxx6VHNVJ+lPsljFdLG0LEGQabyKgDVMrjqXPcEm
 +yU/V1JL6LQvn/oUs4shAjzDfl7KCi9bcA==
X-Google-Smtp-Source: APXvYqwhMW4qTcPvNNhvZyg7Nr2Dre/Plb85jfTr32mjs9jJbdCtxJLLOLvDyzXXb3guDMS7YvWryA==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr7859695wru.44.1558359825304; 
 Mon, 20 May 2019 06:43:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844?
 ([2001:b07:6468:f312:ac04:eef9:b257:b844])
 by smtp.gmail.com with ESMTPSA id x22sm16824884wmi.4.2019.05.20.06.43.44
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 20 May 2019 06:43:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: Directly return result from
 kvm_arch_check_processor_compat()
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
References: <20190420051817.5644-1-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <050c13ef-6797-bff9-58a9-674f6fee9d72@redhat.com>
Date: Mon, 20 May 2019 15:43:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190420051817.5644-1-sean.j.christopherson@intel.com>
Content-Language: en-US
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 20/04/19 07:18, Sean Christopherson wrote:
> Add a wrapper to invoke kvm_arch_check_processor_compat() so that the
> boilerplate ugliness of checking virtualization support on all CPUs is
> hidden from the arch specific code.  x86's implementation in particular
> is quite heinous, as it unnecessarily propagates the out-param pattern
> into kvm_x86_ops.
> 
> While the x86 specific issue could be resolved solely by changing
> kvm_x86_ops, make the change for all architectures as returning a value
> directly is prettier and technically more robust, e.g. s390 doesn't set
> the out param, which could lead to subtle breakage in the (highly
> unlikely) scenario where the out-param was not pre-initialized by the
> caller.
> 
> Opportunistically annotate svm_check_processor_compat() with __init.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Tested on VMX only.
> 
>  arch/mips/kvm/mips.c             | 4 ++--
>  arch/powerpc/kvm/powerpc.c       | 4 ++--
>  arch/s390/include/asm/kvm_host.h | 1 -
>  arch/s390/kvm/kvm-s390.c         | 5 +++++
>  arch/x86/include/asm/kvm_host.h  | 2 +-
>  arch/x86/kvm/svm.c               | 4 ++--
>  arch/x86/kvm/vmx/vmx.c           | 8 ++++----
>  arch/x86/kvm/x86.c               | 4 ++--
>  include/linux/kvm_host.h         | 2 +-
>  virt/kvm/arm/arm.c               | 4 ++--
>  virt/kvm/kvm_main.c              | 9 ++++++---
>  11 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 6d0517ac18e5..1c22b938c550 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -123,9 +123,9 @@ int kvm_arch_hardware_setup(void)
>  	return 0;
>  }
>  
> -void kvm_arch_check_processor_compat(void *rtn)
> +int kvm_arch_check_processor_compat(void)
>  {
> -	*(int *)rtn = 0;
> +	return 0;
>  }
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 92910b7c5bcc..7b7635201739 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -425,9 +425,9 @@ int kvm_arch_hardware_setup(void)
>  	return 0;
>  }
>  
> -void kvm_arch_check_processor_compat(void *rtn)
> +int kvm_arch_check_processor_compat(void)
>  {
> -	*(int *)rtn = kvmppc_core_check_processor_compat();
> +	return kvmppc_core_check_processor_compat();
>  }
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index c47e22bba87f..96a1603ecf10 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -903,7 +903,6 @@ extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
>  extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
>  
>  static inline void kvm_arch_hardware_disable(void) {}
> -static inline void kvm_arch_check_processor_compat(void *rtn) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 28f35d2b06cb..4c50bd533ebc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -221,6 +221,11 @@ int kvm_arch_hardware_enable(void)
>  	return 0;
>  }
>  
> +int kvm_arch_check_processor_compat(void)
> +{
> +	return 0;
> +}
> +
>  static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  			      unsigned long end);
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8d68ba0cba0c..02ba99ef8c5f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -995,7 +995,7 @@ struct kvm_x86_ops {
>  	int (*disabled_by_bios)(void);             /* __init */
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	void (*check_processor_compatibility)(void *rtn);
> +	int (*check_processor_compatibility)(void);/* __init */
>  	int (*hardware_setup)(void);               /* __init */
>  	void (*hardware_unsetup)(void);            /* __exit */
>  	bool (*cpu_has_accelerated_tpr)(void);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 406b558abfef..236e2fc0edec 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5859,9 +5859,9 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
>  	hypercall[2] = 0xd9;
>  }
>  
> -static void svm_check_processor_compat(void *rtn)
> +static int __init svm_check_processor_compat(void)
>  {
> -	*(int *)rtn = 0;
> +	return 0;
>  }
>  
>  static bool svm_cpu_has_accelerated_tpr(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d8f101b58ab8..7d0733b8f383 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6720,22 +6720,22 @@ static int vmx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> -static void __init vmx_check_processor_compat(void *rtn)
> +static int __init vmx_check_processor_compat(void)
>  {
>  	struct vmcs_config vmcs_conf;
>  	struct vmx_capability vmx_cap;
>  
> -	*(int *)rtn = 0;
>  	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
> -		*(int *)rtn = -EIO;
> +		return -EIO;
>  	if (nested)
>  		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept,
>  					   enable_apicv);
>  	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
>  		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
>  				smp_processor_id());
> -		*(int *)rtn = -EIO;
> +		return -EIO;
>  	}
> +	return 0;
>  }
>  
>  static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c09507057743..6214c27b0c2a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9042,9 +9042,9 @@ void kvm_arch_hardware_unsetup(void)
>  	kvm_x86_ops->hardware_unsetup();
>  }
>  
> -void kvm_arch_check_processor_compat(void *rtn)
> +int kvm_arch_check_processor_compat(void)
>  {
> -	kvm_x86_ops->check_processor_compatibility(rtn);
> +	return kvm_x86_ops->check_processor_compatibility();
>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 640a03642766..0ddef348b9b0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -842,7 +842,7 @@ int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void);
>  void kvm_arch_hardware_unsetup(void);
> -void kvm_arch_check_processor_compat(void *rtn);
> +int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index be4ec5f3ba5f..67ecadbd8961 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -105,9 +105,9 @@ int kvm_arch_hardware_setup(void)
>  	return 0;
>  }
>  
> -void kvm_arch_check_processor_compat(void *rtn)
> +int kvm_arch_check_processor_compat(void)
>  {
> -	*(int *)rtn = 0;
> +	return 0;
>  }
>  
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4bb20f2b2a69..41effae3f9ec 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4135,6 +4135,11 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  	kvm_arch_vcpu_put(vcpu);
>  }
>  
> +static void check_processor_compat(void *rtn)
> +{
> +	*(int *)rtn = kvm_arch_check_processor_compat();
> +}
> +
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		  struct module *module)
>  {
> @@ -4166,9 +4171,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		goto out_free_0a;
>  
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu,
> -				kvm_arch_check_processor_compat,
> -				&r, 1);
> +		smp_call_function_single(cpu, check_processor_compat, &r, 1);
>  		if (r < 0)
>  			goto out_free_1;
>  	}
> 

Queued for 5.3, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

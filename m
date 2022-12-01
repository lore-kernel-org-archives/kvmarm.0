Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E60C43217
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 15:22:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FEF8403AD;
	Thu,  1 Dec 2022 10:22:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JTdzWeHmo1zG; Thu,  1 Dec 2022 10:22:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0998D40719;
	Thu,  1 Dec 2022 10:22:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE2040385
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:22:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3R-a71yql0t6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 10:22:52 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B80274018F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:22:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669908172;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=0uolOOp7yoOC/673O4rWJ2SQim3eJ9tGJUopqkFhibc=;
 b=B+Uzk/aU+G0kyeVnZME32d4YN4l7sLEVdy7VP6JuIJVqdFtpi6L4u9AR4foUS4yhJn04ji
 IbCpdEjCFiv/Ox5p9ri3H0diiVKuINuS06MGQTlm7eAeA92w2eMUUp1TObuZXodswa8hnv
 xYmqwHPcu0DVGFsFXIzPOza1/s2AbEU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-aJm1wF8hMbK09cGwSLi8vg-1; Thu, 01 Dec 2022 10:22:51 -0500
X-MC-Unique: aJm1wF8hMbK09cGwSLi8vg-1
Received: by mail-wm1-f72.google.com with SMTP id
 v125-20020a1cac83000000b003cfa148576dso989547wme.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 07:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0uolOOp7yoOC/673O4rWJ2SQim3eJ9tGJUopqkFhibc=;
 b=5SQaOlMwL2oyqV8AQWOA1GNoJU7n9GkjGCOMi7eixW+O2Furu6wSXT4nd7wNn/BhFX
 Q22w1k8r5+BLbq5oI1tljJ3rKKRNCe51ObZeswt4/kOenCeI+h3kKwRn6K+vROjHqm4X
 YXYVaBVpudzDh3Y0vXHbyZU1Obc2hCV/qkBVpL9dbDl2nUmghxajNtuOgGcNvFs/lyWj
 XoSfla5sl8yLr6a/DlvU1C9l1XsTG30rn2Lw+zSzlFv96MQDpwmxze+9BwKMM2O4cdua
 D1b6tFfsGrmTwtU2Ep7Gkga6US0XZodVDystzRxXi4Cq2iXR+cCzB+XNwJTTpAWYGykR
 +8+A==
X-Gm-Message-State: ANoB5pmas6VjDTJ3KU8Q7kymdDZszLOBQ0Z07tfLzH/X3AslaAQJZFHS
 rjied0Wom+5Jo5e+9OWYrD7Y+SNy5D1jGwf6GeDccVaU8v3Uoc2Bql4ZcRRJNopf5mA0m124CLN
 TskdvKOYGwf2ab1pC2GcOD+mR
X-Received: by 2002:adf:f54e:0:b0:242:1534:7b57 with SMTP id
 j14-20020adff54e000000b0024215347b57mr14035646wrp.404.1669908170127; 
 Thu, 01 Dec 2022 07:22:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4+3YusiSWHR13O3MACnIQbSphop/g7AmmIFME21D1fv2+5ZYUMJJrVIeLUQmj0nQTJeAmHuA==
X-Received: by 2002:adf:f54e:0:b0:242:1534:7b57 with SMTP id
 j14-20020adff54e000000b0024215347b57mr14035606wrp.404.1669908169821; 
 Thu, 01 Dec 2022 07:22:49 -0800 (PST)
Received: from ovpn-194-141.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id
 j11-20020a05600c190b00b003b47e75b401sm10593279wmq.37.2022.12.01.07.22.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 07:22:49 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 12/50] KVM: VMX: Move Hyper-V eVMCS initialization to
 helper
In-Reply-To: <20221130230934.1014142-13-seanjc@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-13-seanjc@google.com>
Date: Thu, 01 Dec 2022 16:22:45 +0100
Message-ID: <87k03bf8sa.fsf@ovpn-194-141.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 David Woodhouse <dwmw2@infradead.org>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Paul Durrant <paul@xen.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Sean Christopherson <seanjc@google.com> writes:

> Move Hyper-V's eVMCS initialization to a dedicated helper to clean up
> vmx_init(), and add a comment to call out that the Hyper-V init code
> doesn't need to be unwound if vmx_init() ultimately fails.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 73 +++++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c0de7160700b..b8bf95b9710d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -523,6 +523,8 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>  static unsigned long host_idt_base;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> +static struct kvm_x86_ops vmx_x86_ops __initdata;
> +
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> @@ -551,6 +553,43 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static __init void hv_init_evmcs(void)
> +{
> +	int cpu;
> +
> +	if (!enlightened_vmcs)
> +		return;
> +
> +	/*
> +	 * Enlightened VMCS usage should be recommended and the host needs
> +	 * to support eVMCS v1 or above.
> +	 */
> +	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> +	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
> +	     KVM_EVMCS_VERSION) {
> +
> +		/* Check that we have assist pages on all online CPUs */
> +		for_each_online_cpu(cpu) {
> +			if (!hv_get_vp_assist_page(cpu)) {
> +				enlightened_vmcs = false;
> +				break;
> +			}
> +		}
> +
> +		if (enlightened_vmcs) {
> +			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> +			static_branch_enable(&enable_evmcs);
> +		}
> +
> +		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> +			vmx_x86_ops.enable_l2_tlb_flush
> +				= hv_enable_l2_tlb_flush;
> +
> +	} else {
> +		enlightened_vmcs = false;
> +	}
> +}
> +
>  static void hv_reset_evmcs(void)
>  {
>  	struct hv_vp_assist_page *vp_ap;
> @@ -577,6 +616,7 @@ static void hv_reset_evmcs(void)
>  }
>  
>  #else /* IS_ENABLED(CONFIG_HYPERV) */
> +static void hv_init_evmcs(void) {}
>  static void hv_reset_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
> @@ -8500,38 +8540,11 @@ static int __init vmx_init(void)
>  {
>  	int r, cpu;
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
>  	/*
> -	 * Enlightened VMCS usage should be recommended and the host needs
> -	 * to support eVMCS v1 or above. We can also disable eVMCS support
> -	 * with module parameter.
> +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> +	 * to unwind if a later step fails.
>  	 */
> -	if (enlightened_vmcs &&
> -	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> -	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
> -	    KVM_EVMCS_VERSION) {
> -
> -		/* Check that we have assist pages on all online CPUs */
> -		for_each_online_cpu(cpu) {
> -			if (!hv_get_vp_assist_page(cpu)) {
> -				enlightened_vmcs = false;
> -				break;
> -			}
> -		}
> -
> -		if (enlightened_vmcs) {
> -			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> -			static_branch_enable(&enable_evmcs);
> -		}
> -
> -		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> -			vmx_x86_ops.enable_l2_tlb_flush
> -				= hv_enable_l2_tlb_flush;
> -
> -	} else {
> -		enlightened_vmcs = false;
> -	}
> -#endif
> +	hv_init_evmcs();
>  
>  	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

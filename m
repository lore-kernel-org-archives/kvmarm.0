Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EB6FCB
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669908174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0uolOOp7yoOC/673O4rWJ2SQim3eJ9tGJUopqkFhibc=;
	b=T4plrYYBaB8hdH6jF7EmpM3WUJ3Uky4GEKRqEXxBt9CBrvbZ76pQsSXzQ1dHfvxCFMTnpu
	xuhPsQI1sjVRHwmDtedlYvjVWtNHl6lL/v+/GYsTxveWCHOk0Bm1S7G4MvMfV9zPuux1/B
	+nvlfkTY21+3smedCtE/LvsLXmXsahA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-LHQ3lFP7PwuZgiEz9YtJ6w-1; Thu, 01 Dec 2022 10:22:51 -0500
X-MC-Unique: LHQ3lFP7PwuZgiEz9YtJ6w-1
Received: by mail-wr1-f71.google.com with SMTP id e19-20020adfa453000000b0024209415034so513439wra.18
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 07:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0uolOOp7yoOC/673O4rWJ2SQim3eJ9tGJUopqkFhibc=;
        b=LXfwGVEna7UURgftGyfTIeeXyG6XuxoXgNMF0WujOBMQLXEUQuIKmE5cv9RJs3LzjA
         Pvm8gZJvBYR/TfSkRr+Bo0N+re23B8lnjodc7BS+Op62Fktl9n8ctWtulUbpO9NxHjGh
         5SwOw8LPvNorhPH8ZVAi0d9NWaxb1WfX0zlxmhlA1nh7e+Luk2QZuKvnb7pl1daCugFh
         WD0PdCB9etf2HXlHWROWNnsWXDJ7eYgab2L1WxlOfMT4j2WuBUpTQZ7SIzrLJkT6feRB
         3IqIaT8Nlqr4ADmuG4ByGJu+ILvxvi594gSBn7JJ24+tYl35QFIy6KaiSNBcj7Jc7YAT
         eHfg==
X-Gm-Message-State: ANoB5pnPCdDw2fdLWXD658UgTNF8ZW6anzgSA3rLXTtcbFFsZ8DIE1mv
	X4FFOKIGFDh6XYC0x4w//4Pe4qNq12bpW51zZNkd33CC7Dt/O1oWwtRxOpJkF83DyNUapUh0Swe
	/sy9eltGpHwwGlgyx
X-Received: by 2002:adf:f54e:0:b0:242:1534:7b57 with SMTP id j14-20020adff54e000000b0024215347b57mr14035618wrp.404.1669908170120;
        Thu, 01 Dec 2022 07:22:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4+3YusiSWHR13O3MACnIQbSphop/g7AmmIFME21D1fv2+5ZYUMJJrVIeLUQmj0nQTJeAmHuA==
X-Received: by 2002:adf:f54e:0:b0:242:1534:7b57 with SMTP id j14-20020adff54e000000b0024215347b57mr14035606wrp.404.1669908169821;
        Thu, 01 Dec 2022 07:22:49 -0800 (PST)
Received: from ovpn-194-141.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j11-20020a05600c190b00b003b47e75b401sm10593279wmq.37.2022.12.01.07.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 07:22:49 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra
 <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Yuan Yao
 <yuan.yao@intel.com>, Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>, Chao Gao
 <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Sean
 Christopherson <seanjc@google.com>, David Woodhouse <dwmw2@infradead.org>,
 Paul Durrant <paul@xen.org>
Subject: Re: [PATCH v2 12/50] KVM: VMX: Move Hyper-V eVMCS initialization to
 helper
In-Reply-To: <20221130230934.1014142-13-seanjc@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-13-seanjc@google.com>
Date: Thu, 01 Dec 2022 16:22:45 +0100
Message-ID: <87k03bf8sa.fsf@ovpn-194-141.brq.redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Message-ID: <20221201152245.6hO42IR3K7AwzbFzXyLG06KbfnbOXh8_Jb8ZbX6xwCE@z>

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


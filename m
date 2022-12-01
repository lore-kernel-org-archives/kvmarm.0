Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF66C43217
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 15:43:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F3540385;
	Thu,  1 Dec 2022 10:43:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8+9TfrMQRnLB; Thu,  1 Dec 2022 10:43:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6335240399;
	Thu,  1 Dec 2022 10:43:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E25340399
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j25ftHwB0Yb3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 10:43:04 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFBF640385
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:43:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669909384;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uICPaEENN8EB00poBiDynBWP9unBSRZ6Eo0ZeloiILw=;
 b=ShDSpJFN0QDtH03IzK5wfnlyUH76O3c7dsbxoFK+KF0E2RVlEAR3LFhECLAXd86gw9UQ/X
 3FrWrq7UepVYdRDfFbakv+ciRtEt2VkXedgY1ubBB3Thq6PYJfP/roq+NZqQvA1N2Tkfx1
 mPSxDMX7PJPfke0HISThbxAYOMGvlMc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-X3Q4GUwyOU-PDicL_0xpfA-1; Thu, 01 Dec 2022 10:43:03 -0500
X-MC-Unique: X3Q4GUwyOU-PDicL_0xpfA-1
Received: by mail-wr1-f70.google.com with SMTP id
 e7-20020adf9bc7000000b00242121eebe2so525742wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 07:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=uICPaEENN8EB00poBiDynBWP9unBSRZ6Eo0ZeloiILw=;
 b=qq6FbIYMzrDKUWxIGkpyjSlt6bqadYy86uCbEnNkafuejn1gRxTTUWZg/yRRZ4rrew
 2lh20zUNqRUwd3d4m4wSavBmaQ6Es99aDQ288XudU9q5S/wWPHFzU2TaIIZ9CXs/hUBC
 1GkSGviGGGTdY2F540qrbzMGQJUXkK9eDZkh29CBhVgzF9V5CF5yHbUCUjeyo+L+2/M/
 rebK0U3gaC7g42VKPxRp4IuzP+eRr55HS3YXd4TzytBSJcdnvmPiS4rH6JuGghvKgM0P
 2FA8QtoR6PY6kcJAmzaHkgrEhjeuliP7PU/SlUvH2mZxpDcJeGtPUMaJ93KkdUT7hdd5
 Vf3A==
X-Gm-Message-State: ANoB5plS7HGif4M7NuL34opgyv9+NXXrq9MrXZXcPQQHGYkGmBQq7g7E
 fYHxU3PihGJjmZFQ6aTLoarUew8ysz+UFxAQxmDT8g4UfvVcXqVOVSfHRX6HbcD8KmY4aGc0obJ
 L+7T+FGy7uJcJJTp7QNyKFjsj
X-Received: by 2002:adf:ecd2:0:b0:236:6fd9:9efa with SMTP id
 s18-20020adfecd2000000b002366fd99efamr39370677wro.101.1669909382084; 
 Thu, 01 Dec 2022 07:43:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4imAxqHpsHzf4lwMnv25YvuYKadYTHsioCJaPqnZlFtnFG20xMn8tkXOhL/ZrHUpQYnEbeIQ==
X-Received: by 2002:adf:ecd2:0:b0:236:6fd9:9efa with SMTP id
 s18-20020adfecd2000000b002366fd99efamr39370625wro.101.1669909381800; 
 Thu, 01 Dec 2022 07:43:01 -0800 (PST)
Received: from ovpn-194-141.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id
 bg28-20020a05600c3c9c00b003cfa3a12660sm9307122wmb.1.2022.12.01.07.42.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 07:43:00 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 10/50] KVM: VMX: Reset eVMCS controls in VP assist
 page during hardware disabling
In-Reply-To: <20221130230934.1014142-11-seanjc@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-11-seanjc@google.com>
Date: Thu, 01 Dec 2022 16:42:58 +0100
Message-ID: <87h6yff7ul.fsf@ovpn-194-141.brq.redhat.com>
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

> Reset the eVMCS controls in the per-CPU VP assist page during hardware
> disabling instead of waiting until kvm-intel's module exit.  The controls
> are activated if and only if KVM creates a VM, i.e. don't need to be
> reset if hardware is never enabled.
>
> Doing the reset during hardware disabling will naturally fix a potential
> NULL pointer deref bug once KVM disables CPU hotplug while enabling and
> disabling hardware (which is necessary to fix a variety of bugs).  If the
> kernel is running as the root partition, the VP assist page is unmapped
> during CPU hot unplug, and so KVM's clearing of the eVMCS controls needs
> to occur with CPU hot(un)plug disabled, otherwise KVM could attempt to
> write to a CPU's VP assist page after it's unmapped.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cea8c07f5229..d85d175dca70 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -551,6 +551,33 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static void hv_reset_evmcs(void)
> +{
> +	struct hv_vp_assist_page *vp_ap;
> +
> +	if (!static_branch_unlikely(&enable_evmcs))
> +		return;
> +
> +	/*
> +	 * KVM should enable eVMCS if and only if all CPUs have a VP assist
> +	 * page, and should reject CPU onlining if eVMCS is enabled the CPU
> +	 * doesn't have a VP assist page allocated.
> +	 */
> +	vp_ap = hv_get_vp_assist_page(smp_processor_id());
> +	if (WARN_ON_ONCE(!vp_ap))
> +		return;
> +

In case my understanding is correct, this may actually get triggered
for Hyper-V root partition: vmx_hardware_disable() gets called from
kvm_dying_cpu() which has its own CPUHP_AP_KVM_STARTING stage. VP page
unmapping happens in hv_cpu_die() which uses generic CPUHP_AP_ONLINE_DYN
(happens first on CPU oflining AFAIR). I believe we need to introduce a
new CPUHP_AP_HYPERV_STARTING stage and put it before
CPUHP_AP_KVM_STARTING so it happens after it upon offlining.

The issue is likely theoretical as Hyper-V root partition is a very
special case, I'm not sure whether KVM is used there and whether CPU
offlining is possible. In any case, WARN_ON_ONCE() is much better than
NULL pointer dereference we have now :-)

> +	/*
> +	 * Reset everything to support using non-enlightened VMCS access later
> +	 * (e.g. when we reload the module with enlightened_vmcs=0)
> +	 */
> +	vp_ap->nested_control.features.directhypercall = 0;
> +	vp_ap->current_nested_vmcs = 0;
> +	vp_ap->enlighten_vmentry = 0;
> +}
> +
> +#else /* IS_ENABLED(CONFIG_HYPERV) */
> +static void hv_reset_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  /*
> @@ -2496,6 +2523,8 @@ static void vmx_hardware_disable(void)
>  	if (cpu_vmxoff())
>  		kvm_spurious_fault();
>  
> +	hv_reset_evmcs();
> +
>  	intel_pt_handle_vmx(0);
>  }
>  
> @@ -8462,27 +8491,8 @@ static void vmx_exit(void)
>  	kvm_exit();
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	if (static_branch_unlikely(&enable_evmcs)) {
> -		int cpu;
> -		struct hv_vp_assist_page *vp_ap;
> -		/*
> -		 * Reset everything to support using non-enlightened VMCS
> -		 * access later (e.g. when we reload the module with
> -		 * enlightened_vmcs=0)
> -		 */
> -		for_each_online_cpu(cpu) {
> -			vp_ap =	hv_get_vp_assist_page(cpu);
> -
> -			if (!vp_ap)
> -				continue;
> -
> -			vp_ap->nested_control.features.directhypercall = 0;
> -			vp_ap->current_nested_vmcs = 0;
> -			vp_ap->enlighten_vmentry = 0;
> -		}
> -
> +	if (static_branch_unlikely(&enable_evmcs))
>  		static_branch_disable(&enable_evmcs);
> -	}
>  #endif
>  	vmx_cleanup_l1d_flush();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF2DC4332B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 640F620735
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 13:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEmIS5Wj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 640F620735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6754A5A0;
	Mon, 23 Mar 2020 09:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u6Zg-uqyUAq1; Mon, 23 Mar 2020 09:35:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9ED94B0BA;
	Mon, 23 Mar 2020 09:35:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF3854B09B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:10:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcKG1Vp3CEIc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 08:10:46 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7D44B08C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:10:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584965446;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KTi6Fbpftif/VSaqN/XQLRD1K5JgrsXFftrydIRiWZs=;
 b=dEmIS5WjQBJtpFM1CvUbPWjHJXTaKn7nU//8GG/AAmonADRMmnsHDcx6qWoKuMOUJuE2BS
 SFViJZRldHkSc+tX0XPj49etA27DKSqL4UQGwEDkhQk5ZrWZPHm4t5UjuHr1sxz2WsLzsv
 ULykLwDhRD5kQ15kqwaEEBJtgpEeFYY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-GuUaQ7-QNXiJPfL3HCTBZg-1; Mon, 23 Mar 2020 08:10:44 -0400
X-MC-Unique: GuUaQ7-QNXiJPfL3HCTBZg-1
Received: by mail-wr1-f69.google.com with SMTP id o18so3878177wrx.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=rHQRdviv+oNnM+wOvy7j9QWQo0zwjiFN+uLtW4Mvpq0=;
 b=ifYUYjHXPJe6X2kq+QrcwFomfOjzjy76TmzfLOtBqE/I6K+wweIC9/iinPl099mnxi
 xotftieLZQ5YF3tZe0ScziMfOPzSz6snLq9KeSr2S6/VejpjqoXROFUbwKRQgBkFxGmJ
 ESBwBgGsnAayZy2x4YenXMxbaL6ro3sluTZ3XZRRQBwKlX6Hvb83C9rTp+19g3PKIxeG
 60tFZ4L0T3iZ1ovPkaOfr1PG0MMIDe/8a37w9jekVIW1XePbqXgZ0zL+jx8cDY30vUjw
 0OCCVbFvqGWhyeRALl5JoW8aQWG0S0D0nzykpHRwsHwFFebnZKOTI2ddZXNFq5LNWcqB
 y8/g==
X-Gm-Message-State: ANhLgQ0Mn0Es6Ce52Jf0U0pEi1jpx64v8fFXAUXsC1GBDjn7I+Blax0Q
 xc2T5w1W6K+ZmO+I8sDOCSBNftU2/gOw6p4yX2KcDmecdhMabOAE9ZsO59OXW0xxhrwM9IMWnxC
 QPt9htTc4+B1llX5sRSRezq7r
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr30662468wrq.180.1584965443486; 
 Mon, 23 Mar 2020 05:10:43 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsLu0mWmhCib7a9L9Z4UgbCUMlvtjWeM7CpEh6ia2EdDdwqHhRYkq8ynpPTFBq7OzYIQ6wpBQ==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr30662429wrq.180.1584965443217; 
 Mon, 23 Mar 2020 05:10:43 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id m7sm957131wro.41.2020.03.23.05.10.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Mar 2020 05:10:42 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Move init-only kvm_x86_ops to separate
 struct
In-Reply-To: <20200321202603.19355-3-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-3-sean.j.christopherson@intel.com>
Date: Mon, 23 Mar 2020 13:10:40 +0100
Message-ID: <87lfnr9sqn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 23 Mar 2020 09:35:35 -0400
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the kvm_x86_ops functions that are used only within the scope of
> kvm_init() into a separate struct, kvm_x86_init_ops.  In addition to
> identifying the init-only functions without restorting to code comments,
> this also sets the stage for waiting until after ->hardware_setup() to
> set kvm_x86_ops.  Setting kvm_x86_ops after ->hardware_setup() is
> desirable as many of the hooks are not usable until ->hardware_setup()
> completes.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 13 +++++++++----
>  arch/x86/kvm/svm.c              | 15 ++++++++++-----
>  arch/x86/kvm/vmx/vmx.c          | 16 +++++++++++-----
>  arch/x86/kvm/x86.c              | 10 ++++++----
>  4 files changed, 36 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9a183e9d4cb1..f4c5b49299ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1054,12 +1054,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  }
>  
>  struct kvm_x86_ops {
> -	int (*cpu_has_kvm_support)(void);          /* __init */
> -	int (*disabled_by_bios)(void);             /* __init */
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	int (*check_processor_compatibility)(void);/* __init */
> -	int (*hardware_setup)(void);               /* __init */
>  	void (*hardware_unsetup)(void);            /* __exit */
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(int index);
> @@ -1260,6 +1256,15 @@ struct kvm_x86_ops {
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>  };
>  
> +struct kvm_x86_init_ops {
> +	int (*cpu_has_kvm_support)(void);
> +	int (*disabled_by_bios)(void);
> +	int (*check_processor_compatibility)(void);
> +	int (*hardware_setup)(void);
> +
> +	struct kvm_x86_ops *runtime_ops;
> +};
> +
>  struct kvm_arch_async_pf {
>  	u32 token;
>  	gfn_t gfn;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2125c6ae5951..33e67c3389c2 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7351,11 +7351,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
>  }
>  
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> -	.cpu_has_kvm_support = has_svm,
> -	.disabled_by_bios = is_disabled,
> -	.hardware_setup = svm_hardware_setup,
>  	.hardware_unsetup = svm_hardware_teardown,
> -	.check_processor_compatibility = svm_check_processor_compat,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> @@ -7480,9 +7476,18 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.check_nested_events = svm_check_nested_events,
>  };
>  
> +static struct kvm_x86_init_ops svm_init_ops __initdata = {
> +	.cpu_has_kvm_support = has_svm,
> +	.disabled_by_bios = is_disabled,
> +	.hardware_setup = svm_hardware_setup,
> +	.check_processor_compatibility = svm_check_processor_compat,
> +
> +	.runtime_ops = &svm_x86_ops,
> +};

Unrelated to your patch but I think we can make the naming of some of
these functions more consistend on SVM/VMX, in particular I'd suggest 

has_svm() -> cpu_has_svm_support()
is_disabled -> svm_disabled_by_bios()
...
(see below for VMX)

> +
>  static int __init svm_init(void)
>  {
> -	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
> +	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
>  			__alignof__(struct vcpu_svm), THIS_MODULE);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07299a957d4a..ffcdcc86f5b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7842,11 +7842,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  }
>  
>  static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> -	.cpu_has_kvm_support = cpu_has_kvm_support,
> -	.disabled_by_bios = vmx_disabled_by_bios,
> -	.hardware_setup = hardware_setup,
>  	.hardware_unsetup = hardware_unsetup,
> -	.check_processor_compatibility = vmx_check_processor_compat,
> +
>  	.hardware_enable = hardware_enable,
>  	.hardware_disable = hardware_disable,
>  	.cpu_has_accelerated_tpr = report_flexpriority,
> @@ -7981,6 +7978,15 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>  };
>  
> +static struct kvm_x86_init_ops vmx_init_ops __initdata = {
> +	.cpu_has_kvm_support = cpu_has_kvm_support,
> +	.disabled_by_bios = vmx_disabled_by_bios,
> +	.check_processor_compatibility = vmx_check_processor_compat,
> +	.hardware_setup = hardware_setup,

cpu_has_kvm_support() -> cpu_has_vmx_support()
hardware_setup() -> vmx_hardware_setup()

> +
> +	.runtime_ops = &vmx_x86_ops,
> +};
> +
>  static void vmx_cleanup_l1d_flush(void)
>  {
>  	if (vmx_l1d_flush_pages) {
> @@ -8065,7 +8071,7 @@ static int __init vmx_init(void)
>  	}
>  #endif
>  
> -	r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
> +	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
>  		return r;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0f08e1b4e762..20f989d1bba8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7298,8 +7298,8 @@ static struct notifier_block pvclock_gtod_notifier = {
>  
>  int kvm_arch_init(void *opaque)
>  {
> +	struct kvm_x86_init_ops *ops = opaque;
>  	int r;
> -	struct kvm_x86_ops *ops = opaque;
>  
>  	if (kvm_x86_ops) {
>  		printk(KERN_ERR "kvm: already loaded the other module\n");
> @@ -7354,7 +7354,7 @@ int kvm_arch_init(void *opaque)
>  	if (r)
>  		goto out_free_percpu;
>  
> -	kvm_x86_ops = ops;
> +	kvm_x86_ops = ops->runtime_ops;
>  
>  	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
>  			PT_DIRTY_MASK, PT64_NX_MASK, 0,
> @@ -9623,6 +9623,7 @@ void kvm_arch_hardware_disable(void)
>  
>  int kvm_arch_hardware_setup(void *opaque)
>  {
> +	struct kvm_x86_init_ops *ops = opaque;
>  	int r;
>  
>  	rdmsrl_safe(MSR_EFER, &host_efer);
> @@ -9630,7 +9631,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	if (boot_cpu_has(X86_FEATURE_XSAVES))
>  		rdmsrl(MSR_IA32_XSS, host_xss);
>  
> -	r = kvm_x86_ops->hardware_setup();
> +	r = ops->hardware_setup();
>  	if (r != 0)
>  		return r;
>  
> @@ -9665,13 +9666,14 @@ void kvm_arch_hardware_unsetup(void)
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> +	struct kvm_x86_init_ops *ops = opaque;
>  
>  	WARN_ON(!irqs_disabled());
>  
>  	if (kvm_host_cr4_reserved_bits(c) != cr4_reserved_bits)
>  		return -EIO;
>  
> -	return kvm_x86_ops->check_processor_compatibility();
> +	return ops->check_processor_compatibility();
>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)

The patch itself looks good,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

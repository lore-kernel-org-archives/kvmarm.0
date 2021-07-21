Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9394BC12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:16:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 139A56023B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 139A56023B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 894FA4B113;
	Wed, 21 Jul 2021 12:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZSPjJPKK+yHz; Wed, 21 Jul 2021 12:16:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE3B4B116;
	Wed, 21 Jul 2021 12:16:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19B724B113
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HnIZkYifTcU8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:16:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A712B4B112
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:16:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626884198;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=IcSV6p3DsGPg3q7H9uG8rdf3PK9RYtHNWHXgMTJFgSw=;
 b=iz/YaBB3GoJdlSbRhPlRZmcUj53TqAkB7sVbRkMpGhAiDP+QJLv7+eL+xIqHqwABCULDPD
 nCINtfpqqyqaS1DusxTEg3zJJG0eusLxj44Qm6VFXC90yxokmXzxSlvnsUTDreYW3t2S90
 jFvgnB207zV61285VN1TsW8eE6/lvpQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-h010vPBXMPqIdqMOf4TiTA-1; Wed, 21 Jul 2021 12:16:35 -0400
X-MC-Unique: h010vPBXMPqIdqMOf4TiTA-1
Received: by mail-il1-f200.google.com with SMTP id
 a13-20020a92c54d0000b0290216ae9088ffso1860849ilj.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 09:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IcSV6p3DsGPg3q7H9uG8rdf3PK9RYtHNWHXgMTJFgSw=;
 b=qNICCnDVd7E2QWDVPNBINdqG4NEX28PAR04UZPFLXOt7fkwrd6dhMIodTq7qtlGfSQ
 PAsaw6Fpfaw8NZnZ8v8bsFGmFz4u3BtEJTiZUiboz6nHL6XAHOV24lQZ14WFjFcddOaX
 D3YwVvkFqX6vTrMusGHylpr+hHk4pPzuqZ8gRVQKF59dqQAlFXw9Y/rf9tMFHPYZ7bSG
 SvFMdHPaJc1PaPy8owVEdgVGWEe6lHxeeshLfJAYmR30ljun+cIqL+QZpAs+3WHITewy
 McOcEVye+zq0R5gQymGUJeB3lxA5PBr4Pc+HqOkXN41FvuNfKufT+SII6zuEq5hzYqxi
 l9jA==
X-Gm-Message-State: AOAM531BPUKQOzS9G0m20AdPgwa/SUDIfpPvEeA92tWqjGy2JJ0EdmXb
 LFAxO4Z2QPbrZ5tauvveuO/JRBiOQ/c66uS9QzOiUM6Tqavx+c04g9VPUgVJGN4Z3QwsO+b0kHB
 qO+EIhvVq4rCgRQrmZVbTuZjI
X-Received: by 2002:a05:6e02:ea9:: with SMTP id
 u9mr24497386ilj.174.1626884194626; 
 Wed, 21 Jul 2021 09:16:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/IBOod66B4GglMJLgXKr35GBUPC3amMbq6Jd0LtCJ6mFrJw0uOyg05WtQr7pLrGObTD7EEQ==
X-Received: by 2002:a05:6e02:ea9:: with SMTP id
 u9mr24497370ilj.174.1626884194383; 
 Wed, 21 Jul 2021 09:16:34 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id w14sm10296889ilj.76.2021.07.21.09.16.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 09:16:33 -0700 (PDT)
Date: Wed, 21 Jul 2021 18:16:31 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 08/12] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
Message-ID: <20210721161631.mrfiuusc5zou4we5@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-9-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210719184949.1385910-9-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Jul 19, 2021 at 06:49:45PM +0000, Oliver Upton wrote:
> Add a new vCPU attribute that allows userspace to directly manipulate
> the virtual counter-timer offset. Exposing such an interface allows for
> the precise migration of guest virtual counter-timers, as it is an
> indepotent interface.
> 
> Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
> interface, wherein a write to a single vCPU is broadcasted to all vCPUs
> within a VM.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
>  3 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index b46d5f742e69..7b57cba3416a 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
>  numbers on at least one VCPU after creating all VCPUs and before running any
>  VCPUs.
>  
> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> +------------------------------------------------
> +
> +:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
> +
> +Returns:
> +
> +	 ======= ======================================
> +	 -EFAULT Error reading/writing the provided
> +	 	 parameter address
> +	 -ENXIO  Attribute not supported
> +	 ======= ======================================
> +
> +Specifies the guest's virtual counter-timer offset from the host's
> +virtual counter. The guest's virtual counter is then derived by
> +the following equation:
> +
> +  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> +
> +KVM does not allow the use of varying offset values for different vCPUs;
> +the last written offset value will be broadcasted to all vCPUs in a VM.
> +
>  3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>  ==================================
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..008d0518d2b1 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -365,6 +365,7 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> +#define   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER	2
>  #define KVM_ARM_VCPU_PVTIME_CTRL	2
>  #define   KVM_ARM_VCPU_PVTIME_IPA	0
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..d2b1b13af658 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1305,7 +1305,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  	}
>  }
>  
> -int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	int __user *uaddr = (int __user *)(long)attr->addr;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> @@ -1338,7 +1338,39 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	return 0;
>  }
>  
> -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +	u64 offset;
> +
> +	if (get_user(offset, uaddr))
> +		return -EFAULT;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		update_vtimer_cntvoff(vcpu, offset);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +		return kvm_arm_timer_set_attr_irq(vcpu, attr);
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		return kvm_arm_timer_set_attr_offset(vcpu, attr);
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	int __user *uaddr = (int __user *)(long)attr->addr;
>  	struct arch_timer_context *timer;
> @@ -1359,11 +1391,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	return put_user(irq, uaddr);
>  }
>  
> +int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +	struct arch_timer_context *timer;
> +	u64 offset;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		timer = vcpu_vtimer(vcpu);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	offset = timer_get_offset(timer);
> +	return put_user(offset, uaddr);
> +}
> +
> +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +		return kvm_arm_timer_get_attr_irq(vcpu, attr);
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> +		return kvm_arm_timer_get_attr_offset(vcpu, attr);
> +	}
> +
> +	return -ENXIO;
> +}
> +
>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
>  	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
>  		return 0;
>  	}
>  
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

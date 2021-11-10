Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF84C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D10561205
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D10561205
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5454B2B5;
	Wed, 10 Nov 2021 05:59:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MOegu7jOhrAn; Wed, 10 Nov 2021 05:59:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813744B2B6;
	Wed, 10 Nov 2021 05:59:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AD74B2B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 05:59:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mtqBJ-JMQYU7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 05:59:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 946DE4B2A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 05:59:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636541942;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Rud4BOhI3/FnheVPSiISCtxclKyfCyexZ+PhymJnR1M=;
 b=N0ZtTkxTrMp18MISIJPQXfjFr897VY9VXmbOtnHBIhF4Mba0BGQA9nQqOLBWuQHfL6XyzE
 1eJH51OHd8wAL3mcGH35qKWYw6JP+XQr05GpSMgkf2EGyjj2ucGzA59MsVD2lnDOoe5JGm
 qXRyxUAJ3EHIgGm+0H3pAjBdxtE9ioI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-vkKC7CtyPteZUkY20EiOLw-1; Wed, 10 Nov 2021 05:59:01 -0500
X-MC-Unique: vkKC7CtyPteZUkY20EiOLw-1
Received: by mail-wm1-f72.google.com with SMTP id
 m14-20020a05600c3b0e00b0033308dcc933so1013512wms.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 02:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:subject:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Rud4BOhI3/FnheVPSiISCtxclKyfCyexZ+PhymJnR1M=;
 b=PRfu/fj+tv32ic+rj+sSJQ76yHTylid/obwp+RwxMSRYTnX7tS9nz4LKTIr6lAAPeu
 GDvzH9uqZ/V4rxiDkW6dGj4+afjTufswWm+z1yjlzQQXVQ5idZTKN1Fpwf72SHnjyHo+
 F9A8lF+Ne2YE6Zr2+MGoouNqfEu2h2ZLZ28f23V5REmGbuL8qOM5Fhzb6Y3w1rg4+RzG
 4v+qS2NQOAP02CzLy7MsRSlirDmBCMeSFpClTHWBojK8xEgxfstB9UPEyZ07ziWxUzPJ
 dUOkwpiIpVDYj3UWwe5TFOCrKZoa3++ueX6IHK//u6M6YqJE7qh9gbpMp2fCM1oPqM4S
 poAg==
X-Gm-Message-State: AOAM533g2ZsCbNv/rDd80ukNygHM9u5nSR4gGGfJNjWBwOoyBV23KhtA
 WU/uNvu8pPlw0AJuq3NfEuq8JbfqfMaTwSYVHDeLvd37J1+gD+uqTKhv6yVrRSeozMtTdvdK99p
 LjejzhQnFUkyaMkz70Yy+J9AN
X-Received: by 2002:a5d:424c:: with SMTP id s12mr18029634wrr.370.1636541940214; 
 Wed, 10 Nov 2021 02:59:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfdYIAv7B9E9ylltgHIyhCaUoqaBWjTAG5jF5bdx5t8xS8Q1D/9qoWSPwt+wfcivG8Ym+ZfA==
X-Received: by 2002:a5d:424c:: with SMTP id s12mr18029591wrr.370.1636541939935; 
 Wed, 10 Nov 2021 02:58:59 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l5sm5484924wms.16.2021.11.10.02.58.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 02:58:59 -0800 (PST)
From: Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v4 13/21] KVM: arm64: Impment SDEI event delivery
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-14-gshan@redhat.com>
Message-ID: <74c5f170-fb08-56a7-ff87-9a51ecfda989@redhat.com>
Date: Wed, 10 Nov 2021 11:58:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-14-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

s/Impment/Implement in the commit title

On 8/15/21 2:13 AM, Gavin Shan wrote:
> This implement kvm_sdei_deliver() to support SDEI event delivery.
> The function is called when the request (KVM_REQ_SDEI) is raised.
> The following rules are taken according to the SDEI specification:
> 
>    * x0 - x17 are saved. All of them are cleared except the following
>      registered:
s/registered/registers
>      x0: number SDEI event to be delivered
s/number SDEI event/SDEI event number
>      x1: parameter associated with the SDEI event
user arg?
>      x2: PC of the interrupted context
>      x3: PState of the interrupted context
> 
>    * PC is set to the handler of the SDEI event, which was provided
>      during its registration. PState is modified accordingly.
> 
>    * SDEI event with critical priority can preempt those with normal
>      priority.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/kvm_sdei.h |  1 +
>  arch/arm64/kvm/arm.c              |  3 ++
>  arch/arm64/kvm/sdei.c             | 84 +++++++++++++++++++++++++++++++
>  4 files changed, 89 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index aedf901e1ec7..46f363aa6524 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -47,6 +47,7 @@
>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>  #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
> +#define KVM_REQ_SDEI		KVM_ARCH_REQ(6)
>  
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>  				     KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> index b0abc13a0256..7f5f5ad689e6 100644
> --- a/arch/arm64/include/asm/kvm_sdei.h
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -112,6 +112,7 @@ KVM_SDEI_FLAG_FUNC(enabled)
>  void kvm_sdei_init_vm(struct kvm *kvm);
>  void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
> +void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
>  void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
>  void kvm_sdei_destroy_vm(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2f021aa41632..0c3db1ef1ba9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -689,6 +689,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
>  			kvm_reset_vcpu(vcpu);
>  
> +		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
> +			kvm_sdei_deliver(vcpu);
> +
>  		/*
>  		 * Clear IRQ_PENDING requests that were made to guarantee
>  		 * that a VCPU sees new virtual interrupts.
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 62efee2b67b8..b5d6d1ed3858 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -671,6 +671,90 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	struct kvm_sdei_vcpu_event *ksve = NULL;
> +	struct kvm_sdei_vcpu_regs *regs = NULL;
> +	unsigned long pstate;
> +	int index = 0;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei))
> +		return;
> +
> +	/* The critical event can't be preempted */
move the comment after the spin_lock
> +	spin_lock(&vsdei->lock);
> +	if (vsdei->critical_event)
> +		goto unlock;
> +
> +	/*
> +	 * The normal event can be preempted by the critical event.
> +	 * However, the normal event can't be preempted by another
> +	 * normal event.
> +	 */
> +	ksve = list_first_entry_or_null(&vsdei->critical_events,
> +			struct kvm_sdei_vcpu_event, link);
> +	if (!ksve && !vsdei->normal_event) {
> +		ksve = list_first_entry_or_null(&vsdei->normal_events,
> +				struct kvm_sdei_vcpu_event, link);
> +	}
At this stage of the review the struct kvm_sdei_vcpu_event lifecycle is
not known.

From the dispatcher pseudocode I understand you check

((IsCriticalEvent(E) and !CriticalEventRunning(P, C)) ||
(!IsCriticalEvent(E) and !EventRunning(P, C)))

but I can't check you take care of
IsEnabled(E) and
IsEventTarget(E, P)
IsUnmasked(P)

Either you should shash with 18/21 or at least you should add comments.
> +
> +	if (!ksve)
> +		goto unlock;
> +
> +	kske = ksve->kske;
> +	kse = kske->kse;
> +	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL) {
> +		vsdei->critical_event = ksve;
> +		vsdei->state.critical_num = ksve->state.num;
> +		regs = &vsdei->state.critical_regs;
> +	} else {
> +		vsdei->normal_event = ksve;
> +		vsdei->state.normal_num = ksve->state.num;
> +		regs = &vsdei->state.normal_regs;
> +	}
> +
> +	/* Save registers: x0 -> x17, PC, PState */
> +	for (index = 0; index < ARRAY_SIZE(regs->regs); index++)
> +		regs->regs[index] = vcpu_get_reg(vcpu, index);
> +
> +	regs->pc = *vcpu_pc(vcpu);
> +	regs->pstate = *vcpu_cpsr(vcpu);
> +
> +	/*
> +	 * Inject SDEI event: x0 -> x3, PC, PState. We needn't take lock
> +	 * for the KVM event as it can't be destroyed because of its
> +	 * reference count.
> +	 */
> +	for (index = 0; index < ARRAY_SIZE(regs->regs); index++)
> +		vcpu_set_reg(vcpu, index, 0);
> +
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
> +	vcpu_set_reg(vcpu, 0, kske->state.num);
> +	vcpu_set_reg(vcpu, 1, kske->state.params[index]);
> +	vcpu_set_reg(vcpu, 2, regs->pc);
> +	vcpu_set_reg(vcpu, 3, regs->pstate);
> +
> +	pstate = regs->pstate;
> +	pstate |= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT);
> +	pstate &= ~PSR_MODE_MASK;
> +	pstate |= PSR_MODE_EL1h;
> +	pstate &= ~PSR_MODE32_BIT;
> +
> +	vcpu_write_sys_reg(vcpu, regs->pstate, SPSR_EL1);
> +	*vcpu_cpsr(vcpu) = pstate;
> +	*vcpu_pc(vcpu) = kske->state.entries[index];
> +
> +unlock:
> +	spin_unlock(&vsdei->lock);
> +}
> +
>  void kvm_sdei_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_sdei_kvm *ksdei;
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

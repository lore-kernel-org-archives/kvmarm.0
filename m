Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8241BC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:50:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAA0861205
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EAA0861205
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A2C4B283;
	Tue,  9 Nov 2021 10:50:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vd96gskDBp4f; Tue,  9 Nov 2021 10:50:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF6D4B27B;
	Tue,  9 Nov 2021 10:50:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4494B264
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:50:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lT3YgSKtA2SJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 10:50:10 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31D04B24F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:50:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636473010;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=irwTneTf9QI6LVI8ekRzV43VSKxwRrtEsvCyVPgaciQ=;
 b=b2URQgWpnGZiowwdqLzOX2ryDeX5Py0/xJlUD9SU/Sb0JfkztYXt6ecSoJzLG/XbUyrscM
 0vHtddn62HTD+9kXSQt1ZUbFiwDSwzgoA8cgyInX/E/F1vzyprOzU9/BVmgRwBq85k4Vrt
 oZMaDOMPEIlltfk+H/1NOtuEzNJoHU4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-5-xFDEV3OI2KwfVGHb_jrw-1; Tue, 09 Nov 2021 10:50:09 -0500
X-MC-Unique: 5-xFDEV3OI2KwfVGHb_jrw-1
Received: by mail-wr1-f72.google.com with SMTP id
 y9-20020a5d6209000000b001684625427eso4943186wru.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 07:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=irwTneTf9QI6LVI8ekRzV43VSKxwRrtEsvCyVPgaciQ=;
 b=Q2Y6FmgHdyWGYelIt9OWZGIv6OcM2OEjocLkkRKm8CMoXa0rUXdTPlz0Et3aA3U1no
 EFsNg5LxJjvHEyeJtRrZ/UveRLJ/IEEKSpyf6NGXB3+aFsTaYo1H8s8E89JR8M120xet
 lUf7B36YvePZE+lah3NrvHUnx+OV29x5WoHODEFI0S0sBhVcoNyuh/P7qp1wu6POaFKZ
 w0nW2WrXYqx3UUbzf52WIuPf8G1321ZjQsEKjvdmvnS/0DUsm6jR0KGpo4i8WXtI5C6j
 QlZIE0AXmJyfsiMHiPNlVf9NaNacby2DEx3hWhzG+TYpIL4vmRlNg2hTwfxs6/IW4WUe
 6JUw==
X-Gm-Message-State: AOAM530yhJwtzM2vFaLvxeLJILH1eSFTZPvN1t4sFv2rdJvE/AN3TO+L
 kYF/CdZ1Vry+p+SuLdgHsCmNPGdGmSGptTw2ZHJkpsyxUMjQwsFRZO4jBZxBblmqMTAdejKSExj
 aMhBB9k/OHm7ayToqROI/HWPK
X-Received: by 2002:a05:6000:1841:: with SMTP id
 c1mr10617533wri.425.1636473008124; 
 Tue, 09 Nov 2021 07:50:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfJIgxn8zfsJqdTZUNR1ozg+WcdEC2yKW2Q/fU8vHOZ0eE2ok8b/2tmr7DLaxIQ1GJrUDRWA==
X-Received: by 2002:a05:6000:1841:: with SMTP id
 c1mr10617494wri.425.1636473007893; 
 Tue, 09 Nov 2021 07:50:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id a4sm2730083wmg.10.2021.11.09.07.50.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 07:50:07 -0800 (PST)
Subject: Re: [PATCH v4 04/21] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-5-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <434349d3-4dcb-9157-35a5-9f05aaed4982@redhat.com>
Date: Tue, 9 Nov 2021 16:50:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-5-gshan@redhat.com>
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

Hi Gavin,
On 8/15/21 2:13 AM, Gavin Shan wrote:
> This supports SDEI_EVENT_REGISTER hypercall, which is used by guest
> to register SDEI events. The SDEI event won't be raised to the guest
> or specific vCPU until it's registered and enabled explicitly.
> 
> Only those events that have been exported by KVM can be registered.
> After the event is registered successfully, the KVM SDEI event (object)
> is created or updated because the same KVM SDEI event is shared by
revisit the terminology (KVM SDEI event). The same SDEI registered event
object is shared by multiple vCPUs if it is a private event.
> multiple vCPUs if it's a private event.>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 122 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index aa9485f076a9..d3ea3eee154b 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -21,6 +21,20 @@ static struct kvm_sdei_event_state defined_kse[] = {
>  	},
>  };
>  
> +static struct kvm_sdei_event *kvm_sdei_find_event(struct kvm *kvm,
> +						  unsigned long num)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse;
the 'k' prefix everywhere for your local variable is unneeded.
> +
> +	list_for_each_entry(kse, &ksdei->events, link) {
> +		if (kse->state.num == num)
> +			return kse;
> +	}
> +
> +	return NULL;
> +}
> +
>  static void kvm_sdei_remove_events(struct kvm *kvm)
>  {
>  	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> @@ -32,6 +46,20 @@ static void kvm_sdei_remove_events(struct kvm *kvm)
>  	}
>  }
>  
> +static struct kvm_sdei_kvm_event *kvm_sdei_find_kvm_event(struct kvm *kvm,
> +							  unsigned long num)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_kvm_event *kske;
> +
> +	list_for_each_entry(kske, &ksdei->kvm_events, link) {> +		if (kske->state.num == num)
I still don't get the diff between the num of an SDEI event vs the num
of a so-called SDEI kvm event. Event numbers are either static or
dynamically created using bind ops which you do not support. But to me
this is a property of the root exposed SDEI event and not a property of
the registered event. Please could you clarify?
> +			return kske;
> +	}
> +
> +	return NULL;
> +}
> +
>  static void kvm_sdei_remove_kvm_events(struct kvm *kvm,
>  				       unsigned int mask,
>  				       bool force)
> @@ -86,6 +114,98 @@ static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	unsigned long event_num = smccc_get_arg1(vcpu);
> +	unsigned long event_entry = smccc_get_arg2(vcpu);
> +	unsigned long event_param = smccc_get_arg3(vcpu);
> +	unsigned long route_mode = smccc_get_arg4(vcpu);
> +	unsigned long route_affinity = smccc_get_arg5(vcpu);
> +	int index = vcpu->vcpu_idx;
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = SDEI_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +	if (!kvm_sdei_is_valid_event_num(event_num)) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	if (!(route_mode == SDEI_EVENT_REGISTER_RM_ANY ||
> +	      route_mode == SDEI_EVENT_REGISTER_RM_PE)) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	/*
> +	 * The KVM event could have been created if it's a private event.
> +	 * We needn't create a KVM event in this case.
s/create a KVM event/to create another KVM event instance
> +	 */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	if (kske) {
> +		kse = kske->kse;
> +		index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +			vcpu->vcpu_idx : 0;
> +
> +		if (kvm_sdei_is_registered(kske, index)) {
> +			ret = SDEI_DENIED;
> +			goto unlock;
> +		}
> +
> +		kske->state.route_mode     = route_mode;
> +		kske->state.route_affinity = route_affinity;
> +		kske->state.entries[index] = event_entry;
> +		kske->state.params[index]  = event_param;
> +		kvm_sdei_set_registered(kske, index);
> +		goto unlock;
> +	}
> +
> +	/* Check if the event number has been registered */
> +	kse = kvm_sdei_find_event(kvm, event_num);
I don't get the comment. find_event looks up for exposed events and not
registered events, right? So maybe this is the first thing to check, ie.
the num matches one exposed event.
> +	if (!kse) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto unlock;
> +	}
> +
> +	/* Create KVM event */
> +	kske = kzalloc(sizeof(*kske), GFP_KERNEL);
> +	if (!kske) {
> +		ret = SDEI_OUT_OF_RESOURCE;
> +		goto unlock;
> +	}
> +
> +	/* Initialize KVM event state */
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
> +	kske->state.num            = event_num;
> +	kske->state.refcount       = 0;
> +	kske->state.route_mode     = route_affinity;
> +	kske->state.route_affinity = route_affinity;
> +	kske->state.entries[index] = event_entry;
> +	kske->state.params[index] = event_param;
> +	kvm_sdei_set_registered(kske, index);
> +
> +	/* Initialize KVM event */
> +	kske->kse = kse;
> +	kske->kvm = kvm;
> +	list_add_tail(&kske->link, &ksdei->kvm_events);
> +
> +unlock:
> +	spin_unlock(&ksdei->lock);
> +out:
> +	return ret;
> +}
> +
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u32 func = smccc_get_function(vcpu);
> @@ -97,6 +217,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_version(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
> +		ret = kvm_sdei_hypercall_register(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
>  	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
>  	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

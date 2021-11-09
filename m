Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45285C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 18:48:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5EEF61179
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 18:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5EEF61179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A3A4B1E3;
	Tue,  9 Nov 2021 13:47:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jRsXML6WtqYb; Tue,  9 Nov 2021 13:47:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21F914B245;
	Tue,  9 Nov 2021 13:47:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7B14B1E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 13:47:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5w5jByhN4sQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 13:47:55 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFABC4B1E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 13:47:55 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636483675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y0RovrZWpwirwAExhIJwYKka0MpzBNZCqhlUn9GM8bg=;
 b=P92Mp/nD/nuk0XLCSI43W0gt2yUMcJV33sLBrxWgQYoxwIdcMKm4vq2ExgJgnlB/KSqRNn
 aSrfy1ZsUZdT0rxI1G/yb7DK9OMwl4Z1TtEBinksNY5/DJWTifpJAg/BlB6tOCNpog6s9C
 rh1c0dCNmlGmFvatzUYAFAjkjZ/0KVw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-L_c0OW5YNLyUeE0Yis-Rrg-1; Tue, 09 Nov 2021 13:47:54 -0500
X-MC-Unique: L_c0OW5YNLyUeE0Yis-Rrg-1
Received: by mail-wm1-f72.google.com with SMTP id
 o10-20020a05600c4fca00b0033312e1ed8bso91176wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 10:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=y0RovrZWpwirwAExhIJwYKka0MpzBNZCqhlUn9GM8bg=;
 b=KcUTP3N9r594v7nYcxysps04fdL/CAFHXtORgVhvLbOZ3FRrSIUL0ace7ARwm9mLs4
 esb23mPxrQ5p9mZirNArcbntvPGoLzR5cxI4NgZ+MtVr0ZXetWzjTZza5krZxEy1Hva8
 yCRFyWfvSFEVDkWFXODMlRPzb5ZCDgPTM7amlldJDZP2OzEOpqCirtXvFq/MZbPmwTuP
 TEvVRuTwY2s+FBvpkEU8xoRoIhAc6Oj+zlhC2PNr3RbJ9KgPxNOYs+Lc2lRYR3O2odhj
 M0ocWFa52tKzD8EHBFsO5j+qDe+U2KrdDxm63xkgjCC8IKKXGYhetVf5bMHS+y0XsjKx
 ltYw==
X-Gm-Message-State: AOAM533u1YxncKB3ivFR610TS9oBZWHG65ljfGoqQcTWergYA7OQhdAm
 8tYngG4U4ATf0jWT6cxoFbox1AlIc39xT/wmGFjnrg8AQ34Gly4WOX3w6SwIo78XN/Jo/y2YlwV
 m+/tVsbm2LtQ514WWoxKHwQn1
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr9674024wmr.134.1636483672885; 
 Tue, 09 Nov 2021 10:47:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwosnr4qtmp9gIyxAanUH2RRhXq8QfVnuZRB+FSoEkfAQ8fHaZCCxXpv2LDlJQ1Y+laoJpIw==
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr9673989wmr.134.1636483672615; 
 Tue, 09 Nov 2021 10:47:52 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id p13sm3556837wmi.0.2021.11.09.10.47.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 10:47:52 -0800 (PST)
Subject: Re: [PATCH v4 10/21] KVM: arm64: Support SDEI_EVENT_ROUTING_SET
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-11-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <0d46c17b-1a37-cbf6-4d34-aa03d30e39ef@redhat.com>
Date: Tue, 9 Nov 2021 19:47:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-11-gshan@redhat.com>
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
> This supports SDEI_EVENT_ROUTING_SET hypercall. It's used by the
> guest to set route mode and affinity for the registered KVM event.
> It's only valid for the shared events. It's not allowed to do so
> when the corresponding event has been raised to the guest.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 64 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 5dfa74b093f1..458695c2394f 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -489,6 +489,68 @@ static unsigned long kvm_sdei_hypercall_info(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_route(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	unsigned long event_num = smccc_get_arg1(vcpu);
> +	unsigned long route_mode = smccc_get_arg2(vcpu);
> +	unsigned long route_affinity = smccc_get_arg3(vcpu);
> +	int index = 0;
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
Some sanity checking on the affinity arg could be made as well according
to 5.1.2  affinity desc. The fn shall return INVALID_PARAMETER in case
of invalid affinity.
> +
> +	/* Check if the KVM event has been registered */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	if (!kske) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto unlock;
> +	}
> +
> +	/* Validate KVM event state */
> +	kse = kske->kse;
> +	if (kse->state.type != SDEI_EVENT_TYPE_SHARED) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto unlock;
> +	}
> +
Event handler is in a state other than: handler-registered.
> +	if (!kvm_sdei_is_registered(kske, index) ||
> +	    kvm_sdei_is_enabled(kske, index)     ||
> +	    kske->state.refcount) {
I am not sure about the refcount role here. Does it make sure the state
is != handler-enabled and running or handler-unregister-pending?

I think we would gain in readibility if we had a helper to check whether
we are in those states?
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}
> +
> +	/* Update state */
> +	kske->state.route_mode     = route_mode;
> +	kske->state.route_affinity = route_affinity;
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
> @@ -523,6 +585,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_info(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
> +		ret = kvm_sdei_hypercall_route(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_PE_MASK:
>  	case SDEI_1_0_FN_SDEI_PE_UNMASK:
>  	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A012C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:05:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED169611C5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:05:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED169611C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5111B4B116;
	Tue,  9 Nov 2021 12:05:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h7qvCzBEotP5; Tue,  9 Nov 2021 12:05:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0660E4B25B;
	Tue,  9 Nov 2021 12:05:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 908314B15D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:05:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tilc0xGzpHNM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 12:05:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D88B4B116
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:05:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636477506;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=C+tFRg598ce+Pkksxlpyq2K1tm7az89DtXstWpm6hqc=;
 b=IVok75bKRuqJ1xnsFrmUsT7EMxVT6RsSKDEQ8SfRsUqCBge7tUSxCuxhUe3rFHximH5Qol
 hZvXJxqo9D0+RHwLMRf1K3WxLCSQsbmKxANTBTqslVu/Vq5BgvJWQIH0AXJXE1uHg4PO5E
 rnebcXTYycmGQj1Bi92Xb5p5fY8yygE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-2IUipWnZPT6-6eQdutcXuQ-1; Tue, 09 Nov 2021 12:05:05 -0500
X-MC-Unique: 2IUipWnZPT6-6eQdutcXuQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 144-20020a1c0496000000b003305ac0e03aso1634191wme.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 09:05:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=C+tFRg598ce+Pkksxlpyq2K1tm7az89DtXstWpm6hqc=;
 b=wYyHAPxRF3rbg96MzWKFXsYjF7Apfsyq1ayx/+WGC8GjePMtKK86pdv7DLke2BW7bA
 Kg3C4kkP7B9GG0h5p6JaH/aIHywFZbTIyU4mMqqlmR2lMwjvGJ/k5yhmDzdGB3vxXiXV
 Wb2Y+wI86eNFtciDr+xnP/9mmomnYIZxpzGbDRuF5N/0Ms/3ITuR8OCalRL6WSSdt+4d
 ITx9SZCuMM8CAMFYZG1ESp0Waiq6a2Mk91Bm0aeJxwcLi0j0u6M4Kob4NFaPoooaZNSS
 l/gHYwAXpzf6yaPVUPqyvn+dEI5ke5tSQYz3y3B+E1U+P5slcnxJFQnKBYndCEOA39u7
 9uUg==
X-Gm-Message-State: AOAM532L632lfxeaHorj8oIqAFnxzCm6vrT6jyZdO3pDikEZeKqKXlTW
 31A6btiu+I0q7q11WeTGS7Q3ghbKXeTYE6FAmD25KLFxJf1hLU1u7FP/EDS5tGEuXCnhUfDpk1K
 0SYG3Rb3iefEWAmzcewtdEuqH
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr11472499wrj.338.1636477504006; 
 Tue, 09 Nov 2021 09:05:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4zmFD63DlRvgaPFPwC/DJ0LRgwzSloKUJSs78C2aFK91vrl3ZK3k6EtXwUcJIi3p8AMau7A==
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr11472455wrj.338.1636477503802; 
 Tue, 09 Nov 2021 09:05:03 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id o12sm26601930wrc.85.2021.11.09.09.05.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 09:05:03 -0800 (PST)
Subject: Re: [PATCH v4 07/21] KVM: arm64: Support SDEI_EVENT_UNREGISTER
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-8-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <100a4aa0-6c2d-2fec-6f11-c7e64946ef0b@redhat.com>
Date: Tue, 9 Nov 2021 18:05:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-8-gshan@redhat.com>
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



On 8/15/21 2:13 AM, Gavin Shan wrote:
> This supports SDEI_EVENT_UNREGISTER hypercall. It's used by the
> guest to unregister SDEI event. The SDEI event won't be raised to
> the guest or specific vCPU after it's unregistered successfully.
> It's notable the SDEI event is disabled automatically on the guest
> or specific vCPU once it's unregistered successfully.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 61 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index b4162efda470..a3ba69dc91cb 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -308,6 +308,65 @@ static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_unregister(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	unsigned long event_num = smccc_get_arg1(vcpu);
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
> +	/* Check if the KVM event exists */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	if (!kske) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto unlock;
> +	}
> +
> +	/* Check if there is pending events */
> +	if (kske->state.refcount) {
> +		ret = SDEI_PENDING;
don't you want to record the fact the unregistration is outstanding to
perform subsequent actions? Otherwise nothing will hapen when the
current executing handlers complete?
> +		goto unlock;
> +	}
> +
> +	/* Check if it has been registered */
> +	kse = kske->kse;
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
you could have an inline for the above as this is executed in many
functions. even including the code below.
> +	if (!kvm_sdei_is_registered(kske, index)) {
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}
> +
> +	/* The event is disabled when it's unregistered */
> +	kvm_sdei_clear_enabled(kske, index);
> +	kvm_sdei_clear_registered(kske, index);
> +	if (kvm_sdei_empty_registered(kske)) {
a refcount mechanism would be cleaner I think.
> +		list_del(&kske->link);
> +		kfree(kske);
> +	}
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
> @@ -333,6 +392,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
>  	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
> +		ret = kvm_sdei_hypercall_unregister(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
>  	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
>  	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

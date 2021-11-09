Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263ADC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:12:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93571611C8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93571611C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 068F44B28B;
	Tue,  9 Nov 2021 12:12:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xvpJZ-d8w7J3; Tue,  9 Nov 2021 12:12:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B834B27C;
	Tue,  9 Nov 2021 12:12:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95BAC4B25B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:12:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nohhnonp0xEV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 12:12:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222CF4B162
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:12:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636477969;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=itzQ0IJHUze6zygYKZqaj/ELO8lr8mqZkASjXKCWKPk=;
 b=XflPUHjxNeoXdIJgkEEL6IF8ThNriyroI9/KRmxysjtagBC1jpE7R2oBpDRxKu6/gHIzzR
 oiawcOz6Atxm/8+7YHzpjEw1pisAeaUBDvOnis3D8GwZCju0laapaS5X6fdRWxpBFk+T94
 GEyajvj/3eSQfoTRdmCMwGjHz3cQDrs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-qEddP32vMDinudqZEw9tgg-1; Tue, 09 Nov 2021 12:12:45 -0500
X-MC-Unique: qEddP32vMDinudqZEw9tgg-1
Received: by mail-wr1-f72.google.com with SMTP id
 q17-20020adff791000000b00183e734ba48so4972721wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 09:12:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=itzQ0IJHUze6zygYKZqaj/ELO8lr8mqZkASjXKCWKPk=;
 b=oX12qI0b0gct8tTJA3svDIlijKuDEiVPGqf5IhY+FHfY0WDSEIGAVLrwA+q5g91eu9
 HYJ1YjahWw9vjMM6rlVRrtWo6gwilVEcsjeBwCnPPiS8RWYc8oI5/DlJAvcvEMB/tFvT
 gW+Ckzyx2TCwmPRU/OcXmVUx9TjThdfTujjJDs4/CQHMpy/SIB+r9rEpaXDHjniR3k99
 0FNe6291Ua79avfm8Vh80HkRHR5QieAmJ565GGuguaBrCn99gW4FbxdPCFdMLbBcOvcV
 U1T75C7Vik8cZxzp49RRaNsV6kpC3/x15fZV+QSkGc+bIbKbf47okJXHqBDPYSptdFui
 792g==
X-Gm-Message-State: AOAM530v295K4qH0YUNbfYSUy6UMfRnjv/X9QuuRVN/Uik9lh6qsAwlT
 iOvnsLuGzcVdghkfNKCo1RSJQf7LKbc7hAy7NkGCC/GwmA0aO4Gl7XOrvS6XIabOY4G6laf+sNc
 vXmK6HznWbbc3A0X3sqYvrHGI
X-Received: by 2002:a05:600c:4e94:: with SMTP id
 f20mr8704358wmq.77.1636477964374; 
 Tue, 09 Nov 2021 09:12:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz53OVWvuTZM63VElmCOXuGyy0d7vSRcf6ZLE9rhLSzl92PQ5p+WlBK2KEaDuhh8aa7rVU8vw==
X-Received: by 2002:a05:600c:4e94:: with SMTP id
 f20mr8704315wmq.77.1636477964097; 
 Tue, 09 Nov 2021 09:12:44 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id a4sm3050291wmb.39.2021.11.09.09.12.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 09:12:43 -0800 (PST)
Subject: Re: [PATCH v4 08/21] KVM: arm64: Support SDEI_EVENT_STATUS hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-9-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <36f2f2cf-3e6e-30ce-53d2-6c44be93272d@redhat.com>
Date: Tue, 9 Nov 2021 18:12:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-9-gshan@redhat.com>
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
> This supports SDEI_EVENT_STATUS hypercall. It's used by the guest
> to retrieve a bitmap to indicate the SDEI event states, including
> registration, enablement and delivery state.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index a3ba69dc91cb..b95b8c4455e1 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -367,6 +367,54 @@ static unsigned long kvm_sdei_hypercall_unregister(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_status(struct kvm_vcpu *vcpu)
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
if we were to support bound events, I do not know if a given even num
can disapper inbetween that check and the rest of the code, in which
case a lock would be needed?
> +
> +	/*
> +	 * Check if the KVM event exists. None of the flags
> +	 * will be set if it doesn't exist.
> +	 */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	if (!kske) {
> +		ret = 0;
> +		goto unlock;
> +	}
> +
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
> +	if (kvm_sdei_is_registered(kske, index))
> +		ret |= (1UL << SDEI_EVENT_STATUS_REGISTERED);
> +	if (kvm_sdei_is_enabled(kske, index))
> +		ret |= (1UL << SDEI_EVENT_STATUS_ENABLED);
> +	if (kske->state.refcount)
> +		ret |= (1UL << SDEI_EVENT_STATUS_RUNNING);
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
> @@ -395,6 +443,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_unregister(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
> +		ret = kvm_sdei_hypercall_status(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
>  	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
>  	case SDEI_1_0_FN_SDEI_PE_MASK:
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

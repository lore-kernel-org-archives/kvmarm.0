Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EBCC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 16:02:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83BC460234
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 16:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 83BC460234
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFC574B29C;
	Tue,  9 Nov 2021 11:02:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w44Uq6VHqPUw; Tue,  9 Nov 2021 11:02:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 326974B267;
	Tue,  9 Nov 2021 11:02:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 877814B1FB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 11:02:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZoLu7mNrjWAp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 11:02:16 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 420A24B1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 11:02:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636473736;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f0NkQHNtByTMuU5oqC5nvNn2ilO38HykCMw0MGjwEAk=;
 b=QPUiKnuz4FPoEa+PASKCPjb0ziWNg0zc3MtTmVOT4E9kGKFAwy++Zdp/Q9W9J/H+EyJgWM
 mN015ldpgFd1nOeljqmiaczc9RIuf6fNcw8EWUqdVRVqFMe7e2iLR6fSIWwj2yDZSt7Wyj
 dEEpczq7zo24TrnS+FxwytDPdAXonAA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-6BJf0Y1bM-acxqL0eWg1Kg-1; Tue, 09 Nov 2021 11:02:12 -0500
X-MC-Unique: 6BJf0Y1bM-acxqL0eWg1Kg-1
Received: by mail-wr1-f71.google.com with SMTP id
 k8-20020a5d5248000000b001763e7c9ce5so4943899wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 08:02:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=f0NkQHNtByTMuU5oqC5nvNn2ilO38HykCMw0MGjwEAk=;
 b=RKeBD0ohbggYzhKq7KrELThLQIZR4JZocdBoRGtUb0/m9HM2fFS4STJlH/sFMQFvFV
 uGAdFhenG3O363W2GbIfAgWpECXSL1cNhmQ1p+DQOQxaN63VLyuFgnhbbL8VQnuiOkgR
 d8lQvdoeAG6fVPAmpmOfY45470dnVte+Qu43FKwOeha5bPRVZ0ZPJzi3iIHzctjq2/fW
 N6IjwyH7ooLCOXVyEb+RFAzhg4cu5nldb3AKXJAnhAck5w1Dz9cMkFcjIfIwUHFNnIVs
 3lbcJomwwYcrkHNz9IFr3SUMRxL9DoqEPiWhJWVEi1YSIk7gCzXmcOgiLp9u5xY5ot7t
 zHew==
X-Gm-Message-State: AOAM530TWQ7PF7u7QT99yKwJTz1cLNMhlM+QhPDChasHsoHgmrgEjmdw
 i1rDTN/uT8xbFUDSc4NdYX7JIkp/lqRfo+tuEDK0Jh8wSyBnqx9RsjjqzQv2K4eO4i2Db0+8pCt
 vX5PqfcSFzmWHT4W4S0mrYR2d
X-Received: by 2002:a5d:658c:: with SMTP id q12mr10616526wru.34.1636473731668; 
 Tue, 09 Nov 2021 08:02:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxp0D3kDsjHNuP+MJKyYIwWAs2FuuiuZ12DLM3XJ7oW9wcvQltGyhH8qsK2rMJxIaC0ruiexQ==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr10616477wru.34.1636473731405; 
 Tue, 09 Nov 2021 08:02:11 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id y6sm21903594wrh.18.2021.11.09.08.02.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 08:02:10 -0800 (PST)
Subject: Re: [PATCH v4 05/21] KVM: arm64: Support SDEI_EVENT_{ENABLE, DISABLE}
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-6-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <4ce1aed4-d955-145c-777b-350efec2e7bc@redhat.com>
Date: Tue, 9 Nov 2021 17:02:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-6-gshan@redhat.com>
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
> This supports SDEI_EVENT_{ENABLE, DISABLE} hypercall. After SDEI
> event is registered by guest, it won't be delivered to the guest
> until it's enabled. On the other hand, the SDEI event won't be
> raised to the guest or specific vCPU if it's has been disabled
> on the guest or specific vCPU.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 68 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index d3ea3eee154b..b022ce0a202b 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -206,6 +206,70 @@ static unsigned long kvm_sdei_hypercall_register(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
> +					       bool enable)
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
I would rename into is_exposed_event_num()
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	/* Check if the KVM event exists */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	if (!kske) {
> +		ret = SDEI_INVALID_PARAMETERS;
should be DENIED according to the spec, ie. nobody registered that event?
> +		goto unlock;
> +	}
> +
> +	/* Check if there is pending events */
does that match the "handler-unregister-pending state" case mentionned
in the spec?
> +	if (kske->state.refcount) {
> +		ret = SDEI_PENDING;
? not documented in my A spec? DENIED?
> +		goto unlock;
> +	}
> +
> +	/* Check if it has been registered */
isn't duplicate of /* Check if the KVM event exists */ ?
> +	kse = kske->kse;
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
> +	if (!kvm_sdei_is_registered(kske, index)) {
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}
> +
> +	/* Verify its enablement state */
> +	if (enable == kvm_sdei_is_enabled(kske, index)) {
spec says:
Enabling/disabled an event, which is already enabled/disabled, is
permitted and has no effect. I guess ret should be OK.
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}
> +
> +	/* Update enablement state */
> +	if (enable)
> +		kvm_sdei_set_enabled(kske, index);
> +	else
> +		kvm_sdei_clear_enabled(kske, index);
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
> @@ -220,7 +284,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_register(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
> +		ret = kvm_sdei_hypercall_enable(vcpu, true);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
> +		ret = kvm_sdei_hypercall_enable(vcpu, false);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

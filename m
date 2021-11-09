Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BD5C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:20:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00DBB61208
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 17:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 00DBB61208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFF14B283;
	Tue,  9 Nov 2021 12:20:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LIqizO1dEgFO; Tue,  9 Nov 2021 12:20:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9DC4B282;
	Tue,  9 Nov 2021 12:20:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45AD44B282
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:20:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JhYgoHAMOwUq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 12:20:04 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE234B281
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 12:20:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636478403;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EeoeqnN42iO2HBA0In6NdJ3XgDyDHyboIkYWjl3H/UQ=;
 b=XqKrLn2wO/dsW3jBHYFWbWLiR0Kp9oprmEjAKLtloiteQ1UejB4NSx9x4KCnBHe9/C1Lny
 F3gbc9OSnKE/Q9AcYVr8MfXq1mre+CY7RSnEHUUMwD/hDP+SrReVi6JOcNeiIhui97IzR1
 NqsHhIwo5wufDDjeqWBvFwJqPR/Xms4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-l5cb5f_mPkSNwz4k46zVVQ-1; Tue, 09 Nov 2021 12:20:02 -0500
X-MC-Unique: l5cb5f_mPkSNwz4k46zVVQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 z137-20020a1c7e8f000000b0030cd1800d86so8040618wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 09:20:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=EeoeqnN42iO2HBA0In6NdJ3XgDyDHyboIkYWjl3H/UQ=;
 b=CY6uu4KORS9PEaKpuJJUf74BsBxtui6dGQ94CHtNmItAJ6LnxOo5pEC9kyhQRSiOCG
 Y8bgDVIo7hxDSm4TfODbkCPGzJBLJRjcgVOFNSBX9sDMvIrp4W/xXG2qa+IY/0OXVJGS
 Gb92JnmrwEnNimKEC+VYwGisgsWAx9uKX8ciJ/OEhEQuNSNc+qpVgFyDEATBiCRkewit
 vB7V8Rub9Nnf5H60HZ2SalMQXU43aCnaQhIHisFrWDez3zj2lBrPMECyOqibqoRcoYMG
 MXk1af01eHnsMl6H2633vc+cn3nUlMh4EkH/+JNKSwK97mgoC9OYgzhQX2kbtkS7QG4i
 93Iw==
X-Gm-Message-State: AOAM533TN8tpnS6ZTPJC3bEArmrk1VCRqr0uy10g2qsGNIziSIeFjfP/
 4r3rbpcz7E0kkWQUzAyUuVJFygvb8DgvLIPzkzFVLwpQjlMgRledR7IqZ+pmGraKblgNRFv0/cA
 gtclgdWbC/m/EWE1X2TH73PTj
X-Received: by 2002:adf:f448:: with SMTP id f8mr11639345wrp.47.1636478400392; 
 Tue, 09 Nov 2021 09:20:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCCtys+DFTB9rGKP29bXN2P+dxcKGg761X5Ys6eQzwFD7BzaaXV521w8QRy/G0gOuB6O4KJA==
X-Received: by 2002:adf:f448:: with SMTP id f8mr11639296wrp.47.1636478400112; 
 Tue, 09 Nov 2021 09:20:00 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n8sm20410332wrp.95.2021.11.09.09.19.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 09:19:59 -0800 (PST)
Subject: Re: [PATCH v4 09/21] KVM: arm64: Support SDEI_EVENT_GET_INFO hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-10-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <03e9b1fb-af79-69bf-f242-00fef3b11a81@redhat.com>
Date: Tue, 9 Nov 2021 18:19:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-10-gshan@redhat.com>
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
> This supports SDEI_EVENT_GET_INFO hypercall. It's used by the guest
> to retrieve various information about the supported (exported) events,
> including type, signaled, route mode and affinity for the shared
> events.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 76 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index b95b8c4455e1..5dfa74b093f1 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -415,6 +415,80 @@ static unsigned long kvm_sdei_hypercall_status(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_info(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	unsigned long event_num = smccc_get_arg1(vcpu);
> +	unsigned long event_info = smccc_get_arg2(vcpu);
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
> +	/*
> +	 * Check if the KVM event exists. The event might have been
> +	 * registered, we need fetch the information from the registered
s/fetch/to fetch
> +	 * event in that case.
> +	 */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
> +	kse = kske ? kske->kse : NULL;
> +	if (!kse) {
> +		kse = kvm_sdei_find_event(kvm, event_num);
> +		if (!kse) {
> +			ret = SDEI_INVALID_PARAMETERS;
this should have already be covered by !kvm_sdei_is_valid_event_num I
think (although this latter only checks the since static event num with
KVM owner mask)
> +			goto unlock;
> +		}
> +	}
> +
> +	/* Retrieve the requested information */
> +	switch (event_info) {
> +	case SDEI_EVENT_INFO_EV_TYPE:
> +		ret = kse->state.type;
> +		break;
> +	case SDEI_EVENT_INFO_EV_SIGNALED:
> +		ret = kse->state.signaled;
> +		break;
> +	case SDEI_EVENT_INFO_EV_PRIORITY:
> +		ret = kse->state.priority;
> +		break;
> +	case SDEI_EVENT_INFO_EV_ROUTING_MODE:
> +	case SDEI_EVENT_INFO_EV_ROUTING_AFF:
> +		if (kse->state.type != SDEI_EVENT_TYPE_SHARED) {
> +			ret = SDEI_INVALID_PARAMETERS;
> +			break;
> +		}
> +
> +		if (event_info == SDEI_EVENT_INFO_EV_ROUTING_MODE) {
> +			ret = kske ? kske->state.route_mode :
> +				     SDEI_EVENT_REGISTER_RM_ANY;
no, if event is not registered (!kske) DENIED should be returned
> +		} else {
same here
> +			ret = kske ? kske->state.route_affinity : 0;
> +		}
> +
> +		break;
> +	default:
> +		ret = SDEI_INVALID_PARAMETERS;
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
> @@ -446,6 +520,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_status(vcpu);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
> +		ret = kvm_sdei_hypercall_info(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
>  	case SDEI_1_0_FN_SDEI_PE_MASK:
>  	case SDEI_1_0_FN_SDEI_PE_UNMASK:
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

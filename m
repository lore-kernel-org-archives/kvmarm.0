Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61888C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:16:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE787610CB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE787610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 422F54B276;
	Wed, 10 Nov 2021 06:16:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yy0nZp3cRfYq; Wed, 10 Nov 2021 06:16:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD46B4B2A7;
	Wed, 10 Nov 2021 06:16:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3FE4B26A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:16:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bMZMyOX0uEZJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 06:16:39 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B6D4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:16:39 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636542999;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=b7mp+5lU0MhnDm60HKtkVOloR5zR9YnN9HfGbstaIfs=;
 b=RADyz6GKBXyQD6XJsM/MD/cDFYvZ+01dnlrT7Uvduxw9ZjvKsj6Gs56AnW1mO24rgBeCTS
 puhUYdcnWQJwMNLrXamUYTOkHgbfT1rEZruLMnkyPv2uF7YeC/pO0BPb1cpoaEw/TOMlxR
 lvFTq5IvDJbWbiUzDz92mr8Mf8ntfS8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-0AQ6o99XMVShutjMZgHR1g-1; Wed, 10 Nov 2021 06:16:38 -0500
X-MC-Unique: 0AQ6o99XMVShutjMZgHR1g-1
Received: by mail-wm1-f71.google.com with SMTP id
 a186-20020a1c7fc3000000b00332f1a308e7so2944754wmd.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 03:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:subject:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=b7mp+5lU0MhnDm60HKtkVOloR5zR9YnN9HfGbstaIfs=;
 b=aftaStUFiJUBIDIeiFGbdrbImjyovUglhfi26rL7eUXcoL1QHejB1r4pMgAoaVExMs
 Y5IwmgZQ/7SpA/IwLDzSZf1bo6r0p8CU1Xl5y23IxX83m+g30IPWN1aI5eFGs+dByLBR
 iRUNNCWcAjorAqU7YzgP51LfRdBGfDdFJc3EK1s24k+Q7IdNwhu0uA6EZE5ujWNz/JPw
 l3N8J/oGuF8mnPfNuvXUs37mECp7/S8a0CDrqK0GTPI08ugZYrGR/YAmKAn0uD+xEKeP
 DHCzeG/59ANKDRTua7iEr1cdYIXwxevaQuaQPPgRQr1RIy3kTp0NslNu48rgKSFfkw01
 9fAQ==
X-Gm-Message-State: AOAM53384+8aQvEY3mHj5wadUKI5SzSDLv0ki/hVrMbajyGJNz5H6Fc5
 99RU4iC5sd6PStqjJxPBaKzK8Gcx1RJius7n8kQI2+SWrwgZmxKdojN6k4C+aR2Ku1wKwJCJ3v6
 1CtTQuHHZ1aCY8USubV6CACMw
X-Received: by 2002:a05:600c:a08:: with SMTP id
 z8mr15762582wmp.165.1636542997168; 
 Wed, 10 Nov 2021 03:16:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFgu1WvaBJtOekSSDZd6W0/5PVsCaDO0G5c6yrDZz8jXAaT6s3N0Oam2ZI1nIihQXdcquXCw==
X-Received: by 2002:a05:600c:a08:: with SMTP id
 z8mr15762550wmp.165.1636542996946; 
 Wed, 10 Nov 2021 03:16:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id h1sm5337881wmb.7.2021.11.10.03.16.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 03:16:36 -0800 (PST)
From: Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
Message-ID: <d9471e38-1840-1f79-c028-8f78afc0d2c7@redhat.com>
Date: Wed, 10 Nov 2021 12:16:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-7-gshan@redhat.com>
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
> This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
> to retrieved the original registers (R0 - R17) in its SDEI event
> handler. Those registers can be corrupted during the SDEI event
> delivery.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index b022ce0a202b..b4162efda470 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -270,6 +270,44 @@ static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_vcpu_regs *regs;
> +	unsigned long index = smccc_get_arg1(vcpu);
s/index/param_id to match the spec?
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = SDEI_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +	if (index > ARRAY_SIZE(vsdei->state.critical_regs.regs)) {
> +		ret = SDEI_INVALID_PARAMETERS;
> +		goto out;
> +	}
I would move the above after regs = and use regs there (although the
regs ARRAY_SIZE of both is identifical)
> +
> +	/* Check if the pending event exists */
> +	spin_lock(&vsdei->lock);
> +	if (!(vsdei->critical_event || vsdei->normal_event)) {
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}
> +
> +	/* Fetch the requested register */
> +	regs = vsdei->critical_event ? &vsdei->state.critical_regs :
> +				       &vsdei->state.normal_regs;
> +	ret = regs->regs[index];
> +
> +unlock:
> +	spin_unlock(&vsdei->lock);
> +out:
> +	return ret;
> +}
> +
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u32 func = smccc_get_function(vcpu);
> @@ -290,6 +328,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  		ret = kvm_sdei_hypercall_enable(vcpu, false);
>  		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
> +		ret = kvm_sdei_hypercall_context(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
>  	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
>  	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

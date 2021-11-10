Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D46C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:10:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 284D961251
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 284D961251
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A73804B2E4;
	Wed, 10 Nov 2021 09:10:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ksq4LFnNsZ7n; Wed, 10 Nov 2021 09:10:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D18E4B2F1;
	Wed, 10 Nov 2021 09:10:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C180A4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:10:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9E5QquMIG4fc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 09:10:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A20D4B2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:10:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636553402;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=w+V9WyF9pMhWUeAnQb8K3r7eRchvmHWHCwXm8++AnmI=;
 b=IREIaJlWPdkH18GPSk2zF+DpFvjIzYNf14BV2W9/doS2Bz9+yoLlehX1eFlD2GE9ZxvO2k
 wtjm7Sj3rACXlEO4L9zYXLjZ50suOWZsPezDlzn635Hr4m2BziUWQs071DrobrJt6f0Bne
 CR6Ad69NZH+6AhUc7HDpxMHafZl42kw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-F9GgRXSaO4CNz4xlCwqjhg-1; Wed, 10 Nov 2021 09:10:00 -0500
X-MC-Unique: F9GgRXSaO4CNz4xlCwqjhg-1
Received: by mail-wm1-f72.google.com with SMTP id
 201-20020a1c04d2000000b003335bf8075fso302552wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=w+V9WyF9pMhWUeAnQb8K3r7eRchvmHWHCwXm8++AnmI=;
 b=IsKG4iGjxBjEB84XzDFEwSUyqGUFZba1eYeHgJwhF9SnfnkjHjHp9P7AOdJtqFiMQu
 WA+1G/QVkw49X3eh254xC5csROdICYOmX5k3AnEMVFQwIM+bI1v9foEt50Fke+HpQK89
 rAjSzpC9czX+68TWLUmFdKq5Kb4EYeBGaC+vvferZAgyjNrmAo2/plDEKkp30M6HwiPi
 wxdfkmBlxEtxREiUwp7n1RS7HDjmlg47Iv82uucRf6jiSsthUziPXgPHq/PR+xGFsgat
 LW+Alkgi9o0ZZ9V1iU+WmGfjbV0SJMLUYWCi7m0mFKRc9h914k5ux4wBNa+U6Cqw+/cw
 819Q==
X-Gm-Message-State: AOAM533NeYQgE7SXhPHxvNlBFp+q6phOx6HmQfDWrkb+5BaAkLzsA+kl
 nT8PCUGtgwSotFhFpVkA6mC6QLMogBlDVc+b6pAQ71V5HwRJpnMLQSJqTZSfEpOejEvdOENIr/I
 GVVYqjjC9DoCmgjEgd70b3V5K
X-Received: by 2002:a05:6000:110b:: with SMTP id
 z11mr90478wrw.32.1636553399782; 
 Wed, 10 Nov 2021 06:09:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7QBo1yRJhfsOQ2XVt81p0F1T6VQOT/KGKflHbyIhvjg5FfatM1OUKkNEOOIJJd02T3IvUKw==
X-Received: by 2002:a05:6000:110b:: with SMTP id
 z11mr90444wrw.32.1636553399609; 
 Wed, 10 Nov 2021 06:09:59 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l2sm6307842wmq.42.2021.11.10.06.09.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 06:09:59 -0800 (PST)
Subject: Re: [PATCH v4 19/21] KVM: arm64: Support SDEI event cancellation
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-20-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <6557af7a-ca00-d9dd-c970-3e85c81d1582@redhat.com>
Date: Wed, 10 Nov 2021 15:09:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-20-gshan@redhat.com>
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
> The injected SDEI event is to send notification to guest. The SDEI
> event might not be needed after it's injected. This introduces API
> to support cancellation on the injected SDEI event if it's not fired
> to the guest yet.
> 
> This mechanism will be needed when we're going to support asynchronous
> page fault.

if we are able to manage the migration of an executing SDEI why can't we
manage the migration of pending SDEIs?

Eric
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_sdei.h |  1 +
>  arch/arm64/kvm/sdei.c             | 49 +++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> index 51087fe971ba..353744c7bad9 100644
> --- a/arch/arm64/include/asm/kvm_sdei.h
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -126,6 +126,7 @@ int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
>  			       kvm_sdei_notifier notifier);
>  int kvm_sdei_inject(struct kvm_vcpu *vcpu,
>  		    unsigned long num, bool immediate);
> +int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num);
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
>  long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
>  long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 7c2789cd1421..4f5a582daa97 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -907,6 +907,55 @@ int kvm_sdei_inject(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	struct kvm_sdei_vcpu_event *ksve = NULL;
> +	int ret = 0;
> +
> +	if (!(ksdei && vsdei)) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
> +	/* Find the vCPU event */
> +	spin_lock(&vsdei->lock);
> +	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
> +	if (!ksve) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	/* Event can't be cancelled if it has been delivered */
> +	if (ksve->state.refcount <= 1 &&
> +	    (vsdei->critical_event == ksve ||
> +	     vsdei->normal_event == ksve)) {
> +		ret = -EINPROGRESS;
> +		goto unlock;
> +	}
> +
> +	/* Free the vCPU event if necessary */
> +	kske = ksve->kske;
> +	ksve->state.refcount--;
> +	if (!ksve->state.refcount) {
> +		list_del(&ksve->link);
> +		kfree(ksve);
> +	}
> +
> +unlock:
> +	spin_unlock(&vsdei->lock);
> +	if (kske) {
> +		spin_lock(&ksdei->lock);
> +		kske->state.refcount--;
> +		spin_unlock(&ksdei->lock);
> +	}
> +out:
> +	return ret;
> +}
> +
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

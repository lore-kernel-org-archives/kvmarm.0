Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C883C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 15:37:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60FA8610F8
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 15:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60FA8610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C03CA4A98B;
	Wed, 10 Nov 2021 10:37:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E2FHg-OxOJYH; Wed, 10 Nov 2021 10:37:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578A74B09C;
	Wed, 10 Nov 2021 10:37:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF8DB4A98B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 10:37:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 97inrCx3mnZf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 10:37:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D104A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 10:37:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636558631;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TsMK8Ym36EtrROun3gA7xiKiYj4bqI5P7kgHHKBVFyA=;
 b=D6+xZiYlf5a/kWyUzRdJbYXH5SjHYm7zu22ObyIdochIYGdTX6zIabrC3T+iqKwfKoV+D1
 UBHAkmOzLEKMXzixZd3WFgH9EF0dVCFBBzEtZ+FBFfppeoYtfga4kpdlI1uUGiS2KXKXza
 iUo9hAIh8ZTpanW4xhFuT+/10mdSvxA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-YAMvgx7fPhmkVy-Rc5JApA-1; Wed, 10 Nov 2021 10:37:09 -0500
X-MC-Unique: YAMvgx7fPhmkVy-Rc5JApA-1
Received: by mail-wr1-f70.google.com with SMTP id
 k8-20020a5d5248000000b001763e7c9ce5so499829wrc.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 07:37:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=TsMK8Ym36EtrROun3gA7xiKiYj4bqI5P7kgHHKBVFyA=;
 b=mTcPt3GSCu5R4aA/ftfeVnVik9A42M6rO9/C50M8llM1CmnLp79ioqNchZJgmdKXuh
 K7bzFCJWm90j90ftqaZ6XdwOp7Qmn0B9nJxTL2YPj23eyM65Qa8IYQFRTol5a3zM8r6D
 d6dJrQMR1Rc1/BPYMkMcL4YtTDJyC/cQEIWSy9LZNiy9ce7TiJfCCX7xj3lNpugODU57
 bDY/XnjDyh7jw61ASXX1qC/Fc/fhEhYRUv9ZMur3cHWzuPN142gDeOQB3AL6T8YGsQb8
 qPE4qItnsiy5bYVsBwD4xzS6xriytZCBpsSg1ChbqFFXBmkMOW2hmU0b6U/S26WWIYyZ
 HBeQ==
X-Gm-Message-State: AOAM530E1qIALszzPxO1VJFCVPFbxref4ZM56A9lvBpAlsqAv1IH1sHE
 j8u4LAkWEQPa2Adx/1d5l7U4Rd4DGlxYGnaCRvUi+xVWCFYyGv3ulndjOxiUJuZElUaWsLDVaZR
 v8lVI08Ot8bHcFt8FzEusEbbI
X-Received: by 2002:a5d:6501:: with SMTP id x1mr747765wru.390.1636558625632;
 Wed, 10 Nov 2021 07:37:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycXSjChwKB0BbkM3ANwTjPHehWgOpLyLq/W1gEpfqQx0APhVPiRmZJycKMvLPxdh+qEJNvlg==
X-Received: by 2002:a5d:6501:: with SMTP id x1mr747721wru.390.1636558625424;
 Wed, 10 Nov 2021 07:37:05 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n32sm6983581wms.1.2021.11.10.07.37.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 07:37:04 -0800 (PST)
Subject: Re: [PATCH v4 02/15] KVM: async_pf: Add helper function to check
 completion queue
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-3-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <56d8dbec-a8fd-b109-0c0f-b01c1aef4741@redhat.com>
Date: Wed, 10 Nov 2021 16:37:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-3-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

On 8/15/21 2:59 AM, Gavin Shan wrote:
> This adds inline helper kvm_check_async_pf_completion_queue() to
> check if there are pending completion in the queue. The empty stub
> is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
> consider if CONFIG_KVM_ASYNC_PF is enabled.
> 
> All checks on the completion queue is done by the newly added inline
> function since list_empty() and list_empty_careful() are interchangeable.
why is it interchangeable?

> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h | 10 ++++++++++
>  virt/kvm/async_pf.c      | 10 +++++-----
>  virt/kvm/kvm_main.c      |  4 +---
>  4 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..7f35d9324b99 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11591,7 +11591,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  {
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
>  
>  	if (kvm_apic_has_events(vcpu))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 85b61a456f1c..a5f990f6dc35 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -339,12 +339,22 @@ struct kvm_async_pf {
>  	bool				notpresent_injected;
>  };
>  
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> +{
> +	return !list_empty_careful(&vcpu->async_pf.done);
> +}
> +
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>  void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>  bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			unsigned long hva, struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #else
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
>  #endif
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index dd777688d14a..d145a61a046a 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
>  		kvm_arch_async_page_present(vcpu, apf);
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&apf->link, &vcpu->async_pf.done);
>  	apf->vcpu = NULL;
>  	spin_unlock(&vcpu->async_pf.lock);
> @@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  		spin_lock(&vcpu->async_pf.lock);
>  	}
>  
> -	while (!list_empty(&vcpu->async_pf.done)) {
> +	while (kvm_check_async_pf_completion_queue(vcpu)) {
this is replaced by a stronger check. Please can you explain why is it
equivalent?
>  		struct kvm_async_pf *work =
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
> @@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
> -	while (!list_empty_careful(&vcpu->async_pf.done) &&
> +	while (kvm_check_async_pf_completion_queue(vcpu) &&
>  	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
>  		spin_lock(&vcpu->async_pf.lock);
>  		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
> @@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	struct kvm_async_pf *work;
>  	bool first;
>  
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return 0;
>  
>  	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> @@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&work->link, &vcpu->async_pf.done);
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..8795503651b1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3282,10 +3282,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>  	if (kvm_arch_dy_runnable(vcpu))
>  		return true;
>  
> -#ifdef CONFIG_KVM_ASYNC_PF
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
> -#endif
>  
>  	return false;
>  }
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

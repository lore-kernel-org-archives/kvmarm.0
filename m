Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BEBC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 21:30:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A806360F39
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 21:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A806360F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6C74B0F2;
	Mon, 16 Aug 2021 17:30:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jiULVmlJB+-v; Mon, 16 Aug 2021 17:30:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27804B103;
	Mon, 16 Aug 2021 17:30:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9964B110
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 12:54:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qLqlVAHI73S7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Aug 2021 12:54:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 236E84B10E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 12:54:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629132841;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PADTFWtkgacjxL5aCb4BndbTfuIMvOWWJjkXMj5LjiI=;
 b=Rm1RStGRxmgjw5WJBFlTLGXKCEbSm3aZUNeglFM2065dCrmMolHuCMSL5whW4ugXmYCMP9
 lTn/ptI5bx//kkTxx73CZaHGcgZ9A9DNXhV8+Nvobt0hkibFTm+fXNiZHN+IVbIFR5a0oK
 O4ByO+Rq280AGnsqddduJyHXh+skusc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-a_CgpFYtOnOyVyrURTibuw-1; Mon, 16 Aug 2021 12:54:00 -0400
X-MC-Unique: a_CgpFYtOnOyVyrURTibuw-1
Received: by mail-wm1-f70.google.com with SMTP id
 u14-20020a7bcb0e0000b0290248831d46e4so166670wmj.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 09:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=PADTFWtkgacjxL5aCb4BndbTfuIMvOWWJjkXMj5LjiI=;
 b=k8RmFICBmntyD9dNwZ3iRX1Web6NQPazbPZAN8Ub91pFemzkJqiJKR8n8MS0DjknVS
 xvPYUczLIVCdRSBDUb3f7oB0kloGdql2LuY2trzUloDo4/wTrdA0lKG/qV/eO3yfRU0B
 zx4KLlJXv4H7w8Y9Q+kNMGRLv9oLwhPKYKSBljbJ0onliLRDzZ7kiMMt1m8RR3s90rp+
 Dk+4YeJL4FzdtC7E5+fxg/haeajZnIgtYpF7tKtisJQLGI827Fhi2Q2G36Ed5gm+u96n
 /M65MWENWyKqXl+Vm4mAIcvJikkkNSI/SP5hxE7fNH0c5evLLcHRVR9L6WjETRIz1Ex+
 SSUQ==
X-Gm-Message-State: AOAM532hj+MY3HwraLZDbxF1oXp1I5Alnv6CKjFhiAGvkgNFq1NqwTGC
 6MwmxW3abhkOISkSgXnaosW9NDXDHZWcDC5ZMS7ZjUvc3YKulXwzl7E1d5AHGzP6s8NGt1HR0BA
 MT3iYSIg3eidygrAhsuiujylWAjL9NKkF1fQiUtQhjI5pJHeQWJKmxhOOuLhZz6jE3sZ0KQMT/O
 lA
X-Received: by 2002:adf:e3d2:: with SMTP id k18mr19260253wrm.212.1629132839166; 
 Mon, 16 Aug 2021 09:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiktEdXIUdYenTuirwoDwoW4Gw7S40sfPqijk61K8unLBFFJ1r0nluf5F4o61Bw+qZPW9CrA==
X-Received: by 2002:adf:e3d2:: with SMTP id k18mr19260223wrm.212.1629132838897; 
 Mon, 16 Aug 2021 09:53:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id i8sm9234140wrv.70.2021.08.16.09.53.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Aug 2021 09:53:58 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 02/15] KVM: async_pf: Add helper function to check
 completion queue
In-Reply-To: <20210815005947.83699-3-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-3-gshan@redhat.com>
Date: Mon, 16 Aug 2021 18:53:57 +0200
Message-ID: <87bl5xmiu2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=vkuznets@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 16 Aug 2021 17:30:36 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Gavin Shan <gshan@redhat.com> writes:

> This adds inline helper kvm_check_async_pf_completion_queue() to
> check if there are pending completion in the queue. The empty stub
> is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
> consider if CONFIG_KVM_ASYNC_PF is enabled.
>
> All checks on the completion queue is done by the newly added inline
> function since list_empty() and list_empty_careful() are interchangeable.
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

Nitpicking: When not reading the implementation, I'm not exactly sure
what this function returns as 'check' is too ambiguous ('true' when the
queue is full? when it's empty? when it's not empty? when it was
properly set up?). I'd suggest we go with a more specific:

kvm_async_pf_completion_queue_empty() or something like that instead
(we'll have to invert the logic everywhere then). 

Side note: x86 seems to already use a shortened 'apf' instead of
'async_pf' in a number of places (e.g. 'apf_put_user_ready()'), we may
want to either fight this practice or support the rebelion by renaming
all functions from below instead :-)

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

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

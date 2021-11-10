Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D8AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:35:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC0A061130
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:35:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC0A061130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671BB4B288;
	Wed, 10 Nov 2021 06:35:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fOvkj97tVrfb; Wed, 10 Nov 2021 06:35:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1434B241;
	Wed, 10 Nov 2021 06:35:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA70E4B241
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:35:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ-l7NrBeV5u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 06:35:28 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3264B23E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:35:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636544128;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GMK3AQv2v0VYH+29HMqixMbj/3+oXx5xG3vQFOxIFfk=;
 b=hCzqsP+6maWQr4LedLacybCkZ0iPC1FAg7kOX8kccfjA+v7y+JPuS3bNotBKLXtwiUH1Xg
 PQtnZSnCIdJ4JQ4qkLmyNrg4s6qd9t3kMXCwK50aK4eiOG12BnKxU7b1QRGBGy5a5PFOk4
 VVl+Sft6ffro9XVSxcybMyZbi2xeDas=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-Z9OXHjd8ODWKUXHRqjQAFw-1; Wed, 10 Nov 2021 06:35:27 -0500
X-MC-Unique: Z9OXHjd8ODWKUXHRqjQAFw-1
Received: by mail-wm1-f72.google.com with SMTP id
 k5-20020a7bc3050000b02901e081f69d80so973378wmj.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 03:35:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=GMK3AQv2v0VYH+29HMqixMbj/3+oXx5xG3vQFOxIFfk=;
 b=VrlXiw2akBHTRsem8GNarBLX6B2nbYX62qeOfv6VFRoxvN1vlLdjqSNIakqHAB/6gA
 Wf+ZkIO5PnS8ZpsQKpwQrc132YkMLkNGsHY5Oy6RT6Um4LaclrI2CXBM5V3S3cRt8bDc
 n1g3O8yfjpNukz+vdGx3u0rPo1HteqpDWfanlS0Cp4XN6Tqnj8UeSvN7tDDWUqJ5vGTF
 DgfLKEQXGfuGgr55r+3YnQSIohI/qkZQt0hXdTQcTm45vWZSyUE/wxzfFyVIem35nVOQ
 kf6of+hFMEUZ+Ul9rW09TUzeCu8bqTd6mST9bwypCmvpDSGo2bxuzjM5eLcp8vbiWVQS
 R8dw==
X-Gm-Message-State: AOAM530Psrr0/Xna9KoflzUFNrznmOevPj1q3qO4kZGUL8Ygu9SRSr9X
 2F1ZNFyX8qLeXqAasj7t+SmrjoJkRQ4IATsp/+Z1YwRSrFjO/62ohWMyor8XZWsHzEPHyEKNxQu
 8BAqWKZw+l3PpIZUQNj3hgHzM
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr19247422wrq.354.1636544124747; 
 Wed, 10 Nov 2021 03:35:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXqasDzL+qmM9KJjXCfDTC1z0HFK6+Kt5XbnCv3TvMQHcbEaBKts/biRFjOidcRcin6h0n9g==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr19247382wrq.354.1636544124550; 
 Wed, 10 Nov 2021 03:35:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id p13sm5748673wmi.0.2021.11.10.03.35.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 03:35:23 -0800 (PST)
Subject: Re: [PATCH v4 15/21] KVM: arm64: Support SDEI event notifier
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-16-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <a5a9f99b-d919-e381-f4f0-45a1db417843@redhat.com>
Date: Wed, 10 Nov 2021 12:35:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-16-gshan@redhat.com>
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
> The owner of the SDEI event, like asynchronous page fault, need
owner is not a terminology used in the SDEI spec
> know the state of injected SDEI event. This supports SDEI event
s/need know the state of injected/to know the state of the injected
> state updating by introducing notifier mechanism. It's notable
a notifier mechanism
> the notifier (handler) should be capable of migration.
I don't understand the last sentence
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_sdei.h      | 12 +++++++
>  arch/arm64/include/uapi/asm/kvm_sdei.h |  1 +
>  arch/arm64/kvm/sdei.c                  | 45 +++++++++++++++++++++++++-
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> index 7f5f5ad689e6..19f2d9b91f85 100644
> --- a/arch/arm64/include/asm/kvm_sdei.h
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -16,6 +16,16 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>  
> +struct kvm_vcpu;
> +
> +typedef void (*kvm_sdei_notifier)(struct kvm_vcpu *vcpu,
> +				  unsigned long num,
> +				  unsigned int state);
> +enum {
> +	KVM_SDEI_NOTIFY_DELIVERED,
> +	KVM_SDEI_NOTIFY_COMPLETED,
> +};
> +
>  struct kvm_sdei_event {
>  	struct kvm_sdei_event_state		state;
>  	struct kvm				*kvm;
> @@ -112,6 +122,8 @@ KVM_SDEI_FLAG_FUNC(enabled)
>  void kvm_sdei_init_vm(struct kvm *kvm);
>  void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
> +int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
> +			       kvm_sdei_notifier notifier);
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
>  void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
>  void kvm_sdei_destroy_vm(struct kvm *kvm);
> diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
> index 8928027023f6..4ef661d106fe 100644
> --- a/arch/arm64/include/uapi/asm/kvm_sdei.h
> +++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
> @@ -23,6 +23,7 @@ struct kvm_sdei_event_state {
>  	__u8	type;
>  	__u8	signaled;
>  	__u8	priority;
> +	__u64	notifier;
why is the notifier attached to the exposed event and not to the
registered or even vcpu event? This needs to be motivated.

Also as commented earlier I really think we first need to agree on the
uapi and get a consensus on it as it must be right on the 1st shot. In
that prospect maybe introduce a patch dedicated to the uapi and document
it properly, including the way the end user is supposed to use it.

Another way to proceed would be to not support migration at the moment,
mature the API and then introduce migration support later. Would it make
sense? For instance, in the past in-kernel ITS emulation was first
introduced without migration support.

Thanks

Eric
>  };
>  
>  struct kvm_sdei_kvm_event_state {
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 1e8e213c9d70..5f7a37dcaa77 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -314,9 +314,11 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>  	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
>  	struct kvm_sdei_kvm_event *kske = NULL;
>  	struct kvm_sdei_vcpu_event *ksve = NULL;
>  	struct kvm_sdei_vcpu_regs *regs;
> +	kvm_sdei_notifier notifier;
>  	unsigned long ret = SDEI_SUCCESS;
>  	int index;
>  
> @@ -349,6 +351,13 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
>  	*vcpu_cpsr(vcpu) = regs->pstate;
>  	*vcpu_pc(vcpu) = regs->pc;
>  
> +	/* Notifier */
> +	kske = ksve->kske;
> +	kse = kske->kse;
> +	notifier = (kvm_sdei_notifier)(kse->state.notifier);
> +	if (notifier)
> +		notifier(vcpu, kse->state.num, KVM_SDEI_NOTIFY_COMPLETED);
> +
>  	/* Inject interrupt if needed */
>  	if (resume)
>  		kvm_inject_irq(vcpu);
> @@ -358,7 +367,6 @@ static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
>  	 * event state as it's not destroyed because of the reference
>  	 * count.
>  	 */
> -	kske = ksve->kske;
>  	ksve->state.refcount--;
>  	kske->state.refcount--;
>  	if (!ksve->state.refcount) {
> @@ -746,6 +754,35 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +int kvm_sdei_register_notifier(struct kvm *kvm,
> +			       unsigned long num,
> +			       kvm_sdei_notifier notifier)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	int ret = 0;
> +
> +	if (!ksdei) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
> +	spin_lock(&ksdei->lock);
> +
> +	kse = kvm_sdei_find_event(kvm, num);
> +	if (!kse) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	kse->state.notifier = (unsigned long)notifier;
> +
> +unlock:
> +	spin_unlock(&ksdei->lock);
> +out:
> +	return ret;
> +}
> +
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -755,6 +792,7 @@ void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>  	struct kvm_sdei_kvm_event *kske = NULL;
>  	struct kvm_sdei_vcpu_event *ksve = NULL;
>  	struct kvm_sdei_vcpu_regs *regs = NULL;
> +	kvm_sdei_notifier notifier;
>  	unsigned long pstate;
>  	int index = 0;
>  
> @@ -826,6 +864,11 @@ void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>  	*vcpu_cpsr(vcpu) = pstate;
>  	*vcpu_pc(vcpu) = kske->state.entries[index];
>  
> +	/* Notifier */
> +	notifier = (kvm_sdei_notifier)(kse->state.notifier);
> +	if (notifier)
> +		notifier(vcpu, kse->state.num, KVM_SDEI_NOTIFY_DELIVERED);
> +
>  unlock:
>  	spin_unlock(&vsdei->lock);
>  }
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

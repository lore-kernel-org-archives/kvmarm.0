Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8225CC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:05:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3B2361246
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3B2361246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6712D4B2D3;
	Wed, 10 Nov 2021 09:05:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nwE430hBExOd; Wed, 10 Nov 2021 09:05:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1C8C4B2DA;
	Wed, 10 Nov 2021 09:05:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298274B2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:05:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4ClAoTex9oY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 09:05:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E414B286
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:05:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636553140;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jj5VWreri1Cq4IUj2RAKn1UrTLkppAlKfSLNXLYemI4=;
 b=QYgg9CD65b9y3wuxNGJy/0Zkg9VIsHModTIewaQMlS5AbMktFAaYUCiTV7pplSiq0wQlkr
 gL+EqgXcVU7mVFqr+D262/IJVZiSsW6Fga1KaW6RpUmVldQ8Dvij+b0wg6qGO+j1tkVqfj
 oa9GPld/nHBNiEeoThkN0T3hxCDCgqI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-TrebtMkNOP6VVZWynKxGaw-1; Wed, 10 Nov 2021 09:05:39 -0500
X-MC-Unique: TrebtMkNOP6VVZWynKxGaw-1
Received: by mail-wm1-f69.google.com with SMTP id
 g11-20020a1c200b000000b003320d092d08so1156136wmg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=jj5VWreri1Cq4IUj2RAKn1UrTLkppAlKfSLNXLYemI4=;
 b=XxhCObJwGnzcBwFevps9KGSPnPHGDyEHYuX/4p8YgSw/Ya5RJTr1JF8DurR+chEE+j
 FDeVmNuE6oIM/Wfv5FnAFvPJwC3AGkHdIjjXiN+QQ4aea9qtDzpKA7dPzZWCA6LNfSVd
 5W08VwloyoaPiesSYtt0xxXu+5YAbTIvqeb0TlTRQRxXc6lGcDBHqYA+gx6mudNux4ak
 cBS1tnytJZ3K+uF2GLoLSrIRuBMZZCI/5jZCsIVybV0Ee5N2ZnXGVB2AiEesIBhoLD4x
 KuH/ZGWIRuH5oPIvbmc/68RvvQB3EIiWMDFjOWG78LLLlr8ibaSNGeHAsElE696psgia
 J6QQ==
X-Gm-Message-State: AOAM531HCZRn0zhGyI3xfiZeWFwDEc9OsZNPhCazihcu4O+ukqVGPqxZ
 SWUVyoWMPQjru/lBFuqtmdi3Ye9DnmyEgkWNNNDBawq86lW+npN3EFlOnaeySrzj393IQroUKyM
 79OAgolsIMHaQwEKHY1BtwHHC
X-Received: by 2002:a1c:447:: with SMTP id 68mr16791279wme.69.1636553137528;
 Wed, 10 Nov 2021 06:05:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxja9oMSCV/h+9FDdKfXS7b9KKTIne9SQJuNkZzMrSBTtEcY6h3oZNZAeViu3afBOTsGiQf7Q==
X-Received: by 2002:a1c:447:: with SMTP id 68mr16791145wme.69.1636553136514;
 Wed, 10 Nov 2021 06:05:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id t8sm5496973wmn.44.2021.11.10.06.05.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 06:05:35 -0800 (PST)
Subject: Re: [PATCH v4 18/21] KVM: arm64: Support SDEI event injection
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-19-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <6c11ed83-796e-765e-bb6a-116947d33eab@redhat.com>
Date: Wed, 10 Nov 2021 15:05:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-19-gshan@redhat.com>
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
> This supports SDEI event injection by implementing kvm_sdei_inject().
> It's called by kernel directly or VMM through ioctl command to inject
> SDEI event to the specific vCPU.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_sdei.h      |   2 +
>  arch/arm64/include/uapi/asm/kvm_sdei.h |   1 +
>  arch/arm64/kvm/sdei.c                  | 108 +++++++++++++++++++++++++
>  3 files changed, 111 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> index a997989bab77..51087fe971ba 100644
> --- a/arch/arm64/include/asm/kvm_sdei.h
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -124,6 +124,8 @@ void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
>  int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
>  			       kvm_sdei_notifier notifier);
> +int kvm_sdei_inject(struct kvm_vcpu *vcpu,
> +		    unsigned long num, bool immediate);
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
>  long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
>  long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
> diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
> index b916c3435646..f7a6b2b22b50 100644
> --- a/arch/arm64/include/uapi/asm/kvm_sdei.h
> +++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
> @@ -67,6 +67,7 @@ struct kvm_sdei_vcpu_state {
>  #define KVM_SDEI_CMD_SET_VEVENT			7
>  #define KVM_SDEI_CMD_GET_VCPU_STATE		8
>  #define KVM_SDEI_CMD_SET_VCPU_STATE		9
> +#define KVM_SDEI_CMD_INJECT_EVENT		10
>  
>  struct kvm_sdei_cmd {
>  	__u32						cmd;
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 79315b77f24b..7c2789cd1421 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -802,6 +802,111 @@ int kvm_sdei_register_notifier(struct kvm *kvm,
>  	return ret;
>  }
>  
> +int kvm_sdei_inject(struct kvm_vcpu *vcpu,
> +		    unsigned long num,
> +		    bool immediate)
don't get the immediate param.
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	struct kvm_sdei_vcpu_event *ksve = NULL;
> +	int index, ret = 0;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
> +	if (!kvm_sdei_is_valid_event_num(num)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Check the kvm event */
> +	spin_lock(&ksdei->lock);
> +	kske = kvm_sdei_find_kvm_event(kvm, num);
> +	if (!kske) {
> +		ret = -ENOENT;
> +		goto unlock_kvm;
> +	}
> +
> +	kse = kske->kse;
> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
> +		vcpu->vcpu_idx : 0;
> +	if (!(kvm_sdei_is_registered(kske, index) &&
> +	      kvm_sdei_is_enabled(kske, index))) {
> +		ret = -EPERM;
> +		goto unlock_kvm;
> +	}
> +
> +	/* Check the vcpu state */
> +	spin_lock(&vsdei->lock);
> +	if (vsdei->state.masked) {
> +		ret = -EPERM;
> +		goto unlock_vcpu;
> +	}
> +
> +	/* Check if the event can be delivered immediately */
> +	if (immediate) {
According to the dispatcher pseudo code this should be always checked?
> +		if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL &&
> +		    !list_empty(&vsdei->critical_events)) {
> +			ret = -ENOSPC;
> +			goto unlock_vcpu;
> +		}
> +
> +		if (kse->state.priority == SDEI_EVENT_PRIORITY_NORMAL &&
> +		    (!list_empty(&vsdei->critical_events) ||
> +		     !list_empty(&vsdei->normal_events))) {
> +			ret = -ENOSPC;
> +			goto unlock_vcpu;
> +		}
> +	}
What about shared event dispatching. I don't see the afficinity checked
anywhere?
> +
> +	/* Check if the vcpu event exists */
> +	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
> +	if (ksve) {
> +		kske->state.refcount++;
> +		ksve->state.refcount++;
why this double refcount increment??
> +		kvm_make_request(KVM_REQ_SDEI, vcpu);
> +		goto unlock_vcpu;
> +	}
> +
> +	/* Allocate vcpu event */
> +	ksve = kzalloc(sizeof(*ksve), GFP_KERNEL);
> +	if (!ksve) {
> +		ret = -ENOMEM;
> +		goto unlock_vcpu;
> +	}
> +
> +	/*
> +	 * We should take lock to update KVM event state because its
> +	 * reference count might be zero. In that case, the KVM event
> +	 * could be destroyed.
> +	 */
> +	kske->state.refcount++;
> +	ksve->state.num      = num;
> +	ksve->state.refcount = 1;
> +	ksve->kske           = kske;
> +	ksve->vcpu           = vcpu;
> +
> +	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL)
> +		list_add_tail(&ksve->link, &vsdei->critical_events);
> +	else
> +		list_add_tail(&ksve->link, &vsdei->normal_events);
> +
> +	kvm_make_request(KVM_REQ_SDEI, vcpu);
> +
> +unlock_vcpu:
> +	spin_unlock(&vsdei->lock);
> +unlock_kvm:
> +	spin_unlock(&ksdei->lock);
> +out:
> +	return ret;
> +}
> +
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -1317,6 +1422,9 @@ long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg)
>  	case KVM_SDEI_CMD_SET_VCPU_STATE:
>  		ret = kvm_sdei_set_vcpu_state(vcpu, &cmd->ksv_state);
>  		break;
> +	case KVM_SDEI_CMD_INJECT_EVENT:
> +		ret = kvm_sdei_inject(vcpu, cmd->num, false);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

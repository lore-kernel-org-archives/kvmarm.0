Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069C6C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:48:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CEA861104
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7CEA861104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F764B2DD;
	Wed, 10 Nov 2021 08:48:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xfw-mnDU+7di; Wed, 10 Nov 2021 08:48:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD4B4B2E4;
	Wed, 10 Nov 2021 08:48:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 109F64B2DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:48:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T686gkfYXl-7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 08:48:16 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1C714B2B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:48:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636552096;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Og55LDFYJ7kO+kgyTSozRobvntp0cnmzWCkIuzU05sg=;
 b=ZPnhrM7BjEEmxS7HUrOpaNcPYEkoBRiP8cuX4kxzNhoaBL9Ijy0sLKXfVLYz+yNnXHQDdl
 dNK2RGaj9hWTN20jURNm3/QXJjk1Cs24qLbDrBG00JjdubnJSYVkvPnsNEJcQqbSKosgRk
 9jZmMmwnTiLvk/sWdGhU0feb6FKDslg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-qBNTwezjPa6gPN-6Yqdaww-1; Wed, 10 Nov 2021 08:48:15 -0500
X-MC-Unique: qBNTwezjPa6gPN-6Yqdaww-1
Received: by mail-wm1-f70.google.com with SMTP id
 o18-20020a05600c511200b00332fa17a02eso1215353wms.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 05:48:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Og55LDFYJ7kO+kgyTSozRobvntp0cnmzWCkIuzU05sg=;
 b=3BfSht5Ivn8fu1Js6Zonlj4Y/UTbR18cSLTRQlfU8/AXPmlnNDTsDkDvAMynvf5Igr
 1W3mANpUk3H5io/17BDsjEREyBhpMiOpb7a+Xn1hNZjeLwtmaTw49YL6klioxU9IOCKk
 49+Ydh5KybuIz9HXHjlX2wP2gHv7jvxw8JP2KYTnMO/yvJpZZmrbicxXrP74IMY79S8Z
 H+vgH//nGmqqXGbONz8N/jQ9FN1CRkmQ1zZ0PFq5Z2jf/THVQn7SgXhaErziEW9XXo+a
 tiQ7Dth0jO5H3whjL0AjIQ1bKRy9P+nZbF6qW3pgfEFRF/Z74wDoplkJkq1ihzbEqVD0
 bXLg==
X-Gm-Message-State: AOAM530HXDVe33ZbbrecUTJG21bKZo3IIdhEgZZqPYEbzP9YsJcrMbOi
 cOYXBjqlpjEd4NdJjOI/3wLJlOY4sOJ8OLMsnC5AJKzxBgo+2DgK4TP+TI5D4HRdcVrM0B/bdis
 McfrfQSJ6Qyc2BoPPISM6QsMk
X-Received: by 2002:a05:600c:4f87:: with SMTP id
 n7mr16258200wmq.168.1636552093644; 
 Wed, 10 Nov 2021 05:48:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyp8PU3xnrReXZdEzOGfjYjxfYWwQf7uiEdn+JdUIQ7LP/uVRbGaV+xWQAd7nFWI/TOLRNBUQ==
X-Received: by 2002:a05:600c:4f87:: with SMTP id
 n7mr16258153wmq.168.1636552093377; 
 Wed, 10 Nov 2021 05:48:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id i17sm6086348wmq.48.2021.11.10.05.48.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 05:48:12 -0800 (PST)
Subject: Re: [PATCH v4 16/21] KVM: arm64: Support SDEI ioctl commands on VM
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-17-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <6a4f1736-3af0-ccaa-e8a0-242759610430@redhat.com>
Date: Wed, 10 Nov 2021 14:48:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-17-gshan@redhat.com>
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
> This supports ioctl commands on VM to manage the various objects.
> It's primarily used by VMM to accomplish live migration. The ioctl
> commands introduced by this are highlighted as blow:
below
> 
>    * KVM_SDEI_CMD_GET_VERSION
>      Retrieve the version of current implementation
which implementation, SDEI?
>    * KVM_SDEI_CMD_SET_EVENT
>      Add event to be exported from KVM so that guest can register
>      against it afterwards
>    * KVM_SDEI_CMD_GET_KEVENT_COUNT
>      Retrieve number of registered SDEI events
>    * KVM_SDEI_CMD_GET_KEVENT
>      Retrieve the state of the registered SDEI event
>    * KVM_SDEI_CMD_SET_KEVENT
>      Populate the registered SDEI event
I think we really miss the full picture of what you want to achieve with
those IOCTLs or at least I fail to get it. Please document the UAPI
separately including the structs and IOCTLs.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_sdei.h      |   1 +
>  arch/arm64/include/uapi/asm/kvm_sdei.h |  17 +++
>  arch/arm64/kvm/arm.c                   |   3 +
>  arch/arm64/kvm/sdei.c                  | 171 +++++++++++++++++++++++++
>  include/uapi/linux/kvm.h               |   3 +
>  5 files changed, 195 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> index 19f2d9b91f85..8f5ea947ed0e 100644
> --- a/arch/arm64/include/asm/kvm_sdei.h
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -125,6 +125,7 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
>  int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
>  			       kvm_sdei_notifier notifier);
>  void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
> +long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
>  void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
>  void kvm_sdei_destroy_vm(struct kvm *kvm);
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
> index 4ef661d106fe..35ff05be3c28 100644
> --- a/arch/arm64/include/uapi/asm/kvm_sdei.h
> +++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
> @@ -57,5 +57,22 @@ struct kvm_sdei_vcpu_state {
>  	struct kvm_sdei_vcpu_regs	normal_regs;
>  };
>  
> +#define KVM_SDEI_CMD_GET_VERSION		0
> +#define KVM_SDEI_CMD_SET_EVENT			1
> +#define KVM_SDEI_CMD_GET_KEVENT_COUNT		2
> +#define KVM_SDEI_CMD_GET_KEVENT			3
> +#define KVM_SDEI_CMD_SET_KEVENT			4
> +
> +struct kvm_sdei_cmd {
> +	__u32						cmd;
> +	union {
> +		__u32					version;
> +		__u32					count;
> +		__u64					num;
> +		struct kvm_sdei_event_state		kse_state;
> +		struct kvm_sdei_kvm_event_state		kske_state;
> +	};
> +};
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _UAPI__ASM_KVM_SDEI_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0c3db1ef1ba9..8d61585124b2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1389,6 +1389,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			return -EFAULT;
>  		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
>  	}
> +	case KVM_ARM_SDEI_COMMAND: {
> +		return kvm_sdei_vm_ioctl(kvm, arg);
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 5f7a37dcaa77..bdd76c3e5153 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -931,6 +931,177 @@ void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.sdei = vsdei;
>  }
>  
> +static long kvm_sdei_set_event(struct kvm *kvm,
> +			       struct kvm_sdei_event_state *kse_state)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +
> +	if (!kvm_sdei_is_valid_event_num(kse_state->num))
> +		return -EINVAL;
> +
> +	if (!(kse_state->type == SDEI_EVENT_TYPE_SHARED ||
> +	      kse_state->type == SDEI_EVENT_TYPE_PRIVATE))
> +		return -EINVAL;
> +
> +	if (!(kse_state->priority == SDEI_EVENT_PRIORITY_NORMAL ||
> +	      kse_state->priority == SDEI_EVENT_PRIORITY_CRITICAL))
> +		return -EINVAL;
> +
> +	kse = kvm_sdei_find_event(kvm, kse_state->num);
> +	if (kse)
> +		return -EEXIST;
> +
> +	kse = kzalloc(sizeof(*kse), GFP_KERNEL);
> +	if (!kse)
> +		return -ENOMEM;
userspace can exhaust the mem since there is no limit. There must be a max.

> +
> +	kse->state = *kse_state;
> +	kse->kvm = kvm;
> +	list_add_tail(&kse->link, &ksdei->events);
> +
> +	return 0;
> +}
> +
> +static long kvm_sdei_get_kevent_count(struct kvm *kvm, int *count)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +	int total = 0;
> +
> +	list_for_each_entry(kske, &ksdei->kvm_events, link) {
> +		total++;
> +	}
> +
> +	*count = total;
> +	return 0;
> +}
> +
> +static long kvm_sdei_get_kevent(struct kvm *kvm,
> +				struct kvm_sdei_kvm_event_state *kske_state)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +
> +	/*
> +	 * The first entry is fetched if the event number is invalid.
> +	 * Otherwise, the next entry is fetched.
why don't we return an error? What is the point returning the next entry?
> +	 */
> +	if (!kvm_sdei_is_valid_event_num(kske_state->num)) {
> +		kske = list_first_entry_or_null(&ksdei->kvm_events,
> +				struct kvm_sdei_kvm_event, link);
> +	} else {
> +		kske = kvm_sdei_find_kvm_event(kvm, kske_state->num);
> +		if (kske && !list_is_last(&kske->link, &ksdei->kvm_events))
> +			kske = list_next_entry(kske, link);
Sorry I don't get why we return the next one?
> +		else
> +			kske = NULL;
> +	}
> +
> +	if (!kske)
> +		return -ENOENT;
> +
> +	*kske_state = kske->state;
> +
> +	return 0;
> +}
> +
> +static long kvm_sdei_set_kevent(struct kvm *kvm,
> +				struct kvm_sdei_kvm_event_state *kske_state)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse = NULL;
> +	struct kvm_sdei_kvm_event *kske = NULL;
> +
> +	/* Sanity check */
> +	if (!kvm_sdei_is_valid_event_num(kske_state->num))
> +		return -EINVAL;
> +
> +	if (!(kske_state->route_mode == SDEI_EVENT_REGISTER_RM_ANY ||
> +	      kske_state->route_mode == SDEI_EVENT_REGISTER_RM_PE))
> +		return -EINVAL;
> +
> +	/* Check if the event number is valid */
> +	kse = kvm_sdei_find_event(kvm, kske_state->num);
> +	if (!kse)
> +		return -ENOENT;
> +
> +	/* Check if the event has been populated */
> +	kske = kvm_sdei_find_kvm_event(kvm, kske_state->num);
> +	if (kske)
> +		return -EEXIST;
> +
> +	kske = kzalloc(sizeof(*kske), GFP_KERNEL);
userspace can exhaust the mem since there is no limit
> +	if (!kske)
> +		return -ENOMEM;
> +
> +	kske->state = *kske_state;
> +	kske->kse   = kse;
> +	kske->kvm   = kvm;
> +	list_add_tail(&kske->link, &ksdei->kvm_events);
> +
> +	return 0;
> +}
> +
> +long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_cmd *cmd = NULL;
> +	void __user *argp = (void __user *)arg;
> +	bool copy = false;
> +	long ret = 0;
> +
> +	/* Sanity check */
> +	if (!ksdei) {
> +		ret = -EPERM;
> +		goto out;
> +	}
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(cmd, argp, sizeof(*cmd))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	spin_lock(&ksdei->lock);
> +
> +	switch (cmd->cmd) {
> +	case KVM_SDEI_CMD_GET_VERSION:
> +		copy = true;
> +		cmd->version = (1 << 16);       /* v1.0.0 */
> +		break;
> +	case KVM_SDEI_CMD_SET_EVENT:
> +		ret = kvm_sdei_set_event(kvm, &cmd->kse_state);
> +		break;
> +	case KVM_SDEI_CMD_GET_KEVENT_COUNT:
> +		copy = true;
> +		ret = kvm_sdei_get_kevent_count(kvm, &cmd->count);
> +		break;
> +	case KVM_SDEI_CMD_GET_KEVENT:
> +		copy = true;
> +		ret = kvm_sdei_get_kevent(kvm, &cmd->kske_state);
> +		break;
> +	case KVM_SDEI_CMD_SET_KEVENT:
> +		ret = kvm_sdei_set_kevent(kvm, &cmd->kske_state);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	spin_unlock(&ksdei->lock);
> +out:
> +	if (!ret && copy && copy_to_user(argp, cmd, sizeof(*cmd)))
> +		ret = -EFAULT;
> +
> +	kfree(cmd);
> +	return ret;
> +}
> +
>  void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9e4aabcb31a..8cf41fd4bf86 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1679,6 +1679,9 @@ struct kvm_xen_vcpu_attr {
>  #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
>  #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
>  
> +/* Available with KVM_CAP_ARM_SDEI */
> +#define KVM_ARM_SDEI_COMMAND	_IOWR(KVMIO, 0xce, struct kvm_sdei_cmd)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

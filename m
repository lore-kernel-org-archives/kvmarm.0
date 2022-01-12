Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FD0C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 02:46:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819454A7FD;
	Tue, 11 Jan 2022 21:46:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pzRPFXILxWK0; Tue, 11 Jan 2022 21:46:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 258024B0B4;
	Tue, 11 Jan 2022 21:46:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 743B24A7FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:46:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id goFvZ-WN6l9F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 21:46:36 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4403949F1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:46:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641955595;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lrg/rvcseomradiaHHuYHA2x3dDDuMaVcEYJB9dgKGE=;
 b=HFbEvTNrTK17JvVDwN+l6k0o6XH0ej/rzt5wZNCqffcjKdmFxV8fO2JLHRkhUHrq2IMlNh
 SpfUj3SqVzeTis0Ao+7KuvTPU37o8eCV/J/SytXRk77p7qdPNfwevIIqLynd/qW2hEyohj
 8b5ixfpvoHEa4CIq4s0WplpvcY8y3iI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-QaXQ-xsCMZixjJs-4ANMPQ-1; Tue, 11 Jan 2022 21:46:32 -0500
X-MC-Unique: QaXQ-xsCMZixjJs-4ANMPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEB801898292;
 Wed, 12 Jan 2022 02:46:30 +0000 (UTC)
Received: from [10.72.12.29] (ovpn-12-29.pek2.redhat.com [10.72.12.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ACED5BE29;
 Wed, 12 Jan 2022 02:46:26 +0000 (UTC)
Subject: Re: [PATCH v4 09/21] KVM: arm64: Support SDEI_EVENT_GET_INFO hypercall
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-10-gshan@redhat.com>
 <03e9b1fb-af79-69bf-f242-00fef3b11a81@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <44039a09-344f-3ac9-0d58-c0c8c4562b60@redhat.com>
Date: Wed, 12 Jan 2022 10:46:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <03e9b1fb-af79-69bf-f242-00fef3b11a81@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 11/10/21 1:19 AM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> This supports SDEI_EVENT_GET_INFO hypercall. It's used by the guest
>> to retrieve various information about the supported (exported) events,
>> including type, signaled, route mode and affinity for the shared
>> events.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 76 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 76 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index b95b8c4455e1..5dfa74b093f1 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -415,6 +415,80 @@ static unsigned long kvm_sdei_hypercall_status(struct kvm_vcpu *vcpu)
>>   	return ret;
>>   }
>>   
>> +static unsigned long kvm_sdei_hypercall_info(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_event *kse = NULL;
>> +	struct kvm_sdei_kvm_event *kske = NULL;
>> +	unsigned long event_num = smccc_get_arg1(vcpu);
>> +	unsigned long event_info = smccc_get_arg2(vcpu);
>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	/* Sanity check */
>> +	if (!(ksdei && vsdei)) {
>> +		ret = SDEI_NOT_SUPPORTED;
>> +		goto out;
>> +	}
>> +
>> +	if (!kvm_sdei_is_valid_event_num(event_num)) {
>> +		ret = SDEI_INVALID_PARAMETERS;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Check if the KVM event exists. The event might have been
>> +	 * registered, we need fetch the information from the registered
> s/fetch/to fetch

Ack.

>> +	 * event in that case.
>> +	 */
>> +	spin_lock(&ksdei->lock);
>> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
>> +	kse = kske ? kske->kse : NULL;
>> +	if (!kse) {
>> +		kse = kvm_sdei_find_event(kvm, event_num);
>> +		if (!kse) {
>> +			ret = SDEI_INVALID_PARAMETERS;
> this should have already be covered by !kvm_sdei_is_valid_event_num I
> think (although this latter only checks the since static event num with
> KVM owner mask)

Nope. Strictly speaking, kvm_sdei_find_event() covers the check carried
by !kvm_sdei_is_valid_event_num(). All the defined (exposed) events should
have virtual event number :)

>> +			goto unlock;
>> +		}
>> +	}
>> +
>> +	/* Retrieve the requested information */
>> +	switch (event_info) {
>> +	case SDEI_EVENT_INFO_EV_TYPE:
>> +		ret = kse->state.type;
>> +		break;
>> +	case SDEI_EVENT_INFO_EV_SIGNALED:
>> +		ret = kse->state.signaled;
>> +		break;
>> +	case SDEI_EVENT_INFO_EV_PRIORITY:
>> +		ret = kse->state.priority;
>> +		break;
>> +	case SDEI_EVENT_INFO_EV_ROUTING_MODE:
>> +	case SDEI_EVENT_INFO_EV_ROUTING_AFF:
>> +		if (kse->state.type != SDEI_EVENT_TYPE_SHARED) {
>> +			ret = SDEI_INVALID_PARAMETERS;
>> +			break;
>> +		}
>> +
>> +		if (event_info == SDEI_EVENT_INFO_EV_ROUTING_MODE) {
>> +			ret = kske ? kske->state.route_mode :
>> +				     SDEI_EVENT_REGISTER_RM_ANY;
> no, if event is not registered (!kske) DENIED should be returned

I don't think so. According to the specification, there is no DENIED
return value for STATUS hypercall. Either INVALID_PARAMETERS or NOT_SUPPORTED
should be returned from this hypercall :)

>> +		} else {
> same here
>> +			ret = kske ? kske->state.route_affinity : 0;
>> +		}
>> +
>> +		break;
>> +	default:
>> +		ret = SDEI_INVALID_PARAMETERS;
>> +	}
>> +
>> +unlock:
>> +	spin_unlock(&ksdei->lock);
>> +out:
>> +	return ret;
>> +}
>> +
>>   int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 func = smccc_get_function(vcpu);
>> @@ -446,6 +520,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   		ret = kvm_sdei_hypercall_status(vcpu);
>>   		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
>> +		ret = kvm_sdei_hypercall_info(vcpu);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
>>   	case SDEI_1_0_FN_SDEI_PE_MASK:
>>   	case SDEI_1_0_FN_SDEI_PE_UNMASK:
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19A1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 02:41:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E384A7FD;
	Tue, 11 Jan 2022 21:41:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VWxq4W5bRlWn; Tue, 11 Jan 2022 21:41:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 688814ACC9;
	Tue, 11 Jan 2022 21:41:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00FE149F29
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:41:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qbO+ao+8qaMW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 21:41:18 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E311549F0D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:41:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641955278;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uEux6PgvXo4td8VAgOHXM3FPN3p4OGxpPUEBxPT+bpE=;
 b=P4E0Mqua/Jok7draHTAQfblNNWrKgmZ/+c7w/xZf3jI4JMOKFEO1jvW7phLMHa2VU60GNS
 CM8zlh0RHYbNFW2IjFe25GWZiBJpdZpa+GuxzHOlfavSl8ZLlX7yg1yRgivTP/KQf0n2Go
 6bucKmxeFbExdchJt3m7udBO/BkKnOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-KfpExFTfMpKXr5U0oyp9HQ-1; Tue, 11 Jan 2022 21:41:15 -0500
X-MC-Unique: KfpExFTfMpKXr5U0oyp9HQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AE7B363A6;
 Wed, 12 Jan 2022 02:41:14 +0000 (UTC)
Received: from [10.72.12.29] (ovpn-12-29.pek2.redhat.com [10.72.12.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DDAA519BF;
 Wed, 12 Jan 2022 02:41:03 +0000 (UTC)
Subject: Re: [PATCH v4 08/21] KVM: arm64: Support SDEI_EVENT_STATUS hypercall
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-9-gshan@redhat.com>
 <36f2f2cf-3e6e-30ce-53d2-6c44be93272d@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c60845e3-0d98-2007-3461-2a707abe03cb@redhat.com>
Date: Wed, 12 Jan 2022 10:40:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <36f2f2cf-3e6e-30ce-53d2-6c44be93272d@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On 11/10/21 1:12 AM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> This supports SDEI_EVENT_STATUS hypercall. It's used by the guest
>> to retrieve a bitmap to indicate the SDEI event states, including
>> registration, enablement and delivery state.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 50 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index a3ba69dc91cb..b95b8c4455e1 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -367,6 +367,54 @@ static unsigned long kvm_sdei_hypercall_unregister(struct kvm_vcpu *vcpu)
>>   	return ret;
>>   }
>>   
>> +static unsigned long kvm_sdei_hypercall_status(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_event *kse = NULL;
>> +	struct kvm_sdei_kvm_event *kske = NULL;
>> +	unsigned long event_num = smccc_get_arg1(vcpu);
>> +	int index = 0;
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
> if we were to support bound events, I do not know if a given even num
> can disapper inbetween that check and the rest of the code, in which
> case a lock would be needed?

For the bound events, it's possbile. However, @ksdei->lock can be reused
in that cause. Anyway, it's something for future :)

>> +
>> +	/*
>> +	 * Check if the KVM event exists. None of the flags
>> +	 * will be set if it doesn't exist.
>> +	 */
>> +	spin_lock(&ksdei->lock);
>> +	kske = kvm_sdei_find_kvm_event(kvm, event_num);
>> +	if (!kske) {
>> +		ret = 0;
>> +		goto unlock;
>> +	}
>> +
>> +	index = (kse->state.type == SDEI_EVENT_TYPE_PRIVATE) ?
>> +		vcpu->vcpu_idx : 0;
>> +	if (kvm_sdei_is_registered(kske, index))
>> +		ret |= (1UL << SDEI_EVENT_STATUS_REGISTERED);
>> +	if (kvm_sdei_is_enabled(kske, index))
>> +		ret |= (1UL << SDEI_EVENT_STATUS_ENABLED);
>> +	if (kske->state.refcount)
>> +		ret |= (1UL << SDEI_EVENT_STATUS_RUNNING);
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
>> @@ -395,6 +443,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   		ret = kvm_sdei_hypercall_unregister(vcpu);
>>   		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
>> +		ret = kvm_sdei_hypercall_status(vcpu);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
>>   	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
>>   	case SDEI_1_0_FN_SDEI_PE_MASK:
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

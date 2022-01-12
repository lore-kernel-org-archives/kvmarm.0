Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCD4C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 07:19:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D62694B1BF;
	Wed, 12 Jan 2022 02:19:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zOge9k0f4lSK; Wed, 12 Jan 2022 02:19:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E3084B160;
	Wed, 12 Jan 2022 02:19:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 146D849F4F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 02:19:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qX86anDktNYM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 02:19:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADD649F4D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 02:19:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641971970;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=w5CS/fk3B1Jvusc64HiZRYZbo+ognmOdXNBVykQBTZQ=;
 b=LPXFIqWp0FKBQHrYXcViPHl8PAgV6p5WYCHjp/pEYb+2+Mksbq1jMrOWNeRNlDUsj8Eti3
 4YFrHFhV8HaJbd07A1YxKa1UyAJiNEyVIplAbuVpPC0aloNrywyYB05KWJr0gIfWhmfF61
 P7ZzHeIOBK5NSroCFHk+CV6OD4PIyF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-jU2kZIyKNhygsq7pPn5lug-1; Wed, 12 Jan 2022 02:19:28 -0500
X-MC-Unique: jU2kZIyKNhygsq7pPn5lug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 049731023F4D;
 Wed, 12 Jan 2022 07:19:25 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 533B56E201;
 Wed, 12 Jan 2022 07:19:13 +0000 (UTC)
Subject: Re: [PATCH v4 19/21] KVM: arm64: Support SDEI event cancellation
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-20-gshan@redhat.com>
 <6557af7a-ca00-d9dd-c970-3e85c81d1582@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <13955510-6e0f-dc94-83cc-26f0f53a8fcd@redhat.com>
Date: Wed, 12 Jan 2022 15:19:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <6557af7a-ca00-d9dd-c970-3e85c81d1582@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On 11/10/21 10:09 PM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> The injected SDEI event is to send notification to guest. The SDEI
>> event might not be needed after it's injected. This introduces API
>> to support cancellation on the injected SDEI event if it's not fired
>> to the guest yet.
>>
>> This mechanism will be needed when we're going to support asynchronous
>> page fault.
> 
> if we are able to manage the migration of an executing SDEI why can't we
> manage the migration of pending SDEIs?
> 

I think the commit log needs to explain the use case in a clearer way. It's
about Async PF's performance, not migration. In Async PF, the page fault is
delivered in asynchronous way using worker. The page fault can be completed
before the injected SDEI event for page-not-present notification is delivered.
In this case, we needn't the overhead caused by the injected SDEI event.

I will think about it and may drop this patch from the series, to detach
SDEI and async PF as much as possible :)


>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_sdei.h |  1 +
>>   arch/arm64/kvm/sdei.c             | 49 +++++++++++++++++++++++++++++++
>>   2 files changed, 50 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
>> index 51087fe971ba..353744c7bad9 100644
>> --- a/arch/arm64/include/asm/kvm_sdei.h
>> +++ b/arch/arm64/include/asm/kvm_sdei.h
>> @@ -126,6 +126,7 @@ int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
>>   			       kvm_sdei_notifier notifier);
>>   int kvm_sdei_inject(struct kvm_vcpu *vcpu,
>>   		    unsigned long num, bool immediate);
>> +int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num);
>>   void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
>>   long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
>>   long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index 7c2789cd1421..4f5a582daa97 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -907,6 +907,55 @@ int kvm_sdei_inject(struct kvm_vcpu *vcpu,
>>   	return ret;
>>   }
>>   
>> +int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_kvm_event *kske = NULL;
>> +	struct kvm_sdei_vcpu_event *ksve = NULL;
>> +	int ret = 0;
>> +
>> +	if (!(ksdei && vsdei)) {
>> +		ret = -EPERM;
>> +		goto out;
>> +	}
>> +
>> +	/* Find the vCPU event */
>> +	spin_lock(&vsdei->lock);
>> +	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
>> +	if (!ksve) {
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	/* Event can't be cancelled if it has been delivered */
>> +	if (ksve->state.refcount <= 1 &&
>> +	    (vsdei->critical_event == ksve ||
>> +	     vsdei->normal_event == ksve)) {
>> +		ret = -EINPROGRESS;
>> +		goto unlock;
>> +	}
>> +
>> +	/* Free the vCPU event if necessary */
>> +	kske = ksve->kske;
>> +	ksve->state.refcount--;
>> +	if (!ksve->state.refcount) {
>> +		list_del(&ksve->link);
>> +		kfree(ksve);
>> +	}
>> +
>> +unlock:
>> +	spin_unlock(&vsdei->lock);
>> +	if (kske) {
>> +		spin_lock(&ksdei->lock);
>> +		kske->state.refcount--;
>> +		spin_unlock(&ksdei->lock);
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>>   void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm *kvm = vcpu->kvm;
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

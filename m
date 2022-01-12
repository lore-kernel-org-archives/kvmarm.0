Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32D8C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 02:58:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A5E49F52;
	Tue, 11 Jan 2022 21:58:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yk2SEv4O07Y4; Tue, 11 Jan 2022 21:58:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF73749F49;
	Tue, 11 Jan 2022 21:58:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 691FC49F49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:58:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g0+4-gWngD31 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 21:58:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EBA949F2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:58:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641956328;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yu1Ym+x2T7q80BfcH6OCGclknqzM/xi6/S5+IsSqfEw=;
 b=MqQwXX+QQxu5beNbqqr0lvi68mjpKZsaUVwSNsa58J1KLE6cmVioGUdXsv0N9UZNpRjK9O
 Ph6O1TG9A873Ugf93nRtb81QVlUy0yhoEedVFefNEKp+aCpX9QFO5dtJNE8urCjEQu77o4
 SckKpCXW4FnCViSKBzZSIaCzxV8hxWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-RIuCibhXNgKiavnO-x1HCA-1; Tue, 11 Jan 2022 21:58:45 -0500
X-MC-Unique: RIuCibhXNgKiavnO-x1HCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8316B801B0C;
 Wed, 12 Jan 2022 02:58:44 +0000 (UTC)
Received: from [10.72.12.29] (ovpn-12-29.pek2.redhat.com [10.72.12.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E21C3610A5;
 Wed, 12 Jan 2022 02:58:37 +0000 (UTC)
Subject: Re: [PATCH v4 11/21] KVM: arm64: Support SDEI_PE_{MASK, UNMASK}
 hypercall
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-12-gshan@redhat.com>
 <e5acdb48-fb16-ab18-4938-c03265c4cfbf@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <60e72d4e-6002-eaac-783f-20a2cbe6f9aa@redhat.com>
Date: Wed, 12 Jan 2022 10:58:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e5acdb48-fb16-ab18-4938-c03265c4cfbf@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On 11/10/21 4:31 AM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> This supports SDEI_PE_{MASK, UNMASK} hypercall. They are used by
>> the guest to stop the specific vCPU from receiving SDEI events.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 35 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index 458695c2394f..3fb33258b494 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -551,6 +551,37 @@ static unsigned long kvm_sdei_hypercall_route(struct kvm_vcpu *vcpu)
>>   	return ret;
>>   }
>>   
>> +static unsigned long kvm_sdei_hypercall_mask(struct kvm_vcpu *vcpu,
>> +					     bool mask)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	/* Sanity check */
>> +	if (!(ksdei && vsdei)) {
>> +		ret = SDEI_NOT_SUPPORTED;
>> +		goto out;
>> +	}
>> +
>> +	spin_lock(&vsdei->lock);
>> +
>> +	/* Check the state */
>> +	if (mask == vsdei->state.masked) {
>> +		ret = SDEI_DENIED;
> are you sure? I don't this error documented in 5.1.12?
> 
> Besides the spec says:
> "
> This call can be invoked by the client to mask the PE, whether or not
> the PE is already masked."

Yep, I think this check can safely dropped.

>> +		goto unlock;
>> +	}
>> +
>> +	/* Update the state */
>> +	vsdei->state.masked = mask ? 1 : 0;
>> +
>> +unlock:
>> +	spin_unlock(&vsdei->lock);
>> +out:
>> +	return ret;
> In case of success the returned value is SUCESS for UNMASK but not for
> MASK (see table in 5.1.12).
> 
> By the way I have just noticed there is a more recent of the spec than
> the A:
> 
> ARM_DEN0054C
> 
> You should update the cover letter and [PATCH v4 02/21] KVM: arm64: Add
> SDEI virtualization infrastructure commit msg
> 

Thanks, Eric. You've looked into newer version of spec. I will update
the code and link to the spec accordingly :)

> 
>> +}
>> +
>>   int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 func = smccc_get_function(vcpu);
>> @@ -588,7 +619,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   		ret = kvm_sdei_hypercall_route(vcpu);
>>   		break;
>>   	case SDEI_1_0_FN_SDEI_PE_MASK:
>> +		ret = kvm_sdei_hypercall_mask(vcpu, true);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_PE_UNMASK:
>> +		ret = kvm_sdei_hypercall_mask(vcpu, false);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
>>   	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
>>   	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

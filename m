Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258E9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 02:34:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3774A11C;
	Tue, 11 Jan 2022 21:34:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C+9VzDIH6Qrm; Tue, 11 Jan 2022 21:34:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54B394B106;
	Tue, 11 Jan 2022 21:34:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B70C49F5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:34:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sI4cyAUXX2z3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 21:34:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A034B0CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 21:34:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641954845;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0ve6dVqu6QAlOIPi+1hlZlM6kVDy3FX6QfRDchE8K0A=;
 b=RBeWy3qtCkMNUViPVA0puC4y+g/KnndcyyPBNYoQm6BSc+lhD8XEG9b7lpzWG4tGI9y4UI
 jjpJ/MNgGHE7wVzDH/QWX2yaylxURATlGqSSJaSow5dQoaY7V53/50v5EdYOim2TDnz2lc
 RnhvwIOUmZqfWf0riYkxMVNoeYVc3H4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-LSn0tQE-Mp6its-C8N6Whw-1; Tue, 11 Jan 2022 21:34:02 -0500
X-MC-Unique: LSn0tQE-Mp6its-C8N6Whw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0938D1F2DA;
 Wed, 12 Jan 2022 02:33:59 +0000 (UTC)
Received: from [10.72.12.29] (ovpn-12-29.pek2.redhat.com [10.72.12.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B91654BC64;
 Wed, 12 Jan 2022 02:33:53 +0000 (UTC)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <d9471e38-1840-1f79-c028-8f78afc0d2c7@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <28219c6a-5200-b8f3-09e1-6aa08565030a@redhat.com>
Date: Wed, 12 Jan 2022 10:33:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d9471e38-1840-1f79-c028-8f78afc0d2c7@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

On 11/10/21 7:16 PM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
>> to retrieved the original registers (R0 - R17) in its SDEI event
>> handler. Those registers can be corrupted during the SDEI event
>> delivery.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 40 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index b022ce0a202b..b4162efda470 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -270,6 +270,44 @@ static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
>>   	return ret;
>>   }
>>   
>> +static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_vcpu_regs *regs;
>> +	unsigned long index = smccc_get_arg1(vcpu);
> s/index/param_id to match the spec?

Sure, but "reg_id" seems better here. As the parameter indicates the GPR index
to be fetched on request of the guest kernel.

>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	/* Sanity check */
>> +	if (!(ksdei && vsdei)) {
>> +		ret = SDEI_NOT_SUPPORTED;
>> +		goto out;
>> +	}
>> +
>> +	if (index > ARRAY_SIZE(vsdei->state.critical_regs.regs)) {
>> +		ret = SDEI_INVALID_PARAMETERS;
>> +		goto out;
>> +	}
> I would move the above after regs = and use regs there (although the
> regs ARRAY_SIZE of both is identifical)

Ok.

>> +
>> +	/* Check if the pending event exists */
>> +	spin_lock(&vsdei->lock);
>> +	if (!(vsdei->critical_event || vsdei->normal_event)) {
>> +		ret = SDEI_DENIED;
>> +		goto unlock;
>> +	}
>> +
>> +	/* Fetch the requested register */
>> +	regs = vsdei->critical_event ? &vsdei->state.critical_regs :
>> +				       &vsdei->state.normal_regs;
>> +	ret = regs->regs[index];
>> +
>> +unlock:
>> +	spin_unlock(&vsdei->lock);
>> +out:
>> +	return ret;
>> +}
>> +
>>   int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 func = smccc_get_function(vcpu);
>> @@ -290,6 +328,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   		ret = kvm_sdei_hypercall_enable(vcpu, false);
>>   		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
>> +		ret = kvm_sdei_hypercall_context(vcpu);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
>>   	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
>>   	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

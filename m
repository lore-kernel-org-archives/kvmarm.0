Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5354CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 12:52:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6DE949F1D;
	Wed, 23 Mar 2022 08:52:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LPuMTM7bvJJL; Wed, 23 Mar 2022 08:52:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8591B49EEE;
	Wed, 23 Mar 2022 08:52:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D58411D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:52:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HfXWAOeCt3AF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 08:52:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC1640719
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:52:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648039945;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kP4WEdqICDi/tswpTgBElOvFLSzQdggSOHSaXzbd4xY=;
 b=VxFy5CWkoCOgKG9C/DRQjL5TQKNV29/Gu2IqHPa7Rw38U7VzKKiFHwqvvmsBwvC9I25EIb
 ZSRVFX+69Vi0sntIWPibgN+DQcTxWabBRb8uhm2N4OkFLQF9nakPV6jGydBmQRoBDl0aiK
 S0V1yCbx8Jhmn3/ehSqAbbto6jot9T8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-X4vk_0kdNPmY1lciXFhZUw-1; Wed, 23 Mar 2022 08:52:24 -0400
X-MC-Unique: X4vk_0kdNPmY1lciXFhZUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9BD21064C8B;
 Wed, 23 Mar 2022 12:52:23 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE046C07F5B;
 Wed, 23 Mar 2022 12:52:18 +0000 (UTC)
Subject: Re: [PATCH v5 15/22] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-16-gshan@redhat.com> <YjpWXGIoaXUVjXQW@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cfd58d73-ada1-8c42-1d3e-794766dd86d5@redhat.com>
Date: Wed, 23 Mar 2022 20:52:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YjpWXGIoaXUVjXQW@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Oliver,

On 3/23/22 7:06 AM, Oliver Upton wrote:
> On Tue, Mar 22, 2022 at 04:07:03PM +0800, Gavin Shan wrote:
>> This supports SDEI_EVENT_SIGNAL hypercall. It's used by the guest
>> to inject SDEI event, whose number must be zero to the specified
>> vCPU. As the routing mode and affinity isn't supported yet, the
>> calling vCPU is assumed to be the target.
>>
>> The SDEI event 0x0 is a private one, with normal priority. It's
>> usually used for testing.
> 
> I don't know if that is actually the case. One real use that immediately
> comes to mind is doing an NMI on a wedged CPU. KVM probably shouldn't
> glean at how the guest may use a particular call, so at most we should
> just point at the spec and state that event 0 is for software signaled
> events.
> 

Yes, I agree. I will amend the change log in next respin, to make it
clear. As you said, it really depend on how the event is used by
the guest. We can't assume its usage.

>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 64 ++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index a24270378305..ba2ca65c871b 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -726,6 +726,66 @@ static int do_inject_event(struct kvm_vcpu *vcpu,
>>   	return 0;
>>   }
>>   
>> +static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_exposed_event *exposed_event;
>> +	struct kvm_sdei_registered_event *registered_event;
>> +	unsigned long event_num = smccc_get_arg1(vcpu);
>> +	int index;
>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	/* @event_num must be zero */
>> +	if (!kvm_sdei_is_default(event_num)) {
> 
> 0 isn't KVM's default event. I'd argue KVM doesn't have a default event
> to begin with. This has a precise definition coming from the spec. In
> fact, 'KVM_SDEI_DEFAULT_EVENT' should probably be eliminated, and any
> missing SDEI definitions should be added to include/uapi/linux/arm_sdei.h.
> 
> That goes for any values coming from the specification. KVM's
> implementation details belong in a KVM header :)
> 

Indeed. include/uapi/linux/arm_sdei.h is the right place to define
the software signaled event number. The function to validate/check
on it is still part of kvm_sdei.h, but its name would be something
like kvm_sdei_is_sw_signaled() or kvm_sdei_is_signaled_event().

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

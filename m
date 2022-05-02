Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89EFC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 03:05:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4504B292;
	Sun,  1 May 2022 23:05:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S+2ru7wEvAXX; Sun,  1 May 2022 23:05:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA7B4B26E;
	Sun,  1 May 2022 23:05:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8A149F3E
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:04:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4FwfJTlpdn7c for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 23:04:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A62BA410FF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:04:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651460697;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LIk0gbsSq+JZ6Ardj/siE8ahXgUcdMEBM+JGnLF1ssc=;
 b=BOYtMelgM+tjfbvoUo5OXdtYrOFE+XEN2ET9aYrNp1CCmZMugk7F2uIJ50CnTXHbGG+5bj
 Q8qn3GOKpHvx+ODFkdOCZBZ7lo8k0yJzZBJ8OELBqnQjmGCsC/J4BnU3Lrfr6Hf1DBdotc
 8H7nWg8LtjgM2TIGsBq2qgZEC9AsAf8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-Hk5HYOmAN22ONjP6yxoWkQ-1; Sun, 01 May 2022 23:04:54 -0400
X-MC-Unique: Hk5HYOmAN22ONjP6yxoWkQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF8D485A5BE;
 Mon,  2 May 2022 03:04:53 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 33DDD550849;
 Mon,  2 May 2022 03:04:46 +0000 (UTC)
Subject: Re: [PATCH v6 14/18] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-15-gshan@redhat.com> <Ym2q2fUwPXNDcMjQ@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d4819173-ad19-94aa-443d-3428f68ad929@redhat.com>
Date: Mon, 2 May 2022 11:04:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym2q2fUwPXNDcMjQ@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

On 5/1/22 5:32 AM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:39:07PM +0800, Gavin Shan wrote:
>> This supports SDEI_EVENT_SIGNAL hypercall. It's used by guest
>> to inject event, whose number must be zero to the specified
>> vCPU. As the shared event isn't supported, calling vCPU is
>> assumed to be the target.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index ebdbe7810cf0..e1f6ab9800ee 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -455,6 +455,48 @@ static unsigned long hypercall_mask(struct kvm_vcpu *vcpu, bool mask)
>>   	return ret;
>>   }
>>   
>> +static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_event *event;
>> +	unsigned int num = smccc_get_arg(vcpu, 1);
>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	/*
>> +	 * The event must be the software signaled one, whose number
>> +	 * is zero.
>> +	 */
>> +	if (!kvm_sdei_is_sw_signaled(num)) {
>> +		ret = SDEI_INVALID_PARAMETERS;
>> +		goto out;
>> +	}
>> +
>> +	spin_lock(&vsdei->lock);
>> +
>> +	/* Check if the vcpu has been masked */
>> +	if (vsdei->masked) {
>> +		ret = SDEI_INVALID_PARAMETERS;
>> +		goto unlock;
>> +	}
> 
> You should still be able to signal an event if the vCPU is masked. Just
> means the bit will rot in the pending bitmap until the vCPU is unmasked.
> 

Nice point! The event pending state is set if vCPU is masked. However,
it's not becoming active until the vCPU is unmasked :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

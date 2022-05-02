Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528F0C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 02:57:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 317964B1DD;
	Sun,  1 May 2022 22:57:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jUjPToybRO7l; Sun,  1 May 2022 22:57:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAB9B4B176;
	Sun,  1 May 2022 22:57:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B324B152
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 22:57:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bh8cQD9fcZ+5 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 22:57:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23DE94B0CB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 22:57:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651460271;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gWY6k1lplnoSScpXUZwqx/l3MDoKL2LgUHMZvlCwKFY=;
 b=iNrmqvbR2irRIGb9rD10ubn047XBW0tuEzF1dKrAYVfUdQ8Y442A04HA/6oqZSXpuNqSrc
 qVw57yazI2v6shfI2t0G3lZkMlMrIess6gQp5U/KvWXLFeKpjbyBaxw0CQtQl+wMS+qFfv
 DH+cTnq9b/WlKnNil1keMZPZ50Eb284=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-UahhAIegNFCQR8mxzE_mFg-1; Sun, 01 May 2022 22:57:48 -0400
X-MC-Unique: UahhAIegNFCQR8mxzE_mFg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46953185A79C;
 Mon,  2 May 2022 02:57:48 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B829AC28103;
 Mon,  2 May 2022 02:57:41 +0000 (UTC)
Subject: Re: [PATCH v6 06/18] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-7-gshan@redhat.com> <Ym1PyIQY4m4/9IVi@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <84e52a58-523d-15bd-d537-81d1bfa29af7@redhat.com>
Date: Mon, 2 May 2022 10:57:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym1PyIQY4m4/9IVi@google.com>
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

On 4/30/22 11:03 PM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:38:59PM +0800, Gavin Shan wrote:
>> This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
>> to retrieve the registers (x0 - x17) from the interrupted or preempted
>> context in the event handler. The interrupted or preempted context
>> is saved prior to handling the event by executing its handler and
>> restored after that.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 34 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index 941263578b30..af5d11b8eb2f 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -140,6 +140,37 @@ static unsigned long hypercall_enable(struct kvm_vcpu *vcpu, bool enable)
>>   	return ret;
>>   }
>>   
>> +static unsigned long hypercall_context(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	struct kvm_sdei_vcpu_context *context;
>> +	unsigned long param_id = smccc_get_arg(vcpu, 1);
>> +	unsigned long ret = SDEI_SUCCESS;
>> +
>> +	spin_lock(&vsdei->lock);
>> +
>> +	/* Check if we have events are being handled */
>> +	context = &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL];
>> +	context = context->event ? context : NULL;
>> +	context = context ? : &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
>> +	context = context->event ? context : NULL;
>> +	if (!context) {
>> +		ret = SDEI_DENIED;
>> +		goto unlock;
>> +	}
> 
> Eek! You'll probably be able to drop all of this and just check the SDEI
> active flag.
>

Yep, the event's active state will be checked instead in next respin :)

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

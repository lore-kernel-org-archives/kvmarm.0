Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3AAC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:25:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B19F14B252;
	Tue, 11 Jan 2022 04:25:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4yEEeCWzO+gO; Tue, 11 Jan 2022 04:25:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4214B256;
	Tue, 11 Jan 2022 04:25:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 308B14B24D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:25:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eyftY8WXVg8S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 04:25:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DD84B226
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:25:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641893125;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NIOLB34hJ7NrgadAdzd+FzQSHzDK7thVWV6D0ErLYoo=;
 b=Pw/Z+1wNLRScO9x3JKlVlNSfQ2w95s2CX2HLpTidSf8BQGszICT2ZaSYp+hRIxPmnw10Xw
 S5ZMu6c5aPXGyW7OcRveuSBiIbAT4aglKZ5QbG6NmBgeI6M+g5ZqcfsQnalmh9QIeniJKT
 5DEn92Y+D0hBIfY2XxyqgWcOKeZHxho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-IiEpoNaMMVSnAgUuqAzCYg-1; Tue, 11 Jan 2022 04:25:21 -0500
X-MC-Unique: IiEpoNaMMVSnAgUuqAzCYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1598C802CA0;
 Tue, 11 Jan 2022 09:25:20 +0000 (UTC)
Received: from [10.72.14.32] (ovpn-14-32.pek2.redhat.com [10.72.14.32])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EED567AB4D;
 Tue, 11 Jan 2022 09:25:16 +0000 (UTC)
Subject: Re: [PATCH v4 03/21] KVM: arm64: Support SDEI_VERSION hypercall
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-4-gshan@redhat.com>
 <3160dd62-1d96-7dcb-e99a-7ac923abc2c7@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <be1955d3-4a67-9219-64fa-3dfd46a9eee0@redhat.com>
Date: Tue, 11 Jan 2022 17:25:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <3160dd62-1d96-7dcb-e99a-7ac923abc2c7@redhat.com>
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

On 11/9/21 11:26 PM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> This supports SDEI_VERSION hypercall by returning v1.0.0 simply
> s/This supports/Add Support. I think this is the prefered way to start
> the commit msg. Here and elsewhere.

Ok.

>> when the functionality is supported on the VM and vCPU.
> Can you explain when the functionality isn't supported on either. From
> the infra patch I have the impression that an allocation failure is the
> sole cause of lack of support?

Yes, it's the only reason that SDEI isn't supported. I will
mention this in the commit log in next respin.

>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index ab330b74a965..aa9485f076a9 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -70,6 +70,22 @@ static void kvm_sdei_remove_vcpu_events(struct kvm_vcpu *vcpu)
>>   	}
>>   }
>>   
>> +static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
>> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
>> +	unsigned long ret = SDEI_NOT_SUPPORTED;
> nit: I would remove ret local variable

Ok.

>> +
>> +	if (!(ksdei && vsdei))
>> +		return ret;
>> +
>> +	/* v1.0.0 */
>> +	ret = (1UL << SDEI_VERSION_MAJOR_SHIFT);
>> +
>> +	return ret;
>> +}
>> +
>>   int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 func = smccc_get_function(vcpu);
>> @@ -78,6 +94,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>>   
>>   	switch (func) {
>>   	case SDEI_1_0_FN_SDEI_VERSION:
>> +		ret = kvm_sdei_hypercall_version(vcpu);
>> +		break;
>>   	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
>>   	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
>>   	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

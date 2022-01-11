Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C2DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 07:53:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D85CE4B205;
	Tue, 11 Jan 2022 02:53:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1amFyRK43qV; Tue, 11 Jan 2022 02:53:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8354C4B119;
	Tue, 11 Jan 2022 02:53:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D844B119
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 02:53:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4UNCwiR+L92v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 02:53:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 210BD49EF9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 02:53:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641887579;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=s3Y1O09JG5ePpg5LAktUzWgPzg+txuTZh+F8MesPjNg=;
 b=QW1ND9jf2dTnuMhOjyaOzf+yJQs9nWQ7h/rbgy/nM1NeDK4sZTL3c/UQw8943ftrKgzIPL
 1PQ/NjqUR6bQFS7TaC638JYPMNbQtWPb/RYe/GyAwxD2hYDQTPSDN5wg0FYJiBLIzQgqYs
 jIaE6s+5+wNdMN23vi99mcAz7NCZJYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-KZHLwfp_MiyHbBdYkyg6hQ-1; Tue, 11 Jan 2022 02:52:54 -0500
X-MC-Unique: KZHLwfp_MiyHbBdYkyg6hQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3F2A85EE62;
 Tue, 11 Jan 2022 07:52:52 +0000 (UTC)
Received: from [10.72.14.32] (ovpn-14-32.pek2.redhat.com [10.72.14.32])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95E207B9E2;
 Tue, 11 Jan 2022 07:52:48 +0000 (UTC)
Subject: Re: [PATCH v4 01/21] KVM: arm64: Introduce template for inline
 functions
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-2-gshan@redhat.com>
 <5112b3ba-d038-f622-c67f-e53695cbef37@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8b7d3a75-dbf8-c8b9-bbb6-bd89d9429802@redhat.com>
Date: Tue, 11 Jan 2022 15:52:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5112b3ba-d038-f622-c67f-e53695cbef37@redhat.com>
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

On 11/9/21 11:26 PM, Eric Auger wrote:
> On 8/15/21 2:13 AM, Gavin Shan wrote:
>> The inline functions used to get the SMCCC parameters have same
>> layout. It means these functions can be presented by a template,
>> to make the code simplified. Besides, this adds more similar inline
>> functions like smccc_get_arg{4,5,6,7,8}() to visit more SMCCC arguments,
>> which are needed by SDEI virtualization support.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   include/kvm/arm_hypercalls.h | 34 +++++++++++++++-------------------
>>   1 file changed, 15 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
>> index 0e2509d27910..ebecb6c68254 100644
>> --- a/include/kvm/arm_hypercalls.h
>> +++ b/include/kvm/arm_hypercalls.h
>> @@ -6,27 +6,21 @@
>>   
>>   #include <asm/kvm_emulate.h>
>>   
>> -int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>> -
>> -static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
>> -{
>> -	return vcpu_get_reg(vcpu, 0);
>> +#define SMCCC_DECLARE_GET_FUNC(type, name, reg)			\
>> +static inline type smccc_get_##name(struct kvm_vcpu *vcpu)	\
>> +{								\
>> +	return vcpu_get_reg(vcpu, reg);				\
>>   }
>>   
>> -static inline unsigned long smccc_get_arg1(struct kvm_vcpu *vcpu)
>> -{
>> -	return vcpu_get_reg(vcpu, 1);
>> -}
>> -
>> -static inline unsigned long smccc_get_arg2(struct kvm_vcpu *vcpu)
>> -{
>> -	return vcpu_get_reg(vcpu, 2);
>> -}
>> -
>> -static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
>> -{
>> -	return vcpu_get_reg(vcpu, 3);
>> -}
>> +SMCCC_DECLARE_GET_FUNC(u32,           function, 0)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg1,     1)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg2,     2)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg3,     3)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg4,     4)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg5,     5)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg6,     6)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg7,     7)
>> +SMCCC_DECLARE_GET_FUNC(unsigned long, arg8,     8)
> I think I would keep smccc_get_function() and add macros to get the
> 64-bit args. SMCCC_DECLARE_GET_FUNC is an odd macro name for a function
> fetching an arg. I would suggest:
> 

I agree. The code will be changed accordingly in next respin.

>> +#define SMCCC_DECLARE_GET_ARG(reg)			\
>> +static inline unsigned long smccc_get_arg##reg(struct kvm_vcpu *vcpu)	\
>> +{								\
>> +	return vcpu_get_reg(vcpu, reg);				\
>>   }
>>   
>>   static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>>   				    unsigned long a0,
>> @@ -40,4 +34,6 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>>   	vcpu_set_reg(vcpu, 3, a3);
>>   }
>>   
>> +int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>> +
> spurious change?

I thought the inline function would come before the exposed ones. However,
I don't think it's necessary. I will drop the changes in next respin.

>>   #endif
>>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

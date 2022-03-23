Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D044BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 12:16:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4499B40F9C;
	Wed, 23 Mar 2022 08:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r2pk-lC4l5cw; Wed, 23 Mar 2022 08:16:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B8C49EE6;
	Wed, 23 Mar 2022 08:16:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1A749EE2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:16:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AL8-XAguxbPc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 08:16:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF2940F9C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:16:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648037786;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cKZQyQfM1SrU7UHeHhmB05DBFXftBCZkFW+SMB5Y0vI=;
 b=hnzxjRUr/4yJPSxx0sxfZVfClm3UB7yG7dSOFmvT8uv6b+XeQqlh6J6BUKqDFQ4N0EP55s
 AjJe7MFOVAD556NI7MwhG9hw66N7sbSZOlj9QIPui2NFUMFO5QVrhPwqPC+rZEQk9FN/K5
 2Ix9LCLuyyzPpg1m0ZNR/QlQWeyJ+QM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-8NecRMKoPI-0zLlKbyh3Sg-1; Wed, 23 Mar 2022 08:16:23 -0400
X-MC-Unique: 8NecRMKoPI-0zLlKbyh3Sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C520185A79C;
 Wed, 23 Mar 2022 12:16:22 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C88E7202699A;
 Wed, 23 Mar 2022 12:16:13 +0000 (UTC)
Subject: Re: [PATCH v5 01/22] KVM: arm64: Introduce template for inline
 functions
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-2-gshan@redhat.com> <YjomvjFNjGADmu6l@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <7a7f2325-c9fc-7e8f-c10d-11de3ddc1a59@redhat.com>
Date: Wed, 23 Mar 2022 20:16:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YjomvjFNjGADmu6l@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On 3/23/22 3:42 AM, Oliver Upton wrote:
> On Tue, Mar 22, 2022 at 04:06:49PM +0800, Gavin Shan wrote:
>> The inline functions used to get the SMCCC parameters have same
>> layout. It means these functions can be presented by an unified
>> template, to make the code simplified. Besides, this adds more
>> similar inline functions like smccc_get_arg{4,5,6,7,8}() to get
>> more SMCCC arguments, which are needed by SDEI virtualization
>> support.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   include/kvm/arm_hypercalls.h | 24 ++++++++++++------------
>>   1 file changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
>> index 0e2509d27910..d5144c852fe4 100644
>> --- a/include/kvm/arm_hypercalls.h
>> +++ b/include/kvm/arm_hypercalls.h
>> @@ -13,20 +13,20 @@ static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
>>   	return vcpu_get_reg(vcpu, 0);
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
>> +#define SMCCC_DECLARE_GET_ARG(reg)					\
>> +static inline unsigned long smccc_get_arg##reg(struct kvm_vcpu *vcpu)	\
>> +{									\
>> +	return vcpu_get_reg(vcpu, reg);					\
>>   }
>>   
>> -static inline unsigned long smccc_get_arg3(struct kvm_vcpu *vcpu)
>> -{
>> -	return vcpu_get_reg(vcpu, 3);
>> -}
>> +SMCCC_DECLARE_GET_ARG(1)
>> +SMCCC_DECLARE_GET_ARG(2)
>> +SMCCC_DECLARE_GET_ARG(3)
>> +SMCCC_DECLARE_GET_ARG(4)
>> +SMCCC_DECLARE_GET_ARG(5)
>> +SMCCC_DECLARE_GET_ARG(6)
>> +SMCCC_DECLARE_GET_ARG(7)
>> +SMCCC_DECLARE_GET_ARG(8)
> 
> Hmm. What if we specify a single inline function where the caller passes
> the arg # as a parameter? We really just want to abstract away the
> off-by-one difference between GP registers and SMCCC arguments.
> 
> Macros generally make me uneasy for template functions, but I may be in
> the vocal minority on this topic :)
> 

I think it's a good idea to have smccc_get_arg(unsigned char index).
However, it will cause more code changes because the following functions
have been used. Anyway, I think it's still worthy to pass @index to
differentiate the argument index. I will change it accordingly in
next respin.

    smccc_get_arg1()
    smccc_get_arg2()
    smccc_get_arg3()

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

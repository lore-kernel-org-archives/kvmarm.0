Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77058C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 12:46:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFCBF49EFC;
	Wed, 23 Mar 2022 08:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SK1asWrY4JB7; Wed, 23 Mar 2022 08:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5EE949F00;
	Wed, 23 Mar 2022 08:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AEB49EF6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3uULRWpMi8m8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 08:46:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AE0B49EF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 08:46:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648039611;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DTnFtVcodyoIwIXV9QxS/vo7a2K9rOATfHER2lAcBYs=;
 b=D5udak05osjVDH0IED2H5KlgJOUVIUbQkmRl7cKZGMMj2dNvJlcj6PIenAZun/gHqmQ2UN
 WNzXXQPwPEXLJW9XX6gmfTl5DbTVRV6fs5iMAJbvkGprMynRvW5m7bqqd9LvyAu9ALyCbd
 cCPMw4zf+TpTwzpUhiOHGiyebh1ytPY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-gHMvhEejPxqhMi7HhzDauQ-1; Wed, 23 Mar 2022 08:46:48 -0400
X-MC-Unique: gHMvhEejPxqhMi7HhzDauQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0BD23810D56;
 Wed, 23 Mar 2022 12:46:47 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F2C401E78;
 Wed, 23 Mar 2022 12:46:43 +0000 (UTC)
Subject: Re: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
To: Oliver Upton <oupton@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-4-gshan@redhat.com> <YjoPxLAMIPobBzS0@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d8e151e5-080b-dc87-b7e0-9031a7928853@redhat.com>
Date: Wed, 23 Mar 2022 20:46:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YjoPxLAMIPobBzS0@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

On 3/23/22 2:04 AM, Oliver Upton wrote:
> On Tue, Mar 22, 2022 at 04:06:51PM +0800, Gavin Shan wrote:
>> This supports SDEI_VERSION hypercall by returning v1.1, which is
>> the specification version we're following. The vendor is set to
>> 'KVM'.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index 8a9b477b8977..5a3a64cd6e84 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -118,6 +118,14 @@ static bool remove_all_vcpu_events(struct kvm_vcpu *vcpu,
>>   	return pending;
>>   }
>>   
>> +static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
>> +{
>> +	/* v1.1 and the vendor is KVM */
>> +	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
>> +	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
>> +	       0x4b564d;
> 
> It looks like the SDEI specification states that the vendor-defined
> version number is 32 bits. Could we just use one of the
> ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_{0,3} values instead?
> 
> ASCII 'KVM' is neat, but in reality guest software will just throw it in
> a macro regardless. Might as well use one of the values we've already
> trained it to use :-)
> 
> Also, it would appear that guest discovery of SDEI relies upon KVM
> reporting a valid SDEI version. IMO, this patch should come at the very
> end when KVM actually implements SDEI.
> 

Yeah, I was sticky to the pattern of "KVM". However, I think it's good
to reuse the existing one. Lets use ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
if you agree. Its first two characters are "VM" at least.

It's fine to return the version here because the SDEI capability isn't
exposed yet. It means no events have been exposed and able to be
registered. However, It's also fine to move this patch after the
following one:

[PATCH v5 16/22] KVM: arm64: Support SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

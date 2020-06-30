Return-Path: <SRS0=T474=AL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BE6C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 00:29:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3081520781
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 00:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mqx1Gtt4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3081520781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B44434B5A1;
	Mon, 29 Jun 2020 20:29:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3OampaZKlF6D; Mon, 29 Jun 2020 20:29:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E03094B59A;
	Mon, 29 Jun 2020 20:29:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FA84B59A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 20:29:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gCJ3MUwNo2cX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 20:29:00 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A22BF4B597
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 20:29:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593476940;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3VcCQaFkPkFZgupcYppvcG/Su8VB4lAyM/EvwaXMMHw=;
 b=Mqx1Gtt4+Z8rI9pjQvAmGDQGzH+bz1r8PNC9Z0EgU4i2SSOs2XFuwrPmq3CIuC2ftO6w5f
 Oazg4VQLjOQ9j3VOY4i+3wnprayge1M6C093cmIwbu9NKvsGLtl3NtBHmGBaVvE+HxSbvS
 Dz25dx2r1Zbn+6zefEk9TYOwljZvZxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-EhX3MnIhOh-_rgtPZnC2rw-1; Mon, 29 Jun 2020 20:28:56 -0400
X-MC-Unique: EhX3MnIhOh-_rgtPZnC2rw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69DDA1800D42;
 Tue, 30 Jun 2020 00:28:55 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-102.bne.redhat.com
 [10.64.54.102])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AECA5C1D4;
 Tue, 30 Jun 2020 00:28:53 +0000 (UTC)
Subject: Re: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
To: Andrew Scull <ascull@google.com>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-3-gshan@redhat.com>
 <20200629095907.GB3282863@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <0b61dd97-d1c2-e878-af60-e2e09dbae8c6@redhat.com>
Date: Tue, 30 Jun 2020 10:28:50 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200629095907.GB3282863@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Andrew,

On 6/29/20 7:59 PM, Andrew Scull wrote:
> On Mon, Jun 29, 2020 at 07:18:41PM +1000, Gavin Shan wrote:
>> There are a set of inline functions defined in kvm_emulate.h. Those
>> functions reads ESR from vCPU fault information struct and then operate
>> on it. So it's tied with vCPU fault information and vCPU struct. It
>> limits their usage scope.
>>
>> This detaches these functions from the vCPU struct by introducing an
>> other set of inline functions in esr.h to manupulate the specified
>> ESR value. With it, the inline functions defined in kvm_emulate.h
>> can call these inline functions (in esr.h) instead. This shouldn't
>> cause any functional changes.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/esr.h         | 32 +++++++++++++++++++++
>>   arch/arm64/include/asm/kvm_emulate.h | 43 ++++++++++++----------------
>>   2 files changed, 51 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index 035003acfa87..950204c5fbe1 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -326,6 +326,38 @@ static inline bool esr_is_data_abort(u32 esr)
>>   	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
>>   }
>>   
>> +#define ESR_DECLARE_CHECK_FUNC(name, field)	\
>> +static inline bool esr_is_##name(u32 esr)	\
>> +{						\
>> +	return !!(esr & (field));		\
>> +}
>> +#define ESR_DECLARE_GET_FUNC(name, mask, shift)	\
>> +static inline u32 esr_get_##name(u32 esr)	\
>> +{						\
>> +	return ((esr & (mask)) >> (shift));	\
>> +}
> 
> Should these be named DEFINE rather than DECLARE given it also includes
> the function definition?
> 

Thanks for your comments. Indeed, I think DEFINE is better than
DECLARE. These newly introduced helpers are unlikely needed basing
on the comments (and followup) from Mark Rutland.

>> +
>> +ESR_DECLARE_CHECK_FUNC(il_32bit,   ESR_ELx_IL);
>> +ESR_DECLARE_CHECK_FUNC(condition,  ESR_ELx_CV);
>> +ESR_DECLARE_CHECK_FUNC(dabt_valid, ESR_ELx_ISV);
>> +ESR_DECLARE_CHECK_FUNC(dabt_sse,   ESR_ELx_SSE);
>> +ESR_DECLARE_CHECK_FUNC(dabt_sf,    ESR_ELx_SF);
>> +ESR_DECLARE_CHECK_FUNC(dabt_s1ptw, ESR_ELx_S1PTW);
>> +ESR_DECLARE_CHECK_FUNC(dabt_write, ESR_ELx_WNR);
>> +ESR_DECLARE_CHECK_FUNC(dabt_cm,    ESR_ELx_CM);
>> +
>> +ESR_DECLARE_GET_FUNC(class,        ESR_ELx_EC_MASK,      ESR_ELx_EC_SHIFT);
>> +ESR_DECLARE_GET_FUNC(fault,        ESR_ELx_FSC,          0);
>> +ESR_DECLARE_GET_FUNC(fault_type,   ESR_ELx_FSC_TYPE,     0);
>> +ESR_DECLARE_GET_FUNC(condition,    ESR_ELx_COND_MASK,    ESR_ELx_COND_SHIFT);
>> +ESR_DECLARE_GET_FUNC(hvc_imm,      ESR_ELx_xVC_IMM_MASK, 0);
>> +ESR_DECLARE_GET_FUNC(dabt_iss_nisv_sanitized,
>> +		     (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC), 0);
>> +ESR_DECLARE_GET_FUNC(dabt_rd,      ESR_ELx_SRT_MASK,     ESR_ELx_SRT_SHIFT);
>> +ESR_DECLARE_GET_FUNC(dabt_as,      ESR_ELx_SAS,          ESR_ELx_SAS_SHIFT);
>> +ESR_DECLARE_GET_FUNC(sys_rt,       ESR_ELx_SYS64_ISS_RT_MASK,
>> +				   ESR_ELx_SYS64_ISS_RT_SHIFT);
>> +
>>   const char *esr_get_class_string(u32 esr);
>>   #endif /* __ASSEMBLY */
>>   
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index c9ba0df47f7d..9337d90c517f 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -266,12 +266,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>>   
>>   static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>>   {
>> -	u32 esr = kvm_vcpu_get_esr(vcpu);
>> -
>> -	if (esr & ESR_ELx_CV)
>> -		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
>> -
>> -	return -1;
>> +	return esr_is_condition(kvm_vcpu_get_esr(vcpu)) ?
>> +	       esr_get_condition(kvm_vcpu_get_esr(vcpu)) : -1;
>>   }
>>   
>>   static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
>> @@ -291,79 +287,79 @@ static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
>>   
>>   static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
>>   {
>> -	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
>> +	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
>>   }
> 
> It feels a little strange that in the raw esr case it uses macro magic
> but in the vcpu cases here it writes everything out in full. Was there a
> reason that I'm missing or is there a chance to apply a consistent
> approach?
> 

The request was raised when RFCv2 async page fault patchset was posted.
When async page fault is handled, the ESR is cached in advance, not
fetched from vCPU struct. So we want to detach the helpers defined in
kvm_emulate.h from vCPU struct. Hope the discussion in the following
link can help you to understand a bit more:

https://lore.kernel.org/kvmarm/20200508032919.52147-5-gshan@redhat.com/

> I'm not sure of the style preferences, but if it goes the macro path,
> the esr field definitions could be reused with something x-macro like to
> get the kvm_emulate.h and esr.h functions generated from a singe list of
> the esr fields.
> 

Yeah, it's same thing as Mark Rutland suggested. As I replied to his
comments, it can be postponed when next revision of async page fault
patchset is posted.

[...]

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=T474=AL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC87C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 00:16:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C31BE20780
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 00:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uhlyhabl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C31BE20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 270514B570;
	Mon, 29 Jun 2020 20:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P3Bn5ywZmp+U; Mon, 29 Jun 2020 20:16:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C00234B574;
	Mon, 29 Jun 2020 20:16:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EFAC4B570
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 20:16:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hI5Mrc-S55dZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 20:16:19 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F11C94B55D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 20:16:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593476177;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5VINUc1zw/rPkFcqE51OgyFJrBsajiVB+eNeeFTjokc=;
 b=Uhlyhabl3q9EdTfgLBwhHW7cbQUArzeZCKLvf9e9rvt3+m3ZBVQHHx0Vhwbw4JfProBh6k
 xamjaumQCrMCUYx8ugFwzopGTk56fhJFTHpvZ/c8LzR8b58SfnwYCN4NWiAqRHGSs9pEiw
 Fl6w52fsB2fo/fhuqvxDBwpUu3l7dmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-J7YhkiBzPN2ee3iK7tVybQ-1; Mon, 29 Jun 2020 20:16:14 -0400
X-MC-Unique: J7YhkiBzPN2ee3iK7tVybQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 712A2805EEE;
 Tue, 30 Jun 2020 00:16:12 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-102.bne.redhat.com
 [10.64.54.102])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DAE010013C1;
 Tue, 30 Jun 2020 00:16:10 +0000 (UTC)
Subject: Re: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
To: Mark Rutland <mark.rutland@arm.com>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-3-gshan@redhat.com>
 <20200629110016.GB59769@C02TD0UTHF1T.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <1947c322-4fd0-5161-eab8-3504235408c1@redhat.com>
Date: Tue, 30 Jun 2020 10:16:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200629110016.GB59769@C02TD0UTHF1T.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Hi Mark,

On 6/29/20 9:00 PM, Mark Rutland wrote:
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
> 
> TBH, I'm not sure that this patch makes much sense on its own.
> 
> We already use vcpu_get_esr(), which is the bit that'd have to change if
> we didn't pass the vcpu around, and the new helpers are just consuming
> the value in a sifferent way rather than a necessarily simpler way.
> 
> Further comments on that front below.
> 
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
> 
> I'm really not keen on this, as I think it's abstracting the problem at
> the wrong level, hiding information and making things harder to reason
> about rather than abstracting that.
> 
> I strongly suspect the right thing to do is use FIELD_GET() in-place in
> the functions below, e.g.
> 
>     !!FIELD_GET(esr, ESR_ELx_IL);
> 
> ... rather than:
> 
>     esr_get_il_32bit(esr);
> 
> ... as that avoids the wrapper entirely, minimizing indirection and
> making the codebase simpler to navigate.
> 
> For the cases where we *really* want a helper, i'd rather write those
> out explicitly, e.g.
> 

It will be no difference except to use FIELD_GET() to make the code
more explicit. Maybe I didn't fully understand your comments here.
Please let me know if something like below is what you expect?

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9ba0df47f7d..e8294edcd8f4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -343,7 +343,7 @@ static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *
  /* This one is not specific to Data Abort */
  static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
  {
-       return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
+       return !!FIELD_GET(kvm_vcpu_get_esr(vcpu), ESR_ELx_IL);
  }

If my understanding is correct, I think we needn't change the code
and this patch can be dropped.

> #define esr_get_hvc_imm(esr)	FIELD_GET(esr, ESR_ELx_xVC_IMM_MASK)
> 
> ... but I'm not sure if we really need those given these are mostly used
> *once* below.
> 

We don't need these for now, but will be needed when the next revision
of async page fault is posted. Lets ignore this requirement for now
because I can revisit it when the async page fault patchset is posted.
That time, we can have accessors defined in esr.h and helpers in
kvm_emulate.h use those accessors. It's similar to what you're suggesting.

#define esr_get_hvc_imm(esr)	FIELD_GET(esr, ESR_ELx_xVC_IMM_MASK)

static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
{
	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
}


By the way, it's long way to reach that point because I'm still in the
middle of working on virtualizing SDEI currently.

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
> 
> Do we really need to change the structure of this code? I thought this
> was purely about decooupling helpers from the vcpu struct. This could
> have stayed as:
> 
> static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> {
> 	u32 esr = kvm_vcpu_get_esr(vcpu);
> 
> 	if (esr_is_condition(esr))
> 		return esr_get_condition(esr);
> 	
> 	return -1;
> }
> 
> ... or:
> 
> static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> {
> 	u32 esr = kvm_vcpu_get_esr(vcpu);
> 
> 	if (FEILD_GET(esr, ESR_ELx_CV))
> 		return FIELD_GET(esr, ESR_ELx_COND_MASK);
> 	
> 	return -1;
> }
> 

It's not needed to change the structure of the code, but it does
reduce the lines of codes. It's kind of my personal taste :)

[...]

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

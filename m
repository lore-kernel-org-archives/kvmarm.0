Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E55C54FCB
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 13:59:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4D1A2098B
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 13:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mft597zj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4D1A2098B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DD04B173;
	Wed, 22 Apr 2020 09:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 43pdSkb14NW7; Wed, 22 Apr 2020 09:59:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0974B176;
	Wed, 22 Apr 2020 09:59:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA474B173
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 09:59:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RjIxcxrcVx52 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 09:59:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 476864B142
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 09:59:49 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 280B22077D;
 Wed, 22 Apr 2020 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587563988;
 bh=OKor0O1lAwDsiHEhIHm+ZWkyVKAQBwA4AAHrzX1Q+v4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Mft597zjrjfiYPCTD7S4lA3sg14fCZ2v2U47Z6Du5U5NKrMl5NA1BpiDTbr2xAimj
 47DVnc9Fv7lo3ZnBI6UJOPGcZpV//wtWy4jdl3wOzpAv81yu35tKsTyUMnnhnGbfhl
 h4An5H97MXOwUnn3qKU24hiU2sZED7EywJKFlAAc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRFuk-005WlJ-HE; Wed, 22 Apr 2020 14:59:46 +0100
MIME-Version: 1.0
Date: Wed, 22 Apr 2020 14:59:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 02/26] KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
In-Reply-To: <7bfefbb0-a467-3e43-6e22-466ae7184a1f@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-3-maz@kernel.org>
 <7bfefbb0-a467-3e43-6e22-466ae7184a1f@arm.com>
Message-ID: <df8c5f459f449c5e1180dcb2a48d11b0@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, dave.martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, gcherian@marvell.com, prime.zeng@hisilicon.com,
 catalin.marinas@arm.com, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

Hi Suzuki,

On 2020-04-22 14:51, Suzuki K Poulose wrote:
> Hi Marc,
> 
> 
> On 04/22/2020 01:00 PM, Marc Zyngier wrote:
>> Having __load_guest_stage2 in kvm_hyp.h is quickly going to trigger
>> a circular include problem. In order to avoid this, let's move
>> it to kvm_mmu.h, where it will be a better fit anyway.
>> 
>> In the process, drop the __hyp_text annotation, which doesn't help
>> as the function is marked as __always_inline.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
>> ---
>>   arch/arm64/include/asm/kvm_hyp.h | 18 ------------------
>>   arch/arm64/include/asm/kvm_mmu.h | 17 +++++++++++++++++
>>   2 files changed, 17 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h 
>> b/arch/arm64/include/asm/kvm_hyp.h
>> index fe57f60f06a89..dcb63bf941057 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -10,7 +10,6 @@
>>   #include <linux/compiler.h>
>>   #include <linux/kvm_host.h>
>>   #include <asm/alternative.h>
>> -#include <asm/kvm_mmu.h>
>>   #include <asm/sysreg.h>
>>     #define __hyp_text __section(.hyp.text) notrace
>> @@ -88,22 +87,5 @@ void deactivate_traps_vhe_put(void);
>>   u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context 
>> *host_ctxt);
>>   void __noreturn __hyp_do_panic(unsigned long, ...);
>>   -/*
>> - * Must be called from hyp code running at EL2 with an updated VTTBR
>> - * and interrupts disabled.
>> - */
>> -static __always_inline void __hyp_text __load_guest_stage2(struct kvm 
>> *kvm)
>> -{
>> -	write_sysreg(kvm->arch.vtcr, vtcr_el2);
>> -	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
>> -
>> -	/*
>> -	 * ARM errata 1165522 and 1530923 require the actual execution of 
>> the
>> -	 * above before we can switch to the EL1/EL0 translation regime used 
>> by
>> -	 * the guest.
>> -	 */
>> -	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
>> -}
>> -
>>   #endif /* __ARM64_KVM_HYP_H__ */
>>   diff --git a/arch/arm64/include/asm/kvm_mmu.h 
>> b/arch/arm64/include/asm/kvm_mmu.h
>> index 30b0e8d6b8953..5ba1310639ec6 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -604,5 +604,22 @@ static __always_inline u64 kvm_get_vttbr(struct 
>> kvm *kvm)
>>   	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
>>   }
>>   +/*
>> + * Must be called from hyp code running at EL2 with an updated VTTBR
>> + * and interrupts disabled.
>> + */
>> +static __always_inline void __load_guest_stage2(struct kvm *kvm)
>> +{
>> +	write_sysreg(kvm->arch.vtcr, vtcr_el2);
>> +	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
>> +
>> +	/*
>> +	 * ARM erratum 1165522 requires the actual execution of the above
> 
> Is it intentional to drop the reference to errata 1530923 ?

No, that's obviously the effect of a bad conflict resolution during a 
rebase.
I'll fix it now, thanks for spotting it.

> Otherwise :
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5394C282CE
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 04:31:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B85620880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 04:31:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B85620880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B529B4A44D;
	Mon,  8 Apr 2019 00:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EJPynjaEtnDA; Mon,  8 Apr 2019 00:31:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 489F84A47B;
	Mon,  8 Apr 2019 00:31:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABEAC4A479
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 00:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPXZMVDl8Pxl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 00:31:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A85F4A44D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 00:31:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D55E15AD;
 Sun,  7 Apr 2019 21:31:32 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EE0C3F718;
 Sun,  7 Apr 2019 21:31:29 -0700 (PDT)
Subject: Re: [PATCH v8 4/9] KVM: arm/arm64: preserve host HCR_EL2 value
To: Dave Martin <Dave.Martin@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
 <20190405110229.GR3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <8066f634-b2e0-33c3-a6f4-4f38729b3f86@arm.com>
Date: Mon, 8 Apr 2019 10:01:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190405110229.GR3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408043126.i8WauDQZ8JCUjTu3hOhbMqeIoF-oJ4agQoqs3yrZmiY@z>

Hi,

On 4/5/19 4:32 PM, Dave Martin wrote:
> On Tue, Apr 02, 2019 at 07:57:12AM +0530, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>> is a constant value. This works today, as the host HCR_EL2 value is
>> always the same, but this will get in the way of supporting extensions
>> that require HCR_EL2 bits to be set conditionally for the host.
>>
>> To allow such features to work without KVM having to explicitly handle
>> every possible host feature combination, this patch has KVM save/restore
>> for the host HCR when switching to/from a guest HCR. The saving of the
>> register is done once during cpu hypervisor initialization state and is
>> just restored after switch from guest.
>>
>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>> kvm_call_hyp and is helpful in non-VHE case.
>>
>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>> to toggle the TGE bit with a RMW sequence, as we already do in
>> __tlb_switch_to_guest_vhe().
>>
>> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
>> and guest can now use this field in a common way.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> [Added cpu_init_host_ctxt, hcr_el2 field in struct kvm_cpu_context,
>> save hcr_el2 in hyp init stage]
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
> 
> [...]
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index a01fe087..3b09fd0 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -209,6 +209,8 @@ struct kvm_cpu_context {
>>   		u32 copro[NR_COPRO_REGS];
>>   	};
>>   
>> +	/* HYP host/guest configuration */
>> +	u64 hcr_el2;
> 
> Minor nit: You could delete "host/guest" from the comment here.  This is
> implied by the fact that the member is in struct kvm_cpu_context in the
> first place.
ok. Agree with you.
> 
>>   	struct kvm_vcpu *__hyp_running_vcpu;
>>   };
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 3563fe6..f5cefa1 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
> 
> [...]
> 
>> @@ -159,9 +159,10 @@ static void deactivate_traps_vhe(void)
>>   }
>>   NOKPROBE_SYMBOL(deactivate_traps_vhe);
>>   
>> -static void __hyp_text __deactivate_traps_nvhe(void)
>> +static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
> 
> Where __hyp_text functions accept pointer arguments, they are usually
> hyp pointers already...  (see below)
> 
>>   {
>>   	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>> +	struct kvm_cpu_context *hyp_host_ctxt = kern_hyp_va(host_ctxt);
>>   
>>   	__deactivate_traps_common();
>>   
>> @@ -169,25 +170,28 @@ static void __hyp_text __deactivate_traps_nvhe(void)
>>   	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
>>   
>>   	write_sysreg(mdcr_el2, mdcr_el2);
>> -	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
>> +	write_sysreg(hyp_host_ctxt->hcr_el2, hcr_el2);
>>   	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
>>   }
>>   
>>   static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>>   {
>> +	struct kvm_cpu_context *host_ctxt;
>> +
>> +	host_ctxt = vcpu->arch.host_cpu_context;
> 
> host_ctxt is not otherwise used here, so can we convert it up-front so
> that the argument to __deactivate_traps_nvhe() and
> deactivate_traps_vhe() is a hyp pointer already?
> 
> So:
> 
> 	struct kvm_cpu_context *hyp_host_ctxt;
> 
> 	hyp_host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> 
>>   	/*
>>   	 * If we pended a virtual abort, preserve it until it gets
>>   	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
>>   	 * the crucial bit is "On taking a vSError interrupt,
>>   	 * HCR_EL2.VSE is cleared to 0."
>>   	 */
>> -	if (vcpu->arch.hcr_el2 & HCR_VSE)
>> -		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
>> +	if (vcpu->arch.ctxt.hcr_el2 & HCR_VSE)
>> +		vcpu->arch.ctxt.hcr_el2 = read_sysreg(hcr_el2);
>>   
>>   	if (has_vhe())
>> -		deactivate_traps_vhe();
>> +		deactivate_traps_vhe(host_ctxt);
>>   	else
>> -		__deactivate_traps_nvhe();
>> +		__deactivate_traps_nvhe(host_ctxt);
> 
> Then just pass hyp_host_ctxt to both of these, and drop the
> kern_hyp_va() conversion from __deactivate_traps_nvhe().
> 
> This may be a bit less confusing.
Yes your explanation makes sense.
> 
> Alternatively, just pass in the vcpu pointer (since this pattern is
> already well established all over the place).
I think passing vcpu as parameter will make it consistent with other 
existing functions. __kvm_vcpu_run_nvhe function also takes vcpu and 
extracts hyp_host_ctxt.
> 
> Another option could be to pull the hcr_el2 write out of the backends
> entirely and put it in this common code instead.  This doesn't look
> straightforward though (or at least, I don't remember enough about how
> all these traps handling functions fit together...)
ok.

Thanks,
Amit D
> 
> [...]
> 
> Cheers
> ---Dave
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

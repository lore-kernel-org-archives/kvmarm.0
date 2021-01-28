Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC14C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 09:07:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23A7D64DD6
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 09:07:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23A7D64DD6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDA94B199;
	Thu, 28 Jan 2021 04:07:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gir6X+E3PIKI; Thu, 28 Jan 2021 04:07:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8554B19B;
	Thu, 28 Jan 2021 04:07:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3AE04B18F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 04:07:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LNkidkJYAqq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 04:07:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E7C94B18B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 04:07:14 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5E35664DD1;
 Thu, 28 Jan 2021 09:07:13 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l53Gh-00AZZn-4I; Thu, 28 Jan 2021 09:07:11 +0000
MIME-Version: 1.0
Date: Thu, 28 Jan 2021 09:07:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
In-Reply-To: <VE1PR08MB47665F987B86F85454434377F4BA9@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <73b606d9c49e05435113a40a534af133@kernel.org>
 <VE1PR08MB47665F987B86F85454434377F4BA9@VE1PR08MB4766.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <f11a46325548ad5b93e24f4cfdb22d65@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, James.Morse@arm.com, will@kernel.org,
 Suzuki.Poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Steve.Capper@arm.com, Justin.He@arm.com,
 nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Justin He <Justin.He@arm.com>, nd <nd@arm.com>, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-28 03:01, Jianyong Wu wrote:
> Hi Marc,
> 
>> 
>>  From 8f2a919d6f13d36445974794c76821fbb6b40f88 Mon Sep 17 00:00:00
>> 2001
>>  From: Marc Zyngier <maz@kernel.org>
>> Date: Sat, 16 Jan 2021 10:53:21 +0000
>> Subject: [PATCH] CMO on RO memslot
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/kvm/mmu.c | 51 +++++++++++++++++++++++++++++++++----
>> -------
>>   1 file changed, 39 insertions(+), 12 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
>> 7d2257cc5438..3c176b5b0a28 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -760,7 +760,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
>> phys_addr_t fault_ipa,
>>   	struct kvm_pgtable *pgt;
>> 
>>   	fault_granule = 1UL <<
>> ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>> -	write_fault = kvm_is_write_fault(vcpu);
>> +	/*
>> +	 * Treat translation faults on CMOs as read faults. Should
>> +	 * this further generate a permission fault, it will be caught
>> +	 * in kvm_handle_guest_abort(), with prejudice...
>> +	 */
>> +	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
>> +		write_fault = false;
>> +	else
>> +		write_fault = kvm_is_write_fault(vcpu);
>>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>   	VM_BUG_ON(write_fault && exec_fault);
>> 
>> @@ -1013,19 +1021,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu
>> *vcpu)
>>   		}
>> 
>>   		/*
>> -		 * Check for a cache maintenance operation. Since we
>> -		 * ended-up here, we know it is outside of any memory
>> -		 * slot. But we can't find out if that is for a device,
>> -		 * or if the guest is just being stupid. The only thing
>> -		 * we know for sure is that this range cannot be cached.
>> +		 * Check for a cache maintenance operation. Two cases:
>> +		 *
>> +		 * - It is outside of any memory slot. But we can't find out
>> +		 *   if that is for a device, or if the guest is just being
>> +		 *   stupid. The only thing we know for sure is that this
>> +		 *   range cannot be cached.  So let's assume that the guest
>> +		 *   is just being cautious, and skip the instruction.
>> +		 *
>> +		 * - Otherwise, check whether this is a permission fault.
>> +		 *   If so, that's a DC IVAC on a R/O memslot, which is a
>> +		 *   pretty bad idea, and we tell the guest so.
>>   		 *
>> -		 * So let's assume that the guest is just being
>> -		 * cautious, and skip the instruction.
>> +		 * - If this wasn't a permission fault, pass it along for
>> +                 *   further handling (including faulting the page in
>> if it
>> +                 *   was a translation fault).
>>   		 */
>> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
>> {
>> -			kvm_incr_pc(vcpu);
>> -			ret = 1;
>> -			goto out_unlock;
>> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
>> +			if (kvm_is_error_hva(hva)) {
>> +				kvm_incr_pc(vcpu);
>> +				ret = 1;
>> +				goto out_unlock;
>> +			}
>> +
>> +			if (fault_status == FSC_PERM) {
>> +				/* DC IVAC on a R/O memslot */
>> +				kvm_inject_dabt(vcpu,
>> kvm_vcpu_get_hfar(vcpu));
> 
> One question:
> In general, the "DC" ops show up very early in guest. So what if the
> guest do this before interrupt initialization? If so, the guest may
> stuck here.

I don't understand your question. Do you mean "what if the guest
does this without being able to handle an exception"?

If that's your question, then the answer is "don't do that".
The architecture is clear that DC IVAC needs write permission, and
will result in an abort being delivered if there is no writable
mapping (and there can't be, the memslot is R/O).

DC CIVAC doesn't have that requirement, and will not generate an
exception.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

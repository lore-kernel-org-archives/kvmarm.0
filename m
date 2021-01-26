Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E8CC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 09:18:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7232F206E5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 09:18:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7232F206E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A47B44B203;
	Tue, 26 Jan 2021 04:18:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vajDNbo0UIsN; Tue, 26 Jan 2021 04:18:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFA24B1A5;
	Tue, 26 Jan 2021 04:18:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DAA4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 04:18:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AKjOErCHzRlm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 04:18:04 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15B7A4B1A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 04:18:04 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B71FC206E5;
 Tue, 26 Jan 2021 09:18:02 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l4KU4-00A4WZ-Ji; Tue, 26 Jan 2021 09:18:00 +0000
MIME-Version: 1.0
Date: Tue, 26 Jan 2021 09:18:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
In-Reply-To: <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <73b606d9c49e05435113a40a534af133@kernel.org>
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

On 2021-01-26 08:10, Jianyong Wu wrote:
> Hi Marc,
> 
>>   		/*
>> -		 * Check for a cache maintenance operation. Since we
>> -		 * ended-up here, we know it is outside of any memory
>> -		 * slot. But we can't find out if that is for a device,
>> -		 * or if the guest is just being stupid. The only thing
>> -		 * we know for sure is that this range cannot be cached.
>> +		 * Check for a cache maintenance operation. Two cases:
>>   		 *
>> -		 * So let's assume that the guest is just being
>> -		 * cautious, and skip the instruction.
>> +		 * - It is outside of any memory slot. But we can't
>> +		 *   find out if that is for a device, or if the guest
>> +		 *   is just being stupid. The only thing we know for
>> +		 *   sure is that this range cannot be cached.  So
>> +		 *   let's assume that the guest is just being
>> +		 *   cautious, and skip the instruction.
>> +		 *
>> +		 * - Otherwise, clean/invalidate the whole memslot. We
>> +		 *   should special-case DC IVAC and inject a
>> +		 *   permission fault, but we can't really identify it
>> +		 *   in this context.
>>   		 */
>> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
>> {
>> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
>> +			if (!kvm_is_error_hva(hva)) {
>> +				spin_lock(&vcpu->kvm->mmu_lock);
>> +				stage2_flush_memslot(vcpu->kvm,
>> memslot);
> 
> Maybe we should not flush the whole memslot here as every "dc ivac"
> only work on a range of memory with cache line size. So what about
> using:
> stage2_apply_range_resched(vcpu->kvm, fault_ipa, fault_ipa +
> cache_line_size(), kvm_pgtable_stage2_flush) instead. It will a bit
> faster than flush the whole memslot.
> Also I test your idea of "unmap after flush" using:
> 	stage2_apply_range_resched(vcpu->kvm, fault_ipa, fault_ipa +
> cache_line_size(), kvm_pgtable_stage2_flush);
> 	stage2_apply_range(vcpu->kvm, fault_ipa, fault_ipa +
> cache_line_size(), kvm_pgtable_stage2_unmap, true);
> then I do "dc ivac" on the rom of 128M twice and got the double time
> of around 11s. it means that there is no optimization when do the
> second "dc ivac".
> I'm not sure if there is something wrong in my test.
> 
> So what about just using " stage2_apply_range_resched(vcpu->kvm,
> fault_ipa, fault_ipa + cache_line_size(), kvm_pgtable_stage2_flush);"
> instead of
> " stage2_flush_memslot(vcpu->kvm, memslot);" and let the guest bears
> the disadvantage of low performance.

No, both solutions are wrong. I had to write my own test case because
the idea of hacking some unknown guest wasn't very appealing.

At the end of the day, what we need to implement is as follow:

- if a CMO hits normal memory, it's all already handled
- if a CMO hits non-memory, we skip it, as we do today
- if a CMO hits R/O memory, that's where things become fun:
   - if it is a DC IVAC, the architecture says this should result
     in a permission fault
   - if it is a DC CIVAC, it works as expected

So we need to distinguish between IVAC and CIVAC. One way to do it
is to treat CMOs generating a translation fault as a *read*, even
when they are on a RO memslot.

If they come back with a permission fault:
- inside a RW memslot: no problem, treat it as a write
- inside a RO memslot: only IVAC will fault here, inject an abort
   in the guest

This translates into the following patch, which does the trick
for me.

         M.

 From 8f2a919d6f13d36445974794c76821fbb6b40f88 Mon Sep 17 00:00:00 2001
 From: Marc Zyngier <maz@kernel.org>
Date: Sat, 16 Jan 2021 10:53:21 +0000
Subject: [PATCH] CMO on RO memslot

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
  arch/arm64/kvm/mmu.c | 51 +++++++++++++++++++++++++++++++++-----------
  1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..3c176b5b0a28 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -760,7 +760,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
  	struct kvm_pgtable *pgt;

  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
-	write_fault = kvm_is_write_fault(vcpu);
+	/*
+	 * Treat translation faults on CMOs as read faults. Should
+	 * this further generate a permission fault, it will be caught
+	 * in kvm_handle_guest_abort(), with prejudice...
+	 */
+	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
+		write_fault = false;
+	else
+		write_fault = kvm_is_write_fault(vcpu);
  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
  	VM_BUG_ON(write_fault && exec_fault);

@@ -1013,19 +1021,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu 
*vcpu)
  		}

  		/*
-		 * Check for a cache maintenance operation. Since we
-		 * ended-up here, we know it is outside of any memory
-		 * slot. But we can't find out if that is for a device,
-		 * or if the guest is just being stupid. The only thing
-		 * we know for sure is that this range cannot be cached.
+		 * Check for a cache maintenance operation. Two cases:
+		 *
+		 * - It is outside of any memory slot. But we can't find out
+		 *   if that is for a device, or if the guest is just being
+		 *   stupid. The only thing we know for sure is that this
+		 *   range cannot be cached.  So let's assume that the guest
+		 *   is just being cautious, and skip the instruction.
+		 *
+		 * - Otherwise, check whether this is a permission fault.
+		 *   If so, that's a DC IVAC on a R/O memslot, which is a
+		 *   pretty bad idea, and we tell the guest so.
  		 *
-		 * So let's assume that the guest is just being
-		 * cautious, and skip the instruction.
+		 * - If this wasn't a permission fault, pass it along for
+                 *   further handling (including faulting the page in 
if it
+                 *   was a translation fault).
  		 */
-		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
-			kvm_incr_pc(vcpu);
-			ret = 1;
-			goto out_unlock;
+		if (kvm_vcpu_dabt_is_cm(vcpu)) {
+			if (kvm_is_error_hva(hva)) {
+				kvm_incr_pc(vcpu);
+				ret = 1;
+				goto out_unlock;
+			}
+
+			if (fault_status == FSC_PERM) {
+				/* DC IVAC on a R/O memslot */
+				kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+				ret = 1;
+				goto out_unlock;
+			}
+
+			goto handle_access;
  		}

  		/*
@@ -1039,6 +1065,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
  		goto out_unlock;
  	}

+handle_access:
  	/* Userspace should not be able to register out-of-bounds IPAs */
  	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));

-- 
2.29.2


-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

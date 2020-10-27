Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD15EC55178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 14:59:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E00DF222C8
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 14:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ridBwbpr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E00DF222C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E48A4B513;
	Tue, 27 Oct 2020 10:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcA777BjGVnc; Tue, 27 Oct 2020 10:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB3B4B493;
	Tue, 27 Oct 2020 10:59:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B684B4EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 10:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zHYStoWAurjN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 10:59:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A398A4B3EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 10:59:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5D27921527;
 Tue, 27 Oct 2020 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603810756;
 bh=KPDhQ2eC+hxI1es67zSQER6Oyh7tou/MgdkaJjDBDL8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ridBwbprwzCFa4wXIdwtXZVVKi1mGH8VqkUUTTXXSqR7UrtScoEKRIle+aKYuYPHL
 2vQ8dVOZcHXd3PlnG02Q6EsT2WNKYfP5N6BPTLuICkH/5EdF2cERPlNSHof9RaAlKx
 z2f+tg5T2ahGYsctfyn48UXBCZKU7LvYteIZ4D0s=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXQRO-004l60-7t; Tue, 27 Oct 2020 14:59:14 +0000
MIME-Version: 1.0
Date: Tue, 27 Oct 2020 14:59:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 04/11] KVM: arm64: Move PC rollback on SError to HYP
In-Reply-To: <e2487f06-3f2f-1a0b-49d8-a72ea9288bb2@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-5-maz@kernel.org>
 <e2487f06-3f2f-1a0b-49d8-a72ea9288bb2@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <cd5527f7308f1db09268efd7c83e51c5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-10-27 14:56, James Morse wrote:
> Hi Marc,
> 
> On 26/10/2020 13:34, Marc Zyngier wrote:
>> Instead of handling the "PC rollback on SError during HVC" at EL1 
>> (which
>> requires disclosing PC to a potentially untrusted kernel), let's move
>> this fixup to ... fixup_guest_exit(), which is where we do all fixups.
> 
>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h 
>> b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index d687e574cde5..668f02c7b0b3 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -411,6 +411,21 @@ static inline bool fixup_guest_exit(struct 
>> kvm_vcpu *vcpu, u64 *exit_code)
>>  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>>  		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>> 
>> +	if (ARM_SERROR_PENDING(*exit_code)) {
>> +		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
>> +
>> +		/*
>> +		 * HVC already have an adjusted PC, which we need to
>> +		 * correct in order to return to after having injected
>> +		 * the SError.
>> +		 *
>> +		 * SMC, on the other hand, is *trapped*, meaning its
>> +		 * preferred return address is the SMC itself.
>> +		 */
>> +		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
>> +			*vcpu_pc(vcpu) -= 4;
> 
> Isn't *vcpu_pc(vcpu) the PC of the previous entry for this vcpu?....
> its not the PC of the
> exit until __sysreg_save_el2_return_state() saves it, which happens 
> just after
> fixup_guest_exit().

Hmmm. Good point. The move was obviously done in haste, thank you for 
pointing
this blatant bug.

> Mess with ELR_EL2 directly?

Yes, that's the best course of action. We never run this code anyway.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

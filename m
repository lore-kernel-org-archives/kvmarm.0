Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45ABC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:38:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43F91206F1
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3rJ1R+b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43F91206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F4B4B232;
	Thu, 28 May 2020 08:38:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7+9DI8P2uGAT; Thu, 28 May 2020 08:38:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7274B0BA;
	Thu, 28 May 2020 08:38:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8A64B21C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:38:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MkPIF5lxW23U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 08:38:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 032A64B203
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:38:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D4FA6206F1;
 Thu, 28 May 2020 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590669533;
 bh=BZ3w3GKugfaLInyp5RM4AxYALpTVIM2qk6X84rH4MZ0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Z3rJ1R+bzPOdlblNYhPa8gmGr4lF28LeXZT53IK4yg4k6erfxGYql74WkmlXVUann
 bQaelJYw+9Evjwn1vQuA2fIBs9erGxfL+xVjdMxGbWtvcfojUY4uZlibadAf6vU7Yc
 XFVkRPpsxlDCWwmOWnMjC8YSn4ZczW5sSqK7Caac=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jeHoB-00FzCQ-BM; Thu, 28 May 2020 13:38:51 +0100
MIME-Version: 1.0
Date: Thu, 28 May 2020 13:38:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Stop save/restoring ACTLR_EL1
In-Reply-To: <4d42a5db0b573c7a184aea654829a06c@kernel.org>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-3-james.morse@arm.com>
 <4d42a5db0b573c7a184aea654829a06c@kernel.org>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <07d09551c456c6be326473e003def3ab@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-05-28 13:36, Marc Zyngier wrote:
> On 2020-05-26 17:18, James Morse wrote:
>> KVM sets HCR_EL2.TACR (which it calls HCR_TAC) via HCR_GUEST_FLAGS.
> 
> TAC is a leftover from 32bit.
> 
>> This means ACTLR* accesses from the guest are always trapped, and
>> always return the value in the sys_regs array.
>> 
>> The guest can't change the value of these registers, so we are
>> save restoring the reset value, which came from the host.
>> 
>> Stop save/restoring this register.
>> 
>> This also stops this register being affected by sysregs_loaded_on_cpu,
>> so we can provide 32 bit accessors that always use the in-memory copy.
>> 
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/sysreg-sr.c | 2 --
>>  arch/arm64/kvm/sys_regs.c      | 2 --
>>  2 files changed, 4 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c 
>> b/arch/arm64/kvm/hyp/sysreg-sr.c
>> index 75b1925763f1..57116cf3a1a5 100644
>> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
>> @@ -44,7 +44,6 @@ static void __hyp_text
>> __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>>  {
>>  	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
>>  	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
>> -	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
>>  	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
>>  	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
>>  	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
>> @@ -133,7 +132,6 @@ static void __hyp_text
>> __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>>  		isb();
>>  	}
>> 
>> -	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
> 
> If we don't need to save/restore it, we can also drop its presence
> in the sys_regs array.
> 
>>  	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
>>  	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
>>  	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2eda539f3281..aae58513025c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -81,7 +81,6 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, 
>> int reg)
>>  	switch (reg) {
>>  	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
>>  	case SCTLR_EL1:		return read_sysreg_s(SYS_SCTLR_EL12);
>> -	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
>>  	case CPACR_EL1:		return read_sysreg_s(SYS_CPACR_EL12);
>>  	case TTBR0_EL1:		return read_sysreg_s(SYS_TTBR0_EL12);
>>  	case TTBR1_EL1:		return read_sysreg_s(SYS_TTBR1_EL12);
>> @@ -124,7 +123,6 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
>> val, int reg)
>>  	switch (reg) {
>>  	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
>>  	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	return;
>> -	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
>>  	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	return;
>>  	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	return;
>>  	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	return;
> 
> It strikes me that we don't even have a trap handler for this sysreg,
> whether it is 32 or 64bit... That's a bit unfortunate, to say the
> least...

Ah, no. the sucker is hidden away in "generic_v8"...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

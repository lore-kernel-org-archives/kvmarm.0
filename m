Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2156C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 10:45:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86C4120679
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 10:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1RtG08G/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86C4120679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F294B0B6;
	Mon, 15 Jun 2020 06:45:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TK7L3-f8R4tb; Mon, 15 Jun 2020 06:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711BA4A4FC;
	Mon, 15 Jun 2020 06:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD524A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 06:45:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YCL8Rca3UV0X for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 06:45:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68F404A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 06:45:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 440DE20679;
 Mon, 15 Jun 2020 10:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592217910;
 bh=NQzIZ8HPcQkoHR2c+q1ZkigBSIf8XsDf44QYuMwZ1eI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=1RtG08G/L03qKYK1oCOce5i21jHfrQ3NbZC8zOJcMgDMZ0czTmcyDD4bt7pC2BB3o
 qecG3/VcX504T1V2WOzpEUg5g2RXJmqv2ter5zGq7x6z+iBfsdH0JfYpj/dt2FmqRm
 v2hCvpW4bzXkjj+JNt21eLWPEaZqZnHxFtfGSm14=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jkmc0-0034QJ-RE; Mon, 15 Jun 2020 11:45:08 +0100
MIME-Version: 1.0
Date: Mon, 15 Jun 2020 11:45:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
In-Reply-To: <20200615084857.GD177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org> <20200615084857.GD177680@google.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8683c038040236e1fefed067649c31d9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Hi Andrew,

On 2020-06-15 09:48, Andrew Scull wrote:
> On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
>> While initializing EL2, switch Pointer Authentication if detected
> 
>                                 ^ nit: on?

Yes.

> 
>> from EL1. We use the EL1-provided keys though.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/hyp-init.S | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>> 
>> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
>> index 6e6ed5581eed..81732177507d 100644
>> --- a/arch/arm64/kvm/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp-init.S
>> @@ -104,6 +104,17 @@ alternative_else_nop_endif
>>  	 */
>>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
>> +alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
>> +	b	1f
>> +alternative_else_nop_endif
>> +alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
>> +	b	2f
>> +alternative_else_nop_endif
>> +1:
>> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
>> +	orr	x4, x4, #SCTLR_ELx_ENDA
>> +	orr	x4, x4, #SCTLR_ELx_ENDB
> 
> mm/proc.S builds the mask with ldr and ors it in one go, would be nice
> to use the same pattern.

Do you actually mean kernel/head.S, or even __ptrauth_keys_init_cpu in 
asm/asm_pointer_auth.h?

If so, I agree that it'd be good to make it look similar by using the 
mov_q macro, at the expense of a spare register (which we definitely can 
afford here).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

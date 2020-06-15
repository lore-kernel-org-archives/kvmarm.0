Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B418AC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 10:56:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C97A2068E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 10:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIlbWLp6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C97A2068E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDD444B0C9;
	Mon, 15 Jun 2020 06:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id le7tusN5Jyee; Mon, 15 Jun 2020 06:55:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1254B0BB;
	Mon, 15 Jun 2020 06:55:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB40F4B09A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 06:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F-ti8gQRLal0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 06:55:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FFDF4A522
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 06:55:56 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 759C82068E;
 Mon, 15 Jun 2020 10:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592218555;
 bh=QaBa2U9Geoqv5p35xEZGCPFzj0swu4OiDh55cMIarDQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=uIlbWLp6f1Vl5kwtuO2o8tEhAOPhh8OwsbhlCIUjVE5onhQxrcOt2paYytzhQFZ+S
 ELIHnWlyL61RYWU/C3dTm+2G2hErdEZSbK5DW3FL9qg5z91Ymd4N6jhMqSAN1YD6Je
 HKrDTYLd1K0oZDSgUbNGNojGjlv4ZletzawM1YYY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jkmmP-0034WH-Vp; Mon, 15 Jun 2020 11:55:54 +0100
MIME-Version: 1.0
Date: Mon, 15 Jun 2020 11:55:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
In-Reply-To: <20200615100318.GA773@C02TD0UTHF1T.local>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org>
 <20200615100318.GA773@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <c1ab609a8888d1c67b1946ebbf934dac@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

On 2020-06-15 11:03, Mark Rutland wrote:
> On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
>> While initializing EL2, switch Pointer Authentication if detected
>> from EL1. We use the EL1-provided keys though.
> 
> Perhaps "enable address authentication", to avoid confusion with
> context-switch, and since generic authentication cannot be disabled
> locally at EL2.

Ah, fair enough.

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
> 
> I see this is the same pattern we use in the kvm context switch, but I
> think we can use the ARM64_HAS_ADDRESS_AUTH cap instead (likewise in 
> the
> existing code).
> 
> AFAICT that won't permit mismatch given both 
> ARM64_HAS_ADDRESS_AUTH_ARCH
> and ARM64_HAS_ADDRESS_AUTH_IMP_DEF are dealt with as
> ARM64_CPUCAP_BOOT_CPU_FEATURE.

That'd be a nice cleanup, as the two back to back alternatives are a bit 
hard to read.

> 
>> +1:
>> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
>> +	orr	x4, x4, #SCTLR_ELx_ENDA
>> +	orr	x4, x4, #SCTLR_ELx_ENDB
> 
> Assuming we have a spare register, it would be nice if we could follow 
> the same
> pattern as in proc.S, where we do:
> 
> | ldr     x2, =SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
> |              SCTLR_ELx_ENDA | SCTLR_ELx_ENDB
> | orr     x0, x0, x2
> 
> ... though we could/should use mov_q rather than a load literal, here 
> and in
> proc.S.

Looks like this code isn't in -rc1 anymore, replaced with a mov_q in 
__ptrauth_keys_init_cpu.

I'll switch to that in v2.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

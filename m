Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29543C43334
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 10:50:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7454B4E3;
	Fri,  1 Jul 2022 06:50:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZibFfD58OiZr; Fri,  1 Jul 2022 06:50:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 836794B335;
	Fri,  1 Jul 2022 06:50:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70824B335
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 06:50:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BCHGW+-kvRY5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 06:50:07 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 403EA4B2AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 06:50:07 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BCC58B82F45;
 Fri,  1 Jul 2022 10:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47832C3411E;
 Fri,  1 Jul 2022 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656672604;
 bh=KL3HCbfmIFwpgQxHgKNqdfe68KZEBjGoiTLhKkW04Vc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=BZ8+LMQYkO8E3V0b8x4/wGg6JBNFWqJgwC4FRyMHck0/WTp19N4v4FQPnclu+j6uR
 tto47Kdud5bf028XT5T9xTI4e8nCc0FwS2yNCid9JchnCytU5A2DqvMnnV1o6H8AXA
 ZEZLW9NYPVGbKq/79ooZL4bkpTAoYHmbp3C3xXaCYGp1pSzxy79HHc46bmn4yxF8zr
 VCl0gB3p81ePFR2Vheu2BXxncQd+PVrwLIO3tivUDNPMDfYiYf0vSgoXhJohV70HtW
 UbCx/X16K93C/U1017ms10b96VSYr9qHLl1IymA5e1ONQD/z+1HQ16HBR6cxEH+Plz
 B4+WTj3FrWRmw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o7EDp-004Z3B-EI;
 Fri, 01 Jul 2022 11:50:01 +0100
MIME-Version: 1.0
Date: Fri, 01 Jul 2022 11:50:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: Schspa Shi <schspa@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix 64 bit mmio handle
In-Reply-To: <m2bkua148a.fsf@gmail.com>
References: <20220630161220.53449-1-schspa@gmail.com>
 <87mtdu15ok.wl-maz@kernel.org> <m2bkua148a.fsf@gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a5ca4db3db9ef101258cab94d6b7e045@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: schspa@gmail.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On 2022-06-30 17:50, Schspa Shi wrote:
> Marc Zyngier <maz@kernel.org> writes:
> 
>> On Thu, 30 Jun 2022 17:12:20 +0100,
>> Schspa Shi <schspa@gmail.com> wrote:
>>> 
>>> If the len is 8 bytes, we can't get the correct sign extend for
>>> be system.
>> 
>> I'm afraid you'll have to give me a bit more details.
>> 
>>> 
>>> Fix the mask type len and the comparison of length.
>>> 
>>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>>> ---
>>>  arch/arm64/kvm/mmio.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>>> index 3dd38a151d2a6..0692f8b18f35c 100644
>>> --- a/arch/arm64/kvm/mmio.c
>>> +++ b/arch/arm64/kvm/mmio.c
>>> @@ -81,8 +81,8 @@ unsigned long kvm_mmio_read_buf(const void *buf, 
>>> unsigned int len)
>>>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>>  {
>>>  	unsigned long data;
>>> +	unsigned long mask;
>>>  	unsigned int len;
>>> -	int mask;
>>>   	/* Detect an already handled MMIO return */
>>>  	if (unlikely(!vcpu->mmio_needed))
>>> @@ -97,7 +97,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>>  		data = kvm_mmio_read_buf(run->mmio.data, len);
>>>   		if (kvm_vcpu_dabt_issext(vcpu) &&
>>> -		    len < sizeof(unsigned long)) {
>>> +		    len <= sizeof(unsigned long)) {
>> 
>> If you're reading an 8 byte quantity, what is there to sign-extend?
>> Sign extension only makes sense if what you're reading is *smaller*
>> than the size of the register you are targeting.
>> 
> 
> Yes, you are correct, sorry for my bad patch.
> Please ignore this patch.
> 
>> I must be missing something. And how is that related to running BE? BE
>> in the host? The guest?
> 
> I mean BE is for guest running with BE mode.

So what problem did you see? If you have noticed something going
wrong, I'd like to get it fixed.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

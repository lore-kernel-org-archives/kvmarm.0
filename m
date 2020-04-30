Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBFDC8300D
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:59:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAEE320784
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRDP7EhD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAEE320784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51A9F4B568;
	Thu, 30 Apr 2020 06:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T6ev0lLtiJCf; Thu, 30 Apr 2020 06:59:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 300694B55F;
	Thu, 30 Apr 2020 06:59:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CED4B55F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:59:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vPI5YnRq4g+y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 06:59:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E226E4B55D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:59:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C00E020784;
 Thu, 30 Apr 2020 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588244347;
 bh=XdmvD3Q8v1cVOjovGFmT69sCbDPOc3huwohLmrMo6aQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LRDP7EhDi2XJ8/Y4BDNiUv0rMndR1qZec3TsYLk7z/Ujv4RPCejiqk103Qoxyx0P8
 eRTj5qEqmYG1Dnf0qLKUP44Xj1w22cvWXI4/77S4iGghNXnP7yK6uttQGo2EkGVY43
 PbWiUJKCvbMKaWQoRDSEJwzNzZVj02UZlJu8+eB0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jU6uH-0080A8-UU; Thu, 30 Apr 2020 11:59:06 +0100
MIME-Version: 1.0
Date: Thu, 30 Apr 2020 11:59:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
In-Reply-To: <20200430102556.GE19932@willie-the-truck>
References: <20200430101513.318541-1-maz@kernel.org>
 <20200430102556.GE19932@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <897baec2a3fad776716bccf3027340fa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On 2020-04-30 11:25, Will Deacon wrote:
> On Thu, Apr 30, 2020 at 11:15:13AM +0100, Marc Zyngier wrote:
>> In the unlikely event that a 32bit vcpu traps into the hypervisor
>> on an instruction that is located right at the end of the 32bit
>> range, the emulation of that instruction is going to increment
>> PC past the 32bit range. This isn't great, as userspace can then
>> observe this value and get a bit confused.
>> 
>> Conversly, userspace can do things like (in the context of a 64bit
>> guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
>> set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
>> that PC hasn't been truncated. More confusion.
>> 
>> Fix both by:
>> - truncating PC increments for 32bit guests
>> - sanitize PC every time a core reg is changed by userspace, and
>>   that PSTATE indicates a 32bit mode.
> 
> It's not clear to me whether this needs a cc stable. What do you think? 
> I
> suppose that it really depends on how confused e.g. QEMU gets.

It isn't so much QEMU itself that I'm worried about (the emulation 
shouldn't
really care about the PC), but the likes of GDB. So yes, a cc stable 
seems to
be in order.

> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/guest.c     | 4 ++++
>>  virt/kvm/arm/hyp/aarch32.c | 8 ++++++--
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 23ebe51410f0..2a159af82429 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, 
>> const struct kvm_one_reg *reg)
>>  	}
>> 
>>  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
>> +
>> +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
>> +		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> 
> It seems slightly odd to me that we don't enforce this for *all* the
> registers when running as a 32-bit guest. Couldn't userspace be equally
> confused by a 64-bit lr or sp?

Fair point. How about this on top, which wipes the upper 32 bits for
each and every register in the current mode:

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2a159af82429..f958c3c7bf65 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -201,9 +201,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu, 
const struct kvm_one_reg *reg)

  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));

-	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
-		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
+	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
+		int i;

+		for (i = 0; i < 16; i++)
+			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
+	}
  out:
  	return err;
  }

I'm tempted to make the whole SET_REG hunk a separate patch though.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

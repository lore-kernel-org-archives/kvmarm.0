Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7727C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 14:21:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58F5141016;
	Mon, 14 Feb 2022 09:21:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ULTwb4jnX3S; Mon, 14 Feb 2022 09:21:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BBA449E2A;
	Mon, 14 Feb 2022 09:21:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3CC41016
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 09:21:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JRwVgRrg+9wE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 09:21:03 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6090D40DE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 09:21:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2D45E6102D;
 Mon, 14 Feb 2022 14:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F260C340E9;
 Mon, 14 Feb 2022 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644848461;
 bh=F1gp4tJ4gmy9EY9Y249vOXEmsd/gkZm4hZliZmvfUuY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=WoS6O3Kr5uEhqS1goJlqSgk8kpWAb0IpUeN9HmajoDdPsNxJ5WolE3T9bXJieoFnW
 LxZzAFbB0j7q+gWdep+HRqnUi+NfOtLL9/FrM/kzDYNdFBMUFhprfWshB//TVjH9iD
 3T1XWyxtYEElW3IOuSFhZlhVgZlAF3f7ZTBM6iGPXUhk2nvlYUd8cHRuG3oNZdBmy2
 nPVXbYwvGmsYG3nIZlzIgjTcUs+tfCvfYuwM80C8n8EMkWjT4ac9Q88rNTqVf9p7JJ
 ssHc57YsDex2iFhLCB929cmYoP8qBa8wlWFRkK9gazw74cEKftLf8wzExpht0lxjGf
 Ja07NbtIwqeYg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nJcDr-007nf0-J2; Mon, 14 Feb 2022 14:20:59 +0000
MIME-Version: 1.0
Date: Mon, 14 Feb 2022 14:20:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: Miguel Luis <miguel.luis@oracle.com>
Subject: Re: [PATCH v6 06/64] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
In-Reply-To: <9724047B-0890-4C23-95CF-3AD553C4C63D@oracle.com>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-7-maz@kernel.org>
 <9724047B-0890-4C23-95CF-3AD553C4C63D@oracle.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <78e2094fb22d935c9bd635abb9a646ca@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: miguel.luis@oracle.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com,
 linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 Mihai Carabas <mihai.carabas@oracle.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

On 2022-02-14 12:39, Miguel Luis wrote:
> Hi Marc,
> 
>> On 28 Jan 2022, at 11:18, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> From: Christoffer Dall <christoffer.dall@arm.com>
>> 
>> When running a nested hypervisor we commonly have to figure out if
>> the VCPU mode is running in the context of a guest hypervisor or guest
>> guest, or just a normal guest.
>> 
>> Add convenient primitives for this.
>> 
>> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>> arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++++++++
>> 1 file changed, 53 insertions(+)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h 
>> b/arch/arm64/include/asm/kvm_emulate.h
>> index d62405ce3e6d..ea9a130c4b6a 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -178,6 +178,59 @@ static __always_inline void vcpu_set_reg(struct 
>> kvm_vcpu *vcpu, u8 reg_num,
>> 		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>> }
>> 
>> +static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context 
>> *ctxt)
>> +{
>> +	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
>> +	case PSR_MODE_EL2h:
>> +	case PSR_MODE_EL2t:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
> 
> PSR_MODE_EL2{h,t} values the least significant nibble, so why the
> PSR_MODE32_BIT in the condition?

Because that's part of the M bits in SPSR, and this has to be
valid on any code path, no matter what execution state the
guest is in. You can't evaluate the M[3:0] on their own *unless*
you have already checked that M[4] is 0 (an AArch32 guest would
have M[4]==1).

Yes, we are so far lucky that AArch32 and AArch64 don't overlap
in their values of SPSR_EL2.M[3:0]. We may run out of luck at
some point.

> 
> For the scope of this function as is, may I suggest:
> 
> 	switch (ctxt->regs.pstate & PSR_MODE_MASK) {
> 
> which should be sufficient to check if vcpu_is_el2_ctx.

I don't think this is wise. It makes the code more fragile,
and harder to reason about.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

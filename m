Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C660C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 10:14:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DA54207BB
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 10:14:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AH5Au2n/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DA54207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B44F44B6ED;
	Tue, 10 Nov 2020 05:14:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TXxNaU6Juopv; Tue, 10 Nov 2020 05:14:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 558D44B70D;
	Tue, 10 Nov 2020 05:14:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 098BF4B70D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 05:14:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2K7p2kVmndjy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 05:14:06 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFCE44B6ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 05:14:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5116620797;
 Tue, 10 Nov 2020 10:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605003244;
 bh=oiJduJ6dIM4xNThorZ5/RiydXGO4yrO5KxVvhHyptiQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=AH5Au2n/A0Yz7YVrSjo4FFX9ASh+3wqIKP+XbCvsyYtlvIzTPCKvJeh28LZwaCqm2
 XTnHvlm5TxGhbQXaks3vXf0w20abUha2ETN64x8534dxYivipgw/FV1sjOfUNQG8g8
 rknEH5xZYUyUULE/vkzI3IotOTINjEJtDdAr5EY4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcQf4-009Pd8-B0; Tue, 10 Nov 2020 10:14:02 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 10:14:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 3/8] KVM: arm64: Map AArch32 cp15 register to AArch64
 sysregs
In-Reply-To: <b6628cea-520a-90bd-3c42-82ed2863c4af@arm.com>
References: <20201102191609.265711-1-maz@kernel.org>
 <20201102191609.265711-4-maz@kernel.org>
 <b6628cea-520a-90bd-3c42-82ed2863c4af@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <256242247e00a3dba3ab281c3a06c1dc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-11-03 18:29, James Morse wrote:
> Hi Marc,
> 
> On 02/11/2020 19:16, Marc Zyngier wrote:
>> Move all the cp15 registers over to their AArch64 counterpart.
>> This requires the annotation of a few of them (such as the usual
>> DFAR/IFAR vs FAR_EL1), and a new helper that generates mask/shift
>> pairs for the various configurations.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 26c7c25f8a6d..137818793a4a 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -138,26 +156,16 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>>  			  const struct sys_reg_desc *r)
>>  {
>>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>> -	u64 val;
>> -	int reg = r->reg;
>> +	u64 val, mask, shift;
>> 
>>  	BUG_ON(!p->is_write);
>> 
>> -	/* See the 32bit mapping in kvm_host.h */
>> -	if (p->is_aarch32)
>> -		reg = r->reg / 2;
>> +	get_access_mask(r, &mask, &shift);
>> 
>> -	if (!p->is_aarch32 || !p->is_32bit) {
>> -		val = p->regval;
>> -	} else {
>> -		val = vcpu_read_sys_reg(vcpu, reg);
>> -		if (r->reg % 2)
>> -			val = (p->regval << 32) | (u64)lower_32_bits(val);
>> -		else
>> -			val = ((u64)upper_32_bits(val) << 32) |
>> -				lower_32_bits(p->regval);
>> -	}
>> -	vcpu_write_sys_reg(vcpu, val, reg);
> 
>> +	val = vcpu_read_sys_reg(vcpu, r->reg);
>> +	val &= ~mask;
>> +	val |= (p->regval & (mask >> shift)) << shift;
>> +	vcpu_write_sys_reg(vcpu, val, r->reg);
> 
> I can't tell if the compiler has worked out ithat it can skip the
> sys_read most of the
> time... Won't some of these trap for a nested VHE hypervisor?
> 
> | if (~mask) {
> |	val = vcpu_read_sys_reg(vcpu, r->reg);
> |	val &= ~mask;
> | }

Seems like a good call. I'm happy to fold that in.

> 
> 
> But, as the sys_reg arrays already have indirection for this function, 
> why does
> access_vm_reg() have to deal with this at all? Its not even needed for
> all the aarch32 registers...
> 
> 
> | { AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0),
> access_aarch32_alias, NULL, MAIR_EL1 },
> 
> Where access_aarch32_alias() does the shift+mask and read_modify-write
> on the sys_reg?


I don't really like the idea of separate handlers. The whole point is to
unify the two view, and I feel like having yet another indirection makes
it harder to maintain.

> 
>>  	kvm_toggle_cache(vcpu, was_enabled);
>>  	return true;
> 
>> @@ -1919,19 +1919,24 @@ static const struct sys_reg_desc 
>> cp14_64_regs[] = {
>>   */
>>  static const struct sys_reg_desc cp15_regs[] = {
> 
>> -	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR 
>> },
> 
>> +	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, TCR_EL1 
>> },
> 
> Don't look now ... TTBRCR2 means this one is a LO/HI job.

That's the problem with AArch32. You stop looking for a couple of years,
and it decides to throw a new sysreg at you without any notice. WTF?

> (I'm guessing that should be fixed before this series to make the 
> backport easy)

I'll work something out as a prologue to this series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2597AC388F2
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99D292076E
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99D292076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23EA04B2E5;
	Tue,  3 Nov 2020 13:29:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Yi9n1RIMqXe; Tue,  3 Nov 2020 13:29:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46F54B4DB;
	Tue,  3 Nov 2020 13:29:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0AC54B318
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gPeSJ9K3jmNv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 13:29:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 491C04B4DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF0221474;
 Tue,  3 Nov 2020 10:29:36 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDAAD3F718;
 Tue,  3 Nov 2020 10:29:35 -0800 (PST)
Subject: Re: [PATCH 3/8] KVM: arm64: Map AArch32 cp15 register to AArch64
 sysregs
To: Marc Zyngier <maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
 <20201102191609.265711-4-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <b6628cea-520a-90bd-3c42-82ed2863c4af@arm.com>
Date: Tue, 3 Nov 2020 18:29:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-4-maz@kernel.org>
Content-Language: en-GB
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> Move all the cp15 registers over to their AArch64 counterpart.
> This requires the annotation of a few of them (such as the usual
> DFAR/IFAR vs FAR_EL1), and a new helper that generates mask/shift
> pairs for the various configurations.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 26c7c25f8a6d..137818793a4a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -138,26 +156,16 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  			  const struct sys_reg_desc *r)
>  {
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
> -	u64 val;
> -	int reg = r->reg;
> +	u64 val, mask, shift;
>  
>  	BUG_ON(!p->is_write);
>  
> -	/* See the 32bit mapping in kvm_host.h */
> -	if (p->is_aarch32)
> -		reg = r->reg / 2;
> +	get_access_mask(r, &mask, &shift);
>  
> -	if (!p->is_aarch32 || !p->is_32bit) {
> -		val = p->regval;
> -	} else {
> -		val = vcpu_read_sys_reg(vcpu, reg);
> -		if (r->reg % 2)
> -			val = (p->regval << 32) | (u64)lower_32_bits(val);
> -		else
> -			val = ((u64)upper_32_bits(val) << 32) |
> -				lower_32_bits(p->regval);
> -	}
> -	vcpu_write_sys_reg(vcpu, val, reg);

> +	val = vcpu_read_sys_reg(vcpu, r->reg);
> +	val &= ~mask;
> +	val |= (p->regval & (mask >> shift)) << shift;
> +	vcpu_write_sys_reg(vcpu, val, r->reg);

I can't tell if the compiler has worked out ithat it can skip the sys_read most of the
time... Won't some of these trap for a nested VHE hypervisor?

| if (~mask) {
|	val = vcpu_read_sys_reg(vcpu, r->reg);
|	val &= ~mask;
| }


But, as the sys_reg arrays already have indirection for this function, why does
access_vm_reg() have to deal with this at all? Its not even needed for all the aarch32
registers...


| { AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_aarch32_alias, NULL, MAIR_EL1 },

Where access_aarch32_alias() does the shift+mask and read_modify-write on the sys_reg?


>  	kvm_toggle_cache(vcpu, was_enabled);
>  	return true;

> @@ -1919,19 +1919,24 @@ static const struct sys_reg_desc cp14_64_regs[] = {
>   */
>  static const struct sys_reg_desc cp15_regs[] = {

> -	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },

> +	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, TCR_EL1 },

Don't look now ... TTBRCR2 means this one is a LO/HI job.

(I'm guessing that should be fixed before this series to make the backport easy)


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

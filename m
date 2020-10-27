Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E642C388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:41:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FC1221556
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FC1221556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDA34B4AC;
	Tue, 27 Oct 2020 13:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8+OStESEoiiH; Tue, 27 Oct 2020 13:41:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E4214B4AD;
	Tue, 27 Oct 2020 13:41:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4524B4A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pgDYFhjpFMPK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:41:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 998E44B446
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:41:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D58D139F;
 Tue, 27 Oct 2020 10:41:30 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B55DF3F719;
 Tue, 27 Oct 2020 10:41:28 -0700 (PDT)
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
To: Marc Zyngier <maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
Date: Tue, 27 Oct 2020 17:41:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-9-maz@kernel.org>
Content-Language: en-GB
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 26/10/2020 13:34, Marc Zyngier wrote:
> Similarily to what has been done for AArch64, move the AArch32 exception
> inhjection to HYP.
> 
> In order to not use the regmap selection code at EL2, simplify the code
> populating the target mode's LR register by harcoding the two possible
> LR registers (LR_abt in X20, LR_und in X22).


> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index cd6e643639e8..8d1d1bcd9e69 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -57,10 +67,25 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)

> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	return __vcpu_read_sys_reg(vcpu, reg / 2);
> +}

Doesn't this re-implement the issue 3204be4109ad biased?


> @@ -155,23 +180,189 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,

> +static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> +{

> +	/*
> +	 * Table D1-27 of DDI 0487F.c shows the GPR mapping between
> +	 * AArch32 and AArch64. We only deal with ABT/UND.

(to check I understand : because these are the only two KVM ever injects?)


> +	 */
> +	switch(mode) {
> +	case PSR_AA32_MODE_ABT:
> +		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 20;
>  		break;
> +		

(two bonus tabs!)


> +	case PSR_AA32_MODE_UND:
> +		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 22;
>  		break;
>  	}> +
> +	vcpu_set_reg(vcpu, lr, *vcpu_pc(vcpu) + return_offset);


Can we, abuse, the compat_lr_abt definitions to do something like:

|	u32 return_address = *vcpu_pc(vcpu) + return_offset;
[..]
|	switch(mode) {
|	case PSR_AA32_MODE_ABT:>
|		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
|		vcpu_gp_regs(vcpu)->compat_lr_abt = return_address;
|		break;
|	case PSR_AA32_MODE_UND:
|		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
|		vcpu_gp_regs(vcpu)->compat_lr_und = return_address;
|		break;

...as someone who has no clue about 32bit, this hides all the worrying magic-14==magic-22!



Thanks,

James

> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

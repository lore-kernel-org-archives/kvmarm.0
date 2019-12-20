Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB48FC3F68F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:36:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C0F621655
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C0F621655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A716E4AC6C;
	Fri, 20 Dec 2019 10:36:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LazJLnTBIZXN; Fri, 20 Dec 2019 10:36:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 744794A5A3;
	Fri, 20 Dec 2019 10:36:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F884A535
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:36:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LGrxmD-onKGJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 10:36:49 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C944C4A523
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:36:49 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iiKKd-0000nh-69; Fri, 20 Dec 2019 16:36:47 +0100
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: correct AArch32 SPSR on exception
 entry
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 20 Dec 2019 15:36:47 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191220150549.31948-4-mark.rutland@arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-4-mark.rutland@arm.com>
Message-ID: <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com,
 drjones@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 peter.maydell@linaro.org, suzuki.poulose@arm.com, will@kernel.org,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hi Mark,

On 2019-12-20 15:05, Mark Rutland wrote:
> Confusingly, there are three SPSR layouts that a kernel may need to 
> deal
> with:
>
> (1) An AArch64 SPSR_ELx view of an AArch64 pstate
> (2) An AArch64 SPSR_ELx view of an AArch32 pstate
> (3) An AArch32 SPSR_* view of an AArch32 pstate
>
> When the KVM AArch32 support code deals with SPSR_{EL2,HYP}, it's 
> either
> dealing with #2 or #3 consistently. On arm64 the PSR_AA32_* 
> definitions
> match the AArch64 SPSR_ELx view, and on arm the PSR_AA32_* 
> definitions
> match the AArch32 SPSR_* view.
>
> However, when we inject an exception into an AArch32 guest, we have 
> to
> synthesize the AArch32 SPSR_* that the guest will see. Thus, an 
> AArch64
> host needs to synthesize layout #3 from layout #2.
>
> This patch adds a new host_spsr_to_spsr32() helper for this, and 
> makes
> use of it in the KVM AArch32 support code. For arm64 we need to 
> shuffle
> the DIT bit around, and remove the SS bit, while for arm we can use 
> the
> value as-is.
>
> I've open-coded the bit manipulation for now to avoid having to 
> rework
> the existing PSR_* definitions into PSR64_AA32_* and PSR32_AA32_*
> definitions. I hope to perform a more thorough refactoring in future 
> so
> that we can handle pstate view manipulation more consistently across 
> the
> kernel tree.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Drew Jones <drjones@redhat.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm/include/asm/kvm_emulate.h   |  5 +++++
>  arch/arm64/include/asm/kvm_emulate.h | 32 
> ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/aarch32.c               |  6 +++---
>  3 files changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/include/asm/kvm_emulate.h
> b/arch/arm/include/asm/kvm_emulate.h
> index dee2567661ed..b811576bc456 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -53,6 +53,11 @@ static inline void vcpu_write_spsr(struct kvm_vcpu
> *vcpu, unsigned long v)
>  	*__vcpu_spsr(vcpu) = v;
>  }
>
> +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> +{
> +	return spsr;
> +}
> +
>  static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
>  					 u8 reg_num)
>  {
> diff --git a/arch/arm64/include/asm/kvm_emulate.h
> b/arch/arm64/include/asm/kvm_emulate.h
> index d69c1efc63e7..98672938f9f9 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -204,6 +204,38 @@ static inline void vcpu_write_spsr(struct
> kvm_vcpu *vcpu, unsigned long v)
>  		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
>  }
>
> +/*
> + * The layout of SPSR for an AArch32 state is different when
> observed from an
> + * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates
> the AArch32
> + * view given an AArch64 view.
> + *
> + * In ARM DDI 0487E.a see:
> + *
> + * - The AArch64 view (SPSR_EL2) in section C5.2.18, page C5-426
> + * - The AArch32 view (SPSR_abt) in section G8.2.126, page G8-6256
> + * - The AArch32 view (SPSR_und) in section G8.2.132, page G8-6280
> + *
> + * Which show the following differences:
> + *
> + * | Bit | AA64 | AA32 | Notes                       |
> + * +-----+------+------+-----------------------------|
> + * | 24  | DIT  | J    | J is RES0 in ARMv8          |
> + * | 21  | SS   | DIT  | SS doesn't exist in AArch32 |
> + *
> + * ... and all other bits are (currently) common.
> + */
> +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> +{
> +	const unsigned long overlap = BIT(24) | BIT(21);
> +	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
> +
> +	spsr &= overlap;

Are you sure this is what you want to do? This doesn't leave
that many bits set in SPSR... :-/

> +
> +	spsr |= dit << 21;
> +
> +	return spsr;
> +}
> +
>  static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
>  {
>  	u32 mode;
> diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> index 17bcde5c2451..115210e64682 100644
> --- a/virt/kvm/arm/aarch32.c
> +++ b/virt/kvm/arm/aarch32.c
> @@ -128,15 +128,15 @@ static unsigned long get_except32_cpsr(struct
> kvm_vcpu *vcpu, u32 mode)
>
>  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32
> vect_offset)
>  {
> -	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
> -	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
> +	unsigned long spsr = *vcpu_cpsr(vcpu);
> +	bool is_thumb = (spsr & PSR_AA32_T_BIT);
>  	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
>  	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
>
>  	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
>
>  	/* Note: These now point to the banked copies */
> -	vcpu_write_spsr(vcpu, new_spsr_value);
> +	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
>  	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
>
>  	/* Branch to exception vector */

Apart from what I believe is a missing ~ above, this looks good.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=AIE7=4F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100F1C34021
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 14:56:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9709120679
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 14:56:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9709120679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239F14AF37;
	Mon, 17 Feb 2020 09:56:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vSKcxKM4gF-l; Mon, 17 Feb 2020 09:56:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A734A94D;
	Mon, 17 Feb 2020 09:56:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D1A4AEEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 09:56:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hac3ffdNjmUF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Feb 2020 09:56:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6F04A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 09:56:35 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B13A630E;
 Mon, 17 Feb 2020 06:56:34 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBBA93F703;
 Mon, 17 Feb 2020 06:56:33 -0800 (PST)
Date: Mon, 17 Feb 2020 14:56:31 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 12/94] KVM: arm64: nv: Add EL2->EL1 translation helpers
Message-ID: <20200217145630.GD47755@lakrids.cambridge.arm.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-13-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200211174938.27809-13-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On Tue, Feb 11, 2020 at 05:48:16PM +0000, Marc Zyngier wrote:
> Some EL2 system registers immediately affect the current execution
> of the system, so we need to use their respective EL1 counterparts.
> For this we need to define a mapping between the two.
> 
> These helpers will get used in subsequent patches.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  6 ++++
>  arch/arm64/kvm/sys_regs.c            | 48 ++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 282e9ddbe1bc..486978d0346b 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -58,6 +58,12 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
>  int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
>  int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>  
> +u64 translate_tcr(u64 tcr);
> +u64 translate_cptr(u64 tcr);
> +u64 translate_sctlr(u64 tcr);
> +u64 translate_ttbr0(u64 tcr);
> +u64 translate_cnthctl(u64 tcr);

Sorry to bikeshed, but could we please make the direction of translation
explicit in the name? e.g. tcr_el2_to_tcr_el1(), or tcr_el2_to_el1()?

> +
>  static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>  {
>  	return !(vcpu->arch.hcr_el2 & HCR_RW);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4b5310ea3bf8..634d3ee6799c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -65,6 +65,54 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +static u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
> +{
> +	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
> +		<< TCR_IPS_SHIFT;
> +}
> +
> +u64 translate_tcr(u64 tcr)
> +{
> +	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
> +	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
> +	       tcr_el2_ips_to_tcr_el1_ps(tcr) |
> +	       (tcr & TCR_EL2_TG0_MASK) |
> +	       (tcr & TCR_EL2_ORGN0_MASK) |
> +	       (tcr & TCR_EL2_IRGN0_MASK) |
> +	       (tcr & TCR_EL2_T0SZ_MASK);
> +}

I'm guessing this is only meant to cover a !VHE guest EL2 for the
moment, so only covers HCR_EL2.E2H=0? It might be worth mentioning in
the commit message.

It looks like this is missing some bits (e.g. TBID, HPD, HD, HA) that
could apply to the Guest-EL2 Stage-1. Maybe those are added by later
patches, but that's not obvious to me at this point in the series.

> +
> +u64 translate_cptr(u64 cptr_el2)
> +{
> +	u64 cpacr_el1 = 0;
> +
> +	if (!(cptr_el2 & CPTR_EL2_TFP))
> +		cpacr_el1 |= CPACR_EL1_FPEN;
> +	if (cptr_el2 & CPTR_EL2_TTA)
> +		cpacr_el1 |= CPACR_EL1_TTA;
> +	if (!(cptr_el2 & CPTR_EL2_TZ))
> +		cpacr_el1 |= CPACR_EL1_ZEN;
> +
> +	return cpacr_el1;
> +}

Looking in ARM DDI 0487E.a I also see TCPAC and TAM; I guess we don't
need to map those to anthing?

> +
> +u64 translate_sctlr(u64 sctlr)
> +{
> +	/* Bit 20 is RES1 in SCTLR_EL1, but RES0 in SCTLR_EL2 */
> +	return sctlr | BIT(20);
> +}

Looking in ARM DDI 0487E.a section D13.2.105, bit 20 is TSCXT, so this
might need to be reconsidered.

> +
> +u64 translate_ttbr0(u64 ttbr0)
> +{
> +	/* Force ASID to 0 (ASID 0 or RES0) */
> +	return ttbr0 & ~GENMASK_ULL(63, 48);
> +}

Again, I assume this is only meant to provide a !VHE EL2 as this stands.

> +
> +u64 translate_cnthctl(u64 cnthctl)
> +{
> +	return ((cnthctl & 0x3) << 10) | (cnthctl & 0xfc);
> +}

I assume this yields CNTKCTL_EL1, but I don't entirely follow. For
virtual-EL2 don't we have to force EL1P(C)TEN so that virtual-EL2
accesses don't trap?

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

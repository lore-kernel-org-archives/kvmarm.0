Return-Path: <SRS0=/1aR=2R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648ACC2D0C6
	for <kvmarm@archiver.kernel.org>; Fri, 27 Dec 2019 15:42:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4509208C4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Dec 2019 15:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4509208C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 053714A3B4;
	Fri, 27 Dec 2019 10:42:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FxWxKoeN47De; Fri, 27 Dec 2019 10:42:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CAC54A4FC;
	Fri, 27 Dec 2019 10:42:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC344A3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Dec 2019 10:42:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HPd1XdoGWufT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Dec 2019 10:42:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C404A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Dec 2019 10:42:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 714D61FB;
 Fri, 27 Dec 2019 07:42:34 -0800 (PST)
Received: from [10.37.8.128] (unknown [10.37.8.128])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 474BF3F68F;
 Fri, 27 Dec 2019 07:42:31 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: arm/arm64: correct CPSR on exception entry
To: Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-3-mark.rutland@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <775a6053-ad90-bf2f-43f0-11f71d34f4a1@arm.com>
Date: Fri, 27 Dec 2019 15:42:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191220150549.31948-3-mark.rutland@arm.com>
Content-Language: en-US
Cc: stable@vger.kernel.org, Will Deacon <will@kernel.org>
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

Hi,

On 12/20/19 3:05 PM, Mark Rutland wrote:
> When KVM injects an exception into a guest, it generates the CPSR value
> from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
> bits to zero.
>
> This isn't correct, as the architecture specifies that some CPSR bits
> are (conditionally) cleared or set upon an exception, and others are
> unchanged from the original context.
>
> This patch adds logic to match the architectural behaviour. To make this
> simple to follow/audit/extend, documentation references are provided,
> and bits are configured in order of their layout in SPSR_EL2. This

This patch applies equally well to 32bit KVM, where we have a SPSR register.

> layout can be seen in the diagram on ARM DDI 0487E.a page C5-426.
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
>  arch/arm/include/asm/kvm_emulate.h |  12 ++++
>  arch/arm64/include/asm/ptrace.h    |   1 +
>  virt/kvm/arm/aarch32.c             | 110 +++++++++++++++++++++++++++++++++----
>  3 files changed, 113 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index 40002416efec..dee2567661ed 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -14,13 +14,25 @@
>  #include <asm/cputype.h>
>  
>  /* arm64 compatibility macros */
> +#define PSR_AA32_MODE_FIQ	FIQ_MODE
> +#define PSR_AA32_MODE_SVC	SVC_MODE
>  #define PSR_AA32_MODE_ABT	ABT_MODE
>  #define PSR_AA32_MODE_UND	UND_MODE
>  #define PSR_AA32_T_BIT		PSR_T_BIT
> +#define PSR_AA32_F_BIT		PSR_F_BIT
>  #define PSR_AA32_I_BIT		PSR_I_BIT
>  #define PSR_AA32_A_BIT		PSR_A_BIT
>  #define PSR_AA32_E_BIT		PSR_E_BIT
>  #define PSR_AA32_IT_MASK	PSR_IT_MASK
> +#define PSR_AA32_GE_MASK	0x000f0000
> +#define PSR_AA32_PAN_BIT	0x00400000
> +#define PSR_AA32_SSBS_BIT	0x00800000
> +#define PSR_AA32_DIT_BIT	0x01000000

This is actually PSR_J_BIT on arm. Maybe it's worth defining it like that to
make the overlap obvious.

> +#define PSR_AA32_Q_BIT		PSR_Q_BIT
> +#define PSR_AA32_V_BIT		PSR_V_BIT
> +#define PSR_AA32_C_BIT		PSR_C_BIT
> +#define PSR_AA32_Z_BIT		PSR_Z_BIT
> +#define PSR_AA32_N_BIT		PSR_N_BIT
>  
> unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
>  
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index fbebb411ae20..bf57308fcd63 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -62,6 +62,7 @@
>  #define PSR_AA32_I_BIT		0x00000080
>  #define PSR_AA32_A_BIT		0x00000100
>  #define PSR_AA32_E_BIT		0x00000200
> +#define PSR_AA32_PAN_BIT	0x00400000
>  #define PSR_AA32_SSBS_BIT	0x00800000
>  #define PSR_AA32_DIT_BIT	0x01000000
>  #define PSR_AA32_Q_BIT		0x08000000
> diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> index c4c57ba99e90..17bcde5c2451 100644
> --- a/virt/kvm/arm/aarch32.c
> +++ b/virt/kvm/arm/aarch32.c
> @@ -10,6 +10,7 @@
>   * Author: Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/bits.h>
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> @@ -28,22 +29,111 @@ static const u8 return_offsets[8][2] = {
>  	[7] = { 4, 4 },		/* FIQ, unused */
>  };
>  
> +/*
> + * When an exception is taken, most CPSR fields are left unchanged in the
> + * handler. However, some are explicitly overridden (e.g. M[4:0]).
> + *
> + * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
> + * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
> + * obsoleted by the ARMv7 virtualization extensions and is RES0.
> + *
> + * For the SPSR layout seen from AArch32, see:
> + * - ARM DDI 0406C.d, page B1-1148
> + * - ARM DDI 0487E.a, page G8-6264
> + *
> + * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
> + * - ARM DDI 0487E.a, page C5-426
> + *
> + * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
> + * MSB to LSB.
> + */
> +static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
> +{
> +	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
> +	unsigned long old, new;
> +
> +	old = *vcpu_cpsr(vcpu);
> +	new = 0;
> +
> +	new |= (old & PSR_AA32_N_BIT);
> +	new |= (old & PSR_AA32_Z_BIT);
> +	new |= (old & PSR_AA32_C_BIT);
> +	new |= (old & PSR_AA32_V_BIT);
> +	new |= (old & PSR_AA32_Q_BIT);
> +
> +	// CPSR.IT[7:0] are set to zero upon any exception
> +	// See ARM DDI 0487E.a, section G1.12.3
> +	// See ARM DDI 0406C.d, section B1.8.3
> +
> +	new |= (old & PSR_AA32_DIT_BIT);
> +
> +	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
> +	// See ARM DDI 0487E.a, page G8-6244
> +	if (sctlr & BIT(31))
> +		new |= PSR_AA32_SSBS_BIT;
> +
> +	// CPSR.PAN is unchanged unless overridden by SCTLR.SPAN
> +	// See ARM DDI 0487E.a, page G8-6246
> +	new |= (old & PSR_AA32_PAN_BIT);
> +	if (sctlr & BIT(23))
> +		new |= PSR_AA32_PAN_BIT;

PSTATE.PAN is unconditionally set when SCTLR.SPAN is clear.

> +
> +	// SS does not exist in AArch32, so ignore
> +
> +	// CPSR.IL is set to zero upon any exception
> +	// See ARM DDI 0487E.a, page G1-5527
> +
> +	new |= (old & PSR_AA32_GE_MASK);
> +
> +	// CPSR.IT[7:0] are set to zero upon any exception
> +	// See prior comment above
> +
> +	// CPSR.E is set to SCTLR.EE upon any exception
> +	// See ARM DDI 0487E.a, page G8-6245
> +	// See ARM DDI 0406C.d, page B4-1701
> +	if (sctlr & BIT(25))
> +		new |= PSR_AA32_E_BIT;
> +
> +	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
> +	// CPSR.A is set upon an exception to other modes
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= (old & PSR_AA32_A_BIT);
> +	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
> +		new |= PSR_AA32_A_BIT;
> +
> +	// CPSR.I is set upon any exception
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= PSR_AA32_I_BIT;
> +
> +	// CPSR.F is set upon an exception to FIQ
> +	// CPSR.F is unchanged upon an exception to other modes
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= (old & PSR_AA32_F_BIT);
> +	if (mode == PSR_AA32_MODE_FIQ)
> +		new |= PSR_AA32_F_BIT;
> +
> +	// CPSR.T is set to SCTLR.TE upon any exception
> +	// See ARM DDI 0487E.a, page G8-5514
> +	// See ARM DDI 0406C.d, page B1-1181
> +	if (sctlr & BIT(30))
> +		new |= PSR_AA32_T_BIT;
> +
> +	new |= mode;
> +
> +	return new;
> +}
> +
>  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  {
> -	unsigned long cpsr;
>  	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
>  	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
>  	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
>  	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
>  
> -	cpsr = mode | PSR_AA32_I_BIT;
> -
> -	if (sctlr & (1 << 30))
> -		cpsr |= PSR_AA32_T_BIT;
> -	if (sctlr & (1 << 25))
> -		cpsr |= PSR_AA32_E_BIT;
> -
> -	*vcpu_cpsr(vcpu) = cpsr;
> +	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
>  
>  	/* Note: These now point to the banked copies */
>  	vcpu_write_spsr(vcpu, new_spsr_value);
> @@ -84,7 +174,7 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>  		fsr = &vcpu_cp15(vcpu, c5_DFSR);
>  	}
>  
> -	prepare_fault32(vcpu, PSR_AA32_MODE_ABT | PSR_AA32_A_BIT, vect_offset);
> +	prepare_fault32(vcpu, PSR_AA32_MODE_ABT, vect_offset);
>  
>  	*far = addr;
>  

I've also checked that the ARM documentation references match the code.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

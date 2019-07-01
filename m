Return-Path: <SRS0=uL1D=U6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92444C0650E
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 16:36:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 215F220B7C
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 16:36:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 215F220B7C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6A34A4E6;
	Mon,  1 Jul 2019 12:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P6NpzalbYBFL; Mon,  1 Jul 2019 12:36:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37B3A4A4A0;
	Mon,  1 Jul 2019 12:36:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6FB40217
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 12:36:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5WzPrxz0gRw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jul 2019 12:36:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3D6F4A483
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 12:36:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81ED62B;
 Mon,  1 Jul 2019 09:36:05 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (dawn-kernel.cambridge.arm.com
 [10.1.197.116])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 466FC3F703;
 Mon,  1 Jul 2019 09:36:04 -0700 (PDT)
Subject: Re: [PATCH 07/59] KVM: arm64: nv: Add EL2 system registers to vcpu
 context
To: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-8-marc.zyngier@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <37d056e6-85e1-5d6e-3c1c-e89d00140fdf@arm.com>
Date: Mon, 1 Jul 2019 17:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-8-marc.zyngier@arm.com>
Content-Language: en-US
Cc: andre.przywara@arm.com, dave.martin@arm.com
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

Hi Marc,

On 21/06/2019 10:37, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing the following instructions in EL1 will trap to EL2:
> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
> ARM v8.3. The only instruction that was not undef is eret.
> 
> This patch sets up a handler for EL2 registers and SP_EL1 register
> accesses at EL1. The host hypervisor keeps those register values in
> memory, and will emulate their behavior.
> 
> This patch doesn't set the NV bit yet. It will be set in a later patch
> once nested virtualization support is completed.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 37 +++++++++++++++-
>   arch/arm64/include/asm/sysreg.h   | 50 ++++++++++++++++++++-
>   arch/arm64/kvm/sys_regs.c         | 74 ++++++++++++++++++++++++++++---
>   3 files changed, 154 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4bcd9c1291d5..2d4290d2513a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -173,12 +173,47 @@ enum vcpu_sysreg {
>   	APGAKEYLO_EL1,
>   	APGAKEYHI_EL1,
>   
> -	/* 32bit specific registers. Keep them at the end of the range */
> +	/* 32bit specific registers. */
>   	DACR32_EL2,	/* Domain Access Control Register */
>   	IFSR32_EL2,	/* Instruction Fault Status Register */
>   	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
>   	DBGVCR32_EL2,	/* Debug Vector Catch Register */
>   
> +	/* EL2 registers sorted ascending by Op0, Op1, CRn, CRm, Op2 */
> +	FIRST_EL2_SYSREG,
> +	VPIDR_EL2 = FIRST_EL2_SYSREG,
> +			/* Virtualization Processor ID Register */
> +	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
> +	SCTLR_EL2,	/* System Control Register (EL2) */
> +	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
> +	HCR_EL2,	/* Hypervisor Configuration Register */
> +	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
> +	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
> +	HSTR_EL2,	/* Hypervisor System Trap Register */
> +	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
> +	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
> +	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
> +	TCR_EL2,	/* Translation Control Register (EL2) */
> +	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
> +	VTCR_EL2,	/* Virtualization Translation Control Register */
> +	SPSR_EL2,	/* EL2 saved program status register */
> +	ELR_EL2,	/* EL2 exception link register */
> +	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
> +	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
> +	ESR_EL2,	/* Exception Syndrome Register (EL2) */
> +	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
> +	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
> +	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
> +	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
> +	VBAR_EL2,	/* Vector Base Address Register (EL2) */
> +	RVBAR_EL2,	/* Reset Vector Base Address Register */
> +	RMR_EL2,	/* Reset Management Register */
> +	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
> +	TPIDR_EL2,	/* EL2 Software Thread ID Register */
> +	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
> +	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
> +	SP_EL2,		/* EL2 Stack Pointer */

Does it need to include the following registers Counter-timer Hyp Physical timer
registers ? i.e, CNTHP_{CTL,CVAL,TVAL}_EL2. Or do we have some other magic with
NV for the virtual EL2 ?

Cheers
Suzuki

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

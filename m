Return-Path: <SRS0=WMPN=HA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26220C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 18:05:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8EF6664E0B
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 18:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EF6664E0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5BAD4B13B;
	Fri, 29 Jan 2021 13:05:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jwJslz7bODZq; Fri, 29 Jan 2021 13:05:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A17884B143;
	Fri, 29 Jan 2021 13:05:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C54E4B124
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 13:05:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id te3gsuiOJJHL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2021 13:05:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7524B119
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 13:05:41 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B77713A1;
 Fri, 29 Jan 2021 10:05:40 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48D333F885;
 Fri, 29 Jan 2021 10:05:38 -0800 (PST)
Date: Fri, 29 Jan 2021 18:04:52 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 05/66] KVM: arm64: nv: Add EL2 system registers to
 vcpu context
Message-ID: <20210129180452.6d527e91@slackpad.fritz.box>
In-Reply-To: <20201210160002.1407373-6-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
 <20201210160002.1407373-6-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
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

On Thu, 10 Dec 2020 15:59:01 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi,

> Add the minimal set of EL2 system registers to the vcpu context.
> Nothing uses them just yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Checked against the ARM ARM that this list contains the _EL2 registers
available in ARMv8.1, minus timer and GIC registers.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre 

> ---
>  arch/arm64/include/asm/kvm_host.h | 34 ++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 11beda85ee7e..d731cf7a56cb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -206,12 +206,44 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> -	/* 32bit specific registers. Keep them at the end of the range */
> +	/* 32bit specific registers. */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
>  	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
>  	DBGVCR32_EL2,	/* Debug Vector Catch Register */
>  
> +	/* EL2 registers */
> +	VPIDR_EL2,	/* Virtualization Processor ID Register */
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
> +	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
> +	SP_EL2,		/* EL2 Stack Pointer */
> +
>  	NR_SYS_REGS	/* Nothing after this line! */
>  };
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

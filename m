Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE09C4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:07:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68DE52242A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68DE52242A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E1A4B4FB;
	Mon, 26 Oct 2020 10:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XUEXqUHqdeC7; Mon, 26 Oct 2020 10:07:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21CC34B4EB;
	Mon, 26 Oct 2020 10:07:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92634B4E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:07:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d3aSGeL747Nr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:07:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C47714B4DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:07:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A97730E;
 Mon, 26 Oct 2020 07:07:26 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A86F03F68F;
 Mon, 26 Oct 2020 07:07:24 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:07:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/11] KVM: arm64: Move VHE direct sysreg accessors into
 kvm_host.h
Message-ID: <20201026140721.GG12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-6-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
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

On Mon, Oct 26, 2020 at 01:34:44PM +0000, Marc Zyngier wrote:
> As we are about to need to access system registers from the HYP
> code based on their internal encoding, move the direct sysreg
> accessors to a common include file.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/kvm_host.h | 85 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 81 -----------------------------
>  2 files changed, 85 insertions(+), 81 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9a75de3ad8da..0ae51093013d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -438,6 +438,91 @@ struct kvm_vcpu_arch {
>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
>  void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
>  
> +static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
> +{
> +	/*
> +	 * *** VHE ONLY ***
> +	 *
> +	 * System registers listed in the switch are not saved on every
> +	 * exit from the guest but are only saved on vcpu_put.
> +	 *
> +	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
> +	 * should never be listed below, because the guest cannot modify its
> +	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
> +	 * thread when emulating cross-VCPU communication.
> +	 */
> +	switch (reg) {
> +	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
> +	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
> +	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
> +	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
> +	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
> +	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
> +	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
> +	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
> +	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
> +	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
> +	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
> +	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
> +	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
> +	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
> +	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
> +	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
> +	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
> +	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
> +	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
> +	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
> +	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
> +	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
> +	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
> +	default:		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
> +{
> +	/*
> +	 * *** VHE ONLY ***
> +	 *
> +	 * System registers listed in the switch are not restored on every
> +	 * entry to the guest but are only restored on vcpu_load.
> +	 *
> +	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
> +	 * should never be listed below, because the MPIDR should only be set
> +	 * once, before running the VCPU, and never changed later.
> +	 */
> +	switch (reg) {
> +	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
> +	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
> +	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
> +	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
> +	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
> +	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
> +	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
> +	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
> +	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
> +	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
> +	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
> +	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
> +	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
> +	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
> +	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
> +	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
> +	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
> +	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
> +	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
> +	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
> +	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
> +	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
> +	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
> +	default:		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * CP14 and CP15 live in the same array, as they are backed by the
>   * same system registers.
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 01f63027cf40..f7415c9dbcd9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -64,87 +64,6 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> -static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
> -{
> -	/*
> -	 * System registers listed in the switch are not saved on every
> -	 * exit from the guest but are only saved on vcpu_put.
> -	 *
> -	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
> -	 * should never be listed below, because the guest cannot modify its
> -	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
> -	 * thread when emulating cross-VCPU communication.
> -	 */
> -	switch (reg) {
> -	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
> -	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
> -	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
> -	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
> -	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
> -	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
> -	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
> -	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
> -	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
> -	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
> -	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
> -	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
> -	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
> -	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
> -	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
> -	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
> -	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
> -	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
> -	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
> -	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
> -	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
> -	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
> -	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
> -	default:		return false;
> -	}
> -
> -	return true;
> -}
> -
> -static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
> -{
> -	/*
> -	 * System registers listed in the switch are not restored on every
> -	 * entry to the guest but are only restored on vcpu_load.
> -	 *
> -	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
> -	 * should never be listed below, because the MPIDR should only be set
> -	 * once, before running the VCPU, and never changed later.
> -	 */
> -	switch (reg) {
> -	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
> -	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
> -	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
> -	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
> -	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
> -	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
> -	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
> -	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
> -	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
> -	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
> -	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
> -	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
> -	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
> -	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
> -	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
> -	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
> -	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
> -	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
> -	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
> -	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
> -	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
> -	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
> -	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
> -	default:		return false;
> -	}
> -
> -	return true;
> -}
> -
>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>  {
>  	u64 val = 0x8badf00d8badf00d;
> -- 
> 2.28.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

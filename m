Return-Path: <SRS0=ZPfy=BI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7463C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 16:38:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69FEC206D8
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 16:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69FEC206D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A124B288;
	Wed, 29 Jul 2020 12:38:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9zIWeWsP3DvF; Wed, 29 Jul 2020 12:38:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624084B462;
	Wed, 29 Jul 2020 12:38:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECD04B288
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 12:38:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 65A21IWKHTM2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jul 2020 12:38:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EBF74B278
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 12:38:05 -0400 (EDT)
Received: from gaia (unknown [95.146.230.158])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D80AF206D8;
 Wed, 29 Jul 2020 16:38:02 +0000 (UTC)
Date: Wed, 29 Jul 2020 17:38:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200729163800.GA24572@gaia>
References: <20200717205233.903344-1-robh@kernel.org>
 <20200717205233.903344-4-robh@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717205233.903344-4-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jul 17, 2020 at 02:52:33PM -0600, Rob Herring wrote:
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index ce3080834bfa..ce5b0d9b12bf 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -46,6 +46,17 @@
>  #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
>  #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
>  
> +static inline u64 __hyp_text read_sysreg_par(void)
> +{
> +	u64 par;
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +		dmb(sy);
> +	par = read_sysreg(par_el1);
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +		dmb(sy);
> +	return par;
> +}

Even if that's not always called on a critical path, I agree with Andrew
that we could use alternatives here for dmb(sy).

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index baf5ce9225ce..3f798e0f1419 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -94,10 +94,16 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>  	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
>  	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
>  	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
> -	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
>  	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
>  	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
>  	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
> +	case PAR_EL1:
> +		if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +			dmb(sy);
> +		*val = read_sysreg_s(SYS_PAR_EL1);
> +		if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +			dmb(sy);
> +		break;
>  	default:		return false;
>  	}

Can't we use read_sysreg_par() directly here?

> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 8afb238ff335..98609532e61a 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -260,7 +260,17 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>  	local_irq_save(flags);
>  	asm volatile("at s1e1r, %0" :: "r" (addr));
>  	isb();
> +	/*
> +	 * Arm Erratum 1508412 requires dmb(sy) before and after reads of
> +	 * PAR_EL1.
> +	 * As this location is not a hot path, just condition it on the config
> +	 * option.
> +	 */
> +	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> +		dmb(sy);
>  	par = read_sysreg(par_el1);
> +	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> +		dmb(sy);
>  	local_irq_restore(flags);

Why not read_sysreg_par()?

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

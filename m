Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4C3C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:31:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE7BC64F69
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE7BC64F69
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E7A4B65F;
	Wed, 17 Mar 2021 10:31:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2UtrruhDpSm1; Wed, 17 Mar 2021 10:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECB9A4B441;
	Wed, 17 Mar 2021 10:31:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDD34B3EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:31:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7+e4tE9HgpZy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:31:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F54B4B3C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:31:08 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D7564F67;
 Wed, 17 Mar 2021 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615991467;
 bh=S3JhTXMjWji0Vcn4IbAXOL+PlkhYOkccvDgq5tIxZqM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gd5K9dwWeW2twuwVtOVTybSn0Rqnktu+3VRkcDDcJgl6cF2ca31aWt3NmbaIX1Xbu
 ilH4P4RBMyK1XbcM5G8Dpb24Pl3hNhzT5NTjwWj7SxawhsmPo3ypEcANPLluaSxdI3
 ei7+x9WhQ1cEPUOAFGiehQyU7PYF3tigFiqPPrRgPPflrbED96mHMdDQm7UIS+kQzO
 l1+BtZcDiLs3y3yBuMgZVfzxrAyzeg3EXFgNsOTkEeKTEvnCtuw57XwNK7YstnV7Kb
 3YCo+8iFAP+9mouFphJjh/NtqgxM7QlAxvFU6QR0BvnPmqzqku1+Xcd48EUiL+6B7U
 CVdBJnBOeOnJA==
Date: Wed, 17 Mar 2021 14:31:01 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/10] KVM: arm64: Use {read,write}_sysreg_el1 to access
 ZCR_EL1
Message-ID: <20210317143101.GC5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tue, Mar 16, 2021 at 10:13:04AM +0000, Marc Zyngier wrote:
> Switch to the unified EL1 accessors for ZCR_EL1, which will make
> things easier for nVHE support.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c                 | 3 ++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 3e081d556e81..b7e36a506d3d 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -11,6 +11,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/fpsimd.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> @@ -112,7 +113,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  		fpsimd_save_and_flush_cpu_state();
>  
>  		if (guest_has_sve)
> -			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
> +			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>  	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 807bc4734828..d762d5bdc2d5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -269,7 +269,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  		__sve_restore_state(vcpu_sve_pffr(vcpu),
>  				    &vcpu->arch.ctxt.fp_regs.fpsr,
>  				    sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> -		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
>  	} else {
>  		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);

Looks straightforward enough:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

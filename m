Return-Path: <SRS0=xcs2=UY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0444C48BD5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 08:49:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63758215EA
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 08:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63758215EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97DD44A4A9;
	Tue, 25 Jun 2019 04:48:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EuG3aZxu+qrM; Tue, 25 Jun 2019 04:48:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370B64A445;
	Tue, 25 Jun 2019 04:48:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6754A409
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 04:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 62RXe-lChF6S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jun 2019 04:48:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 207A34A331
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 04:48:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88A232B;
 Tue, 25 Jun 2019 01:48:54 -0700 (PDT)
Received: from [10.37.8.194] (unknown [10.37.8.194])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E5D03F718;
 Tue, 25 Jun 2019 01:48:52 -0700 (PDT)
Subject: Re: [PATCH 16/59] KVM: arm64: nv: Save/Restore vEL2 sysregs
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-17-marc.zyngier@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <800f3e9a-5b67-951b-34c2-60367c0697f9@arm.com>
Date: Tue, 25 Jun 2019 09:48:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-17-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> Whenever we need to restore the guest's system registers to the CPU, we
> now need to take care of the EL2 system registers as well. Most of them
> are accessed via traps only, but some have an immediate effect and also
> a guest running in VHE mode would expect them to be accessible via their
> EL1 encoding, which we do not trap.
> 
> Split the current __sysreg_{save,restore}_el1_state() functions into
> handling common sysregs, then differentiate between the guest running in
> vEL2 and vEL1.
> 
> For vEL2 we write the virtual EL2 registers with an identical format directly
> into their EL1 counterpart, and translate the few registers that have a
> different format for the same effect on the execution when running a
> non-VHE guest guest hypervisor.
> 
>   [ Commit message reworked and many bug fixes applied by Marc Zyngier
>     and Christoffer Dall. ]
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 160 +++++++++++++++++++++++++++++++--
>  1 file changed, 153 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 62866a68e852..2abb9c3ff24f 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c

[...]

> @@ -124,10 +167,91 @@ static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
>  }
>  
> -static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> +static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
>  {
> +	u64 val;
> +
> +	write_sysreg(read_cpuid_id(),			vpidr_el2);
>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
> -	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> +	write_sysreg_el1(ctxt->sys_regs[MAIR_EL2],	SYS_MAIR);
> +	write_sysreg_el1(ctxt->sys_regs[VBAR_EL2],	SYS_VBAR);
> +	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL2],SYS_CONTEXTIDR);
> +	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL2],	SYS_AMAIR);
> +
> +	if (__vcpu_el2_e2h_is_set(ctxt)) {
> +		/*
> +		 * In VHE mode those registers are compatible between
> +		 * EL1 and EL2.
> +		 */
> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
> +		write_sysreg_el1(ctxt->sys_regs[CPTR_EL2],	SYS_CPACR);
> +		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
> +		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
> +		write_sysreg_el1(ctxt->sys_regs[CNTHCTL_EL2],	SYS_CNTKCTL);
> +	} else {
> +		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
> +				 SYS_SCTLR);
> +		write_sysreg_el1(translate_cptr(ctxt->sys_regs[CPTR_EL2]),
> +				 SYS_CPACR);
> +		write_sysreg_el1(translate_ttbr0(ctxt->sys_regs[TTBR0_EL2]),
> +				 SYS_TTBR0);
> +		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
> +				 SYS_TCR);
> +		write_sysreg_el1(translate_cnthctl(ctxt->sys_regs[CNTHCTL_EL2]),
> +				 SYS_CNTKCTL);
> +	}
> +
> +	/*
> +	 * These registers can be modified behind our back by a fault
> +	 * taken inside vEL2. Save them, always.
> +	 */
> +	write_sysreg_el1(ctxt->sys_regs[ESR_EL2],	SYS_ESR);
> +	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL2],	SYS_AFSR0);
> +	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL2],	SYS_AFSR1);
> +	write_sysreg_el1(ctxt->sys_regs[FAR_EL2],	SYS_FAR);
> +	write_sysreg(ctxt->sys_regs[SP_EL2],		sp_el1);
> +	write_sysreg_el1(ctxt->sys_regs[ELR_EL2],	SYS_ELR);
> +
> +	val = __fixup_spsr_el2_write(ctxt, ctxt->sys_regs[SPSR_EL2]);
> +	write_sysreg_el1(val,	SYS_SPSR);
> +}
> +
> +static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
> +{
> +	u64 mpidr;
> +
> +	if (has_vhe()) {
> +		struct kvm_vcpu *vcpu;
> +
> +		/*
> +		 * Warning: this hack only works on VHE, because we only
> +		 * call this with the *guest* context, which is part of
> +		 * struct kvm_vcpu. On a host context, you'd get pure junk.
> +		 */
> +		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);

This seems very fragile, just to find out whether the guest has hyp
capabilities. It would be at least nice to make sure this is indeed a
guest context.

The *clean* way to do it could be to have a pointer to kvm_vcpu in the
kvm_cpu_context which would be NULL for host contexts.

Otherwise, I'm under the impression that for a host context,
ctxt->sys_reg[HCR_EL2] == 0 and that this would also be true for a guest
without nested virt capability. Could we use something like that here?

Cheers,

Julien
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

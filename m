Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA515C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 11:10:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 378B240066;
	Fri,  4 Feb 2022 06:10:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eylX5SpMatcd; Fri,  4 Feb 2022 06:10:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E0BF40C95;
	Fri,  4 Feb 2022 06:10:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6D1D40C95
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 06:10:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7sESRVyCw1v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 06:10:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDA140066
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 06:10:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AF441435;
 Fri,  4 Feb 2022 03:10:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BEE53F774;
 Fri,  4 Feb 2022 03:10:17 -0800 (PST)
Date: Fri, 4 Feb 2022 11:10:35 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 20/64] KVM: arm64: nv: Trap CPACR_EL1 access in
 virtual EL2
Message-ID: <Yf0Jm4vUNrnTcylS@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-21-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-21-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

Hi Marc,

This also what Arm ARM recommends for a guest with HCR_EL2.E2H = 0 in section
D5.7.1 "Armv8.3 nested virtualization functionality".

The L1 guest hypervisor running at virtual EL2 is restoring the guest context at
EL1, but the host is actually running in hardware EL1 and the register access
needs to be trapped because it affects the guest hypervisor. And because the L0
host is running with HCR_EL2.E2H = 1, writes to CPACR_EL1 are redirected to
CPTR_EL2.

Also the reset value is correct, as CPACR_EL1 either has RES0 or UNKNOWN fields
are reset.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Jan 28, 2022 at 12:18:28PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> For the same reason we trap virtual memory register accesses in virtual
> EL2, we trap CPACR_EL1 access too; We allow the virtual EL2 mode to
> access EL1 system register state instead of the virtual EL2 one.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
>  arch/arm64/kvm/sys_regs.c       | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 6ed9e4893a02..1e6a00e7bfb3 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -64,6 +64,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  		__activate_traps_fpsimd32(vcpu);
>  	}
>  
> +	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> +		val |= CPTR_EL2_TCPAC;
> +	
>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4f2bcc1e0c25..7f074a7f6eb3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1819,7 +1819,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
>  	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
> -	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> +	{ SYS_DESC(SYS_CPACR_EL1), access_rw, reset_val, CPACR_EL1, 0 },
>  
>  	MTE_REG(RGSR_EL1),
>  	MTE_REG(GCR_EL1),
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

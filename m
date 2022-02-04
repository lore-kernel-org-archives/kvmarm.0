Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8755DC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 14:02:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F0141016;
	Fri,  4 Feb 2022 09:02:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Un2qlhVD7SR0; Fri,  4 Feb 2022 09:02:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7804241003;
	Fri,  4 Feb 2022 09:02:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58F6D41003
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 09:02:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QBMr3bJoci8D for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 09:02:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 908BC40066
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 09:02:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C563311D4;
 Fri,  4 Feb 2022 06:02:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0767A3F40C;
 Fri,  4 Feb 2022 06:02:02 -0800 (PST)
Date: Fri, 4 Feb 2022 14:02:12 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 21/64] KVM: arm64: nv: Handle PSCI call via smc from
 the guest
Message-ID: <Yf0x5Nx18wjvnUUw@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-22-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-22-maz@kernel.org>
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

The patch looks good to me. Checked kvm_hvc_call_handler(), it returns -1
only when kvm_psci_call() doesn't handle the function and
PSCI_RET_NOT_SUPPORTED must be set by the caller (which is handle_smc).

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Jan 28, 2022 at 12:18:29PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> VMs used to execute hvc #0 for the psci call if EL3 is not implemented.
> However, when we come to provide the virtual EL2 mode to the VM, the
> host OS inside the VM calls kvm_call_hyp() which is also hvc #0. So,
> it's hard to differentiate between them from the host hypervisor's point
> of view.
> 
> So, let the VM execute smc instruction for the psci call. On ARMv8.3,
> even if EL3 is not implemented, a smc instruction executed at non-secure
> EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than being treated as
> UNDEFINED. So, the host hypervisor can handle this psci call without any
> confusion.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 2bbeed8c9786..0cedef6e0d80 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -62,6 +62,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
>  
>  static int handle_smc(struct kvm_vcpu *vcpu)
>  {
> +	int ret;
> +
>  	/*
>  	 * "If an SMC instruction executed at Non-secure EL1 is
>  	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
> @@ -69,10 +71,28 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>  	 *
>  	 * We need to advance the PC after the trap, as it would
>  	 * otherwise return to the same address...
> +	 *
> +	 * If imm is non-zero, it's not defined, so just skip it.
> +	 */
> +	if (kvm_vcpu_hvc_get_imm(vcpu)) {
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +		kvm_incr_pc(vcpu);
> +		return 1;
> +	}
> +
> +	/*
> +	 * If imm is zero, it's a psci call.
> +	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
> +	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
> +	 * being treated as UNDEFINED.
>  	 */
> -	vcpu_set_reg(vcpu, 0, ~0UL);
> +	ret = kvm_hvc_call_handler(vcpu);
> +	if (ret < 0)
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +
>  	kvm_incr_pc(vcpu);
> -	return 1;
> +
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Save ESR_EL2 on guest SError
Date: Tue, 31 Oct 2017 04:26:01 +0000
Message-ID: <86po943puu.fsf@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-18-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E6349D20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 00:24:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OfTF0EvmI4jO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 00:24:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4DED49D13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 00:24:31 -0400 (EDT)
In-Reply-To: <20171019145807.23251-18-james.morse@arm.com> (James Morse's
 message of "Thu, 19 Oct 2017 15:58:03 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19 2017 at  4:58:03 pm BST, James Morse <james.morse@arm.com> wrote:
> When we exit a guest due to an SError the vcpu fault info isn't updated
> with the ESR. Today this is only done for traps.
>
> The v8.2 RAS Extensions define ISS values for SError. Update the vcpu's
> fault_info with the ESR on SError so that handle_exit() can determine
> if this was a RAS SError and decode its severity.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index af37658223a0..cba6d8ac105c 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -230,13 +230,20 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	return true;
>  }
>  
> +static void __hyp_text __populate_fault_info_esr(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
> +}
> +
>  static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  {
> -	u64 esr = read_sysreg_el2(esr);
> -	u8 ec = ESR_ELx_EC(esr);
> +	u8 ec;
> +	u64 esr;
>  	u64 hpfar, far;
>  
> -	vcpu->arch.fault.esr_el2 = esr;
> +	__populate_fault_info_esr(vcpu);
> +	esr = vcpu->arch.fault.esr_el2;
> +	ec = ESR_ELx_EC(esr);
>  
>  	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
>  		return true;
> @@ -325,6 +332,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
>  		goto again;
> +	else if (ARM_EXCEPTION_CODE(exit_code) == ARM_EXCEPTION_EL1_SERROR)
> +		__populate_fault_info_esr(vcpu);
>  
>  	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
>  	    exit_code == ARM_EXCEPTION_TRAP) {

With this patch, the only case were we don't save ESR_EL2 is when we
take an interrupt. I think we should bite the bullet and make it
slightly more streamlined, always saving ESR_EL2.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.

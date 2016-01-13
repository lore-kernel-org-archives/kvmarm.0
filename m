From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/3] KVM: ARM64: Fix wrong use of the CPSR MODE mask
Date: Wed, 13 Jan 2016 09:31:53 +0000
Message-ID: <56961989.9080404@arm.com>
References: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
 <1452676601-14796-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5B249B17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:27:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U0hNTXxyzSR8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 04:27:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B5C49B08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:27:51 -0500 (EST)
In-Reply-To: <1452676601-14796-2-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/01/16 09:16, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> The values of CPSR MODE mask are different between aarch32 and aarch64.
> It should use the right one according to the execution state.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 3066328..779a587 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -127,10 +127,14 @@ static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
>  
>  static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
>  {
> -	u32 mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
> +	u32 mode;
>  
> -	if (vcpu_mode_is_32bit(vcpu))
> +	if (vcpu_mode_is_32bit(vcpu)) {
> +		mode = *vcpu_cpsr(vcpu) & COMPAT_PSR_MODE_MASK;
>  		return mode > COMPAT_PSR_MODE_USR;
> +	}
> +
> +	mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
>  
>  	return mode != PSR_MODE_EL0t;
>  }
> 

Nice catch. At the moment, it will only affect perf's is_user_mode()
with a 32bit guest (always reporting the guest as running in kernel
mode), so that's not a big deal with mainline (but it clearly has a much
bigger implication with the PMU support).

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

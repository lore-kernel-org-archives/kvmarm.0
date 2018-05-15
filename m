From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v7 14/16] KVM: arm64: Remove redundant *exit_code changes
 in fpsimd_guest_exit()
Date: Tue, 15 May 2018 12:46:38 +0200
Message-ID: <20180515104638.GB38551@C02W217FHV2R.local>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-15-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 05:13:03PM +0100, Dave Martin wrote:
> In fixup_guest_exit(), there are a couple of cases where after
> checking what the exit code was, we assign it explicitly with the
> value it already had.
> 
> Assuming this is not indicative of a bug, these assignments are not
> needed.
> 
> This patch removes the redundant assignments, and simplifies some
> if-nesting that becomes trivial as a result.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index a6a8c7d..18d0faa 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -403,12 +403,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		if (valid) {
>  			int ret = __vgic_v2_perform_cpuif_access(vcpu);
>  
> -			if (ret == 1) {
> -				if (__skip_instr(vcpu))
> -					return true;
> -				else
> -					*exit_code = ARM_EXCEPTION_TRAP;
> -			}
> +			if (ret ==  1 && __skip_instr(vcpu))
> +				return true;
>  
>  			if (ret == -1) {
>  				/* Promote an illegal access to an
> @@ -430,12 +426,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
>  		int ret = __vgic_v3_perform_cpuif_access(vcpu);
>  
> -		if (ret == 1) {
> -			if (__skip_instr(vcpu))
> -				return true;
> -			else
> -				*exit_code = ARM_EXCEPTION_TRAP;
> -		}
> +		if (ret == 1 && __skip_instr(vcpu))
> +			return true;
>  	}
>  
>  	/* Return to the host kernel and handle the exit */

I can't seem to easily convince myself that we couldn't have the
ARM_EXIT_WITH_SERROR_BIT set here and thus instead should be using
ARM_EXCEPTION_CODE() in the upper check.

Marc, can you help?

Thanks,
-Christoffer

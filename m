From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix PSCI affinity info return value for
 non valid cores
Date: Fri, 4 Sep 2015 16:55:28 +0100
Message-ID: <20150904155528.GA6390@leverpostej>
References: <1441379184-16749-1-git-send-email-a.spyridakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441379184-16749-1-git-send-email-a.spyridakis@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 04, 2015 at 04:06:24PM +0100, Alexander Spyridakis wrote:
> If a guest requests the affinity info for a non-existing vCPU we need to
> properly return an error, instead of erroneously reporting an off state.
> 
> Signed-off-by: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
> Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>

This looks correct to me per the PSCI 0.2 spec:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Was this spotted by inspection, or do you have some client for which
this is important?

Thanks,
Mark.

> ---
>  arch/arm/kvm/psci.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> index 4b94b51..ad6f642 100644
> --- a/arch/arm/kvm/psci.c
> +++ b/arch/arm/kvm/psci.c
> @@ -126,7 +126,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  
>  static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  {
> -	int i;
> +	int i, matching_cpus = 0;
>  	unsigned long mpidr;
>  	unsigned long target_affinity;
>  	unsigned long target_affinity_mask;
> @@ -151,12 +151,16 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_for_each_vcpu(i, tmp, kvm) {
>  		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
> -		if (((mpidr & target_affinity_mask) == target_affinity) &&
> -		    !tmp->arch.pause) {
> -			return PSCI_0_2_AFFINITY_LEVEL_ON;
> +		if ((mpidr & target_affinity_mask) == target_affinity) {
> +			matching_cpus++;
> +			if (!tmp->arch.pause)
> +				return PSCI_0_2_AFFINITY_LEVEL_ON;
>  		}
>  	}
>  
> +	if (!matching_cpus)
> +		return PSCI_RET_INVALID_PARAMS;
> +
>  	return PSCI_0_2_AFFINITY_LEVEL_OFF;
>  }
>  
> -- 
> 2.5.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

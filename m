From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v6 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Wed, 27 Mar 2019 09:47:42 +0000
Message-ID: <612e5089-fc43-eee4-1856-cdca89ce3b50@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-20-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7422A4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 05:47:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id czL8K5GpzASp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 05:47:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25FC04A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 05:47:48 -0400 (EDT)
In-Reply-To: <1553017938-710-20-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 19/03/2019 17:52, Dave Martin wrote:
> This patch includes the SVE register IDs in the list returned by
> KVM_GET_REG_LIST, as appropriate.
> 
> On a non-SVE-enabled vcpu, no new IDs are added.
> 
> On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
> from the list, since userspace is required to access the Z-
> registers instead in order to access the V-register content.  For
> the variably-sized SVE registers, the appropriate set of slice IDs
> are enumerated, depending on the maximum vector length for the
> vcpu.
> 
> As it currently stands, the SVE architecture never requires more
> than one slice to exist per register, so this patch adds no
> explicit support for enumerating multiple slices.  The code can be
> extended straightforwardly to support this in the future, if
> needed.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

> ---
> 
> Changes since v5:
> 
> (Dropped Julien Thierry's Reviewed-by due to non-trivial rebasing)
> 
>  * Move mis-split reword to prevent put_user()s being accidentally the
>    correct size from KVM: arm64/sve: Add pseudo-register for the guest's
>    vector lengths.
> ---
>  arch/arm64/kvm/guest.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 736d8cb..585c31e5 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -411,6 +411,56 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
>  }
>  
> +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> +{
> +	/* Only the first slice ever exists, for now */
> +	const unsigned int slices = 1;

Nit: Might be worth introducing a macro/inline function for the number
of slices supported. This way, the day we need to change that, we only
need to look for that identifier.

Cheers,

-- 
Julien Thierry

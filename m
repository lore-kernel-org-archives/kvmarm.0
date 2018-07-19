From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 10/16] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Thu, 19 Jul 2018 13:08:10 +0200
Message-ID: <20180719110810.2edkoz53b6vrafum@kamzik.brq.redhat.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-11-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D920A49F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 06:55:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KRxN7VZw1-0h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 06:55:07 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C255E40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 06:55:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-11-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 03:57:34PM +0100, Dave Martin wrote:
> Since SVE will be enabled or disabled on a per-vcpu basis, a flag
> is needed in order to track which vcpus have it enabled.
> 
> This patch adds a suitable flag and a helper for checking it.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9671ddd..609d08b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -308,6 +308,14 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
>  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> +
> +static inline bool vcpu_has_sve(struct kvm_vcpu_arch const *vcpu_arch)
> +{
> +	return system_supports_sve() &&

system_supports_sve() checks cpus_have_const_cap(), not
this_cpu_has_cap(), so, iiuc, the result of this check won't
change, regardless of which cpu it's run on at the time.

> +		(vcpu_arch->flags & KVM_ARM64_GUEST_HAS_SVE);

Since this flag can only be set if system_supports_sve() is
true at vcpu init time, then it isn't necessary to always check
system_supports_sve() in this function. Or, should
system_supports_sve() be changed to use this_cpu_has_cap()?

Thanks,
drew

> +
> +}
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

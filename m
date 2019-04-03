From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 09/27] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Wed, 3 Apr 2019 21:14:13 +0200
Message-ID: <20190403191413.5s6o4jruuijrdtgg@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B614A41A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 15:14:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CE2i5Q1yxZuD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Apr 2019 15:14:30 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09C964A369
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 15:14:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553864452-15080-10-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:34PM +0000, Dave Martin wrote:
> Since SVE will be enabled or disabled on a per-vcpu basis, a flag
> is needed in order to track which vcpus have it enabled.
> =

> This patch adds a suitable flag and a helper for checking it.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 6d10100..ad4f7f0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -328,6 +328,10 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
>  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> +
> +#define vcpu_has_sve(vcpu) (system_supports_sve() && \
> +			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))

We shouldn't need the system_supports_sve() here. vcpu->arch.flags can
only have the KVM_ARM64_GUEST_HAS_SVE flag set when system_supports_sve()
is true, and it can't change later.

Thanks,
drew

>  =

>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  =

> -- =

> 2.1.4
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

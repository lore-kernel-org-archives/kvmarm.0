From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 10/16] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Wed, 25 Jul 2018 12:41:06 +0100
Message-ID: <20180725114103.GG4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-11-git-send-email-Dave.Martin@arm.com>
 <20180719110810.2edkoz53b6vrafum@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D147940672
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:41:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wXSbmCNWKXkM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 07:41:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC6C40493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:41:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719110810.2edkoz53b6vrafum@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 01:08:10PM +0200, Andrew Jones wrote:
> On Thu, Jun 21, 2018 at 03:57:34PM +0100, Dave Martin wrote:
> > Since SVE will be enabled or disabled on a per-vcpu basis, a flag
> > is needed in order to track which vcpus have it enabled.
> > 
> > This patch adds a suitable flag and a helper for checking it.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 9671ddd..609d08b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -308,6 +308,14 @@ struct kvm_vcpu_arch {
> >  #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
> >  #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
> >  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> > +#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> > +
> > +static inline bool vcpu_has_sve(struct kvm_vcpu_arch const *vcpu_arch)
> > +{
> > +	return system_supports_sve() &&
> 
> system_supports_sve() checks cpus_have_const_cap(), not
> this_cpu_has_cap(), so, iiuc, the result of this check won't
> change, regardless of which cpu it's run on at the time.

That's correct: this is intentional.

If any physical cpu doesn't have SVE, we treat it is absent from the
whole system, and we don't permit its use.  This ensures that any task
or vcpu can always be migrated to any physical cpu.
> 
> > +		(vcpu_arch->flags & KVM_ARM64_GUEST_HAS_SVE);
> 
> Since this flag can only be set if system_supports_sve() is
> true at vcpu init time, then it isn't necessary to always check
> system_supports_sve() in this function. Or, should
> system_supports_sve() be changed to use this_cpu_has_cap()?

The main purpose of system_supports_sve() here is to shadow the check on
vcpu_arch->flags with a static branch.  If the system doesn't support
SVE, we don't pay the runtime cost of the dynamic check on
vcpu_arch->flags.

If the kernel is built with CONFIG_ARM64_SVE=n, the dynamic check should
be entirely optimised away by the compiler.

I'd rather not add an explicit comment for this because the same
convention is followed elsewhere -- thus for consistency the comment
would need to be added in a lot of places.

Cheers
---Dave

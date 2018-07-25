From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 10/16] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Wed, 25 Jul 2018 12:48:12 +0100
Message-ID: <20180725114812.GI4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-11-git-send-email-Dave.Martin@arm.com>
 <20180719150244.cybuq65qc6pt7hek@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2870440A50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:48:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BBzRsL-gCNcb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 07:48:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1690D40493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:48:17 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719150244.cybuq65qc6pt7hek@kamzik.brq.redhat.com>
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

On Thu, Jul 19, 2018 at 05:02:44PM +0200, Andrew Jones wrote:
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
> 
> Shouldn't this vcpu function take a vcpu instead of a vcpu_arch?

Logically it could.  There was some circular include issue that made it
tricky to get the definition of struct kvm_vcpu here, but I may have
another go at it.

Cheers
---Dave

From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 23/26] KVM: arm64/sve: Allow userspace to enable SVE
 for vcpus
Date: Tue, 26 Feb 2019 12:13:55 +0000
Message-ID: <20190226121355.GU3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-24-git-send-email-Dave.Martin@arm.com>
 <88f7a00d-019a-5ed3-5a80-6032775dc5c5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F344A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:14:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aT+M076f8yr8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:13:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D66FE49E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <88f7a00d-019a-5ed3-5a80-6032775dc5c5@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 09:05:16AM +0000, Julien Thierry wrote:
> Hi Dave,
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> > Now that all the pieces are in place, this patch offers a new flag
> > KVM_ARM_VCPU_SVE that userspace can pass to KVM_ARM_VCPU_INIT to
> > turn on SVE for the guest, on a per-vcpu basis.
> > 
> > As part of this, support for initialisation and reset of the SVE
> > vector length set and registers is added in the appropriate places.
> > Allocation SVE registers is deferred until kvm_arm_vcpu_finalize(),
> > by which time the size of the registers is known.
> > 
> > Setting the vector lengths supported by the vcpu is considered
> > configuration of the emulated hardware rather than runtime
> > configuration, so no support is offered for changing the vector
> > lengths of an existing vcpu across reset.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Changes since v4:
> > 
> >  * Pull out vcpu_sve_state_size(), for use earlier in the series.
> > 
> >  * Remove unnecessary vcpu->arch.sve_vqs[], and clamp maximum guest
> >    vector length to 256 bytes for forwards compatibility.
> > 
> >    (See "KVM: arm64/sve: Add pseudo-register for the guest's vector
> >    lengths".)
> > 
> >  * Minor tidyups to make some checks less verbose.
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +-
> >  arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  arch/arm64/kvm/reset.c            | 70 ++++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 71 insertions(+), 2 deletions(-)

[...]

> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c

[...]

> >  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu)
> >  {
> >  	if (likely(kvm_arm_vcpu_finalized(vcpu)))
> >  		return 0;
> >  
> > +	if (vcpu_has_sve(vcpu)) {
> > +		size_t size = vcpu_sve_state_size(vcpu);
> > +
> > +		if (!size)
> > +			return -EINVAL;
> > +
> > +		vcpu->arch.sve_state = kzalloc(size, GFP_KERNEL);
> 
> We should probably free this in kvm_arch_vcpu_free().

Hmmm, good spot!

Looks like I lost that during a previous rebase.

Cheers
---Dave

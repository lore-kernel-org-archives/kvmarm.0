From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Thu, 28 Mar 2019 12:27:03 +0000
Message-ID: <20190328122702.GB3567@e103592.cambridge.arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-20-git-send-email-Dave.Martin@arm.com>
 <612e5089-fc43-eee4-1856-cdca89ce3b50@arm.com>
 <20190327103319.GT3567@e103592.cambridge.arm.com>
 <71c30b21-9a4b-42d5-02a8-25bc18044c1f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3FF84A2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 08:27:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwmrUNh9CP3O for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 08:27:08 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 549C84A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 08:27:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <71c30b21-9a4b-42d5-02a8-25bc18044c1f@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 27, 2019 at 03:21:02PM +0000, Julien Thierry wrote:
> 
> 
> On 27/03/2019 10:33, Dave Martin wrote:
> > On Wed, Mar 27, 2019 at 09:47:42AM +0000, Julien Thierry wrote:
> >> Hi Dave,
> >>
> >> On 19/03/2019 17:52, Dave Martin wrote:

[...]

> >>> +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	/* Only the first slice ever exists, for now */
> >>> +	const unsigned int slices = 1;
> >>
> >> Nit: Might be worth introducing a macro/inline function for the number
> >> of slices supported. This way, the day we need to change that, we only
> >> need to look for that identifier.
> > 
> > ... Reasonable point, but I wanted to avoid inventing anything
> > prematurely, partly because sve_reg_to_region() will need work in order
> > to support multiple slices (though it's not rocket science).
> > 
> > I could introduce something like the following:
> > 
> > static unsigned int sve_num_slices(const struct kvm_vcpu *vcpu)
> > {
> > 	unsigned int slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0));
> > 	unsigned int slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl, slice_size);
> > 
> > 	/*
> > 	 * For now, the SVE register ioctl access code won't work
> > 	 * properly with multiple register slices.  KVM should prevent
> > 	 * configuration of a vcpu with a maximum vector length large
> > 	 * enough to trigger this:
> > 	 */
> > 	if (WARN_ON_ONCE(slices > 1))
> > 		return 1;
> > 
> > 	return slices;
> > }
> > 
> > This may be clearer, but felt a bit like overkill...
> > 
> > Thoughts?
> 
> Seems a bit overkill yes... I was more thinking of a define and the
> person in charge of adding the slice support would just need to look for
> references to that define to know (some of) the places that would need
> rework/review.
> 
> So, unless someone else thinks it's good to introduce it right now you
> can ignore that.

OK, how about the following?  This keeps things minimal, but should help
future maintainers know that something may need updating here in the
future. 

Cheers
---Dave


diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ea5219d..086ab05 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -289,6 +289,13 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define KVM_SVE_ZREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0))
 #define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
 
+/*
+ * number of register slices required to cover each whole SVE register on vcpu
+ * NOTE: If you are tempted to modify this, you must also rework
+ * sve_reg_to_region() to match:
+ */
+#define vcpu_sve_slices(vcpu) 1
+
 /* Bounds of a single SVE register slice within vcpu->arch.sve_state */
 struct sve_state_reg_region {
 	unsigned int koffset;	/* offset into sve_state in kernel memory */
@@ -505,7 +512,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
 	/* Only the first slice ever exists, for now */
-	const unsigned int slices = 1;
+	const unsigned int slices = vcpu_sve_slices(vcpu);
 
 	if (!vcpu_has_sve(vcpu))
 		return 0;
@@ -521,7 +528,7 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
 	/* Only the first slice ever exists, for now */
-	const unsigned int slices = 1;
+	const unsigned int slices = vcpu_sve_slices(vcpu);
 	u64 reg;
 	unsigned int i, n;
 	int num_regs = 0;

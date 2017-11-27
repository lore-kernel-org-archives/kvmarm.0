From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 08/37] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Mon, 27 Nov 2017 09:25:57 +0300
Message-ID: <20171126201352.yjcexe235azk3sdf@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-9-christoffer.dall@linaro.org>
 <20171125075221.oj5euwo7hnktxxsj@yury-thinkpad>
 <20171126161716.GK28855@cbox>
 <20171126185852.bjte7raycorctft2@yury-thinkpad>
 <20171126191834.GN28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171126191834.GN28855@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Nov 26, 2017 at 08:18:34PM +0100, Christoffer Dall wrote:
> On Sun, Nov 26, 2017 at 09:58:52PM +0300, Yury Norov wrote:
> > On Sun, Nov 26, 2017 at 05:17:16PM +0100, Christoffer Dall wrote:
> > > Hi Yury,
> > > 
> > > On Sat, Nov 25, 2017 at 10:52:21AM +0300, Yury Norov wrote:
> > > > 
> > > > On Thu, Oct 12, 2017 at 12:41:12PM +0200, Christoffer Dall wrote:
> > > > > Avoid saving the guest VFP registers and restoring the host VFP
> > > > > registers on every exit from the VM.  Only when we're about to run
> > > > > userspace or other threads in the kernel do we really have to switch the
> > > > > state back to the host state.
> > > > > 
> > > > > We still initially configure the VFP registers to trap when entering the
> > > > > VM, but the difference is that we now leave the guest state in the
> > > > > hardware registers while running the VM.
> > > > > 
> > > > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_emulate.h |  5 ++++
> > > > >  arch/arm64/include/asm/kvm_host.h    |  3 +++
> > > > >  arch/arm64/kernel/asm-offsets.c      |  1 +
> > > > >  arch/arm64/kvm/hyp/entry.S           |  3 +++
> > > > >  arch/arm64/kvm/hyp/switch.c          | 47 +++++++++++-------------------------
> > > > >  arch/arm64/kvm/hyp/sysreg-sr.c       | 21 +++++++++++++---
> > > > >  6 files changed, 44 insertions(+), 36 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > > > index 1fbfe96..630dd60 100644
> > > > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > > > @@ -56,6 +56,11 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> > > > >  	return (unsigned long *)&vcpu->arch.hcr_el2;
> > > > >  }
> > > > >  
> > > > > +static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	return (!(vcpu->arch.hcr_el2 & HCR_RW));
> > > > > +}
> > > > > +
> > > > >  static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
> > > > >  {
> > > > >  	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index 7d3bfa7..5e09eb9 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -210,6 +210,9 @@ struct kvm_vcpu_arch {
> > > > >  	/* Guest debug state */
> > > > >  	u64 debug_flags;
> > > > >  
> > > > > +	/* 1 if the guest VFP state is loaded into the hardware */
> > > > > +	u64 guest_vfp_loaded;
> > > > 
> > > > May it be just u8/bool?
> > > > 
> > > This particular field is accessed from assembly code, and I'm not sure
> > > what guarantees the compiler makes in terms of how a u8/bool is
> > > allocated with respect to padding and alignment, and I think that's why
> > > we've been using u64 fields in the past.
> > > 
> > > I don't actually remember the details, but I'd rather err on the side of
> > > caution than trying to save a few bytes.  However, if someone can
> > > convince me there's a completely safe way to do this, then I'm happy to
> > > change it.
> > 
> > 'strb     w0, [x3, #VCPU_GUEST_VFP_LOADED]' would work. See
> > C6.6.181 STRB (register) in ARM64 ARM.
> 
> I'm well aware of this instruction.  Thank you though.
> 
> The concern was that we haven't done this in the past.  I think that was
> because the size of a _Bool is not well-defined and we really didn't
> care about a couple of handful of bytes when talking about vcpu
> structures.  Really.
> 
> A u8 should work though, but probably this will all be moot if I combine
> the flags into a single field.
> 
> > 
> > The only thing I would recommend is to reorder fields in kvm_vcpu_arch
> > to avoid unneeded holes in the structure. It already spend 10 bytes for
> > nothing in 3 holes.
> > 
> Patches are welcome.

Heh :) I meant reordering only this field if it is changed.

If you want me to reorder the whole structure and remove all holes...

Patches of that sort (I mean moving fields here and there just to save
couple of bytes) are looking weird. At most because there is general
assumption that the hole exists because author prefers to have clean
logic in field order even with the cost of few holes. But if you give
me indulgence...

Nevertheless, for this specific structure:
Before:
/* size: 8176, cachelines: 128, members: 23 */
/* sum members: 8152, holes: 3, sum holes: 10 */
/* padding: 14 */
/* last cacheline: 48 bytes */

After:
/* size: 8160, cachelines: 128, members: 23 */
/* padding: 8 */
/* last cacheline: 32 bytes */

The patch is below.

Yury

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dcded44b4180..3739471c39ac 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -200,10 +200,6 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
-	u64 hcr_el2;
-	u32 mdcr_el2;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
@@ -249,6 +245,20 @@ struct kvm_vcpu_arch {
 	 * here.
 	 */
 
+	/* IO related fields */
+	struct kvm_decode mmio_decode;
+
+	/* Cache some mmu pages needed inside spinlock regions */
+	struct kvm_mmu_memory_cache mmu_page_cache;
+
+	/* HYP configuration */
+	u64 hcr_el2;
+	u32 mdcr_el2;
+
+	/* Target CPU and feature flags */
+	int target;
+	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
+
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
@@ -266,16 +276,6 @@ struct kvm_vcpu_arch {
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
 
-	/* IO related fields */
-	struct kvm_decode mmio_decode;
-
-	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
-
-	/* Target CPU and feature flags */
-	int target;
-	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
-
 	/* Detect first run of a vcpu */
 	bool has_run_once;
 

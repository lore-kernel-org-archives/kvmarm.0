From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Tue, 29 Jan 2019 21:32:23 +0000
Message-ID: <20190129213223.GB3567@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <20190122151714.GG3578@e103592.cambridge.arm.com>
 <20190125144657.3db91c91@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E7324A3A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 16:32:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x7Rrd5osiFEL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 16:32:27 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A44BC4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 16:32:27 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190125144657.3db91c91@donnerap.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 25, 2019 at 02:46:57PM +0000, Andre Przywara wrote:
> On Tue, 22 Jan 2019 15:17:14 +0000
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> Hi Dave,
> 
> thanks for having a look!
> 
> > On Mon, Jan 07, 2019 at 12:05:36PM +0000, Andre Przywara wrote:
> > > KVM implements the firmware interface for mitigating cache
> > > speculation vulnerabilities. Guests may use this interface to
> > > ensure mitigation is active.
> > > If we want to migrate such a guest to a host with a different
> > > support level for those workarounds, migration might need to fail,
> > > to ensure that critical guests don't loose their protection.
> > > 
> > > Introduce a way for userland to save and restore the workarounds
> > > state. On restoring we do checks that make sure we don't downgrade
> > > our mitigation level.
> > > 
> > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > ---
> > >  arch/arm/include/asm/kvm_emulate.h   |  10 ++
> > >  arch/arm/include/uapi/asm/kvm.h      |   9 ++
> > >  arch/arm64/include/asm/kvm_emulate.h |  14 +++
> > >  arch/arm64/include/uapi/asm/kvm.h    |   9 ++
> > >  virt/kvm/arm/psci.c                  | 138
> > > ++++++++++++++++++++++++++- 5 files changed, 178 insertions(+), 2
> > > deletions(-)
> > > 
> > > diff --git a/arch/arm/include/asm/kvm_emulate.h
> > > b/arch/arm/include/asm/kvm_emulate.h index
> > > 77121b713bef..2255c50debab 100644 ---
> > > a/arch/arm/include/asm/kvm_emulate.h +++
> > > b/arch/arm/include/asm/kvm_emulate.h @@ -275,6 +275,16 @@ static
> > > inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> > > return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK; }
> > >  
> > > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct
> > > kvm_vcpu *vcpu) +{
> > > +	return false;
> > > +}
> > > +
> > > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct
> > > kvm_vcpu *vcpu,
> > > +						      bool flag)
> > > +{
> > > +}
> > > +
> > >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> > >  {
> > >  	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> > > diff --git a/arch/arm/include/uapi/asm/kvm.h
> > > b/arch/arm/include/uapi/asm/kvm.h index 4602464ebdfb..02c93b1d8f6d
> > > 100644 --- a/arch/arm/include/uapi/asm/kvm.h
> > > +++ b/arch/arm/include/uapi/asm/kvm.h
> > > @@ -214,6 +214,15 @@ struct kvm_vcpu_events {
> > >  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM |
> > > KVM_REG_SIZE_U64 | \ KVM_REG_ARM_FW | ((r) & 0xffff))
> > >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1
> > > KVM_REG_ARM_FW_REG(1) +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK	0x3
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	4 
> > >  /* Device Control API: ARM VGIC */
> > >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > > diff --git a/arch/arm64/include/asm/kvm_emulate.h
> > > b/arch/arm64/include/asm/kvm_emulate.h index
> > > 506386a3edde..a44f07f68da4 100644 ---
> > > a/arch/arm64/include/asm/kvm_emulate.h +++
> > > b/arch/arm64/include/asm/kvm_emulate.h @@ -336,6 +336,20 @@ static
> > > inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> > > return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK; }
> > >  
> > > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct
> > > kvm_vcpu *vcpu) +{
> > > +	return vcpu->arch.workaround_flags &
> > > VCPU_WORKAROUND_2_FLAG; +}
> > > +
> > > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct
> > > kvm_vcpu *vcpu,
> > > +						      bool flag)
> > > +{
> > > +	if (flag)
> > > +		vcpu->arch.workaround_flags |=
> > > VCPU_WORKAROUND_2_FLAG;
> > > +	else
> > > +		vcpu->arch.workaround_flags &=
> > > ~VCPU_WORKAROUND_2_FLAG; +}
> > > +
> > >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> > >  {
> > >  	if (vcpu_mode_is_32bit(vcpu)) {
> > > diff --git a/arch/arm64/include/uapi/asm/kvm.h
> > > b/arch/arm64/include/uapi/asm/kvm.h index
> > > 97c3478ee6e7..4a19ef199a99 100644 ---
> > > a/arch/arm64/include/uapi/asm/kvm.h +++
> > > b/arch/arm64/include/uapi/asm/kvm.h @@ -225,6 +225,15 @@ struct
> > > kvm_vcpu_events { #define KVM_REG_ARM_FW_REG(r)
> > > (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \ KVM_REG_ARM_FW | ((r) &
> > > 0xffff)) #define KVM_REG_ARM_PSCI_VERSION
> > > KVM_REG_ARM_FW_REG(0) +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
> > > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2
> > > KVM_REG_ARM_FW_REG(2) +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK	0x3 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2 +#define
> > > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	4  
> > 
> > If this is the first exposure of this information to userspace, I
> > wonder if we can come up with some common semantics that avoid having
> > to add new ad-hoc code (and bugs) every time a new
> > vulnerability/workaround is defined.
> > 
> > We seem to have at least the two following independent properties
> > for a vulnerability, with the listed values for each:
> > 
> >  * vulnerability (Vulnerable, Unknown, Not Vulnerable)
> > 
> >  * mitigation support (Not Requestable, Requestable)
> > 
> > Migrations must not move to the left in _either_ list for any
> > vulnerability.
> > 
> > If we want to hedge out bets we could follow the style of the ID
> > registers and allocate to each theoretical vulnerability a pair of
> > signed 2- or (for more expansion room if we think we might need it)
> > 4-bit fields.
> > 
> > We could perhaps allocate as follows:
> > 
> >  * -1=Vulnerable, 0=Unknown, 1=Not Vulnerable
> >  *  0=Mitigation not requestable, 1=Mitigation requestable
> 
> So as discussed in person, that sounds quite neat. I implemented
> that, but the sign extension and masking to n bits is not very pretty
> and limits readability.
> However the property of having a kind of "vulnerability scale", where a
> simple comparison would determine compatibility, is a good thing to
> have and drastically simplifies the checking code.
> 
> > Checking code wouldn't need to know which fields describe mitigation
> > mechanisms and which describe vulnerabilities: we'd just do a strict
> > >= comparison on each.
> > 
> > Further, if a register is never written before the vcpu is first run,
> > we should imply a write of 0 to it as part of KVM_RUN (so that if the
> > destination node has a negative value anywhere, KVM_RUN barfs cleanly.
> 
> What I like about the signedness is this "0 means unknown", which is
> magically forwards compatible. However I am not sure we can transfer
> this semantic into every upcoming register that pops up in the future.

I appreciate the concern, but can you give an example of how it might
break?

My idea is that you can check for compatibility by comparing fields
without any need to know what they mean, but we wouldn't pre-assign
meanings for the values of unallocated fields, just create a precedent
that future fields can follow (where it works).

This is much like the CPU ID features scheme itself.  A "0" might
mean that something is absent, but there's no way (or need) to know
what.

> Actually we might not need this:
> My understanding of how QEMU handles this in migration is that it reads
> the f/w reg on the originating host A and writes this into the target
> host B, without itself interpreting this in any way. It's up to the
> target kernel (basically this code here) to check compatibility. So I am
> not sure we actually need a stable scheme. If host A doesn't know about

Nothing stops userspace from interpreting the data, so there's a risk
people may grow to rely on it even if we don't want them to.

So we should try to have something that's forward-compatible if at all
possible...

> a certain register, it won't appear in the result of the
> KVM_GET_REG_LIST ioctl, so it won't be transferred to host B at all. In
> the opposite case the receiving host would reject an unknown register,
> which I believe is safer, although I see that it leaves the "unknown"
> case on the table.
> 
> It would be good to have some opinion of how forward looking we want to
> (and can) be here.
> 
> Meanwhile I am sending a v2 which implements the linear scale idea,
> without using signed values, as this indeed simplifies the code.
> I have the signed version still in a branch here, let me know if you
> want to have a look.

Happy to take a look at it.

I was hoping that cpufeatures already had a helper for extracting a
signed field, but I didn't go looking for it...

At the asm level this is just a sbfx, so it's hardly expensive.

Cheers
---Dave

From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Fri, 22 Feb 2019 12:26:24 +0000
Message-ID: <20190222122624.507d7a9f@donnerap.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <2b794331-cebe-92f1-7adc-58b041bbe1d6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B8F4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:26:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ENU09nInaWDo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 07:26:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF0F40217
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:26:33 -0500 (EST)
In-Reply-To: <2b794331-cebe-92f1-7adc-58b041bbe1d6@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 7 Jan 2019 13:17:37 +0000
Steven Price <steven.price@arm.com> wrote:

Hi,

> On 07/01/2019 12:05, Andre Przywara wrote:
> > KVM implements the firmware interface for mitigating cache speculation
> > vulnerabilities. Guests may use this interface to ensure mitigation is
> > active.
> > If we want to migrate such a guest to a host with a different support
> > level for those workarounds, migration might need to fail, to ensure that
> > critical guests don't loose their protection.
> > 
> > Introduce a way for userland to save and restore the workarounds state.
> > On restoring we do checks that make sure we don't downgrade our
> > mitigation level.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_emulate.h   |  10 ++
> >  arch/arm/include/uapi/asm/kvm.h      |   9 ++
> >  arch/arm64/include/asm/kvm_emulate.h |  14 +++
> >  arch/arm64/include/uapi/asm/kvm.h    |   9 ++
> >  virt/kvm/arm/psci.c                  | 138 ++++++++++++++++++++++++++-
> >  5 files changed, 178 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> > index 77121b713bef..2255c50debab 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -275,6 +275,16 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> >  	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
> >  }
> >  
> > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
> > +						      bool flag)
> > +{
> > +}
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >  	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> > diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> > index 4602464ebdfb..02c93b1d8f6d 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -214,6 +214,15 @@ struct kvm_vcpu_events {
> >  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
> >  					 KVM_REG_ARM_FW | ((r) & 0xffff))
> >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK	0x3
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	4
> >  
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 506386a3edde..a44f07f68da4 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -336,6 +336,20 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> >  	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> >  }
> >  
> > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
> > +{
> > +	return vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG;
> > +}
> > +
> > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
> > +						      bool flag)
> > +{
> > +	if (flag)
> > +		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
> > +	else
> > +		vcpu->arch.workaround_flags &= ~VCPU_WORKAROUND_2_FLAG;
> > +}
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >  	if (vcpu_mode_is_32bit(vcpu)) {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 97c3478ee6e7..4a19ef199a99 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -225,6 +225,15 @@ struct kvm_vcpu_events {
> >  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >  					 KVM_REG_ARM_FW | ((r) & 0xffff))
> >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1  
> 
> I can't help feeling we need more than one bit to deal with all the
> possible states. The host can support/not-support the workaround (i.e
> the HVC) and the guest can be using/not using the workaround.
> 
> In particular I can imagine the following situation:
> 
> * Guest starts on a host (host A) without the workaround HVC (so
> configures not to use it). Assuming the host doesn't need the workaround
> the guest is therefore not vulnerable.
> 
> * Migrated to a new host (host B) with the workaround HVC (this is
> accepted), the guest is potentially vulnerable.
> 
> * Migration back to the original host (host A) is then rejected, even
> though the guest isn't using the HVC.
> 
> I can see two options here:
> 
> * Reject the migration to host B as the guest may be vulnerable after
> the migration. I.e. the workaround availability cannot change (either
> way) during a migration
> 
> * Store an extra bit of information which is whether a particular guest
> has the HVC exposed to it. Ideally the HVC handling for the workaround
> would also get disabled when running on a host which supports the HVC
> but was migrated from a host which doesn't. This prevents problems with
> a guest which is e.g. migrated during boot and may do feature detection
> after the migration.
> 
> Since this is a new ABI it would be good to get the register values
> sorted even if we don't have a complete implementation of it.

So I thought about this a bit more and now implemented something like a combination of your two options above:
- There is a new UNAFFECTED state, which is currently unused. As mentioned before, the current NOT_AVAIL does not mean not needed, but actually translates as "unknown". At the moment this is our best guess on this matter. There are patches on the list which extend the host workaround code, so we can then actually differentiate between "unknown" and "always mitigated". Once they have landed, we can then communicate this new state to userland.
- For now we are very strict and allow only migration if the workaround levels are identical. Since the guest may have detected either one state during its boot, we don't have much
of a choice here. When we later gain the UNAFFECTED state, we can additionally allow migration from "NOT_AVAIL" to "UNAFFECTED".

I hope this covers your concerns.

Cheers,
Andre.

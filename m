From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Fri, 22 Feb 2019 17:36:02 +0000
Message-ID: <20190222173602.05f34343@donnerap.cambridge.arm.com>
References: <20190222121818.30164-1-andre.przywara@arm.com>
 <20190222121818.30164-2-andre.przywara@arm.com>
 <c3dba11e-7f17-d49a-4eac-f3309f836d66@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B73824A2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 12:36:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M-c-6jlw-KX7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 12:36:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA014A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 12:36:07 -0500 (EST)
In-Reply-To: <c3dba11e-7f17-d49a-4eac-f3309f836d66@arm.com>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 22 Feb 2019 17:16:12 +0000
Steven Price <steven.price@arm.com> wrote:

> On 22/02/2019 12:18, Andre Przywara wrote:
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
> >  arch/arm/include/asm/kvm_emulate.h   |  10 +++
> >  arch/arm/include/uapi/asm/kvm.h      |  10 +++
> >  arch/arm64/include/asm/kvm_emulate.h |  14 ++++
> >  arch/arm64/include/uapi/asm/kvm.h    |   9 ++
> >  virt/kvm/arm/psci.c                  | 119 +++++++++++++++++++++++----
> >  5 files changed, 146 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> > index 8927cae7c966..663a02d7e6f4 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -283,6 +283,16 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
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
> > index 4602464ebdfb..ba4d2afe65e3 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -214,6 +214,16 @@ struct kvm_vcpu_events {
> >  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
> >  					 KVM_REG_ARM_FW | ((r) & 0xffff))
> >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED	2  
> 
> Thanks for adding the UNAFFECTED state for WORKAROUND_1 - this means the
> ABI at least can deal with migration to a host which supports but
> doesn't need the workaround. I'm happy for the actual support for this
> to be added later if/when it's needed.

Thanks. Actually we *can't* do anything right now, because the host kernel only provides this "requires w/a or not" state, so for the current kernel we will never see UNAFFECTED. If QEMU wants to set UNAFFECTED because the source kernel had it, we naturally deny it, as future code would do as well. So I think this solution is forward compatible.
 
> Reviewed-by: Steven Price <steven.price@arm.com>

Thanks for that!
Andre.

From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 21/27] KVM: arm/arm64: Add hook for arch-specific KVM
 initialisation
Date: Thu, 4 Apr 2019 15:53:55 +0100
Message-ID: <20190404145354.GG3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-22-git-send-email-Dave.Martin@arm.com>
 <20190404142528.pxo3vrnk6mfsgmyq@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190404142528.pxo3vrnk6mfsgmyq@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 04:25:28PM +0200, Andrew Jones wrote:
> On Fri, Mar 29, 2019 at 01:00:46PM +0000, Dave Martin wrote:
> > This patch adds a kvm_arm_init_arch_resources() hook to perform
> > subarch-specific initialisation when starting up KVM.
> > 
> > This will be used in a subsequent patch for global SVE-related
> > setup on arm64.
> > 
> > No functional change.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   | 2 ++
> >  arch/arm64/include/asm/kvm_host.h | 2 ++
> >  virt/kvm/arm/arm.c                | 4 ++++
> >  3 files changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 770d732..a49ee01 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -53,6 +53,8 @@
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > +static inline int kvm_arm_init_arch_resources(void) { return 0; }
> > +
> >  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 205438a..3e89509 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -58,6 +58,8 @@
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > +static inline int kvm_arm_init_arch_resources(void) { return 0; }
> > +
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> >  int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 99c3738..c69e137 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -1664,6 +1664,10 @@ int kvm_arch_init(void *opaque)
> >  	if (err)
> >  		return err;
> >  
> > +	err = kvm_arm_init_arch_resources();
> > +	if (err)
> > +		return err;
> > +
> >  	if (!in_hyp_mode) {
> >  		err = init_hyp_mode();
> >  		if (err)
> > -- 
> > 2.1.4
> >
> 
> It's not clear to me from the commit message why init_common_resources()
> won't work for this. Maybe it'll be more clear as I continue the review.

init_common_resources() is for stuff common to arm and arm64.

kvm_arm_init_arch_resources() is intended for stuff specific to the
particular arch backend.

Maybe there is a better name for this.

Cheers
---Dave

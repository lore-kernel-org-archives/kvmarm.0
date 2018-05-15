From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 08/16] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Tue, 15 May 2018 13:48:44 +0100
Message-ID: <20180515124843.GO7753@e103592.cambridge.arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-9-git-send-email-Dave.Martin@arm.com>
 <20180515105523.GC38551@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180515105523.GC38551@C02W217FHV2R.local>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 15, 2018 at 12:55:23PM +0200, Christoffer Dall wrote:
> On Wed, May 09, 2018 at 05:12:57PM +0100, Dave Martin wrote:
> > This patch refactors KVM to align the host and guest FPSIMD
> > save/restore logic with each other for arm64.  This reduces the
> > number of redundant save/restore operations that must occur, and
> > reduces the common-case IRQ blackout time during guest exit storms
> > by saving the host state lazily and optimising away the need to
> > restore the host state before returning to the run loop.

[...]

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c

[...]

> > +/*
> > + * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
> > + * The actual loading is done by the FPSIMD access trap taken to hyp.
> > + *
> > + * Here, we just set the correct metadata to indicate that the FPSIMD
> > + * state in the cpu regs (if any) belongs to current on the host.
> > + *
> > + * TIF_SVE is backed up here, since it may get clobbered with guest state.
> > + * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).
> > + */
> > +void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	BUG_ON(system_supports_sve());
> > +	BUG_ON(!current->mm);
> > +
> > +	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
> > +	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
> > +	if (test_thread_flag(TIF_SVE))
> > +		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> > +}
> > +
> > +/*
> > + * If the guest FPSIMD state was loaded, update the host's context
> > + * tracking data mark the CPU FPSIMD regs as dirty for vcpu so that they
> 
> nit: by marking the CPU FPSIMD regs as dirty and belonging to the
> vcpu... ?

Changed locally.

Marc, let me know if you can pick this up or want me to repost.  There
are a couple of pending FWIWs now.

There is also the option to include the separate update_thread_flags()
patches that now have maintainer acks, though I will need to confirm
with the respective maintainers that they're OK with this.

> Otherwise:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

[...]

Thanks
---Dave

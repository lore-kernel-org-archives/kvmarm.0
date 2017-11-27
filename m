From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 08/37] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Mon, 27 Nov 2017 09:32:34 +0100
Message-ID: <20171127083234.5ouevx4mhnfxibnc@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-9-christoffer.dall@linaro.org>
 <20171115160440.umfucia5rmrioeqs@kamzik.brq.redhat.com>
 <20171126161756.GL28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A7D49DB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 03:29:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2mvxtpzSevAQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 03:29:51 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0219F49D74
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 03:29:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171126161756.GL28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: riel@redhat.com, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Nov 26, 2017 at 05:17:56PM +0100, Christoffer Dall wrote:
> Hi Drew,
> 
> On Wed, Nov 15, 2017 at 05:04:40PM +0100, Andrew Jones wrote:
> > On Thu, Oct 12, 2017 at 12:41:12PM +0200, Christoffer Dall wrote:
> > > Avoid saving the guest VFP registers and restoring the host VFP
> > > registers on every exit from the VM.  Only when we're about to run
> > > userspace or other threads in the kernel do we really have to switch the
> > > state back to the host state.
> > 
> > Rik van Riel's recently post patch "[PATCH v2 0/2] x86,kvm: move qemu/guest
> > FPU switching out to kvm_arch_vcpu_ioctl_run" indicates that for x86 they
> > only need to swap guest and userspace VFP registers before exiting VCPU_RUN
> > to userspace, not for running other threads. I imagine that's the same for
> > ARM as well.
> > 
> > If so, then I think this hunk
> > 
> > > @@ -209,4 +212,16 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> > >   */
> > >  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
> > >  {
> > > +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> > > +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> > > +
> > > +	/* Restore host FP/SIMD state */
> > > +	if (vcpu->arch.guest_vfp_loaded) {
> > > +		if (vcpu_el1_is_32bit(vcpu))
> > > +			kvm_call_hyp(__fpsimd32_save_state,
> > > +				     kern_hyp_va(guest_ctxt));
> > > +		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> > > +		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> > > +		vcpu->arch.guest_vfp_loaded = 0;
> > > +	}
> > >  }
> > 
> > could be moved to the return of kvm_arch_vcpu_ioctl_run().
> > 
> That sounds cool.
> 
> I'll keep this patch as it is now, and look at Rik's patches and post a
> follow up later, does that sound ok?

Works for me. I'm guessing there's also going to be some overlap with
Dave Martin's SVE work. So whichever series goes second can probably
be the one to put the most consideration into it.

Thanks,
drew

Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D65DC33CA4
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 11:04:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 983D52077C
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 11:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 983D52077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E02544B1D9;
	Fri, 10 Jan 2020 06:04:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DF8W4AevGp0M; Fri, 10 Jan 2020 06:04:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B38B4B17C;
	Fri, 10 Jan 2020 06:04:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ABDC4B17C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 06:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyOLDj3YQIyN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 06:04:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 947BC4B179
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 06:04:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42E28328;
 Fri, 10 Jan 2020 03:04:23 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B939C3F703;
 Fri, 10 Jan 2020 03:04:22 -0800 (PST)
Date: Fri, 10 Jan 2020 11:04:21 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 09/18] arm64: KVM: enable conditional save/restore
 full SPE profiling buffer controls
Message-ID: <20200110110420.GD42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-10-andrew.murray@arm.com>
 <20191221141325.5a177343@why>
 <20200110105435.GC42593@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200110105435.GC42593@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <Catalin.Marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <Sudeep.Holla@arm.com>,
 will@kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jan 10, 2020 at 10:54:36AM +0000, Andrew Murray wrote:
> On Sat, Dec 21, 2019 at 02:13:25PM +0000, Marc Zyngier wrote:
> > On Fri, 20 Dec 2019 14:30:16 +0000
> > Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > [somehow managed not to do a reply all, re-sending]
> > 
> > > From: Sudeep Holla <sudeep.holla@arm.com>
> > > 
> > > Now that we can save/restore the full SPE controls, we can enable it
> > > if SPE is setup and ready to use in KVM. It's supported in KVM only if
> > > all the CPUs in the system supports SPE.
> > > 
> > > However to support heterogenous systems, we need to move the check if
> > > host supports SPE and do a partial save/restore.
> > 
> > No. Let's just not go down that path. For now, KVM on heterogeneous
> > systems do not get SPE. If SPE has been enabled on a guest and a CPU
> > comes up without SPE, this CPU should fail to boot (same as exposing a
> > feature to userspace).
> > 
> > > 
> > > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > ---
> > >  arch/arm64/kvm/hyp/debug-sr.c | 33 ++++++++++++++++-----------------
> > >  include/kvm/arm_spe.h         |  6 ++++++
> > >  2 files changed, 22 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > > index 12429b212a3a..d8d857067e6d 100644
> > > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > > @@ -86,18 +86,13 @@
> > >  	}
> > >  
> > >  static void __hyp_text
> > > -__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > > +__debug_save_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > >  {
> > >  	u64 reg;
> > >  
> > >  	/* Clear pmscr in case of early return */
> > >  	ctxt->sys_regs[PMSCR_EL1] = 0;
> > >  
> > > -	/* SPE present on this CPU? */
> > > -	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> > > -						  ID_AA64DFR0_PMSVER_SHIFT))
> > > -		return;
> > > -
> > >  	/* Yes; is it owned by higher EL? */
> > >  	reg = read_sysreg_s(SYS_PMBIDR_EL1);
> > >  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> > > @@ -142,7 +137,7 @@ __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > >  }
> > >  
> > >  static void __hyp_text
> > > -__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > > +__debug_restore_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > >  {
> > >  	if (!ctxt->sys_regs[PMSCR_EL1])
> > >  		return;
> > > @@ -210,11 +205,14 @@ void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
> > >  	struct kvm_guest_debug_arch *host_dbg;
> > >  	struct kvm_guest_debug_arch *guest_dbg;
> > >  
> > > +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > > +	guest_ctxt = &vcpu->arch.ctxt;
> > > +
> > > +	__debug_restore_spe_context(guest_ctxt, kvm_arm_spe_v1_ready(vcpu));
> > > +
> > >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> > >  		return;
> > >  
> > > -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > > -	guest_ctxt = &vcpu->arch.ctxt;
> > >  	host_dbg = &vcpu->arch.host_debug_state.regs;
> > >  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> > >  
> > > @@ -232,8 +230,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> > >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > >  	guest_ctxt = &vcpu->arch.ctxt;
> > >  
> > > -	if (!has_vhe())
> > > -		__debug_restore_spe_nvhe(host_ctxt, false);
> > > +	__debug_restore_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
> > 
> > So you now do an unconditional save/restore on the exit path for VHE as
> > well? Even if the host isn't using the SPE HW? That's not acceptable
> > as, in most cases, only the host /or/ the guest will use SPE. Here, you
> > put a measurable overhead on each exit.
> > 
> > If the host is not using SPE, then the restore/save should happen in
> > vcpu_load/vcpu_put. Only if the host is using SPE should you do
> > something in the run loop. Of course, this only applies to VHE and
> > non-VHE must switch eagerly.
> > 
> 
> On VHE where SPE is used in the guest only - we save/restore in vcpu_load/put.
> 
> On VHE where SPE is used in the host only - we save/restore in the run loop.
> 
> On VHE where SPE is used in guest and host - we save/restore in the run loop.
> 
> As the guest can't trace EL2 it doesn't matter if we restore guest SPE early
> in the vcpu_load/put functions. (I assume it doesn't matter that we restore
> an EL0/EL1 profiling buffer address at this point and enable tracing given
> that there is nothing to trace until entering the guest).
> 
> However the reason for moving save/restore to vcpu_load/put when the host is
> using SPE is to minimise the host EL2 black-out window.
> 
> 
> On nVHE we always save/restore in the run loop. For the SPE guest-use-only
> use-case we can't save/restore in vcpu_load/put - because the guest runs at
> the same ELx level as the host - and thus doing so would result in the guest
> tracing part of the host.
> 
> Though if we determine that (for nVHE systems) the guest SPE is profiling only
> EL0 - then we could also save/restore in vcpu_load/put where SPE is only being
> used in the guest.
> 
> Does that make sense, are my reasons correct?

Also I'm making the following assumptions:

 - We determine if the host or guest are using SPE by seeing if profiling
   (e.g. PMSCR_EL1) is enabled. That should determine *when* we restore as per
   my previous email.

 - I'm less sure on this: We should determine *what* we restore based on the
   availability of the SPE feature and not if it is being used - so for guest
   this is if the guest has the feature on the vcpu. For host this is based on
   the CPU feature registers.

   The downshot of this is that if you have SPE support present on guest and
   host and they aren't being used, then you still save/restore upon entering/
   leaving a guest. The reason I feel this is needed is to prevent the issue
   where the host starts programming the SPE registers, but is preempted by
   KVM entering a guest, before it could enable host SPE. Thus when we enter the
   guest we don't save all the registers, we return to the host and the host
   SPE carries on from where it left of and enables it - yet because we didn't
   restore all the programmed registers it doesn't work.

Thanks,

Andrew Murray

> 
> Thanks,
> 
> Andrew Murray
> 
> 
> > >  
> > >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> > >  		return;
> > > @@ -249,19 +246,21 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> > >  
> > >  void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
> > >  {
> > > -	/*
> > > -	 * Non-VHE: Disable and flush SPE data generation
> > > -	 * VHE: The vcpu can run, but it can't hide.
> > > -	 */
> > >  	struct kvm_cpu_context *host_ctxt;
> > >  
> > >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > > -	if (!has_vhe())
> > > -		__debug_save_spe_nvhe(host_ctxt, false);
> > > +	if (cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> > > +						 ID_AA64DFR0_PMSVER_SHIFT))
> > > +		__debug_save_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
> > >  }
> > >  
> > >  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
> > >  {
> > > +	bool kvm_spe_ready = kvm_arm_spe_v1_ready(vcpu);
> > > +
> > > +	/* SPE present on this vCPU? */
> > > +	if (kvm_spe_ready)
> > > +		__debug_save_spe_context(&vcpu->arch.ctxt, kvm_spe_ready);
> > >  }
> > >  
> > >  u32 __hyp_text __kvm_get_mdcr_el2(void)
> > > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > > index 48d118fdb174..30c40b1bc385 100644
> > > --- a/include/kvm/arm_spe.h
> > > +++ b/include/kvm/arm_spe.h
> > > @@ -16,4 +16,10 @@ struct kvm_spe {
> > >  	bool irq_level;
> > >  };
> > >  
> > > +#ifdef CONFIG_KVM_ARM_SPE
> > > +#define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> > > +#else
> > > +#define kvm_arm_spe_v1_ready(v)		(false)
> > > +#endif /* CONFIG_KVM_ARM_SPE */
> > > +
> > >  #endif /* __ASM_ARM_KVM_SPE_H */
> > 
> > Thanks,
> > 
> > 	M.
> > -- 
> > Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

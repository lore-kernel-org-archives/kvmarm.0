From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the
 world switch
Date: Mon, 13 Apr 2015 16:26:21 +0200
Message-ID: <20150413142621.GA21755@cbox>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
 <20150413125751.GA13347@cbox>
 <552BCEBA.8010204@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <552BCEBA.8010204@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 13, 2015 at 03:12:10PM +0100, Marc Zyngier wrote:
> On 13/04/15 13:57, Christoffer Dall wrote:
> > On Thu, Apr 09, 2015 at 05:53:59PM +0100, Marc Zyngier wrote:
> >> The world switch spends quite some time dealing with the FP/SIMD
> >> registers, as the state is quite sizeable (32 128bit registers,
> >> plus some crumbs on the side). We save/restore them on each
> >> entry/exit, so that both the host and the guest always see
> >> the state they expect.
> >>
> >> But let's face it: the host kernel doesn't care. It is the host
> >> userspace that actually cares about FP. An obvious improvement is
> >> to remove the save/restore from the world switch, and only perform
> >> it when we're about to enter/exit the guest (by plugging it into
> >> vcpu_load/vcpu_put). The effect is pretty spectacular when running
> >> hackbench (which is the only benchmark worth looking at):
> >>
> >> Without this patch:
> >>
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 36.756
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 36.679
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 36.699
> >>
> >> With this patch:
> >>
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 30.947
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 30.868
> >> 	Running with 50*40 (== 2000) tasks.
> >> 	Time: 30.961
> >>
> >> This is on a HiKey board (8*A53), with a 4 vcpu guest.
> > 
> > cool.  Based on stats from kvm-unit-tests on A57 we should reduce the
> > overall world-switch cost (in the best cases, caches, etc.) with ~8.5%,
> > but this is even better and we are doing slightly more work than
> > context-switching here, so I'm guessing factoring in potential extra
> > cache misses, it can be this good.
> > 
> > However, on XGene with Ubuntu 14.04 Trusty, I get the following (do not
> > compare to Marc's results, I may be using different kernel settings and
> > different payload size):
> > 
> > Without the patch:
> > 
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 15.970
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 15.963
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 15.875
> > 
> > 
> > With the patch:
> > 
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 16.768:
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 14.865
> > 	Running with 50*40 (== 2000) tasks.
> > 	Time: 14.880
> > 
> > On an HP Moonshot server I ran a number of other benchmarks and got
> > similarly boring results.
> 
> I did another set of tests, this time involving Seattle, XGene and the
> HiKey board. The result is that you cannot trust HiKey, this is the most
> unpredictable platform I've ever seen (I had some chosen words for it,
> that I don't want to write here....).
> 
> So while this patch seems to provide a small improvement in some cases,
> it is definitely not as interesting as my first testing suggested. Too
> good to be true! ;-)
> 
> I'm going to try and revive my lazy-fp patches, and see if there's
> anything to improve here.
> 
> > Comments on the patch itself below:
> > 
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/include/asm/kvm_host.h   |  3 +++
> >>  arch/arm/kvm/arm.c                |  2 ++
> >>  arch/arm64/include/asm/kvm_asm.h  |  4 ++++
> >>  arch/arm64/include/asm/kvm_host.h |  3 +++
> >>  arch/arm64/kvm/Makefile           |  1 +
> >>  arch/arm64/kvm/fpsimd.S           | 39 ++++++++++++++++++++++++++++++++++++
> >>  arch/arm64/kvm/handle_fpsimd.c    | 42 +++++++++++++++++++++++++++++++++++++++
> >>  arch/arm64/kvm/hyp.S              | 27 -------------------------
> >>  8 files changed, 94 insertions(+), 27 deletions(-)
> >>  create mode 100644 arch/arm64/kvm/fpsimd.S
> >>  create mode 100644 arch/arm64/kvm/handle_fpsimd.c
> >>
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >> index d71607c..65cf1d1 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -226,6 +226,9 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
> >>  int kvm_perf_init(void);
> >>  int kvm_perf_teardown(void);
> >>  
> >> +static inline void kvm_fpsimd_flush_hwstate(struct kvm_vcpu *vcpu) {}
> >> +static inline void kvm_fpsimd_sync_hwstate(struct kvm_vcpu *vcpu) {}
> >> +
> >>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
> >>  
> >>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index 6f53645..ff1213c 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -287,6 +287,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >>  	vcpu->cpu = cpu;
> >>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
> >>  
> >> +	kvm_fpsimd_flush_hwstate(vcpu);
> > 
> > not sure about the flus/sync terminology here, because we're not really
> > flushing a software model to hardware state - we're doing both in every
> > step.
> > 
> > How about:
> > 
> > kvm_fpsimd_load_vcpu_state()
> > kvm_fpsimd_put_vcpu_state()
> 
> The rest of the kernel does use that flush/sync terminology, specially
> for FP/SIMD. So it is a matter of either being consistent with the arm64
> convention, or consistent with the KVM convention. I don't mind either way.
> 

ok, I didn't realize this was used for FP/SIMD.  The terminology always
confused me a bit, but let's just do the least churn.

> >>  	kvm_arm_set_running_vcpu(vcpu);
> >>  }
> >>  
> >> @@ -299,6 +300,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>  	 */
> >>  	vcpu->cpu = -1;
> >>  
> >> +	kvm_fpsimd_sync_hwstate(vcpu);
> >>  	kvm_arm_set_running_vcpu(NULL);
> >>  }
> >>  
> >> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> >> index 4f7310f..eafb0c3 100644
> >> --- a/arch/arm64/include/asm/kvm_asm.h
> >> +++ b/arch/arm64/include/asm/kvm_asm.h
> >> @@ -137,6 +137,10 @@ extern char __restore_vgic_v2_state[];
> >>  extern char __save_vgic_v3_state[];
> >>  extern char __restore_vgic_v3_state[];
> >>  
> >> +struct kvm_cpu_context;
> >> +extern void __kvm_save_fpsimd(struct kvm_cpu_context *);
> >> +extern void __kvm_restore_fpsimd(struct kvm_cpu_context *);
> >> +
> >>  #endif
> >>  
> >>  #endif /* __ARM_KVM_ASM_H__ */
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index f0f58c9..2b968e5 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -201,6 +201,9 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  int kvm_perf_init(void);
> >>  int kvm_perf_teardown(void);
> >>  
> >> +void kvm_fpsimd_flush_hwstate(struct kvm_vcpu *vcpu);
> >> +void kvm_fpsimd_sync_hwstate(struct kvm_vcpu *vcpu);
> >> +
> >>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >>  
> >>  static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >> index d5904f8..6d9c2b7 100644
> >> --- a/arch/arm64/kvm/Makefile
> >> +++ b/arch/arm64/kvm/Makefile
> >> @@ -18,6 +18,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o reset.o sys_regs.o sys_regs_generic_v8.o
> >> +kvm-$(CONFIG_KVM_ARM_HOST) += fpsimd.o handle_fpsimd.o
> >>  
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
> >> diff --git a/arch/arm64/kvm/fpsimd.S b/arch/arm64/kvm/fpsimd.S
> >> new file mode 100644
> >> index 0000000..458a1a7
> >> --- /dev/null
> >> +++ b/arch/arm64/kvm/fpsimd.S
> >> @@ -0,0 +1,39 @@
> >> +/*
> >> + * Copyright (C) 2012,2013 - ARM Ltd
> > 
> > I don't know if you care, but shouldn't this be 2015?
> 
> I wondered. I've just moved existing code around, so I decided to keep
> the original date.

ah, ignore me then.

-Christoffer

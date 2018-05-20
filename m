From: kbuild test robot <lkp@intel.com>
Subject: [kvmarm:queue 9/29] arch/arm/kvm/../../../virt/kvm/arm/arm.c:783:3:
 error: implicit declaration of function 'kvm_arch_vcpu_ctxsync_fp'; did you
 mean 'kvm_arch_vcpu_put_fp'?
Date: Mon, 21 May 2018 06:20:22 +0800
Message-ID: <201805210613.5kgi04jf%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kbuild-all@01.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git queue
head:   f2d1aab22d57235b58db391d318727d3e5ef1e89
commit: 9d346205940be002dc43a3274f8c6c47beddd8cc [9/29] KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing
config: arm-axm55xx_defconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 9d346205940be002dc43a3274f8c6c47beddd8cc
        # save the attached .config to linux build tree
        make.cross ARCH=arm 

All errors (new ones prefixed by >>):

   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
>> arch/arm/kvm/../../../virt/kvm/arm/arm.c:783:3: error: implicit declaration of function 'kvm_arch_vcpu_ctxsync_fp'; did you mean 'kvm_arch_vcpu_put_fp'? [-Werror=implicit-function-declaration]
      kvm_arch_vcpu_ctxsync_fp(vcpu);
      ^~~~~~~~~~~~~~~~~~~~~~~~
      kvm_arch_vcpu_put_fp
   cc1: some warnings being treated as errors

vim +783 arch/arm/kvm/../../../virt/kvm/arm/arm.c

   626	
   627	/**
   628	 * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
   629	 * @vcpu:	The VCPU pointer
   630	 * @run:	The kvm_run structure pointer used for userspace state exchange
   631	 *
   632	 * This function is called through the VCPU_RUN ioctl called from user space. It
   633	 * will execute VM code in a loop until the time slice for the process is used
   634	 * or some emulation is needed from user space in which case the function will
   635	 * return with return value 0 and with the kvm_run structure filled in with the
   636	 * required data for the requested emulation.
   637	 */
   638	int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
   639	{
   640		int ret;
   641	
   642		if (unlikely(!kvm_vcpu_initialized(vcpu)))
   643			return -ENOEXEC;
   644	
   645		ret = kvm_vcpu_first_run_init(vcpu);
   646		if (ret)
   647			return ret;
   648	
   649		if (run->exit_reason == KVM_EXIT_MMIO) {
   650			ret = kvm_handle_mmio_return(vcpu, vcpu->run);
   651			if (ret)
   652				return ret;
   653			if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
   654				return 0;
   655		}
   656	
   657		if (run->immediate_exit)
   658			return -EINTR;
   659	
   660		vcpu_load(vcpu);
   661	
   662		kvm_sigset_activate(vcpu);
   663	
   664		ret = 1;
   665		run->exit_reason = KVM_EXIT_UNKNOWN;
   666		while (ret > 0) {
   667			/*
   668			 * Check conditions before entering the guest
   669			 */
   670			cond_resched();
   671	
   672			update_vttbr(vcpu->kvm);
   673	
   674			check_vcpu_requests(vcpu);
   675	
   676			/*
   677			 * Preparing the interrupts to be injected also
   678			 * involves poking the GIC, which must be done in a
   679			 * non-preemptible context.
   680			 */
   681			preempt_disable();
   682	
   683			/* Flush FP/SIMD state that can't survive guest entry/exit */
   684			kvm_fpsimd_flush_cpu_state();
   685	
   686			kvm_pmu_flush_hwstate(vcpu);
   687	
   688			local_irq_disable();
   689	
   690			kvm_vgic_flush_hwstate(vcpu);
   691	
   692			/*
   693			 * Exit if we have a signal pending so that we can deliver the
   694			 * signal to user space.
   695			 */
   696			if (signal_pending(current)) {
   697				ret = -EINTR;
   698				run->exit_reason = KVM_EXIT_INTR;
   699			}
   700	
   701			/*
   702			 * If we're using a userspace irqchip, then check if we need
   703			 * to tell a userspace irqchip about timer or PMU level
   704			 * changes and if so, exit to userspace (the actual level
   705			 * state gets updated in kvm_timer_update_run and
   706			 * kvm_pmu_update_run below).
   707			 */
   708			if (static_branch_unlikely(&userspace_irqchip_in_use)) {
   709				if (kvm_timer_should_notify_user(vcpu) ||
   710				    kvm_pmu_should_notify_user(vcpu)) {
   711					ret = -EINTR;
   712					run->exit_reason = KVM_EXIT_INTR;
   713				}
   714			}
   715	
   716			/*
   717			 * Ensure we set mode to IN_GUEST_MODE after we disable
   718			 * interrupts and before the final VCPU requests check.
   719			 * See the comment in kvm_vcpu_exiting_guest_mode() and
   720			 * Documentation/virtual/kvm/vcpu-requests.rst
   721			 */
   722			smp_store_mb(vcpu->mode, IN_GUEST_MODE);
   723	
   724			if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
   725			    kvm_request_pending(vcpu)) {
   726				vcpu->mode = OUTSIDE_GUEST_MODE;
   727				isb(); /* Ensure work in x_flush_hwstate is committed */
   728				kvm_pmu_sync_hwstate(vcpu);
   729				if (static_branch_unlikely(&userspace_irqchip_in_use))
   730					kvm_timer_sync_hwstate(vcpu);
   731				kvm_vgic_sync_hwstate(vcpu);
   732				local_irq_enable();
   733				preempt_enable();
   734				continue;
   735			}
   736	
   737			kvm_arm_setup_debug(vcpu);
   738	
   739			/**************************************************************
   740			 * Enter the guest
   741			 */
   742			trace_kvm_entry(*vcpu_pc(vcpu));
   743			guest_enter_irqoff();
   744	
   745			if (has_vhe()) {
   746				kvm_arm_vhe_guest_enter();
   747				ret = kvm_vcpu_run_vhe(vcpu);
   748				kvm_arm_vhe_guest_exit();
   749			} else {
   750				ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
   751			}
   752	
   753			vcpu->mode = OUTSIDE_GUEST_MODE;
   754			vcpu->stat.exits++;
   755			/*
   756			 * Back from guest
   757			 *************************************************************/
   758	
   759			kvm_arm_clear_debug(vcpu);
   760	
   761			/*
   762			 * We must sync the PMU state before the vgic state so
   763			 * that the vgic can properly sample the updated state of the
   764			 * interrupt line.
   765			 */
   766			kvm_pmu_sync_hwstate(vcpu);
   767	
   768			/*
   769			 * Sync the vgic state before syncing the timer state because
   770			 * the timer code needs to know if the virtual timer
   771			 * interrupts are active.
   772			 */
   773			kvm_vgic_sync_hwstate(vcpu);
   774	
   775			/*
   776			 * Sync the timer hardware state before enabling interrupts as
   777			 * we don't want vtimer interrupts to race with syncing the
   778			 * timer virtual interrupt state.
   779			 */
   780			if (static_branch_unlikely(&userspace_irqchip_in_use))
   781				kvm_timer_sync_hwstate(vcpu);
   782	
 > 783			kvm_arch_vcpu_ctxsync_fp(vcpu);
   784	
   785			/*
   786			 * We may have taken a host interrupt in HYP mode (ie
   787			 * while executing the guest). This interrupt is still
   788			 * pending, as we haven't serviced it yet!
   789			 *
   790			 * We're now back in SVC mode, with interrupts
   791			 * disabled.  Enabling the interrupts now will have
   792			 * the effect of taking the interrupt again, in SVC
   793			 * mode this time.
   794			 */
   795			local_irq_enable();
   796	
   797			/*
   798			 * We do local_irq_enable() before calling guest_exit() so
   799			 * that if a timer interrupt hits while running the guest we
   800			 * account that tick as being spent in the guest.  We enable
   801			 * preemption after calling guest_exit() so that if we get
   802			 * preempted we make sure ticks after that is not counted as
   803			 * guest time.
   804			 */
   805			guest_exit();
   806			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
   807	
   808			/* Exit types that need handling before we can be preempted */
   809			handle_exit_early(vcpu, run, ret);
   810	
   811			preempt_enable();
   812	
   813			ret = handle_exit(vcpu, run, ret);
   814		}
   815	
   816		/* Tell userspace about in-kernel device output levels */
   817		if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
   818			kvm_timer_update_run(vcpu);
   819			kvm_pmu_update_run(vcpu);
   820		}
   821	
   822		kvm_sigset_deactivate(vcpu);
   823	
   824		vcpu_put(vcpu);
   825		return ret;
   826	}
   827	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--FL5UXtIhxfXey3p5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
BQBAhaKMKLHwpgVTyeBVoIpO/R+O1rh+gUUBAA==

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--FL5UXtIhxfXey3p5--

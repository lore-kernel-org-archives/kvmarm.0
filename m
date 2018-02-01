From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v3 00/41] Optimize KVM/ARM for VHE systems
Date: Thu, 1 Feb 2018 19:15:36 +0300
Message-ID: <20180201161536.weg5f5kivjtleauc@yury-thinkpad>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <f886a2fd-e0f0-3252-9f6e-00422d895e9f@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <f886a2fd-e0f0-3252-9f6e-00422d895e9f@semihalf.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tomasz Nowicki <tn@semihalf.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 02:57:59PM +0100, Tomasz Nowicki wrote:
> Hi Christoffer,
> 
> I created simple module for VM kernel. It is spinning on PSCI version
> hypercall to measure the base exit cost as you suggested. Also, I measured
> CPU cycles for each loop and here are my results:
> 
> My setup:
> 1-socket ThunderX2 running VM - 1VCPU
> 
> Tested baselines:
> a) host kernel v4.15-rc3 and VM kernel v4.15-rc3
> b) host kernel v4.15-rc3 + vhe-optimize-v3-with-fixes and VM kernel
> v4.15-rc3
> 
> Module was loaded from VM and the results are presented in [%] relative to
> average CPU cycles spending on PSCI version hypercall for vanilla VHE host
> kernel v4.15-rc3:
> 
>              VHE  |  nVHE
> =========================
> baseline a)  100% |  130%
> =========================
> baseline a)  36%  |  123%
> 
> So I confirm significant performance improvement, especially for VHE case.
> Additionally, I run network throughput tests with vhost-net but for that
> case no differences.

Hi Tomasz,

Can you share your test?

Yury
 
> Thanks,
> Tomasz
> 
> On 12.01.2018 13:07, Christoffer Dall wrote:
> > This series redesigns parts of KVM/ARM to optimize the performance on
> > VHE systems.  The general approach is to try to do as little work as
> > possible when transitioning between the VM and the hypervisor.  This has
> > the benefit of lower latency when waiting for interrupts and delivering
> > virtual interrupts, and reduces the overhead of emulating behavior and
> > I/O in the host kernel.
> > 
> > Patches 01 through 06 are not VHE specific, but rework parts of KVM/ARM
> > that can be generally improved.  We then add infrastructure to move more
> > logic into vcpu_load and vcpu_put, we improve handling of VFP and debug
> > registers.
> > 
> > We then introduce a new world-switch function for VHE systems, which we
> > can tweak and optimize for VHE systems.  To do that, we rework a lot of
> > the system register save/restore handling and emulation code that may
> > need access to system registers, so that we can defer as many system
> > register save/restore operations to vcpu_load and vcpu_put, and move
> > this logic out of the VHE world switch function.
> > 
> > We then optimize the configuration of traps.  On non-VHE systems, both
> > the host and VM kernels run in EL1, but because the host kernel should
> > have full access to the underlying hardware, but the VM kernel should
> > not, we essentially make the host kernel more privileged than the VM
> > kernel despite them both running at the same privilege level by enabling
> > VE traps when entering the VM and disabling those traps when exiting the
> > VM.  On VHE systems, the host kernel runs in EL2 and has full access to
> > the hardware (as much as allowed by secure side software), and is
> > unaffected by the trap configuration.  That means we can configure the
> > traps for VMs running in EL1 once, and don't have to switch them on and
> > off for every entry/exit to/from the VM.
> > 
> > Finally, we improve our VGIC handling by moving all save/restore logic
> > out of the VHE world-switch, and we make it possible to truly only
> > evaluate if the AP list is empty and not do *any* VGIC work if that is
> > the case, and only do the minimal amount of work required in the course
> > of the VGIC processing when we have virtual interrupts in flight.
> > 
> > The patches are based on v4.15-rc3, v9 of the level-triggered mapped
> > interrupts support series [1], and the first five patches of James' SDEI
> > series [2].
> > 
> > I've given the patches a fair amount of testing on Thunder-X, Mustang,
> > Seattle, and TC2 (32-bit) for non-VHE testing, and tested VHE
> > functionality on the Foundation model, running both 64-bit VMs and
> > 32-bit VMs side-by-side and using both GICv3-on-GICv3 and
> > GICv2-on-GICv3.
> > 
> > The patches are also available in the vhe-optimize-v3 branch on my
> > kernel.org repository [3].  The vhe-optimize-v3-base branch contains
> > prerequisites of this series.
> > 
> > Changes since v2:
> >   - Rebased on v4.15-rc3.
> >   - Includes two additional patches that only does vcpu_load after
> >     kvm_vcpu_first_run_init and only for KVM_RUN.
> >   - Addressed review comments from v2 (detailed changelogs are in the
> >     individual patches).
> > 
> > Thanks,
> > -Christoffer
> > 
> > [1]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git level-mapped-v9
> > [2]: git://linux-arm.org/linux-jm.git sdei/v5/base
> > [3]: git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git vhe-optimize-v3
> > 
> > Christoffer Dall (40):
> >    KVM: arm/arm64: Avoid vcpu_load for other vcpu ioctls than KVM_RUN
> >    KVM: arm/arm64: Move vcpu_load call after kvm_vcpu_first_run_init
> >    KVM: arm64: Avoid storing the vcpu pointer on the stack
> >    KVM: arm64: Rework hyp_panic for VHE and non-VHE
> >    KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
> >    KVM: arm/arm64: Add kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs
> >    KVM: arm/arm64: Introduce vcpu_el1_is_32bit
> >    KVM: arm64: Defer restoring host VFP state to vcpu_put
> >    KVM: arm64: Move debug dirty flag calculation out of world switch
> >    KVM: arm64: Slightly improve debug save/restore functions
> >    KVM: arm64: Improve debug register save/restore flow
> >    KVM: arm64: Factor out fault info population and gic workarounds
> >    KVM: arm64: Introduce VHE-specific kvm_vcpu_run
> >    KVM: arm64: Remove kern_hyp_va() use in VHE switch function
> >    KVM: arm64: Don't deactivate VM on VHE systems
> >    KVM: arm64: Remove noop calls to timer save/restore from VHE switch
> >    KVM: arm64: Move userspace system registers into separate function
> >    KVM: arm64: Rewrite sysreg alternatives to static keys
> >    KVM: arm64: Introduce separate VHE/non-VHE sysreg save/restore
> >      functions
> >    KVM: arm/arm64: Remove leftover comment from kvm_vcpu_run_vhe
> >    KVM: arm64: Unify non-VHE host/guest sysreg save and restore functions
> >    KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2 on VHE systems
> >    KVM: arm64: Change 32-bit handling of VM system registers
> >    KVM: arm64: Rewrite system register accessors to read/write functions
> >    KVM: arm64: Introduce framework for accessing deferred sysregs
> >    KVM: arm/arm64: Prepare to handle deferred save/restore of SPSR_EL1
> >    KVM: arm64: Prepare to handle deferred save/restore of ELR_EL1
> >    KVM: arm64: Defer saving/restoring 64-bit sysregs to vcpu load/put on
> >      VHE
> >    KVM: arm64: Prepare to handle deferred save/restore of 32-bit
> >      registers
> >    KVM: arm64: Defer saving/restoring 32-bit sysregs to vcpu load/put
> >    KVM: arm64: Move common VHE/non-VHE trap config in separate functions
> >    KVM: arm64: Configure FPSIMD traps on vcpu load/put
> >    KVM: arm64: Configure c15, PMU, and debug register traps on cpu
> >      load/put for VHE
> >    KVM: arm64: Separate activate_traps and deactive_traps for VHE and
> >      non-VHE
> >    KVM: arm/arm64: Get rid of vgic_elrsr
> >    KVM: arm/arm64: Handle VGICv2 save/restore from the main VGIC code
> >    KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file to arm64
> >    KVM: arm/arm64: Handle VGICv3 save/restore from the main VGIC code on
> >      VHE
> >    KVM: arm/arm64: Move VGIC APR save/restore to vgic put/load
> >    KVM: arm/arm64: Avoid VGICv3 save/restore on VHE with no IRQs
> > 
> > Shih-Wei Li (1):
> >    KVM: arm64: Move HCR_INT_OVERRIDE to default HCR_EL2 guest flag
> > 
> >   arch/arm/include/asm/kvm_asm.h                    |   5 +-
> >   arch/arm/include/asm/kvm_emulate.h                |  21 +-
> >   arch/arm/include/asm/kvm_host.h                   |   6 +-
> >   arch/arm/include/asm/kvm_hyp.h                    |   4 +
> >   arch/arm/kvm/emulate.c                            |   4 +-
> >   arch/arm/kvm/hyp/Makefile                         |   1 -
> >   arch/arm/kvm/hyp/switch.c                         |  16 +-
> >   arch/arm64/include/asm/kvm_arm.h                  |   4 +-
> >   arch/arm64/include/asm/kvm_asm.h                  |  18 +-
> >   arch/arm64/include/asm/kvm_emulate.h              |  74 +++-
> >   arch/arm64/include/asm/kvm_host.h                 |  49 ++-
> >   arch/arm64/include/asm/kvm_hyp.h                  |  32 +-
> >   arch/arm64/include/asm/kvm_mmu.h                  |   2 +-
> >   arch/arm64/kernel/asm-offsets.c                   |   2 +
> >   arch/arm64/kvm/debug.c                            |  28 +-
> >   arch/arm64/kvm/guest.c                            |   3 -
> >   arch/arm64/kvm/hyp/Makefile                       |   2 +-
> >   arch/arm64/kvm/hyp/debug-sr.c                     |  88 +++--
> >   arch/arm64/kvm/hyp/entry.S                        |   9 +-
> >   arch/arm64/kvm/hyp/hyp-entry.S                    |  41 +--
> >   arch/arm64/kvm/hyp/switch.c                       | 404 +++++++++++++---------
> >   arch/arm64/kvm/hyp/sysreg-sr.c                    | 192 ++++++++--
> >   {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c |  81 -----
> >   arch/arm64/kvm/inject_fault.c                     |  24 +-
> >   arch/arm64/kvm/regmap.c                           |  65 +++-
> >   arch/arm64/kvm/sys_regs.c                         | 247 +++++++++++--
> >   arch/arm64/kvm/sys_regs.h                         |   4 +-
> >   arch/arm64/kvm/sys_regs_generic_v8.c              |   4 +-
> >   include/kvm/arm_vgic.h                            |   2 -
> >   virt/kvm/arm/aarch32.c                            |   2 +-
> >   virt/kvm/arm/arch_timer.c                         |   7 -
> >   virt/kvm/arm/arm.c                                |  50 ++-
> >   virt/kvm/arm/hyp/timer-sr.c                       |  44 +--
> >   virt/kvm/arm/hyp/vgic-v3-sr.c                     | 244 +++++++------
> >   virt/kvm/arm/mmu.c                                |   6 +-
> >   virt/kvm/arm/pmu.c                                |  37 +-
> >   virt/kvm/arm/vgic/vgic-init.c                     |  11 -
> >   virt/kvm/arm/vgic/vgic-v2.c                       |  61 +++-
> >   virt/kvm/arm/vgic/vgic-v3.c                       |  12 +-
> >   virt/kvm/arm/vgic/vgic.c                          |  21 ++
> >   virt/kvm/arm/vgic/vgic.h                          |   3 +
> >   41 files changed, 1229 insertions(+), 701 deletions(-)
> >   rename {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c (50%)
> > 

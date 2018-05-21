From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [kvmarm:queue 13/29]
 arch/arm/kvm/../../../virt/kvm/arm/arm.c:1598:6: error: implicit declaration
 of function 'system_supports_sve'
Date: Mon, 21 May 2018 11:18:01 +0100
Message-ID: <20180521101800.GC13470@e103592.cambridge.arm.com>
References: <201805210615.tc7bzjhx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <201805210615.tc7bzjhx%fengguang.wu@intel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 21, 2018 at 06:12:16AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git queue
> head:   f2d1aab22d57235b58db391d318727d3e5ef1e89
> commit: 61d47b5d95db9a4ce12c50ffaa6918a40619984f [13/29] KVM: arm64: Save host SVE context as appropriate
> config: arm-axm55xx_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 61d47b5d95db9a4ce12c50ffaa6918a40619984f
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
>    arch/arm/kvm/../../../virt/kvm/arm/arm.c:785:3: error: implicit declaration of function 'kvm_arch_vcpu_ctxsync_fp'; did you mean 'kvm_arch_vcpu_put_fp'? [-Werror=implicit-function-declaration]
>       kvm_arch_vcpu_ctxsync_fp(vcpu);
>       ^~~~~~~~~~~~~~~~~~~~~~~~
>       kvm_arch_vcpu_put_fp
>    arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_init':
> >> arch/arm/kvm/../../../virt/kvm/arm/arm.c:1598:6: error: implicit declaration of function 'system_supports_sve' [-Werror=implicit-function-declaration]
>      if (system_supports_sve() && !has_vhe()) {
>          ^~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/system_supports_sve +1598 arch/arm/kvm/../../../virt/kvm/arm/arm.c
> 
>   1564	
>   1565	/**
>   1566	 * Initialize Hyp-mode and memory mappings on all CPUs.
>   1567	 */
>   1568	int kvm_arch_init(void *opaque)
>   1569	{
>   1570		int err;
>   1571		int ret, cpu;
>   1572		bool in_hyp_mode;
>   1573	
>   1574		if (!is_hyp_mode_available()) {
>   1575			kvm_info("HYP mode not available\n");
>   1576			return -ENODEV;
>   1577		}
>   1578	
>   1579		for_each_online_cpu(cpu) {
>   1580			smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
>   1581			if (ret < 0) {
>   1582				kvm_err("Error, CPU %d not supported!\n", cpu);
>   1583				return -ENODEV;
>   1584			}
>   1585		}
>   1586	
>   1587		/*
>   1588		 * VHE is a prerequisite for SVE in the Arm architecture, and
>   1589		 * Kconfig ensures that if system_supports_sve() here then
>   1590		 * CONFIG_ARM64_VHE is enabled, so if VHE support wasn't already
>   1591		 * detected and enabled, the CPU is architecturally
>   1592		 * noncompliant.
>   1593		 *
>   1594		 * Just in case this mismatch is seen, detect it, warn and give
>   1595		 * up.  Supporting this forbidden configuration in Hyp would be
>   1596		 * pointless.
>   1597		 */
> > 1598		if (system_supports_sve() && !has_vhe()) {

OK, these were a couple of brainos in a late version of the branch that
I didn't rebuild for arm, where things got renamed or I inserted
arm64-specific calls in common code.  My bad :(

I'll push out fixes today.

Cheers
---Dave

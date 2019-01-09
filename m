From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [kvmarm:kvm-arm64/nv-wip-v5.0-rc1 4/75]
 arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:700:7: error:
 'SYS_CNTP_TVAL_EL0' undeclared
Date: Wed, 9 Jan 2019 09:13:23 +0000
Message-ID: <a82a7868-f3c0-0b3e-d0b7-182992c268fa@arm.com>
References: <201901091219.igdmvhpC%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1A74A2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 04:14:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48d0Gpi+EATT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 04:14:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1874A3A1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 04:14:51 -0500 (EST)
In-Reply-To: <201901091219.igdmvhpC%fengguang.wu@intel.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/01/2019 04:40, kbuild test robot wrote:

Marc, Christoffer,

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm64/nv-wip-v5.0-rc1
> head:   688c386ca096f2c1f2eee386697586c88df5d5bc
> commit: 2b1265c58a873d917e99ac762e243c1274481dbf [4/75] KVM: arm/arm64: consolidate arch timer trap handlers
> config: arm-axm55xx_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 2b1265c58a873d917e99ac762e243c1274481dbf
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.2.0 make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):

I was looking at this yesterday: It's a bit nasty, don't know a good
solution beside bringing back this part of my original timer rework series.
The problem is that those symbols contains the Aarch64 specific
(instruction) encoding of the timer registers, plus we need the AArch32
encodings for 32-on-64 guests.

That's why I used the generic UAPI encoding for the registers, because
we only need *some* identification for them, it doesn't need to be
something defined by the architecture.
Since arch_timer.c is shared, but sys_regs.c and coproc.c are arch
specific already, it seems natural to do the conversion in the trap
handler and keep the arch_timer code generic.

Does that make sense? I was a bit hesitant as it works against some of
your changes.

Cheers,
Andre.

> 
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c: In function 'get_timer_from_sysreg':
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:700:7: error: 'SYS_CNTP_TVAL_EL0' undeclared (first use in this function)
>      case SYS_CNTP_TVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:700:7: note: each undeclared identifier is reported only once for each function it appears in
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:701:7: error: 'SYS_CNTP_CTL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CTL_EL0:
>           ^~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:702:7: error: 'SYS_CNTP_CVAL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:703:7: error: 'SYS_AARCH32_CNTP_TVAL' undeclared (first use in this function)
>      case SYS_AARCH32_CNTP_TVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:704:7: error: 'SYS_AARCH32_CNTP_CTL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CTL:
>           ^~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
>>> arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:705:7: error: 'SYS_AARCH32_CNTP_CVAL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c: In function 'kvm_arm_timer_read_sysreg':
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:723:7: error: 'SYS_CNTP_TVAL_EL0' undeclared (first use in this function)
>      case SYS_CNTP_TVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:724:7: error: 'SYS_AARCH32_CNTP_TVAL' undeclared (first use in this function)
>      case SYS_AARCH32_CNTP_TVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:728:7: error: 'SYS_CNTP_CTL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CTL_EL0:
>           ^~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:729:7: error: 'SYS_AARCH32_CNTP_CTL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CTL:
>           ^~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:733:7: error: 'SYS_CNTP_CVAL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:734:7: error: 'SYS_AARCH32_CNTP_CVAL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c: In function 'kvm_arm_timer_write_sysreg':
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:758:7: error: 'SYS_CNTP_TVAL_EL0' undeclared (first use in this function)
>      case SYS_CNTP_TVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:759:7: error: 'SYS_AARCH32_CNTP_TVAL' undeclared (first use in this function)
>      case SYS_AARCH32_CNTP_TVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:763:7: error: 'SYS_CNTP_CTL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CTL_EL0:
>           ^~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:764:7: error: 'SYS_AARCH32_CNTP_CTL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CTL:
>           ^~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:768:7: error: 'SYS_CNTP_CVAL_EL0' undeclared (first use in this function); did you mean 'SYS_CNTP_TVAL_EL0'?
>      case SYS_CNTP_CVAL_EL0:
>           ^~~~~~~~~~~~~~~~~
>           SYS_CNTP_TVAL_EL0
>    arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:769:7: error: 'SYS_AARCH32_CNTP_CVAL' undeclared (first use in this function); did you mean 'SYS_AARCH32_CNTP_TVAL'?
>      case SYS_AARCH32_CNTP_CVAL:
>           ^~~~~~~~~~~~~~~~~~~~~
>           SYS_AARCH32_CNTP_TVAL
> 
> vim +/SYS_CNTP_TVAL_EL0 +700 arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c
> 
>    695	
>    696	static struct arch_timer_context *get_timer_from_sysreg(struct kvm_vcpu *vcpu,
>    697								u32 sr)
>    698	{
>    699		switch (sr) {
>  > 700		case SYS_CNTP_TVAL_EL0:
>  > 701		case SYS_CNTP_CTL_EL0:
>  > 702		case SYS_CNTP_CVAL_EL0:
>  > 703		case SYS_AARCH32_CNTP_TVAL:
>  > 704		case SYS_AARCH32_CNTP_CTL:
>  > 705		case SYS_AARCH32_CNTP_CVAL:
>    706			return vcpu_ptimer(vcpu);
>    707		default:
>    708			BUG();
>    709		}
>    710	}
>    711	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

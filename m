From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Sat, 31 Oct 2015 10:06:46 +0800
Message-ID: <56342236.4020108@huawei.com>
References: <201510302030.qrh0XuT1%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 061C7410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 22:04:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9Q2+1N16zxF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2015 22:04:43 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0F8241049
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 22:04:37 -0400 (EDT)
In-Reply-To: <201510302030.qrh0XuT1%fengguang.wu@intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kbuild test robot <lkp@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, shannon.zhao@linaro.org, will.deacon@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Thanks for your test:)
It fails because there is no arch/arm/include/asm/pmu.h while
arch/arm64/include/asm/pmu.h exists. Will fix this at next version.

On 2015/10/30 20:08, kbuild test robot wrote:
> Hi Shannon,
> 
> [auto build test ERROR on kvm/linux-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
> 
> url:    https://github.com/0day-ci/linux/commits/Shannon-Zhao/KVM-ARM64-Add-guest-PMU-support/20151030-143148
> config: arm-axm55xx_defconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/arm/kvm/arm.c:31:0:
>>> include/kvm/arm_pmu.h:22:21: fatal error: asm/pmu.h: No such file or directory
>     #include <asm/pmu.h>
>                         ^
>    compilation terminated.
> 
> vim +22 include/kvm/arm_pmu.h
> 
> 219856f5 Shannon Zhao 2015-10-30  16   */
> 219856f5 Shannon Zhao 2015-10-30  17  
> 219856f5 Shannon Zhao 2015-10-30  18  #ifndef __ASM_ARM_KVM_PMU_H
> 219856f5 Shannon Zhao 2015-10-30  19  #define __ASM_ARM_KVM_PMU_H
> 219856f5 Shannon Zhao 2015-10-30  20  
> 219856f5 Shannon Zhao 2015-10-30  21  #include <linux/perf_event.h>
> 219856f5 Shannon Zhao 2015-10-30 @22  #include <asm/pmu.h>
> 219856f5 Shannon Zhao 2015-10-30  23  
> 219856f5 Shannon Zhao 2015-10-30  24  struct kvm_pmc {
> 219856f5 Shannon Zhao 2015-10-30  25  	u8 idx;/* index into the pmu->pmc array */
> 
> :::::: The code at line 22 was first introduced by commit
> :::::: 219856f54d23298fff48e6e20e7e87fc45e42798 KVM: ARM64: Define PMU data structure for each vcpu
> 
> :::::: TO: Shannon Zhao <shannon.zhao@linaro.org>
> :::::: CC: 0day robot <fengguang.wu@intel.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

-- 
Shannon

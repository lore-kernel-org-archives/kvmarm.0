From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [kvmarm:master 7/8]
 arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1705:36: error: implicit declaration
 of function 'kvm_stage2_has_pmd'; did you mean 'kvm_stage2_has_pud'?
Date: Mon, 4 Feb 2019 09:20:15 +0000
Message-ID: <f915d215-7f04-b048-b7ae-4cd6183096ae@arm.com>
References: <201902021846.dWX0ezZV%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A884A330
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 04:20:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTnnPFcxJ1B2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 04:20:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 719D94A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 04:20:21 -0500 (EST)
In-Reply-To: <201902021846.dWX0ezZV%fengguang.wu@intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lkp@intel.com
Cc: marc.zyngier@arm.com, kbuild-all@01.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 02/02/2019 10:50, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git master
> head:   a7d7d3ebc7d441ee48e1fd87d9a8abbf7d528127
> commit: 4cc936fd184a2641801c906ea320326317895397 [7/8] KVM: arm64: Relax the restriction on using stage2 PUD huge mapping
> config: arm-axm55xx_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 8.2.0-11) 8.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 4cc936fd184a2641801c906ea320326317895397
>          # save the attached .config to linux build tree
>          GCC_VERSION=8.2.0 make.cross ARCH=arm
> 
> All errors (new ones prefixed by >>):
> 
>     arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'user_mem_abort':
>>> arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1705:36: error: implicit declaration of function 'kvm_stage2_has_pmd'; did you mean 'kvm_stage2_has_pud'? [-Werror=implicit-function-declaration]
>            (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>                                         ^~~~~~~~~~~~~~~~~~
>                                         kvm_stage2_has_pud
>     cc1: some warnings being treated as errors
> 
> vim +1705 arch/arm/kvm/../../../virt/kvm/arm/mmu.c


Thanks for the report. I will fix this by adding dummy definitions for arm32.

Suzuki

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543C6C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:09:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96D949EB1;
	Sat, 23 Apr 2022 04:09:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FOjX+UJAvyYR; Sat, 23 Apr 2022 04:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3272640BED;
	Sat, 23 Apr 2022 04:09:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 418CC49F55
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 04:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F4jdB2MjwpLB for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2022 04:09:16 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41F6749F4A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 04:09:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1650701356; x=1682237356;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=FFxlNihVEolpriYnsSloMndObmA0fWh9gsMeNYrdUkg=;
 b=CQ+EMOVovg9+/qONL3XfRhHD8txYdCfHi+f2JhLlGzxG+HMiMC9TT2zn
 K6daw6v3z0RwKYuHK1tqQcwnr99I65JujL7DzlKfwscVIxCZiJAMEhLEN
 yCdpzDbABgWt03Pl2+GuCC+gTiqL9hTCP1Wdc+7x2uZAIYGREpLsuYpoi
 aQYSfrDFFT6CiFtPEX7Yi5gFNVOLHmh+vDwBWXsByivNEIZOXA9r6pMk3
 vEouaFO5woH5/SN6eoLOCfc2KZZFIFEVAeRqhgsi5GDCbYvCvQJw06iRe
 ccT317foyV+PmTWy7FAqcLxiaL24ZpqCFnx9kmGkjz27dk1BkLHLcxybs Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="351315746"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; d="scan'208";a="351315746"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Apr 2022 01:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; d="scan'208";a="648956790"
Received: from lkp-server01.sh.intel.com (HELO dd58949a6e39) ([10.239.97.150])
 by FMSMGA003.fm.intel.com with ESMTP; 23 Apr 2022 01:09:10 -0700
Received: from kbuild by dd58949a6e39 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1niApJ-00003n-TL;
 Sat, 23 Apr 2022 08:09:10 +0000
Date: Sat, 23 Apr 2022 16:08:10 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 19/20] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <202204231516.bclimUe4-lkp@intel.com>
References: <20220422210546.458943-20-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-20-dmatlack@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, kbuild-all@lists.01.org,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Hi David,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 150866cd0ec871c765181d145aa0912628289c8a]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220423-062108
base:   150866cd0ec871c765181d145aa0912628289c8a
config: riscv-randconfig-r005-20220422 (https://download.01.org/0day-ci/archive/20220423/202204231516.bclimUe4-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/871c5afc76a6f414c03f433d06bacfd928910b1b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220423-062108
        git checkout 871c5afc76a6f414c03f433d06bacfd928910b1b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   arch/riscv/kvm/mmu.c: In function 'stage2_ioremap':
>> arch/riscv/kvm/mmu.c:364:56: error: 'struct kvm_mmu_memory_cache' has no member named 'cache'
     364 |                 ret = kvm_mmu_topup_memory_cache(&cache.cache, stage2_pgd_levels);
         |                                                        ^
   arch/riscv/kvm/mmu.c:369:52: error: 'struct kvm_mmu_memory_cache' has no member named 'cache'
     369 |                 ret = stage2_set_pte(kvm, 0, &cache.cache, addr, &pte);
         |                                                    ^
   arch/riscv/kvm/mmu.c:378:41: error: 'struct kvm_mmu_memory_cache' has no member named 'cache'
     378 |         kvm_mmu_free_memory_cache(&cache.cache);
         |                                         ^
>> arch/riscv/kvm/mmu.c:350:37: warning: variable 'cache' set but not used [-Wunused-but-set-variable]
     350 |         struct kvm_mmu_memory_cache cache = {
         |                                     ^~~~~


vim +364 arch/riscv/kvm/mmu.c

   342	
   343	static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
   344				  unsigned long size, bool writable)
   345	{
   346		pte_t pte;
   347		int ret = 0;
   348		unsigned long pfn;
   349		phys_addr_t addr, end;
 > 350		struct kvm_mmu_memory_cache cache = {
   351			.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
   352			.gfp_zero = __GFP_ZERO,
   353		};
   354	
   355		end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
   356		pfn = __phys_to_pfn(hpa);
   357	
   358		for (addr = gpa; addr < end; addr += PAGE_SIZE) {
   359			pte = pfn_pte(pfn, PAGE_KERNEL);
   360	
   361			if (!writable)
   362				pte = pte_wrprotect(pte);
   363	
 > 364			ret = kvm_mmu_topup_memory_cache(&cache.cache, stage2_pgd_levels);
   365			if (ret)
   366				goto out;
   367	
   368			spin_lock(&kvm->mmu_lock);
   369			ret = stage2_set_pte(kvm, 0, &cache.cache, addr, &pte);
   370			spin_unlock(&kvm->mmu_lock);
   371			if (ret)
   372				goto out;
   373	
   374			pfn++;
   375		}
   376	
   377	out:
   378		kvm_mmu_free_memory_cache(&cache.cache);
   379		return ret;
   380	}
   381	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F39C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 24 Apr 2022 15:21:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA19E40B6C;
	Sun, 24 Apr 2022 11:21:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dh1U3HGMHKC8; Sun, 24 Apr 2022 11:21:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F346549ECB;
	Sun, 24 Apr 2022 11:21:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DCA449B07
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Apr 2022 11:21:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s7lo30E7BA88 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 24 Apr 2022 11:21:49 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33F4C49B26
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Apr 2022 11:21:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1650813709; x=1682349709;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=eIHnhfDbluDI+XDea6eH7Q41SXR8SjqhHXj2rb5GifQ=;
 b=GQ6JkZdf8Fp0Xs6CwVmbUerImSuQ5NJDjIFpKrqtoGKmkIPdoPrP1JxA
 Mov99PDHLIRgQD9hFejESItSzBomIz252DQDwjG36Mccq6uVcw6E1aUZG
 6k+ssDRg1kSUdCt6vbWuNZPJH8u9fIKZjpSMKbY2vTSYLn8zmFYcK4UQz
 uhael2WXDn39ytC4t4+tCUO0F2jdV6n6939QZ80HN3SCiurctXTSSpmye
 BJQ39m0WopAKFqaPW0SbhjlP0EPPaD68Sq9Dg5JhMByCfK9Xq85yRVj8g
 jiQSzCU5edoxJKOb7wJ9eBn0kh5Gujm74wZz8qfJE7SuCUOghadvwt68E g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="245622929"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; d="scan'208";a="245622929"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Apr 2022 08:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; d="scan'208";a="616149527"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by fmsmga008.fm.intel.com with ESMTP; 24 Apr 2022 08:21:43 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nie3T-0001Yh-9I;
 Sun, 24 Apr 2022 15:21:43 +0000
Date: Sun, 24 Apr 2022 23:21:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 19/20] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <202204242355.T1SzNT9S-lkp@intel.com>
References: <20220422210546.458943-20-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-20-dmatlack@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, kbuild-all@lists.01.org,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 llvm@lists.linux.dev,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Ben Gardon <bgardon@google.com>,
 maciej.szmigiero@oracle.com,
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
config: riscv-randconfig-r016-20220424 (https://download.01.org/0day-ci/archive/20220424/202204242355.T1SzNT9S-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1cddcfdc3c683b393df1a5c9063252eb60e52818)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/871c5afc76a6f414c03f433d06bacfd928910b1b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220423-062108
        git checkout 871c5afc76a6f414c03f433d06bacfd928910b1b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/mmu.c:364:43: error: no member named 'cache' in 'struct kvm_mmu_memory_cache'
                   ret = kvm_mmu_topup_memory_cache(&cache.cache, stage2_pgd_levels);
                                                     ~~~~~ ^
   arch/riscv/kvm/mmu.c:369:39: error: no member named 'cache' in 'struct kvm_mmu_memory_cache'
                   ret = stage2_set_pte(kvm, 0, &cache.cache, addr, &pte);
                                                 ~~~~~ ^
   arch/riscv/kvm/mmu.c:378:35: error: no member named 'cache' in 'struct kvm_mmu_memory_cache'
           kvm_mmu_free_memory_cache(&cache.cache);
                                      ~~~~~ ^
   3 errors generated.


vim +364 arch/riscv/kvm/mmu.c

   342	
   343	static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
   344				  unsigned long size, bool writable)
   345	{
   346		pte_t pte;
   347		int ret = 0;
   348		unsigned long pfn;
   349		phys_addr_t addr, end;
   350		struct kvm_mmu_memory_cache cache = {
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

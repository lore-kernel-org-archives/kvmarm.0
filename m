Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF2EC433EF
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 07:01:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A564B2A5;
	Sat,  2 Apr 2022 03:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19R6C+851M0t; Sat,  2 Apr 2022 03:01:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F1EF4B2BF;
	Sat,  2 Apr 2022 03:01:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB884B2BD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 03:01:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id srHPyFMFGTqW for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 03:01:47 -0400 (EDT)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 672834B2A5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 03:01:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1648882907; x=1680418907;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=5fQpfgHL+BcKJLXV9JlywPoB0By7fPM3sgcVDusgY2k=;
 b=iGirB6rKI1bQ3Q27pODBJqQbBpNdhP+qojRwwT3ExyIRSIQfTcehAjJw
 d58+G27MPiQf5zD+k9zV4hBh3XwCdlhCenLuneKktinN5awXb1sWy6c/u
 Y/xKPhzZydkaVBcUl068TQgpz75UlNqBjhAgtRK5D9OiJ7Go1vGdhP0d3
 HcSyzaRUXCnni5A/E+nM7IWVwk1cqIF/capJWjanPGpWk1d1d/s37wC8H
 wM+S9tO9Phk5/7Un67DwrpHwL5r7bxBQGAMVwHe3CnCWQIkHXuv+gxw91
 kGWaMnXgl8Iv3GlbuEPSumJUCtG5uhKWTVBtpNyPSUz1KfC61DjDXEToV Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="259111331"
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; d="scan'208";a="259111331"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Apr 2022 00:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; d="scan'208";a="845542078"
Received: from lkp-server02.sh.intel.com (HELO 3231c491b0e2) ([10.239.97.151])
 by fmsmga005.fm.intel.com with ESMTP; 02 Apr 2022 00:01:41 -0700
Received: from kbuild by 3231c491b0e2 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1naXlV-0001zS-6J;
 Sat, 02 Apr 2022 07:01:41 +0000
Date: Sat, 2 Apr 2022 15:01:16 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 16/23] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <202204021411.oOhP2vFP-lkp@intel.com>
References: <20220401175554.1931568-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-17-dmatlack@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220402-015911
base:   19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220402/202204021411.oOhP2vFP-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c4a1b07d0979e7ff20d7d541af666d822d66b566)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5f7a06676291033d880081035c2efae13702a0c4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220402-015911
        git checkout 5f7a06676291033d880081035c2efae13702a0c4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:766:8: warning: format specifies type 'unsigned long long' but the argument has type 'int' [-Wformat]
                                      sp->role.access, access);
                                      ^~~~~~~~~~~~~~~
   include/linux/printk.h:654:45: note: expanded from macro 'pr_err_ratelimited'
           printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                              ~~~     ^~~~~~~~~~~
   include/linux/printk.h:640:17: note: expanded from macro 'printk_ratelimited'
                   printk(fmt, ##__VA_ARGS__);                             \
                          ~~~    ^~~~~~~~~~~
   include/linux/printk.h:446:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:418:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
>> arch/x86/kvm/mmu/mmu.c:766:25: warning: format specifies type 'unsigned long long' but the argument has type 'u32' (aka 'unsigned int') [-Wformat]
                                      sp->role.access, access);
                                                       ^~~~~~
   include/linux/printk.h:654:45: note: expanded from macro 'pr_err_ratelimited'
           printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                              ~~~     ^~~~~~~~~~~
   include/linux/printk.h:640:17: note: expanded from macro 'printk_ratelimited'
                   printk(fmt, ##__VA_ARGS__);                             \
                          ~~~    ^~~~~~~~~~~
   include/linux/printk.h:446:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:418:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   2 warnings generated.


vim +766 arch/x86/kvm/mmu/mmu.c

   754	
   755	static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
   756	{
   757		if (!sp->role.direct) {
   758			sp->shadowed_translation[index].access = access;
   759			return;
   760		}
   761	
   762		if (WARN_ON(access != sp->role.access))
   763			pr_err_ratelimited("access mismatch under direct page %llx "
   764					   "(expected %llx, got %llx)\n",
   765					   kvm_mmu_page_get_gfn(sp, index),
 > 766					   sp->role.access, access);
   767	}
   768	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

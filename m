Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49567C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 06:19:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B89924B2DD;
	Sat,  2 Apr 2022 02:19:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OF+2A0OEMfVy; Sat,  2 Apr 2022 02:19:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F8654B2DE;
	Sat,  2 Apr 2022 02:19:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEBCB4B2DC
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 02:19:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OyKwEp9ZZ3yl for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 02:19:44 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B93A94B2CF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 02:19:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1648880384; x=1680416384;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=UjSUeGlmXpsPEBh2KODuoUS52M/OuM8DBv+VanaakrM=;
 b=fvVnsySCc4CquAFuWYgt4qJhI9n2H+9bpSciKLeHTfje1ZhbRxKP7gJn
 jdz2t68t6Ao1c3Eav+43A166XwmcwDmZuqXZiSKqYNlQpfAsQHzONJqCa
 i8vnxvKaYoEP6o1kJO77k3Z0kHwI3obe8o6G/sKk2PHT6uVmDdT838WW1
 ka7jPqK02re6/CQuJo7lqLSTk3Ap+69UD9RBRqa8LTqoBkhtkskV7gw+R
 s24XEHVrJnrWQ0OGs3zYjiF8xTmgC+iZQLjePoi9bmGdU51eRpuG9q1xX
 0sg6rtuSM32Qgd4SgwLKeXgzsfSZm0NjZc2X9pAJqYpqti+O4cyv6VT0c Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="346719615"
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; d="scan'208";a="346719615"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 01 Apr 2022 23:19:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; d="scan'208";a="504401639"
Received: from lkp-server02.sh.intel.com (HELO 3231c491b0e2) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 01 Apr 2022 23:19:38 -0700
Received: from kbuild by 3231c491b0e2 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1naX6n-0001mu-JV;
 Sat, 02 Apr 2022 06:19:37 +0000
Date: Sat, 2 Apr 2022 14:19:32 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 16/23] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <202204021419.Rh6Pgcl9-lkp@intel.com>
References: <20220401175554.1931568-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-17-dmatlack@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220402-015911
base:   19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
config: x86_64-randconfig-a002 (https://download.01.org/0day-ci/archive/20220402/202204021419.Rh6Pgcl9-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/5f7a06676291033d880081035c2efae13702a0c4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-Extend-Eager-Page-Splitting-to-the-shadow-MMU/20220402-015911
        git checkout 5f7a06676291033d880081035c2efae13702a0c4
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:29,
                    from include/linux/cpumask.h:10,
                    from include/linux/mm_types_task.h:14,
                    from include/linux/mm_types.h:5,
                    from arch/x86/kvm/irq.h:13,
                    from arch/x86/kvm/mmu/mmu.c:18:
   arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_page_set_access':
>> include/linux/kern_levels.h:5:25: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:418:25: note: in definition of macro 'printk_index_wrap'
     418 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:640:17: note: in expansion of macro 'printk'
     640 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                 ^~~~~~
   include/linux/printk.h:654:9: note: in expansion of macro 'printk_ratelimited'
     654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:654:28: note: in expansion of macro 'KERN_ERR'
     654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                            ^~~~~~~~
   arch/x86/kvm/mmu/mmu.c:763:17: note: in expansion of macro 'pr_err_ratelimited'
     763 |                 pr_err_ratelimited("access mismatch under direct page %llx "
         |                 ^~~~~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'u32' {aka 'unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:418:25: note: in definition of macro 'printk_index_wrap'
     418 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:640:17: note: in expansion of macro 'printk'
     640 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                 ^~~~~~
   include/linux/printk.h:654:9: note: in expansion of macro 'printk_ratelimited'
     654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:654:28: note: in expansion of macro 'KERN_ERR'
     654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                            ^~~~~~~~
   arch/x86/kvm/mmu/mmu.c:763:17: note: in expansion of macro 'pr_err_ratelimited'
     763 |                 pr_err_ratelimited("access mismatch under direct page %llx "
         |                 ^~~~~~~~~~~~~~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a7 Joe Perches 2012-07-30  4  
04d2c8c83d0e3ac Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3ac Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3ac Joe Perches 2012-07-30  7  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

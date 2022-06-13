Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC94C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jun 2022 06:50:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 998874B3C6;
	Mon, 13 Jun 2022 02:50:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xZtNHG1K+XEZ; Mon, 13 Jun 2022 02:50:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437F24B3ED;
	Mon, 13 Jun 2022 02:50:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A4CB4B2D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 02:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dq4xNEUfcgxz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jun 2022 02:49:55 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4227E4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 02:49:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1655102995; x=1686638995;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=RGtR00YXznzblbZw6feUnIn4iE2iFhjqHOStGqIumPY=;
 b=V9Ye6o2uMtrRW7SmARjBazCORoyzXnYXjYyr1soJ7tVCl4EqKO2nFd80
 OniKRvg3E/E6F9XYtLacSkqXLt3iHH1ybeDypB7XrWaov9gmyoOSD+BB/
 WGd2mWblziwx1QroQrUnb/NRrmmIjp2hQGspo3e2hFtQjh5ADK5NEtqLd
 ITj+6uNcxvZv56S7SPOqmJRSQnjbY/Ul2N3PQLhZyxPRWWF6IvdCLikhg
 Ufv5y2lK21Wazagr0OczeJbW5NUfhoXN2rwS5fLymPVx0cgFB12kZdbMK
 0X3L4bAG8p3QnNivnfgnVPbo8BcYrO55JodNN0KQ12L9bb53b7DpxkGII A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="303580588"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; d="scan'208";a="303580588"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 12 Jun 2022 23:49:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; d="scan'208";a="567782758"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
 by orsmga002.jf.intel.com with ESMTP; 12 Jun 2022 23:49:47 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1o0dtS-000Kaj-UI;
 Mon, 13 Jun 2022 06:49:46 +0000
Date: Mon, 13 Jun 2022 14:49:29 +0800
From: kernel test robot <lkp@intel.com>
To: Kalesh Singh <kaleshsingh@google.com>, mark.rutland@arm.com,
 broonie@kernel.org, maz@kernel.org
Subject: Re: [PATCH v3 5/5] KVM: arm64: Unwind and dump nVHE hypervisor
 stacktrace
Message-ID: <202206131423.8tjrMBgk-lkp@intel.com>
References: <20220607165105.639716-6-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220607165105.639716-6-kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, surenb@google.com, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 tjmercier@google.com, kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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

Hi Kalesh,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on f2906aa863381afb0015a9eb7fefad885d4e5a56]

url:    https://github.com/intel-lab-lkp/linux/commits/Kalesh-Singh/KVM-nVHE-Hypervisor-stack-unwinder/20220608-011351
base:   f2906aa863381afb0015a9eb7fefad885d4e5a56
config: arm64-randconfig-c024-20220612 (https://download.01.org/0day-ci/archive/20220613/202206131423.8tjrMBgk-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ac1ce397ffe5b05df06cdb56a30db4099c7428ec
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kalesh-Singh/KVM-nVHE-Hypervisor-stack-unwinder/20220608-011351
        git checkout ac1ce397ffe5b05df06cdb56a30db4099c7428ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   aarch64-linux-ld: arch/arm64/kernel/stacktrace.o: in function `hyp_dump_backtrace':
>> arch/arm64/kernel/stacktrace.c:254: undefined reference to `kvm_arm_hyp_stacktrace_page'
   aarch64-linux-ld: arch/arm64/kernel/stacktrace.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `kvm_arm_hyp_stacktrace_page' which may bind externally can not be used when making a shared object; recompile with -fPIC
   arch/arm64/kernel/stacktrace.c:254:(.text+0x634): dangerous relocation: unsupported relocation
>> aarch64-linux-ld: arch/arm64/kernel/stacktrace.c:254: undefined reference to `kvm_arm_hyp_stacktrace_page'
   pahole: .tmp_vmlinux.btf: No such file or directory
   .btf.vmlinux.bin.o: file not recognized: file format not recognized


vim +254 arch/arm64/kernel/stacktrace.c

   246	
   247	/**
   248	 * Symbolizes and dumps the hypervisor backtrace from the shared
   249	 * stacktrace page.
   250	 */
   251	noinline notrace void hyp_dump_backtrace(unsigned long hyp_offset)
   252	{
   253		unsigned long *stacktrace_pos =
 > 254			(unsigned long *)*this_cpu_ptr(&kvm_arm_hyp_stacktrace_page);
   255		unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
   256		unsigned long pc = *stacktrace_pos++;
   257	
   258		kvm_err("nVHE HYP call trace:\n");
   259	
   260		while (pc) {
   261			pc &= va_mask;		/* Mask tags */
   262			pc += hyp_offset;	/* Convert to kern addr */
   263			kvm_err("[<%016lx>] %pB\n", pc, (void *)pc);
   264			pc = *stacktrace_pos++;
   265		}
   266	
   267		kvm_err("---- end of nVHE HYP call trace ----\n");
   268	}
   269	#else /* __KVM_NVHE_HYPERVISOR__ */
   270	DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack)
   271		__aligned(16);
   272	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

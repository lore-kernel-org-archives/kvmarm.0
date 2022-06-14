Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C8FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 20:10:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB8CF4B31A;
	Tue, 14 Jun 2022 16:10:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X1Yc0cWQcV11; Tue, 14 Jun 2022 16:10:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39B9A4B303;
	Tue, 14 Jun 2022 16:10:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0994B2E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 16:10:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kLibAiG9GbdB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jun 2022 16:10:00 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A19A4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 16:10:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1655237400; x=1686773400;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=H39qclFsqZbsKF4/6iQ+SjBBp3vw55ZbnY4RJ7gbLBE=;
 b=XGdH0cpq1qb+QhFSIJTJbfsNV21emAy6deHSqNuHWzeK//mHMksz3cIq
 fL20uRSnwAGIuNIsxVZyy5SOm5EYeN5BOJ/v34nAzawHTzMXjXf65EnEf
 2WvBAiD7k0PA4B3S3o5yDUmVup2SHaYqtpCEdVMeMY9qOTN0I6re/iiyf
 vhqNJjhFlPWAa+de5r/d/IlHnqbK1+cyvABB/T/Ab9dAfn4z7ERgYbH9F
 2VkC9sdx3pUXI8smkp/Tg8lk90PE+J8qMVpLZIKpSr+CDGfJQAT8PrMYa
 EW6Udl9Xprfd0TIJnQtxr3zhafcph1bCKWviomzcmEgdu+0/bbBLbqQrJ Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="259186400"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; d="scan'208";a="259186400"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Jun 2022 13:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; d="scan'208";a="582851874"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
 by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 13:09:50 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1o1CrF-000MGT-Cq;
 Tue, 14 Jun 2022 20:09:49 +0000
Date: Wed, 15 Jun 2022 04:09:33 +0800
From: kernel test robot <lkp@intel.com>
To: Kalesh Singh <kaleshsingh@google.com>, mark.rutland@arm.com,
 broonie@kernel.org, maz@kernel.org
Subject: Re: [PATCH v3 5/5] KVM: arm64: Unwind and dump nVHE hypervisor
 stacktrace
Message-ID: <202206150420.KMU4kXzZ-lkp@intel.com>
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
 llvm@lists.linux.dev, tjmercier@google.com, kbuild-all@lists.01.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
config: arm64-buildonly-randconfig-r003-20220613 (https://download.01.org/0day-ci/archive/20220615/202206150420.KMU4kXzZ-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c97436f8b6e2718286e8496faf53a2c800e281cf)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/ac1ce397ffe5b05df06cdb56a30db4099c7428ec
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kalesh-Singh/KVM-nVHE-Hypervisor-stack-unwinder/20220608-011351
        git checkout ac1ce397ffe5b05df06cdb56a30db4099c7428ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: kvm_arm_hyp_stacktrace_page
   >>> referenced by stacktrace.c:254 (arch/arm64/kernel/stacktrace.c:254)
   >>>               kernel/stacktrace.o:(hyp_dump_backtrace) in archive arch/arm64/built-in.a
   >>> referenced by stacktrace.c:254 (arch/arm64/kernel/stacktrace.c:254)
   >>>               kernel/stacktrace.o:(hyp_dump_backtrace) in archive arch/arm64/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

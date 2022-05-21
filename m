Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89E3C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 21 May 2022 05:31:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 183B44B412;
	Sat, 21 May 2022 01:31:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pTA0OJ0d078C; Sat, 21 May 2022 01:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83DA64B224;
	Sat, 21 May 2022 01:31:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F8C4B15C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 May 2022 01:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iN+CbH3b+YMd for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 May 2022 01:31:35 -0400 (EDT)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E3E4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 May 2022 01:31:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1653111095; x=1684647095;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=pp3WYBxYIXv2CWVlcuu3e3VMZaw3NZhSkcaGgRnzNKM=;
 b=TUVusvsNl4Jo48SgUPzIinjQB5iFXlP3gtRDgUiCMQflbdtCqAuOumes
 jT6MsLIQ/qJplPOShA3a4VxHliOXJrYAGii8BYm90pyb5hFB81SuDzJ+c
 Ohwo5rkkZFBgA7OfCGwzC7v0lGJqnXpRKAkHPhsQj08mb2fDy9RxLXfvZ
 K6VoxqayRfYsgQx8uM+jk2mL1yTkyj7s19M1XjE5u3kwWf4zlQztMMaCc
 5O6bWNllrGUBn9dotuLw6L3HKzrmU1SpDOFYHtbuH26Edy87hI4r1a+bc
 NwLmEEcf5rxI33Yv19aZyboT26w6YrBJ82eEvA53DpTrt4qyOEn1RAWBE g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="333437000"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; d="scan'208";a="333437000"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 20 May 2022 22:31:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; d="scan'208";a="607337678"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
 by orsmga001.jf.intel.com with ESMTP; 20 May 2022 22:31:30 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nsHi6-0005yM-1w;
 Sat, 21 May 2022 05:31:30 +0000
Date: Sat, 21 May 2022 13:31:10 +0800
From: kernel test robot <lkp@intel.com>
To: Peng Wu <wupeng58@huawei.com>, maz@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: cancel the return value check of
 kvm_arm_init_sve()
Message-ID: <202205211307.MWDiBNQS-lkp@intel.com>
References: <20220520084911.44253-1-wupeng58@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220520084911.44253-1-wupeng58@huawei.com>
Cc: kbuild-all@lists.01.org, wupeng58@huawei.com, yuehaibing@huawei.com,
 linux-kernel@vger.kernel.org, liwei391@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Peng,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvmarm/next]
[also build test ERROR on v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Peng-Wu/KVM-arm64-cancel-the-return-value-check-of-kvm_arm_init_sve/20220520-165501
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220521/202205211307.MWDiBNQS-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4f7983bee8e912289335be279fb1f0a0abd6b31b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peng-Wu/KVM-arm64-cancel-the-return-value-check-of-kvm_arm_init_sve/20220520-165501
        git checkout 4f7983bee8e912289335be279fb1f0a0abd6b31b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/reset.c:46:6: error: conflicting types for 'kvm_arm_init_sve'; have 'void(void)'
      46 | void kvm_arm_init_sve(void)
         |      ^~~~~~~~~~~~~~~~
   In file included from include/linux/kvm_host.h:45,
                    from arch/arm64/kvm/reset.c:13:
   arch/arm64/include/asm/kvm_host.h:70:5: note: previous declaration of 'kvm_arm_init_sve' with type 'int(void)'
      70 | int kvm_arm_init_sve(void);
         |     ^~~~~~~~~~~~~~~~


vim +46 arch/arm64/kvm/reset.c

    45	
  > 46	void kvm_arm_init_sve(void)
    47	{
    48		if (system_supports_sve()) {
    49			kvm_sve_max_vl = sve_max_virtualisable_vl();
    50	
    51			/*
    52			 * The get_sve_reg()/set_sve_reg() ioctl interface will need
    53			 * to be extended with multiple register slice support in
    54			 * order to support vector lengths greater than
    55			 * VL_ARCH_MAX:
    56			 */
    57			if (WARN_ON(kvm_sve_max_vl > VL_ARCH_MAX))
    58				kvm_sve_max_vl = VL_ARCH_MAX;
    59	
    60			/*
    61			 * Don't even try to make use of vector lengths that
    62			 * aren't available on all CPUs, for now:
    63			 */
    64			if (kvm_sve_max_vl < sve_max_vl())
    65				pr_warn("KVM: SVE vector length for guests limited to %u bytes\n",
    66					kvm_sve_max_vl);
    67		}
    68	}
    69	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

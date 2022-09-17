Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEACC6FA82
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 15:11:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E047A4B85E;
	Sat, 17 Sep 2022 11:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qk12qiX8Hv9r; Sat, 17 Sep 2022 11:11:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 588284B849;
	Sat, 17 Sep 2022 11:11:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4494B845
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 11:11:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dy6Bd3-2bVhF for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2022 11:11:06 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B108A4B839
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 11:11:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1663427466; x=1694963466;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=Mg1mTmFu6agjQhhpCPwzyOWFWXDgCK6dpsoGBgS6IfY=;
 b=noCzX/F/gov13rcaewRLiZBrzt65x1aVxVkk8nxaCr2fN60jLWUMhptM
 aJUmuKw8/0o+0dnUwCN2kRKE7EfJvk3ZnMQn58sF4Nll8lPoFmQP4Y2OI
 UWuON+gs7XjLZFv4q3wLx41r88e2STaCsIwvE429LcAqWgznPjQ6r4rg6
 KFdILGOINhI9OurmvNGKZey7X+dcNw2k0MVOUC1jE//AN9jgtydvCPod5
 Hc60gtlKbf1WKILWA0P2KGMVa+fPgqht5bgH5j6MMlBPheveBKh0ns5oG
 dpSQxjlYg883E5RzEqQBj0xzmrOofybCJUJ9uH1ufq601RYO80s/rV/G9 g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10473"; a="300530239"
X-IronPort-AV: E=Sophos;i="5.93,323,1654585200"; d="scan'208";a="300530239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Sep 2022 08:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,323,1654585200"; d="scan'208";a="707071147"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
 by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2022 08:11:00 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1oZZTA-0000Qb-0C;
 Sat, 17 Sep 2022 15:11:00 +0000
Date: Sat, 17 Sep 2022 23:10:14 +0800
From: kernel test robot <lkp@intel.com>
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 2/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <202209180726.FLL69aKA-lkp@intel.com>
References: <20220916045135.154505-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220916045135.154505-3-gshan@redhat.com>
Cc: maz@kernel.org, drjones@redhat.com, kbuild-all@lists.01.org,
 shan.gavin@gmail.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 catalin.marinas@arm.com, corbet@lwn.net, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, will@kernel.org, linux-kselftest@vger.kernel.org,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org
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

Hi Gavin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvmarm/next linus/master v6.0-rc5 next-20220916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gavin-Shan/KVM-arm64-Enable-ring-based-dirty-memory-tracking/20220916-125417
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220918/202209180726.FLL69aKA-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a1a4cd8f6a5e8927f800baff7d965870a1b7d7ba
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Gavin-Shan/KVM-arm64-Enable-ring-based-dirty-memory-tracking/20220916-125417
        git checkout a1a4cd8f6a5e8927f800baff7d965870a1b7d7ba
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12: warning: no previous prototype for 'kvm_cpu_dirty_log_size' [-Wmissing-prototypes]
      14 | int __weak kvm_cpu_dirty_log_size(void)
         |            ^~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_cpu_dirty_log_size +14 arch/arm64/kvm/../../../virt/kvm/dirty_ring.c

fb04a1eddb1a65 Peter Xu 2020-09-30  13  
fb04a1eddb1a65 Peter Xu 2020-09-30 @14  int __weak kvm_cpu_dirty_log_size(void)
fb04a1eddb1a65 Peter Xu 2020-09-30  15  {
fb04a1eddb1a65 Peter Xu 2020-09-30  16  	return 0;
fb04a1eddb1a65 Peter Xu 2020-09-30  17  }
fb04a1eddb1a65 Peter Xu 2020-09-30  18  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

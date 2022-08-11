Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FB7C19F2D
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 07:17:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5154E1F8;
	Thu, 11 Aug 2022 03:17:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kbRDRqpKOGa5; Thu, 11 Aug 2022 03:17:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0ED4E1F4;
	Thu, 11 Aug 2022 03:17:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C6F4E1E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 03:17:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W88PUlJgJAR1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 03:17:00 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC71E4E1EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 03:16:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1660202219; x=1691738219;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=3KYvpST+bKbnrxkz5t5MctHL3D3UTy9lSqp411H2Tmk=;
 b=GMkmv8Nq49Ea7nl5rGHD1iZY+f6CQbDW0zrVYng/dAZMD/k6itmrpB8q
 Aj5Mc2u+QFU56L2X4mOdTSncyYO/dtS/6lXHHr4F52+PnOtAm1mi9aMr+
 Rs+alSfE9tamfT01UFKDjLXU78k5y1M6BXVzvLm45rbD1NipyzhZrjiGf
 yGBpkcW1JMVAv880adFtZskS++Y9jS9FrO6qMtwuDvw9Yt8PZ/oZHczqU
 axanUO5Jkj+xSIHZ/0eDIS7RuEf1HAwEA2FjU+RV7C/zFAucPfFGc+i0x
 JDSH79ju/eAXsmOMrXuLm14HnUR8DxV5OD1KPegoMRcxb4vcq77ffyGd8 w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="271056332"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; d="scan'208";a="271056332"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Aug 2022 00:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; d="scan'208";a="556029924"
Received: from lkp-server02.sh.intel.com (HELO d10ab0927833) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 11 Aug 2022 00:16:55 -0700
Received: from kbuild by d10ab0927833 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1oM2R4-00005F-1n;
 Thu, 11 Aug 2022 07:16:54 +0000
Date: Thu, 11 Aug 2022 15:16:08 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <202208111500.62e0Bl2l-lkp@intel.com>
References: <20220810193033.1090251-4-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-4-pcc@google.com>
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Hi Peter,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on linus/master next-20220811]
[cannot apply to kvmarm/next arm/for-next soc/for-next xilinx-xlnx/master v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20220811/202208111500.62e0Bl2l-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1a400517d8428df0ec9f86f8d303b2227ee9702f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
        git checkout 1a400517d8428df0ec9f86f8d303b2227ee9702f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> mm/memory.c:92:2: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]
      92 | #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
         |  ^~~~~~~


vim +92 mm/memory.c

42b7772812d15b Jan Beulich    2008-07-23  90  
af27d9403f5b80 Arnd Bergmann  2018-02-16  91  #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
90572890d20252 Peter Zijlstra 2013-10-07 @92  #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
75980e97daccfc Peter Zijlstra 2013-02-22  93  #endif
75980e97daccfc Peter Zijlstra 2013-02-22  94  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

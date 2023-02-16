Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D293C3B;
	Thu, 16 Feb 2023 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676547031; x=1708083031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bufIGhjRj0BeVI6DEp0mGz3xE04jkQ6oemHOFlKJy6g=;
  b=k8bk3FYMetyXoEQlH4iMbcf/I1oE+mih0tShVz8D0n/uoCe0AFKsmt6l
   ot/MsthoQ86nIlIOHy49ZR1f3VcqCQyR2vbysnDaemyCc8wWl4KqpDyEu
   uy9/t+OGDU1HJNj8mx4nTpj5/jULI6nmex7QkiX08TuSCYOGgPVxoMXJb
   +eCpFKYEj1+dEqLQFVWs64XSda1YfTsRZMiTtKI6jbmhVm/ohYM4TiCm3
   X4sxVex81VZDtJG/sZhxmChpKRpzFeNYn85PIYqOrh+qs3LVbnOmNrlTi
   dwNEH1ONOe3jk7ZzZQYWdAR4T1Ow/jqoOHpSjeHzSiKQBKINNGJN8DbTI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="331690855"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331690855"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 03:30:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793996732"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="793996732"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2023 03:30:25 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pScT2-000AE1-2m;
	Thu, 16 Feb 2023 11:30:24 +0000
Date: Thu, 16 Feb 2023 19:30:09 +0800
From: kernel test robot <lkp@intel.com>
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 03/14] KVM: arm64: PMU: Don't use the sanitized value
 for PMUVer
Message-ID: <202302161936.Uzpkezkn-lkp@intel.com>
References: <20230211031506.4159098-4-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211031506.4159098-4-reijiw@google.com>

Hi Reiji,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 4ec5183ec48656cec489c49f989c508b68b518e3]

url:    https://github.com/intel-lab-lkp/linux/commits/Reiji-Watanabe/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230211-111929
base:   4ec5183ec48656cec489c49f989c508b68b518e3
patch link:    https://lore.kernel.org/r/20230211031506.4159098-4-reijiw%40google.com
patch subject: [PATCH v4 03/14] KVM: arm64: PMU: Don't use the sanitized value for PMUVer
config: arm64-randconfig-r032-20230213 (https://download.01.org/0day-ci/archive/20230216/202302161936.Uzpkezkn-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db89896bbbd2251fff457699635acbbedeead27f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/29753380ce14f6aec0352bcc4762ba2514289849
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Reiji-Watanabe/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230211-111929
        git checkout 29753380ce14f6aec0352bcc4762ba2514289849
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/kvm/ drivers/hte/ kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302161936.Uzpkezkn-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/kvm/pmu-emul.c:1059:4: warning: no previous prototype for function 'kvm_arm_pmu_get_pmuver_limit' [-Wmissing-prototypes]
   u8 kvm_arm_pmu_get_pmuver_limit(void)
      ^
   arch/arm64/kvm/pmu-emul.c:1059:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   u8 kvm_arm_pmu_get_pmuver_limit(void)
   ^
   static 
   1 warning generated.


vim +/kvm_arm_pmu_get_pmuver_limit +1059 arch/arm64/kvm/pmu-emul.c

3d0dba5764b943 Marc Zyngier 2022-11-13  1058  
3d0dba5764b943 Marc Zyngier 2022-11-13 @1059  u8 kvm_arm_pmu_get_pmuver_limit(void)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

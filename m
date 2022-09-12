Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF3CECAAD3
	for <kvmarm@archiver.kernel.org>; Mon, 12 Sep 2022 00:45:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A7D4C543;
	Sun, 11 Sep 2022 20:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id APoSVeRVZhPS; Sun, 11 Sep 2022 20:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DEE4C4A1;
	Sun, 11 Sep 2022 20:45:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBCA4C4A1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Sep 2022 20:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ckk9uAOOaBae for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Sep 2022 20:45:24 -0400 (EDT)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18A5A4C3AA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Sep 2022 20:45:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1662943524; x=1694479524;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=viX+brJTpExQFsglg2LwYvr+BZipezfWZc8sCHKwFqc=;
 b=n6+u/XajVsNgryRAyi144zHSCI2XEwMAarfjfCCuiMsKePINQRTVicrF
 TeyDtlJy/AXaNTGQQRzp+gLvH6cuwr3uwasV9F2sQTsWeSMTvUV/huZOF
 nAB8juXTZ1yXeDw8F+Mfs4aNMrnBfbA3QRFlGOnaM4EYWlSr2gk7/UhaA
 weghoZnMQcoR7naF3klrn3lkbY5sfd7xlPoHxXcXoLkhzRjuekAB8YHgj
 q1vcpOC4b7aMv41fMCCMirN1Y0+67q/iTyjFRqWVqmTIT2yRlvuqSRFoP
 D6/lwWkgNE4AtIBCbm6R6UgayfnQepX/0m3MOiyThjCOEgM+e8gEAOa3u w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="296499921"
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; d="scan'208";a="296499921"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Sep 2022 17:45:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; d="scan'208";a="566988592"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 11 Sep 2022 17:45:19 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1oXXZe-000229-29;
 Mon, 12 Sep 2022 00:45:18 +0000
Date: Mon, 12 Sep 2022 08:44:36 +0800
From: kernel test robot <lkp@intel.com>
To: Elliot Berman <quic_eberman@quicinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3] KVM: arm64: Ignore kvm-arm.mode if
 !is_hyp_mode_available()
Message-ID: <202209120812.lW9MTQPf-lkp@intel.com>
References: <20220911214059.2767620-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220911214059.2767620-1-quic_eberman@quicinc.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>, kbuild-all@lists.01.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Elliot,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 0982c8d859f8f7022b9fd44d421c7ec721bb41f9]

url:    https://github.com/intel-lab-lkp/linux/commits/Elliot-Berman/KVM-arm64-Ignore-kvm-arm-mode-if-is_hyp_mode_available/20220912-054253
base:   0982c8d859f8f7022b9fd44d421c7ec721bb41f9
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220912/202209120812.lW9MTQPf-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2266c3455ccaa7b42a9a0be751e15a15899d99b8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Elliot-Berman/KVM-arm64-Ignore-kvm-arm-mode-if-is_hyp_mode_available/20220912-054253
        git checkout 2266c3455ccaa7b42a9a0be751e15a15899d99b8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/arm64/kvm/arm.c: In function 'early_kvm_mode_cfg':
>> arch/arm64/kvm/arm.c:2281:17: error: expected ';' before 'return'
    2281 |                 return 0;
         |                 ^~~~~~


vim +2281 arch/arm64/kvm/arm.c

  2268	
  2269	static int __init early_kvm_mode_cfg(char *arg)
  2270	{
  2271		if (!arg)
  2272			return -EINVAL;
  2273	
  2274		if (strcmp(arg, "none") == 0) {
  2275			kvm_mode = KVM_MODE_NONE;
  2276			return 0;
  2277		}
  2278	
  2279		if (!is_hyp_mode_available()) {
  2280			pr_warn_once("KVM is not available. Ignoring kvm-arm.mode\n")
> 2281			return 0;
  2282		}
  2283	
  2284		if (strcmp(arg, "protected") == 0) {
  2285			if (!is_kernel_in_hyp_mode())
  2286				kvm_mode = KVM_MODE_PROTECTED;
  2287			else
  2288				pr_warn_once("Protected KVM not available with VHE\n");
  2289	
  2290			return 0;
  2291		}
  2292	
  2293		if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
  2294			kvm_mode = KVM_MODE_DEFAULT;
  2295			return 0;
  2296		}
  2297	
  2298		return -EINVAL;
  2299	}
  2300	early_param("kvm-arm.mode", early_kvm_mode_cfg);
  2301	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

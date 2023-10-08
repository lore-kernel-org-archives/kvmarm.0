Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5771EFC04;
	Sun,  8 Oct 2023 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AU2GoFws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696803927; x=1728339927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yPD6DsIdg9+uokcveGmkjl3wIt7hKAzaaoSXHfIFMT8=;
  b=AU2GoFwsVRQ4jc41D/qBsOlQDuFenhqbFRFfhJWVAL2Rzn0xWPFNVwBr
   1UlY//ZOqfdP20tTOiMB/rGumzS/JHldQwsCuhSeYWrOhfdJW7Ylx28O+
   1PqbjxUDJRxxwEsraa2SRWHOXvUy2zT0JWIueh9NA8+tcU8yEPDkf4GhO
   1Ax/kcwzf9KPn3bQ23rpynuA8Si7j7welqB1Wg84MldaqgjN6ykOL8BjZ
   LM6ebnDcotuFKHuBwy6Ui/tZiktNZk9aoxxaRGb0sqTQYy4JGGAMQZ10w
   PvZMpXXBmQ/qlDUAKdPXLpLhOIf+fJbIMtOTMOrFBQVhBf/YUloc2VKpy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="387900176"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="387900176"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 15:25:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="869025176"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="869025176"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2023 15:25:21 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qpcD9-0005p2-1q;
	Sun, 08 Oct 2023 22:25:19 +0000
Date: Mon, 9 Oct 2023 06:25:00 +0800
From: kernel test robot <lkp@intel.com>
To: Tianyi Liu <i.pear@outlook.com>, seanjc@google.com, pbonzini@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
Message-ID: <202310090652.6TMWiCuU-lkp@intel.com>
References: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>

Hi Tianyi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB10840154D4F09917D6528BC69DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231009/202310090652.6TMWiCuU-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231009/202310090652.6TMWiCuU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310090652.6TMWiCuU-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:12917:35: error: incompatible pointer to integer conversion passing 'void *' to parameter of type 'gva_t' (aka 'unsigned long') [-Wint-conversion]
           return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
                                            ^~~~
   arch/x86/kvm/x86.c:7403:19: note: passing argument to parameter here
   EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
                     ^
   1 error generated.


vim +12917 arch/x86/kvm/x86.c

 12911	
 12912	bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)
 12913	{
 12914		struct x86_exception e;
 12915	
 12916		/* Return true on success */
 12917		return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
 12918	}
 12919	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

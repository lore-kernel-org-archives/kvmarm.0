Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F4A2584;
	Sun,  8 Oct 2023 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKEjtIrh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696800804; x=1728336804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QjUYd7D8jxKwhfKDBMGlUwHrcS+k4UsbgJEgqAWVww8=;
  b=TKEjtIrhWEIA1014hp3rRkOWFOujxcgxS04Y/A6W+J8JSQO8JtmELQ1Z
   Zd0bmzngXdwmxCwxJdIpXhQgoEdn5x3ntighVfj01s9XJztM8v/Kf36SM
   brLlBL06wMjnxfe+iDq9hCQmdxQ9liFcsz3YQhE05zgVH3ZjOCF3vTXrN
   FqEkt5fQqGIETSk/aRJpXm2KtE+AVTl3hQUdE6vYlq6JoKke1K0s3gybg
   4T0Q/9fyvnd5ZbWIDTS4lslUPXVydypPBgDZEkyEvWgJatjp0Q47+0/oH
   ThY0MqQRyn1rp7TEIvdvnDgzzwx929IpqEkmzPJkP+CCjcM6f0IyX8W7G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="5580192"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="5580192"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 14:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="787968390"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="787968390"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 08 Oct 2023 14:33:17 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qpbOl-0005mD-1l;
	Sun, 08 Oct 2023 21:33:15 +0000
Date: Mon, 9 Oct 2023 05:32:47 +0800
From: kernel test robot <lkp@intel.com>
To: Tianyi Liu <i.pear@outlook.com>, seanjc@google.com, pbonzini@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
	x86@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
Message-ID: <202310090559.wzrojQni-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB10840154D4F09917D6528BC69DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20231009/202310090559.wzrojQni-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231009/202310090559.wzrojQni-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310090559.wzrojQni-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_read_virt':
>> arch/x86/kvm/x86.c:12917:42: warning: passing argument 2 of 'kvm_read_guest_virt' makes integer from pointer without a cast [-Wint-conversion]
   12917 |         return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
         |                                          ^~~~
         |                                          |
         |                                          void *
   arch/x86/kvm/x86.c:7388:38: note: expected 'gva_t' {aka 'long unsigned int'} but argument is of type 'void *'
    7388 |                                gva_t addr, void *val, unsigned int bytes,
         |                                ~~~~~~^~~~


vim +/kvm_read_guest_virt +12917 arch/x86/kvm/x86.c

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

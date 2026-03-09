Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27C23BA229;
	Mon,  9 Mar 2026 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773064535; cv=none; b=ISPkkVknnKqNoHc3F/Pm+YdRRG28M0Oem9dxOJXvh2pPYom/kFR0UUKTagGJnk5jDjn8faSlqBl31IuBdQXx+q+Bw+28SAUJpL3+Zsv6Ns/FvOIOlr8GLIOPnq8gXZqT8g7gVk2mGb45+LxNWLfwJAgBGDBzNW5rpEd9t8W0XTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773064535; c=relaxed/simple;
	bh=LYU7f1W/6Y4395TuspVKH8/dYPrHUxLAvCr+I0YcG2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZS+d6SMGxZa3sKNQ9nMUDj8g02q5k4jAeYQmN4sV4sTntjUnyhuJmZVgODMCoaVdl1ox/CLav5uI6oWZ1uXNQ7jPCo8F/5wHUq0KRlnlP9hNtfBS4gIcEoM7C9798hX8VGW0IeavGWLvhY8QVQVthSck/PRNVFNMCAxakL3Aqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOpqqjac; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOpqqjac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773064534; x=1804600534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LYU7f1W/6Y4395TuspVKH8/dYPrHUxLAvCr+I0YcG2Q=;
  b=kOpqqjacDfRxxuJini+C94U2zhTknGVyd8pSiXC8nuTu68hcPD0vbcji
   I+aEy/FIKDCSaChMhAt7oCrMS9/TecHEA2bLfvCEr6nUXsf176KzuLr2B
   pb90rzwCEbmFONCV3HURfgl9j1gG0nYJnmnwWInRJB1Yg4fopFFMN/B5C
   lElYfY/O4CKSB5HqSdIBOSWBz1Bp5BTAp9pM+FURJn+sPgubTHn6R/qqo
   o4bXL3LIdL/OTr+3Mwb5UdlH2JR5MyenGZ7YwifoCk3iqMQ6YyeZ2VO56
   iuzORwP/1jbLzRhA+hDK6f4hJgKU0yAYCqU4E3f/FhqJSnAiz9Z+fgw1k
   A==;
X-CSE-ConnectionGUID: 7gG6zXv8Rt2WE86GGiEKJw==
X-CSE-MsgGUID: zIQDzZGTQ/S/7MtA0XnYhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="74165423"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="74165423"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 06:55:33 -0700
X-CSE-ConnectionGUID: 35g/1QXiQFu65Eoij268DQ==
X-CSE-MsgGUID: 5uUJPd0tQe+JQv+ZTet5LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="218965824"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 09 Mar 2026 06:55:29 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzb4w-000000002rB-41r0;
	Mon, 09 Mar 2026 13:55:26 +0000
Date: Mon, 9 Mar 2026 14:54:35 +0100
From: kernel test robot <lkp@intel.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
Message-ID: <202603091444.4H1PFs01-lkp@intel.com>
References: <20260309102625.2315725-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309102625.2315725-3-aneesh.kumar@kernel.org>

Hi Aneesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on tip/irq/core arm/for-next arm/fixes kvmarm/next soc/for-next linus/master v7.0-rc3 next-20260306]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Aneesh-Kumar-K-V-Arm/dma-direct-swiotlb-handle-swiotlb-alloc-free-outside-__dma_direct_alloc_pages/20260309-182834
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20260309102625.2315725-3-aneesh.kumar%40kernel.org
patch subject: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size alignment for shared buffers
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260309/202603091444.4H1PFs01-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603091444.4H1PFs01-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603091444.4H1PFs01-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:15:
   In file included from include/linux/completion.h:12:
   In file included from include/linux/swait.h:7:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:18:
   In file included from arch/x86/include/asm/irqflags.h:5:
   In file included from arch/x86/include/asm/processor-flags.h:6:
>> include/linux/mem_encrypt.h:60:9: error: use of undeclared identifier 'PAGE_SIZE'
      60 |         return PAGE_SIZE;
         |                ^
>> include/linux/mem_encrypt.h:66:9: error: call to undeclared function 'ALIGN'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      66 |         return ALIGN(size, mem_decrypt_granule_size());
         |                ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&


vim +/PAGE_SIZE +60 include/linux/mem_encrypt.h

    56	
    57	#ifndef mem_decrypt_granule_size
    58	static inline size_t mem_decrypt_granule_size(void)
    59	{
  > 60		return PAGE_SIZE;
    61	}
    62	#endif
    63	
    64	static inline size_t mem_decrypt_align(size_t size)
    65	{
  > 66		return ALIGN(size, mem_decrypt_granule_size());
    67	}
    68	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

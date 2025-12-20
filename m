Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF7426A1AC;
	Sat, 20 Dec 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766238424; cv=none; b=bx3PzT6kBTviOortKAlF1WBanXW7ESdh111e+OrbUTDL+x2HjE6Mnb9glUjfDkMLsMOvbBH4i1baX9Sxgha2H5Xo4MYbtX3AzOj/Spp7Oov8KxG8dBSum2VHCKwaiCmcq8E63wo89K3ivY1am2KKxU4tEt1/sWTLI24anarMmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766238424; c=relaxed/simple;
	bh=1pFvDAhK/0OcjfDXa8369dj+tMnoofvfLqxmhTvaU8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeEYUFp6alZ4OQTnTKdHBCwfddWnRM2vP5ejI0hTRrBnUqAvVLwRwUnJFPjMjV850ag+NKT2FrF5tn1nnJThnPTEz+bdkg++NmFEJ12BRTzxZbH30T1drsbgQksFoxe8e+MwfD/bjOVkX4XdEgskPVUPfXk4VjGm+1+8NEs3xpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3GrvDsj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3GrvDsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766238422; x=1797774422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1pFvDAhK/0OcjfDXa8369dj+tMnoofvfLqxmhTvaU8c=;
  b=a3GrvDsjN5nzOYh7jda955YPsw6myYGp4rfq/DXEoQfyjAiR3H2aZNMZ
   +fvm9eT1cPbOC5pD7NkMFv+A700urrV1UM4WuXwkxEKNtDugOFxxstccl
   jfHcao9IYbC7HOhqh9yA6N6OImvltYlBzhakVf2BWTir8jYdP9oH0jkN+
   VziUd6JCtwHJcbXPIxgdlUqah8Y3d67zezMO/pMhX5RqQ5Jr6/Szo3X6b
   iOtNpxFW4+kQQdVcXqs0e9Iy3IZM1J4krhynQOLHY5LC9wtLps3jkamJe
   +EvfYGdomg9hUypNx9JxcjRGtigzMFHlkmxQ6T0jjfSDrtFWNNa0G5OHg
   w==;
X-CSE-ConnectionGUID: swu7ZioNTS67tl/nLK06+w==
X-CSE-MsgGUID: P1/673+3R4+ZNEtvRLmQeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="70743481"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="70743481"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 05:47:00 -0800
X-CSE-ConnectionGUID: bCJ4A+TsSdWZ9Q4Ncue62A==
X-CSE-MsgGUID: CKi6IRQPS9Sz/jESAesUuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229775584"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 05:46:55 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWxIK-000000004Zz-3jrU;
	Sat, 20 Dec 2025 13:46:52 +0000
Date: Sat, 20 Dec 2025 21:46:50 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 19/46] KVM: arm64: Expose support for private memory
Message-ID: <202512202102.XFW5Jfym-lkp@intel.com>
References: <20251217101125.91098-20-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217101125.91098-20-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19-rc1 next-20251219]
[cannot apply to kvmarm/next kvm/queue kvm/next arm64/for-next/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/kvm-arm64-Include-kvm_emulate-h-in-kvm-arm_psci-h/20251218-030351
base:   linus/master
patch link:    https://lore.kernel.org/r/20251217101125.91098-20-steven.price%40arm.com
patch subject: [PATCH v12 19/46] KVM: arm64: Expose support for private memory
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20251220/202512202102.XFW5Jfym-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202102.XFW5Jfym-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202102.XFW5Jfym-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/linux/kvm_host.h:725:45: error: expected identifier or '(' before 'struct'
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                                             ^~~~~~
   arch/arm64/include/asm/kvm_host.h:1465:41: note: in definition of macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                         ^~~
>> arch/arm64/include/asm/kvm_host.h:1465:45: error: expected ')' before '->' token
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                             ^~
   include/linux/kvm_host.h:725:20: note: in expansion of macro 'kvm_arch_has_private_mem'
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:182: arch/arm64/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1314: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +725 include/linux/kvm_host.h

f481b069e67437 Paolo Bonzini       2015-05-17  723  
d1e54dd08f163a Fuad Tabba          2025-07-29  724  #ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
a7800aa80ea4d5 Sean Christopherson 2023-11-13 @725  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
a7800aa80ea4d5 Sean Christopherson 2023-11-13  726  {
a7800aa80ea4d5 Sean Christopherson 2023-11-13  727  	return false;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  728  }
a7800aa80ea4d5 Sean Christopherson 2023-11-13  729  #endif
a7800aa80ea4d5 Sean Christopherson 2023-11-13  730  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

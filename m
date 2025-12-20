Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893AB2BE7AA;
	Sat, 20 Dec 2025 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766241318; cv=none; b=kp67e5JR8FLBRIvHkDGQ4W9WnA4O/TT+npvi5xjFtoHcN+VHupBf1MWpKCAkvGKlWQoHIrJWXEpHwvcqlhQwnHrlzUAa6I1HZ4OMsRyprnC1bIWChlls9sSNUPkzDIPK2UHZAEtJM9uMM2fv5IqtmvAZWQJnWFxfWbIGO5lMVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766241318; c=relaxed/simple;
	bh=9gOKI4ydE/etDrXVJz8yRHpBpx0bgUzny4+FMywWXSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcyOk0PLy/IuJ+hak4PRYktNzQRToygVTPEeiazV8PdL3UGLFlWibxsyvAqHfBuuqLV42yUaxVUBRckI1A7FXnZxkC3e1fGF2hBQ/VcDqU+PF7ErsiPcZ0HFv1O8AhvFpx1avHXEgVc9zlMEQT2RCQ95DzKXJjlkkt7p2QJAdII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kd4dUdMF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kd4dUdMF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766241317; x=1797777317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9gOKI4ydE/etDrXVJz8yRHpBpx0bgUzny4+FMywWXSY=;
  b=kd4dUdMFDTMF1X9MXbwfCZunljEORCjHTz7w+ePk5LIWB2qgluvwCFja
   4NQWBOT60RhifzKnFPxpH5ZFPZenzRnE1kTWx9DJdzv4nbXQgPVvKoFaL
   LvY0A3n3PK5knwDJwxd+sfdzjRWozlOXTDDJx4SMzNGwgww1uABfgEecX
   G4zmWEz5lmuRvTm+ltM4TaOS7JcUrwEarBu8Wl2S4Y+iMIs9jGEmr79L2
   sQql5677cRBGbYc5HL9v212ZzXxxhCrNYdQj1cHt6yl8Cr0sRAdCQw3pn
   jTznxlqQsaBqY3cUFFWoVunkSe0+dJlUq51g/YmDYOkIzxZDZi40om7NQ
   A==;
X-CSE-ConnectionGUID: 6o/S2EgyThC5AY+Mj1sljw==
X-CSE-MsgGUID: I8MZ68hrSuqghgL+zG+4cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="93650051"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="93650051"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:35:12 -0800
X-CSE-ConnectionGUID: N++nUyL/R02YBkaHhtghhA==
X-CSE-MsgGUID: F/GGCguNQ5ye63EfybK99w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199023543"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 06:35:07 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWy2z-000000004eI-0SXZ;
	Sat, 20 Dec 2025 14:35:05 +0000
Date: Sat, 20 Dec 2025 22:34:50 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
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
Subject: Re: [PATCH v12 20/46] arm64: RMI: Allow populating initial contents
Message-ID: <202512202203.1g4jywFB-lkp@intel.com>
References: <20251217101125.91098-21-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217101125.91098-21-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc1 next-20251219]
[cannot apply to kvmarm/next kvm/queue kvm/next arm64/for-next/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/kvm-arm64-Include-kvm_emulate-h-in-kvm-arm_psci-h/20251218-030351
base:   linus/master
patch link:    https://lore.kernel.org/r/20251217101125.91098-21-steven.price%40arm.com
patch subject: [PATCH v12 20/46] arm64: RMI: Allow populating initial contents
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20251220/202512202203.1g4jywFB-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202203.1g4jywFB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202203.1g4jywFB-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/kvm/rmi.c:805:16: warning: variable 'data_flags' set but not used [-Wunused-but-set-variable]
     805 |         unsigned long data_flags = 0;
         |                       ^
   1 warning generated.


vim +/data_flags +805 arch/arm64/kvm/rmi.c

   801	
   802	int kvm_arm_rmi_populate(struct kvm *kvm,
   803				 struct kvm_arm_rmi_populate *args)
   804	{
 > 805		unsigned long data_flags = 0;
   806		unsigned long ipa_start = args->base;
   807		unsigned long ipa_end = ipa_start + args->size;
   808		int ret;
   809	
   810		if (args->reserved ||
   811		    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
   812		    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
   813		    !IS_ALIGNED(ipa_end, PAGE_SIZE))
   814			return -EINVAL;
   815	
   816		ret = realm_ensure_created(kvm);
   817		if (ret)
   818			return ret;
   819	
   820		if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
   821			data_flags |= RMI_MEASURE_CONTENT;
   822	
   823		ret = populate_region(kvm, gpa_to_gfn(ipa_start),
   824				      args->size >> PAGE_SHIFT,
   825				      args->source_uaddr, args->flags);
   826	
   827		if (ret < 0)
   828			return ret;
   829	
   830		return ret * PAGE_SIZE;
   831	}
   832	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

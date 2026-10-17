Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E62A3D954A;
	Sat, 17 Oct 2026 11:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792237796; cv=none; b=c69CGN1qIgIHsMkU+B5r8yZXtrzpL6R1D8s9GkptN8G+lgjb0fRYzWQ1wje5dpttkNQviWWFKbtDGn366mYiQecHbLTSrHQF/jEBO90q+2i5FaQwNTHhO+K1D0JI6VNZlJSvw7srqYJlIM9+f1Q2zpB7HZeKolfr4LBnV/FhG9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792237796; c=relaxed/simple;
	bh=I9rUXOsPvPb1Pr+yDalZ+a5oJd95FTQW828LowTVdXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiyknvB9OTwFE7qtx/PM5UfGG9l1cfGzunzmVM0MZVEgJQwUs2//YDmy/1ep8YshcPnBw6FaA5IlE3pX4a1T6VFjN3D0S7teyUhCUM2rC0vKrSUeh+S0axUWS9R4ZFwzNb2x3+H/Nz2lSkgdn2aKFEft9p9V7veWF4O4fkPGOrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VyfByGnW; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VyfByGnW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792237795; x=1823773795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I9rUXOsPvPb1Pr+yDalZ+a5oJd95FTQW828LowTVdXA=;
  b=VyfByGnWNKbn2kfyVg0MSWDUPSd5gMLacSgiGpVThbxumWonxg2S+Fh/
   yopAomT7444DhiWJlXp+N315x66TT6ffaEhyGkNksLfRBlrKba1pFf2Uj
   W6HJhTwuYn/NWhlCkmJlGmxhgl4e9iFFASPGaBuYosI0nvkB19hIUyiEm
   lXZ0jKTl1VRc5IS42x8xlAAjlqjKymY62JycSn/wGUCYATa7QPNWAECjl
   GiDO4/lwoJpTKHnn0KW7zQRhB6/vAMxfLlGPA1W9rQ43i77UfdVAlG/IU
   WqqTrd9R6pUCwcYQOKC5I/8aptLs2faKQlxQejNuAkxeoq7TSopsSWX4t
   A==;
X-CSE-ConnectionGUID: 0IpToEM7R7eWz8pb7aEOKw==
X-CSE-MsgGUID: ZHmIHB8LTEC4A1puyhDNHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="890581"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="890581"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2026 04:49:54 -0700
X-CSE-ConnectionGUID: DYy1T7yHTp+E+xZibSr/fQ==
X-CSE-MsgGUID: jNHTC4sES8KGI2xa8NxPhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2248423"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 17 Oct 2026 04:49:45 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xI2v0-00000000JL4-2aZn;
	Sat, 17 Oct 2026 11:49:42 +0000
Date: Sat, 17 Oct 2026 19:48:51 +0800
From: kernel test robot <lkp@intel.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 erratum E#030003
Message-ID: <202610171939.VWCcPPra-lkp@intel.com>
References: <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>

Hi Tomohiro,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907]

url:    https://github.com/intel-lab-lkp/linux/commits/Tomohiro-Misono/arm64-cputype-Add-FUJITSU-MONAKA-definition/20261016-190045
base:   24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
patch link:    https://lore.kernel.org/r/20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48%40fujitsu.com
patch subject: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA erratum E#030003
config: arm-defconfig (https://download.01.org/0day-ci/archive/20261017/202610171939.VWCcPPra-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 6719b9e31d6a93099612c474eec76d9f41d0275a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261017/202610171939.VWCcPPra-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610171939.VWCcPPra-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/irqchip/irq-gic-v3.c:1892:34: error: use of undeclared identifier 'ARM_CPU_IMP_FUJITSU'
    1892 |         if (read_cpuid_implementor() != ARM_CPU_IMP_FUJITSU ||
         |                                         ^~~~~~~~~~~~~~~~~~~
>> drivers/irqchip/irq-gic-v3.c:1893:34: error: use of undeclared identifier 'FUJITSU_CPU_PART_MONAKA'
    1893 |             read_cpuid_part_number() != FUJITSU_CPU_PART_MONAKA)
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +/ARM_CPU_IMP_FUJITSU +1892 drivers/irqchip/irq-gic-v3.c

  1889	
  1890	static bool gic_enable_quirk_fujitsu_030003(void *data)
  1891	{
> 1892		if (read_cpuid_implementor() != ARM_CPU_IMP_FUJITSU ||
> 1893		    read_cpuid_part_number() != FUJITSU_CPU_PART_MONAKA)
  1894			return false;
  1895	
  1896		static_branch_enable(&gic_fujitsu_030003_erratum);
  1897		return true;
  1898	}
  1899	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

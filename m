Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168460;
	b=fz2kIMeY1ahGosypp5aVg812eqmrnAaIq3egQIka2mYmC8PALRq3mkctK9KSmT5ioaKI
	 G85nJXprgJYvi13rupQUCsUGKKWQtfz3hJopP3zcWDzCQheip4Zdgb9HNv8OJToS3B4ME
	 lR1daaMHjLDMTJwycB2+TJsuEd4Ug3Dnk4rVXffvSuzq+kNh7sHc2g7uERck/u8MXJAaB
	 wIaj+nZ0M4KeOMvf2YHtXbQiJX4hiI7CW+fv+DY3tu7dbsCf+pTyYB79+No2EloIPoP1f
	 c2y6pzV01sVvJnd+ZjQuOb67p3CDSCl8+o0m37nkXMWXhT2dfIPBDzi3OpZ7ypgaQBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168460;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=toC7g/mQwam01PNWnVEE4EXGk05THrMqM14HugAXhgw=;
	b=FWJPojHqOc0oDQh2p/zxXfcS5/Hl02xjsfSPEh24acKy+tPpV0ghgi8FUPY7Kl1f0rfb
	 f2lbKVoBtpMZJ9sJD5IjT8EyKpUAgpWcEL8Xv1LKFMXbWmFViJg3g0usYVxFhZHrJlJpT
	 U4EkABcJAJm6vbN0f1odZom5W1RV0I/Bxh0ZC7eRdR41NTywnKL953PtgzupRI8TDw5Ue
	 IIwsqCcDL/0ejIDtlOf0XXb5NzTTYn+A3aXANUxesarrxaT00wRY2oBAFJ7D/b5egWNhL
	 k2ozQr5O8hrkdtoZlImbqPz1G/0p2NmE3ZTx3bvkj+fmXekHbxNcI9WjFcqdLXLIyAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d5uKR4ys;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215D960A261B;
	Fri, 20 Nov 2026 09:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 215D960A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d5uKR4ys
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795168461; x=1826704461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2IgmBcIuK8iKdSO/EWf2izgDQSehVeqYibGtFqL+DMg=;
  b=d5uKR4ys9sPMhqillYSYfjaPgSl5pJy/++stb93cvLtIvyGlrPE+88DY
   HYS1TbaBpocwC9XiGq5pUqHYmYmYIFIVrEb6EfX0YKSPp9u7OZRU6M8kA
   sBJhdAfYmqE3oAHGtq1cx5N16H0vHQ3WSLhCwNw40npDPnCTPoMFt0sRr
   Efj+bEJrWtDip8yLtbs+vkR7fpYJvy3stAHyWj63Ka8V1kIcpZlMD1pcw
   qfblMvJnzl0qK4Jla5e7zRAXzIzIcM4hKeeeOmnrHYy9cd+4WboWW8TH2
   ub43RI9IEL5yGeVK1iWVmEjyHt0H6+7oXGmpJhCGx4OTjQWuEnAbkDRrj
   w==;
X-CSE-ConnectionGUID: OVbCBOY8SqWhC22wFqSvOg==
X-CSE-MsgGUID: Pwt32V9ORsC+6+otIZFN+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4085328"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="4085328"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 01:54:20 -0800
X-CSE-ConnectionGUID: fZlQO3tfSKq+pWuRGHALcA==
X-CSE-MsgGUID: yBxFOHSZQdaGaldQSiVmTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10802136"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 20 Nov 2026 01:54:14 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xULJq-00000001HWp-2jPC;
	Fri, 20 Nov 2026 09:54:10 +0000
Date: Fri, 20 Nov 2026 17:53:25 +0800
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
	Zenghui Yu <yuzenghui@huawei.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 Erratum E#030003
Message-ID: <202611201734.HqRvXW7Q-lkp@intel.com>
References: <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>

Hi Tomohiro,

kernel test robot noticed the following build warnings:

[auto build test WARNING on aebb7274476403040d582c61478df8f4a7bf9cd3]

url:    https://github.com/intel-lab-lkp/linux/commits/Tomohiro-Misono/arm64-cputype-Add-FUJITSU-MONAKA-definition/20261119-180433
base:   aebb7274476403040d582c61478df8f4a7bf9cd3
patch link:    https://lore.kernel.org/r/20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c%40fujitsu.com
patch subject: [PATCH v3 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA Erratum E#030003
config: arm-randconfig-1003-20261120 (https://download.01.org/0day-ci/archive/20261120/202611201734.HqRvXW7Q-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 3b14d7c370558b46e5f0c6494a05c492e59bf32c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611201734.HqRvXW7Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611201734.HqRvXW7Q-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/irqchip/irq-gic-v3.c:83:32: warning: unused variable 'gic_fujitsu_030003_erratum' [-Wunused-variable]
      83 | static DEFINE_STATIC_KEY_FALSE(gic_fujitsu_030003_erratum);
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +/gic_fujitsu_030003_erratum +83 drivers/irqchip/irq-gic-v3.c

    82	
  > 83	static DEFINE_STATIC_KEY_FALSE(gic_fujitsu_030003_erratum);
    84	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

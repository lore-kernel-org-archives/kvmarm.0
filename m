Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0B838E5FF;
	Tue,  2 Jun 2026 04:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780373704; cv=none; b=tnbzO2ozVypY/L0jFe8LguIHAu/EbUJvRsOPMbzw0ychm9HaoPFXsY1aTU6v8nnx/kK05rjacUuTcSidYmiamWiDQ73Vog0rDZ8YSYxq3s7onqNAJGnUCLGs/hEmTzVnCMnljpXU4v6b3zYRBd0x9bglbSlI7PVGS4qO3sVFzis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780373704; c=relaxed/simple;
	bh=vfRA/Ie/j4izTP90KkxVG6PO83nBUWibXhsc1OZxR+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PucwQUo4WVYJlJHv06hs+OMUKNW9oXRsll8gl1CyhfRZ6D0jbpc+8pLcotwwRhcIRUP+VoFe5PgQ3pUgBdYEKy4j4J3w89HO8ZwhXmTf9ME9CNJOeJvQ+d1i9PVUjbHrIT5PL7yBoxPFkCkqAcYrjTkQZic3Bb4cMa4BX+eObog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ci4yQogl; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ci4yQogl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780373702; x=1811909702;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vfRA/Ie/j4izTP90KkxVG6PO83nBUWibXhsc1OZxR+I=;
  b=ci4yQoglSOKGPtqprcXsfNpf6Jt+kN40EJJSizMH+UxxTWadycBPzJXo
   IKv08vfux5m51WoxL1AsI8PN5dg0Q1UR+lxsXtbTm2atEk4doQ1+0XADV
   Bm8nU09tlTW33BmJ8rnpZBD60yp3HWwIvFa5ZDXDPwcbyzhkj2DrRDZTz
   CaEHeHny4IV4MCmifAF6hZn+bURy+8l8qQeqP2QWC1VxOwbBUN89Fm+zL
   jQNaju/8GfwGbG3CycZCyBDtIWfh7RQWe3tdYScrXRxDiCgheKhgVkSMN
   V6LfAiI94gw9FESz+t+pSjlSbooS/TPRQTkegSVrHmxC8d/FLPwdSxbpC
   Q==;
X-CSE-ConnectionGUID: s6Ei81mCQIympXdb7xeCBw==
X-CSE-MsgGUID: 9ERmTggTQY+hATRx3iG0Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81332265"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="81332265"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 21:15:01 -0700
X-CSE-ConnectionGUID: 2Wo58T2iR0ymRS+tXnPy6w==
X-CSE-MsgGUID: XzqRfukNQgysyyAQQYsEyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242752583"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 01 Jun 2026 21:14:58 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUGWl-00000000BUI-2Uz6;
	Tue, 02 Jun 2026 04:14:55 +0000
Date: Tue, 2 Jun 2026 12:14:47 +0800
From: kernel test robot <lkp@intel.com>
To: Congkai Tan <congkai@amazon.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, Congkai Tan <congkai@amazon.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Haris Okanovic <harisokn@amazon.com>,
	Geoff Blake <blakgeof@amazon.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Message-ID: <202606021209.2lvgE216-lkp@intel.com>
References: <20260601193954.2103455-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601193954.2103455-1-congkai@amazon.com>

Hi Congkai,

kernel test robot noticed the following build errors:

[auto build test ERROR on 1702da76e017ae0fbe1a92b07bc332972c293e89]

url:    https://github.com/intel-lab-lkp/linux/commits/Congkai-Tan/KVM-arm64-Expose-PMMIR_EL1-SLOTS-to-guests/20260602-034527
base:   1702da76e017ae0fbe1a92b07bc332972c293e89
patch link:    https://lore.kernel.org/r/20260601193954.2103455-1-congkai%40amazon.com
patch subject: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
config: arm64-randconfig-r123-20260602 (https://download.01.org/0day-ci/archive/20260602/202606021209.2lvgE216-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260602/202606021209.2lvgE216-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606021209.2lvgE216-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kvm/sys_regs.c: In function 'access_pmmir':
>> arch/arm64/kvm/sys_regs.c:1391:28: error: invalid use of undefined type 'struct arm_pmu'
    1391 |         p->regval = cpu_pmu->reg_pmmir & ARMV8_PMU_SLOTS;
         |                            ^~


vim +1391 arch/arm64/kvm/sys_regs.c

  1373	
  1374	/*
  1375	 * Expose only PMMIR_EL1.SLOTS to the guest, which is consumed by perf in its
  1376	 * topdown default metric group. Other PMMIR_EL1 fields remain RAZ. Future
  1377	 * patches can extend the exposed mask incrementally as KVM gains support for
  1378	 * those features.
  1379	 */
  1380	static bool access_pmmir(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  1381				 const struct sys_reg_desc *r)
  1382	{
  1383		struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
  1384	
  1385		if (p->is_write)
  1386			return write_to_read_only(vcpu, p, r);
  1387	
  1388		if (check_pmu_access_disabled(vcpu, 0))
  1389			return false;
  1390	
> 1391		p->regval = cpu_pmu->reg_pmmir & ARMV8_PMU_SLOTS;
  1392		return true;
  1393	}
  1394	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

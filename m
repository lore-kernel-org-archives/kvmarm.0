Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107A2848AD;
	Tue, 10 Feb 2026 05:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770702937; cv=none; b=s8BitiZbzfxV2MZX/gZ4Novb1ddsWfuu5LEzn1o9akWveSeWUZZiiW+uNkq5Y6aclhIEEKFzg0II5a29LN0MH4DoK5UU7YS03cL8EuufnbfWQWUwIMyx71i+QmhIFQ1yAJAw58d8q/nfbuV+8HjpA/5lYmlI3X3Cv3rEV4yuA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770702937; c=relaxed/simple;
	bh=9nnWMdj/22l/UeayrTX5T1lj3a2Zm8Tv6HcRko/maj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiMj5EV9kS/bxP44KDQfzivqy5p3RreKg5ZXlIImPdqG0Fzr0ioPoA9DL4bnNDa53dD3iDMkGX2Ovzb45ydDj1/Btr1nrhwNMWJHUG56RA7hJINDlWt3Q/c+m9nnh1L9cTkjL6BcepJaPJm1EVGhzvfguNdEGTbcYtaqduxj2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MHyzqE2T; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MHyzqE2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770702936; x=1802238936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9nnWMdj/22l/UeayrTX5T1lj3a2Zm8Tv6HcRko/maj4=;
  b=MHyzqE2TL98Y0e1NilVdyuPkF+iXRXqwK1HCmioj4IILCK2GgdtAffnF
   YmxoonRaH+n1t8MW7wCXH7L3GeQUhw6g06+vigoEspOhHCqeMM09qJgt3
   TrK3JS7ebNhlC40im4gEKhdAgTN+1XsTTvG9ssfrWXYip9r1YJ8golp8+
   dHXO2O+WkhLj+/q+yp49W0uLtLq5EziQfaMS+PGZTHcGkT/0LqcwuFXVh
   M27TBMjSDDcELRkxIzrhWI0jGY1N6olRkaVOMWFmWklIMtMLd+AhJ4nWE
   7TgqV5sOUKxogmykfg6SJoTkCF5lS/+36cMHm7Zk3SqnHUt19BVITMMNy
   w==;
X-CSE-ConnectionGUID: OuED8cO+S2OBND25UL6dwg==
X-CSE-MsgGUID: KHrc5bRJS2WwbpXlpOMGQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82552870"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82552870"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 21:55:30 -0800
X-CSE-ConnectionGUID: arSyvb8yT9+dGXp6koLMDA==
X-CSE-MsgGUID: OiiH5N3LTQOp/Uz4oFV5Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211845844"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 09 Feb 2026 21:55:24 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpgiY-00000000ogW-0ClM;
	Tue, 10 Feb 2026 05:55:22 +0000
Date: Tue, 10 Feb 2026 13:55:00 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition
 the PMU
Message-ID: <202602101354.lZex1CmW-lkp@intel.com>
References: <20260209221414.2169465-17-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209221414.2169465-17-coltonlewis@google.com>

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20260210-064939
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260209221414.2169465-17-coltonlewis%40google.com
patch subject: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition the PMU
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20260210/202602101354.lZex1CmW-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101354.lZex1CmW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101354.lZex1CmW-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: arch/arm64/kvm/pmu-direct.c:55 function parameter 'vcpu' not described in 'kvm_vcpu_pmu_is_partitioned'
>> Warning: arch/arm64/kvm/pmu-direct.c:55 expecting prototype for kvm_pmu_is_partitioned(). Prototype was for kvm_vcpu_pmu_is_partitioned() instead

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

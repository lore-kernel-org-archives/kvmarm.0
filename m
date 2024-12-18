Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9291BDC3;
	Wed, 18 Dec 2024 23:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734564224; cv=none; b=kE2gGhjdv9/QI53umxbRBGTAwENkMVlPkltr9iPPmJE1BQHYsqkTDvtEyoPPRoWrBJzjuc8QLV50Pj1fcTsV4zEY/hvu7i7R3LGM16baA0AavVFc7cvmKZkt7gEGGWeDXs/qnSWcFFoNK6STVbWAOcgnUr3j/A0VVBliXBZGzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734564224; c=relaxed/simple;
	bh=qIRpEqM2whIgS+t+pxzqW0QabjeDe+qjaYmNNmfBzUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXRSUIkDMxgaFZ1MKJJM63Uo9R/lhby61GBB1kjwOXjgV+5HflgDIC1Vwpqh/GlqadnRXwB+2Uim4vQ/pw50vwpvA+ohmozas1dd+9eqLTyFIl1eYqM//2Q4C0b+QFhAXuwJqL2dshfQtocTVuLeejZGBFvuWo4IDtDoVMSzovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUY6ukcq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUY6ukcq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734564222; x=1766100222;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qIRpEqM2whIgS+t+pxzqW0QabjeDe+qjaYmNNmfBzUA=;
  b=TUY6ukcqVoBw9NTPegW2WRmeELDNH4KQAFmFEpR7Q6tjAP0staZITwjD
   lSD8T/nwNui5bURLmMdU9nWnmtiaKfmuMZHWTQ9wI4NDMrOc14wqVg+qN
   kaiZv2PzfxuXeagLx7bJKP3Jsker2H7vOGkRjTLbcmoKFVcgJviHbg3R8
   OEhPKPDaBrbov93d01cGztE7MTB1aVdAwg65u5T7fgmyGWML/MArRCMEl
   3z9ReOOfuogZ+LohSIRCv2p52SoF2Ei5u3d8AVXwwPuatBKfcJJfSmikI
   tZTQ0kagxIYiDLASjJU3qM0h1ct0e2TCbLqwLre5vLfB8nU/ppFnICUU+
   A==;
X-CSE-ConnectionGUID: aQaHec0jTviPc5TgzE92Hw==
X-CSE-MsgGUID: nSzRrLAoQd2NA28YVxCKQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="46070146"
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="46070146"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 15:23:41 -0800
X-CSE-ConnectionGUID: Set8+qouRRyNwdBWCJd6Xw==
X-CSE-MsgGUID: 8cn4UoAHT3SdVWTtlbRu7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="97902516"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 18 Dec 2024 15:23:37 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tO3OA-000GhW-1r;
	Wed, 18 Dec 2024 23:23:34 +0000
Date: Thu, 19 Dec 2024 07:23:07 +0800
From: kernel test robot <lkp@intel.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 09/18] KVM: arm64: Drop kvm_arm_pmu_available static key
Message-ID: <202412190743.1bLEb7Ps-lkp@intel.com>
References: <20241217212048.3709204-10-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217212048.3709204-10-oliver.upton@linux.dev>

Hi Oliver,

kernel test robot noticed the following build errors:

[auto build test ERROR on 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/drivers-perf-apple_m1-Refactor-event-select-filter-configuration/20241218-054416
base:   78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
patch link:    https://lore.kernel.org/r/20241217212048.3709204-10-oliver.upton%40linux.dev
patch subject: [PATCH 09/18] KVM: arm64: Drop kvm_arm_pmu_available static key
config: arm64-randconfig-001-20241219 (https://download.01.org/0day-ci/archive/20241219/202412190743.1bLEb7Ps-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241219/202412190743.1bLEb7Ps-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412190743.1bLEb7Ps-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/arm.c:394:7: error: call to undeclared function 'kvm_supports_guest_pmuv3'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   r = kvm_supports_guest_pmuv3();
                       ^
   arch/arm64/kvm/arm.c:1400:7: error: call to undeclared function 'kvm_supports_guest_pmuv3'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           if (!kvm_supports_guest_pmuv3())
                ^
   2 errors generated.


vim +/kvm_supports_guest_pmuv3 +394 arch/arm64/kvm/arm.c

   309	
   310	int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
   311	{
   312		int r;
   313	
   314		if (kvm && kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, ext))
   315			return 0;
   316	
   317		switch (ext) {
   318		case KVM_CAP_IRQCHIP:
   319			r = vgic_present;
   320			break;
   321		case KVM_CAP_IOEVENTFD:
   322		case KVM_CAP_USER_MEMORY:
   323		case KVM_CAP_SYNC_MMU:
   324		case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
   325		case KVM_CAP_ONE_REG:
   326		case KVM_CAP_ARM_PSCI:
   327		case KVM_CAP_ARM_PSCI_0_2:
   328		case KVM_CAP_READONLY_MEM:
   329		case KVM_CAP_MP_STATE:
   330		case KVM_CAP_IMMEDIATE_EXIT:
   331		case KVM_CAP_VCPU_EVENTS:
   332		case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
   333		case KVM_CAP_ARM_NISV_TO_USER:
   334		case KVM_CAP_ARM_INJECT_EXT_DABT:
   335		case KVM_CAP_SET_GUEST_DEBUG:
   336		case KVM_CAP_VCPU_ATTRIBUTES:
   337		case KVM_CAP_PTP_KVM:
   338		case KVM_CAP_ARM_SYSTEM_SUSPEND:
   339		case KVM_CAP_IRQFD_RESAMPLE:
   340		case KVM_CAP_COUNTER_OFFSET:
   341			r = 1;
   342			break;
   343		case KVM_CAP_SET_GUEST_DEBUG2:
   344			return KVM_GUESTDBG_VALID_MASK;
   345		case KVM_CAP_ARM_SET_DEVICE_ADDR:
   346			r = 1;
   347			break;
   348		case KVM_CAP_NR_VCPUS:
   349			/*
   350			 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
   351			 * architectures, as it does not always bound it to
   352			 * KVM_CAP_MAX_VCPUS. It should not matter much because
   353			 * this is just an advisory value.
   354			 */
   355			r = min_t(unsigned int, num_online_cpus(),
   356				  kvm_arm_default_max_vcpus());
   357			break;
   358		case KVM_CAP_MAX_VCPUS:
   359		case KVM_CAP_MAX_VCPU_ID:
   360			if (kvm)
   361				r = kvm->max_vcpus;
   362			else
   363				r = kvm_arm_default_max_vcpus();
   364			break;
   365		case KVM_CAP_MSI_DEVID:
   366			if (!kvm)
   367				r = -EINVAL;
   368			else
   369				r = kvm->arch.vgic.msis_require_devid;
   370			break;
   371		case KVM_CAP_ARM_USER_IRQ:
   372			/*
   373			 * 1: EL1_VTIMER, EL1_PTIMER, and PMU.
   374			 * (bump this number if adding more devices)
   375			 */
   376			r = 1;
   377			break;
   378		case KVM_CAP_ARM_MTE:
   379			r = system_supports_mte();
   380			break;
   381		case KVM_CAP_STEAL_TIME:
   382			r = kvm_arm_pvtime_supported();
   383			break;
   384		case KVM_CAP_ARM_EL1_32BIT:
   385			r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
   386			break;
   387		case KVM_CAP_GUEST_DEBUG_HW_BPS:
   388			r = get_num_brps();
   389			break;
   390		case KVM_CAP_GUEST_DEBUG_HW_WPS:
   391			r = get_num_wrps();
   392			break;
   393		case KVM_CAP_ARM_PMU_V3:
 > 394			r = kvm_supports_guest_pmuv3();
   395			break;
   396		case KVM_CAP_ARM_INJECT_SERROR_ESR:
   397			r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
   398			break;
   399		case KVM_CAP_ARM_VM_IPA_SIZE:
   400			r = get_kvm_ipa_limit();
   401			break;
   402		case KVM_CAP_ARM_SVE:
   403			r = system_supports_sve();
   404			break;
   405		case KVM_CAP_ARM_PTRAUTH_ADDRESS:
   406		case KVM_CAP_ARM_PTRAUTH_GENERIC:
   407			r = kvm_has_full_ptr_auth();
   408			break;
   409		case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
   410			if (kvm)
   411				r = kvm->arch.mmu.split_page_chunk_size;
   412			else
   413				r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
   414			break;
   415		case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
   416			r = kvm_supported_block_sizes();
   417			break;
   418		case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
   419			r = BIT(0);
   420			break;
   421		default:
   422			r = 0;
   423		}
   424	
   425		return r;
   426	}
   427	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

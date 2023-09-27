Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FD14C80;
	Wed, 27 Sep 2023 02:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695782809; x=1727318809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=92IZjLvkXfOOf8zoWXjjyphUN7c3DRXJX04aFkJRoEY=;
  b=koR362zz8pyr1RL6uiXbV791WYhpO6nJhPiTnvFsa4zYXGl1cYkEaDbN
   +eCt8xruh8yuO0do91lk0nSLpvJrA5fsfm+cYpxCapSzqy6rA/ffHm7sD
   Ext7Xetj38c2b4elVFPSzJ5sfpmu5lU9D8/pX6n4/mo3SaMxj+7ZYO63J
   W+x/HC4DDGQx1rs7blcpuA9ZYf8i4bLXnkgFVnhXdMypGhHnt5Wy8vP4c
   doAiRl23f7j8XRbDr9xk6UNEjvzPXy7IVhtelsK0ZnVxn4PEGID/OllB6
   eNsRjqMdiY6MODMe2vlIg25XOZHWDo71tvJUKctLqNOoaE7fIylFBaTZA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="381614912"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="381614912"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 19:46:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864621211"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864621211"
Received: from lkp-server02.sh.intel.com (HELO 32c80313467c) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 19:46:46 -0700
Received: from kbuild by 32c80313467c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qlKYt-0003eF-14;
	Wed, 27 Sep 2023 02:46:03 +0000
Date: Wed, 27 Sep 2023 10:45:34 +0800
From: kernel test robot <lkp@intel.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v10 10/12] KVM: arm64: Document vCPU feature selection
 UAPIs
Message-ID: <202309271037.rM4DMYYZ-lkp@intel.com>
References: <20230920183310.1163034-11-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920183310.1163034-11-oliver.upton@linux.dev>

Hi Oliver,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ce9ecca0238b140b88f43859b211c9fdfd8e5b70]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-Allow-userspace-to-get-the-writable-masks-for-feature-ID-registers/20230921-023547
base:   ce9ecca0238b140b88f43859b211c9fdfd8e5b70
patch link:    https://lore.kernel.org/r/20230920183310.1163034-11-oliver.upton%40linux.dev
patch subject: [PATCH v10 10/12] KVM: arm64: Document vCPU feature selection UAPIs
reproduce: (https://download.01.org/0day-ci/archive/20230927/202309271037.rM4DMYYZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309271037.rM4DMYYZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/arm/vcpu-features.rst:13: WARNING: undefined label: kvm_arm_vcpu_init (if the link has no caption the label must precede a section header)
>> Documentation/virt/kvm/arm/vcpu-features.rst:30: WARNING: undefined label: kvm_arm_get_reg_writable_masks (if the link has no caption the label must precede a section header)

vim +13 Documentation/virt/kvm/arm/vcpu-features.rst

    12	
  > 13	The ``KVM_ARM_VCPU_INIT`` ioctl accepts a bitmap of feature flags
    14	(``struct kvm_vcpu_init::features``). Features enabled by this interface are
    15	*opt-in* and may change/extend UAPI. See :ref:`KVM_ARM_VCPU_INIT` for complete
    16	documentation of the features controlled by the ioctl.
    17	
    18	Otherwise, all CPU features supported by KVM are described by the architected
    19	ID registers.
    20	
    21	The ID Registers
    22	================
    23	
    24	The Arm architecture specifies a range of *ID Registers* that describe the set
    25	of architectural features supported by the CPU implementation. KVM initializes
    26	the guest's ID registers to the maximum set of CPU features supported by the
    27	system. The ID register values are VM-scoped in KVM, meaning that the values
    28	are identical for all vCPUs in a VM.
    29	
  > 30	KVM allows userspace to *opt-out* of certain CPU features described by the ID
    31	registers by writing values to them via the ``KVM_SET_ONE_REG`` ioctl. The ID
    32	registers are mutable until the VM has started, i.e. userspace has called
    33	``KVM_RUN`` on at least one vCPU in the VM. Userspace can discover what fields
    34	are mutable in the ID registers using the ``KVM_ARM_GET_REG_WRITABLE_MASKS``.
    35	See the :ref:`ioctl documentation <KVM_ARM_GET_REG_WRITABLE_MASKS>` for more
    36	details.
    37	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

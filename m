Received: from out-197.mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD219219ED
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pLAV7sRo"
Date: Tue, 24 Oct 2023 18:58:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698173919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9MztIQI/YLVWMEXXDAj+/H0pEuWc97y2iGY8jdy0ciM=;
	b=pLAV7sRoKcajp/XZTIagaih6Vt8c40syBTGAKFteCTnSo51X6vgfM8hzaqALwNz+Vk20nV
	vJAIZWqlyVz9ioD98yIAPVyVFhgwmCOgrUgYy8qVReoVJnvOhZVqHJS/w4dqCiUhdlozke
	drH/8KpKB0mRjxRmVVL3dk/Z5UXi7/4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kernel test robot <lkp@intel.com>
Cc: kvmarm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2
 isn't advertised
Message-ID: <ZTgT287FMQl0aXye@linux.dev>
References: <20231019185618.3442949-2-oliver.upton@linux.dev>
 <202310241025.FmLnpSTG-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202310241025.FmLnpSTG-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 24, 2023 at 10:47:58AM +0800, kernel test robot wrote:
> Hi Oliver,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on 6465e260f48790807eef06b583b38ca9789b6072]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-Make-PMEVTYPER-n-_EL0-NSH-RES0-if-EL2-isn-t-advertised/20231020-025836
> base:   6465e260f48790807eef06b583b38ca9789b6072
> patch link:    https://lore.kernel.org/r/20231019185618.3442949-2-oliver.upton%40linux.dev
> patch subject: [PATCH v3 1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
> config: arm64-randconfig-004-20231023 (https://download.01.org/0day-ci/archive/20231024/202310241025.FmLnpSTG-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231024/202310241025.FmLnpSTG-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202310241025.FmLnpSTG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm64/kvm/sys_regs.c: In function 'reset_pmevtyper':
> >> arch/arm64/kvm/sys_regs.c:754:41: error: too many arguments to function 'kvm_pmu_evtyper_mask'

Ah, the prototype for !CONFIG_HW_PERF_EVENTS is wrong. I'll squash this
in:

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e0bcf447a2ab..fd0aa8105a5b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -173,7 +173,7 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {
 	return 0;
 }
-static inline u64 kvm_pmu_evtyper_mask(void)
+static inline u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 {
 	return 0;
 }

-- 
Thanks,
Oliver

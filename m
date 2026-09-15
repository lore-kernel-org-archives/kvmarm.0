Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C4433B969;
	Tue, 15 Sep 2026 21:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508957; cv=none; b=g4JTkjA2PmY5t4CrUKScIHCGYjLX9lAtp+JAFK+wwmd3ZoaDdvE4EBDtXc2cs0BmuzaNyI2LQXqm2kCOhfrPGoq6qJKrMTUu3YYfSCpZwMyHuJEze1IRsMyK1dmUR3pHCMYyXJ65m//pbki6WX34FKuNCrIdAyOoobxWifRQeuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508957; c=relaxed/simple;
	bh=4Mh5YWpLGrRiK7zAXkaXbQmVg/ZurD93+09+Y8jTx+M=;
	h=Date:From:To:Cc:Subject:Message-ID; b=dpcG4bYQyHV2HoX+J0dYgDJwqyyaRhEIrLN3iqy60eTRLLamDg6bKpbWiuJ0vHcuN1xCFPnjKsM68T6zTZBK3UyyXhgncKBj+NNOzxTNjk2wXVaam7YDnvOLhOPt+xKd65v0YKgVsAnbsFRv/Fqm2Y3GRWPEYo5X/4dfMGRcVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mK4KK4UY; arc=none smtp.client-ip=192.198.163.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mK4KK4UY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789508954; x=1821044954;
  h=date:from:to:cc:subject:message-id;
  bh=4Mh5YWpLGrRiK7zAXkaXbQmVg/ZurD93+09+Y8jTx+M=;
  b=mK4KK4UYXR5UYSBfHESWw8s9Hrw2bxB/mk9av8AN2IHsMmgCwf0QV8EU
   Rz+X1Aq1on5uoUuscLR7U9lcwb4QN+h1sLMeaEpRwZYb5EsTx/R8p9ILU
   LX61CGcatyv0MxjEAWgQNH3yJoebWWPNgAIs1T7FyC9BwRkTUL9hWTrCh
   a+M/NPIe+tTqxPSy1FOLyd7y2p3G4O9yzPxN7rqBb1pf3yuEzeeOe/DNH
   evnuHFjDUAd78AuyWWWqNo9SbAK9g+OAADs5zJkbaaLtCJ13E6paWIFTN
   vWhgJX1mEQugV7yQEUZKBhRYZPjb6uTPW9G+b0h++4gn65XedAV33dCOl
   A==;
X-CSE-ConnectionGUID: bjKalSEhSkSbUDeVthDWfg==
X-CSE-MsgGUID: KMUrjYB6TamY7uLNHgP0PA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="395298"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="395298"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 14:49:14 -0700
X-CSE-ConnectionGUID: hLb2xrbBQ161CTWIOpZ+xg==
X-CSE-MsgGUID: 2z5BNDMlQAerbuvLzwFLtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="266930764"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 15 Sep 2026 14:49:12 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6b1Z-00000000577-3KBN;
	Tue, 15 Sep 2026 21:49:09 +0000
Date: Wed, 16 Sep 2026 05:48:32 +0800
From: kernel test robot <lkp@intel.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: [kvmarm:next 31/83]
 arch/arm64/kvm/vgic/vgic-irs-v5.c:1016:8: warning: variable 'addr' set but
 not used
Message-ID: <202609160555.JW0KTj94-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
head:   8476ce1f1e949a4eae0c0b8f06cf6ab51a3edfd0
commit: 71091136d1452b6125579b210d29efec3e79681a [31/83] KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
config: arm64-randconfig-003-20260916 (https://download.01.org/0day-ci/archive/20260916/202609160555.JW0KTj94-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260916/202609160555.JW0KTj94-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609160555.JW0KTj94-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/vgic/vgic-irs-v5.c: In function 'vgic_v5_has_attr_regs':
>> arch/arm64/kvm/vgic/vgic-irs-v5.c:1016:8: warning: variable 'addr' set but not used [-Wunused-but-set-variable]
     gpa_t addr, offset;
           ^~~~


vim +/addr +1016 arch/arm64/kvm/vgic/vgic-irs-v5.c

  1010	
  1011	int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
  1012	{
  1013		const struct vgic_register_region *region;
  1014		struct vgic_reg_attr reg_attr;
  1015		struct kvm_vcpu *vcpu;
> 1016		gpa_t addr, offset;
  1017		int ret, align;
  1018	
  1019		ret = vgic_v5_parse_attr(dev, attr, &reg_attr);
  1020		if (ret)
  1021			return ret;
  1022	
  1023		vcpu = reg_attr.vcpu;
  1024		addr = reg_attr.addr;
  1025	
  1026		if (attr->group == KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
  1027			return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
  1028	
  1029		offset = attr->attr;
  1030	
  1031		region = vgic_find_mmio_region(vgic_v5_irs_registers,
  1032					       ARRAY_SIZE(vgic_v5_irs_registers),
  1033					       offset);
  1034		if (!region)
  1035			return -ENXIO;
  1036	
  1037		align = region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
  1038		if (offset & align)
  1039			return -EINVAL;
  1040	
  1041		return 0;
  1042	}
  1043	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

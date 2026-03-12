Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5473032D0CC;
	Thu, 12 Mar 2026 08:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302927; cv=none; b=HVfZTwAUUH2rDZg3h9DF16EnBf48vRlEwCd5Ohc/71+WG5A1s25ym1ldvYPqNRZsil+ysAauY+eWLulTs2G04cjgzlF06HGPl9Y3ZNy2UqbYbGlssKTUxRnrowQpNqJe+kY+VgABuAFNIQEgCTFSYLtsoeAuq9Zdu4V1Fo9ALrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302927; c=relaxed/simple;
	bh=4OIdc6IS8R0ZQeJSrgBXE5mnoJyO70OLvayJyXABy1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov3RqjCflweV8f9W/jhaJIJkp98Yy7JMgFqOFqKoLZ8qQqitt/5K1k10AtLMgqPyyOK7O/LUoVmb22aT1VLbI/oygtqtPo3QaAI23fzVsw1tM914ZDtWhnAHAkjRUcJCfKPiuA0T3532AtZ01gxeILovtK9WJqFdJ6v/H/0Mkh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ba2O8SL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ba2O8SL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B7EC4CEF7;
	Thu, 12 Mar 2026 08:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302927;
	bh=4OIdc6IS8R0ZQeJSrgBXE5mnoJyO70OLvayJyXABy1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ba2O8SL8dP4Ip5q7TqHL2kejwldaI7xq5hcsc5fu9cBIgu81NM2FGdk0PN9xyBRF1
	 onMytz5fq3jZcJ0w1UbjPTj4dQpzLry+2Q98YTvRRPAvn2fgEkoVLl6G3dd1q7unWT
	 jdvlYPVVnxhgoqZWF30KPtxSwfCEedPyOwJMPeB9xiBfAptfXI2l9lMpozM35jY6Ro
	 upvO7yQeVk0I0R1ntxvexxNlvqMQ5ScnTKPG3OQa9aiMh5iDr0x7j75BSXmH61sBcn
	 7sJfUL6zddQ7UywIHV2dfDQw3xymCH0VuuyOXf7lSaI41rVJWJ2c0p8gLn+JeCTWcM
	 67MmZShx0tD1w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 09/12] coco: host: KVM: arm64: Handle vdev map/validation exits
Date: Thu, 12 Mar 2026 13:37:40 +0530
Message-ID: <20260312080743.3487326-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
References: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- define the RMM SMCCC IDs (and wrappers) for VDEV_VALIDATE_MAPPING
  and VDEV_MEM_MAP, add the matching RHI request IDs, and extend the REC
  exit payload to carry GPA/HPA details for mapping exits
- update KVM to recognize RMI_EXIT_VDEV_MAP and surface it to
  userspace via KVM_EXIT_ARM64_TIO
- use the new realm_dev_mem_map() to map device memory.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_rmi.h         |   4 +
 arch/arm64/include/asm/rhi.h             |   1 +
 arch/arm64/include/asm/rmi_cmds.h        |  26 +++++
 arch/arm64/include/asm/rmi_smc.h         |   4 +
 arch/arm64/include/uapi/asm/rmi-da.h     |   8 ++
 arch/arm64/kvm/rmi-exit.c                |  38 ++++++++
 arch/arm64/kvm/rmi.c                     | 115 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/arm-cca.c |  28 ++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  |  37 ++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |   3 +
 10 files changed, 264 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index a967061af6ed..0a38a489fd53 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -134,4 +134,8 @@ static inline bool kvm_realm_is_private_address(struct realm *realm,
 	return !(addr & BIT(realm->ia_bits - 1));
 }
 
+int realm_dev_mem_map(struct kvm *kvm, unsigned long rec_phys,
+		      unsigned long pdev_phys, unsigned long vdev_phys,
+		      unsigned long start_ipa, unsigned long end_ipa,
+		      unsigned long start_pa);
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 888b3a1c3953..ba9e11152c1b 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -85,5 +85,6 @@ enum rhi_tdi_state {
 #define __RHI_DA_VDEV_GET_INTERFACE_REPORT 0x3
 #define __RHI_DA_VDEV_GET_MEASUREMENTS	0x4
 #define __REC_EXIT_DA_VDEV_REQUEST	0x5
+#define __REC_EXIT_DA_VDEV_MAP		0x6
 
 #endif
diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index f29c2de5d3b9..53bffaace64c 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -695,4 +695,30 @@ static inline unsigned long rmi_vdev_complete(unsigned long rec_phys, unsigned l
 	return res.a0;
 }
 
+static inline int rmi_vdev_validate_mapping(unsigned long rd, unsigned long rec_phys,
+					    unsigned long pdev_phys, unsigned long vdev_phys,
+					    unsigned long base, unsigned long top,
+					    unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_VALIDATE_MAPPING, rd,
+			     rec_phys, pdev_phys, vdev_phys, base, top, &res);
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
+}
+
+static inline int rmi_vdev_mem_map(unsigned long rd, unsigned long vdev_phys,
+				   unsigned long ipa, unsigned long level, unsigned long pa)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_MEM_MAP, rd, vdev_phys, ipa, level, pa, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 6b685585e750..41ee49c341c0 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -39,6 +39,7 @@
 
 #define SMC_RMI_RTT_READ_ENTRY		SMC_RMI_CALL(0x0161)
 #define SMC_RMI_RTT_UNMAP_UNPROTECTED	SMC_RMI_CALL(0x0162)
+#define SMC_RMI_VDEV_VALIDATE_MAPPING	SMC_RMI_CALL(0x0163)
 
 #define SMC_RMI_PSCI_COMPLETE		SMC_RMI_CALL(0x0164)
 #define SMC_RMI_FEATURES		SMC_RMI_CALL(0x0165)
@@ -47,6 +48,7 @@
 #define SMC_RMI_RTT_INIT_RIPAS		SMC_RMI_CALL(0x0168)
 #define SMC_RMI_RTT_SET_RIPAS		SMC_RMI_CALL(0x0169)
 
+#define SMC_RMI_VDEV_MEM_MAP		SMC_RMI_CALL(0x0172)
 #define SMC_RMI_PDEV_ABORT		SMC_RMI_CALL(0x0174)
 #define SMC_RMI_PDEV_COMMUNICATE        SMC_RMI_CALL(0x0175)
 #define SMC_RMI_PDEV_CREATE             SMC_RMI_CALL(0x0176)
@@ -187,6 +189,7 @@ struct rec_params {
 #define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
 #define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
 #define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
+#define REC_ENTER_FLAG_DEV_MEM_RESPONSE BIT(6)
 
 #define REC_RUN_GPRS			31
 #define REC_MAX_GIC_NUM_LRS		16
@@ -227,6 +230,7 @@ struct rec_enter {
 #define RMI_EXIT_HOST_CALL		0x05
 #define RMI_EXIT_SERROR			0x06
 #define RMI_EXIT_VDEV_REQUEST		0x08
+#define RMI_EXIT_VDEV_MAP		0x09
 
 struct rec_exit {
 	union { /* 0x000 */
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
index ac6e2fd2807d..20d3eab8ce64 100644
--- a/arch/arm64/include/uapi/asm/rmi-da.h
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -27,4 +27,12 @@ struct arm64_vdev_device_idmap_guest_req {
 	__s32 vcpu_fd;
 };
 
+struct arm64_vdev_device_memmap_guest_req {
+	__u32 req_type;
+	__s32 vcpu_fd;
+	__aligned_u64 gpa_base;
+	__aligned_u64 gpa_top;
+	__aligned_u64 pa_base;
+};
+
 #endif
diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 3bba5e6afe88..c1605b03a32d 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -144,6 +144,42 @@ static int rec_exit_vdev_request(struct kvm_vcpu *vcpu)
 	kvm_prepare_vdev_request_exit(vcpu, rec->run->exit.vdev_id_1);
 	return 0;
 }
+
+static inline void kvm_prepare_vdev_validate_mapping_exit(struct kvm_vcpu *vcpu,
+							  gpa_t gpa_base, gpa_t gpa_top,
+							  hpa_t pa_base, unsigned long vdev_id)
+{
+	vcpu->run->exit_reason = KVM_EXIT_ARM64_TIO;
+	vcpu->run->cca_exit.nr = RMI_EXIT_VDEV_MAP;
+	vcpu->run->cca_exit.vdev_id  = vdev_id;
+	vcpu->run->cca_exit.flags = 0;
+	vcpu->run->cca_exit.gpa_base = gpa_base;
+	vcpu->run->cca_exit.gpa_top  = gpa_top;
+	vcpu->run->cca_exit.pa_base  = pa_base;
+}
+
+static int rec_exit_vdev_validate_mapping(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.dev_mem_base;
+	unsigned long top = rec->run->exit.dev_mem_top;
+
+	if (!kvm_realm_is_private_address(realm, base) ||
+	    !kvm_realm_is_private_address(realm, top - 1)) {
+
+		/* Set RMI_REJECT bit */
+		rec->run->enter.flags = REC_ENTER_FLAG_DEV_MEM_RESPONSE;
+		vcpu_err(vcpu, "Invalid DEV_MEM_VALIDATE for %#lx - %#lx\n", base, top);
+		return -EINVAL;
+	}
+
+	kvm_prepare_vdev_validate_mapping_exit(vcpu, base, top, rec->run->exit.dev_mem_pa,
+					       rec->run->exit.vdev_id_1);
+	return 0;
+}
+
 static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -215,6 +251,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_host_call(vcpu);
 	case RMI_EXIT_VDEV_REQUEST:
 		return rec_exit_vdev_request(vcpu);
+	case RMI_EXIT_VDEV_MAP:
+		return rec_exit_vdev_validate_mapping(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 08f3d2362dfd..bb338712ef34 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1505,6 +1505,121 @@ static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 	rec->run->exit.ripas_base = base;
 }
 
+/*
+ * Even though we can map larger block, since we need to delegate each granule.
+ * We map granule size and fold
+ */
+static int __realm_dev_mem_map(struct kvm *kvm,
+			       struct kvm_mmu_memory_cache *cache, unsigned long rec_phys,
+			       unsigned long pdev_phys, unsigned long vdev_phys,
+			       unsigned long start_ipa, unsigned long end_ipa,
+			       phys_addr_t phys, unsigned long *top_ipa)
+{
+	int ret = 0;
+	unsigned long rmi_ret;
+	unsigned long ipa, next_ipa;
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+
+	for (ipa = start_ipa ; ipa < end_ipa; ipa += RMM_PAGE_SIZE) {
+
+		if (rmi_granule_delegate(phys)) {
+			ret = -EINVAL;
+			goto err_delegate;
+		}
+
+		rmi_ret = rmi_vdev_mem_map(rd_phys, vdev_phys,
+					   ipa, RMM_RTT_MAX_LEVEL, phys);
+		if (RMI_RETURN_STATUS(rmi_ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(rmi_ret);
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      RMM_RTT_MAX_LEVEL,
+						      cache);
+			if (ret)
+				goto err_vdev_mem_map;
+
+			if (rmi_vdev_mem_map(rd_phys, vdev_phys,
+					     ipa, RMM_RTT_MAX_LEVEL, phys))
+				ret = -ENXIO;
+		}
+		if (ret)
+			goto err_vdev_mem_map;
+
+		phys += RMM_PAGE_SIZE;
+	}
+
+	/*
+	 * Return the highest mapped IPA within the range
+	 * (processed by vdev_mem_map)
+	 */
+	*top_ipa = end_ipa;
+
+	while (start_ipa < end_ipa) {
+		/* now validate the device memory mapping */
+		if (rmi_vdev_validate_mapping(rd_phys, rec_phys, pdev_phys,
+				vdev_phys, start_ipa, end_ipa, &next_ipa)) {
+			/*
+			 * We can't find the RTT error here, because
+			 * things are already setup by dev_mem_map before
+			 * Caller will do the unmap and undelegate
+			 */
+			return -ENXIO;
+		}
+		start_ipa = next_ipa;
+	}
+
+	return 0;
+
+ err_vdev_mem_map:
+	WARN_ON(rmi_granule_undelegate(phys));
+ err_delegate:
+	*top_ipa = ipa - RMM_PAGE_SIZE;
+	return ret;
+}
+
+int realm_dev_mem_map(struct kvm *kvm, unsigned long rec_phys,
+		      unsigned long pdev_phys, unsigned long vdev_phys,
+		      unsigned long start_ipa, unsigned long end_ipa,
+		      unsigned long start_pa)
+{
+	int ret;
+	unsigned long top_ipa;
+	unsigned long base_ipa = start_ipa;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
+
+	do {
+		ret = kvm_mmu_topup_memory_cache(&cache,
+						 kvm_mmu_cache_min_pages(mmu));
+		if (ret)
+			break;
+
+		write_lock(&kvm->mmu_lock);
+		ret = __realm_dev_mem_map(kvm, &cache, rec_phys, pdev_phys,
+				vdev_phys, start_ipa, end_ipa, start_pa, &top_ipa);
+		write_unlock(&kvm->mmu_lock);
+
+		/* update base before we break out of loop*/
+		start_pa += top_ipa - start_ipa;
+		start_ipa = top_ipa;
+		if (ret && ret != -ENOMEM)
+			break;
+	} while (start_ipa < end_ipa);
+
+	kvm_mmu_free_memory_cache(&cache);
+	if (!ret) {
+		/* fold rtts if we can */
+		for (start_ipa = ALIGN(base_ipa, RMM_L2_BLOCK_SIZE);
+		     ((start_ipa + RMM_L2_BLOCK_SIZE) < end_ipa); start_ipa += RMM_L2_BLOCK_SIZE)
+			fold_rtt(&kvm->arch.realm, start_ipa, RMM_RTT_BLOCK_LEVEL);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(realm_dev_mem_map);
+
 /*
  * kvm_rec_pre_enter - Complete operations before entering a REC
  *
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 8aa362f44090..405542ffd9d1 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -378,6 +378,34 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope sco
 			return -EINVAL;
 		}
 	}
+	case PCI_TSM_REQ_STATE_CHANGE:
+	{
+		u32 req_type;
+
+		if (get_user(req_type, (u32 __user *)req.user))
+			return -EFAULT;
+
+		switch (req_type) {
+
+		case __REC_EXIT_DA_VDEV_MAP:
+		{
+			struct arm64_vdev_device_memmap_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+
+			return cca_vdev_device_map_validate(pdev, req_obj.vcpu_fd,
+							    req_obj.gpa_base,
+							    req_obj.gpa_top,
+							    req_obj.pa_base);
+		}
+		default:
+			return -EINVAL;
+		}
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 3c19dfe89c0a..d76095a3e6c3 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1108,3 +1108,40 @@ int cca_vdev_device_request(struct pci_dev *pdev, unsigned long vcpu_fd)
 		return -ENXIO;
 	return 0;
 }
+
+int cca_vdev_device_map_validate(struct pci_dev *pdev, unsigned long vcpu_fd,
+				 unsigned long gpa_base, unsigned long gpa_top,
+				 unsigned long pa_base)
+{
+	struct kvm *kvm;
+	struct realm *realm;
+	phys_addr_t rec_phys;
+	struct kvm_vcpu *vcpu;
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	struct cca_host_tdi *host_tdi;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct file *vcpu_filp __free(fput) = fget(vcpu_fd);
+
+	if (!file_is_vcpu(vcpu_filp))
+		return -EINVAL;
+
+	vcpu = vcpu_filp->private_data;
+	if (!vcpu)
+		return -EINVAL;
+
+	host_tdi = to_cca_host_tdi(pdev);
+	pf0_dsc = to_cca_pf0_dsc(pdev->tsm->dsm_dev);
+	kvm = host_tdi->tdi.kvm;
+	realm = &kvm->arch.realm;
+	rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
+	rmm_vdev_phys = virt_to_phys(host_tdi->rmm_vdev);
+	rmm_pdev_phys = virt_to_phys(pf0_dsc->rmm_pdev);
+
+	/* make sure this is the same vm */
+	if (vcpu->kvm != kvm)
+		return -EINVAL;
+
+	return realm_dev_mem_map(kvm, rec_phys, rmm_pdev_phys,
+				 rmm_vdev_phys, gpa_base, gpa_top, pa_base);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 2547afa1256f..60b10bce3140 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -154,4 +154,7 @@ int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long of
 int cca_vdev_get_interface_report(struct pci_dev *pdev);
 int cca_vdev_get_device_measurements(struct pci_dev *pdev, unsigned long flags, u8 *nonce);
 int cca_vdev_device_request(struct pci_dev *pdev, unsigned long rec_id);
+int cca_vdev_device_map_validate(struct pci_dev *pdev, unsigned long vcpu_fd,
+				 unsigned long gpa_base, unsigned long gpa_top,
+				 unsigned long pa_base);
 #endif
-- 
2.43.0


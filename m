Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8538237B;
	Mon, 27 Apr 2026 08:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280118; cv=none; b=ZMUuVtBt+ZBCzbG/7g8NTh7TotwoW5rdZFNieRO8kBT7JWNx72+AjlYDi/lr1IV0I2cYgtFgA1C00zmZk3ah2ySIQGgpRA5PsgASP9u+/hqv/mkBoWb+VBEvnkZatalhOrT59g9k8M1Hd0rr1tasBCP8kIoQ2OeIVT9OjW56f/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280118; c=relaxed/simple;
	bh=88hOg6NY6CrThS8YzdfhSv8cNoHRbxmDNGMrKrPhSG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTELDoQal1ejzyNA9mORQOJL7emDLmpX7Bx1m/rm+AHSVQLSSkluMBdHKCFXpwYzUcrDtVfm1x14P7o+kUK0xXWvxeeWT0IPtTiwTG01PfhpaB+dRoGyEBLhl4+pkX8wZzo0+A6g9HWQOIlvvMNUyQdYBl1WfKOXyRxqBZPHu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uaVL1qbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uaVL1qbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2B5C2BCB4;
	Mon, 27 Apr 2026 08:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280118;
	bh=88hOg6NY6CrThS8YzdfhSv8cNoHRbxmDNGMrKrPhSG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaVL1qbH1+1FgsujtGyxxMjxpj/QePOkHWqgpFPkJK67CH9KUxiTQ/z8pybWlLrmV
	 YUfvqOp7KZEfT8f+pq79bxNQMd2Evgn3ko6X6T4W4CS9ApFbV8yPnPWBNdlSmScnJH
	 ZHwfhK7dPBUh8ISmwZmNp78/D7R54Eq1SvMSfJhLys1TRBW/A0PzLH57q5YJqtVG+v
	 mrIdG8Ght3sPU0gIxBeFtaVvsP9+k84yqw6au7EuLOhh3tlOWv2OWq+IaUTv6awcdU
	 5D2rvo8xR/HVFS4B57lzXSd5JsRGEo3QH1DtpaCpOsiRLPsyIJHmWhw7B5EF8PAs+R
	 ADnyTT8xNIc6w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 13/16] coco: host: KVM: arm64: Handle vdev validate-mapping exits
Date: Mon, 27 Apr 2026 14:23:41 +0530
Message-ID: <20260427085344.941627-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the RMM/RHI definitions needed for device-memory mapping exits and
plumb them through the arm64 Realm host stack.

Teach KVM to handle RMI_EXIT_VDEV_VALIDATE_MAPPING by exposing the request
to userspace as KVM_EXIT_ARM64_TIO, carrying the vdev id together with the
GPA range and host PA supplied by RMM. On re-entry, complete the request
with RMI_RTT_DEV_VALIDATE.

Also add realm_dev_mem_map() so the host CCA driver can install
device-memory mappings for a vdev, and wire the PCI TSM state-change
request path to call it.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst           |  20 +++
 arch/arm64/include/asm/kvm_rmi.h         |   4 +
 arch/arm64/include/asm/rmi_smc.h         |   2 +
 arch/arm64/include/uapi/asm/rmi-da.h     |   9 ++
 arch/arm64/kvm/rmi-exit.c                |  37 +++++
 arch/arm64/kvm/rmi.c                     | 189 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/arm-cca.c |  27 ++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  |  21 +++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |   2 +
 include/uapi/linux/kvm.h                 |  11 ++
 10 files changed, 322 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5dfaafae14b6..4df99bb2857f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7454,6 +7454,26 @@ the ``KVM_EXIT_ARM_SEA_FLAG_GPA_VALID`` flag is set. Otherwise, the value of
 ``gpa`` is unknown.
 
 ::
+		/* KVM_EXIT_ARM64_TIO*/
+		struct {
+			__u64 flags;
+			__u64 nr;
+			__u64 vdev_id;
+			__u64 gpa_base;
+			__u64 gpa_top;
+			__u64 pa_base;
+			__u64 response;
+		} cca_exit;
+
+Used on arm64 systems. When the VM capability ``KVM_CAP_ARM_RMI`` is
+enabled, KVM generates a VM exit whenever the guest needs host assistance
+to validate a device-memory GPA-to-PA mapping. The ``nr`` field records
+the exit reason; currently the following values are defined:
+
+* ``RMI_EXIT_VDEV_VALIDATE_MAPPING``: the guest wants the host to validate or install a
+  device-memory mapping.
+
+The ``flags`` field must be zero.
 
 		/* Fix the size of the union. */
 		char padding[256];
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index e1f5523c2dfa..f49988fe182e 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -126,4 +126,8 @@ static inline bool kvm_realm_is_private_address(struct realm *realm,
 	return !(addr & BIT(realm->ia_bits - 1));
 }
 
+int realm_dev_mem_map(struct kvm *kvm, unsigned long pdev_phys,
+		unsigned long vdev_phys, unsigned long start_ipa,
+		unsigned long end_ipa, unsigned long start_pa);
+
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 29dbe4e0dfb0..6bbabcd853bd 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -328,6 +328,7 @@ struct rec_params {
 #define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
 #define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
 #define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
+#define REC_ENTER_FLAG_DEV_MEM_RESPONSE BIT(6)
 
 #define REC_RUN_GPRS			31
 #define REC_MAX_GIC_NUM_LRS		16
@@ -360,6 +361,7 @@ struct rec_enter {
 #define RMI_EXIT_RIPAS_CHANGE		0x04
 #define RMI_EXIT_HOST_CALL		0x05
 #define RMI_EXIT_SERROR			0x06
+#define RMI_EXIT_VDEV_VALIDATE_MAPPING		0x09
 
 struct rec_exit {
 	union { /* 0x000 */
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
index 97648928f763..572afb4095f2 100644
--- a/arch/arm64/include/uapi/asm/rmi-da.h
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -29,4 +29,13 @@ struct arm64_vdev_device_measurement_guest_req {
 };
 #define __RHI_DA_VDEV_UPDATE_MEASUREMENTS	0x4
 
+struct arm64_vdev_device_memmap_guest_req {
+	__u32 req_type;
+	__u32 reserved;
+	__aligned_u64 gpa_base;
+	__aligned_u64 gpa_top;
+	__aligned_u64 pa_base;
+};
+#define __REC_DA_VDEV_MAP		0x5
+
 #endif
diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 7eff6967530c..8c7cf716ce3c 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -129,6 +129,41 @@ static int rec_exit_host_call(struct kvm_vcpu *vcpu)
 	return kvm_smccc_call_handler(vcpu);
 }
 
+static inline void kvm_prepare_vdev_validate_mapping_exit(struct kvm_vcpu *vcpu,
+		gpa_t gpa_base, gpa_t gpa_top,
+		hpa_t pa_base, unsigned long vdev_id)
+{
+	vcpu->run->exit_reason = KVM_EXIT_ARM64_TIO;
+	vcpu->run->cca_exit.nr = RMI_EXIT_VDEV_VALIDATE_MAPPING;
+	vcpu->run->cca_exit.vdev_id  = vdev_id;
+	vcpu->run->cca_exit.flags = 0;
+	vcpu->run->cca_exit.gpa_base = gpa_base;
+	vcpu->run->cca_exit.gpa_top  = gpa_top;
+	vcpu->run->cca_exit.pa_base  = pa_base;
+	vcpu->run->cca_exit.response = 0;
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
+		vcpu->run->cca_exit.response = -EINVAL;
+		/* return to guest */
+		return 1;
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
@@ -198,6 +233,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_ripas_change(vcpu);
 	case RMI_EXIT_HOST_CALL:
 		return rec_exit_host_call(vcpu);
+	case RMI_EXIT_VDEV_VALIDATE_MAPPING:
+		return rec_exit_vdev_validate_mapping(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index f33d17ca855d..3a549dc87906 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1283,6 +1283,192 @@ static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 	rec->run->exit.ripas_base = base;
 }
 
+static int rmi_rtt_dev_map(unsigned long rd_phys, unsigned long vdev_phys,
+		unsigned long base, unsigned long top, unsigned long flags,
+		unsigned long oaddr, unsigned long *out_top, unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_RTT_DEV_MAP, rd_phys, vdev_phys, base, top, flags, oaddr);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+	if (*rmi_ret)
+		return 0;
+
+	*out_top = sro->regs.a1;
+
+	return 0;
+}
+
+static int rmi_rtt_dev_validate(unsigned long rd_phys, unsigned long rec_phys,
+		unsigned long base, unsigned long top, unsigned long *out_top,
+		unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_RTT_DEV_VALIDATE, rd_phys,
+			     rec_phys, base, top);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+	if (*rmi_ret)
+		return 0;
+
+	*out_top = sro->regs.a1;
+
+	return 0;
+}
+
+/*
+ * Even though we can map larger block, since we need to delegate each granule.
+ * We map granule size and fold
+ */
+static int __realm_dev_mem_map(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+		unsigned long pdev_phys, unsigned long vdev_phys,
+		unsigned long start_ipa, unsigned long end_ipa,
+		phys_addr_t phys, unsigned long *top_ipa)
+{
+	int ret = 0;
+	unsigned long rmi_ret;
+	unsigned long ipa = start_ipa, next_ipa;
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+
+	if (rmi_delegate_range(phys, end_ipa - start_ipa))
+		return -EINVAL;
+
+	while (ipa < end_ipa) {
+		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
+		unsigned long range_desc = addr_range_desc(phys, end_ipa - ipa);
+
+		ret = rmi_rtt_dev_map(rd_phys, vdev_phys, ipa, end_ipa, flags,
+				      range_desc, &next_ipa, &rmi_ret);
+		if (ret)
+			goto err_undelegate_tail;
+
+		if (RMI_RETURN_STATUS(rmi_ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(rmi_ret);
+
+			WARN_ON(level == RMM_RTT_MAX_LEVEL);
+
+			if (kvm_mmu_memory_cache_nr_free_objects(cache) <
+			    (RMM_RTT_MAX_LEVEL - level)) {
+				ret = -ENOMEM;
+				goto err_undelegate_tail;
+			}
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      RMM_RTT_MAX_LEVEL,
+						      cache);
+			if (ret)
+				goto err_undelegate_tail;
+
+			ret = rmi_rtt_dev_map(rd_phys, vdev_phys, ipa, end_ipa, flags,
+					      range_desc, &next_ipa, &rmi_ret);
+			if (ret)
+				goto err_undelegate_tail;
+		}
+
+		if (WARN_ON(rmi_ret != RMI_SUCCESS)) {
+			ret = -EIO;
+			goto err_undelegate_tail;
+		}
+
+		phys += next_ipa - ipa;
+		ipa = next_ipa;
+	}
+	/*
+	 * successfully mapped the provided range, return the top_ipa
+	 */
+	*top_ipa = end_ipa;
+	return 0;
+
+err_undelegate_tail:
+	*top_ipa = ipa;
+	/*
+	 * undelegate the tail range. Rest will be done by the caller.
+	 */
+	if (end_ipa > ipa)
+		WARN_ON(rmi_undelegate_range(phys, end_ipa - ipa));
+
+	return ret;
+}
+
+int realm_dev_mem_map(struct kvm *kvm, unsigned long pdev_phys,
+		unsigned long vdev_phys, unsigned long start_ipa,
+		unsigned long end_ipa, unsigned long start_pa)
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
+		ret = __realm_dev_mem_map(kvm, &cache, pdev_phys, vdev_phys,
+					  start_ipa, end_ipa, start_pa, &top_ipa);
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
+
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
+static void kvm_complete_vdev_map_validate(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	struct kvm_run *run = vcpu->run;
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
+
+	/* reject the vdev_map validate request  */
+	if (run->cca_exit.response) {
+		rec->run->enter.flags = REC_ENTER_FLAG_DEV_MEM_RESPONSE;
+	} else {
+		unsigned long next_ipa;
+		unsigned long start_ipa = run->cca_exit.gpa_base;
+
+		while (start_ipa < run->cca_exit.gpa_top) {
+			int ret;
+			unsigned long rmi_ret;
+
+			ret = rmi_rtt_dev_validate(rd_phys, rec_phys, start_ipa,
+					   run->cca_exit.gpa_top, &next_ipa,
+					   &rmi_ret);
+			if (ret || rmi_ret) {
+				rec->run->enter.flags = REC_ENTER_FLAG_DEV_MEM_RESPONSE;
+				break;
+			}
+			start_ipa = next_ipa;
+		}
+	}
+}
+
 /*
  * kvm_rec_pre_enter - Complete operations before entering a REC
  *
@@ -1311,6 +1497,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
 	case RMI_EXIT_RIPAS_CHANGE:
 		kvm_complete_ripas_change(vcpu);
 		break;
+	case RMI_EXIT_VDEV_VALIDATE_MAPPING:
+		kvm_complete_vdev_map_validate(vcpu);
+		break;
 	}
 
 	return 1;
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 855427935f2d..66e0acadf743 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -585,6 +585,33 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope sco
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
+		case __REC_DA_VDEV_MAP:
+		{
+			struct arm64_vdev_device_memmap_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+
+			return cca_vdev_device_map(pdev, req_obj.gpa_base,
+						   req_obj.gpa_top,
+						   req_obj.pa_base);
+		}
+		default:
+			return -EINVAL;
+		}
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index ec7701ff7e03..543c40fb1160 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1377,3 +1377,24 @@ int cca_vdev_update_device_measurements(struct pci_dev *pdev, unsigned long flag
 	/* get and update the interface report cache. */
 	return vdev_update_device_measurements_cache(pdev);
 }
+
+int cca_vdev_device_map(struct pci_dev *pdev, unsigned long gpa_base,
+		unsigned long gpa_top, unsigned long pa_base)
+{
+	struct kvm *kvm;
+	struct realm *realm;
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	struct cca_host_tdi *host_tdi;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	host_tdi = to_cca_host_tdi(pdev);
+	pdev_dsc = to_cca_pdev_dsc(pdev->tsm->dsm_dev);
+	kvm = host_tdi->tdi.kvm;
+	realm = &kvm->arch.realm;
+	rmm_vdev_phys = virt_to_phys(host_tdi->rmm_vdev);
+	rmm_pdev_phys = virt_to_phys(pdev_dsc->rmm_pdev);
+
+	return realm_dev_mem_map(kvm, rmm_pdev_phys, rmm_vdev_phys,
+				 gpa_base, gpa_top, pa_base);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 621e0858f0c6..3dfb6b3cc2ef 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -250,5 +250,7 @@ int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long of
 		unsigned long max_len, void __user *user_buf);
 int cca_vdev_update_interface_report(struct pci_dev *pdev);
 int cca_vdev_update_device_measurements(struct pci_dev *pdev, unsigned long flags, u8 *nonce);
+int cca_vdev_device_map(struct pci_dev *pdev, unsigned long gpa_base,
+		unsigned long gpa_top, unsigned long pa_base);
 
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 309f058cf2f8..bac41f2b13e4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -192,6 +192,7 @@ struct kvm_exit_snp_req_certs {
 #define KVM_EXIT_ARM_SEA          41
 #define KVM_EXIT_ARM_LDST64B      42
 #define KVM_EXIT_SNP_REQ_CERTS    43
+#define KVM_EXIT_ARM64_TIO	  44
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -496,6 +497,16 @@ struct kvm_run {
 		} arm_sea;
 		/* KVM_EXIT_SNP_REQ_CERTS */
 		struct kvm_exit_snp_req_certs snp_req_certs;
+		/* KVM_EXIT_ARM64_TIO*/
+		struct {
+			__u64 flags;
+			__u64 nr;
+			__u64 vdev_id;
+			__u64 gpa_base;
+			__u64 gpa_top; /* input and output */
+			__u64 pa_base;
+			__u64 response;
+		} cca_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.43.0


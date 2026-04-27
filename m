Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4150D3A5E72;
	Mon, 27 Apr 2026 08:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280056; cv=none; b=bTsySYQU6oCY1btSUaEecFAoZNnJZTfhST6ZEGVyP85DO0cA8/rBVl0nMUBtIlUY7n0m91coGf+mwDoEgL0JVtq9ZBp+EcDEXUPeJ3Te45z/GVKOAjlN6hPFh14O9Ue98QhLYP3tNCN1NPxj4OYJ6uVKhL8NucA9MqECF4Rgmrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280056; c=relaxed/simple;
	bh=JfWdATR+ksplR0PmftYBSWa0gSRwb/sK94s7f4YM0dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB1VbofMb5F67Uezt0fXIDLcY3t8uTxVjPQaTgqBkY5ApYFv3w3zGM4gAAdn5kt8OiNtCBK0VDmc5cNwjtC1IEanNSluQlXRHt2u0h5Uv+oV1EpNTxGwAUYKxtA3dRG9sDINfU8VjBswcxoB8kyhi7LVhEcTv7MEzPrPRk67//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKDZn4cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKDZn4cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54039C19425;
	Mon, 27 Apr 2026 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280055;
	bh=JfWdATR+ksplR0PmftYBSWa0gSRwb/sK94s7f4YM0dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKDZn4cjwl4lQA7o0Bz8MAbBaxcq/tX2h2EPZ6G3KsRbnikEBr4HSKBK9c/VZS5fp
	 BBip49RtACA8qnX1nupsWN85JiFbBMHa1HLbXqbPG+3sRck1QWnvG7vIN70l3qiNix
	 DovwKftQ8KWUOTu1Qh9xDi3lwNKvqdueniv/Ld9BTaDwIAjwRQYPc0XXTAjAq4mztC
	 ROqMinTMq7bNY5yFy34bNfWGfAPa9fpcT4E0vBCbyrFTI+2KUbcnfd/3JXQHo8Reak
	 DRTE/dV4WSC0o6ImUGdAEH0ZegDu1Ij8JqLaPJ5pnKAUYC6+exotV7ykDyjH8yyoco
	 gbUnKIFvWNzqQ==
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
Subject: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm viommu plumbing
Date: Mon, 27 Apr 2026 14:23:31 +0530
Message-ID: <20260427085344.941627-4-aneesh.kumar@kernel.org>
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

Add initial plumbing for Realm pSMMU integration in the arm-smmu-v3 iommufd
path.

Changes include:
- add RMI SMC IDs and helper wrappers for pSMMU activate and ST_L2 create/destroy
- add RMI pSMMU parameter structure definitions
- add IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 UAPI/internal type support
- add arm-smmu-v3 realm viommu init/vdevice hooks
- store SMMU MMIO physical base and realm initialization state in arm_smmu_device

This enables basic realm pSMMU setup and vdevice stream-table operations.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h             |   7 +
 arch/arm64/include/asm/rmi_smc.h              |  18 +++
 arch/arm64/kernel/rmi.c                       |  39 +++++
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |   7 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c | 148 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   4 +
 include/uapi/linux/iommufd.h                  |   1 +
 8 files changed, 225 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 75eb59d4fa84..659d68ad5f1d 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -863,4 +863,11 @@ static inline unsigned long rmi_psmmu_event_consume(unsigned long psmmu_phys,
 	return res.a0;
 }
 
+int rmi_psmmu_activate(unsigned long psmmu_phys,
+	       unsigned long psmmu_params_phys, unsigned long *rmi_ret);
+int rmi_psmmu_st_l2_create(unsigned long psmmu_phys,
+		   unsigned long stream_id, unsigned long *rmi_ret);
+int rmi_psmmu_st_l2_destroy(unsigned long psmmu_phys,
+		    unsigned long stream_id, unsigned long *rmi_ret);
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index be1b1e95a937..5b540d25914e 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -625,4 +625,22 @@ struct rmi_psmmu_info {
 	};
 };
 
+#define RMI_PSMMU_FLAG_MSI	BIT(0)
+#define RMI_PSMMU_FLAG_ATS	BIT(1)
+#define RMI_PSMMU_FLAG_PRI	BIT(2)
+struct rmi_psmmu_params {
+	union {
+		struct {
+			u64 flags;
+			u64 grr_addr;
+			u64 grr_data;
+			u64 eventq_addr;
+			u64 eventq_data;
+			u64 priq_addr;
+			u64 priq_data;
+		};
+		u8 padding5[0x1000];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
index da4707981548..cc4050db5a6a 100644
--- a/arch/arm64/kernel/rmi.c
+++ b/arch/arm64/kernel/rmi.c
@@ -423,6 +423,45 @@ unsigned long rmi_sro_execute(struct rmi_sro_state *sro)
 	return regs.a0;
 }
 
+int rmi_psmmu_activate(unsigned long psmmu_phys,
+	       unsigned long psmmu_params_phys, unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_PSMMU_ACTIVATE, psmmu_phys, psmmu_params_phys);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+
+	return 0;
+}
+
+int rmi_psmmu_st_l2_create(unsigned long psmmu_phys,
+		   unsigned long stream_id, unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_PSMMU_ST_L2_CREATE, psmmu_phys, stream_id);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+
+	return 0;
+}
+
+int rmi_psmmu_st_l2_destroy(unsigned long psmmu_phys,
+		    unsigned long stream_id, unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_PSMMU_ST_L2_DESTROY, psmmu_phys, stream_id);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+
+	return 0;
+}
+
 static int rmi_configure(void)
 {
 	struct rmm_config *config __free(free_page) = NULL;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index ddae0b07c76b..c98e91b3ca13 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -437,6 +437,9 @@ size_t arm_smmu_get_viommu_size(struct device *dev,
 	if (viommu_type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
 		return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
 
+	if (viommu_type == IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
+		return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
+
 	if (!smmu->impl_ops || !smmu->impl_ops->get_viommu_size)
 		return 0;
 	return smmu->impl_ops->get_viommu_size(viommu_type);
@@ -464,6 +467,10 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 		return 0;
 	}
 
+	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
+		return arm_realm_smmu_v3_init(viommu, user_data);
+
+
 	return smmu->impl_ops->vsmmu_init(vsmmu, user_data);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
index fec1a32de53c..6f8de7cead9d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c
@@ -6,6 +6,7 @@
 #include <linux/interrupt.h>
 #include <asm/rmi_smc.h>
 #include <asm/rmi_cmds.h>
+#include <asm/kvm_emulate.h>
 
 #include "arm-smmu-v3.h"
 
@@ -122,3 +123,150 @@ void arm_smmu_setup_realm_irqs(struct arm_smmu_device *smmu)
 		}
 	}
 }
+
+static void arm_realm_smmu_v3_destroy(struct iommufd_viommu *viommu)
+{
+	/* When we add refcount psmmu deactivate here. */
+}
+
+static void arm_realm_smmu_v3_vdevice_destroy(struct iommufd_vdevice *vdev)
+{
+	struct device *dev = iommufd_vdevice_to_device(vdev);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	/* FIXME which stream to pick */
+	/* At this moment, iommufd only supports PCI device that has one SID */
+	struct arm_smmu_stream *stream = &master->streams[0];
+	struct arm_smmu_device *smmu = master->smmu;
+	unsigned long rmi_ret = 0;
+	int ret;
+
+	if (!smmu->realm_initialized)
+		return;
+
+	ret = rmi_psmmu_st_l2_destroy(smmu->base_phys,
+				    ALIGN_DOWN(stream->id, STRTAB_NUM_L2_STES),
+				      &rmi_ret);
+	if (ret || rmi_ret) {
+
+		/* Table in use */
+		if (RMI_RETURN_STATUS(rmi_ret) == RMI_ERROR_PSMMU_ST &&
+		    RMI_RETURN_INDEX(rmi_ret) == 2)
+			return;
+
+		dev_warn(dev, "failed to destroy realm stream mapping\n");
+	}
+}
+
+static int arm_realm_smmu_v3_vdevice_init(struct iommufd_vdevice *vdev)
+{
+	struct device *dev = iommufd_vdevice_to_device(vdev);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	// fixme which stream to pick
+	/* At this moment, iommufd only supports PCI device that has one SID */
+	struct arm_smmu_stream *stream = &master->streams[0];
+	struct arm_smmu_device *smmu = master->smmu;
+	unsigned long rmi_ret = 0;
+	int ret;
+
+	if (!smmu->realm_initialized)
+		return -EINVAL;
+
+	ret = rmi_psmmu_st_l2_create(smmu->base_phys,
+				     ALIGN_DOWN(stream->id, STRTAB_NUM_L2_STES),
+				     &rmi_ret);
+	if (ret || rmi_ret) {
+		if (!ret)
+			return -EIO;
+		if (RMI_RETURN_STATUS(rmi_ret) == RMI_ERROR_PSMMU_ST &&
+		    RMI_RETURN_INDEX(rmi_ret) == 2) {
+			/* table already exist */
+			vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
+			return 0;
+		}
+		dev_warn(dev, "failed to create realm stream mapping\n");
+		return -EIO;
+	}
+	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
+	return 0;
+}
+
+static const struct iommufd_viommu_ops arm_realm_smmu_v3_ops = {
+	.destroy = arm_realm_smmu_v3_destroy,
+	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
+	.cache_invalidate = arm_vsmmu_cache_invalidate,
+	.vdevice_init = arm_realm_smmu_v3_vdevice_init,
+};
+
+static int get_irq_data(int irq, u64 *msi_addr, u64 *msi_data)
+{
+	struct msi_desc *desc;
+
+	desc = irq_get_msi_desc(irq);
+	if (!desc)
+		return -EINVAL;
+
+	*msi_addr = (((u64)desc->msg.address_hi) << 32) | desc->msg.address_lo;
+	*msi_data = desc->msg.data;
+	return 0;
+}
+
+int arm_realm_smmu_v3_init(struct iommufd_viommu *viommu,
+			   const struct iommu_user_data *user_data)
+{
+	int ret = 0;
+	struct kvm *kvm = viommu->kvm;
+	struct rmi_psmmu_params *params;
+	struct arm_smmu_device *smmu =
+		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
+	unsigned long rmi_ret;
+
+	if (!kvm)
+		return -EINVAL;
+
+	if (!kvm_is_realm(kvm))
+		return -EINVAL;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_RME))
+		return -EOPNOTSUPP;
+
+	if (smmu->realm_initialized)
+		goto psmmu_already_active;
+
+	params = (struct rmi_psmmu_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	/* No ATS and PRI support */
+	if (!(smmu->features & ARM_SMMU_FEAT_MSI))
+		goto psmmu_activate;
+
+	params->flags = RMI_PSMMU_FLAG_MSI;
+	if (get_irq_data(smmu->realm_gerr_irq,
+			 &params->grr_addr, &params->grr_data)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+	if (get_irq_data(smmu->realm_evtq_irq,
+			 &params->eventq_addr, &params->eventq_data)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+psmmu_activate:
+	ret = rmi_psmmu_activate(smmu->base_phys, virt_to_phys(params),
+				 &rmi_ret);
+	if (ret || rmi_ret) {
+		if (!ret)
+			ret = -EIO;
+		dev_warn(smmu->dev, "failed to activate realm pSMMU\n");
+		ret = -EIO;
+	} else {
+		smmu->realm_initialized = true;
+	}
+out_free:
+	free_page((unsigned long)params);
+psmmu_already_active:
+	if (!ret)
+		viommu->ops = &arm_realm_smmu_v3_ops;
+	return ret;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 17fd99887aab..1e3d4d682e32 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3956,6 +3956,7 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 	if (ret)
 		return ret;
 
+	smmu->realm_initialized = false;
 	if (smmu->impl_ops && smmu->impl_ops->init_structures)
 		return smmu->impl_ops->init_structures(smmu);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6680516b571b..d528b3212d38 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -811,6 +811,8 @@ struct arm_smmu_device {
 
 	struct rb_root			streams;
 	struct mutex			streams_mutex;
+
+	bool realm_initialized;
 };
 
 struct arm_smmu_stream {
@@ -1073,6 +1075,8 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 			      const struct iommu_user_data *user_data);
 int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 			       struct iommu_user_data_array *array);
+int arm_realm_smmu_v3_init(struct iommufd_viommu *viommu,
+			   const struct iommu_user_data *user_data);
 #else
 #define arm_smmu_get_viommu_size NULL
 #define arm_smmu_hw_info NULL
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 47213663c0c1..74afc9967c3e 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -1055,6 +1055,7 @@ enum iommu_viommu_type {
 	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
 	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
 	IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV = 2,
+	IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 = 3,
 };
 
 /**
-- 
2.43.0


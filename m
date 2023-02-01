Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481318481
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:48 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id o18so7754445wrj.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1XbjFRROGqTsKVaKlJ9OMpS1XHI6QRbg+Uxdf993wI=;
        b=vGASOMbylysHRfrGLv6YhTO7WEjv6c1RwzKjV7XsdcywE+jEFIsdsb5w+2OghxLS9/
         qXlv60FR7L4TDsiNTkGc7CFP9sOBBSMgFZJP6RehQWKk+xblpDCkv+NdoiRZJc4lo+MB
         OHZI/Ska0NQGQp6sf6XYaGIC4f/Sqp2c09J4jQvzaOnijt2sBekilaucOj/jUKSNd/AX
         5pRusIs+/gQ0kDODgdeueanv2yN6KNe+s7ycRNU9ypbQUkV21yxob/1nlBgVHMhIfud/
         OgRirqcvdAhkcPaU2A0Q77RWKieLbANDuuIfIpzi/IVRF8f+n9FVapUusjVNOE82ZS44
         c4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1XbjFRROGqTsKVaKlJ9OMpS1XHI6QRbg+Uxdf993wI=;
        b=jG6w1bLhkunRj/NA+gzbpuZxiZAKrINlYEkFpe5o6d7Q9VwSO/F5uVwjj00BkAPgmR
         MRhilg4xDC8iTsQZDFRcrlL0eJWd0dqdnp71c8yz/BJsmSYm161vvSaNpOqGtFGGaUe9
         EdC12wQhdbYdgysYZGddYfmcuPzAxskFfvkPtjz8sNy0GarNgTZ2ex4JBSMJWx9Z3r+q
         68heu10USmaGFy8Qm42vc/bs9srNrGoW5l2jMVXc5j5bUbuvK3EzoYNU1dkV0LaHt9uu
         aTparu2pn+dQKWStof5YB64dbfrXnq/vfdchmqG3aTv+mIw/SP1vsfi6C8e1Ubq3fgVt
         rvNA==
X-Gm-Message-State: AO0yUKVP21OL2Kidp2ENTR+yIqsHHG0r/CEjUNM4togWRam8sde9zKEx
	CabDwclklhUnqmJ/OMSZNZof5w==
X-Google-Smtp-Source: AK7set/A9Wvge/x9I0c0N1VcVRmzSfGiz2QGPnhn/EemCOX5Ccigvrx/7k9pg7r6kMkCHM3qkXEWvg==
X-Received: by 2002:a5d:6b48:0:b0:2bf:963a:f266 with SMTP id x8-20020a5d6b48000000b002bf963af266mr1586152wrw.27.1675256387822;
        Wed, 01 Feb 2023 04:59:47 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:47 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 36/45] iommu/arm-smmu-v3-kvm: Validate device features
Date: Wed,  1 Feb 2023 12:53:20 +0000
Message-Id: <20230201125328.2186498-37-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM hypervisor driver supports a small subset of features. Ensure
the implementation is compatible, and disable some unused features.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 1e0daf9ea4ac..2cc632f6b256 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -23,6 +23,59 @@ static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
 
+static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
+{
+	unsigned long oas;
+	unsigned int required_features =
+		ARM_SMMU_FEAT_TRANS_S2 |
+		ARM_SMMU_FEAT_TT_LE;
+	unsigned int forbidden_features =
+		ARM_SMMU_FEAT_STALL_FORCE;
+	unsigned int keep_features =
+		ARM_SMMU_FEAT_2_LVL_STRTAB	|
+		ARM_SMMU_FEAT_2_LVL_CDTAB	|
+		ARM_SMMU_FEAT_TT_LE		|
+		ARM_SMMU_FEAT_SEV		|
+		ARM_SMMU_FEAT_COHERENCY		|
+		ARM_SMMU_FEAT_TRANS_S1		|
+		ARM_SMMU_FEAT_TRANS_S2		|
+		ARM_SMMU_FEAT_VAX		|
+		ARM_SMMU_FEAT_RANGE_INV;
+
+	if (smmu->options & ARM_SMMU_OPT_PAGE0_REGS_ONLY) {
+		dev_err(smmu->dev, "unsupported layout\n");
+		return false;
+	}
+
+	if ((smmu->features & required_features) != required_features) {
+		dev_err(smmu->dev, "missing features 0x%x\n",
+			required_features & ~smmu->features);
+		return false;
+	}
+
+	if (smmu->features & forbidden_features) {
+		dev_err(smmu->dev, "features 0x%x forbidden\n",
+			smmu->features & forbidden_features);
+		return false;
+	}
+
+	smmu->features &= keep_features;
+
+	/*
+	 * This can be relaxed (although the spec says that OAS "must match
+	 * the system physical address size."), but requires some changes. All
+	 * table and queue allocations must use GFP_DMA* to ensure the SMMU can
+	 * access them.
+	 */
+	oas = get_kvm_ipa_limit();
+	if (smmu->oas < oas) {
+		dev_err(smmu->dev, "incompatible address size\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -68,11 +121,15 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (!kvm_arm_smmu_validate_features(smmu))
+		return -ENODEV;
+
 	platform_set_drvdata(pdev, host_smmu);
 
 	/* Hypervisor parameters */
 	hyp_smmu->mmio_addr = ioaddr;
 	hyp_smmu->mmio_size = size;
+	hyp_smmu->features = smmu->features;
 	kvm_arm_smmu_cur++;
 
 	return 0;
-- 
2.39.0


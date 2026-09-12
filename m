Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBD1418353;
	Sat, 12 Sep 2026 08:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202216; cv=none; b=NkCIinIaiR0XeS/8kum9i9BfrBa2ZXnjo14ysLjNMTnYP2iirNp5tI8Xf7hGT2N8E6/ir6IJBnNdE5XijvMGS49bd99/Lczz4calTHc4o97XjOakU3yR1O2M2dnou2pz1gQxTuQzolYOgqoyAzWFbMyDo6/iLfuVupX+g1BXOtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202216; c=relaxed/simple;
	bh=xYGEaS8WqRXy4gKjMYCYl3wvNlWG1k1qPV2+uqWO2eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqQi25BFng/5dY9mY8Sg8tFm6HLVI5vh8w7z+os++DS85JS/dPXrhtUz6MtpOBnDQ2LUmfT5yUiiyGRHILflVaETvo9hV1msLq+xwmVBV9/ZmYxAvXMPJWb365bs1e+L9ehevVq3JVVVycjzwOg3GZyoWrTUmTLpt/hJ1tqnjsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fuXHRgdE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fuXHRgdE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 913C31713;
	Sat, 12 Sep 2026 01:36:48 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 99A993F7B4;
	Sat, 12 Sep 2026 01:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789202212; bh=xYGEaS8WqRXy4gKjMYCYl3wvNlWG1k1qPV2+uqWO2eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuXHRgdEBk5W1VkCnQl+EAfa71FygiKN60WrDO2pqkEGMsOjk2HQKb5LV+3QzdDBO
	 3Sz62YPHDjQvoLK2rIfUNff8pLAcIjFcpUp/ABUK5yxFEb4IuzsHiT0NLt5FpYglmV
	 I3VbpI7nnDAS6AB3gofqQuna+SIuC7sKV359g3/A=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 3/7] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Sat, 12 Sep 2026 09:36:06 +0100
Message-ID: <20260912083611.2513845-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912083611.2513845-1-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

RMM v2.0 brings the ability to set the RMM's granule size. Check the
feature registers and configure the RMM so that it matches the host's
page size. This means that operations can be done with a granularity
equal to PAGE_SIZE.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v17:
  * Move rmi_config_set() out of the header file.
  * Print the error message for rmi_config_set if it fails
 Changes since v15:
  * Actually check the feature register for the host's page-size support.
 Changes since v14:
  * Move the implementation into drivers/firmware/arm_rmm.
 Changes since v13:
  * Moved out of KVM.
---
 drivers/firmware/arm_rmm/rmi.c | 79 ++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 2fd538c937dca..5b0e342ce3d58 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -35,6 +35,25 @@ static int rmi_features(unsigned long index, unsigned long *out)
 	return args.a0;
 }
 
+/**
+ * rmi_rmm_config_set() - Configure the RMM
+ * @cfg_ptr: PA of a struct rmm_config
+ *
+ * Sets configuration options on the RMM.
+ *
+ * Return: RMI return code
+ */
+static int rmi_rmm_config_set(unsigned long cfg_ptr)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RMM_CONFIG_SET, cfg_ptr,
+	};
+
+	rmi_smccc_invoke(&regs);
+
+	return regs.a0;
+}
+
 unsigned long rmi_feat_reg(unsigned long index)
 {
 	if (WARN_ON(index >= RMI_FEAT_REG_COUNT))
@@ -98,6 +117,62 @@ static int rmi_read_features(void)
 	return 0;
 }
 
+static int rmi_configure(void)
+{
+	unsigned long granule_feature;
+	unsigned long granule_size;
+	int ret = 0;
+	struct rmm_config *config;
+
+	switch (PAGE_SIZE) {
+	case SZ_4K:
+		granule_size = RMI_GRANULE_SIZE_4KB;
+		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB;
+		break;
+	case SZ_16K:
+		granule_size = RMI_GRANULE_SIZE_16KB;
+		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB;
+		break;
+	case SZ_64K:
+		granule_size = RMI_GRANULE_SIZE_64KB;
+		granule_feature = RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB;
+		break;
+	default:
+		BUILD_BUG();
+	}
+
+	if (!(rmi_feat_reg(1) & granule_feature)) {
+		pr_err("RMM does not support %luKB granules\n",
+		       PAGE_SIZE >> 10);
+		return -ENXIO;
+	}
+
+	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
+	if (!config) {
+		pr_err("Unable to allocate memory for RMM config\n");
+		return -ENOMEM;
+	}
+
+	config->rmi_granule_size = granule_size;
+
+	/*
+	 * For now we set the tracking_region_size to 0 which is the only option
+	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
+	 * TODO: Support other tracking sizes via Kconfig option for other
+	 * PAGE_SIZES
+	 */
+	config->tracking_region_size = 0;
+
+	ret = rmi_rmm_config_set(virt_to_phys(config));
+	if (ret) {
+		pr_err("RMM config set failed (%d)\n", ret);
+		ret = -EINVAL;
+	}
+
+	free_page((unsigned long)config);
+	return ret;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -111,6 +186,10 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	ret = rmi_configure();
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.43.0


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E7435E1CC;
	Thu, 24 Sep 2026 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257951; cv=none; b=rWRJpZxJWmY6ShVq/IpQoFG4JuebRnJN9LAhrgZ8q1EUVY6u7cO2P51Bx+TkPDR+L7IsNuaK6Tpdjjq4yeLz3tpPnrDJspGd++Urawt0BrgsJknQua/zbKyuwbnzS7sO9rN7vvXa9mK8a9TTYelmpB+51qQh0H3gcTRk0ualZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257951; c=relaxed/simple;
	bh=qa9TZc+aTVWQg28XUDat98BhOFmHoCXzzZDDjNuWdBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSIhwOPkBjThZj90OK4b8FcjCiKkW21ysVfwr6f1P0N7xYb/EK5EILjGngSqjWmBlsS7m0oqlTwc6sJZzn+oQ/icPcT01BrdluT2LvQoRDqyiV3iIdkkrnlsfKs+XMD1a7HDITAZAVwLa9MwFxXt16Wqf0ZQfkOcaJ2f2d4dnHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sPJUmP8g; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sPJUmP8g"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B100F1570;
	Thu, 24 Sep 2026 06:52:25 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D91B23F86F;
	Thu, 24 Sep 2026 06:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790257949; bh=qa9TZc+aTVWQg28XUDat98BhOFmHoCXzzZDDjNuWdBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPJUmP8g1+AefzPlXHz6cLm6+/mYNdV+uq+2qdC0sPnNVCcJbFLzRteCy+uMp9x4x
	 NlHQZjBOzK2wHXffBADSFoG/1sNvYEeWztkfjTl5EXKqBySWVzlEawzmKyJDqwtIzg
	 Qsjwgq0ix/WPIXWS1eL/pfDaJcUlc+ReHMMkx1bM=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v19 3/7] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Thu, 24 Sep 2026 14:51:57 +0100
Message-ID: <20260924135201.850038-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924135201.850038-1-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v2.0 brings the ability to set the RMM's granule size. Check the
feature registers and configure the RMM so that it matches the host's
page size. This means that operations can be done with a granularity
equal to PAGE_SIZE.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v18:
  * Move the rmi_config_set closer to rmi_configure, drop the comment
  * Use __free() magic for rmm_config object
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
 drivers/firmware/arm_rmm/rmi.c | 70 ++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 3baba931f92e4..c9ea964fd9081 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -84,6 +84,72 @@ unsigned long rmi_feat_reg(unsigned long index)
 }
 EXPORT_SYMBOL_GPL(rmi_feat_reg);
 
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
+static int rmi_configure(void)
+{
+	unsigned long granule_feature;
+	unsigned long granule_size;
+	int ret = 0;
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
+	struct rmm_config *config __free(free_page) =
+		(struct rmm_config *)get_zeroed_page(GFP_KERNEL);
+
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
+	return ret;
+}
 
 static int __init arm64_init_rmi(void)
 {
@@ -98,6 +164,10 @@ static int __init arm64_init_rmi(void)
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


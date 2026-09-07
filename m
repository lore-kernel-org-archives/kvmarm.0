Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CBB466AE1;
	Mon,  7 Sep 2026 10:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775210; cv=none; b=RwwcqTfvPs4I7s4O2OmfjpCYYgyJtxO3B0ZSxbSKw4IVJPvvVxU/Z7vt6oeO9mfLsqYfDBfjD0UpZCTomwlLgtSOjSZKbK9Is4qPpxTUpwkb18wnKh+VnE9g9/Ydly51MSOhOd2uFP4S1goiamLh9EbRnvK0aNiYkRSZl1lZluQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775210; c=relaxed/simple;
	bh=+Wef5eEgQduEiDa1tV8XW5jWMF2Z9IL+jMT+GW+PGLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVUiECWh+7RemtGVzJ530fIJvhgiaWZ/0Ood+YzyXkhu06vTt3ONxOeYq99J8k1KIrYn3uOu/r75DqkVn4CYBVtrJmUUH11k9lGW5IeUuhTc0/XgKZRy7ub4KBIAzUXOWE8aIoc/EujYJqFQvNeNF3pHWJ2PCpaZY5FZ1V0jUww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jQpfArcJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jQpfArcJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 549641476;
	Mon,  7 Sep 2026 03:00:04 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 410193F7B4;
	Mon,  7 Sep 2026 03:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788775208; bh=+Wef5eEgQduEiDa1tV8XW5jWMF2Z9IL+jMT+GW+PGLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQpfArcJNK14BqrE92Ldp01QPPFr6TyiIvwNP777zdWog7UVwfxqzWITJ+l/tW7eE
	 rLkG1biGLRUcNJLia/dMMEpIGEkCRvie29sxlD2TzB5kKL+QkSJVoJcTbqE4AOcli3
	 E4SZrAHma4XIdc+dJikuynjKrqTlHOs53UDoQyQg=
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
Subject: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Mon,  7 Sep 2026 10:59:37 +0100
Message-ID: <20260907095942.1140734-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907095942.1140734-1-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
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

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v15:
  * Actually check the feature register for the host's page-size support.
 Changes since v14:
  * Move the implementation into drivers/firmware/arm_rmm.
 Changes since v13:
  * Moved out of KVM.
---
 drivers/firmware/arm_rmm/rmi.c | 58 ++++++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h   | 17 ++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 008a783407b4e..76f91c145e1fd 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -77,6 +77,60 @@ static int rmi_read_features(void)
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
+	if (!config)
+		return -ENOMEM;
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
+		pr_err("RMM config set failed\n");
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
@@ -90,6 +144,10 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	ret = rmi_configure();
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 2fb1f7f86d71e..9aa27697e2377 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -12,6 +12,23 @@
 
 unsigned long rmi_feat_reg(unsigned long id);
 
+/**
+ * rmi_rmm_config_set() - Configure the RMM
+ * @cfg_ptr: PA of a struct rmm_config
+ *
+ * Sets configuration options on the RMM.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
+
+	return res.a0;
+}
+
 /**
  * rmi_features() - Read feature register
  * @index: Feature register index
-- 
2.43.0


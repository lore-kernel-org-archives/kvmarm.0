Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016E84A688D;
	Thu,  1 Oct 2026 08:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844398; cv=none; b=Olqrp8Bz/kaPB1odpC8JE5eBjAzRSnbS5Vy74LI8I18/yLO8+5OSa88h+q3/3gVU2OsydIrUPmqR5dAQEdK8IJ/YG9Qt3sX9bmeVmgPrctIftZQMUpNGEXDqAOd1Fu1cATPn37cxcRmHG3aAZlOHlBdMVyT4r72T7vdhF1C3wBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844398; c=relaxed/simple;
	bh=jMF7cPjgSwrYgKWpu0S5vDpf99D4E45DpJ7BDVWrE8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRqpFwEey4oeaQ8QDMjylzyLrjUZo8Dmdxr9YWKR5eAB1fL5JeUeCbzWCSnBknxdpkVV/Yct6uiulSWQ95ATYLkSaEJMMrTB3clukGghwpwEt0LeGc4FnYsO9DuafhM76UVdzqszMrdVGSW3Ap+ylg94D92HxHenadY1cOdcB6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dyAhrBNN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dyAhrBNN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2A09143D;
	Thu,  1 Oct 2026 01:46:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3360F3F85F;
	Thu,  1 Oct 2026 01:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790844396; bh=jMF7cPjgSwrYgKWpu0S5vDpf99D4E45DpJ7BDVWrE8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyAhrBNNePU4ZHt/gUvkl2UmkPqoPoGcHG8Cx0lsTzJkDIdNYqc2QnTMGsUqGNitN
	 DcjG2/jt1R5Bef4oKImkq0rZQubA8eiWdk0KnnLAHEe789v1xkqV2Hyj81LZ4IEF8p
	 th87G3yfYiOJTekLa8MMQTwPoLfQSf+NRx4XygJQ=
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
Subject: [PATCH v21 3/9] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Thu,  1 Oct 2026 09:45:49 +0100
Message-ID: <20261001084555.1456543-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001084555.1456543-1-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
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

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v19:
  * Don't initialize 'ret' in rmi_configure, add explicit return 0/-EINVAL
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
index 90706a16c8836..b558965a05a2c 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -84,6 +84,72 @@ unsigned long rmi_feat_reg(unsigned int index)
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
+	int ret;
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
+		return -EINVAL;
+	}
+
+	return 0;
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


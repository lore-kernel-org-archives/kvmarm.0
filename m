Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CEE418A4E;
	Mon,  3 Aug 2026 13:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764678; cv=none; b=GY1mT9K6RdrdJO4lH15v4OBTKFtKn6Twf15TenO5K7cGJX//zTITkIXyGerMZW5nODZ06GWHe4RKVf503uOzMrJYsa5LlhGUNv2od1QS/v5vAsaKTuHSNAxBPnoYGTQ09GYRvQoIWelfsPKQA3kuLXZFvffcHKlGY/dyV73mojg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764678; c=relaxed/simple;
	bh=a87dBoIo+abuHgtTSNKpMeJOicdZeUlF8rukrl520eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THTTLL6ZbTCSQJwOi5yL+F+ZRSz0aZrQzr/zqfYJKKdDKZaICo1BhaergfSJZbhyily0xeP/g6Rb6ZtAzG7MgShoiKa7LUHbsyoH1vDaatlVzxhjYEToIoRQoBVStu86wLgoFEYJm7FJWnpYEFeens2yNldZnIJTtzLGVcd+riY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pMyjQBeB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pMyjQBeB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE762143D;
	Mon,  3 Aug 2026 06:44:32 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9965A3F66F;
	Mon,  3 Aug 2026 06:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764676; bh=a87dBoIo+abuHgtTSNKpMeJOicdZeUlF8rukrl520eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMyjQBeBYwoZSI0DbSR2aZTg1nQpOqpGBko74lcraMj2do/JBVxlHmi9zICxzM7de
	 iZEcEpqEky0c+AANwK9eXvydVOl2QjP1Ndgt52P0yU90vYc0XiNtTXKBLkf/sijbYw
	 qQ/ALa0hCmvxwZtXPBgCjnL7vQDdrWON0zgltEN8=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 04/45] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Mon,  3 Aug 2026 14:43:20 +0100
Message-ID: <20260803134403.80630-5-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
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

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Actually check the feature register for the host's page-size support.
Changes since v14:
 * Move the implementation into drivers/firmware/arm_rmm.
Changes since v13:
 * Moved out of KVM.
---
 drivers/firmware/arm_rmm/rmi.c | 61 ++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 008a783407b4..ff9f76cc199a 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -77,6 +77,63 @@ static int rmi_read_features(void)
 	return 0;
 }
 
+static int rmi_configure(void)
+{
+	unsigned long granule_feature;
+	unsigned long granule_size;
+	long rmi_ret;
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
+	rmi_ret = rmi_rmm_config_set(virt_to_phys(config));
+	if (rmi_ret) {
+		pr_err("RMM config set failed\n");
+		ret = -EINVAL;
+		goto out_free_config;
+	}
+
+out_free_config:
+	free_page((unsigned long)config);
+	return ret;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -90,6 +147,10 @@ static int __init arm64_init_rmi(void)
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


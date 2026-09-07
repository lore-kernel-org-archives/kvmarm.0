Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E227F46A608;
	Mon,  7 Sep 2026 10:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775216; cv=none; b=oQ05wn4yBSS7P4IbrruVsMxUHxp3hDyueXQNyrfvcmbpUJSqpZ41KJ9fCvO57i2Hj8qihBv7UmfQstnEUA97R/fEnC8kEhkGTO0a1lzkHRzdckgroUEg2zP+zW06EvXRYHKMM9Hgz9T1MaxGrKjbcGiCWwE2S7X9eWR4PqRbavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775216; c=relaxed/simple;
	bh=3REQ5jWF12CkaqiVLtnquClwniilkFTh6i4V9X/W8Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSgfLDrPxR9LeECGIBhISVbLRBwCv+a6jf7juqlBqO9F9uTZ1ImwlgDKAwA4TK3HQqcBljFhN2W+v3KTdDEpkDw+TWq5pOD8CovISBvPZXx1t7aBTDDOyIT6gmz1WIA/VFN7PZsaW+1M+und84pq7paFAUkx3HdFLsRypM7ewKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o0NNnupV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o0NNnupV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 915ED1476;
	Mon,  7 Sep 2026 03:00:10 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 805B03F7B4;
	Mon,  7 Sep 2026 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788775214; bh=3REQ5jWF12CkaqiVLtnquClwniilkFTh6i4V9X/W8Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0NNnupVWVetQC/vx9RJ9UwpkUGwpzRnsMh/ZRIvgHt+mOk9nl819dKIE+ZvGQhUy
	 BQply/fsvQkQWNz+OxKAzFYILQkAcFFFc62hn3afjNrGmhfiyPdqPrmw4a1knt1Oo8
	 +EeUQ0bCZdi67lxEO0ZhxGXTqxCelNU1w59Qv6Js=
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
Subject: [PATCH v17 5/7] firmware: arm_rmm: Activate the RMM
Date: Mon,  7 Sep 2026 10:59:39 +0100
Message-ID: <20260907095942.1140734-6-suzuki.poulose@arm.com>
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

Activate the RMM after the basic configuration. This is a memory transferring,
stateful operation.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v16:
 * Split into a new patch
---
 drivers/firmware/arm_rmm/rmi.c | 17 +++++++++++++++--
 include/linux/arm-rmi-cmds.h   | 11 +++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 42c973c3a98bb..d969c8738efde 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -641,7 +641,8 @@ static int rmi_configure(void)
 
 static int __init arm64_init_rmi(void)
 {
-	int ret;
+	int ret = 0;
+	struct rmi_sro_state *sro = NULL;
 
 	/* Continue without realm support if we can't agree on a version */
 	ret = rmi_check_version();
@@ -656,7 +657,19 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
-	return 0;
+	/* Activate the RMM */
+	sro = kmalloc_obj(*sro);
+	if (!sro)
+		return -ENOMEM;
+
+	ret = rmi_rmm_activate(sro);
+	if (ret) {
+		pr_err("RMM activate failed\n");
+		ret = ret < 0 ? ret : -ENXIO;
+	}
+
+	kfree(sro);
+	return ret;
 }
 
 /*
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index fed0f3421895d..dea7c7004d35f 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -64,6 +64,17 @@ static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
 	return res.a0;
 }
 
+/**
+ * rmi_rmm_activate() - Activate the RMM
+ * @sro: Preallocated SRO context to be used
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rmm_activate(struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
+}
+
 /**
  * rmi_features() - Read feature register
  * @index: Feature register index
-- 
2.43.0


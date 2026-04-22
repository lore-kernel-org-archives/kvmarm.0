Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9238537FF58
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776875106; cv=none; b=Qyk295bUFF7cVEgkV53YEzk8lG3QLvIffyYD7hi/GXcf3Pe7VBfu3afoAMNm74gCoyfENOxt8FLARvI6zm3P32QukmCxWXrildQ4HyoQMAt6jXgZ0UG4CZJb2hZ7pLiif8t484kWEqMo+wWsOqezDPnZxxlXuiOQwI7SP+QWbpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776875106; c=relaxed/simple;
	bh=+KnBVwVQsum+9CObFDKz95hXpLV5Rw5969CJRIdIoIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYpdI79QWV+gPt+xCN+Rh1ZDTyesJv+QZZuJ7+GMbVGKv7fSbYjTWvoh+qWXT7wcY2aUJofgRigqcDTVBkU098PsF1T4VRgSiM4xJzTSIZjrEBO29ly5FSceItnpmhkv2z3TNLAoDnuPPIw/Ebk2eTBZPfORTitYeNv9Ndulv40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k2g586JF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k2g586JF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FA691F91;
	Wed, 22 Apr 2026 09:24:58 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 84A613F23F;
	Wed, 22 Apr 2026 09:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776875103; bh=+KnBVwVQsum+9CObFDKz95hXpLV5Rw5969CJRIdIoIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2g586JFM89yTYChnUIUHqyRBlz+btkGzp3IaaoiKKbQoyNJiZJ7qCqq7faO5UdDk
	 vy/iC/oj8l5ZGXZwtzUoiJ+rAmcwEuiu89yVeT7AUxX3DS6cm/RwXEa8fckmk1PX5p
	 A+CfMmP03d/ZnRSY7rJgxPzUMBSFkqROX8p0mAgM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	zohar@linux.ibm.com,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	sudeep.holla@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	noodles@meta.com,
	sebastianene@google.com,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH v2 2/4] tpm: tpm_crb_ffa: revert defered_probed when tpm_crb_ffa is built-in
Date: Wed, 22 Apr 2026 17:24:47 +0100
Message-Id: <20260422162449.1814615-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260422162449.1814615-1-yeoreum.yun@arm.com>
References: <20260422162449.1814615-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 746d9e9f62a6 ("tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when it's build_in")
probe tpm_crb_ffa forcefully when it's built-in to integrate with IMA.

However, as IMA init function is changed to late_initcall_sync level.
So, this change isn't required anymore.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 drivers/char/tpm/tpm_crb_ffa.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb_ffa.c b/drivers/char/tpm/tpm_crb_ffa.c
index 99f1c1e5644b..025c4d4b17ca 100644
--- a/drivers/char/tpm/tpm_crb_ffa.c
+++ b/drivers/char/tpm/tpm_crb_ffa.c
@@ -177,23 +177,13 @@ static int tpm_crb_ffa_to_linux_errno(int errno)
  */
 int tpm_crb_ffa_init(void)
 {
-	int ret = 0;
-
-	if (!IS_MODULE(CONFIG_TCG_ARM_CRB_FFA)) {
-		ret = ffa_register(&tpm_crb_ffa_driver);
-		if (ret) {
-			tpm_crb_ffa = ERR_PTR(-ENODEV);
-			return ret;
-		}
-	}
-
 	if (!tpm_crb_ffa)
-		ret = -ENOENT;
+		return -ENOENT;

 	if (IS_ERR_VALUE(tpm_crb_ffa))
-		ret = -ENODEV;
+		return -ENODEV;

-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_crb_ffa_init);

@@ -405,9 +395,7 @@ static struct ffa_driver tpm_crb_ffa_driver = {
 	.id_table = tpm_crb_ffa_device_id,
 };

-#ifdef MODULE
 module_ffa_driver(tpm_crb_ffa_driver);
-#endif

 MODULE_AUTHOR("Arm");
 MODULE_DESCRIPTION("TPM CRB FFA driver");
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


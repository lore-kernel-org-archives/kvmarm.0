Received: from the.earth.li (the.earth.li [93.93.131.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9BF36D500
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.93.131.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037075; cv=none; b=ZFTz4gh7KgFg2sWLgOjH9B7ein7pvacD9T6Vy7utaVz1ZWUOiHXn6VHiIk/iLOzh6QT/i2pPVeABJeShUQOKs0Ps1rNInIWn5vJWInwtUF1+akmG0rfGuILX9SHqF8mP8uKz8WL5+2jSrOIMlwAgv+IqRuEEZXiMH1dhH/0KFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037075; c=relaxed/simple;
	bh=6Y7kEvWLblX9b7Lo29A/5VKlmbFvHRCAoteZiBjYeAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9eIuAgb2URgpzJkeq8D0V4crR+27IrbnEUNJDTxKNqHs+1OKiVB1ZxQlc9//YUnapQZM4KAQg01u+FuR7E2B2ZSo0qAfjqR5uBEAaXDbucP2fsbDf9oyEJx6OOxkPInvZQQhMS88wMOGFLSyas0bgcm+Qo6uPo+3ceEla4Kh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li; spf=pass smtp.mailfrom=earth.li; dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b=HuVLe4A1; arc=none smtp.client-ip=93.93.131.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earth.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b="HuVLe4A1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
	s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MTLm+QnMa8LZcV3xohAT9xRe8rojyymgVoomkTLpaYs=; b=HuVLe4A1izdqdUfXiweSvrcwPM
	EZ7E77UWtaAyAGfUmxIohCyfZk9j3YvbBoN7i/7An0T/HXDJVaSal3VdDiCww4SUs3Z/tpRyPIXWA
	4fAFlbl+wPkJJdsucxLKh6G1uKDvLkzeDzIAjjw6ppq8XtgA341v+aoXiD2aHVge/oAJ2UeemaL9R
	Ygs79IRXUITnpHvcULJWMtfdWe4NF1wEMB6mZzadJKwRLoBdqDFoFINyaHaQM3T+Txal5gx7GtOmX
	E/s/VjcrCynf9yIPqsy66m5m79JTRAE9nIlaGankZ+OXBbf8NOWi5mIZ4zAeWpzR9THZdnaqt/Gp9
	aNMqR0DQ==;
Received: from noodles by the.earth.li with local (Exim 4.98.2)
	(envelope-from <noodles@earth.li>)
	id 1wGGWF-0000000555f-02gD;
	Fri, 24 Apr 2026 14:24:31 +0100
Date: Fri, 24 Apr 2026 14:24:30 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	jarkko@kernel.org, jgg@ziepe.ca, sudeep.holla@kernel.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com,
	sebastianene@google.com, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH v3 3/4] Revert "tpm: tpm_crb_ffa: try to probe
 tpm_crb_ffa when it's built-in"
Message-ID: <f8d6dcbeb5bf2d4316989d05dcaae20225774d51.1777036497.git.noodles@meta.com>
References: <cover.1777036497.git.noodles@meta.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777036497.git.noodles@meta.com>

From: Yeoreum Yun <yeoreum.yun@arm.com>

This reverts commit 746d9e9f62a6e8ba0eba2b83fc61cfe7fa8797ce.

Now that IMA will retry in the late_initcall_sync level if the TPM is
not available at first, this change is no longer required.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Jonathan McDowell <noodles@meta.com>
---
 drivers/char/tpm/tpm_crb_ffa.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb_ffa.c b/drivers/char/tpm/tpm_crb_ffa.c
index 99f1c1e5644b..05f19c0ebf82 100644
--- a/drivers/char/tpm/tpm_crb_ffa.c
+++ b/drivers/char/tpm/tpm_crb_ffa.c
@@ -123,7 +123,6 @@ struct tpm_crb_ffa {
 };
 
 static struct tpm_crb_ffa *tpm_crb_ffa;
-static struct ffa_driver tpm_crb_ffa_driver;
 
 static int tpm_crb_ffa_to_linux_errno(int errno)
 {
@@ -177,23 +176,13 @@ static int tpm_crb_ffa_to_linux_errno(int errno)
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
 
@@ -405,9 +394,7 @@ static struct ffa_driver tpm_crb_ffa_driver = {
 	.id_table = tpm_crb_ffa_device_id,
 };
 
-#ifdef MODULE
 module_ffa_driver(tpm_crb_ffa_driver);
-#endif
 
 MODULE_AUTHOR("Arm");
 MODULE_DESCRIPTION("TPM CRB FFA driver");
-- 
2.53.0


Received: from the.earth.li (the.earth.li [93.93.131.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC17388377
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.93.131.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037048; cv=none; b=ZM+AvHRqNQxALWef6T2t2kt+W2GrueNB4NAfhOqrKXSOjrr433Db4kKPcQTMv80vtei+TZWcYq0JpHNjzUHW43Z1DbdbKW2pJZV53h9gk486WpIZjNy5XndY5Vdg325SiDPPQDMHuAWriLW9uR9jLR3wmXabWrB02D+GjtmtImk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037048; c=relaxed/simple;
	bh=aVadvFnQupu3+YjXiN45iZ7eUGUZiORmeNoqMxI8+5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmvPvOWPLiQhJtZwMwQYMQa3tEL2dYXI/5oAIlajQ1fAzHbyZ6pvN5UbjXYC7gOUILqYXMxLaxVW6GNZqZZybOn3K6fSUU7ySy5aVjVDmY2oZ3v3KoCbTRCUUJ6mqhI8a6MAmmC1KcTz9WcPCkSJPKyw+AQ7sSdHze+shYMrn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li; spf=pass smtp.mailfrom=earth.li; dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b=LjSajm/L; arc=none smtp.client-ip=93.93.131.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=earth.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earth.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=earth.li header.i=@earth.li header.b="LjSajm/L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
	s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6dUscyZYadGP/u9WJSSSuXzFvgisXZewFczcAHjysNQ=; b=LjSajm/Lv1J/FIEsPkNqemQ0lr
	JJFDS8nLZIO94YyIh7OWBNGrSlWjeSmtNUZQkknrUVZq7gE0SnFxWN/dZmlDD5QiyI/dLzbze/k8b
	MNPROBK3V0WXzbMz5oWFEK8ogZ0ztwIUUQaYZ6VOJKTur2tdLsDhZ3WQIx3Kh0bEoII4eB5JpkgmX
	B6nfhnKJv4kysIQojZ/uPm/NTg0PLy80kFW5CSgaTgmo9sHz+x1Foh0Et+IYVGUEB2R2bPgpHviiM
	l7pULkqFsWeZlbn647tGJs1N07H4hsM5VGMeQ752exLP3MgQ64GVLFbFntFG7gUfmN62TvMP2Mn6I
	1xzVA0tw==;
Received: from noodles by the.earth.li with local (Exim 4.98.2)
	(envelope-from <noodles@earth.li>)
	id 1wGGVp-0000000553V-3BUk;
	Fri, 24 Apr 2026 14:24:05 +0100
Date: Fri, 24 Apr 2026 14:24:05 +0100
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
Subject: [RFC PATCH v3 1/4] lsm: Allow LSMs to register for
 late_initcall_sync init
Message-ID: <af480e33671b77da6555c1db8f6dea3c4fd4049d.1777036497.git.noodles@meta.com>
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

There are situations where LSMs have dependencies that might mean they
want to be initialised later in the boot process, to ensure those
dependencies are available. In particular there are some TPM setups (Arm
FF-A devices, SPI attached TPMs) required by IMA which are not
guaranteed to be initialised for regular initcall_late.

Add an initcall_late_sync option that can be used in these situations.

[noodles: Split out from actual IMA changes]
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Jonathan McDowell <noodles@meta.com>
---
 include/linux/lsm_hooks.h |  2 ++
 security/lsm_init.c       | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index d48bf0ad26f4..88fe105b7f00 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -166,6 +166,7 @@ enum lsm_order {
  * @initcall_fs: LSM callback for fs_initcall setup, optional
  * @initcall_device: LSM callback for device_initcall() setup, optional
  * @initcall_late: LSM callback for late_initcall() setup, optional
+ * @initcall_late_sync: LSM callback for late_initcall_sync() setup, optional
  */
 struct lsm_info {
 	const struct lsm_id *id;
@@ -181,6 +182,7 @@ struct lsm_info {
 	int (*initcall_fs)(void);
 	int (*initcall_device)(void);
 	int (*initcall_late)(void);
+	int (*initcall_late_sync)(void);
 };
 
 #define DEFINE_LSM(lsm)							\
diff --git a/security/lsm_init.c b/security/lsm_init.c
index 573e2a7250c4..4e5c59beb82a 100644
--- a/security/lsm_init.c
+++ b/security/lsm_init.c
@@ -547,13 +547,22 @@ device_initcall(security_initcall_device);
  * security_initcall_late - Run the LSM late initcalls
  */
 static int __init security_initcall_late(void)
+{
+	return lsm_initcall(late);
+}
+late_initcall(security_initcall_late);
+
+/**
+ * security_initcall_late_sync - Run the LSM late initcalls sync
+ */
+static int __init security_initcall_late_sync(void)
 {
 	int rc;
 
-	rc = lsm_initcall(late);
+	rc = lsm_initcall(late_sync);
 	lsm_pr_dbg("all enabled LSMs fully activated\n");
 	call_blocking_lsm_notifier(LSM_STARTED_ALL, NULL);
 
 	return rc;
 }
-late_initcall(security_initcall_late);
+late_initcall_sync(security_initcall_late_sync);
-- 
2.53.0


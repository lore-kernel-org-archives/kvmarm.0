Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4588137F75E
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776875109; cv=none; b=i6yIENcnrlg1dk50idN/3flU7YzRjE6+JgPUO02L5u/dHadJAgILe1HQoSw2ZYPWVufXrGgIgzC2GhTcc7Z3rZ0FSvPt/hcKo/LkjmnASBIkPo65BW8rVH6Q6RS05pwTPi36iJuG1GkKoF6dOeNUkRvSlQrfRbiHezBZLyH3ekE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776875109; c=relaxed/simple;
	bh=OznS5k+Y9tBwswJLbKpzM/l10Fd+kOv7XSaKZ/Nsp/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C6/N6ggC15BKlGct+hz70DaojY2FjKv/37l5vEQutTv7nhl3AwcBW6kgu1smIHLMPbXi0i7Opk/4osVNCvHBnxMU6232Dg9wKkrs8T4oQDJdvCSLBYcKIVkaBEzCF4iBMXfkYgNmbCO3oZ6BmLnDS+ERdPCCqsU++ZpQ+j8hvZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bzTVtfGr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bzTVtfGr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 205DB1F37;
	Wed, 22 Apr 2026 09:25:02 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E5013F23F;
	Wed, 22 Apr 2026 09:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776875107; bh=OznS5k+Y9tBwswJLbKpzM/l10Fd+kOv7XSaKZ/Nsp/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzTVtfGrgh+q1HyFQnBqATd+NWOiXVGKbY6NQxgybP/vyqhIv5ByWSbm9lfRGENC0
	 fSYA/lyhTzTz3EGMzvKH4rzhkwXNkM1IDkaQGw6s6ZxACKseghScFXtZDZJa4mJd3m
	 Wk5xtK8cywNdld7I98uuXIF0swLxZOeqWBz+okjY=
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
Subject: [RFC PATCH v2 3/4] firmware: arm_ffa: revert ffa_init() initcall level to device_initcall
Date: Wed, 22 Apr 2026 17:24:48 +0100
Message-Id: <20260422162449.1814615-4-yeoreum.yun@arm.com>
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

commit 0e0546eabcd6 ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall")
changed the initcall level of ffa_init() to rootfs_initcall to address
an issue where IMA could not properly recognize the TPM device.

However, this introduces a problem: pKVM fails to handle any FF-A calls
because it cannot trap the FFA_VERSION call invoked by ffa_init().

Since the IMA init function level has been changed to late_initcall_sync,
there is no longer a need to keep ffa_init() at rootfs_initcall.
Revert it back to device_initcall.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f2f94d4d533e..02c76ac1570b 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2106,7 +2106,7 @@ static int __init ffa_init(void)
 	kfree(drv_info);
 	return ret;
 }
-rootfs_initcall(ffa_init);
+device_initcall(ffa_init);

 static void __exit ffa_exit(void)
 {
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5103B774F;
	Tue, 29 Sep 2026 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720232; cv=none; b=bY2J8Bk1RHxUuPTyJVs+4gveFHacGsLBID7Xgb/N94yOgwWWdgCsB5JyhdIi9mvEwrnzlz9YiaEYntewJAE6gWOuFlSn3q1AJA0F9bytD+zQ67siXDtCi5mVNzRu6npyPu/vlFtiFAdvk7A1MKyiPOsNAxZWu+pS6nnGSbndwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720232; c=relaxed/simple;
	bh=bOPfrjZC9H0ZdpIC5yzFK/KuR63sWAw36xeTjbxYxb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/8OUvOGCvsWZrGPfQ7e7/aOrQWglWxGSBYbk2Wp5UH2rg+B1PiQifan3ywfDj6HOZQ/wpXXtmEvfKcd3pg3SQD7UL9uGvafCrrUq05rcXA3jCOR7Xjxv+ac6F/igfh7OL72t+ANoqZznL1Ca7EKMcRgDsTp1J15d9NRn0BfhCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BUJoILqN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BUJoILqN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCDD41516;
	Tue, 29 Sep 2026 15:17:01 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9CDEE3F85F;
	Tue, 29 Sep 2026 15:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790720225; bh=bOPfrjZC9H0ZdpIC5yzFK/KuR63sWAw36xeTjbxYxb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUJoILqN3MexnXVDG7eeaKD0yQYeZvc3vwl2HbjB5GMinIoytwhW1vHWq7FU++A2Q
	 o8URuWuBf1xW5Yz+NtSqt0ERv/pWm0TTqURBK3ChlxKETM1S7ZMlIgCoYrsnGEJGCa
	 QJPKxxJpk9bxqStQtA1vY503C6CQfSmatHAjX1rY=
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
Subject: [PATCH v20 7/9] arm64: Block hibernate and kexec while RMM is active
Date: Tue, 29 Sep 2026 23:16:21 +0100
Message-ID: <20260929221623.1342076-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929221623.1342076-1-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM can be deactivated only after all delegated granules have been
reclaimed. If a new kernel is entered while any granules remain in the
Realm PAS, accesses to that memory can raise a Granule Protection Fault
and be fatal to the new kernel.

Crash kexec/kdump needs separate handling. It can be supported only once
the crash kernel can tolerate delegated memory inherited from the primary
kernel. i.e., be able to read the pages safely and fixup the GPF. Until
then disable the kexec completely.

Hibernate has a similar problem. The image cannot be safely saved for
delegated pages, as the RMM doesn't support exporting the pages.

Disable both kexec and hiberation while the RMM is active.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - New patch to disable kexec and hibernation with RMM
---
 arch/arm64/kernel/hibernate.c     |  6 ++++++
 arch/arm64/kernel/machine_kexec.c | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 7bf1174277772..d02f01c17febf 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -10,6 +10,7 @@
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
  */
 #define pr_fmt(x) "hibernate: " x
+#include <linux/arm-rmi-cmds.h>
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
 #include <linux/pm.h>
@@ -341,6 +342,11 @@ int swsusp_arch_suspend(void)
 		return -EBUSY;
 	}
 
+	if (is_rmm_active()) {
+		pr_err("Can't hibernate: RMM is active.\n");
+		return -EBUSY;
+	}
+
 	flags = local_daif_save();
 
 	if (__cpu_suspend_enter(&state)) {
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 8f9bc2327dc85..48f343704cb54 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -6,6 +6,7 @@
  * Copyright (C) Huawei Futurewei Technologies.
  */
 
+#include <linux/arm-rmi-cmds.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
@@ -59,6 +60,16 @@ int machine_kexec_prepare(struct kimage *kimage)
 		return -EBUSY;
 	}
 
+	/*
+	 * We will be able to allow kdump to proceed, once we have the support
+	 * for handling GPF from vmcore accesses to delegated pages. Until then
+	 * block kexec completely.
+	 */
+	if (is_rmm_active()) {
+		pr_err("Can't kexec: RMM is active.\n");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
-- 
2.43.0


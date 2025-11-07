Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C12308F14
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 07:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500144; cv=none; b=Zf3UySVD/p/FT3q3mbPWg8ypIZ9GTh/PAiVSSp7fNc+dJxXBeh4qyWO3b+ECuyXBileN5A4RhqCm0fIlc8wEM1cR0ND/EkPPpQA1RalmjnHzmBLilrXualVMNb83Tp/IYRWrG4BVxc3oIPTh3HLgDK223E8TUrdLDvlbIDBuEwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500144; c=relaxed/simple;
	bh=5o3XUo6Ezb+trWaej0mil2wqYFEvwbs4zDjESVEhzQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8+E/ksqEV1HtWxYl5vJko7wWngodhRW4TV5vr52iYkuKsdDUleVl+wW+0pbozsOc+qbpYv6V0XQZdPAATpHlrikP057rIdDsLEYwxmpkivPrWeorPYjNaAOeSp2R8Ss6W8niTNLcapfipXpSOcy3eOtM4rOWOTQcYwYKg5sHAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4d2r7c184mzRhS1;
	Fri,  7 Nov 2025 15:20:44 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1544618048E;
	Fri,  7 Nov 2025 15:22:20 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Nov 2025 15:22:19 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 7 Nov
 2025 15:22:19 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v7 7/7] kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
Date: Fri, 7 Nov 2025 15:21:27 +0800
Message-ID: <20251107072127.448953-8-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20251107072127.448953-1-wangzhou1@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

Add tests for FEAT_{LS64, LS64_V}. Issue related instructions
if feature presents, no SIGILL should be received. When such
instructions operate on Device memory or non-cacheable memory,
we may received a SIGBUS during the test (w/o FEAT_LS64WB).
Just ignore it since we only tested whether the instruction
itself can be issued as expected on platforms declaring the
support of such features.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 79 +++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index 3b96d090c5eb..4d41ab10988f 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -11,6 +11,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/auxvec.h>
+#include <linux/compiler.h>
 #include <sys/auxv.h>
 #include <sys/prctl.h>
 #include <asm/hwcap.h>
@@ -595,6 +597,67 @@ static void lrcpc3_sigill(void)
 	              : "=r" (data0), "=r" (data1) : "r" (src) :);
 }
 
+static void ignore_signal(int sig, siginfo_t *info, void *context)
+{
+	ucontext_t *uc = context;
+
+	uc->uc_mcontext.pc += 4;
+}
+
+static void ls64_sigill(void)
+{
+	struct sigaction ign, old;
+	char src[64] __aligned(64) = { 1 };
+
+	/*
+	 * LS64, LS64_V require target memory to be Device/Non-cacheable (if
+	 * FEAT_LS64WB not supported) and the completer supports these
+	 * instructions, otherwise we'll receive a SIGBUS. Since we are only
+	 * testing the ABI here, so just ignore the SIGBUS and see if we can
+	 * execute the instructions without receiving a SIGILL. Restore the
+	 * handler of SIGBUS after this test.
+	 */
+	ign.sa_sigaction = ignore_signal;
+	ign.sa_flags = SA_SIGINFO | SA_RESTART;
+	sigemptyset(&ign.sa_mask);
+	sigaction(SIGBUS, &ign, &old);
+
+	register void *xn asm ("x8") = src;
+	register u64 xt_1 asm ("x0");
+
+	/* LD64B x0, [x8] */
+	asm volatile(".inst 0xf83fd100" : "=r" (xt_1) : "r" (xn)
+		     : "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+
+	/* ST64B x0, [x8] */
+	asm volatile(".inst 0xf83f9100" : : "r" (xt_1), "r" (xn)
+		     : "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+
+	sigaction(SIGBUS, &old, NULL);
+}
+
+static void ls64_v_sigill(void)
+{
+	struct sigaction ign, old;
+	char dst[64] __aligned(64);
+
+	/* See comment in ls64_sigill() */
+	ign.sa_sigaction = ignore_signal;
+	ign.sa_flags = SA_SIGINFO | SA_RESTART;
+	sigemptyset(&ign.sa_mask);
+	sigaction(SIGBUS, &ign, &old);
+
+	register void *xn asm ("x8") = dst;
+	register u64 xt_1 asm ("x0") = 1;
+	register u64 st   asm ("x9");
+
+	/* ST64BV x9, x0, [x8] */
+	asm volatile(".inst 0xf829b100" : "=r" (st) : "r" (xt_1), "r" (xn)
+		     : "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+
+	sigaction(SIGBUS, &old, NULL);
+}
+
 static const struct hwcap_data {
 	const char *name;
 	unsigned long at_hwcap;
@@ -1134,6 +1197,22 @@ static const struct hwcap_data {
 		.hwcap_bit = HWCAP3_MTE_STORE_ONLY,
 		.cpuinfo = "mtestoreonly",
 	},
+	{
+		.name = "LS64",
+		.at_hwcap = AT_HWCAP3,
+		.hwcap_bit = HWCAP3_LS64,
+		.cpuinfo = "ls64",
+		.sigill_fn = ls64_sigill,
+		.sigill_reliable = true,
+	},
+	{
+		.name = "LS64_V",
+		.at_hwcap = AT_HWCAP3,
+		.hwcap_bit = HWCAP3_LS64_V,
+		.cpuinfo = "ls64_v",
+		.sigill_fn = ls64_v_sigill,
+		.sigill_reliable = true,
+	},
 };
 
 typedef void (*sighandler_fn)(int, siginfo_t *, void *);
-- 
2.33.0


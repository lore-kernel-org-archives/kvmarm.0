Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBA922AE76
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124662; cv=none; b=rxngv+Q3RHevvbbbsZcWLzK2+zMwJzwpm3sbTttRApivfaDzubvvOpvTsdxtUIpaUBxeAMNgSeJLe/r9yQ7fiin2Cn9QyujKjhMacprT4tN9LH2pqNRpCBpJAwJkXgUeLTD7MXj0znavKjHK3rPgZbKooJVZXMma/uT953fIWDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124662; c=relaxed/simple;
	bh=Rjp056P2OdLCvufqkkEmjsvtBNLByuXOfSMzsCyRZJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ut2xbHWQk/STGIOZDQsMIgAys2utFiulCj5j3dsm1AhVU1hFsu3vCxIlOC9wACgLqCrRBTKAd5iichhGxnhXl1U3zoCnCqxEt5gekLTMsLsEPBdkxkDLWjxfAjxc5lr9Yl15dpvunLnQ1DCxMmfBsNrzipBBjrGe+kbhFZ9G6y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lUtDxkoT; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lUtDxkoT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744124656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fRzR0c+RICStf8RuRrhPa9rgJTPK8UD2IOzsKkxVSqs=;
	b=lUtDxkoTrxhL2z6C7EI9Oqqqxp9cvQy7f6WZ5iC6hg1NAyV+km6utGagy355J0xt+JuwN7
	B1lVFFZPzRwFP7gf5B4A0+o2k0nH+edVFeB/tHKpC/xstpWUviLaPmGKLCnTAFUWzk15o9
	eSilXuyP/xCyABiQkqdjcaxqyZ20PmY=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	jean-philippe@linaro.org
Subject: [kvm-unit-tests PATCH] arm/arm64: efi: Bump number of memregions
Date: Tue,  8 Apr 2025 17:04:14 +0200
Message-ID: <20250408150413.97104-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When using QEMU's 'max' cpu type additional EFI memory regions are
present. Just like riscv's commit f35fe0ee486a ("riscv: efi: Bump
number of memregions"), bump the number we allow to ensure we don't
hit the assert in memregions_add().

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index aaa0da9804a2..67b5db07ba8f 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -31,7 +31,7 @@
 #include "io.h"
 
 #define MAX_DT_MEM_REGIONS	16
-#define NR_EXTRA_MEM_REGIONS	64
+#define NR_EXTRA_MEM_REGIONS	128
 #define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
 extern unsigned long _text, _etext, _data, _edata;
-- 
2.49.0


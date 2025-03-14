Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FDE1FDA9C
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 22:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991684; cv=none; b=BVtZg3jdnbwdufmxFwDeOIH/WJnFrORgd0Z/wuGCv+V/EloYblnHjnjPQcwyz2yhnwYzMJTOS9rH+14ykqybBXA6G46Wb2CYkQfrU022/5JVVoRFBlJfSHBTx0fnhRYFPYm5AyC48rEOahml3HtT/jYLQ9sD3wLjQd3hRezg790=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991684; c=relaxed/simple;
	bh=YkBE+R1VVSZp4EncLclt4ejehkGCrSRhwdH1wa45hac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=noqAFBhqCou8/d3csgt+CtBDQhkcNoWS/LjvhTS345LGc9n12tzdZ3MabOUtdZ51U8lZzfbyGy9Z5qObb8KM5qEyZqcCBO/f5QC2GaQvNXeUTzCvKsuZh+BQWCXP4UfpyvALU96RPvV9V8H3LHYF0+FEVLA6EBIGDg7kNvN36L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rRSOIOOg; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRSOIOOg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n90LYD32wGwxy9sZNGX3ZFLbxYAdTrVLyhAUrdrGPmg=;
	b=rRSOIOOgHtVo7OEdFX5LSf3MJTBde+Up3+ps735RAaqu9lDNbhzN7NkuXyNOkV271wkPfO
	RwGVOqMcstjzgihVcQdC+0k63ZFnUtWLsthcOdiEwaGC808ITxo+EXrig7+VMo3Qe9voBQ
	D2/6qNMn7cnQbXaKMYFrcMsgDURSGYo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 9/9] arm64: Get rid of the 'arm-common' include directory
Date: Fri, 14 Mar 2025 15:25:16 -0700
Message-Id: <20250314222516.1302429-10-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm64/arm-cpu.c                        | 4 ++--
 arm64/fdt.c                            | 4 ++--
 arm64/gic.c                            | 2 +-
 arm64/gicv2m.c                         | 2 +-
 arm64/include/{arm-common => }/gic.h   | 0
 arm64/include/kvm/kvm-arch.h           | 2 +-
 arm64/include/{arm-common => }/pci.h   | 0
 arm64/include/{arm-common => }/timer.h | 0
 arm64/kvm.c                            | 2 +-
 arm64/pci.c                            | 4 ++--
 arm64/pmu.c                            | 2 +-
 arm64/timer.c                          | 4 ++--
 12 files changed, 13 insertions(+), 13 deletions(-)
 rename arm64/include/{arm-common => }/gic.h (100%)
 rename arm64/include/{arm-common => }/pci.h (100%)
 rename arm64/include/{arm-common => }/timer.h (100%)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index f5c8e1e..b9ca814 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -3,8 +3,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
+#include "gic.h"
+#include "timer.h"
 
 #include "asm/pmu.h"
 
diff --git a/arm64/fdt.c b/arm64/fdt.c
index 286ccad..9d93551 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -4,8 +4,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/virtio-mmio.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/pci.h"
+#include "gic.h"
+#include "pci.h"
 
 #include <stdbool.h>
 
diff --git a/arm64/gic.c b/arm64/gic.c
index 0795e95..d0d8543 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -3,7 +3,7 @@
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
diff --git a/arm64/gicv2m.c b/arm64/gicv2m.c
index b47ada8..e4e7dc8 100644
--- a/arm64/gicv2m.c
+++ b/arm64/gicv2m.c
@@ -5,7 +5,7 @@
 #include "kvm/kvm.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #define GICV2M_MSI_TYPER	0x008
 #define GICV2M_MSI_SETSPI	0x040
diff --git a/arm64/include/arm-common/gic.h b/arm64/include/gic.h
similarity index 100%
rename from arm64/include/arm-common/gic.h
rename to arm64/include/gic.h
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index b55b3bf..a9872a8 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -10,7 +10,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 /*
  * The memory map used for ARM guests (not to scale):
diff --git a/arm64/include/arm-common/pci.h b/arm64/include/pci.h
similarity index 100%
rename from arm64/include/arm-common/pci.h
rename to arm64/include/pci.h
diff --git a/arm64/include/arm-common/timer.h b/arm64/include/timer.h
similarity index 100%
rename from arm64/include/arm-common/timer.h
rename to arm64/include/timer.h
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 5e7fe77..6ee4c1d 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -5,7 +5,7 @@
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
diff --git a/arm64/pci.c b/arm64/pci.c
index 5bd82d4..99bf887 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -5,8 +5,8 @@
 #include "kvm/pci.h"
 #include "kvm/util.h"
 
-#include "arm-common/pci.h"
-#include "arm-common/gic.h"
+#include "pci.h"
+#include "gic.h"
 
 /*
  * An entry in the interrupt-map table looks like:
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5ed4979..52f4256 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -9,7 +9,7 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
+#include "gic.h"
 
 #include "asm/pmu.h"
 
diff --git a/arm64/timer.c b/arm64/timer.c
index 6acc50e..b3164f8 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -3,8 +3,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/util.h"
 
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
+#include "gic.h"
+#include "timer.h"
 
 void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
 {
-- 
2.39.5


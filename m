Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9483C0A1D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509749; cv=none; b=I/eR/5QfZlY6S0VBgvYXpzk8PshllB0UAbkKhgzK9v2tyNPqNVAuzCLd9GedmH5fBhMD3M39beNvlKMf/8bNrLQ4ol/S6N2Jku70yL37MfM4BVjViyYZdCtPVAXPXDj1Nf8YMb9jnZ0tnM6ui/nsySmrB/3Az+r4mYc/o+HF+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509749; c=relaxed/simple;
	bh=SROkhbh6/bZDK8vpbuJbeyr6/QiF+pI9lfh9kvOCqug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GPAcNTjTUPXuJV2gX/skxPZEPLAhpYOIJwkUC3q0nkL/TMqaOOClD8GBUyTUk+vAr+JBDTFmLtCoTM0JkM6Tv/XDOzbvio1/FypubNGp9Wg2DOSMt+9hCtwheUqOhl/ihFZmK8YDxV/rjiq0xmLi4miAJdJHhM95E01cAPTa2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ScJjUk0O; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScJjUk0O"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8423f3e4728so843915b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509746; x=1783114546; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pnTbJ0qzupqs+OdQTBbFmTptoXz92YWWt6sTMLKlVlM=;
        b=ScJjUk0OS57HQo3VXuNcsDXxz7aBieZfgtgyQ7v1B2Lhw1P8ob12HptHIgybWhuxRp
         9fsuaL/8rC+oKCU5cwA5QYvnqFKZjOt4asTFVgxEtt6bXv4woIinZZjPy5NrUeZqySWB
         Jnu/cBLR2nUF1q2txOY3GfahxvQTrxhSBonkkOQEzzwwLm1IsjyrW9Lhse1NWxNCw7eG
         Pn1wdKmefyNcMun9YPAGG68PbHE6UqSYZ6VWk36joqyWp929qEj39iHnPctdCK41jvOw
         w5uMWds53+BJw7zjMP04jPldrLmewqgqOEyr0qgmtAWEd27jC4DB9xgd6R9sXv7trIP2
         /YPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509746; x=1783114546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnTbJ0qzupqs+OdQTBbFmTptoXz92YWWt6sTMLKlVlM=;
        b=cbDJ4eujIC7ChHqyIR4vaa3GbR26iVHzxfDOfgRpLUEYamf/L19Dr0whHc4oN9Tmt2
         T/LudlCF0FQ51IkyXTUxyPCqLNX3+DP+S6btxfaiA7aNdoRASJbmBFPo7SPvBtUYOa9a
         dcJsQzcWpIGOUObuDAwPfvU/bg0+E30Q4opOLXaWa2/XopkC8X6IJ3hPQSf4xUWUx79a
         O0aiKg/22AuXLDYmSnSQOQsI4JyXXCEzZHBYDIr/O51nTtjkIDvUuQezWrTNC10tWfyK
         E4yvzE5D/JKDK3vbxN5E0R6qSzEBJjUXFOjdJ75WWiS7J8kEXznuaX4d+I4Yy5m0TuSD
         MK7A==
X-Forwarded-Encrypted: i=1; AHgh+RpTsZf/6+l0xuV5ktkKtczUZc5qoCbA+sR7BPH/GZESnrgto5ROpTyvXeiF1Sb0bUG5l/Ts33M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxeUEN8aa21CUii2IDNLV2GERAwf9uRVA9W4zguWbE1HnAPZoW
	bCF82RFwTYN31BeBdgwsF7RPEjc1nqBwP7u8Su6bmTUozi1C8lw42FUhRfEiRfKHQozuk99poj3
	Xy6OIKQ==
X-Received: from pfbhx20.prod.google.com ([2002:a05:6a00:8994:b0:842:7548:51e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:66c6:b0:845:ba0d:3e5c
 with SMTP id d2e1a72fcca58-845ba0d45cfmr6880920b3a.42.1782509746265; Fri, 26
 Jun 2026 14:35:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:21 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-9-seanjc@google.com>
Subject: [PATCH v8 08/20] KVM: selftests: Add helper to get host IRQ from
 device MSI-X for IRQ bypass test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Introduce proc_util.c and proc_util.h to house utility functions for
interacting with the proc filesystem.

Add vfio_msix_to_host_irq(), which parses /proc/interrupts, to get the host
Linux IRQ for a given VFIO device BDF and MSI-X vector.

This helper will be used by the eventfd IRQ test to print the host IRQ
number when triggering IRQs via VFIO device, e.g. to aid in debugging if
the test fails.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/include/proc_util.h |  9 +++++
 tools/testing/selftests/kvm/lib/proc_util.c   | 40 +++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/proc_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/proc_util.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index a24875fada03..88c6c8046dde 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -11,6 +11,7 @@ LIBKVM += lib/kvm_util.c
 LIBKVM += lib/lru_gen_util.c
 LIBKVM += lib/memstress.c
 LIBKVM += lib/guest_sprintf.c
+LIBKVM += lib/proc_util.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
diff --git a/tools/testing/selftests/kvm/include/proc_util.h b/tools/testing/selftests/kvm/include/proc_util.h
new file mode 100644
index 000000000000..704839b6d7af
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/proc_util.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_PROC_UTIL_H
+#define SELFTEST_KVM_PROC_UTIL_H
+
+#include <stdint.h>
+
+unsigned int vfio_msix_to_host_irq(const char *vfio_device_bdf, int msix);
+
+#endif /* SELFTEST_KVM_PROC_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/proc_util.c b/tools/testing/selftests/kvm/lib/proc_util.c
new file mode 100644
index 000000000000..84d30f055a0a
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/proc_util.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "kvm_util.h"
+#include "test_util.h"
+#include "proc_util.h"
+
+static FILE *open_proc_interrupts(void)
+{
+	FILE *fp;
+
+	fp = fopen("/proc/interrupts", "r");
+	TEST_ASSERT(fp, "fopen(/proc/interrupts) failed");
+
+	return fp;
+}
+
+unsigned int vfio_msix_to_host_irq(const char *device_bdf, int msix)
+{
+	char search_string[64];
+	char line[4096];
+	int irq = -1;
+	FILE *fp;
+
+	fp = open_proc_interrupts();
+
+	snprintf(search_string, sizeof(search_string), "vfio-msix[%d]", msix);
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (strstr(line, device_bdf) && strstr(line, search_string)) {
+			TEST_ASSERT_EQ(1, sscanf(line, "%d:", &irq));
+			break;
+		}
+	}
+
+	fclose(fp);
+
+	TEST_ASSERT(irq != -1, "Failed to locate IRQ for %s %s", device_bdf,
+		    search_string);
+	return (unsigned int)irq;
+}
+
-- 
2.55.0.rc0.799.gd6f94ed593-goog


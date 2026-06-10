Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC55246770
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052831; cv=none; b=XhCyLqLRRkLQNZCtn750pgWrcy73BxfHZ70kpgITnHnJWymovblW2DbfGSQiYNSSCtjCo8tqnZinbAo23j3oe3Ebn443NgB6rG/D72jo6aD//PQV55eGX6Km2F/d8cIJeLQOxxN8l/9/TdlzZ0x8SQ+At1saN14wYNSvovVwGlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052831; c=relaxed/simple;
	bh=zND3vvwQyaPgYriOhaRZZgPXLGs7NEXIBc9VDNPOrfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JDGs1PK1YMzQxPOS0WJj8MrkgMXghnhtxLPHkFgLG3/BYcGhfrNi9RCvJg6X++MtlAPABgtWuotIXrg4xbk/+lizh2/kfENRt63+LwPY0fZAgdroVJEwuv/+y2ppT/tOiYp9Wfs2yecaH8t5pj+5EaMdCsj04dnsXFutzDcvXN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qK/7zImV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qK/7zImV"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8428384f31fso4341380b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052830; x=1781657630; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=724RgwNGECYZAQrR7huttJyeJ2iqdlEoMMuWqlZB/zc=;
        b=qK/7zImVw/SNXQWJ+BU8b7s/tgDn/YbnCxLcq+OgOC5kBdbKvXGijN9EEPzSt8xukh
         545m2lQlOQ/7/PqNYFOGgRAVL3AisMZxXH9HTo/IGVKMnsdNa5r+T+2TTuG1bMnyMUAq
         KsG4RpR8Ml6nqbb8oCNjHjOSP+9deS+KdZYS3v5DJmVB7Cl/ryvKCGUp+aPzYPw8MBcJ
         oWiX7/6jAfG1osrnjRPWDCUCOX7xMnWwvSfIxwtnNSyxMPWH+N66m/zUOGuSeOCj1zZi
         tlxKCx6570AQzKBiFZGXklILH4IbEO+QebGoqTE0hOhw2CTNm09kjdAKPUr+XL+qCj5S
         mltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052830; x=1781657630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=724RgwNGECYZAQrR7huttJyeJ2iqdlEoMMuWqlZB/zc=;
        b=lwBKWWxtOp3mFedqdKOKr6HGzx3Ob9owzE+MFJgY+yznWxQKF/xNbo+o33ki/iafS8
         Rln6+Qch5lcqX5nK1OP8ZrY7qzoz8NM5PofkQc0mqmcao9lQrUTq9HrfC2i2AiriQfEj
         lAQoK4HjxF6waDyqsiT41+xPYk6GSNIZWk/y8ZwmMDHfJwBjufVyogryzsBlHVFjy9wK
         qxvNTdvfs06qcsW5o+vW2HpRPvB+W5cb5P/fFauyWh0LPq8LrTdS0S5aKilDGA3GXbdC
         /Yo7JbMaZARCuivNVCBsFXKa0KoQtTZIu0sbqumuZD0dGM4gsV29n2wcO9HCLnIiqoij
         zWtQ==
X-Forwarded-Encrypted: i=1; AFNElJ/unh8FQo2+GFUo07HKaPxWcI3DDxvjeLO7nwcyYQrtIMYvH4vlOkwpPOJ8uJAgOaQurpm6HI4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhmmwiJlWMZPOVU4xEB0xduPh+tT5AgTHfC3P6rmRJJrQVJuvw
	/Skh3ZXdv6TrI5a2uSDxXSzY8sdP8kUD6HJdQ4iX75Ew1YGsFmk+Fk8A+esZO5D0WfrUfh87G1f
	KwIF32Q==
X-Received: from pfw3.prod.google.com ([2002:a05:6a00:a263:b0:82f:4d28:b8c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4390:b0:82c:d7c4:4c57
 with SMTP id d2e1a72fcca58-842b0e73596mr23804989b3a.19.1781052829531; Tue, 09
 Jun 2026 17:53:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:26 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-7-seanjc@google.com>
Subject: [PATCH v6 06/18] KVM: selftests: Add helper to get host IRQ from
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
index 1339228cbf53..90a370ed99f2 100644
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
2.54.0.1099.g489fc7bff1-goog


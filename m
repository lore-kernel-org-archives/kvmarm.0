Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1712A23D7F0
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310046; cv=none; b=alb/9V1nRoIZOunoG4Id4jL6988B3EofY6s6vpiF0d1dPzeL+jvXkl894iFRTGxOh4pBMTwwAqpXGOC1yrNmIqSt/19mFwo9jgBv4sVW6DtxDUUQRAHev4oUtnJo+DTL/oCPCCzzHXNw1oZuegNGQ68ZbNOc8bK6iPfZ1Xk0Gro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310046; c=relaxed/simple;
	bh=V+fai80fvGy6xNbMhzBzclZirnMI9czJqjJ8MXI2MX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b9o7I4CkhRf4JbELVshD0CeU6p6FE6uLd1oJqFlkzATNLeMCs7ORR/M6p5m0CHgCecYW306EJHb4AxNf2GI+6jS8AONKKf8ehzZ8EIOmaOW6TWoKjxaJWsgcYPn2/AhKRlCn35U7gNpDtdwgAuMLVOprf/riRAoL/ZL/WSBbAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qBNm3tja; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qBNm3tja"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf160f7191so10029695ad.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310044; x=1781914844; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3qRbqYxE/FHHRGIPHLP62KGhWo8UkYosmytEIIXQZ9U=;
        b=qBNm3tjaED82yTIP4umuFl6NotdnT7abE2h2qUmZf+pIsERTOXoUJywyAWG463Z5Yz
         0P1VDf/xDvBxurnwI64PY3nics9VBdqQ/6TUnHAK4/8kDLx/BnewY4draejHEjIHfi2V
         jvH9QOH7b+Qs41ri74w6rpBezjjxWT/cFArGE+1GUk4uROy+gebEZjb2rEj8AI3zY70o
         C2wuAnbHTM2lezEIVPjxS1ZWmWIE924C+sCtbsdLNTV+P6Ua/Chi9Y8FSrbeAurXeF2g
         7TbV34arkx2YgoKZ2kbVexQSjQl1gsNwQW5XDFr37tQ5fHGLzaJJW5hyZsaK80k943fT
         tDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310044; x=1781914844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3qRbqYxE/FHHRGIPHLP62KGhWo8UkYosmytEIIXQZ9U=;
        b=jRf8xKqnOkDNdLM8r8uLETXMZ3YIXI/GqY6Kio+njawr+Emw4Bpi4X6pJJ7xnqDooD
         Umcx3qEYFF21T343QzP99jloN4Wi2nUHqFxmZ9xJWkqUw0PukLpsi6ToCbsnnQjv1kk9
         D/DN3G7PZfQhb/gFZnnIn8pv4Om5FIqzzJWleVYN1n9Szf5VbWEIa6pJNJ7nCW3Xfa8y
         HY0bOUJrobhlu6DL2UEE3f69gIu0x2ypsEgSyQtnn67fpOUYOaRx2l9Kv3GKRzNeT1D3
         6cEAQbMh2tn2hoUzI51tQ53sfWdk22qkTyRGpWpc84EwfclBgDSt46HOKg3+He1BYZAq
         jVFA==
X-Forwarded-Encrypted: i=1; AFNElJ9pr5G4GJEzQ0X4xaYj/Sku/jWr0KrVNd/ekn59XIGMjNHRvlSogvsry41hIFJjD97rQpnZghI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3w2sis86cw/vvueDEa66ZUiMwuM1b5QVujIUDkyaQ8cJVYJAd
	qnzbPvRHawZgEwj/VFIDUWiSGriyt0RfezZuICtmMBhNY9FpLt1d7TEzEx3ohZS77qiypOC+JYd
	b54nNsQ==
X-Received: from plrx19.prod.google.com ([2002:a17:902:b413:b0:2bd:3dba:a4c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:acb:b0:2c0:a746:7b16
 with SMTP id d9443c01a7336-2c6641e3058mr18450205ad.22.1781310044254; Fri, 12
 Jun 2026 17:20:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:19 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-9-seanjc@google.com>
Subject: [PATCH v7 08/20] KVM: selftests: Add helper to get host IRQ from
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
index de5f6e91203b..c112cedd3a2a 100644
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
2.54.0.1136.gdb2ca164c4-goog


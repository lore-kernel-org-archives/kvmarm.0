Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C699468
	for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 23:07:52 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-666e6541c98so2710878b3a.2
        for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734472; x=1690326472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21SpjF+xBmEu7QPQNtztE4cG4YYUJTEjHrp9rj09zZA=;
        b=mYKRtXtslrTwwqDTD/ejgHiqY78Bg3f0Ow86sGs6aIrEeLpYfPezvuDIh78Jlg8dbb
         dpGgzXCTTictLDtnIsHyiSWMfFM+/RoLRRIvrYNCulZ6FJnVbg+tsHpuaxPkMjbsjVcx
         ob74xAx+pweCRjtsPaF/4dQlHbjlZCIDJP+rUSeVBy1V+zM7maAED2cQtj2ToZnitM6x
         qr8ToXU/jiSmQGv6eyCbzXzlkfPbb0wqNg2PTjVKm+SEq8DPJ7lQ5ns++UOonYtp4eA1
         vd9dOx2U6CPxTc5K6QcasCO2Ote5f30zpJ1Nl0OW5jv+rfJnoOIjgQC6tL6NSW1mnhxz
         5vLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734472; x=1690326472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21SpjF+xBmEu7QPQNtztE4cG4YYUJTEjHrp9rj09zZA=;
        b=aA6yCsvTggDvSaQsqTlvZZaOHV2czR1C/0EKxXRLqq/YDXTvwOJKxnX8T4ANjEnGFj
         Te1WoPuxoub2YmN5cez2VCjpU1tqbYrdSrUO676eT7CJ2ai0mO07WwRfdOsIdgGjwbba
         m1ZHdM1btINBS852iAQnHP5kxWRhGYzL0vNK3Bko0UQIml5HUTtY8uLNksROS3HZT+nH
         7+JPFyGFKLJ7M5YV2vwPuRAfJoMTasq4d2dT3isnQAjsxDeGNxZBo1DHItvOq30skEjJ
         xuf61g4euQbJSwYgv54fhu7efAmDMqQ7SuAOYx/1SjSnTd3WO8lqnV15+OtbucB9OCcL
         vXHA==
X-Gm-Message-State: AC+VfDyxHWL0sXfdW8BaeOCa0LWKfMjLSVM8Jij20EbXn9c1pDcrtyNp
	sbnRKWrPQgvtEqWUIStMMe7CUtMOnzk=
X-Google-Smtp-Source: ACHHUZ4g4Mp3PlNC3YacyCrfQUvV+O+hcyfuZIxxGIcHCdWEgNp471z0bfFiNEcrbg19bvWen6IgdA==
X-Received: by 2002:a05:6a20:3d81:b0:107:35ed:28a7 with SMTP id s1-20020a056a203d8100b0010735ed28a7mr36176837pzi.8.1687734471696;
        Sun, 25 Jun 2023 16:07:51 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:51 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 3/6] arm64: enable frame pointer and support stack unwinding
Date: Sun, 25 Jun 2023 23:07:13 +0000
Message-Id: <20230625230716.2922-4-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Enable frame pointers for arm64 and perform stack unwinding based on
arm64 convention.

Signed-off-by: Nadav Amit <namit@vmware.com>

---
v1->v2:
* Adding SPDX [checkpatch]
* Moving some unused declarations to next patch [Andrew]
* Adding recursion prevention
---
 arm/Makefile.arm      |  3 ---
 arm/Makefile.arm64    |  1 +
 arm/Makefile.common   |  3 +++
 lib/arm64/asm/stack.h |  3 +++
 lib/arm64/stack.c     | 44 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 3 deletions(-)
 create mode 100644 lib/arm64/stack.c

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 2ce00f5..7fd39f3 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -11,9 +11,6 @@ ifeq ($(CONFIG_EFI),y)
 $(error Cannot build arm32 tests as EFI apps)
 endif
 
-# stack.o relies on frame pointers.
-KEEP_FRAME_POINTER := y
-
 CFLAGS += $(machine)
 CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index eada7f9..60385e2 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -21,6 +21,7 @@ define arch_elf_check =
 endef
 
 cstart.o = $(TEST_DIR)/cstart64.o
+cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 9b45a8f..bc86e44 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -22,6 +22,9 @@ $(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
 ##################################################################
 AUXFLAGS ?= 0x0
 
+# stack.o relies on frame pointers.
+KEEP_FRAME_POINTER := y
+
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
diff --git a/lib/arm64/asm/stack.h b/lib/arm64/asm/stack.h
index d000624..be486cf 100644
--- a/lib/arm64/asm/stack.h
+++ b/lib/arm64/asm/stack.h
@@ -5,4 +5,7 @@
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
 #endif
 
+#define HAVE_ARCH_BACKTRACE_FRAME
+#define HAVE_ARCH_BACKTRACE
+
 #endif
diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
new file mode 100644
index 0000000..a2024e8
--- /dev/null
+++ b/lib/arm64/stack.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Backtrace support.
+ */
+#include <libcflat.h>
+#include <stdbool.h>
+#include <stack.h>
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+{
+	const void *fp = frame;
+	static bool walking;
+	void *lr;
+	int depth;
+
+	if (walking) {
+		printf("RECURSIVE STACK WALK!!!\n");
+		return 0;
+	}
+	walking = true;
+
+	/*
+	 * ARM64 stack grows down. fp points to the previous fp on the stack,
+	 * and lr is just above it
+	 */
+	for (depth = 0; fp && depth < max_depth; ++depth) {
+
+		asm volatile ("ldp %0, %1, [%2]"
+				  : "=r" (fp), "=r" (lr)
+				  : "r" (fp)
+				  : );
+
+		return_addrs[depth] = lr;
+	}
+
+	walking = false;
+	return depth;
+}
+
+int backtrace(const void **return_addrs, int max_depth)
+{
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
+}
-- 
2.34.1


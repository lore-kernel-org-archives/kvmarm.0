Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF478199A4
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NNxIl0T8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-28c0536806fso756985a91.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253130; x=1703857930; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeAYbCIRliGvqtaXOLpF2rqcgjxtp1a4iDArca+1VrE=;
        b=NNxIl0T8H+eZX9hkveyXMy30FFfDJtdvhLDIt9rXGy1PJz6FlihXj9NTE9386xmVK/
         iSkFt7lKzrZWm1G697oFgmmlN15MOO2cpdTj8hVgKKayzxaE6v6oUORUNmdA3IwrpK7I
         rmxelaJQs4+tvltfp2+xt52omMo9dHYVy6eobWY2U7n3i6l2vczmwDo4+JQYAyH310n6
         JYHxSSWAYRTMVADLlob6neSbovX2pVsaQ9CrmFgFc6/MizCHINvJLn36Y7AWSRPVzs+K
         qGzGAQQPCG2uwVwNTCnwRNY0pwczjIvwpZJJ3ZD/ynFWa3B9nknJjaVN9tDEcVlCGlLv
         gihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253130; x=1703857930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeAYbCIRliGvqtaXOLpF2rqcgjxtp1a4iDArca+1VrE=;
        b=n+q5pkoUwwOr2H6InIgAI4HI9OjzXGrGu1Qt3TSbKE3zu9y7s3iUht68eN4Ku2z8+F
         F2hQ9A4QimePdShHcoV1rLO9U2abFG/emyqmeK22TBFZKqANi/631QHHn7TXxAf5XH5g
         8/xbIqx7xQ0GhKS8B3mLEWLJxKco4HJCtoR3gP2jk0xxduZ3k55Gae9gzyDZ0peqi+yA
         zPtpsTiHWr3KeyyG0WSJPHvT3OHWFG9LV8ODRKdHgfgVpmsrOXtgOFCa8Upg9VstAjZe
         VCLr0VQItzsH9S1cWpvteaDv1I/f6tLHDz2n3Irxlpjujdq2LiaGT9ieEVGn3daVje8l
         ilGg==
X-Gm-Message-State: AOJu0YyoPHpLy8iaVoefIzS548qHfWuWbBpuedo0YqXuw/qy8G926v02
	uxXoflgnWe9VGLleA6ouwxk=
X-Google-Smtp-Source: AGHT+IExjN9duiOKRKviSE2m6Rk3lPcZdwg4mh/5940CTeHG0yd/WEEfRjEKyjHpXFhQ5zZy8GD3fg==
X-Received: by 2002:a17:90a:9d8b:b0:28c:1eff:ac4a with SMTP id k11-20020a17090a9d8b00b0028c1effac4amr143403pjp.90.1703253130457;
        Fri, 22 Dec 2023 05:52:10 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:52:10 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 9/9] migration: add a migration selftest
Date: Fri, 22 Dec 2023 23:50:48 +1000
Message-ID: <20231222135048.1924672-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for migration support in  guest library and test harness
code. It performs migrations a tight loop to irritate races, and has
flushed out several bugs in developing in the complicated test harness
migration code already.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/Makefile.common         |  1 +
 arm/unittests.cfg           |  6 ++++++
 common/selftest-migration.c | 34 ++++++++++++++++++++++++++++++++++
 powerpc/Makefile.common     |  1 +
 powerpc/unittests.cfg       |  4 ++++
 s390x/Makefile              |  1 +
 s390x/unittests.cfg         |  4 ++++
 7 files changed, 51 insertions(+)
 create mode 100644 common/selftest-migration.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5214c8ac..d769ae52 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -5,6 +5,7 @@
 #
 
 tests-common  = $(TEST_DIR)/selftest.$(exe)
+tests-common += $(TEST_DIR)/selftest-migration.$(exe)
 tests-common += $(TEST_DIR)/spinlock-test.$(exe)
 tests-common += $(TEST_DIR)/pci-test.$(exe)
 tests-common += $(TEST_DIR)/pmu.$(exe)
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fe601cbb..1ffd9a82 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -55,6 +55,12 @@ smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
 
+# Test migration
+[selftest-migration]
+file = selftest-migration.flat
+groups = selftest migration
+
+arch = arm64
 # Test PCI emulation
 [pci-test]
 file = pci-test.flat
diff --git a/common/selftest-migration.c b/common/selftest-migration.c
new file mode 100644
index 00000000..f70c505f
--- /dev/null
+++ b/common/selftest-migration.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Machine independent migration tests
+ *
+ * This is just a very simple test that is intended to stress the migration
+ * support in the test harness. This could be expanded to test more guest
+ * library code, but architecture-specific tests should be used to test
+ * migration of tricky machine state.
+ */
+#include <libcflat.h>
+#include <migrate.h>
+
+#if defined(__arm__) || defined(__aarch64__)
+/* arm can only call getchar 15 times */
+#define NR_MIGRATIONS 15
+#else
+#define NR_MIGRATIONS 100
+#endif
+
+int main(int argc, char **argv)
+{
+	int i = 0;
+
+	report_prefix_push("migration");
+
+	for (i = 0; i < NR_MIGRATIONS; i++)
+		migrate_quiet();
+
+	report(true, "simple harness stress test");
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index f8f47490..0d1a65f7 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -6,6 +6,7 @@
 
 tests-common = \
 	$(TEST_DIR)/selftest.elf \
+	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e71140aa..7ce57de0 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -36,6 +36,10 @@ smp = 2
 extra_params = -m 256 -append 'setup smp=2 mem=256'
 groups = selftest
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/Makefile b/s390x/Makefile
index 95ef9533..505e5d32 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -1,4 +1,5 @@
 tests = $(TEST_DIR)/selftest.elf
+tests += $(TEST_DIR)/selftest-migration.elf
 tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6e..a7ad522c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -24,6 +24,10 @@ groups = selftest
 # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [intercept]
 file = intercept.elf
 
-- 
2.42.0


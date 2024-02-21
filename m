Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C517D2E632
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486160; cv=none; b=QPGOajXC7kTSmhpqvJiYeu83BwORV6Q3DxFAWTVOHh4mBUAOBqj7+RLkr33t9uxQEna2ZEmrN5SD0DrQNiqcRmv8OEE0aG31gLgBKCIJZ3TGiR2ZKjjdslg0VNiXjtU6SxmTVEFVdoyaqdsyf9JfO1OLJmDNSPfxdazR3hR6VIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486160; c=relaxed/simple;
	bh=MEerVrBTKNNzcjobYPP0RyiwtXU/Fqyl+6g7hmECOc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDsCl70nA75HcZGtdsKaQUeTyllqRv3E60pFppwfiDJMEPh6sywvyc/DgaMfJL/ig82uRNhr1yJXAZFfMgpfaiAIb6YKjcQqeLlpVJgGOL+IeVGA8OwxwAHsU5zxKb2FJdtZbjOr2NoxD6EmAF0SRNygZlcK0LSSf2nnO4Piclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5kVQPCW; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5kVQPCW"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e46e07ff07so1734701b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486158; x=1709090958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKTDdfNq5MGrQ+0iUWX57avIL8YHWFp0YDpAZCY+Suc=;
        b=P5kVQPCWzdm5hnA1OdPMNQY2A3+jgE/EhHpBbFm532YkbZzhGxKAGivJvMhryV2t0w
         OfBbj2XwkBZw/2CxgTZvLEb2ewucwAaPY7gXOUqlmI72/rKDuzg3/vCNYLIWnTcUfrPC
         IUx+q0R5q3tXAb6S6XgsB8kwvuMI8P32yeFl0vlduXl7ksO5t95nEjczJ4YmXrJuigf1
         +n4tpUc5+Jp3u28/GycRuin/ph9tUFwiHQ9fBuiNsdyz7vtf2xolXBR8WTnK4TSNYZal
         W+kJ4hGsNvKbpGRnMqXMFc0FISwTh0ySUpEvTgaSG8bhWthJnG4CAUgC4B8dkXId5WbH
         UaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486158; x=1709090958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKTDdfNq5MGrQ+0iUWX57avIL8YHWFp0YDpAZCY+Suc=;
        b=rgw7pf3SSk1nR/damwgsVfwOMeMqSlKTZbZHMCDkzBsjfCmqklu4TCsBk9N8Rd8sor
         VlIA3HpOk9JJTQRW+q3Fj5ooHm3whkH4yOKbpLf06U/sc7D1E4cFxpmoMfRwRP49Uvt/
         BE80Ax3+KlESLJgSTXHquW3/YDDCY5GPOdErOuXOA4XeJxPuTNTjhfIWDLV4V6giwvvn
         +lUPLB90oFBPZ7dDLzMK/dPr7swhbRC63j1qAdwP49Cnndr7AKkESwpUDLa71iFCYSsz
         7ZW5M2gmF4zP7FK0uF1NgNi4rz1LY3hv5LQlXy0yVxe0oceSTgo/2I7P6tw55fIL/CCe
         lDZg==
X-Forwarded-Encrypted: i=1; AJvYcCUQy1ChjhViIb7pnOnjqN+TmaqDA6JAdxHClEaMfvoi9ZEYB894wQ3csXV5WCUcpzShrUtoC0zZJyobbgmtWUhoCoQ6c1GK
X-Gm-Message-State: AOJu0YyROcXkU8dserbNbSufKGcArS9SJ/ondB6NIqcGU5F31QycFuCX
	1fxN+VC1ALVSN/7/dbWOhB0r75doCvIZK1iadLf+4RTV1ZShY31b
X-Google-Smtp-Source: AGHT+IH1x5xMI9uoPg2lnHlSiQRJh3IyeLPtdt/kc7CIoeguyY7MUFojlqvGni7okVmY4JK8i1uByQ==
X-Received: by 2002:a17:902:ccce:b0:1dc:30bb:b5cf with SMTP id z14-20020a170902ccce00b001dc30bbb5cfmr558973ple.59.1708486158130;
        Tue, 20 Feb 2024 19:29:18 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:17 -0800 (PST)
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
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 8/8] migration: add a migration selftest
Date: Wed, 21 Feb 2024 13:27:57 +1000
Message-ID: <20240221032757.454524-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for migration support in  guest library and test harness
code. It performs migrations in a tight loop to irritate races and bugs
in the test harness code.

Include the test in s390, powerpc.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/selftest-migration.c  | 29 +++++++++++++++++++++++++++++
 powerpc/Makefile.common      |  1 +
 powerpc/selftest-migration.c |  1 +
 powerpc/unittests.cfg        |  4 ++++
 s390x/Makefile               |  1 +
 s390x/selftest-migration.c   |  1 +
 s390x/unittests.cfg          |  4 ++++
 7 files changed, 41 insertions(+)
 create mode 100644 common/selftest-migration.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c

diff --git a/common/selftest-migration.c b/common/selftest-migration.c
new file mode 100644
index 000000000..54b5d6b2d
--- /dev/null
+++ b/common/selftest-migration.c
@@ -0,0 +1,29 @@
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
+#define NR_MIGRATIONS 30
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
index eb88398d8..da4a7bbb8 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -6,6 +6,7 @@
 
 tests-common = \
 	$(TEST_DIR)/selftest.elf \
+	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/selftest-migration.c b/powerpc/selftest-migration.c
new file mode 120000
index 000000000..bd1eb266d
--- /dev/null
+++ b/powerpc/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e71140aa5..7ce57de02 100644
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
index b72f7578f..344d46d68 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -1,4 +1,5 @@
 tests = $(TEST_DIR)/selftest.elf
+tests += $(TEST_DIR)/selftest-migration.elf
 tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
new file mode 120000
index 000000000..bd1eb266d
--- /dev/null
+++ b/s390x/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6ee..a7ad522ca 100644
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


From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 3/3] arm/arm64: allow building a single test
Date: Thu, 25 Jun 2015 18:12:19 +0200
Message-ID: <1435248739-25425-4-git-send-email-drjones@redhat.com>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D1B57010
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 12:01:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJYyxn-TLSRc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 12:01:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD36B56FF9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 12:01:28 -0400 (EDT)
In-Reply-To: <1435248739-25425-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This is mostly useful for building new tests that don't yet (and
may never) have entries in the makefiles (config-arm*.mak). Of course
it can be used to build tests that do have entries as well, in order
to avoid building all tests, if the plan is to run just the one.

Just do 'make TEST=some-test' to use it, where "some-test" matches
the name of the source file, i.e. arm/some-test.c

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 config/config-arm-common.mak | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/config/config-arm-common.mak b/config/config-arm-common.mak
index 314261ef60cf7..2ad29c115f946 100644
--- a/config/config-arm-common.mak
+++ b/config/config-arm-common.mak
@@ -12,6 +12,11 @@ endif
 tests-common = \
 	$(TEST_DIR)/selftest.flat
 
+ifneq ($(TEST),)
+	tests = $(TEST_DIR)/$(TEST).flat
+	tests-common =
+endif
+
 all: test_cases
 
 ##################################################################
@@ -69,4 +74,5 @@ generated_files = $(asm-offsets)
 
 test_cases: $(generated_files) $(tests-common) $(tests)
 
+$(TEST_DIR)/$(TEST).elf: $(cstart.o) $(TEST_DIR)/$(TEST).o
 $(TEST_DIR)/selftest.elf: $(cstart.o) $(TEST_DIR)/selftest.o
-- 
2.4.3

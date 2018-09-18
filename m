From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 04/13] kvm: selftests: add cscope make target
Date: Tue, 18 Sep 2018 19:54:27 +0200
Message-ID: <20180918175436.19742-5-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E71E4A26A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wMLyGRIGED5x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:52 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01E104A23E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:52 -0400 (EDT)
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
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
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 82d77e10b554..d603d7865cd1 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,7 +28,7 @@ include ../lib.mk
 
 STATIC_LIBS := $(OUTPUT)/libkvm.a
 LIBKVM_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM))
-EXTRA_CLEAN += $(LIBKVM_OBJ) $(STATIC_LIBS)
+EXTRA_CLEAN += $(LIBKVM_OBJ) $(STATIC_LIBS) cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_OBJ))))
 $(LIBKVM_OBJ): $(OUTPUT)/%.o: %.c
@@ -40,3 +40,12 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJ)
 all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
 $(STATIC_LIBS):| khdr
+
+cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
+cscope:
+	$(RM) cscope.*
+	(find $(include_paths) -name '*.h' \
+		-exec realpath --relative-base=$(PWD) {} \;; \
+	find . -name '*.c' \
+		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
+	cscope -b
-- 
2.17.1

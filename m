Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF08369
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694654907; x=1726190907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wSd9GEp5Pne1TmdWLw5kDWwDYuO0mubJkWJuSQ3R++A=;
  b=h0LrVprmpWHFWs8nGBZm81R9L2xkXG8fSSB8CQel522ARXe04I5XCIkT
   OoOiCFiGFovBq1tnwm+2nU8jKhZdL9ofyameakxJ5AeL9Xk/PFaeGC6H7
   JJDp9UJ/LDWvLGM8usfleBvUMRle5Z6t88+iuOLfWX6gcRd79VRHV3SZ3
   JuzaOKiFNU06jMCbHLPZZw2qp1qHoGBp9bso995WZmFA9xFeRsdJokpw7
   Wqkib+7vq04IHecKApCWU7hCzw30W4vD3RV3suv5EkqUSnsZ0kOzet9yI
   NvW0Lz2qgwmGFGLU9lqBuzhYlgf2sgbtcoMLm27Opci9RUoQG0f34zOA8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="377734053"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="377734053"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 18:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="694049172"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="694049172"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 18:28:18 -0700
From: Haibo Xu <haibo1.xu@intel.com>
To: 
Cc: xiaobo55x@gmail.com,
	haibo1.xu@intel.com,
	ajones@ventanamicro.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Sean Christopherson <seanjc@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Thomas Huth <thuth@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [PATCH v3 2/9] KVM: selftests: Unify the makefile rule for split targets
Date: Thu, 14 Sep 2023 09:36:56 +0800
Message-Id: <cda6cc71c9bdde87fe87f6c2dec4f03ca249dd62.1694421911.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1694421911.git.haibo1.xu@intel.com>
References: <cover.1694421911.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A separate makefile rule was used for split targets which was added
in patch(KVM: arm64: selftests: Split get-reg-list test code). This
could be avoided by minor changes to the recipes of current rule.

Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..7972269e8c5f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -249,13 +249,10 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TESTS_OBJS))
 -include $(TEST_DEP_FILES)
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM_OBJS) $(LDLIBS) -o $@
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
 $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-
 EXTRA_CLEAN += $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SPLIT_TESTS_OBJS) cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
@@ -274,6 +271,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
+$(SPLIT_TESTS_TARGETS): $(OUTPUT)/%: $(ARCH_DIR)/%.o
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.34.1


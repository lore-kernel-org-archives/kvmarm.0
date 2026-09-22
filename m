Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A05172F9
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061615; cv=none; b=OfUl+L0DK3Zl+eXhXYE4z8QceTGvLW6AXfoYQjN7SvPZG+aMYtMqj4pPKtHvjHZCUIp57TmOyebFg9/Ucgu/NsoyQYyTR9uEBdDwbH+bHhYmGna6AEElF/bbRF6jm8mofrwWUta+2xCZhmR3oSbfHYXcNR1ym8rNrCwBGBYHIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061615; c=relaxed/simple;
	bh=kR0qtsMATaQ3CTKql6oPYnCVuYWEZQdIrWQeZfXHpe0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S9xjHgANmeI2O/tOjc4zY78TRFe6G6rFz7/dvZ0NougHxq4K3qq/5Luqo8YEiNm+LMDzI2DO+tqb/FlJdKksytw65sWJ1t7D/eaKhmbhJodwTYXULA4Ps3iWrQ0fxvBenTY0goXEyjjjD8JedzWMFiysiF8WPtPRIrMpSTKwZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CgIgzGcA; arc=none smtp.client-ip=91.218.175.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CgIgzGcA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kR0qtsMATaQ3CTKql6oPYnCVuYWEZQdIrWQeZfXHpe0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790061595; v=1; x=1790666395;
 b=CgIgzGcAJ/cAjgNmOs2CCn38VWMIwpFwf7N3E6hvNF4KCmFPJL4wEow4eogQ0/oddPu5N5GN
 VvGYk/RKWczhyWcE756O2PUSFV3uctZ0ulxQzOE+LZhTJj5jFrjen3swuM4DCldPzVo4g4GZ9xi
 oPTWEZY46+f2zfRRUGO3srN8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6931c0f0a84286ba;
	Tue, 22 Sep 2026 07:19:54 +0000
X-Mizu-Trace-ID: 6931c0f0a84286ba
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: selftests: Fix arm64 sysreg header dependencies
Date: Tue, 22 Sep 2026 08:19:44 +0100
Message-Id: <20260922071945.693714-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922071945.693714-1-fuad.tabba@linux.dev>
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rule generating the arm64 sysreg header targets the generated
directory, and its only prerequisite is tools/arch/arm64/tools/*,
which expands to the inner Makefile. An existing directory looks up
to date, so an incremental build never regenerates sysreg-defs.h for
a change to the sysreg table. A selftest referencing a register added
to the table since then fails with undeclared SYS_* identifiers. Clean
builds are unaffected.

Always recurse into tools/arch/arm64/tools, whose Makefile already
tracks the generator's inputs, and target the header rather than its
directory. The recursion leaves the header untouched when nothing
changed, so the dependents rebuild only when the header does.

Fixes: 70c7b704ca725 ("KVM: selftests: Avoid using forced target for generating arm64 headers")
Link: https://lore.kernel.org/r/arGRhHgP_izSwW4T@kernel.org
Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39e..81dca3dbc16b4 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -303,10 +303,16 @@ arm64_hdr_outdir := $(tools_dir)/
 endif
 
 GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
+GEN_SYSREG_DEFS := $(GEN_HDRS)asm/sysreg-defs.h
 CFLAGS += -I$(GEN_HDRS)
 
-$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
+# The inner Makefile tracks the generator's inputs and leaves the header
+# untouched when nothing changed, so dependents rebuild only when it does.
+$(GEN_SYSREG_DEFS): FORCE
 	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
+
+FORCE:
+.PHONY: FORCE
 endif
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
@@ -359,10 +365,10 @@ EXTRA_CLEAN += $(GEN_HDRS) \
 	       $(TEST_GEN_OBJ) \
 	       cscope.*
 
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_SYSREG_DEFS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_SYSREG_DEFS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 # Compile the string overrides as freestanding to prevent the compiler from
@@ -372,10 +378,10 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
 $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-$(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
+$(SPLIT_TEST_GEN_OBJ): $(GEN_SYSREG_DEFS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
-$(TEST_GEN_OBJ): $(GEN_HDRS)
+$(TEST_GEN_OBJ): $(GEN_SYSREG_DEFS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.39.5


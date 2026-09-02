Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94B449E5CE
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788356486; cv=none; b=rO09XlhqAwWU5GMvgkk4s77OzOJdbKjaXrvVQRlQqHj/+Bhv6FrHj6LG4ExJiZgZrh2JsvKNFwiN0OlzaZHByTez4py9cWW76VxGXTj+8Rjxws4beUcbn05i82cRAHSIhbcS+UYhRTLb64suDs0bQRmKilMZ/5P1p/kXN02EIww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788356486; c=relaxed/simple;
	bh=KMGUCU02nxvEGZQa8eku/iJ+RwAWXlAohhC96/fQmBE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YiEzEn2vDxmC1SXAbZt26SF/N0c96gFbMOl8zPVUJ+dgsYs4+2PghAkXq7vhNKVZ35k+ZLC3SnVxbe0zG3zf202DEn2sympPdl7Q6l93ip9Ugml+uyxqNMr6UlH7GLY3Eo3itTLp4EBsCYMXo+yTjF6woRi5FcM6Qp+28sWgL1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EeKGC8tZ; arc=none smtp.client-ip=95.215.58.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EeKGC8tZ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KMGUCU02nxvEGZQa8eku/iJ+RwAWXlAohhC96/fQmBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788356481; v=1; x=1788961281;
 b=EeKGC8tZQs3FUBBzoU+ocKZ3OZDKZts4tPbvvD9OF8JonKVCNs/M0MC3Slx2jjrW8eIQ8IpN
 /OXpZbGizgLXQpRHsAzRaclJVW0xBJqFapj5VZOnvPC4KV7hK3z8zXQKHX5XIDEdjQ1uFSXpjhn
 LhfUd21F2YHOMenlUrA2X97E=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ce0b63c89f984c47;
	Wed, 02 Sep 2026 13:41:21 +0000
X-Mizu-Trace-ID: ce0b63c89f984c47
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Fix arm64 sysreg header dependencies
Date: Wed,  2 Sep 2026 14:41:18 +0100
Message-Id: <20260902134118.2718200-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rule generating the arm64 sysreg header targets the generated
directory, and its only prerequisites are tools/arch/arm64/tools/*,
which is the inner Makefile. An existing directory looks up to date,
so an incremental build never regenerates sysreg-defs.h. A selftest
referencing a register added to the table since then fails with
undeclared SYS_* identifiers. Clean builds are unaffected.

Depend on the generator's inputs, and target the header rather than its
directory, whose mtime does not change when the header is rewritten.

Fixes: 70c7b704ca725 ("KVM: selftests: Avoid using forced target for generating arm64 headers")
Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Unlike the two existing sysreg-defs.h rules, this one's recipe is a recursive
make, so its prerequisites are not the recipe's arguments. They only decide
whether to recurse, which is a question tools/arch/arm64/tools/Makefile already
answers. An alternative is therefore to drop the two explicit inputs in favour
of:

	$(GEN_SYSREG_DEFS): FORCE

leaving that Makefile as the only place naming the generator's inputs. Both
forms regenerate the header and rebuild the dependents in the same invocation,
and neither rebuilds anything when nothing changed. I kept the explicit
prerequisites so that the recursion stays conditional, but I am happy to respin
with FORCE if you would rather.

 tools/testing/selftests/kvm/Makefile.kvm | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39e..4a1f1bfcff0e3 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -303,9 +303,14 @@ arm64_hdr_outdir := $(tools_dir)/
 endif
 
 GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
+GEN_SYSREG_DEFS := $(GEN_HDRS)asm/sysreg-defs.h
 CFLAGS += -I$(GEN_HDRS)
 
-$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
+# A directory's mtime does not track the header inside it.
+# Sysreg inputs duplicated from tools/arch/arm64/tools/Makefile, keep in sync.
+$(GEN_SYSREG_DEFS): $(top_srcdir)/arch/arm64/tools/sysreg \
+		    $(top_srcdir)/arch/arm64/tools/gen-sysreg.awk \
+		    $(wildcard $(arm64_tools_dir)/*)
 	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
 endif
 
@@ -359,10 +364,10 @@ EXTRA_CLEAN += $(GEN_HDRS) \
 	       $(TEST_GEN_OBJ) \
 	       cscope.*
 
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_SYSREG_DEFS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_SYSREG_DEFS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 # Compile the string overrides as freestanding to prevent the compiler from
@@ -372,10 +377,10 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
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

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.39.5


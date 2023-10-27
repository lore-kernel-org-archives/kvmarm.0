Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7737A5E
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vVzP0BLk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698368093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hG2LAfyctCoLtIjZzeKRYZw/nVIS+d0blJ9NshgUWD4=;
	b=vVzP0BLkHnaCFvF6jizyBwsKW1cp7K/9C9wBvrPcrCtmDL0mXqxcIsrWIBWAGsCvHx5qtR
	+ywor4Zee9qLAjxE6ZW0D7ofd2vX7gR7we5QYOwsC13o2nnjf5qfx+kSAvke04qQldIIqZ
	CQTyiOZOEx0M+AQkkrzUOG0mngaS0dM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [PATCH 2/2] KVM: selftests: Avoid using forced target for generating arm64 headers
Date: Fri, 27 Oct 2023 00:54:39 +0000
Message-ID: <20231027005439.3142015-3-oliver.upton@linux.dev>
In-Reply-To: <20231027005439.3142015-1-oliver.upton@linux.dev>
References: <20231027005439.3142015-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'prepare' target that generates the arm64 sysreg headers had no
prerequisites, so it wound up forcing a rebuild of all KVM selftests
each invocation. Add a rule for the generated headers and just have
dependents use that for a prerequisite.

Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Fixes: 9697d84cc3b6 ("KVM: selftests: Generate sysreg-defs.h and add to include path")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4f4f6ad025f4..4de096bbf124 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -22,10 +22,8 @@ arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
 GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
 CFLAGS += -I$(GEN_HDRS)
 
-prepare:
+$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
 	$(MAKE) -C $(arm64_tools_dir)
-else
-prepare:
 endif
 
 LIBKVM += lib/assert.c
@@ -276,10 +274,10 @@ EXTRA_CLEAN += $(GEN_HDRS) \
 	       cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c prepare
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S prepare
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 # Compile the string overrides as freestanding to prevent the compiler from
@@ -289,9 +287,10 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
+$(SPLIT_TESTS_OBJS): $(GEN_HDRS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
-$(TEST_GEN_OBJ): prepare
+$(TEST_GEN_OBJ): $(GEN_HDRS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.42.0.820.g83a721a137-goog


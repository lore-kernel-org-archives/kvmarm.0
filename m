Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103125A117
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bOAZPPxG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700595021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mQR8cKzw4YvxUsn4BIfi8vpujv8/0B55bVmVxQ9uDc=;
	b=bOAZPPxG+2wifGfQxb6o7Y39f0IQP1/cOSAvqSwmixPtocXDF8HnfqYf3LEIbi8hZHR1kb
	Czi+LqhTNmnJi9BLAMt8JDNfam2eIPS6gtdpxSsIDNWWUSQdos+0qNSPAuwueh71gE9qGu
	cf1TfWAnUOiA0vtHeqY76mWKMGWr4y8=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-perf-users@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects output dir
Date: Tue, 21 Nov 2023 19:29:56 +0000
Message-ID: <20231121192956.919380-3-oliver.upton@linux.dev>
In-Reply-To: <20231121192956.919380-1-oliver.upton@linux.dev>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently the sysreg-defs are written out to the source tree
unconditionally, ignoring the specified output directory. Correct the
build rule to emit the header to the output directory. Opportunistically
reorganize the rules to avoid interleaving with the set of beauty make
rules.

Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/tools/Makefile      |  2 +-
 tools/perf/Makefile.perf             | 24 +++++++++++++++---------
 tools/perf/util/Build                |  2 +-
 tools/testing/selftests/kvm/Makefile |  5 +++--
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
index 7f64b8bb5107..7b42feedf647 100644
--- a/tools/arch/arm64/tools/Makefile
+++ b/tools/arch/arm64/tools/Makefile
@@ -22,7 +22,7 @@ endif
 arm64_tools_dir = $(top_srcdir)/arch/arm64/tools
 arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
 arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
-arm64_generated_dir = $(top_srcdir)/tools/arch/arm64/include/generated
+arm64_generated_dir = $(OUTPUT)arch/arm64/include/generated
 arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
 
 all: $(arm64_sysreg_defs)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d88da787e815..058c9aecf608 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -434,6 +434,21 @@ export INSTALL SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
+arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
+ifneq ($(OUTPUT),)
+  arm64_gen_sysreg_outdir := $(OUTPUT)
+else
+  arm64_gen_sysreg_outdir := $(CURDIR)
+endif
+
+arm64-sysreg-defs: FORCE
+	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) O=$(arm64_gen_sysreg_outdir)
+
+arm64-sysreg-defs-clean:
+	$(call QUIET_CLEAN,arm64-sysreg-defs)
+	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) O=$(arm64_gen_sysreg_outdir) \
+		clean > /dev/null
+
 beauty_linux_dir := $(srctree)/tools/perf/trace/beauty/include/linux/
 linux_uapi_dir := $(srctree)/tools/include/uapi/linux
 asm_generic_uapi_dir := $(srctree)/tools/include/uapi/asm-generic
@@ -450,15 +465,6 @@ drm_ioctl_tbl := $(srctree)/tools/perf/trace/beauty/drm_ioctl.sh
 # Create output directory if not already present
 _dummy := $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$(beauty_ioctl_outdir)')
 
-arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
-
-arm64-sysreg-defs: FORCE
-	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
-
-arm64-sysreg-defs-clean:
-	$(call QUIET_CLEAN,arm64-sysreg-defs)
-	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) clean > /dev/null
-
 $(drm_ioctl_array): $(drm_hdr_dir)/drm.h $(drm_hdr_dir)/i915_drm.h $(drm_ioctl_tbl)
 	$(Q)$(SHELL) '$(drm_ioctl_tbl)' $(drm_hdr_dir) > $@
 
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index fb661c48992f..988473bf907a 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -347,7 +347,7 @@ CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ET
 CFLAGS_libstring.o     += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_header.o        += -include $(OUTPUT)PERF-VERSION-FILE
-CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/ -I$(srctree)/tools/arch/arm64/include/generated/
+CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/ -I$(OUTPUT)arch/arm64/include/generated/
 
 $(OUTPUT)util/argv_split.o: ../lib/argv_split.c FORCE
 	$(call rule_mkdir)
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a5963ab9215b..52c59bad7213 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -18,12 +18,13 @@ else
 endif
 
 ifeq ($(ARCH),arm64)
-arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
+tools_dir := $(top_srcdir)/tools
+arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
 GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
 CFLAGS += -I$(GEN_HDRS)
 
 $(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
-	$(MAKE) -C $(arm64_tools_dir)
+	$(MAKE) -C $(arm64_tools_dir) O=$(tools_dir)
 endif
 
 LIBKVM += lib/assert.c
-- 
2.43.0.rc1.413.gea7ed67945-goog


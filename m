Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BCA15AF5
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 07:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uhzgb9Js"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702364746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ohnF1W++KcAoa0lsuGqvKhsZ8LjbSkh3DKZwGQ3ANzo=;
	b=Uhzgb9JsR6oug72Fv2zMFxTJ7ZFgHBsKUxvLPdIBwgg43aj11oiYPIvoVXqMFjdYnreA0c
	l6Z7kSuNxvplQGWQ7b3GjD9qtLDySZFBscxF3y+hglMHqfUwIeqE92wq36tI+OvgfuHicc
	OP4eSUxW0nWEGianxk5jAhH+wz/IRuk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	broonie@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: selftests: Ensure sysreg-defs.h is generated at the expected path
Date: Tue, 12 Dec 2023 07:04:32 +0000
Message-ID: <20231212070431.145544-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Building the KVM selftests from the main selftests Makefile (as opposed
to the kvm subdirectory) doesn't work as OUTPUT is set, forcing the
generated header to spill into the selftests directory. Additionally,
relative paths do not work when building outside of the srctree, as the
canonical selftests path is replaced with 'kselftest' in the output.

Work around both of these issues by explicitly overriding OUTPUT on the
submake cmdline. Move the whole fragment below the point lib.mk gets
included such that $(abs_objdir) is available.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 52c59bad7213..5f4f6be7a866 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -17,16 +17,6 @@ else
 	ARCH_DIR := $(ARCH)
 endif
 
-ifeq ($(ARCH),arm64)
-tools_dir := $(top_srcdir)/tools
-arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
-GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
-CFLAGS += -I$(GEN_HDRS)
-
-$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
-	$(MAKE) -C $(arm64_tools_dir) O=$(tools_dir)
-endif
-
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
@@ -234,6 +224,22 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
 endif
+ifeq ($(ARCH),arm64)
+tools_dir := $(top_srcdir)/tools
+arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
+
+ifneq ($(abs_objdir),)
+arm64_hdr_outdir := $(abs_objdir)/tools/
+else
+arm64_hdr_outdir := $(tools_dir)/
+endif
+
+GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
+CFLAGS += -I$(GEN_HDRS)
+
+$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
+	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
+endif
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)

base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
-- 
2.43.0.472.g3155946c3a-goog


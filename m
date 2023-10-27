Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1A81A
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BmzBBNu0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698368091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5J0Jhz2hwPSoOVC//hWixstF6ppS3O/i9FTlVlzu+p8=;
	b=BmzBBNu0/uOKhKHcCoDgdZf8qmZZ7mUnCVufXKpsfR87RLu2Yh5uXLz/ZilZ21arxll72T
	lBpz2E4PPfCAv5rbxgQcyVclitzNpgl515RbgpitzGmUW+bD4K+JXDjEo3Fx5WqTl5P8Gp
	vktdz0UL8B8YOMKcdr17ZIm/HvIu+LQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Aishwarya TCV <aishwarya.tcv@arm.com>
Subject: [PATCH 1/2] tools headers arm64: Fix references to top srcdir in Makefile
Date: Fri, 27 Oct 2023 00:54:38 +0000
Message-ID: <20231027005439.3142015-2-oliver.upton@linux.dev>
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

Aishwarya reports that KVM selftests for arm64 fail with the following
error:

 | make[4]: Entering directory '/tmp/kci/linux/tools/testing/selftests/kvm'
 | Makefile:270: warning: overriding recipe for target
 | '/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
 | Makefile:265: warning: ignoring old recipe for target
 | '/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
 | make -C ../../../../tools/arch/arm64/tools/
 | make[5]: Entering directory '/tmp/kci/linux/tools/arch/arm64/tools'
 | Makefile:10: ../tools/scripts/Makefile.include: No such file or directory
 | make[5]: *** No rule to make target '../tools/scripts/Makefile.include'.
 |  Stop.

It would appear that this only affects builds from the top-level
Makefile (e.g. make kselftest-all), as $(srctree) is set to ".". Work
around the issue by shadowing the kselftest naming scheme for the source
tree variable.

Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Fixes: 0359c946b131 ("tools headers arm64: Update sysreg.h with kernel sources")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/tools/Makefile | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
index f867e6036c62..7f64b8bb5107 100644
--- a/tools/arch/arm64/tools/Makefile
+++ b/tools/arch/arm64/tools/Makefile
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
+ifeq ($(top_srcdir),)
+top_srcdir := $(patsubst %/,%,$(dir $(CURDIR)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
 endif
 
-include $(srctree)/tools/scripts/Makefile.include
+include $(top_srcdir)/tools/scripts/Makefile.include
 
 AWK	?= awk
 MKDIR	?= mkdir
@@ -19,10 +19,10 @@ else
 Q = @
 endif
 
-arm64_tools_dir = $(srctree)/arch/arm64/tools
+arm64_tools_dir = $(top_srcdir)/arch/arm64/tools
 arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
 arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
-arm64_generated_dir = $(srctree)/tools/arch/arm64/include/generated
+arm64_generated_dir = $(top_srcdir)/tools/arch/arm64/include/generated
 arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
 
 all: $(arm64_sysreg_defs)
-- 
2.42.0.820.g83a721a137-goog


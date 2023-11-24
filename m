Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 480C635F04
	for <kvmarm@lists.linux.dev>; Fri, 24 Nov 2023 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A96E1C00;
	Fri, 24 Nov 2023 08:36:55 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB4B43F73F;
	Fri, 24 Nov 2023 08:36:06 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@linux.ibm.com,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	dave.hansen@linux.intel.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	will@kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 19/25] kselftest/arm64: move get_header()
Date: Fri, 24 Nov 2023 16:35:04 +0000
Message-Id: <20231124163510.1835740-20-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231124163510.1835740-1-joey.gouly@arm.com>
References: <20231124163510.1835740-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Put this function in the header so that it can be used by other tests, without
needing to link to testcases.c.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 .../arm64/signal/testcases/testcases.c        | 23 -----------------
 .../arm64/signal/testcases/testcases.h        | 25 +++++++++++++++++--
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 9f580b55b388..fe950b6bca6b 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -6,29 +6,6 @@
 
 #include "testcases.h"
 
-struct _aarch64_ctx *get_header(struct _aarch64_ctx *head, uint32_t magic,
-				size_t resv_sz, size_t *offset)
-{
-	size_t offs = 0;
-	struct _aarch64_ctx *found = NULL;
-
-	if (!head || resv_sz < HDR_SZ)
-		return found;
-
-	while (offs <= resv_sz - HDR_SZ &&
-	       head->magic != magic && head->magic) {
-		offs += head->size;
-		head = GET_RESV_NEXT_HEAD(head);
-	}
-	if (head->magic == magic) {
-		found = head;
-		if (offset)
-			*offset = offs;
-	}
-
-	return found;
-}
-
 bool validate_extra_context(struct extra_context *extra, char **err,
 			    void **extra_data, size_t *extra_size)
 {
diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.h b/tools/testing/selftests/arm64/signal/testcases/testcases.h
index a08ab0d6207a..d33154c9a4bd 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.h
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.h
@@ -87,8 +87,29 @@ struct fake_sigframe {
 
 bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err);
 
-struct _aarch64_ctx *get_header(struct _aarch64_ctx *head, uint32_t magic,
-				size_t resv_sz, size_t *offset);
+static inline struct _aarch64_ctx *get_header(struct _aarch64_ctx *head, uint32_t magic,
+				size_t resv_sz, size_t *offset)
+{
+	size_t offs = 0;
+	struct _aarch64_ctx *found = NULL;
+
+	if (!head || resv_sz < HDR_SZ)
+		return found;
+
+	while (offs <= resv_sz - HDR_SZ &&
+	       head->magic != magic && head->magic) {
+		offs += head->size;
+		head = GET_RESV_NEXT_HEAD(head);
+	}
+	if (head->magic == magic) {
+		found = head;
+		if (offset)
+			*offset = offs;
+	}
+
+	return found;
+}
+
 
 static inline struct _aarch64_ctx *get_terminator(struct _aarch64_ctx *head,
 						  size_t resv_sz,
-- 
2.25.1


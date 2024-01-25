Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85845136652
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706200998; cv=none; b=Bz/eEhv7UT/8yf9kuXh94xFH87AQms0S5FFgbCX15szRQKnFocpFrnTE3muQqVieEVpe4lRa4Ha+u7BshRBAoKU0xruRIL/lGb8/eSwJNT+JSFu+sbGIfkv+oSbVWLpcRd9XbWwonSFn9pJqWYYXWK8SvBG7wSgh2MZ6rZkf9gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706200998; c=relaxed/simple;
	bh=hkegklhgwhHaIG9vI1njsTd7DG5AV1doOWIOBxRLhcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G10MJQRwk+T5FF2i2r1lG/7l5VhlxwPXgLcGlCK0SinRyywQITzEZUEBN4Ss6xuvKDGiXdEbwYoYgeaC7BqKZSiETAkrUKhJFmufskRE1Yf9PvyyM2CUGRCW7zHsSIT+0xQIVMvkG+hsSrWgUS2I9wSX7UBUwyDKogKHZDjYkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6546F14BF;
	Thu, 25 Jan 2024 08:44:00 -0800 (PST)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 776B83F5A1;
	Thu, 25 Jan 2024 08:43:10 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	bristot@redhat.com,
	vschneid@redhat.com,
	mhiramat@kernel.org,
	rppt@kernel.org,
	hughd@google.com
Cc: pcc@google.com,
	steven.price@arm.com,
	anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com,
	david@redhat.com,
	eugenis@google.com,
	kcc@google.com,
	hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC v3 05/35] mm: cma: Don't append newline when generating CMA area name
Date: Thu, 25 Jan 2024 16:42:26 +0000
Message-Id: <20240125164256.4147-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125164256.4147-1-alexandru.elisei@arm.com>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cma->name is displayed in several CMA messages. When the name is generated
by the CMA code, don't append a newline to avoid breaking the text across
two lines.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes since rfc v2:

* New patch. This is a fix, and can be merged independently of the other
patches.

 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 7c09c47e530b..f49c95f8ee37 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -204,7 +204,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	if (name)
 		snprintf(cma->name, CMA_MAX_NAME, name);
 	else
-		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+		snprintf(cma->name, CMA_MAX_NAME,  "cma%d", cma_area_count);
 
 	cma->base_pfn = PFN_DOWN(base);
 	cma->count = size >> PAGE_SHIFT;
-- 
2.43.0


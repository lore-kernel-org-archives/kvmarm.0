Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612692F5495
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757076107; cv=none; b=FvP/jhIAYrFfru6kffNrfTby/JxV3LKnnaIz8mWg98gbZs9zHkib9NexaCCRb6KPG9rX8GCSBaTMKF0hh0YC3iuQJrzoM3DeFwh+V6IIb4bkipWZbczec9JKxxrYrVmbswnS3WrXRmZYO36sqCBbDzkMlVpGjJFz9zxEMsDNfFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757076107; c=relaxed/simple;
	bh=O3IgAWzoBKQI7rWCvlTFj2il/YVcxrgTZCHEq5CrjWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OsAenUw/XGyWoYH064HeOCSCx7Cc8UQWEBbarhk+gTOVPMYKx2xfOy2TxgnYasyUKMkhsxkm+gapBZ27QRtCkPd1i9GRNSDO7YdwwLEuq7enKJ/nMwCLlz2N5RmRAos0DW1uQq/Y1pLc9VXU52cH1zmpNf1PLfFbqvhV+jsdF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61588153B;
	Fri,  5 Sep 2025 05:41:37 -0700 (PDT)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 304983F63F;
	Fri,  5 Sep 2025 05:41:45 -0700 (PDT)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev
Subject: [kvm-unit-tests PATCH] arm64: mte: Fix MTE granule mask
Date: Fri,  5 Sep 2025 13:41:29 +0100
Message-Id: <20250905124129.32435-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So it generates correct mask when used together with MTE_TAG_SHIFT

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arm/mte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/mte.c b/arm/mte.c
index 95d58aaa..a1bed8a7 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -26,7 +26,7 @@
 #define MTE_TCF_ASYMM	0b11
 
 #define MTE_GRANULE_SIZE        UL(16)
-#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
+#define MTE_GRANULE_MASK        (MTE_GRANULE_SIZE - 1)
 #define MTE_TAG_SHIFT           56
 
 #define untagged(p)									\
-- 
2.34.1


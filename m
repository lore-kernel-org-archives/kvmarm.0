Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7573FE46;
	Fri, 12 Apr 2024 10:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918064; cv=none; b=oALD5V45/vmSM5oiaC1cUCJ8yfB80AceZ2XvF22CigS8i8XKGhF4fPmZCfmUG3MmCtjNPnpJf1Uya22eekcg6q8TuW8PdxEjzw5FJCAWzzs/wcdmPPiJROEChA1CQMA0pYWmvbA4/I+6XOC9F5Hpl6FtVvbVSfq9a7SqCsTXk5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918064; c=relaxed/simple;
	bh=wVApZFw3Jgpr1h5HbRcGGyXr+HJpl/gFzNMPoPRtR6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Er5HoxJqG4+bVHagxHGw8yPzV6waiuNOPuj/rPIA3Vy63IBFd3xN2ligRSf8pW0u+mzDfp4+Q2lEqneQz8nIYhYZ9+xwy8qvTS6R83/v+kzINd/ORWis541+KyFen43O4F/eJ/v9zBx222SRfTWa6y7ddjPggAxEkqZQn70FIpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4864C1596;
	Fri, 12 Apr 2024 03:34:52 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EFB943F64C;
	Fri, 12 Apr 2024 03:34:20 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 02/33] arm: Detect FDT overlap with uninitialised data
Date: Fri, 12 Apr 2024 11:33:37 +0100
Message-Id: <20240412103408.2706058-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the FDT was placed in a region overlapping the bss/stack area, it
would have been overwritten at early boot. Assert this never happened
to detect the case.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/setup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 2f649aff..462a1d51 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -35,6 +35,7 @@
 #define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
 extern unsigned long _text, _etext, _data, _edata;
+extern unsigned long stacktop;
 
 char *initrd;
 u32 initrd_size;
@@ -196,6 +197,12 @@ static void freemem_push_fdt(void **freemem, const void *fdt)
 	u32 fdt_size;
 	int ret;
 
+	/*
+	 * Ensure that the FDT was not overlapping with the uninitialised
+	 * data that was overwritten.
+	 */
+	assert((unsigned long)fdt > (unsigned long)&stacktop);
+
 	fdt_size = fdt_totalsize(fdt);
 	ret = fdt_move(fdt, *freemem, fdt_size);
 	assert(ret == 0);
-- 
2.34.1


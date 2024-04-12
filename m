Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514B032C60;
	Fri, 12 Apr 2024 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918062; cv=none; b=Ka10RVlxY7Vqu4d3uDV9yrIo2xkfnOhcTwGJpUA6EUOdFW+DgjlfxOoBOpNZHuCx+xP+PsmbGPScJ8SW2IV6Mj5VmOQOHvNEUPnnHA3Alwnc+me3tLEJSGFypL5l5RPm/wF5L1gqAiDEKfwEL56fjdZScd7YS8/RVEAQAxLhF/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918062; c=relaxed/simple;
	bh=Ctw8vJJkDEIvSuuFhIzpRsRR2XQ5C75jFGA7+4iX4b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ut5sLb4tj+/jRWXff2Vkof7Y35i+E1N4lyKXrigskELkgtmqrpe1yXEf9p/CZ3N4XKXg+uNq1PFEcOBF9xU5Ig1Lz5nBNMFO0Dgrt/2F7LxWWz3hUgVFYFHEWhA10mB1K3/LINuPzvcakpW3ZANASDEJSJ39uKRAF8z1MPMf2ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0A03113E;
	Fri, 12 Apr 2024 03:34:49 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F06293F64C;
	Fri, 12 Apr 2024 03:34:18 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 01/33] arm: Add necessary header files in asm/pgtable.h
Date: Fri, 12 Apr 2024 11:33:36 +0100
Message-Id: <20240412103408.2706058-2-suzuki.poulose@arm.com>
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

We use memalign() and other symbols defined elsewhere without explicitly including
them, which could cause build failures. Add the necessary header files.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index d7c73906..aa98d9ad 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -13,7 +13,9 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
+#include <alloc.h>
 #include <alloc_page.h>
+#include <asm/setup.h>
 
 /*
  * We can convert va <=> pa page table addresses with simple casts
-- 
2.34.1


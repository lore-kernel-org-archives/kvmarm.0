Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9033C1FAC42
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187068; cv=none; b=GILBBvyW6+lcJ+fcZ+G4JwGUkl/Iaj2ePXPSZIXE0IdtlSYyJ2GwvcAPvHS4c2zI4r8ZzxTRkZrqaQ3cIOigiJLwsMhc/NtgKu3o0b8eqMM2Jx2UOW7WNFbw96i6YOZzc1kk+aD/nawqFLnENAl8oUJaHRysjJllk6pIz2NTUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187068; c=relaxed/simple;
	bh=Mdgjubedp24vdBglgtszpCoCNNLe4oxprQMU53F560k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=asf0ZzTm+DBfzKRUfwLIHVsKElgnq61jKxHAcG1EUGXf13QZWwC026vwVC+4QhjT+dGCOWBRY5PE9Hh1xR0CnDWsr5+FSP+dPnjRyYBEZ6PYFlH79RcAh6R5GOYgz8j1rPo3/+8DqLkkw5GlqnKJ/xGXMw/ZvyGFxS6R6dHODic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34A291576;
	Fri, 23 Jan 2026 08:50:59 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EDD33F694;
	Fri, 23 Jan 2026 08:51:04 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 02/14] arm64: set SCTLR_EL1 to a known value for secondary cores
Date: Fri, 23 Jan 2026 16:50:41 +0000
Message-Id: <20260123165053.2250754-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This ensures that primary and secondary cores will have the same values for
SCTLR_EL1.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Fixes: 10b65ce77ae7 ("arm64: Configure SCTLR_EL1 at boot")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/cstart64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 014c9c7b..dcdd1516 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -185,6 +185,11 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	/* set SCTLR_EL1 to a known value */
+	ldr	x0, =INIT_SCTLR_EL1_MMU_OFF
+	msr	sctlr_el1, x0
+	isb
+
 	/* enable FP/ASIMD and SVE */
 	mov	x0, #(3 << 20)
 	orr	x0, x0, #(3 << 16)
-- 
2.25.1


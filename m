Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30282395DAF
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391930; cv=none; b=Kmv3zHnJVqAakOOi7WaTFynKMOdan8cx7Ex0LUhrTAjEvNyhUmP94J4cRDDTVAFYxvlEtmiUUFI71o7ZtCZaRe79fPdUguVynHAKQ0wydJSj4f05TJlML5k9PN8TP9Ez23IeRqI3uSducWPgRrsh/s1fuYzq3bgXWOXhD4qwzSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391930; c=relaxed/simple;
	bh=Mdgjubedp24vdBglgtszpCoCNNLe4oxprQMU53F560k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BIK4mr//Xjua+esK9A/5LKTpocwjxnVLyQZ8buPEzSbs8P3+SUrllP9p2CyyyecyLALafBB6PlkN6d0DDCdcWgJtyElj90SqK4ibUAqIspc7VUboi5ykkEbFj8s/dtUrDM9d4tNashDJ4Rgvtl2DlDNycvmh3o1M75X9cJFogS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BEAE1515;
	Wed, 14 Jan 2026 03:58:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 002E43F632;
	Wed, 14 Jan 2026 03:58:44 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 01/11] arm64: set SCTLR_EL1 to a known value for secondary cores
Date: Wed, 14 Jan 2026 11:56:53 +0000
Message-Id: <20260114115703.926685-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
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


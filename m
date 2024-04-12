Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D20F5676C;
	Fri, 12 Apr 2024 10:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918094; cv=none; b=opjcNidRY2zIi5n2kguc/j3ZaVbKqFBclxc45BDyDeVyNKYFXN0BGhlzbKl1balINsdjGDrvnwsSx8pOFcZGZkGeH78uVqB12ZXDv569kf6IovI5MxGdv42an7EDSrGgByKWyhA6TlS7zVm9ce0S3ZGuFud/4ruOuptWrMlgVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918094; c=relaxed/simple;
	bh=KksWxqwOaHZnIl8HsPu708eVscZc0fFNwMKoDG4QCNs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A++CH3X9hWucrQmr/IhjK/Zjey1zMIvrnf5yNUH9z14IIZ4uuV3Oa9MsRQiH04uQFfV7Q449NeonBRaVRDiLGA5zc/XcChdiogPHuiibg7P7PjvW8ijZXc+XHUPSbj1kxGrT68AI3upHTrTpTuud0UayQ8nTxGqG42wO6EzHglo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C53C15A1;
	Fri, 12 Apr 2024 03:35:22 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C7303F64C;
	Fri, 12 Apr 2024 03:34:51 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 17/33] arm64: enable SVE at startup
Date: Fri, 12 Apr 2024 11:33:52 +0100
Message-Id: <20240412103408.2706058-18-suzuki.poulose@arm.com>
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

From: Joey Gouly <joey.gouly@arm.com>

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/cstart64.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 92631349..c081365f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -94,8 +94,9 @@ start:
 	adrp    x4, stackptr
 	add     sp, x4, :lo12:stackptr
 
-	/* enable FP/ASIMD */
-	mov	x4, #(3 << 20)
+	/* enable FP/ASIMD and SVE */
+	mov	x4, (3 << 20)
+	orr	x4, x4, (3 << 16)
 	msr	cpacr_el1, x4
 
 	/* set up exception handling */
@@ -278,8 +279,9 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
-	/* Enable FP/ASIMD */
+	/* enable FP/ASIMD and SVE */
 	mov	x0, #(3 << 20)
+	orr	x0, x0, #(3 << 16)
 	msr	cpacr_el1, x0
 
 	/* set up exception handling */
-- 
2.34.1


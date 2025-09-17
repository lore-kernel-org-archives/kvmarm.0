Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDEA3397CC
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120991; cv=none; b=rcPJcsDy7S5fA4EhnNc0+OxIqKOtJcJccMAfytDIUVzPgpx1mI/MsmIGCYKFLmgq71+R5qMbFBjn5owHdSc/X1FJeYrlbGGPdJcXXOOUBco42TaUFHmK5bswDQClx4zhDss5/Km/NX6jQ9xXbf/ZMPqzqUcUeuFbNWeTvWpFpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120991; c=relaxed/simple;
	bh=GZS8B5riWrRAALkBlvJ27EMS9EH/NTGI1JAuqMGKfoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZhVk6w2Qr3VfzelZnKsG0WprUI6CbPLqgtY4BZD1Ux8tdwh6QVeVEXFh9H0Y2G9Ms6wQb1sJYZbaH2oWbgrMlos74o1Ay65aYTyLbYoze415CAo9pBhXKx1ylIwCYWpFnMMeJQWyJnz4CbP0w17mxgBm7QvV1NFTJceafAwI54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA8BA2696;
	Wed, 17 Sep 2025 07:56:19 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7A2C63F66E;
	Wed, 17 Sep 2025 07:56:24 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	Dave.Martin@arm.com,
	ahmed.genidi@arm.com,
	kevin.brodsky@arm.com,
	scott@os.amperecomputing.com,
	mbenes@suse.cz,
	james.clark@linaro.org,
	frederic@kernel.org,
	rafael@kernel.org,
	pavel@kernel.org,
	ryan.roberts@arm.com,
	suzuki.poulose@arm.com,
	maz@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 1/6] arm64: make SCTLR2_EL1 accessible
Date: Wed, 17 Sep 2025 15:56:13 +0100
Message-Id: <20250917145618.1232329-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917145618.1232329-1-yeoreum.yun@arm.com>
References: <20250917145618.1232329-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the kernel runs at EL1, and yet is booted at EL2,
HCRX_EL2.SCTLR2En must be set to avoid trapping SCTLR2_EL1 accesses
from EL1 to EL2.

Ensure this bit is set at the point of initialising EL2.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 46033027510c..d9529dfc4783 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -57,10 +57,16 @@
         /* Enable GCS if supported */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
-	cbz	x1, .Lset_hcrx_\@
+	cbz	x1, .Lskip_hcrx_GCSEn_\@
 	orr	x0, x0, #HCRX_EL2_GCSEn
 
-.Lset_hcrx_\@:
+.Lskip_hcrx_GCSEn_\@:
+	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
+	ubfx	x1, x1, #ID_AA64MMFR3_EL1_SCTLRX_SHIFT, #4
+	cbz	x1, .Lskip_hcrx_SCTLR2En\@
+	orr	x0, x0, #HCRX_EL2_SCTLR2En
+
+.Lskip_hcrx_SCTLR2En\@:
 	msr_s	SYS_HCRX_EL2, x0
 .Lskip_hcrx_\@:
 .endm
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


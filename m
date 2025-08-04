Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9769C2566F5
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309859; cv=none; b=PjTe1fqrl6rSPb+UqqF7MRvXQDHPxdmlD7n5TQBuwwgRtK/VR4BiUUCVy8i8VgSDLtHebZfi9+pTAcIF/IOlG0AhABb+91ionjd3aIajjc+x8ib558FE3fQv1ZJ599d2Mh4rxHxZcKxt9Z3Za0vlwVoa/I/Z1zy5HA2qo1m8X4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309859; c=relaxed/simple;
	bh=RDhCmAJ56pnkwk2maKHLLimX8rlQ3eOcOj6fRl6dtcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o8hcAukUc/136Z764ZHCUfuA0xEGzDwcdRmY8aRU3m8yBQiONFZ3bpZVfAk/qoipz0U0XiSJtjjjgVnRBpMXSFNiMSm1s5yEC6xW2kgwhucOe1VNWcB0YXaPhW55LXTGSYLu2U3y/snA1Kay9h+9TQFxVvdcH5MSFrsHDSbCWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5435150C;
	Mon,  4 Aug 2025 05:17:29 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 470243F738;
	Mon,  4 Aug 2025 05:17:34 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	ry111@xry111.site,
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
	suzuki.poulose@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 02/11] arm64: make SCTLR2_EL1 accessible
Date: Mon,  4 Aug 2025 13:17:15 +0100
Message-Id: <20250804121724.3681531-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250804121724.3681531-1-yeoreum.yun@arm.com>
References: <20250804121724.3681531-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

make SCTLR2_EL1 accssible to initilise it.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 9f38340d24c2..33b59601e8c2 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -57,9 +57,15 @@
         /* Enable GCS if supported */
 	mrs_s	x1, SYS_ID_AA64PFR1_EL1
 	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
-	cbz	x1, .Lset_hcrx_\@
+	cbz	x1, .Lskip_hcrx_GCSEn_\@
 	orr	x0, x0, #HCRX_EL2_GCSEn

+.Lskip_hcrx_GCSEn_\@:
+	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
+	ubfx	x1, x1, #ID_AA64MMFR3_EL1_SCTLRX_SHIFT, #4
+	cbz	x1, .Lset_hcrx_\@
+	orr	x0, x0, HCRX_EL2_SCTLR2En
+
 .Lset_hcrx_\@:
 	msr_s	SYS_HCRX_EL2, x0
 .Lskip_hcrx_\@:
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


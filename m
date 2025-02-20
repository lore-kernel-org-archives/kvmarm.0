Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55AF1F892D
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060863; cv=none; b=o4EwQAhgYBLt08DGw4wM7RTIRg4LZlWv/wS68qREXbtJuhtYW2sBuEFtRDGmmFiHnfroWt3+R0ZanOobzLLaXq0No6v7//+FJV7JCM4c6FKdn53NcIglQ3uMUIUQdXfMctauK37euiepbIcH/EZ68j/eskHE+YnVrJMDeYsrHYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060863; c=relaxed/simple;
	bh=TnsB6W7oVq8pi6s+GL2z4jqeBf3HSO8+1U4kvFDCpZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i5LDhbOq5aZokCaSzJzxVt8aZmnd0TKVnaMOgxe7HiiBrfgK5i8f5Hv01t8G5TFVftHXG5qcSnFJake6e0NPgjPvZJgnsvr3vwj2XwqM9E+a4A9nc2Tma9DyjFnQo3B1xjCebIy4/glsTAFUS77g7hxJSk4i6pHsg7J6zi49Q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DBB62BC3;
	Thu, 20 Feb 2025 06:14:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B94583F59E;
	Thu, 20 Feb 2025 06:14:19 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 7/7] arm64: run at EL2 if supported
Date: Thu, 20 Feb 2025 14:13:54 +0000
Message-Id: <20250220141354.2565567-8-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250220141354.2565567-1-joey.gouly@arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If VHE is supported, continue booting at EL2, otherwise continue booting at
EL1.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart64.S         | 28 ++++++++++++++++++++++++++++
 lib/arm64/asm/sysreg.h |  5 +++++
 2 files changed, 33 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 3a305ad0..2a15c03d 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -68,6 +68,20 @@ reloc_done:
 	mrs	x4, CurrentEL
 	cmp	x4, CurrentEL_EL2
 	b.ne	1f
+	/* EL2 setup */
+	mrs	x4, mpidr_el1
+	msr	vmpidr_el2, x4
+	mrs	x4, midr_el1
+	msr	vpidr_el2, x4
+	/* check VHE is supported */
+	mrs	x4, ID_AA64MMFR1_EL1
+	ubfx	x4, x4, ID_AA64MMFR1_EL1_VH_SHIFT, #4
+	cmp	x4, #0
+	b.eq	drop_to_el1
+	ldr	x4, =(HCR_EL2_TGE | HCR_EL2_E2H)
+	msr	hcr_el2, x4
+	isb
+	b	1f
 drop_to_el1:
 	mov	x4, 4
 	msr	spsr_el2, x4
@@ -200,6 +214,20 @@ secondary_entry:
 	mrs	x0, CurrentEL
 	cmp	x0, CurrentEL_EL2
 	b.ne	1f
+	/* EL2 setup */
+	mrs	x0, mpidr_el1
+	msr	vmpidr_el2, x0
+	mrs	x0, midr_el1
+	msr	vpidr_el2, x0
+	/* check VHE is supported */
+	mrs	x0, ID_AA64MMFR1_EL1
+	ubfx	x0, x0, ID_AA64MMFR1_EL1_VH_SHIFT, #4
+	cmp	x0, #0
+	b.eq	drop_to_el1
+	ldr	x0, =(HCR_EL2_TGE | HCR_EL2_E2H)
+	msr	hcr_el2, x0
+	isb
+	b	1f
 drop_to_el1_secondary:
 	mov	x0, 4
 	msr	spsr_el2, x0
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f214a4f0..d99ab5ec 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -75,6 +75,8 @@ asm(
 
 #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
 
+#define ID_AA64MMFR1_EL1_VH_SHIFT	8
+
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
@@ -99,6 +101,9 @@ asm(
 #define SCTLR_EL1_A		_BITULL(1)
 #define SCTLR_EL1_M		_BITULL(0)
 
+#define HCR_EL2_TGE    _BITULL(27)
+#define HCR_EL2_E2H    _BITULL(34)
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
-- 
2.25.1


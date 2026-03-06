Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1437D1A6821
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807230; cv=none; b=HtAeCr4b7kS+3IH0S/CMqkm49zsaeOek85zRFYtJAs5eYvRyvy9f/ovYzMb5+Ri1hYLb4jNOXzGpFtRe6/fBRSH4JkXQMj86C96oxnATn0GmjEPPVUNJPYp4Wi/oqPZydUsiruZGFa4HJLOxPNP3Vpa908Kly37uw+A2Q3MUmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807230; c=relaxed/simple;
	bh=IM3e4emtSyO50urLeXZRGynh7LXVC2GJ060K6kLUJ24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I1QHSxzFRSDCI2baVeejw8qTn+9+EuK2ywHvtiCXTijAY3n6U4Oqe4cnb+90cMhE4fpL4d+Em9sZxYf3rUYaHxa6zlGDP3Wx11pbtchkTnPpT4kysJ0oct2NQSoxSdX3WJE0D4AKQ/iVWp7QOec45CVjvKz5/61HOAq90W6mU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5991A1682;
	Fri,  6 Mar 2026 06:27:02 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8C8C3F73B;
	Fri,  6 Mar 2026 06:27:07 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1 3/5] arm64: context switch SP_EL0/SP_EL1 depending on context
Date: Fri,  6 Mar 2026 14:26:54 +0000
Message-Id: <20260306142656.2775185-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260306142656.2775185-1-joey.gouly@arm.com>
References: <20260306142656.2775185-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no hypverisor context to store SP_EL0/SP_EL1 separately. Until more
hypervisor features are needed, store SP_EL0 or SP_EL1 in pt_regs based on
which exception level the exception originated from.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart64.S         | 24 ++++++++++++++++++++++--
 lib/arm64/asm/sysreg.h |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 23505bee..d95a8245 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -383,11 +383,31 @@ exceptions_init:
 	ret
 
 .macro mrs_sp, reg
+	mrs	\reg, CurrentEL
+	cmp	\reg, #CurrentEL_EL2
+	b.ne	1f
+	mrs	\reg, SPSR_EL2
+	and	\reg, \reg, #SPSR_EL2_M
+	cbz	\reg, 1f
+	mrs	\reg, sp_el1
+	b	2f
+1:
 	mrs	\reg, sp_el0
+2:
 .endm
 
-.macro msr_sp, reg
+.macro msr_sp, reg, tmp
+	mrs	\tmp, CurrentEL
+	cmp	\tmp, #CurrentEL_EL2
+	b.ne	1f
+	mrs	\tmp, SPSR_EL2
+	and	\tmp, \tmp, #SPSR_EL2_M
+	cbz	\tmp, 1f
+	msr	sp_el1, \reg
+	b	2f
+1:
 	msr	sp_el0, \reg
+2:
 .endm
 
 /*
@@ -446,7 +466,7 @@ exceptions_init:
 
 	.if \vec >= 8
 	ldr	x1, [sp, #S_SP]
-	msr_sp	x1
+	msr_sp	x1, x2
 	.endif
 
 	ldr	x30, [sp, #S_LR]
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f2d05018..ba33fcd9 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -132,6 +132,8 @@ asm(
 #define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
+#define SPSR_EL2_M	0xf
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
-- 
2.25.1


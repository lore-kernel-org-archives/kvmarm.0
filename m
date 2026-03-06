Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F7C3002B9
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807229; cv=none; b=Eu2EzNIO8BZT5gN+U87t3KKsM4KJevS0mpZZ5LT/mDSrlyPl2IYK2wgNNMuVQl+rFMWUCDdhcp4WBE+EmO9ese9y/+lt9PtDp1k56oOVkQ9GebsBJTpuWZJ/k8B4XyUeKabjdKqczpD7+nxFkNNsQZFdwaJbJDRMsg8FBR1xJ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807229; c=relaxed/simple;
	bh=2wj4TwWlpNYzSHAt+10YQF8rlYhFImMy/jKE/ATO2vA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A4uuT46kbOZKcIhVBd16/QHnL41jV+YQMKq3Nknr2wBddEMIrbLzC1aLPXdGCAf+dKPmH7L64XjrsBHnic/G8axnBvZfu1j1s/vVoQR7Nv/mwdC1d/t5siftBR70rfza8tGN4ia5GLuQnE4FVVN+ZFOJmmdcXU/YDVoNY6Nm54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 378221655;
	Fri,  6 Mar 2026 06:27:01 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 965143F73B;
	Fri,  6 Mar 2026 06:27:06 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1 2/5] arm64: add macros for manipulating SP
Date: Fri,  6 Mar 2026 14:26:53 +0000
Message-Id: <20260306142656.2775185-3-joey.gouly@arm.com>
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

These will be extended to support different exception levels.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/cstart64.S | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 49cf8ed6..23505bee 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -382,6 +382,14 @@ exceptions_init:
 	isb
 	ret
 
+.macro mrs_sp, reg
+	mrs	\reg, sp_el0
+.endm
+
+.macro msr_sp, reg
+	msr	sp_el0, \reg
+.endm
+
 /*
  * Vector stubs
  * Adapted from arch/arm64/kernel/entry.S
@@ -410,7 +418,7 @@ exceptions_init:
 	str	x30, [sp, #S_LR]
 
 	.if \vec >= 8
-	mrs	x1, sp_el0
+	mrs_sp	x1
 	.else
 	add	x1, sp, #S_FRAME_SIZE
 	.endif
@@ -438,7 +446,7 @@ exceptions_init:
 
 	.if \vec >= 8
 	ldr	x1, [sp, #S_SP]
-	msr	sp_el0, x1
+	msr_sp	x1
 	.endif
 
 	ldr	x30, [sp, #S_LR]
-- 
2.25.1


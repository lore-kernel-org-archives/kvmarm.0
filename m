Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4E2284B37
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 08:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138567; cv=none; b=YcZzyJ29F9rBm7tQYOlBPF3eDOcx0Vsit5Ax+uvODAkNaFSjZZxFOHYo2A6SbuyjciabuA4I/fxCeSITJZHC06/xzw5MSkltnX4Yc82J9csAWxfNBP0TxEa1CJkboRE3AV07wvoDRS4mE70kFJ+bQqilh1tuBtLWBWoe4jmF4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138567; c=relaxed/simple;
	bh=TZE6sUf/S8FoDtbPPweh9nK7pgeHraoLy/S4W8tvQQk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jbCtVfCRgvap90F+3+mrvOYA0M6tOvz8T+7DZOenBJs+xM4fCEX5Vd1iagsDJe2pzXgdrgtdt8OmMGyTBQJAR+5F9p9c9CpAuc0wzUWX6mZWNMOoQ/QqY7GCCqAXrfWsuUYGSqXwUjUmd807aJYrL8DOQtNCJMeoKwwWatysFYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sNwThq5T; arc=none smtp.client-ip=95.215.58.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sNwThq5T"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TZE6sUf/S8FoDtbPPweh9nK7pgeHraoLy/S4W8tvQQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792138562; v=1; x=1792743362;
 b=sNwThq5T7I2TpNa1qI2/dNmu6gKPuMKQRqw6+wN2DQuRobDHWFQTRVQNIRkOSGzyzhqlRtt4
 7heu+1Yif/cKa1MQQbfyeM1vCtrkXOhFlQxsS2TyWGbUEXtY0iUnXBg9xtj6Da7y3h2iA1CwlZd
 bvL3ELzPHIinfe/9bVY1a3Ok=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a7304d26f9b833f3;
	Fri, 16 Oct 2026 08:16:02 +0000
X-Mizu-Trace-ID: a7304d26f9b833f3
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests
Date: Fri, 16 Oct 2026 09:15:58 +0100
Message-Id: <20261016081558.805411-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM sets HCR_EL2.BSU to Inner Shareable for guests, so that a guest's
barriers cover the TLB and I-cache invalidations that HCR_EL2.FB
broadcasts. However, since HCR_BSU_IS became an alias of the generated
HCR_EL2_BSU_IS, it is the unshifted field value 0b01, which sets bit
0 (VM, already set) and leaves BSU at 0b00. A guest's DSB NSH is then
not required to wait for a broadcast TLBI to complete on other CPUs.

Build the field with SYS_FIELD_PREP_ENUM().

Fixes: d0f39259eff4 ("arm64: sysreg: Add layout for HCR_EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Found while testing Marc's HCR cleanup [1]. Its patch 1 carries this
line over as HCR_EL2_BSU_IS, so on top of this fix that hunk would
keep SYS_FIELD_PREP_ENUM() instead. I can also rebase this on top of
the series if that's easier.

[1] https://lore.kernel.org/r/20261015173605.1072963-1-maz@kernel.org

 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4bfbd827c5aa7..b3e9dd302730e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -98,7 +98,7 @@
  * TID1:	Trap REVIDR_EL1, AIDR_EL1, and SMIDR_EL1
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
+			 SYS_FIELD_PREP_ENUM(HCR_EL2, BSU, IS) | HCR_EL2_FB | HCR_EL2_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
-- 
2.39.5


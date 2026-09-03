Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E0C4AE138
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451602; cv=none; b=ljyyzpJ1FedZ3Sp3UVoDxn51503oPKwtQYPJXr0GU47BC4qwVRbDwGhpc2vVcgunSDuQcURERvubdI1PX9NUMctRyCkxC7KOnGTpDXgPlmUC1GDi9pDJsEsMH+PcCamYX/CfvUQaopkNrFa0TFCuyP3WVVBvfMXPdBKh1jz92ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451602; c=relaxed/simple;
	bh=+u9LjHH89m68GUjK/C5Dy4Vs+z0e4soWaEubuApexkE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK3e9ci87SYsTxKI0YWXtjzdDeJv6gWX56tctr5E+a9L9w1h/iYthqNeRAM6ArmtzD+86BLVnoppUvIoV+ZVDBgmxO9MnBS1ECEQA0dbSS4a9hZD0qw2sL6A2p1gfODzIevoj+iGD3HN/0Jtn49CJRHkQiWgvIg5Nnw40GYBRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nm/0Ky3q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nm/0Ky3q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E51B71D34;
	Thu,  3 Sep 2026 09:06:35 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB4D93F673;
	Thu,  3 Sep 2026 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451599; bh=+u9LjHH89m68GUjK/C5Dy4Vs+z0e4soWaEubuApexkE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nm/0Ky3qNosRJu7gBZpoyWEukBwzxHMiGJHn5pJP2eqAyjVFxu5ILMDviTw3FoolE
	 lCoU1ezDcQKqtQADujKiaTeS/mJ5uUVMae4g9HFmqa+X2riRaBs8G+WV5K0LU3RjmN
	 PTjcnTrhHELxjochl68G8RwrGFVkGKLGWCk+RM5A=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 02/28] arm64/sysreg: Define MDCR_EL2.E2PB values
Date: Thu,  3 Sep 2026 17:05:57 +0100
Message-ID: <20260903160623.315525-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM will make use of the different values for MDCR_EL2.E2PB, document them.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a11a968eb707..4485736a4f49 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4045,7 +4045,12 @@ Field	17	HPMD
 Res0	16
 Field	15	EnSPM
 Field	14	TPMS
-Field	13:12	E2PB
+UnsignedEnum	13:12 E2PB
+	0b00	EL2
+	0b01	RESERVED
+	0b10	EL1_TRAP
+	0b11	EL1
+EndEnum
 Field	11	TDRA
 Field	10	TDOSA
 Field	9	TDA
-- 
2.43.0


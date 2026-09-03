Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A08C311968
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451613; cv=none; b=Mmv/luURoSjVzgtpp08D6h4R3pzYfP0zp9LDAbpL2+jgz0nk2DJbwa/TKCR6f6zZtQLZ+5qwb8yx3Wc62fJ+UcK5GqsD6LQkXdA52ZbcGzWRPBBXKX5huOYekAESB3e48WNeTRLdqHbk/HYis+65lcHH6IpdsYXmDvt3/TAI/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451613; c=relaxed/simple;
	bh=ppWn8zxveAr9HnN+Ue1ihaXYa9wTPVehLcQtaWF0KrA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mmb1+1zlrHAKHtuxoQKhR9MQe2ASVpqBdBlnhi8lVE8tA75guD0i5GTLQwMuwswdNuq9eRbj4Gd79t7tB0rnW3PwGdyGlfLHjdSKiiA05gP2OYJBTBFpIAVc4ZNT2m2DmTKTcwIrfxwPfZp9102CzxIHiSy0k5JcO4I9IS1MfkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aetRBJc5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aetRBJc5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F85C1650;
	Thu,  3 Sep 2026 09:06:48 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43FD93F673;
	Thu,  3 Sep 2026 09:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451612; bh=ppWn8zxveAr9HnN+Ue1ihaXYa9wTPVehLcQtaWF0KrA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aetRBJc5PZWQ1UkyNsOnC/mYjjacSfvMMK14/JoLlaOy4Co7lejhoC0cR3grQC8dW
	 WFPaJ2Xmxywb6q7NxVWpVe/jazif4dVGyvcPMjk0hfK9u2b9ZQWy+S2L3QkRSIrT/n
	 lRcS4YPZAF+gEsdwJHBjNZer4RubrtDbbJuaFXy0=
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
Subject: [RFC PATCH v7 08/28] HACK! KVM: arm64: Disable SPE virtualization if protected KVM is enabled
Date: Thu,  3 Sep 2026 17:06:03 +0100
Message-ID: <20260903160623.315525-9-alexandru.elisei@arm.com>
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

For RFC only.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/spe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 646806a60d66..97160d1fae81 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -22,6 +22,10 @@ void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
 {
 	struct spe_pmu_entry *entry;
 
+	/* TODO: pKVM support */
+	if (is_protected_kvm_enabled())
+		return;
+
 	guard(mutex)(&spe_pmus_lock);
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-- 
2.43.0


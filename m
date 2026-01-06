Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF62D33F364
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721047; cv=none; b=rOBCbAwjJtY4S7nec+i7Cp/2wJe4CksPQb/BZo7IMDumc5z2N9z2lGxaokwU5QcRyfb9DyHN8hg51Amq7w4rDg22bObpiyNUYlHKSVEvd7xKjYsszjQXuG0l4gFhWQ6I1vL7q32ls56fIMSvjY3N1FXxYuYjlRutIgg9geRWUG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721047; c=relaxed/simple;
	bh=T+1g9WFl2Z7a7kG6Umtny2c2mHHvN8QgWIQKWTKCQHM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kYxuEzkVmqTs9GolHDRwMtnGM9hSIqor4BTAzOCbkgdX6T7xKwabS0vL2vKzcGesYlDMxXR8FUIMn0vA7jecJJ8nSTvljEBrRqk2cT2o8B56ULb4Vf4WxTHqlGu8oqRDLTiUsYMeYVRfFDDdXTDMnNbt1K2B3VP6gIpV1q+FMmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F2611596;
	Tue,  6 Jan 2026 09:37:18 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 80AA43F5A1;
	Tue,  6 Jan 2026 09:37:23 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 2/3] KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
Date: Tue,  6 Jan 2026 17:37:06 +0000
Message-Id: <20260106173707.3292074-3-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260106173707.3292074-1-mark.rutland@arm.com>
References: <20260106173707.3292074-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's a gap in the KVM_HOST_DATA_FLAG_* indices since the removal of
KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED and
KVM_HOST_DATA_FLAG_HOST_SME_ENABLED in commits:

* 459f059be702 ("KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN")
* 407a99c4654e ("KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN")

Shuffle the indices to remove the gap, as Oliver requested at the time of
the removals:

  https://lore.kernel.org/linux-arm-kernel/Z6qC4qn47ONfDCSH@linux.dev/

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c78830..4c8b4274f669e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -710,11 +710,11 @@ struct cpu_sve_state {
 struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_SPE			0
 #define KVM_HOST_DATA_FLAG_HAS_TRBE			1
-#define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
-#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
-#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		6
-#define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		7
-#define KVM_HOST_DATA_FLAG_HAS_BRBE			8
+#define KVM_HOST_DATA_FLAG_TRBE_ENABLED			2
+#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	3
+#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
+#define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
+#define KVM_HOST_DATA_FLAG_HAS_BRBE			6
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
-- 
2.30.2


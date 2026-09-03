Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AE34AE13B
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451603; cv=none; b=XTlrmThs7gOL6qFR1r7mZEl7IVeYEPL3x5fHILYR93UOiyKiLXlKdeJFu3HsQKtM0LtU8Sb37Z2uz6ReOtH0srw2FNFswuhey2lK+TP6PVzgYf2uEtQLrowS81LUtfGrtlb5rfHHzg/AA0+tIZxigkmU3QCG83FCo1CftHrjSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451603; c=relaxed/simple;
	bh=KRsytHCjVYrI/He9Vivq384CY+lKsfqtVtL5OpWLDQE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpZjJRN6ahH0cwcAVuZ2d84RQywj0Pbkjdx1tVm+0P70cMGf9LWZWGV+AsFtHIBbpdmmLdGkcUE0R72tYx99z9T7BiFl27Yv9B4q7RkBqj2Dmau4mIGkrHhnzWkQ/GUV4KvLh4P2NMJZ+Ckgo3BrV7tEA4jDvEDkLCEBo12Bc4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XMG4YcD7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XMG4YcD7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 022521596;
	Thu,  3 Sep 2026 09:06:38 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB0833F673;
	Thu,  3 Sep 2026 09:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451601; bh=KRsytHCjVYrI/He9Vivq384CY+lKsfqtVtL5OpWLDQE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XMG4YcD79DKgN3anhQzRYRyNe+6ozkgII7QCHy5x8wnM1Gr3j2dg9d9IoLI5XyIVm
	 iIWLcjIUX3XyOzeGt05GKBt5r/ebZLjYG5YFHQP+G+5kWkAtdrBI9YjnA5ZXSzYy0Q
	 B2KzDl6QraImVpPcBNfDxWcrqTFnEpI/jmgdUTQI=
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
Subject: [RFC PATCH v7 03/28] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig option
Date: Thu,  3 Sep 2026 17:05:58 +0100
Message-ID: <20260903160623.315525-4-alexandru.elisei@arm.com>
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

Add a new configuration option that will be used for KVM SPE emulation.
CONFIG_KVM_ARM_SPE depends on the SPE driver being loaded because:

1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
   and that will be used by KVM to emulate SPE on heterogeneous systems.

2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
   level.

The option will become user selectable after SPE support in KVM is
implemented.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..fece4c02b97c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -103,5 +103,14 @@ config PKVM_STACKTRACE
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
 endif # NVHE_EL2_DEBUG
+
+config KVM_ARM_SPE
+	bool
+	depends on KVM && ARM_SPE_PMU
+	default n
+	help
+	  Adds support for Statistical Profiling Extension (SPE) in virtual
+	  machines.
+
 endif # KVM
 endif # VIRTUALIZATION
-- 
2.43.0


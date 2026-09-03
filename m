Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C30A305693
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451656; cv=none; b=efqzVQbUrUdTao3kixH075CPCKrnrh3GWBza1JwzzHdi1WPdeI4sC4PHf2YaYfRdgVnkRgjEyVFHnHU5vEcgvnG2sDKJexJLhoEp/FCjM2ediVWJMtGaBsntulXpeinCLZM1E69Qdf/26cuo2d7gkuwIWANwTgUNrYzh9aRjNfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451656; c=relaxed/simple;
	bh=U+rws8ncwi/1wkVpb63POq0o8EKKy0KoxPOz8nkpieE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSel8socjP0dmpa2qvKvQ0F1H1n7/N1h5xv6J/mujSvcqW07RdZ46LF65ze1sZfSO6y6PrjX1pwBWvljaQO2rxmQgPt7WbznXZatfCEDIXLSkpu/OVHW8LuVOhS5Vm2Cw66wFLwW1K4MHqtCxXEdhp02hZGyheXVkn6Be8TY7aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Liev/w0I; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Liev/w0I"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 278391F60;
	Thu,  3 Sep 2026 09:07:30 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DD4F3F673;
	Thu,  3 Sep 2026 09:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451653; bh=U+rws8ncwi/1wkVpb63POq0o8EKKy0KoxPOz8nkpieE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Liev/w0Iu/6EmrygmtTnUunzJIhWUHrQ2R5os86hWdDuXxaUMjtKdfi/IPYqwTiOp
	 agQw37H3yDq+Jzydau7AEG78scr7kUz5Rv94aLD3/+/rWZ1S5NTRM+w8UKsRfgJjnV
	 zcJwwxxnHKgNAz2zAPLlUSwKSiUuOEBqPbs4lq1I=
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
Subject: [RFC PATCH v7 28/28] KVM: arm64: Allow the creation of a SPE enabled VM
Date: Thu,  3 Sep 2026 17:06:23 +0100
Message-ID: <20260903160623.315525-29-alexandru.elisei@arm.com>
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

Everything is in place, allow userspace to enable SPE for a virtual
machine.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/Kconfig            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ff77f6ac3adf..32b30ffdcf77 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -40,7 +40,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 10
+#define KVM_VCPU_MAX_FEATURES 11
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2bc8e34c538d..a285b18eb1cc 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -106,9 +106,9 @@ endif # NVHE_EL2_DEBUG
 
 
 config KVM_ARM_SPE
-	bool
+	bool "Support SPE in guest"
 	depends on KVM && ARM_SPE_PMU
-	default n
+	default y
 	help
 	  Adds support for Statistical Profiling Extension (SPE) in virtual
 	  machines.
-- 
2.43.0


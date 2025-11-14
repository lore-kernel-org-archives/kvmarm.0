Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E849628314C
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136544; cv=none; b=dKSuV3xoqrBHqcv+xN2rzhIS1CCx75u9gnv0U/IAN+3s3w152jDYaefVVAxCkvw2X1SsFrYloFpwydGqQ0wihgPJYq8cUknjZrPNalT8eT/7tAtUtJUQPrtSBy5KN97nYy6tk/eRc+WOI88JMgTlJDWJp1F9X6X4CO2hEkC4sBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136544; c=relaxed/simple;
	bh=RmB4j4oqzdbJPAwLvZwU4vW/9oqI+knA/4vk8u1u/Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzGsY/tewde8xNlWf4xTmvVPBd3DTi43CA9nQk6MlavRt6P8ZdYH+YMSx7GNZiyWlAf8S0hLEGh0CKKr2C3gqk9dGcdPl9BOqu/W4+/EHrgzxyEY4j9fVogrT6gjV19CQ2c7fTxv/cFWFO7TZWj4/Ji1l4MjOYBvHsV94zNMpAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3CDF1BF7;
	Fri, 14 Nov 2025 08:08:54 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 640933F5A1;
	Fri, 14 Nov 2025 08:09:00 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 35/35] KVM: arm64: Allow the creation of a SPE enabled VM
Date: Fri, 14 Nov 2025 16:07:16 +0000
Message-ID: <20251114160717.163230-36-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
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
index b730401717b5..1c987274556e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -40,7 +40,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 9
+#define KVM_VCPU_MAX_FEATURES 10
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 31388b5b2655..f746df3c2c28 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -84,9 +84,9 @@ config PTDUMP_STAGE2_DEBUGFS
 	  If in doubt, say N.
 
 config KVM_ARM_SPE
-	bool
+	bool "Support SPE in guest"
 	depends on KVM && ARM_SPE_PMU=y
-	default n
+	default y
 	help
 	  Adds support for Statistical Profiling Extension (SPE) in virtual
 	  machines.
-- 
2.51.2


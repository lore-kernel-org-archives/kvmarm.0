Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCCA1D6DBC
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079749; cv=none; b=WY3+SxsKxIkd490U33bSw3tLHKuij4Yj7B8I/1T0HDA0h1Wv71B94r6eDjyKnzO6sZ/gTJtJtjU2OqSUFTIbP1rxmL5GEJvY/NQX8huOBRR9+bKuvbCAjc0VYIMxiTpcoHc2JqBQMBEGEgqmhTSBZKRo+JwNYv2uSaio0EsoDrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079749; c=relaxed/simple;
	bh=Isgasofx9wEUgfRqbFGlCPnfnMQpp6lZ/GJKuj9LXzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NZT7rpFo4+qdfTfdVbeIMGxYrGaC7ucp+CfaaqaIJPXHrDHwKP7d4uYxs33DhzyG5tlg5jedZgEW1WmWF4avePONNIzdug0m47UwBcNG1mzKSVn071EyMAdyfeCxBrwHb2yoW/ZiT7ZxQv6hGbfkdP0QKoRtgZ9C1/NcJlgPu3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E2EC497;
	Tue, 28 Jan 2025 07:56:13 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 30EA63F694;
	Tue, 28 Jan 2025 07:55:45 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH 1/4] arm64: cpufeature: rename unmap_kernel_at_el0() -> needs_kpti()
Date: Tue, 28 Jan 2025 15:54:25 +0000
Message-Id: <20250128155428.210645-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250128155428.210645-1-mark.rutland@arm.com>
References: <20250128155428.210645-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most arm64_cpu_capabilities::matches callbacks are named to indicate
that they test a boolean condition, e.g. runs_at_el2() or
has_nested_virt_support(). This isn't clear for unmap_kernel_at_el0(),
which can be read as an action rather than a boolean condition, and it's
not immediately clear that this is related to KPTI.

Rename unmap_kernel_at_el0() to needs_kpti() to make this clearer.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed84..8fdcff3722696 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1758,8 +1758,7 @@ has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
 static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
-static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
-				int scope)
+static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	/* List of CPUs that are not vulnerable and don't need KPTI */
 	static const struct midr_range kpti_safe_list[] = {
@@ -2545,11 +2544,10 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
 		.type = ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE,
 		.cpu_enable = cpu_enable_kpti,
-		.matches = unmap_kernel_at_el0,
+		.matches = needs_kpti,
 		/*
-		 * The ID feature fields below are used to indicate that
-		 * the CPU doesn't need KPTI. See unmap_kernel_at_el0 for
-		 * more details.
+		 * The ID feature fields below are used to indicate that the
+		 * CPU doesn't need KPTI. See needs_kpti for more details.
 		 */
 		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, CSV3, IMP)
 	},
-- 
2.30.2


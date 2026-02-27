Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0674535A3A7
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211596; cv=none; b=uPLJYPX+g/j3daGVjyAjQXXYZod1FIy63FUxnwGY/mg11yEEXvedwQn6aDK56HwNg5bNFfrYrelctagwYxj2SSLWbKBW5PYZDDOXKmhY7WpKq5CCb4vzuPZiLe1RgGk4/Cbjw79eq1YEqOZgn32l/MiUPZ2CVLpR1A4Bx28TQLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211596; c=relaxed/simple;
	bh=btyywYT33i0Lf9IQcTmns7XcT2/j2rYyQM4kWBIrhUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMRYiU8hxxstWs9TaRCr/Kx/sebH0MgmRVDKE+pusWSjzfyfi+SF4a9bGFBCS5xPzQWebD8dldYBVHsOkyyK34zVVHccHXLtjiU/fn+iciKe93SgOkaDmdtM+2gOhLhQKkuRifA+udXWtfOYaaehI7+LW95T1vxiZcC3DgRNMRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6864614BF;
	Fri, 27 Feb 2026 08:59:47 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5D6A63F73B;
	Fri, 27 Feb 2026 08:59:52 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 10/17] arm64: Add support for finding vCPU for given MPIDR
Date: Fri, 27 Feb 2026 16:56:17 +0000
Message-ID: <20260227165624.1519865-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-arch.h |  2 ++
 arm64/kvm.c                  | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index 8f508ef8..a50e6a4f 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -114,4 +114,6 @@ struct kvm_arch {
 	cpu_set_t *vcpu_affinity_cpuset;
 };
 
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 23b4dab1..41c47b13 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -5,6 +5,7 @@
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
 #include "kvm/gic.h"
+#include "kvm/kvm-cpu.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
@@ -128,6 +129,22 @@ void kvm__arch_init(struct kvm *kvm)
 	kvm__arch_enable_mte(kvm);
 }
 
+
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
+{
+	int i;
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp) & ARM_MPIDR_HWID_BITMASK;
+
+		if (mpidr == target_mpidr)
+			return tmp;
+	}
+
+	return NULL;
+}
+
 static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
 {
 	if (kvm->cfg.arch.aarch32_guest)
-- 
2.43.0


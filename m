Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E120B136358
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136514; cv=none; b=AMIFDHP8XdhST6W90g5ahxtm1VVTfdjvcrnPw12ebD02ztZdh0rF8OYuGWP49vQpX7e0UmS8n186mvFmU46EvU8sFudjtM+UBZi9hQ0HiyrBZZMPnU4yLlHi6dA1Q5Gf/PZxCebPqI96D2AR3kJZ3aPJRnaPAN0D5k1kWR18Gas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136514; c=relaxed/simple;
	bh=fDsmU7nDm5iuwW5Iq0xj/Mb4YkBMT7oGpJ6QLonHUL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7n3s3b2Yp1dLU3WTkFGcHBuuTGKeWHsYCnwM6s+0I8cgJQoCnsNJ2kGKD9+m5/I+yWIkWw/YqJbim5Ncr6PW/vYyTIQqSy+hNi7gE3mCqRYuJHN1GQlysQPgl0mxq6ruasFLZWESFSylxFn93C0qaCSXQNIsMxVGpbG/PpnBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF7DB1BCA;
	Fri, 14 Nov 2025 08:08:24 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F7A13F5A1;
	Fri, 14 Nov 2025 08:08:30 -0800 (PST)
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
Subject: [RFC PATCH v6 23/35] KVM: arm64: Allow guest SPE physical timestamps only if perfmon_capable()
Date: Fri, 14 Nov 2025 16:07:04 +0000
Message-ID: <20251114160717.163230-24-alexandru.elisei@arm.com>
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

The SPE driver allows userspace to use physical timestamps for records only
if the process if perfmon_capable(). Do the same for a virtual machine.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h |  1 +
 arch/arm64/kvm/spe.c             | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 077ca1e596b8..a61c1c1de76f 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -13,6 +13,7 @@
 struct kvm_spe {
 	struct arm_spe_pmu *arm_spu;
 	u64 max_buffer_size;	/* Maximum per VCPU buffer size */
+	u64 guest_pmscr_el2;
 };
 
 struct kvm_vcpu_spe {
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 32156e43f454..85a1ac8bb57f 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/capability.h>
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
@@ -64,6 +65,8 @@ void kvm_spe_init_vm(struct kvm *kvm)
 
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
 	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
 
 	if (!vcpu_has_spe(vcpu))
@@ -72,6 +75,12 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!vcpu_spe->initialized)
 		return -EINVAL;
 
+	if (kvm_vm_has_ran_once(kvm))
+		return 0;
+
+	if (perfmon_capable())
+		kvm_spe->guest_pmscr_el2 = PMSCR_EL2_PCT_PHYS;
+
 	return 0;
 }
 
@@ -217,8 +226,11 @@ void kvm_vcpu_spe_load(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 
 	host_pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
-	write_sysreg_el2(0, SYS_PMSCR);
-	/* Host was profiling, synchronize the write to PMSCR_EL2. */
+	write_sysreg_el2(vcpu->kvm->arch.kvm_spe.guest_pmscr_el2, SYS_PMSCR);
+	/*
+	 * Host was profiling, synchronize the write to PMSCR_EL2 with the guest
+	 * value which disables profiling at EL2.
+	 */
 	if (FIELD_GET(PMSCR_EL2_E2SPE, host_pmscr_el2))
 		isb();
 
-- 
2.51.2


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313BF3A963A
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413223; cv=none; b=ChZkzpfzIc1uOLVILU+pdAN/tP3Nym9HNWfZoSCR49mEINqxNN2Lfv5CeE0XeiEqyKyf/gMQt2KHHEh9BFgn0K57Z+Xl6PPq8xKwfDXLZiBZ3GkBdJgr8E0Vc6ijA1wgfC6uObWdcKl6q4+zYUCWrR/NRUDWAbcHVmzRDYBqj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413223; c=relaxed/simple;
	bh=s33mhE/ceA2bgjMWjPaX34TjQrQjX0xOaW9+OPVxsAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX0BAMFv89jF4C8J6z6eo6UCDgAP3oyW84m7/rAwSqhA7sQDifD0Wplkooqa3wwHT0mcSS7Z+BLCAEE2u0PG/jNbngVrN5pQlM+/j9I5Q4Iesx2EDx65qThqpHWZb89yXQdrPv455DLnWdH7J5N59r8LVR0CQ14pzcKJNSBCyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A32B244B;
	Fri, 13 Mar 2026 07:46:55 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9BBB03F7BD;
	Fri, 13 Mar 2026 07:46:57 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: ben.horgan@arm.com
Cc: amitsinght@marvell.com,
	baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com,
	carl@os.amperecomputing.com,
	dave.martin@arm.com,
	david@kernel.org,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	gshan@redhat.com,
	james.morse@arm.com,
	jonathan.cameron@huawei.com,
	kobak@nvidia.com,
	lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peternewman@google.com,
	punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com,
	reinette.chatre@intel.com,
	rohit.mathew@arm.com,
	scott@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	zengheng4@huawei.com,
	linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v6 07/40] arm64: mpam: Re-initialise MPAM regs when CPU comes online
Date: Fri, 13 Mar 2026 14:45:44 +0000
Message-ID: <20260313144617.3420416-8-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

Now that the MPAM system registers are expected to have values that change,
reprogram them based on the previous value when a CPU is brought online.

Previously MPAM's 'default PARTID' of 0 was always used for MPAM in
kernel-space as this is the PARTID that hardware guarantees to
reset. Because there are a limited number of PARTID, this value is exposed
to user-space, meaning resctrl changes to the resctrl default group would
also affect kernel threads.  Instead, use the task's PARTID value for
kernel work on behalf of user-space too. The default of 0 is kept for both
user-space and kernel-space when MPAM is not enabled.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
CONFIG_MPAM -> CONFIG_ARM64_MPAM
Check mpam_enabled
Comment about relying on ERET for synchronisation
Update commit message

Changes since v3:
Always set MPAM1_EL1.MPAMEN rather than relying on it being read only
---
 arch/arm64/kernel/cpufeature.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a..c3f900f81653 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -86,6 +86,7 @@
 #include <asm/kvm_host.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
+#include <asm/mpam.h>
 #include <asm/mte.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
@@ -2492,13 +2493,17 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
 static void
 cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
 {
-	/*
-	 * Access by the kernel (at EL1) should use the reserved PARTID
-	 * which is configured unrestricted. This avoids priority-inversion
-	 * where latency sensitive tasks have to wait for a task that has
-	 * been throttled to release the lock.
-	 */
-	write_sysreg_s(0, SYS_MPAM1_EL1);
+	int cpu = smp_processor_id();
+	u64 regval = 0;
+
+	if (IS_ENABLED(CONFIG_ARM64_MPAM) && static_branch_likely(&mpam_enabled))
+		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
+
+	write_sysreg_s(regval | MPAM1_EL1_MPAMEN, SYS_MPAM1_EL1);
+	isb();
+
+	/* Synchronising the EL0 write is left until the ERET to EL0 */
+	write_sysreg_s(regval, SYS_MPAM0_EL1);
 }
 
 static bool
-- 
2.43.0


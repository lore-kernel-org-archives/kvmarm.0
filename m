Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFFE346AE4
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167963; cv=none; b=f/hZvb89QEyjKPzktD00PrvZDzJgUneREHmTY+fywim+EOZrbNGcbXjVfYK1u5Qr6UhdvXQmAFGyM67B18T1EsoPogGRKe42BeEp9+ORJX19A5vSOAI5BWafFVBApys1tcJ9gG9gEj1eZsbrQULZWY6dwbUlZTY/ZnyxznC/bdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167963; c=relaxed/simple;
	bh=butHYceKk79hV04Smp32hSvP9ZQzH5lHTiIZ4GG/wmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqbwRZhWNir7aLHiK5E/Hbv+UICsgzYLjqN3983qI36oDDXVvB4+UQL28mVSDghGnGgY+UTBX+czJ9YI5CsqvCQqw+6quC3GSRzPEyy2oGOgiX6BRINAGPDpn4aSKf5VRGr5qFgA8z4BMhSEYVV2sqZFaqkfr68aOOw5UvPCAiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB331650;
	Fri, 19 Dec 2025 10:12:33 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B27803F5CA;
	Fri, 19 Dec 2025 10:12:35 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [PATCH v2 08/45] arm64: mpam: Re-initialise MPAM regs when CPU comes online
Date: Fri, 19 Dec 2025 18:11:10 +0000
Message-ID: <20251219181147.3404071-9-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219181147.3404071-1-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
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

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
CONFIG_MPAM -> CONFIG_ARM64_MPAM
Check mpam_enabled
Comment about relying on ERET for synchronisation
Update commit message
---
 arch/arm64/kernel/cpufeature.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..0cdfb3728f43 100644
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
@@ -2483,13 +2484,17 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
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
+	write_sysreg_s(regval, SYS_MPAM1_EL1);
+	isb();
+
+	/* Synchronising the EL0 write is left until the ERET to EL0 */
+	write_sysreg_s(regval, SYS_MPAM0_EL1);
 }
 
 static bool
-- 
2.43.0


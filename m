Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AAD3A9DBA
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955917; cv=none; b=c2H9mX5IY5wRq2RTTeAz9Gu8F3OtOjFTeH44RCZ9i7VSNyLdfKCGHqchPXNFWa0N9nfhOymkOZ4NU4EBvBNdtu2zbtdPuUPNL3mYyj9/5jIe34zgVsXGcPgQDqVckp2vKuptUJmGgcBaMcqzc19J5UUa9gpEsZmivE96lzuv4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955917; c=relaxed/simple;
	bh=RrNCpV20xjxhcpPJE0G1wicCE/c65M91pp/h/ui6G8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqqsIHGeIu1Ag703cQOnup6aLo6bnH7g5cvpAEY9+VAF/5qoP2lII/XrNuXLmLUJ1J2tsVB/2XFxRf6bsaW2BL8pbQu+FyvGstVj39yqwN5pybPcp2qcvfqN1O8KGA3BEmzMJzwWj8u16FzzboGlUBxP5Ula1n7T2p2ZlgpTFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24664165C;
	Tue, 24 Feb 2026 09:58:29 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 862AA3F59E;
	Tue, 24 Feb 2026 09:58:30 -0800 (PST)
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
Subject: [PATCH v5 12/41] KVM: arm64: Use kernel-space partid configuration for hypercalls
Date: Tue, 24 Feb 2026 17:56:51 +0000
Message-ID: <20260224175720.2663924-13-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On nVHE systems whether or not MPAM is enabled, EL2 continues to use
partid-0 for hypercalls, even when the host may have configured its kernel
threads to use a different partid. 0 may have been assigned to another
task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
same partid as the kernel thread does on the host.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Use mask
Use read_sysreg_el1 to cope with hvhe

Changes since v3:
Set MPAM2_EL2.MPAMEN to 1 as we rely on that before and after
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..80e71eeddc03 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -638,6 +638,15 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	unsigned long hcall_min = 0;
 	hcall_t hfn;
 
+	if (system_supports_mpam()) {
+		u64 mask = MPAM1_EL1_PARTID_D | MPAM1_EL1_PARTID_I |
+			MPAM1_EL1_PMG_D | MPAM1_EL1_PMG_I;
+		u64 val = MPAM2_EL2_MPAMEN | (read_sysreg_el1(SYS_MPAM1) & mask);
+
+		write_sysreg_s(val, SYS_MPAM2_EL2);
+		isb();
+	}
+
 	/*
 	 * If pKVM has been initialised then reject any calls to the
 	 * early "privileged" hypercalls. Note that we cannot reject
-- 
2.43.0


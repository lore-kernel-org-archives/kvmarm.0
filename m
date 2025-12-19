Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB0C34B400
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167990; cv=none; b=C2L7NVxHynRJSfV+c3Utoe7u82CFs4dLsPFo/MsHUUd0/NuT2/eCXrvgVAF9czfFlTk1UhADyzMrFjCIWVGXMBqOqe9a3cy8OE5ydUqAKxVsmJR1vZBrsP5vOygOUTezaEshllod1+RhXiH16loilKqRctymoGweks4HrQJJ6aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167990; c=relaxed/simple;
	bh=HF4i+UeOKhpLiniwq2yQNzmGsmaIF8nfKMHCqd3uwjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0bFJ8AAjU88QawNawWczaT9wQlOmO1P+0b7bgHsBj0zvsbnrgORqWFJch2RnVoKOA7/2UIh6X76FuvTfX3/aaYyy1IMUZ0FypyWzlZCHaSfHRQbIHePC0BBixMZ1QzNCH6m5uHI+VG7vVNXnp7iExemiEy4U5mmwfyyVlog3mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA87DFEC;
	Fri, 19 Dec 2025 10:13:01 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 721DE3F5CA;
	Fri, 19 Dec 2025 10:13:04 -0800 (PST)
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
Subject: [PATCH v2 14/45] KVM: arm64: Use kernel-space partid configuration for hypercalls
Date: Fri, 19 Dec 2025 18:11:16 +0000
Message-ID: <20251219181147.3404071-15-ben.horgan@arm.com>
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

On nVHE systems whether or not MPAM is enabled, EL2 continues to use
partid-0 for hypercalls, even when the host may have configured its kernel
threads to use a different partid. 0 may have been assigned to another
task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
same partid as the kernel thread does on the host.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a7c689152f68..5c1de7e7dd38 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -635,6 +635,11 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	unsigned long hcall_min = 0;
 	hcall_t hfn;
 
+	if (system_supports_mpam()) {
+		write_sysreg_s(read_sysreg_s(SYS_MPAM1_EL1), SYS_MPAM2_EL2);
+		isb();
+	}
+
 	/*
 	 * If pKVM has been initialised then reject any calls to the
 	 * early "privileged" hypercalls. Note that we cannot reject
-- 
2.43.0


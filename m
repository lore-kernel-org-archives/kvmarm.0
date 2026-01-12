Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDD5376BD1
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237263; cv=none; b=kZ0tPF64SXAGRiy1jo8DYeaqISTmLt45gpPkuYKEqQJp5fVdLLvSijsQVNZbmozYpoJ0gWT8OaJfHLKnASs++kgimjz5gbnBKru/FhuJWkgHeFaeWVHuHIQIMghpkVZWFRfbCUBO3yXLym8yGG813xc5Oj+HvhzbHSIrH7Y1Xek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237263; c=relaxed/simple;
	bh=AS8YhttA5/91PC0YH7JhZt2zkFAUu5FdQg41LknMw/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g67dm7GXfIug8239bD8gSzKdzikn7mkGqBxqExX7nIRGYntbf5TtUIgMzIanxtsFkgSo1x/rs0FlpthYkwnjG0SS6/Hba7A4h1tJhFxOiRoxACwJwSmQaYGTCi2K7k0FIUj221lkVHlZQz6qHr9h2huj2XILtRTXvDwh6dLTd8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE9961516;
	Mon, 12 Jan 2026 09:00:54 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 89EA93F694;
	Mon, 12 Jan 2026 09:00:56 -0800 (PST)
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
Subject: [PATCH v3 13/47] KVM: arm64: Use kernel-space partid configuration for hypercalls
Date: Mon, 12 Jan 2026 16:58:40 +0000
Message-ID: <20260112165914.4086692-14-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
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
Changes since v2:
Use mask
Use read_sysreg_el1 to cope with hvhe
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a7c689152f68..ad99d8a73a9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -635,6 +635,14 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	unsigned long hcall_min = 0;
 	hcall_t hfn;
 
+	if (system_supports_mpam()) {
+		u64 mask = MPAM1_EL1_PARTID_D | MPAM1_EL1_PARTID_I |
+			MPAM1_EL1_PMG_D | MPAM1_EL1_PMG_I;
+
+		write_sysreg_s(read_sysreg_el1(SYS_MPAM1) & mask, SYS_MPAM2_EL2);
+		isb();
+	}
+
 	/*
 	 * If pKVM has been initialised then reject any calls to the
 	 * early "privileged" hypercalls. Note that we cannot reject
-- 
2.43.0


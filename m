Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64B31DED58
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896031; cv=none; b=bpTXL9P0B4uYk3WfF9Ch/9A0WmHGEu6pb8BiKtUQ+7hBkTMOo1/Q0OS6HtBxCdeEFJUZ+V6MMNQctjc56dBtNsixksL5LDUTqOkqjoaBrBqd3k+4Sm+4ksXisaoXhtjdiaelXc+YsTt5mKyZha3PVvqjfV4RS1lqJTR39ckA8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896031; c=relaxed/simple;
	bh=pLqpYVEEADnR92wsme21lW8E+CKrh98cNjiqTh4UPaE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UzZi2iXruOmIdIEzUIp0XEoulJxnVtDWijotCJPHWnAujCX28zBhewWA8N2SRvmbSUV0wPV5LIPs1Tez+MYhGI/+U/3JcacAeO2wXJAzQl93igBiKvDAdkaxjIMa7JiX/LVzw3HIsh/eNUN95EjVV19BrP5mj+m1P4B0zYzVE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84EAC339;
	Wed,  6 Nov 2024 04:27:37 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05A653F6A8;
	Wed,  6 Nov 2024 04:27:05 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: [PATCH] KVM: arm64: VHE: Initialize PMSCR_EL1
Date: Wed,  6 Nov 2024 12:26:54 +0000
Message-ID: <20241106122654.38234-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the pseudocode for StatisticalProfilingEnabled() from Arm
DDI0487K.a, PMSCR_EL1 controls profiling at EL1 and EL0:

- PMSCR_EL1.E1SPE controls profiling at EL1.
- PMSCR_EL1.E0SPE controls profiling at EL0 if HCR_EL2.TGE=0. KVM always
  clears HCR_EL2.TGE when running a VM.

When profiling is enabled in the host, and the host is running in nVHE mode
(HCR_EL2.E2H=0), KVM clears PMSCR_EL1.{E1SPE,E0SPE} before jumping into the
guest.

When profiling is enabled in the host, and the host is running at EL2
(HCR_EL2.E2H=1), KVM will not touch PMSCR_EL1.{E1SPE,E0SPE} before jumping
into the guest. PMSCR_EL1.{E1SPE,E0SPE} reset to an architecturally UNKNOWN
value, which means it might be possible that KVM unintentionally profiles
the guest when is running in VHE mode.

Clear PMSCR_EL1.{E1SPE,E0SPE} when setting up VHE mode to keep the
behaviour consistent and predictable.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Tested on the model, by setting the PMSCR_EL1.E1SPE and E0SPE bits in
__init_el2_debug to simulate a system where they reset to 1. Without the
patch, when the host is running at EL2, and the user is profiling the
kvmtool process, I can see records taken at EL1:

# perf record -e arm_spe// -- ./lkvm-static run -c2 -m512 -k Image -d disk -p earlycon

With this patch, those records disappear; and the size of perf.data has
been more than halved.

 arch/arm64/kernel/hyp-stub.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 65f76064c86b..df63f329d400 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -117,6 +117,8 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
 	bic	x0, x0, #(MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT)
 	msr	mdcr_el2, x0
+	// Disable profiling when running a virtual machine
+	msr_s	SYS_PMSCR_EL12, xzr
 
 	// Transfer the MM state from EL1 to EL2
 	mrs_s	x0, SYS_TCR_EL12
-- 
2.47.0


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD613446CF
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167953; cv=none; b=FqPstNX+CZSPb8upIYTRtLdTsGzjeAKOYNFrntnIsZZx33W8kEwn8QdwZjnVPl1dUi++nncbRtMaBILLkVdSlQgh0XC+xlcO1r4z71Sd9lwfqA7TqdmUCbbnujtWQJQ9M6/WnZ8ISsUh8I78y+hdefQElrG/sEkUWrDRqYghzgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167953; c=relaxed/simple;
	bh=0kRbcYReCYLKHHl8teK40W8k6urdnfAdEGWHwofeDRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Upg16J33V9kt5hyPf8+TImziLNumOOogcARZygjR0RIZlxbdBopJmN/gUKZnVlCdKafgwtKtEEaiECqcKCaxQyFZ2FMFEqFC9A9X1YIWXpLMpNp9WJoYwkknOQBgDma81e1k7ymsE67IGk+5eYmqztmhQwgmQnFzYg2PrfdZxxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9611A15A1;
	Fri, 19 Dec 2025 10:12:23 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E92C3F5CA;
	Fri, 19 Dec 2025 10:12:26 -0800 (PST)
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
Subject: [PATCH v2 06/45] KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
Date: Fri, 19 Dec 2025 18:11:08 +0000
Message-ID: <20251219181147.3404071-7-ben.horgan@arm.com>
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

The MPAMSM_EL1 controls the MPAM labeling for an SMCU, Streaming Mode
Compute Unit. As there is on MPAM support in kvm, make sure MPAMSM_EL1
accesses trigger an UNDEF.

The range of valid configurations for the PARTID and PMG in MPAMSM_EL1 is
not currently specified in Arm Architectural Reference Manual but the
architect has confirmed that it is intended to be the same as that for the
cpu configuration in the MPAMy_ELx registers.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a1..72654ab984ee 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3373,6 +3373,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MPAM1_EL1), undef_access },
 	{ SYS_DESC(SYS_MPAM0_EL1), undef_access },
+	{ SYS_DESC(SYS_MPAMSM_EL1), undef_access },
+
 	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-- 
2.43.0


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7484937417A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237209; cv=none; b=O4rcMHACaNEwrTdiIpNn9rZX1FeGsEXOQPTSV8hTEDYMyW4+nOnw1KZQrarnvQwoSxcjm9d3EAiX5/RkoNSXStrXEGuIdQRLDAOq8sjKuNirPjOxCmiT7niqn1GSZXWxVMLLEwdCLKKkTREYQh3lhrhjB2DGObCK9xlTvLnzky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237209; c=relaxed/simple;
	bh=cPwFzaNsCVBLrSBGfelVpK03vtC73cmxcYReuG99TiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCN92uhTh70v3M7FoCOe88Rh9URn2Xq2FLQzQ6abWSw3opC98sVdvbM64QmmfHt0VEfr8uTcHvfBnNyC5xMzZYP3S4Ezez12UwKcGUTLV4ZE0ng+XTsaRcQW6uMO0AeeYa7onbhf2vUD3ZcbGefdcCxb4pgXqeYOJFO17oG7HiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 419701596;
	Mon, 12 Jan 2026 09:00:00 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CDBCD3F694;
	Mon, 12 Jan 2026 09:00:01 -0800 (PST)
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
Subject: [PATCH v3 03/47] arm64/sysreg: Add MPAMSM_EL1 register
Date: Mon, 12 Jan 2026 16:58:30 +0000
Message-ID: <20260112165914.4086692-4-ben.horgan@arm.com>
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

The MPAMSM_EL1 register determines the MPAM configuration for an SMCU. Add
the register definition.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/tools/sysreg | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d6..afbb55c9b038 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -5052,6 +5052,14 @@ Field	31:16	PARTID_D
 Field	15:0	PARTID_I
 EndSysreg
 
+Sysreg	MPAMSM_EL1	3	0	10	5	3
+Res0	63:48
+Field	47:40	PMG_D
+Res0	39:32
+Field	31:16	PARTID_D
+Res0	15:0
+EndSysreg
+
 Sysreg	ISR_EL1	3	0	12	1	0
 Res0	63:11
 Field	10	IS
-- 
2.43.0


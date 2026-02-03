Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D9733985A
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155047; cv=none; b=m8pruO1mlicSVivVVQPz9kbxvCz4KAvLc889ht2RYpU2S4/DLQGAYqATz3d2jPLoRPgFOL9k4UbS8ts6YCqW3ZMUQnx0LJQmSoY+Rm3EpOMsgUO2c6BcfZoRhi5z42qcbib7qR8+O2xl8nRisesAVWXU6wT5pyKlYjyP1TnjO+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155047; c=relaxed/simple;
	bh=i1nztwTlUACO/UIm2RC8VO6S/RrsV+u2oLbBz867HsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvdHXfw595DDbQ2qpm9XCQd86T6xxpXchU8un8SUuPBmaS5ztBOl3Xbeyf0RFj60hXV03DoW74AMI3dsXnKXMtfmgCikyKvz6Gj3AFwkRiEt72A23MCaiHfn9CPBO4peNS2IBMEKeuqc+PdylN1lkStRWNCWwD8yll4aZUAI2Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 014C1497;
	Tue,  3 Feb 2026 13:43:59 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C00E13F778;
	Tue,  3 Feb 2026 13:43:59 -0800 (PST)
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
Subject: [PATCH v4 01/41] arm64/sysreg: Add MPAMSM_EL1 register
Date: Tue,  3 Feb 2026 21:43:02 +0000
Message-ID: <20260203214342.584712-2-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203214342.584712-1-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MPAMSM_EL1 register determines the MPAM configuration for an SMCU. Add
the register definition.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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


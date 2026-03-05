Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FA73AA1A4
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721868; cv=none; b=K7/323A7akv2VvmKD/uGCrI/pN/WF8z51MR5R8yXIXOGb0SgTkgW0X2GH6pZw1jihghAx6aqZU7YY1ACZzG1Mex6N0aEfDKL9OnkwldW/c5R4SpNHNypi5QTuwnn9yFvL5CrgF52vVcZ0AqNV2CEKnOunduGYrpTVa0LlfNHanQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721868; c=relaxed/simple;
	bh=zLj2vrn57hkwZ2s36BzueBZyzRGMePMFsUk6UVWwqkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0iYlb6pfiQIsQR6DILuUmHnd8LJbLqXylGTU07LfUmDsfFwUbZ0JLHtJuC1dIe1CJaCmH/cJzHiWWm7l2najv8WaLK8POgvBJglAwtQ/Erpa3NCtYKlmT8o3LCwbdUyRlrvqzgBDZ6bJM8tYngBP1qxBPsE2nspjv4fd+t5U4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uu7QkWPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uu7QkWPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73393C2BC87;
	Thu,  5 Mar 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721868;
	bh=zLj2vrn57hkwZ2s36BzueBZyzRGMePMFsUk6UVWwqkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu7QkWPbCWfOVvqY7ezBSO5ypdIpegG1NWiUBNq0LvdfrREFXig5zwCmEnKyy2Nq/
	 I9aaWMetAGqiV70sSrdmBbCz3r6V7K7GXYoOSW2j3vnwSyeBAHMNyEuUWZOG+lOYb8
	 TzGcieEm+ljGlzjLmIbeR0+T0pBvOHiDu5W+b+WinGPl3yltjcyft3q1aGc4gaNCqy
	 2IDWEiwirxMwaNxvy41VUPykCdRiN6DDxcrPmznF3n0FB/nDXvTqz52iCD3VAp62Ve
	 hEXa8IpI90hcUbWjGyZ1ieE+ywRXj1LNbb0QGbx4o8sBKX+ILBVe/XM8dqntlfVXpv
	 4WD5s9yLVFTpg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 05/36] KVM: arm64: Expose self-hosted debug regs as RAZ/WI for protected guests
Date: Thu,  5 Mar 2026 14:43:18 +0000
Message-ID: <20260305144351.17071-6-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI for
now. Although this isn't strictly compatible with the architecture, it's
sufficient for Linux guests and means that debug support can be added
later on.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 06d28621722e..0a84140afa28 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -392,6 +392,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
 
 	/* Group 1 ID registers */
 	HOST_HANDLED(SYS_REVIDR_EL1),
-- 
2.53.0.473.g4a7958ca14-goog


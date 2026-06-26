Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986D43DBD4E
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457473; cv=none; b=ibCTu9gYURs0zaipK1DSmtuh/s9qZdpNXa6jEAOTZiIGWrN1XPjyIYPvgWHRDEF7sgNV5eMjsZYeEVFGL82xZSYmDp0F/rmipl1sRZohRHfV30A2iaIHEq3PYf0cU/IR4nPEvqhwkQIBjxp5zs6hOhfHGrYcXxZEH4ezE/PoCG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457473; c=relaxed/simple;
	bh=SAkqjx3FMxionq2+L+T2JrGjRWdjtpwoZdgT3M4Zi10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t9bGuJih2ZJJW7nxKqvP+s6SxxTq8PXIU7cl2nFP2tapX3rK/eP/D1E2NqZSkNQzAdcjscyPTXgMoSMQIEJc9lM8wnhHBp9gWfFbKFpe1H9pqMauDl4qFYO7kS5tGKfStH8S1lsClplvXpVK7fPrLxII+ucb0bL9duJ6sC1iPfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hPCgWDEo; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hPCgWDEo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782457469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AWikHs3zW6hgIq2xRWQpoHjW3c2rokw3trtL2zxEjlo=;
	b=hPCgWDEokOqbl5bNj/N1xP3CSIzdkVx1QkpBDBoeSdPTd4IUwLdKHeCkOe7cJWesjhL/iM
	8OkBHLkzwBXRb4PxP2BXkiF8SEdbYupaCedBtx9PVSLx3h3/mYm9HUVlwqCHdNTrOP78kQ
	p9d+7NuVMIeEfgKhW1h6hGLeOLUGphs=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 1/8] KVM: arm64: Extract MPIDR computation into a shared header
Date: Fri, 26 Jun 2026 08:04:01 +0100
Message-Id: <20260626070408.3420953-2-fuad.tabba@linux.dev>
In-Reply-To: <20260626070408.3420953-1-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Extract the vCPU MPIDR computation embedded in reset_mpidr() into a
kvm_calculate_mpidr() inline in sys_regs.h, so it can be computed
without duplicating the logic. A follow-up series reuses it to reset
protected vCPUs at EL2.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33c921df19b54..674fabe1d40d1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -976,21 +976,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
+	u64 mpidr = kvm_calculate_mpidr(vcpu);
 
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	mpidr |= (1ULL << 31);
 	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
-
 	return mpidr;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 2a983664220ce..bd56a45abbf9c 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 kvm_calculate_mpidr(const struct kvm_vcpu *vcpu)
+{
+	u64 mpidr;
+
+	/*
+	 * Map the vcpu_id into the first three affinity level fields of
+	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+	 * of the GICv3 to be able to address each CPU directly when
+	 * sending IPIs.
+	 */
+	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.39.5


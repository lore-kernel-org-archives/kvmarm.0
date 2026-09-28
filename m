Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E294E73CA
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609144; cv=none; b=SxorXYe7k+WGIX0tBBw2Y5kbH5rf7NZGfGU8BRABxPezwybBHw0tVuIdAGVvqSzVS5O7JMri/hUGHcCxlKx02r25U0Sa6RO3P3Lnp+xckA10tE4BNw7Rq69iyNivTQcvYfc716+I2GVkSTO28UxRBE3iFZ/Qy5SqEfSO7m16Neg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609144; c=relaxed/simple;
	bh=P0RVNuENs3vpENd0HRdOYdMiYWEyBhUlAVznVoI9ctM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hjuodz4NKX+YtMeeEoJAOUhen0cq84NQxSp+uSdxk2NAOPwwqfW5CfwvGJaXNbHqwbNzIqCF+sdMer0LwDWPn05MZXvo6GrVY65gXU5QJFmal8abILoPUie5xLgjT+CZYAb/l+W+JfASnWjmH6FwZd6okE4x3aC9Ub59CgsQq3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZRQLRpgS; arc=none smtp.client-ip=95.215.58.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZRQLRpgS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=P0RVNuENs3vpENd0HRdOYdMiYWEyBhUlAVznVoI9ctM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609140; v=1; x=1791213940;
 b=ZRQLRpgShNNXptQTnoo4geZPAESCFlaXdtTyBZGmZvRv7slOY508pIK0WglY3qge1J5D0ZNf
 7Pt18O2rA+qfSwCEV4isbB1s8GwLQ3Imr04gcSlmwwe3UEXWU8B+CQrjk8oJXFTI9Q9mqRa+zDt
 j+wE2DdWydpDT9aOfDRagLT4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7f3a0b0fc5a4363a;
	Mon, 28 Sep 2026 15:25:40 +0000
X-Mizu-Trace-ID: 7f3a0b0fc5a4363a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 03/10] KVM: arm64: nv: Don't loop on AT S12E{0,1}{R,W} with an invalid VTCR_EL2
Date: Mon, 28 Sep 2026 16:25:00 +0100
Message-Id: <20260928152507.2116110-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928152507.2116110-1-fuad.tabba@linux.dev>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM walks an L1 guest's stage-2 tables, a positive return means
the walk faulted with the syndrome in out->esr, and a negative one
means KVM couldn't complete it and the caller has to retry. The
VTCR_EL2.T0SZ and SL0 checks return -EFAULT for what is the guest's
own misconfiguration: an invalid SL0 is a stage-2 level 0 Translation
fault (AArch64_S2InvalidSL()), and so is an out of range T0SZ that the
implementation doesn't clamp (AArch64_S2TxSZFaults()).

An L1 guest that programs either value therefore executes
AT S12E{0,1}{R,W} forever, since the AT is never retired, and on an L2
abort KVM injects the fault and then returns -EFAULT from KVM_RUN. The
T0SZ check also left the syndrome unset, so where a fault was reported
at all, on an L2 abort or in PAR_EL1 after a stage-1 AT, it was an
Address size fault.

Return 1 with a level 0 Translation fault from both checks, as the walk
does for the guest's other stage-2 faults.

Fixes: fd276e71d1e7b ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Fixes: 92c6443222ca4 ("KVM: arm64: Propagate PTW errors up to AT emulation")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/nested.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 98c1f8c193319..a67be19e73250 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -275,13 +275,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 
 	stride = wi->pgshift - 3;
 	input_size = get_ia_size(wi);
-	if (input_size > 48 || input_size < 25)
-		return -EFAULT;
-
-	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
-	if (ret) {
+	if (input_size > 48 || input_size < 25 ||
+	    check_base_s2_limits(vcpu, wi, level, input_size, stride)) {
 		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
-		return ret;
+		return 1;
 	}
 
 	base_lower_bound = 3 + input_size - ((3 - level) * stride +
-- 
2.39.5


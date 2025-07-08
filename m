Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512182E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995729; cv=none; b=BqcFTEj/ItH1aBWBShXSu2bnXxZuGgHGY82ZcKHU7dc2fKw8/AadfsJSSs2B9FqqyxHFEC7jvJnmFerEIIElmXYwijI2DruWvJc1JRQetXaN8MIddircISq1VUH2BL1Zw10E7a+XxbtkBVxXCyPn+6M2RhOp65sThfRaWcGNlaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995729; c=relaxed/simple;
	bh=iDwPPqpbo0ZXZt2y3ooVoczdhDtlSAmi4nkIBoVDIik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QyCgHGQ8Hrydf9UGGzWbrUhojcELprDfX7fMK7qT3xVPhRuwAJUW0JZZcaBL82Nomtio6z79Bfj+vRPnxonIyK7Vx3FOYq332Hm/iFS/ipMUs9rs99qpYoOOM/ge+xa1/r57KuzyPNF8DXghtvhSkWHz3IbyKYiQMtpXmyz0WHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KfAdY8ny; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KfAdY8ny"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0iBMPltWKiF+y5ikmGDHHI4S66LBxrWP+9MMRDG9as=;
	b=KfAdY8ny1noFey6ITKrlpboE1UwELPzyH35k5qWuvOw2Qb9BvcW3H9ZEBtTitzRso416XS
	V5BFfwyYD3SEgpJsLtHzxqW98hCWav6yVQ9RGeA3ghjGWGpdAQamTffLDxJObWEeL+mBBy
	uscotzWNNaTgGmHK0iUmnCxv/cgB60U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 26/27] KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
Date: Tue,  8 Jul 2025 10:25:31 -0700
Message-Id: <20250708172532.1699409-27-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Handle SCTLR2_EL1 specially as it is only visible to userspace when
FEAT_SCTLR2 is implemented for the VM.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index d01798b6b3b4..684c52b1b881 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -52,6 +52,12 @@ static struct feature_id_reg feat_id_regs[] = {
 		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
 		16,
 		1
+	},
+	{
+		KVM_ARM64_SYS_REG(SYS_SCTLR2_EL1),
+		KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR3_EL1),
+		ID_AA64MMFR3_EL1_SCTLRX_SHIFT,
+		ID_AA64MMFR3_EL1_SCTLRX_IMP
 	}
 };
 
@@ -469,6 +475,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 1, 0, 0),	/* SCTLR_EL1 */
 	ARM64_SYS_REG(3, 0, 1, 0, 1),	/* ACTLR_EL1 */
 	ARM64_SYS_REG(3, 0, 1, 0, 2),	/* CPACR_EL1 */
+	KVM_ARM64_SYS_REG(SYS_SCTLR2_EL1),
 	ARM64_SYS_REG(3, 0, 2, 0, 0),	/* TTBR0_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
 	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
-- 
2.39.5


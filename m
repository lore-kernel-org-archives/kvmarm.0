Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C7D1F91C8
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995722; cv=none; b=C+mSTY9IKgvj/YNEsvwe0HCRyCeotQfAJYFC2kCnjDaefKtLYg8kqavNV3ZB0KglJst2+FasmA5oAMM9XF6cMbQNNMKd5QMzbJm+wtxpQ8ypUJLEyd62F1jqi4rMa7HiD+eyiVmbOR3YJ78BHUP7AKfJjnH69sBQ5m0B1JGHkKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995722; c=relaxed/simple;
	bh=S1BeiRZMqZuD6nb/IXLDJ8M8iBvRJpMHl754x+35Ea8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UEDO4defL3o0X6oNNqXgGe+76tWvNjBfoo54BisxluuqSmktOTH0NsSbhvoXZt9wKaJf8fN3oMrWoxhY6H43jqaTEukR/VkE6ygDiwuPBgFwQT71LUUUkoCIxiwdl5nmi5XWMDeqPQenxBSb1jE4STj7ud7VhFHm1me5pUOwSVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ga2RCy1x; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ga2RCy1x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atakNEIIuWqe5PWWgZ+wbY1EHpMThWUPcZQMsXNgkPU=;
	b=Ga2RCy1x6tuClJXIv16c+SheyCbJA1pr3ho7t+mkuOPLNn6EINM86jkc1Kv+JUDTjk6IOD
	i/myrx/4Cb3MmzRRbW7V0TlmJeWkPbtyANletgSN3K1RPpno/reJbgbr+HzGjWvrDLr6E2
	qTj3XP2Q04/K5Yxg6P0b4zQuiM0dMj4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 21/27] KVM: arm64: Advertise support for FEAT_SCTLR2
Date: Tue,  8 Jul 2025 10:25:26 -0700
Message-Id: <20250708172532.1699409-22-oliver.upton@linux.dev>
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

Everything is in place to handle the additional state for SCTLR2_ELx,
which is all that FEAT_SCTLR2 implies.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a3dacfce2e5b..b3e6a7034b64 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1644,8 +1644,10 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64MMFR2_EL1_NV;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
-		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
-			ID_AA64MMFR3_EL1_S1PIE;
+		val &= ID_AA64MMFR3_EL1_TCRX |
+		       ID_AA64MMFR3_EL1_SCTLRX |
+		       ID_AA64MMFR3_EL1_S1POE |
+		       ID_AA64MMFR3_EL1_S1PIE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
@@ -2961,6 +2963,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
+				       ID_AA64MMFR3_EL1_SCTLRX	|
 				       ID_AA64MMFR3_EL1_S1PIE   |
 				       ID_AA64MMFR3_EL1_S1POE)),
 	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac),
-- 
2.39.5


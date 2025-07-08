Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE8A2E6122
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995637; cv=none; b=b45OkHrm0qLsAqmKHrynT60rlYKFt/2DcEEAy/MYGtktjUemFOpEe8pVY3javVJQLclmxacpL4ZLvP+1aDQuSaDipQNh+voc2TBci56EHH/1hYqpGqtgQzbhg/4Y8v21Yx5SIoLFOJsYr06i/TnKflL18YVcTIsP1jlUfIWFwFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995637; c=relaxed/simple;
	bh=gAv2B+C5Q46Sww9ndqCy8K509jhzUFpHl01GReTK1qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DuwcJJ+HDq826CbR/cBBqRnnerctUxxr7ihUvQm1ufdJOAafFqZ/B5GBx7u9bbInviDSRb8gNtiM6477p8GTBlah/GjLfKXKJQG30kf0QtUmnRqfwiLczOCXeKHoJU5K3dFEW3wLJ36CsUdXbf98wSxcfg3GyrsG6RrH6idCy+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VumgbHXn; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VumgbHXn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4XFIRTtD8wT7h7YwqJhesIEnNkqKm80HvEpnPT+S5y8=;
	b=VumgbHXnVCoUEZeHllLYQkB0NhwNFES4Qyfg0U1UXfgkIIUUYy7niWujuytHPkXx4GA6Nf
	qVSQLBVPtjX5MPoVfwO+fcWrM/l1r2RimQLR4q/CbkCvmxTA5eB8NPaUto+bvLphnmAbNJ
	VbrJaw5xRW72U52M1Kd7I7rJKg7eyL4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 13/27] KVM: arm64: Enable SCTLR2 when advertised to the guest
Date: Tue,  8 Jul 2025 10:25:18 -0700
Message-Id: <20250708172532.1699409-14-oliver.upton@linux.dev>
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

HCRX_EL2.SCTLR2En needs to be set for SCTLR2_EL1 to take effect in
hardware (in addition to disabling traps).

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1ff52e66514c..71ecdc20523e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -665,6 +665,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_fpmr(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
+
+		if (kvm_has_sctlr2(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
 	}
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
-- 
2.39.5


Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063763BB44
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115104; cv=none; b=JjhbRN6WpJp90w9u9oiMzvf2irNR0zce1inL21KbBN1K4/TmzxR92SR/EfT0z6yTzUdCCixoj8xbwO+KSyRuE9YgOp/gd1v5kBdZLCY54/HLNM5K7lD+2OeK7oV48PctFV3FcoFRQ3VbWqpoM2C8egklIcAqbeTGmFwAfVDgfnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115104; c=relaxed/simple;
	bh=uz020ORgKkCaWxweTRkIC7TUsfyrLW0Qsk0rw9EC/eI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pzB2NFW5vdrLYJJnoqWbJp5KBEv3Pj2gDM0mlyqyysSxJVDkWiPRoNIKxZ91GgwnZhAFOm9WlUtz4TEr24t+xAmd02JjIG0zo/8iRAmyOYq9xxvoW6o8N0zh/aCKlZDhPtLFHRN5BepmDvCM6lmJEcm5iuCLxlTkZkrM10x2ybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mGPx+r6k; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mGPx+r6k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DIcYZUWJ8fxGgYNqZMRS0i2bs3qUC4WbYPaFDpwGLA=;
	b=mGPx+r6kQrZqr1Wz6NPLA29bKsS5qDvQzO9zp8ddYhEvDWsOEpkANwyqm7yOo1HwzmGcE7
	iRM38rH+MEdoETWtVuVqj9kSVbVOtqCD9qiofjI4+YTuJ86a5/FmDS6Mq/CRUNCwVqqfPS
	ITSGerTcctC80PeFG6SRcpu7KhbQ918=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 13/27] KVM: arm64: Enable SCTLR2 when advertised to the guest
Date: Mon, 16 Jun 2025 16:02:54 -0700
Message-Id: <20250616230308.1192565-14-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3ac11effed7d..55ff05c7296d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -727,6 +727,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
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


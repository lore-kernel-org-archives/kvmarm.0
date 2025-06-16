Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A75A21FF5E
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115116; cv=none; b=qgf9Cu37sAwk2O5nk7T6xUSUFBog2Oc+SMP2YZ6xCnGv18DcS2DJ0aDOa0w3NWsDYtV0MXQ+yfCnhYIcJ//8FqibPkgq8+A2jDJOc3Eucyqg3TR0+wZd50mUMgO7JeIhyJ+K6j2l4XZMsggQ0rurLy0qSDEysIk20X6Ul6IXZdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115116; c=relaxed/simple;
	bh=VfZe7js5+sVe/8ZOiMZ1+CRxb0jJJk5sh2L3GNPv0a8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VoYUuV497jWToi+KbajB6fqeBfJlOo0vPKCL+iJvg+fHi8LDEnX7X78Epq1MMGYyvlEf5mQdVV60+35yabeAofHUNf1TKCVjsv6Yr5qm7NteFt0GuWPRwGsOCZjhN/JHHYop1VM6F6K31UxuOOrAwohyLS8xugc2HbjQVKok2wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KUox+PW/; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KUox+PW/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gcyb4RfcDKGBBmk8zESVIXW8SnVy2osTgAHQnICzIuY=;
	b=KUox+PW/iFDG1ZNcrSnQ49bG5HVUQre8ZpCk+yUbq/2ZCpZHuNO3KOEjtr88txfFtAAdgF
	SPs440UIA9meDw22ZTiUI2yQZPXhoicp6R/tXydy2jl1U0jxi+qRMrzSUzoFZlu0q2nfEu
	AbDeflwvfMK17Eprg89RQc6rD3YOFsQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 19/27] KVM: arm64: Take "masked" SEAs to EL2 when TMEA is set
Date: Mon, 16 Jun 2025 16:03:00 -0700
Message-Id: <20250616230308.1192565-20-oliver.upton@linux.dev>
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

SEAs can never actually be masked (they're synchronous after all), but
the value of PSTATE.A used as a proxy for whether software might be in
the middle of an SEA handler. And, when TMEA is set, these "masked" SEAs
are actually routed to EL2.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index e689002f10b6..3eab7690c54e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -209,7 +209,14 @@ static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 
 static bool kvm_sea_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_TEA);
+	if (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_TEA))
+		return true;
+
+	if (!vcpu_mode_priv(vcpu))
+		return false;
+
+	return (*vcpu_cpsr(vcpu) & PSR_A_BIT) &&
+	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
-- 
2.39.5


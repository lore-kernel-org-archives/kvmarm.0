Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688F8137905
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309925; cv=none; b=ci4CyzznmIlmxHYX+7DNYWRXIJyVpGOsk2AcJ4ZPavI05vCQkIoqiHx6OHx7fZK5yp0Ak0VaAZroAjFqtQ9+STR4shHcJZv6Kdua+uau6A2wQxpbRg5d+5oW4v6uQwHcSF0SUH4wFle2jI55X+64rEkmzJF6esL6YDLP/uHU+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309925; c=relaxed/simple;
	bh=7dwMWGA/FVftz7QTT9g+E6z80h/FVdohQHhZp6qAeNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHmlqu9IgGBP1dJVB4xh1um6/x5SzjrJwi5K1K9hmyC/P5gYRt9QeaDwAbmJz3Qgz5SHWIfgzNxifFtN89yNjAKZVzkl4Yo4i92YTCq6l4SgeSOVVZh7fW7/MZ+M4YJed3RwXkMM/f3Hx4z0jXR3mrW5l+6avS/tTaWLD+HAuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G4PxLkML; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G4PxLkML"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UWkEZTkuA/ZXxYNk+cvUOFeBhkGAABmhVnDXAk5ktaM=;
	b=G4PxLkMLIlKpyo0wCUA3TEKDWCHrc4pMGZOYg5bZpwMsrYEvF3wR6T7/d1omSLx5TECPEq
	wKjVUicN3JgzYMpWktE+KuE9eDz+tduDopvq8Z8qjjgy5EjXSwgeMkaRfcXW0uSdC2V5GD
	AI2MaQfh/EZPMLoAa1nUlYnMIQhg5ls=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/15] KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
Date: Thu, 13 Jun 2024 20:17:48 +0000
Message-ID: <20240613201756.3258227-8-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running a guest hypervisor, ZCR_EL2 is an alias for the counterpart
EL1 state.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1807d3a79a8a..53168bbea8a7 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -173,7 +173,16 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+			u64 zcr = read_sysreg_el1(SYS_ZCR);
+
+			/*
+			 * If the vCPU is in the hyp context then ZCR_EL1 is
+			 * loaded with its vEL2 counterpart.
+			 */
+			if (is_hyp_ctxt(vcpu))
+				__vcpu_sys_reg(vcpu, ZCR_EL2) = zcr;
+			else
+				__vcpu_sys_reg(vcpu, ZCR_EL1) = zcr;
 
 			/*
 			 * Restore the VL that was saved when bound to the CPU,
-- 
2.45.2.627.g7a2c4fd464-goog


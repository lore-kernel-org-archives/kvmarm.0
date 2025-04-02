Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6911E3DD0
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 20:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625066; cv=none; b=qWT5ow88h7bKZhFA0cXyltljY+8Lnh9KiQN9gekO4SDAjEkuN9bZ/ztTVvP+FoLx4zDJKBTQSydsrkLdkQ01oyHuiio8/8sEMwMQzBTeoxY5inIq+iPfVxlXOLEGREmc5fdxvufwoWRMzFL24VaXiLK8M0HhyhlHnJdjROOR1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625066; c=relaxed/simple;
	bh=enb34GvY+ErUMelO44pnEhClDaU6Jf+6y2TEJEAii4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y9kPqOQKc7gXvc4SGcCQEsSgYMv0jiwNOR+RDvzxWQeiZ3hXjzx3iEn/QtgHO2UDMogiHyhGVmDXw4MBUDU31giR2vtyZRiHiuC9Kwb6BjjYsppgjHDMOmbTlzdIeDaBhQcYzP5EF2IB3sw8bgRUe1ww5QgJlFj5Tn0syKk0+hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j4vlmS+o; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j4vlmS+o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743625061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XRC3qd8fRWL+smjvSz22p4xOo1QgU09ykbhazHH2n3s=;
	b=j4vlmS+o+213z6i4Ph6dkZfDD03lJyLCZ86fMmDeoBI02NyvIj43FzMp8AuCd30QznPgSt
	m+iWbJmdBt8yALq094a0tnCfwIu3hyuRRj11ybSQJpoCox9PyYuWPdOwcQ8CS2SetgTfmu
	3zyxvgrhSci9uqN1wUBm9BaOr4ZNQRU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/3] arm64: Convert HPFAR_EL2 to sysreg table
Date: Wed,  2 Apr 2025 13:17:24 -0700
Message-Id: <20250402201725.2963645-3-oliver.upton@linux.dev>
In-Reply-To: <20250402201725.2963645-1-oliver.upton@linux.dev>
References: <20250402201725.2963645-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Switch over to the typical sysreg table for HPFAR_EL2 as we're about to
start using more fields in the register.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h  | 4 +++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/tools/sysreg               | 7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d7cf66573aca..44e3fc6483c8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -305,7 +305,9 @@ static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vc
 
 static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 {
-	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_MASK) << 8;
+	u64 hpfar = vcpu->arch.fault.hpfar_el2;
+
+	return FIELD_GET(HPFAR_EL2_FIPA, hpfar) << 12;
 }
 
 static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f34f11c720d7..5ce2230054d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -578,7 +578,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 		return;
 	}
 
-	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
+	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 	ret = host_stage2_idmap(addr);
 	BUG_ON(ret && ret != -EAGAIN);
 }
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 2c63662c1a48..31ad9ce2b91c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3433,3 +3433,10 @@ Field	5	F
 Field	4	P
 Field	3:0	Align
 EndSysreg
+
+Sysreg	HPFAR_EL2	3	4	6	0	4
+Field	63	NS
+Res0	62:48
+Field	47:4	FIPA
+Res0	3:0
+EndSysreg
-- 
2.39.5


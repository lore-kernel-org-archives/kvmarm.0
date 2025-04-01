Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB184214A70
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 22:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743547371; cv=none; b=b+PyjSvZNqBwqTGFAirHtjW8xVUhpU33qDJ0Er+0N6Ioxp3SR0eNo9PFfK+QJ3DJktYyaiXYWayzAcaWSaJJ+Hm5eEHSrWny1a94shOXu3GZJ8jbOHq7xTpEutrMKv2t7283+ecjzf9zJXId83n99K3ziaU2RD8WsxKkUx/L/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743547371; c=relaxed/simple;
	bh=xlWR13vWXmSwq0fxzbaouy0JLIklE+RsbT8ifssUuF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C6iBarUzWCsGmQqnd+ZFouAvVQccW0K5X8YznXvSmycbAaspC439UlHh7jETjtcCVM/n0Q++lLo4A3sk9w7x4XV6aMf3X5NXV6DoN70jmdmmGD51UIrG86CmvFoW0t7hKsNooMG2+/1qSXuqf4pZ6+fqpozaJ3jeEKwLHXhbzE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GZyNTvEZ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GZyNTvEZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743547368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+V7bhrGP24eNgC6K/LafjzOHHi+9pX+4j2cwxRY8fJI=;
	b=GZyNTvEZ2eBJKxZBDW6DFVw+0tUlGYLUMkj3oCWFbh9PEGiunMnc+fag6wbfolRWpuoc7V
	xMruvG5HvEmN0EWaeJ7skKH5qvBcJewj9CxA77JteYXFK298m0TMV9gBtILOaQl5hIZUxg
	yHlZbD1YGgNsP7RqGN/kxM/Ni3zYmk0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] arm64: Convert HPFAR_EL2 to sysreg table
Date: Tue,  1 Apr 2025 15:42:33 -0700
Message-Id: <20250401224234.2906739-3-oliver.upton@linux.dev>
In-Reply-To: <20250401224234.2906739-1-oliver.upton@linux.dev>
References: <20250401224234.2906739-1-oliver.upton@linux.dev>
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
 arch/arm64/include/asm/kvm_emulate.h  | 2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/tools/sysreg               | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d7cf66573aca..5d8c0832acbe 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -305,7 +305,7 @@ static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vc
 
 static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 {
-	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_MASK) << 8;
+	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_EL2_FIPA) << 8;
 }
 
 static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f34f11c720d7..168893570703 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -578,7 +578,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 		return;
 	}
 
-	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
+	addr = (fault.hpfar_el2 & HPFAR_EL2_FIPA) << 8;
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


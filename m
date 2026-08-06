Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA243B3E1
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010638; cv=none; b=GfbaGrWA10j1M3qnIphL5g23dkPrxCsC5JsAPEprS8BBpOvjIeYDZtbzStozQYOX7IDELQtSH9sKuF4gVw901NzHhoeDCFM3uP4M5jeJqSe2vQ5d2DwFeDL83z80qvphD3S/nVKr444F6hvT+IXI5nwer9+/Jr3BOoAVnoN3QnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010638; c=relaxed/simple;
	bh=Q7FD6Y66ifHoTpOKvshD/UjKm4zl+Q/t9jw1vOPYCXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oT04xdd04Sm4z8xr/gTpUainu3ybLb8OIdsCn7BkR8SsTxo3ln9yn2wpcqhOmnQJjRhqobTs5H5zyE8ftIC8bBkerOYL68dJ8w7wP9eyjPAnPZGm8Z4j5hJtX1InX2d9qk9hNqkP9En0GVRjGg0bp397ezptk9GLtdfUDz7JsBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qIqVUJTI; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qIqVUJTI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786010632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqHVzp5pYqarvaM7RLacv87HuepiYTxatZ5ud7gmocA=;
	b=qIqVUJTIWoTr8awgN3nLzRpxI3w0oTdjLrALY/hIFWhsUh8ni9EZCMy6PcS50Tt6Os+oNm
	CNS6/FCsoKWs5vMwAsR2SnmrK4hmhnj6toTYhjV1mjpa1slEFB+XSohBLXM+my73Qy9R4p
	fMlxvYQlK036C+9ZQOvD0geFg8VF2sk=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v1 2/4] KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
Date: Thu,  6 Aug 2026 11:02:54 +0100
Message-Id: <20260806100256.371164-3-fuad.tabba@linux.dev>
In-Reply-To: <20260806100256.371164-1-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

__vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
a valid caller in protected mode, and on a GICv3 machine the registers
they access are UNDEFINED at EL2 and panic the hypervisor.

Reject both when protected mode is enabled.

Fixes: af325e87af5da ("KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3df96ed8ba42..a9afd350b1fb3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -695,6 +695,9 @@ static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
 }
 
@@ -702,6 +705,9 @@ static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
 
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
 
-- 
2.39.5


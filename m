Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D33AC0E4
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962765; cv=none; b=fzNPGGfW6tetAUZpY5m2fG5dwDRMeDX6PJgOj+v/mWg9WtBFUX5tTLfEIeAjOJpM9CbW6fF04aZ6EM9BOCrZJcHf/r2/jQO+4WzzJZD/zmCpYIFFPZVcvFShMEoNJxYbtUa1DmM6kUHal/J3/KW+j5sj+fPJFZd7QZwO+lo+eYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962765; c=relaxed/simple;
	bh=z4EwF+2nV6LNFiwYHiCvrW4hUIU64iI/tXAhjD2lNDA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BKJ9X1OpvTlHGtYBuHvW0M4uWL1eAwpdup+OBLOsgMcQbfEliXEwT4+JJqx9GfMytquU8kbv9buGSvUVmQdwXJfzK+ZwHFPoiolZtSiUxy+Qzy3VXAgGFSiP7m9wYnJJol2JqcdZlGvJEP/giSNlfycxspzrKOdiInWi8IgZCUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DpHbinOo; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DpHbinOo"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=z4EwF+2nV6LNFiwYHiCvrW4hUIU64iI/tXAhjD2lNDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962762; v=1; x=1787567562;
 b=DpHbinOouCJSN6ZYW3beYVCTQdQz7pjlqQps/hWYeCP9v3lAvD/u2qJ3kL3Tr4XeV0nd1J+W
 I+cMCo6BJHaNLItlxPAe4IYNXxM/XU5yV3ATq62EeSug5eyZ9Fle6LhdEcu4vqdqNeQX/s4v2bN
 mKN+LHmBMlrmVCuzHwKPYKzQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 7c0f32848ff2a96c;
	Mon, 17 Aug 2026 10:32:42 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v2 2/4] KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
Date: Mon, 17 Aug 2026 11:32:26 +0100
Message-Id: <20260817103228.1203140-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260817103228.1203140-1-fuad.tabba@linux.dev>
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
a valid caller in protected mode, and on a GICv3 machine both reach a
register that is UNDEFINED at EL2 and panic the hypervisor.

Reject both when protected mode is enabled.

Fixes: af325e87af5da ("KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface")
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
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


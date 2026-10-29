Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313456;
	b=Ys8LxXX4Gyk21qZRH3LazPkw4yQ4bRaR/RmFYBoQ2lKT9+HDOrSC7CRQwk+OknyDqhue
	 9B76gnnjDmdJPaui8280C76PuP87IHtNkGx3hhd+WLT2Lj23VXFtMeCIo/D3jVR7XtYME
	 XJa3Z0dvRjUO8yrezmMi4GHu4MHEHhQ3cz5uJA5cSiHcdVJKhPv3lcddS6Spi9AE5O3a3
	 5IpRvBCpFjPzAqeqdNu800nI06WOhzk3WObPlUzJvhwOtOxuVqGx5qJeJikZiw0z2KSbS
	 LhS7KpoWBMvKDhOxQj1jC1In/k4M4TA7tVxnE6gi90YBlTXJ+SZUaJM1X/OEQ87mGbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RPS6qFr0DOe5dh/aFH6XTY7E73IVxOPpmJYc8EGGxFk=;
	b=YSXZzgpupaiPuOF8r4mBo6mKVe/9XetvguoHj5OOJm4/46WTm6qjcIOCBZ04nJVJ9rL+
	 VVPqHSvrtl+NmnjnNAhJfdo6cc5AXoaNYa5vXB221gbywkzZ2Sd8EfxndUU4VMHNFoYF8
	 0h+Po+tkjlIqhWmbxplBhWFqUdRHoKUE+ddPfIFvULHM++ESkgMxmuNdpl6fsyefE3iEl
	 OqCSl7c3vap0/NULMMOeEkjypDNyul8xOo/XASaJQdXsZdyV0q1463Cqj21Ov0rEJPMlq
	 xgi1dhgOn3YTHiEvEU7sO+AWkBvU9RdUeHcn3Bvqbs76ANaJUve0nZwfm1+SnTbIN1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdVW1J6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8A7606A337
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdVW1J6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74601F031F1;
	Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313456;
	bh=RPS6qFr0DOe5dh/aFH6XTY7E73IVxOPpmJYc8EGGxFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdVW1J6qFjtOAoyaRW1ZUdwK0hiTea/GruohHarnaTFNRa+x8d2w0F4CLQprCvtIU
	 l5PSxK/dlzyC43uM0qf6FD6jKDrTLlqMW3C6sZvSCCXbllrpPanza+vq3/7KWRnmyT
	 lJI/J7jv85pWfCG6i3wI7/bN+GbJEiRyGOBLSKc1yMaL4qxASysjGlUWpmwu9WWwTs
	 PcIYQNuRQnrmBLwjx2bxG01uBFQUL62IEJELelKtIz/nGTYCOgN9j5jn7+jqIG7AIS
	 jEZJmeTJAyENXMHwp147Pln2di1+3ABDCd0yTvc98P2rOQsJQNmDYKgaAM3bT4X28S
	 gNXrSPDuekQ/w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 3/5] KVM: arm64: Reset TCR_EL2 according to guest's E2H mode
Date: Thu, 29 Oct 2026 15:37:30 -0700
Message-ID: <20261029223732.103785-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029223732.103785-1-oupton@kernel.org>
References: <20261029223732.103785-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

Previously vCPU TCR_EL2's reset value didn't consider TCR_EL2's
different formats based on the value of HCR_EL2.E2H. It always resets to
the E2H == 0 version.

This didn't cause any problem because the bits set in the E2H == 0
version (TCR_EL2_RES1) all reset to UNKNOWN for E2H == 1 per the
architecture.

Still, it's better to fix it. Choose the correct reset value by checking
KVM_ARM_VCPU_HAS_EL2_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0687b78cd7c2..bc880d777442 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3273,6 +3273,14 @@ static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return vcpu->kvm->arch.nr_pmu_counters;
 }
 
+static u64 reset_tcr_el2(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg,
+			      vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2_E2H0) ?
+			      TCR_EL2_RES1 : VHE_TCR_EL2_RES1);
+	return __vcpu_sys_reg(vcpu, r->reg);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -3851,7 +3859,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
-	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
+	EL2_REG(TCR_EL2, access_rw, reset_tcr_el2, 0),
 	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
-- 
2.47.3


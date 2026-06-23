Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8138B7BA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240127; cv=none; b=MX6eTp3XWybdwd1o5PytDf4zu/DEw9+uT3h8RMNWqeBVEJguLrj66rAl6BMsCwwaLL+Kks8y4DZPL2G1qRGdbJ0O3CJh2nsO+UpO2JXOHaMxb9xarjEnP6UUWwSl53XLd3IEsqW+dw25AhSzMk+Hk/b0A26M5Z0qTCdcuWPmwC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240127; c=relaxed/simple;
	bh=z3jF6MPLiA62+2y2tpy7zIz3d63t/9m0jF69QjIqbYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYz/R4GIN4Sv3hwyVCmKJ3YHFeqRBrlF13VV3L5R00DvcFuTeQNQYdlCRfuct1c23iqbQeok0k27QUNwnT3vrIWEVV+K+7Bs7NuHKeduI7Temn6FDq4ejFzdA2s+da3V1I/Xy0jx2k+lJ5eMg3HnR8Q2vLYk1+yt2mf/XI3ABBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzxs6LI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzxs6LI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C065C1F00ADE;
	Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240126;
	bh=T+YhAnEJPl0Ho6vj8x0xFF0JruUyJxZJ7ih1hHx69v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzxs6LI51WsEwAmFJ+8M1/5XdGHcC32O9pcbAubw3umgXLtUX/08OOZWlBMi/w4lF
	 oglPL/PK3IFZrhMYpdWQ2EmArBGOunwJ6wiDIcic/snqJnqO9ppoIpHyJpCMII43YE
	 PB0/vhcMgIQfuka8/y0i3eqBDAnf399WKDs6Q2SnI2PzbC0iXBcMmLI8aGNNNSbjoO
	 0QuRTLk1ShOCMNtDQNpn4Ia4FUaarBZqRZn3h+Xg1Cm4V/maY96xN1a9TuPJsrJfzm
	 bcurj48quCTlBXW8B7Prznf4Dj07RevFoN65h5ytpfxgRzu8wGW80M5wZJ3xCdaKT0
	 OytbVAKxb6Qvg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Date: Tue, 23 Jun 2026 11:41:47 -0700
Message-ID: <20260623184201.1518871-9-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using direct permissions, the DBM bit has the effect of granting
the write permission. And, depending on the access, it could grant write
permission without a dirty state update.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/nested.c              | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 22aeb2ed18d1..6ae36973686c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -94,6 +94,7 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e5a407fc0880..4f13f37e560b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
 		break;
 	}
 
+	/*
+	 * Descriptors with the DBM bit set while hardware dirty state are
+	 * considered writable, even though certain accesses (like AT instructions)
+	 * don't actually update the dirty state.
+	 *
+	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
+	 * for the access and just treat DBM as writable here.
+	 */
+	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
+		s2ap |= BIT(1);
+
 	trans->readable = s2ap & BIT(0);
 	trans->writable = s2ap & BIT(1);
 
-- 
2.47.3


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A803D244691
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752092; cv=none; b=KXBmNwhg4RZ062aLMmTP03waglXEoW08o/V7h+y+zfXoLiAjn88Cdld0qAWJi5C6fcQwj4g2aKguinw4/shCBWxrdJ31FLUOdw37US1R6H975NmpWovMoqCgtoFNgwuMnBOg3KqEi0ZDPiLRMCEB+rR2fQ5a3s6zYDFhYhDwHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752092; c=relaxed/simple;
	bh=c6QyZgO3sFxt8cd7kKsM7NkPczhKjzK8imzKP37Lmms=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MKFBVIWjgrIiUOuwiYqq++YH5V09tsCt8VjU8wXt1AgquasA5TR1W4Mx6+s7gL7MU9PV4LlUImcuQh2Q7AUdypmi34GroRrQNsQ67crJeF6/YgfDSJAlFGgPr5ABLuUmPo8IR0ohS0uin6zWNBvQS1yDp8cFVE42jj8Q8XwCqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsNaiSBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsNaiSBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CCDC4CEE9;
	Tue, 20 May 2025 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747752092;
	bh=c6QyZgO3sFxt8cd7kKsM7NkPczhKjzK8imzKP37Lmms=;
	h=From:To:Cc:Subject:Date:From;
	b=AsNaiSBkLzeja5cdsVrAxHQp9eo8wSoGVBl13A/nxgWXE4px0E1foWrckPlDpOIj3
	 Rcb2FIGOIZEgA9weQ0G8K/Rv9CikcDnliCiJoVeXykI2/MHd6fiA4HC9Pq5ijdxGHG
	 E2KDhEY9UOcJvFWEhdYGwALbcbNwa7BEnCTqLSFaG0xcZ2o0j/xSNKnKMMEKwDGFhi
	 u7jpG593iPRDIiIX8ilepulujVsxNgbYa355KFMXr4S3OtcxnCWlPehHO4naQNsYCR
	 KHacbor01tHpfd6d9E2a8tfs3eeWNPkFLOIrzODZFv+Uew4ZYL3PyI8yubQazWvTIZ
	 JOlr3UhNoXFow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHO9p-00GbpR-TB;
	Tue, 20 May 2025 15:41:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Hold mmu_lock when invalidating VNCR SW-TLB before translating
Date: Tue, 20 May 2025 15:41:16 +0100
Message-Id: <20250520144116.3667978-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When translating a VNCR translation fault, we start by marking the
current SW-managed TLB as invalid, so that we can populate it
in place. This is, however, done without the mmu_lock held.

A consequence of this is that another CPU dealing with TLBI
emulation can observe a translation still flagged as valid, but
with invalid walk results (such as pgshift being 0). Bad things
can result from this, such as a BUG() in pgshift_level_to_ttl().

Fix it by taking the mmu_lock for write to perform this local
invalidation, and use invalidate_vncr() instead of open-coding
the write to the 'valid' flag.

Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6a9fd4e0e789c..56b732003caa7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1179,13 +1179,24 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 
 	vt = vcpu->arch.vncr_tlb;
 
-	vt->wi = (struct s1_walk_info) {
-		.regime	= TR_EL20,
-		.as_el0	= false,
-		.pan	= false,
-	};
-	vt->wr = (struct s1_walk_result){};
-	vt->valid = false;
+	/*
+	 * If we're about to walk the EL2 S1 PTs, we must invalidate the
+	 * current TLB, as it could be sampled from another vcpu doing a
+	 * TLBI *IS. A real CPU wouldn't do that, but we only keep a single
+	 * translation, so not much of a choice.
+	 *
+	 * We also prepare the next walk wilst we're at it.
+	 */
+	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
+		invalidate_vncr(vt);
+
+		vt->wi = (struct s1_walk_info) {
+			.regime	= TR_EL20,
+			.as_el0	= false,
+			.pan	= false,
+		};
+		vt->wr = (struct s1_walk_result){};
+	}
 
 	guard(srcu)(&vcpu->kvm->srcu);
 
-- 
2.39.2


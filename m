Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FB21EE00A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820217; cv=none; b=fgapX9Os/ZCWZLuINYpPoLKcbkODVHftKUlYLVUOQiks/FedW93R/Vbkdii8SYwLlJj1JRE17IfmGB1Ht+pqRqV0W+bHEMHWuMoXOjkjj3xuKwA3tpN0Bwfnf/5b4y1LL0qS0g45FGCJbccV7kk01VZtSj0+ExS6BLLph+J5e6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820217; c=relaxed/simple;
	bh=uTXpYO5WtXclYdggoann9HiinQtNq2ANggCc1hfRfek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaUGb6LNapaR60UQp62QmcbzvcQY6ytJAoiqdzCJimDIQZYoKRjqHo1SnU0qUNWQ90Mtw1VqtTm+MPxSZXrTlGkCVaMExc5gZ2eiDKvgrHNus13RNmBG3D7uSO+VeqGwWD98dlqCjyl9Eiu0UVQblCfsh93sfYK9sm+9h0y02NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwsATEUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwsATEUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C23C19424;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=uTXpYO5WtXclYdggoann9HiinQtNq2ANggCc1hfRfek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwsATEUp/4Lvgj/M1nAevcyTnGN18Kcx878AvV6kkj8rKrRmCTfiJqizx21mVFM8A
	 zQVR5QGIZSVrwpYNUKpE82eCdzFDxLvWl8YCIs+ukHArSxCfJ1YG/YjMyWXBGJvNYg
	 DsaKVFunRHdvkghInB8lp9iZdAigCJe8yI/oxaNtby5MNItaNdP6161qy/iXE55S05
	 EaWVI/SjlguW12PLgnlM1kJIHuC2dz1nrvoAE9XUKLOfcrKSD0AQdaES07uWQJmV/7
	 otUDVgAyREspLQvu1yqjOCq45M3BWwMy3PtvRj8ONaJ2tx1hedeDnodWGDJ67chd0S
	 B76A+j/b5m5rQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwJ-00000003YVK-1gB3;
	Mon, 19 Jan 2026 10:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 3/6] KVM: arm64: Make stage2_pte_cacheable() return false when S2_AS_S1 is set
Date: Mon, 19 Jan 2026 10:56:48 +0000
Message-ID: <20260119105651.255693-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We cannot tell from the S2 attributes whether what we map is memory
or not when S2_AS_S1 is set, and issuing a CMO on device memory may
not be the best idea.

In this particular case, pretend that the mapping isn't cacheable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3c5f399b1b986..07561a227f75e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -911,6 +911,14 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
+
+	/*
+	 * With S2_AS_S1, we have no idea whether the OA is actual memory or
+	 * a device. Don't even try a CMO on that.
+	 */
+	if (pgt->flags & KVM_PGTABLE_S2_AS_S1)
+		return false;
+
 	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
 }
 
-- 
2.47.3


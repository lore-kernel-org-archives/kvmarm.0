Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FFE277037
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751383016; cv=none; b=kCjKBQ2BXc1GfKgtlikyFgsDRERZ4+lpfLM/MmNJazIvIOoACmzA0nAyx6ZV301Rnj52UA8NmMeD3dWZuBvrVY3XAXZ5Fy5IKqWbNlT44azky0U2l+clGph8NMBISWrjgQA/6yQhaL+TzxGiJGwyyJMEFaTM5b5CnYpeFJWo2ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751383016; c=relaxed/simple;
	bh=PeXRId0k2QHFVU9yZy9TZVhwUXLiL58Ay3yq7IB90sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pUqyEZ4lV96kK0gpygW3P5MPwx/2m93It64YyjydouwulrasJjjXKcPu3WieGsn3+fRHQviZ2xGSM51/57apJhiMREiCFRntrZ4FvrdonZNiM17RqKKpWU2YIjnAn9LTa3jkbQAgNCLg7ghiwA1LPcvTw9xse7emONGXXDr3ZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHjdLLI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHjdLLI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84644C4CEEF;
	Tue,  1 Jul 2025 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751383016;
	bh=PeXRId0k2QHFVU9yZy9TZVhwUXLiL58Ay3yq7IB90sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHjdLLI6zNfv38kNVFtsyL143n7BYMlbB2kBN5UODbA96dtLF/lPW8zeHW5qwp8vE
	 DC6nvcI/RgdDDOrKm9K+Snz0Yz0xnsZtLEAyB3CCWI1InXxBvut7LYgCaw4OQ3VHci
	 w0f5R4P80fA/aoNcUXKZO46/rZcUC+2ivoKlhPn+BvnnH5zM7Q8Ix1rOykxMrL+XF2
	 dnKvS5zZZbsJdCQMTiTLHpzhIZBnRBr3aXKAeD3uWuFN3iqVgZUWv8YFmgfsFGmWjr
	 5Yw9vM8o01qQwv4t33k+9GC3UiTWQ4+IjnujrgLKYSrHetQ6OVTmJGNRNs7fNgmWNV
	 gjvZPAEGmALPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uWcj8-00Bch8-NT;
	Tue, 01 Jul 2025 16:16:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: Remove the wi->{e0,}poe vs wr->{p,u}ov confusion
Date: Tue,  1 Jul 2025 16:16:47 +0100
Message-Id: <20250701151648.754785-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250701151648.754785-1-maz@kernel.org>
References: <20250701151648.754785-1-maz@kernel.org>
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

Some of the POE computation is a bit confused. Specifically, there
is an element of confusion between what wi->{e0,}poe an wr->{p,u}ov
actually represent.

- wi->{e0,}poe is an *input* to the walk, and indicates whether
  POE is enabled at EL0 or EL{1,2}

- wr->{p,u}ov is a *result* of the walk, and indicates whether
  overlays are enabled. Crutially, it is possible to have POE
  enabled, and yet overlays disabled, while the converse isn't
  true

What this all means is that once the base permissions have been
established, checking for wi->{e0,}poe makes little sense, because
the truth about overlays resides in wr->{p,u}ov. So constructs
checking for (wi->poe && wr->pov) only add perplexity.

Refactor compute_s1_overlay_permissions() and the way it is
called according to the above principles. Take the opportunity
to avoid reading registers that are not strictly required.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 52 ++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a25be111cd8f8..a26e377a36171 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1047,34 +1047,43 @@ static void compute_s1_overlay_permissions(struct kvm_vcpu *vcpu,
 
 	idx = FIELD_GET(PTE_PO_IDX_MASK, wr->desc);
 
-	switch (wi->regime) {
-	case TR_EL10:
-		pov_perms = perm_idx(vcpu, POR_EL1, idx);
-		uov_perms = perm_idx(vcpu, POR_EL0, idx);
-		break;
-	case TR_EL20:
-		pov_perms = perm_idx(vcpu, POR_EL2, idx);
-		uov_perms = perm_idx(vcpu, POR_EL0, idx);
-		break;
-	case TR_EL2:
-		pov_perms = perm_idx(vcpu, POR_EL2, idx);
-		uov_perms = 0;
-		break;
-	}
+	if (wr->pov) {
+		switch (wi->regime) {
+		case TR_EL10:
+			pov_perms = perm_idx(vcpu, POR_EL1, idx);
+			break;
+		case TR_EL20:
+			pov_perms = perm_idx(vcpu, POR_EL2, idx);
+			break;
+		case TR_EL2:
+			pov_perms = perm_idx(vcpu, POR_EL2, idx);
+			break;
+		}
 
-	if (pov_perms & ~POE_RWX)
-		pov_perms = POE_NONE;
+		if (pov_perms & ~POE_RWX)
+			pov_perms = POE_NONE;
 
-	if (wi->poe && wr->pov) {
 		wr->pr &= pov_perms & POE_R;
 		wr->pw &= pov_perms & POE_W;
 		wr->px &= pov_perms & POE_X;
 	}
 
-	if (uov_perms & ~POE_RWX)
-		uov_perms = POE_NONE;
+	if (wr->uov) {
+		switch (wi->regime) {
+		case TR_EL10:
+			uov_perms = perm_idx(vcpu, POR_EL0, idx);
+			break;
+		case TR_EL20:
+			uov_perms = perm_idx(vcpu, POR_EL0, idx);
+			break;
+		case TR_EL2:
+			uov_perms = 0;
+			break;
+		}
+
+		if (uov_perms & ~POE_RWX)
+			uov_perms = POE_NONE;
 
-	if (wi->e0poe && wr->uov) {
 		wr->ur &= uov_perms & POE_R;
 		wr->uw &= uov_perms & POE_W;
 		wr->ux &= uov_perms & POE_X;
@@ -1095,8 +1104,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 	if (!wi->hpd)
 		compute_s1_hierarchical_permissions(vcpu, wi, wr);
 
-	if (wi->poe || wi->e0poe)
-		compute_s1_overlay_permissions(vcpu, wi, wr);
+	compute_s1_overlay_permissions(vcpu, wi, wr);
 
 	/* R_QXXPC */
 	if (wr->pwxn) {
-- 
2.39.2


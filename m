Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77250279333
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751383017; cv=none; b=dalHW+jmJ7MagGv25Qp5/05qKkE8xrv2FNsfbJ8nBtFo+k5NVq4cTeBd+0usoUYAETBRcPd6c7fodbY+pO3srkfq/ib5vLaWvL01lvQnSo4YU5iaahPLfKk2sXnFIAo9EZPOIZ9trDTEnc2towupdKESKEeccHbS798iD/nibWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751383017; c=relaxed/simple;
	bh=mqhSvweyiaf53SB/vB+8vcsB7iR7pvgyiynVGmHKKBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MXd/EEBTbVqa1Y9UvXgMrrxzJY+NjO+LiHI+mlvU29zNxXmGB2qkNAgiorB1CUM7UD4gQMEN+TXEHiu7n9f6yOMrZmtZkdy2icZgtANNDxRfMrE9wL8JHo761lb4GN/stHOry4BcYgkKUWGkE0PJtBsRjVWFSGtnicWp5IhbKao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKdFmkAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKdFmkAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDD0C4CEEB;
	Tue,  1 Jul 2025 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751383017;
	bh=mqhSvweyiaf53SB/vB+8vcsB7iR7pvgyiynVGmHKKBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKdFmkAcnhMzS6xOj6wnM50T1AU1vLet2lEK4jIR7ND1DjSK27Y1R25I/Upm7t6sE
	 OOXrxMRLvi7QQlOlpv3flY7Rgip6Y5gj0WPrziNYiOChVOwRIAYjL59rEzPZ26wcGh
	 /xP/HbpV2S0Nygo/NJnhHVc1zzKuCEyg6BtsHpmyGrOd7uNakDRNRU+i+QD4LMeZk5
	 qejDt8VaR2o7NKQUwjfT+fisIWGXhEJp0ZWuSxvqGWp/6G1mkdlLMxP/oKR5u/LPTB
	 +lvBaeFGRhHbXBKZh5+cgtktBf4ePidO6CYjl3uQ6A8jqCOA3jyfeGaB2j34s7yP70
	 sRNhr3XDXthjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uWcj8-00Bch8-Ss;
	Tue, 01 Jul 2025 16:16:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: Follow specification when implementing WXN
Date: Tue,  1 Jul 2025 16:16:48 +0100
Message-Id: <20250701151648.754785-3-maz@kernel.org>
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

The R_QXXPC and R_NPBXC rules have some interesting (and pretty
sharp) corners when defining the behaviour of of WXN at S1:

- when S1 overlay is enabled, WXN applies to the overlay and
  will remove W

- when S1 overlay is disabled, WXN applies to the base permissions
  and will remove X.

Today, we lumb the two together in a way that doesn't really match
the rules, making things awkward to follow what is happening, in
particular when overlays are enabled.

Split these two rules over two distinct paths, which makes things
a lot easier to read and validate against the architecture rules.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a26e377a36171..0e56105339493 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1063,6 +1063,10 @@ static void compute_s1_overlay_permissions(struct kvm_vcpu *vcpu,
 		if (pov_perms & ~POE_RWX)
 			pov_perms = POE_NONE;
 
+		/* R_QXXPC, S1PrivOverflow enabled */
+		if (wr->pwxn && (pov_perms & POE_X))
+			pov_perms &= ~POE_W;
+
 		wr->pr &= pov_perms & POE_R;
 		wr->pw &= pov_perms & POE_W;
 		wr->px &= pov_perms & POE_X;
@@ -1084,6 +1088,10 @@ static void compute_s1_overlay_permissions(struct kvm_vcpu *vcpu,
 		if (uov_perms & ~POE_RWX)
 			uov_perms = POE_NONE;
 
+		/* R_NPBXC, S1UnprivOverlay enabled */
+		if (wr->uwxn && (uov_perms & POE_X))
+			uov_perms &= ~POE_W;
+
 		wr->ur &= uov_perms & POE_R;
 		wr->uw &= uov_perms & POE_W;
 		wr->ux &= uov_perms & POE_X;
@@ -1106,21 +1114,13 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 
 	compute_s1_overlay_permissions(vcpu, wi, wr);
 
-	/* R_QXXPC */
-	if (wr->pwxn) {
-		if (!wr->pov && wr->pw)
-			wr->px = false;
-		if (wr->pov && wr->px)
-			wr->pw = false;
-	}
+	/* R_QXXPC, S1PrivOverlay disabled */
+	if (!wr->pov)
+		wr->px &= !(wr->pwxn && wr->pw);
 
-	/* R_NPBXC */
-	if (wr->uwxn) {
-		if (!wr->uov && wr->uw)
-			wr->ux = false;
-		if (wr->uov && wr->ux)
-			wr->uw = false;
-	}
+	/* R_NPBXC, S1UnprivOverlay disabled */
+	if (!wr->uov)
+		wr->ux &= !(wr->uwxn && wr->uw);
 
 	pan = wi->pan && (wr->ur || wr->uw ||
 			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
-- 
2.39.2


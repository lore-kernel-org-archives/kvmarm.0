Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478BC6E2AC
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647549; cv=none; b=eRzX03csu1E08P+PY8LgLWG2MtiFmKUYnzulxCQPZntSJHPq0Im2VG95Q9hUZjODB05gExB0l0WeyLpBcz7gG9IBAS3itU9FK5zE5THzBQQvjFdIqPRhBbH9/KuLqmzOwLQp+K5BipR9olDqIpzc8tXG0fk9SBNzFB5tcPs6rpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647549; c=relaxed/simple;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P7GhynknDc5DSY85VT41cTru8XN5HRb6d7zmc7OsZmr7BhtA9vTzOUdEfXRxvR93ERK8mtu9reFLRZJrsA2MAXIkcgFJriVvmPPFGCmrsKwDhdNj8/mEfcGv66VbKaRuddHf+1WMu85S2ydFW4ejpebfaHec4HBfOdaB9bIc7MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CD4Dvk/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CD4Dvk/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213E9C43390;
	Tue, 30 Jan 2024 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647549;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD4Dvk/3gZwr9x1grpucATIAFq6zwMVI29K3GqFHlJ/5WdS2v/G6sUCEBMlpm9qQn
	 PFzF6yC2HS18bDXeF/kveE+zqzDhphiBVmi+qSA7uf6HggN665VNdab7+DWd97assk
	 s+asExTjnczbwvQEfX4cGBO5UayKUlEUHgaXsnND5lS2z8xauSDxUraCnwefh8+p3d
	 1OYXJRFh+z2kBzQp7welmt2zU/Fe5pocq0XO4h9H7Fnhj5D0zOB4+SAW7Ckqs2dQA0
	 DOh39trCRtcAYX/D16NWZ2uAFrg1/mdcQGtfIR1kXO+5KTkZHNf69BemTxUYWD3xW7
	 O6k71N3+pJQjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzL-00GNsE-Bb;
	Tue, 30 Jan 2024 20:45:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 13/25] KVM: arm64: Always populate the trap configuration xarray
Date: Tue, 30 Jan 2024 20:45:20 +0000
Message-Id: <20240130204533.693853-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are going to rely more and more on the global xarray that
contains the trap configuration, always populate it, even in the
non-NV case.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 70043bd78cd4..57f3d0c53fc3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3995,8 +3995,5 @@ int __init kvm_sys_reg_table_init(void)
 	if (!first_idreg)
 		return -EINVAL;
 
-	if (kvm_get_mode() == KVM_MODE_NV)
-		return populate_nv_trap_config();
-
-	return 0;
+	return populate_nv_trap_config();
 }
-- 
2.39.2


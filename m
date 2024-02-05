Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2C17591
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129289; cv=none; b=Jq+kfx4c26wTakdVcuU+JMsACSP0or+c+MSocAO3jsMJ0/FF1/Guolo+CWlLIQcTsibBGXqkkJrNw/2ZycsgNKFxzenYVPnndgxnFvBi8z2qtAsBK6cRNgiLSivkBUOfl06CCRCyGD4QsyNMqpaO/1w75Fq9qadAYAmpqAfczV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129289; c=relaxed/simple;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPiR3h1ZGmeyoeeBjlsUbcVwaoc4Kp2qbCirQjKlqU0DVG/hdAIiQvKVi3YTY+z2xK/oReYsR7JccGYq4/q7CN7EdObzd+KxdhzyNEY7yByh9chf6eGCIXqOQL+X3u0bMFUjhfI68K/Y/+GA+MnsUY1yRdRUF/aKu3gcJJq82Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7nqYlgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7nqYlgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A2AC433A6;
	Mon,  5 Feb 2024 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129289;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7nqYlgXK4qHeJ56fZdq48sdu6oRzQA2jGkUFShH0u+L6/QE1sC/mQqF6goRHO3Jd
	 NUayy7l8kLc6XV4lSiWLMVpiXfqeBgZ0H6aMov6G3w2sWx6OOfR736C4WAyypRLjme
	 tLm/XIhK6bx41rw1PGbX9btI63kgZopdHPHFfuuKFPdjat/h6AykM2jzxEk1FLDYyT
	 lnM7ehVTJi2cC7UqwgZrjN0zFAX8DumBldAbeGbZHokPoiHrhrk92+urjOAKuTC5YX
	 q/uG7NpWdzSWY2nmwfwuL1ZwMEWYWKcAk5G3hLh1NiutH6F4RFTdHh54/KUbV7s4uI
	 pkr/E3OLSFavw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJL-000Nc3-DN;
	Mon, 05 Feb 2024 10:34:47 +0000
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
Subject: [PATCH v3 13/26] KVM: arm64: Always populate the trap configuration xarray
Date: Mon,  5 Feb 2024 10:34:18 +0000
Message-Id: <20240205103431.1104133-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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


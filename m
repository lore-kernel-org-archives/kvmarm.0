Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1B535D6
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916715; cv=none; b=Ah7Caheo1G3i/XW6VIvqHt3QdrCDIsy1tYviUXw92qkdMaPPsofcbcj6kfG7KVV7wkNZA9Ime6GbIy/sDXhjE4hjtvypAs+j79CrW0vHyAbbz6bBKB2+y3QP116dnCKXcL97mkTdXjwSHAwdGaC66LPErb5MUb38r4Sp+UVuFjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916715; c=relaxed/simple;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkjmErWUFIh7+j4mJm/DDf09CL1U8xmkFbUb3YOsSMXe2A7DM47OxVwk8vM1dwt0PSWrSiDN8DINKupxF4VBmGPUgSOpmGTj55Uvp/ynnrQVmH/cnUlkNy/kErZScwk6+lvtZ/0a+SxNhmTNfFY+jWvDYrPHcRBlLSOwz+2qyMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCr3eJgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCr3eJgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6758DC43609;
	Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916715;
	bh=EjcpbmtgtYwiSeP6njS/Mpa43D4V2P6D38wyQWR23GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCr3eJgbHf5QVmYrl0A+XLIzw8dHff8XKaLpSDfen4pw5hKPDfs/WWxrWkoFyZjvT
	 yw2YWjOG+ThOuuNBRIZns1pnP4xBE2cNyKiJghDrq0n6dmfpqjUCxxi+3CJgif5rL1
	 rMDbrd3x5UMNSwEEqseXo031KCMyZW0nNeX1FiS6XbWMDVmobV1AQEfUseb1l1PKJs
	 xAF/MXUbJLCIj/ofdC0Jg1b8v/zK4nzLHrYizRciwC8LloF9hnG8iqVcQL7hv8wNyw
	 948g/uuwYh3wcpHfOYYsgqAiLTU3EPuNLZndhQJNlU93E7edN9vMvKPCWZ8nWsu9tK
	 Egn2jCxhIZSWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9l-00394l-D9;
	Wed, 14 Feb 2024 13:18:33 +0000
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
Subject: [PATCH v4 13/26] KVM: arm64: Always populate the trap configuration xarray
Date: Wed, 14 Feb 2024 13:18:14 +0000
Message-Id: <20240214131827.2856277-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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


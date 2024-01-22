Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238A40C0D
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954740; cv=none; b=GoWiXx18YaBXhmijyfvbpXOXSBg8t+Ks2/GBZoM04Ws6kNP6NmJ0GQ+TvVCtMzEyTL/ZqlMsSS5hrI2V0IzklGUQloT5tYxhfUsXI4DicwdkaD/4t9245yka/ZrxQdwG4gRb/b2Lwf1Fz7TbhnZtI6jGjJ3oGp+BHSH8Y0J6GFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954740; c=relaxed/simple;
	bh=clnsbqOrqt6mWeMXmXn8OtaEdXoa/FRAQpaMrB9aZmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pkbUUHro/C+edpEa6O+wFO1JmzWM6/P+dx86P+4K31g8QoytVSLVW7DcRcfcdL0Dxn0vCDZwVG45e+FHutrCUOs2fgoPf3W+oRX9XGgQ2weMy+hAI2EV65f3S537svRQD5pDRyZNZwm3yCmY1M+gPLTL+dzrgTI6IiP4aXBxAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfOOn0tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfOOn0tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4860C433A6;
	Mon, 22 Jan 2024 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954739;
	bh=clnsbqOrqt6mWeMXmXn8OtaEdXoa/FRAQpaMrB9aZmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfOOn0tmSNPa4tBQDwnWFoRlIzV/QxyrFZwv2q7UkECAP7oATyUt7vFQrxF62UA/B
	 GoUaRYx9nY+04oMNZYNnrsXYS7MvVZALNqi6DmH8LJMYsSoEKE8sw7kp/x19YSpWOA
	 nk8eKnxkVCI6YZQ3Ytnx18H9JitdKXgthOE7H05Idpj42os+wwrWeSZdFxZvyqFXk7
	 RMgRIdaeaMreqXt3lB01DVdLwi5Hz2xYTDcpM++9aKsXMgYwkeUjiEW23Vfs2aPqn2
	 5yVfczBoqkE6c4wGfaqNW7bluEl691g0qbWhkIFOLWYmPkouOln16DQIfZ9T6vdQ/i
	 6wTv7vm2xRmnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l0-00DjkQ-2G;
	Mon, 22 Jan 2024 20:18:58 +0000
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
Subject: [PATCH 13/25] KVM: arm64: Always populate the trap configuration xarray
Date: Mon, 22 Jan 2024 20:18:40 +0000
Message-Id: <20240122201852.262057-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 501de653beb5..77cd818c23b0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3997,8 +3997,5 @@ int __init kvm_sys_reg_table_init(void)
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


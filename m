Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979E1A0B08
	for <kvmarm@lists.linux.dev>; Sat, 21 Dec 2024 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734775902; cv=none; b=n2CG50Ktz3qTaKt4MAhl6p5o3smX+onMl8AYxwu20MI5heXQ3yXex4WtDUutwBWP7lTg26uAsfk0mwb9a+g+LbdbeS624hZN2C8Og5A7dSftNJCTyC6bIyFOgockzk7+L+peXmzWGCxx9hFNP4tvNYezgmi+46e/2Q15Y8Ezpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734775902; c=relaxed/simple;
	bh=xzpT8hoPYLrSd2qWAi+MnXMlOGItQbvM/3WULduMWHo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=saeuN5agct2514Yss9uGQSqJafSO7r/rA93Z2hZyEw4ll35/IiveaQyw1mOpL27Q0xMjKCxD4BpRoZY07BpB7K/ZwkM8GWNzuN+frrK0Q9efl0Vlt/451VNG6ojEKRA8FGVcCaaBtgja0rdva1g6LY+OGSQ9m/WGy6J3v19O8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rklfxOqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rklfxOqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38644C4CECE;
	Sat, 21 Dec 2024 10:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734775902;
	bh=xzpT8hoPYLrSd2qWAi+MnXMlOGItQbvM/3WULduMWHo=;
	h=From:To:Cc:Subject:Date:From;
	b=rklfxOqJLniLvs7bV2uYS3s05Gt39wdZXU0u2bT1aR5YumutIjxvEnDa/PMUc1ppy
	 qO+9ZI6jog5UmiMvnRFCXQuqfSyvQwZbc9S6timb91xZ7meQ+tiM3bUKvNoYgZpm5o
	 PPn9Vs6o4i4j4XmGA8+o0PZspf5iP9gyReJuiZ1qUrmg2Iwz57jngbSAcOYFcV8cPB
	 OVfXboo5KSBGdqcImoBUymZpSWcccbFhPA7C+IRB4Os+6/kr739laz2P+WHcEhdYSB
	 I7OqbG0/ZxDEQdiD+esPmqKxabekiXfmCNZRYxsN6A347BhTKk9k+RfHSd06nuiX87
	 wzpEOhbe5fxiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOwSR-005uEf-S6;
	Sat, 21 Dec 2024 10:11:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Advertise the lack of AArch32 EL0 support
Date: Sat, 21 Dec 2024 10:11:37 +0000
Message-Id: <20241221101137.1405271-1-maz@kernel.org>
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

Although we never supported 32bit anywhere in NV, we fail to
advertise so for EL0, probably owing to the relative lack of
hardware supporting both NV2 and 32bit EL0.

Add some sanitising to ID_AA64PFR0_EL1.EL0, and reaffirm that
"in 64bit-only we trust".

Reported-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9b36218b48def..9e74f7b38e056 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -830,8 +830,10 @@ static void limit_nv_id_regs(struct kvm *kvm)
 		 NV_FTR(PFR0, RAS)	|
 		 NV_FTR(PFR0, EL3)	|
 		 NV_FTR(PFR0, EL2)	|
-		 NV_FTR(PFR0, EL1));
-	/* 64bit EL1/EL2/EL3 only */
+		 NV_FTR(PFR0, EL1)	|
+		 NV_FTR(PFR0, EL0));
+	/* 64bit only at any EL */
+	val |= FIELD_PREP(NV_FTR(PFR0, EL0), 0b0001);
 	val |= FIELD_PREP(NV_FTR(PFR0, EL1), 0b0001);
 	val |= FIELD_PREP(NV_FTR(PFR0, EL2), 0b0001);
 	val |= FIELD_PREP(NV_FTR(PFR0, EL3), 0b0001);
-- 
2.39.2


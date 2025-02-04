Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A9B13C9D4
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738666856; cv=none; b=ZDlhrA/1Hkq6ZBpL7fe896VKvildVOiES072h8AOkJrrXlMdH/p8iLrPoQjiJvcvnEXUdURkbyMhVqkln9TU2GLfb5jXWHIXFD0AjtBI+bOPRT4Ac7b0Rm/R7qXSyYj0DjXV9eLw++PVfKgTlwMO7U6wIRNyOnQgogHX2/k/8HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738666856; c=relaxed/simple;
	bh=m3XU/Fd2NXLsQavBCf01CsTad7U67r4p4e0+aklnsn8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JXH/Moum1m7jr5xeQxoQwn0kkIPgx5ivmH6VM57wCPdP6cYubGG5IF5r5TZ3/+YVQtHxhySUZ4BniNabmcAwgvoFr3IceVdLm2nOiemedwq0DxxqOCrZzRmTLr4jepEijz/Iz0ng0hNI1aeVC7nZrJ+/uasloSLRuCpyy7LsDyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sG7y73GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sG7y73GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23CC4CEDF;
	Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738666856;
	bh=m3XU/Fd2NXLsQavBCf01CsTad7U67r4p4e0+aklnsn8=;
	h=From:To:Cc:Subject:Date:From;
	b=sG7y73GVRTCxBxQ7IoK72vPhD6dQYXS2oWeStvcbgwPj5VUiKyFcEjM7I/iZkESdW
	 53ev1yzy4HTfoRiJwZ2zDUjwRwZiKRFBzVfrEQJdo4C1axjfaXAd28xBcdTO6ZQET2
	 NjhSShqhCLjCdCLDHTI/V78gjAl1EXkG7YdKlmCrFMuVN7SILfrDYfaYUpfS0mQuS1
	 YgOIz1d3VKsICbDjtsVR5cd9wb23m56KIaj67JaL3tV2Im1u0vf/qJyMsLEdBu26u9
	 Dfz0hdYRGQW+ku+TbYbBKv+Y4fxbhiuM9KPMfzbtMHqzsp+wm6IvsDzhsBJrdZwD2w
	 Fsls+9LDZWLUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfGfl-000OVe-VH;
	Tue, 04 Feb 2025 11:00:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/3] KVM/arm64: timer fixes for 6.14
Date: Tue,  4 Feb 2025 11:00:47 +0000
Message-Id: <20250204110050.150560-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It's been recently pointed out that the NV timer code that is
(hopefully) on its way upstream is marginally sub-optimal (read:
terminally broken). This short series attempts to fix things:

- Correctly arm a background timer in all situations

- Avoid corrupting the EL2 state by shoving the EL1 state into it, and
  simplify the handling of emulated timers

- Drop the weird HV timer offset dance dance on E2H switch that never
  happens and make HV timer correctly UNDEF on E2H==0.

Thanks to Volodymyr Babchuk and Wei-Lin Chang for their help.

Patches on top of kvmarm/fixes, and merged back on top of my
kvm-arm64/nv-next branch.

Marc Zyngier (3):
  KVM: arm64: timer: Always evaluate the need for a soft timer
  KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_ECV
  KVM: arm64: timer: Don't adjust the EL2 virtual timer offset

 arch/arm64/kvm/arch_timer.c | 49 +++++++++----------------------------
 arch/arm64/kvm/sys_regs.c   | 16 +++++++++---
 2 files changed, 24 insertions(+), 41 deletions(-)

-- 
2.39.2


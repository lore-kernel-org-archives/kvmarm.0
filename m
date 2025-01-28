Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB2E1BFE10
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738081052; cv=none; b=ncrjfn7DvyJL1lXeASUKlIjHdjiQ7kZIApw+1VmDnKby0BweCitaj5Iw7VcsbpLMWFdN8NMszWPFtzfNx3eUyFcvDkw8/tJuokERsy1/FUz+x26XA8TSgcD6YeU0SqSKfynD92H7Ok7m9v1AKC0Vw4+UyftuFyhNmvMC7TBeGoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738081052; c=relaxed/simple;
	bh=p+DT68ITXpodlOtFqv3LPnEY38sb9Ym3VdrfO9j9S04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h7hdRQYwCIL0Xu+z2hu+n5aBVBhhl9h8b3VYmKfDTXEUzc0/SLGhbjH5cqGMBy8htKLRO+shavjIQIOgecmiBpUhbJXP5E7zVGmAiB4XslE775/f9EnpiPVO1pam15O2Hdi6LFF8vM0VAE2iC4GORDrNCkfEBaYeqYT5GV3W6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdFGHd3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdFGHd3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021FBC4CED3;
	Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738081052;
	bh=p+DT68ITXpodlOtFqv3LPnEY38sb9Ym3VdrfO9j9S04=;
	h=From:To:Cc:Subject:Date:From;
	b=mdFGHd3LHptAWvmRPk4U1ZKheka1e6hFliuVgd0YPim82dfltJo1AzkKu0icDSsyL
	 s1wyfCHBlOtJKJ5oP6GdYU9/PBanz00uZ+esXrp6Sr5IsWTTIvNQ1ZW+lYQG4jReLh
	 v2NC/Glqj6+qihTQClFcUZZWquAeGTDaCy5MqkQmAatyuAJQJPRdmSW/EYVAq3OOgt
	 rBGLPXg7WFiTgpXJhSfzmV8jqOnQ40WsSawJyzJFdH1JzZVEk4OgScgiYA/IGOXHJC
	 VtWhj8BwVAlyCm8yUdF7sVfIxF03UhdezJ04f4ztafIe7T9VKSblWyWQ7ozm3ftPcl
	 0GXwk59DLyjBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tcoHJ-00G6bi-Kg;
	Tue, 28 Jan 2025 16:17:29 +0000
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
Subject: [PATCH 0/3] KVM/arm64: timer fixes for 6.14
Date: Tue, 28 Jan 2025 16:17:18 +0000
Message-Id: <20250128161721.3279927-1-maz@kernel.org>
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

- Make the NV init of the timers less awkward and expensive

Thanks to Volodymyr Babchuk and Wei-Lin Chang for their help.

Patches on top of kvmarm-6.14, and merged back on top of my
kvm-arm64/nv-next branch.

Marc Zyngier (3):
  KVM: arm64: timer: Always evaluate the need for a soft timer
  KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_ECV
  KVM: arm64: timer: Consolidate NV configuration of virtual timers

 arch/arm64/kvm/arch_timer.c  | 82 ++++++++++++++----------------------
 arch/arm64/kvm/arm.c         |  3 ++
 include/kvm/arm_arch_timer.h |  1 +
 3 files changed, 36 insertions(+), 50 deletions(-)

-- 
2.39.2


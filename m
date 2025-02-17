Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63724217713
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739791459; cv=none; b=lnIMCMEre6XFMQGF+D1usn7bXVIGcOPC9ZJVbVsftWslI9xWsmqGlsuGSDkZTQ31r8KsWQccREj6y4/s2zXmBGyh09zBw8TanUc1Wsy72CR5HbAxKprg0Q6kudPaDsZcruxGViwdL27nRH9Sa48ttUTe+neraj6Y//bxg/uhRgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739791459; c=relaxed/simple;
	bh=VW0lRx1jn83lC+Kf9zPv7uSmERzJHKkPsnqIFNwgmSA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YvdYdOoQhtL5+n470OEz+1xqYOfm40glrFDhmIskTWU7zJW8e95o6XKlZMFCVqGShCXfcVrKdQvkgnq030cnzYKLreQXaM0n77F5RLgZQDwRwV5E1Hx8jaNQgohORTIEjCzDwl6BTAd0vp4AhRQAzW1mTtBBhNNNkDT+pINy5gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUpNClV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUpNClV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F6BC4CEE2;
	Mon, 17 Feb 2025 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739791459;
	bh=VW0lRx1jn83lC+Kf9zPv7uSmERzJHKkPsnqIFNwgmSA=;
	h=From:To:Cc:Subject:Date:From;
	b=sUpNClV3tERLKS5FBDJVLSRNP5avrwqxwAST2S3SxEfxT8n8HJFeMk2iC0DvUHHvB
	 W1R8Pq0+cv/0OYxcw00dZmjCghAvpGV0fenf1OcmqaWtQJypc1zwhzfEf28zIccDyj
	 4+KTOzrAUaj/41S0kDP2bwo57zxAruqurK3t4kAIC1DxGLSakmtuPmxTP1SXXleIYi
	 kAKhGDA8d28Dx1cJ3kcDwg9e7zXXXQ8XYXazCfnoHdFxn7Yv3j9vJuu0SzUbA2ezPb
	 7Y9c1B8oLjM4ZqXwBqsupA6PGIdK5CUu17TPTW/p90dcR5aQvwkxWr/aIUyTxpHxyc
	 OG+MppQLy8Fyg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjzEW-0052DP-ML;
	Mon, 17 Feb 2025 11:24:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: EL2 PMU reset handling fixes
Date: Mon, 17 Feb 2025 11:24:10 +0000
Message-Id: <20250217112412.3963324-1-maz@kernel.org>
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

Joey reports that some of his PMU tests do not behave quite as
expected:

- MDCR_EL2.HPMN is set to 0 out of reset

- PMCR_EL0.P should reset all the counters when written from EL2

These couple of patches attempt to remedy the situation. Note that
they have only been compile-tested.

Marc Zyngier (2):
  KVM: arm64: Fix MDCR_EL2.HPMN reset value
  KVM: arm64: Contextualise the handling of PMCR_EL0.P writes

 arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c |  7 ++++++-
 2 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.39.2


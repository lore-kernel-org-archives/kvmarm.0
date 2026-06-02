Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A2E3F1ADB;
	Tue,  2 Jun 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780415682; cv=none; b=e+oo5i3s5pj9jc4dlhgE5GMsKlVDwqBSWQDgF39n1+PfGRXlrmNlYsy4Ia9R6ettcmsTHpdtLs9wMTqeSK2LucEJx6CByz1GRNEu6numSwoIaCDeBTnsY2BbJ5Sq+QBLHXzfBAbs1GPg6qDG28zw3ecUKKv/7sMzIuXmv7xDRe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780415682; c=relaxed/simple;
	bh=ocBHyx3kiEccfvNU8zKhAxmvsC8d/UQpdICkP5q8x3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pJ4fG/fZnGM7v4wt32oCE1Kc9gP2zwiatbHYugeYZ73umU3/kjfo3DcIuTTFtL8hVKJwud80xZpUPjqPIV7P6VnG+QTT9XaF6CSH7YwIS8xVmjYjoRMZonv6ppuMXuTmwawuyMJr03wKCp+TO5+7HpuBQfPhqXU35Esv7vEKzSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nq+qOgoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nq+qOgoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A683C1F00893;
	Tue,  2 Jun 2026 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780415681;
	bh=LdpmtjSiidN7Icp/40zzSnCBgArAOaSHpyOKHF+30zI=;
	h=From:To:Cc:Subject:Date;
	b=Nq+qOgoWxcnO1mJd+Iml5im8ytupjPhSM6o6I+dDc1bKCECf2HtPtmSdyuvh+Id33
	 zVpyFP6CB608an8cAUDFSLoE65upD7Jho4C4kL1f+eMjsR5np6MkEPZ6FC0LE323ls
	 ZM2lZM+Qbbo3R9b+0dWzShg4hBUwwQVKEHwPMnWrT/bZeyLA7+ZccuhmhzQWxOeISS
	 zGANEIz/YbkMaZu/MWI3lmLKGDl+Y4GzBEwAm4+ElPRFAtGrU4beOAXAWgz0lbSeor
	 zIXuVDdFlLpLvHlpaCQr2Kx3TxFTBng/ClzhR63w34sbFcilvs2ggxD6+P3x5vYpkD
	 8G/Pbu+NSQGCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wURRv-00000008fVv-3HqS;
	Tue, 02 Jun 2026 15:54:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: FEAT_{S1POE,ATS1A} support fixes
Date: Tue,  2 Jun 2026 16:54:26 +0100
Message-ID: <20260602155430.2088142-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Whilst working on a slightly unrelated feature (FEAT_NV3), I found out
that an L2 guest wouldn't boot if the host was exposed to FEAT_S1POE.

Upon investigation (and hours wasted in a SW model), it became
apparent that while the AT S1E1A code was ready for action, it had
never been fully plugged in (blame the usual suspect...).

This resulted in an extremely odd failure mode, with an L2 being
unable to make forward progress, but KVM at L1 not taking the hint
that something was really wrong. Additionally, an embarrassing typo
was spotted in the CPTR_EL2 handling.

With this in, FEAT_S1POE no longer breaks our NV guests.

Marc Zyngier (3):
  KVM: arm64: Key CPTR_EL2.E0POE propagation on FEAT_S1POE
  KVM: arm64: Wire AT S1E1A in the system instruction handling table
  arm64: cpufeature: Expose ID_AA64ISAR2_EL1.ATS1A to KVM

 arch/arm64/kernel/cpufeature.c          | 1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/sys_regs.c               | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.47.3


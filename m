Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFE023506F
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746010771; cv=none; b=kO7pSm2wAOdpsI8K8CG8/lc8FwgfwZ+P4mzlRmdJjFwh0MZOFfi7IPMJmq7yiB8dzWc7O5V8Xvuw5Sagxn+GHyGytQ45VzpzlSig5fVkhopoLqUY1YlrtFxgLyQBTcFgcpMH+9mDVVvPXNumIHqpcs813+Fhh22WKdXpypQT+Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746010771; c=relaxed/simple;
	bh=Gf0bCDz5S9cCsCORXQdBpRMQaop0LeWmIkddCqh70K4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H9atvrATVE+2m6pR2DuX9v7CLd/MeewxMo/Q55ajjZRKhuVpQnSl0Oyhw6A9RODmisbv5VP2b+QxU5T/7uUC2SIqhFPosOeDNVs182pUgtZUKJOtSghbgt0CAr2pwRH08n9nJAP78mv8NVAy/yGD9jDBIQRe8Bm3uTQAl7FD5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0Wtf3k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0Wtf3k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3710FC4CEEA;
	Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746010771;
	bh=Gf0bCDz5S9cCsCORXQdBpRMQaop0LeWmIkddCqh70K4=;
	h=From:To:Cc:Subject:Date:From;
	b=W0Wtf3k49S2t8o89mCdewJkS1VjicLI/LCBqEUFRRkIrj8k8zgkKFIY3BFP0Eg8oL
	 CVVkOuk2GgZaDfWDTm46Mw+xXCmzdnpj+E9Bak7u+BJo5PR4XFRWqeZrgMZlptRmqK
	 WJTiZ4tBg1u8HZzz0X+Xlo3tx4rRyaIDL20RFwCsqLFNG33IK/gsiHuc6zU2eUurf4
	 wHDPCT3u37RmX8ZLex3kYwky+AAcp9p8Engfnd68Zratb7WiOPCWgzv3KwmjLpIRFk
	 riOcg9VYka/OoGUvmQ2CqFFMcSahL4kNnKibuCu8M1ZlSs/y/zAARo7LC4jDOBtX7M
	 Wnhyo05A1kP3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uA5A1-00AFD9-2M;
	Wed, 30 Apr 2025 11:59:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Fix HCRX_EL2.GCSEn handling
Date: Wed, 30 Apr 2025 11:59:14 +0100
Message-Id: <20250430105916.3815157-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Will points out[1] that GCS is completely busted on the host if we
ever run a guest, as HCRX_EL2 gets set to a fixed value on vcpu exit,
value that doesn't include the GCSEn bit. This is likely to kaboom on
a nVHE/hVHE setup.

Obviously, nobody ever tested this.

This series moves the handling of HCRX_EL2 to being correctly
saved/restored, which should address the problem. I say "should", as
in keeping with the tradition, I haven't tested it either. Or at least
not with GCS, as I don't have the correct SW setup (I don't even know
what you need to enable GCS).

I'd very much appreciate some help in testing this.

Marc Zyngier (2):
  KVM: arm64: Properly save/restore HCRX_EL2
  KVM: arm64: Kill HCRX_HOST_FLAGS

 arch/arm64/include/asm/el2_setup.h      |  2 +-
 arch/arm64/include/asm/kvm_arm.h        |  1 -
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++-------
 3 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.39.2


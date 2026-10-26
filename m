Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016079;
	b=KQnNifcXQMkjf1zgsXknstMnVecC73N9pJaRU3C/SzaWkN+nQIrsGkNLxol4k1T8J08G
	 2ue9B/k20+uTVX3rdHCAFsGw/P20dzb//pBCuZtqG70+PZT35H+e/qYfBE/KSZAxj2xS4
	 i5hku56GRZtQJYRoCDkvXwV3ldrsH5ekMRzDWis35ZD+FvyDJ1BRF2LUiKksP4u/M2bhE
	 HlGblxxN6OFI41lB3YzYHz0kViMnxcFMLbAvljXoWGbnSqZ65WG+zD4oCijXU65dMczur
	 3YK02liIweaCiotnIH6Yn+ernRvpO4R3ZJlqgeWysZFNUyv0a4oFxNGTcd9P72Qrt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016079;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=pK1qmBovPzYfB3ZzFrf8FUWg+ydK6y3N/RQGf4cuhQo=;
	b=gfIBHpZlZ7ukOUmBE62CiSADhI/kfgR+JyZBWDFVEa6S/JzSw0GTvdZLvG7z3qDaEQbd
	 HqjS8gNe8hTPxiwnZIaXiPfIRU499f0MczPHaGOSVNaLuruD2N/g8crwaZsEfdwfXHrgt
	 GCpWvuT9CjhEaN6NLab9nxsIWIYEXQBpy13LhYqS88Yw8JVQoBkHfsOiSn+b1Qr8kk+IP
	 SUKjXnCVsZXYNCha1TyGOEqlLP0gxQdDzGPwZ7SNn/iI40deg4IKlnOynDawqr7LSXq5F
	 v/WmwQfMbUFQzztPVWK0foOKXizB7ZOFzLDiDk+4PiwU+2XpJTkeE7UOvA/0XHl+Iqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCyfKJ8S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B330606A328;
	Mon, 26 Oct 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCyfKJ8S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71451F031E7;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016079;
	bh=pK1qmBovPzYfB3ZzFrf8FUWg+ydK6y3N/RQGf4cuhQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCyfKJ8Sk1u2p7TWWb66+451JbY7sbDrDHiqhER86e1qaoaF4aaDX08kkB2sEg51Z
	 /8hWcYzkyAHdh2SnyaE/MVY4MRyQcTtw/BsfPD+2rVmAs9HKR56+6VO7tAxQM804wm
	 Dx8QF+nhFqkksBhxlt2oiQrxeVLqKqy1k928owpymqWDgcKieln+/D41nxRqtyluW8
	 TtyLAOtR3B43Lkhxt2mUGAjLq3Pf3ihI6pyQbAYBmoqoqg2HZYv5Ziv6dSTvpyaD5c
	 DA2OEIpyDQiC8sgF94RxGGkMvQ5UxbCh0oCJoi4BAeza6lSriJ1URAQGt8d3TMGqYM
	 26ZVKSbGZkosw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO9-00000007Fr6-0n1y;
	Mon, 26 Oct 2026 12:01:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 0/2] KVM: arm64: Cleanup the HCR_xyz macros
Date: Mon, 26 Oct 2026 12:01:03 +0000
Message-ID: <179301587178.2527370.10543085363432691237.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015173605.1072963-1-maz@kernel.org>
References: <20261015173605.1072963-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 15 Oct 2026 18:36:03 +0100, Marc Zyngier wrote:
> I've been postponing this for some time, but it finally happened: no
> more HCR_xyz macros.
> 
> This series converts the whole thing in one go, using the script
> fragment contained in the first patch. No AI agent involved, all bugs
> are mine! I intend to take this in for 7.4-rc1.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Convert HCR_xyz to HCR_EL2_xyz
      commit: 00869b4a26deb3e52b2ad21f4239f3d533eb16e0
[2/2] KVM: arm64: Get rid of compatibility HCR_EL2 aliases
      commit: d32084d26c217b85e53c61d577178d5aaebc2c5b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



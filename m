Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016079;
	b=ZEuH48RRGgEqn3kNkz6nzltgJwUr8rVKNdltMDD3luZTjG2X3sqH5LBBD9nCfKBFRX7R
	 4oemY+Dkli3OhNgostKyILQW7hb5Zo3I6ThHpI1MixmVaU9Qm/oCy3H38SYv6LpBE4uCQ
	 PjnrpL9M8D6IKGUK53VRD/rmQDZhWN73PykjsdQFsPsPQ4WJrELP5Wd232E6BM8MTKO1S
	 zazAdPu9HtcSjVQDIIfDvUYiClkoAqvQTQzVj2Yr50wK3iuJGUVEFbQ4usakXYm//0/w9
	 LRE1pyS1lypDpbMxL6g2AOUZPx5AO3rperU8ehwul/BL8vRYEo4UJjZjYyEkZqWS7+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016079;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=X8Hx9gqAZ7Cne8MmPIj8pLeQAmVLqZqqq82MdU8ljig=;
	b=Watjtwghyq/gqmkdSWjuL9eKz2kxpAg3vYT3+7yKeOCu00nZOkNt+IUpDvBvhKjYtY+v
	 Ix4x9jTGbZDX3Z9dtSXLG6meeH0UGAfvhiYDha/S0KIOa0R1ruHq/7ovP4NHvemnfIM3F
	 u7LdaMFHkC/6ZcUpRzQmwDWy5e3WNI732oVYANw7/YFjKriSzFk3tLEzbPbIqVAx1kRJ5
	 oUlk5Tb6hbVbp+9TzgTJ9DF+xGGYfGnB3xco2WuzL6PTkT2kmsNkK8sYn1Iaqpl2OVM7Z
	 ZfMtoR1jUI8czejEr6AEZBFZrCbtG6S2gMxZF1EGI1tWzvJSQRjcEWbDnaepVbshU2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KzpbDf4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C881D606A32D;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KzpbDf4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18E11F031E4;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016078;
	bh=X8Hx9gqAZ7Cne8MmPIj8pLeQAmVLqZqqq82MdU8ljig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzpbDf4BSVpgOn3JQoqSd60/O1rCDiDrdCvWWFMNc5Xuya0pFBDjaK+DWTN9wGIUi
	 0ei6tFP7BcQrS6mMWmXbXBGh2qvlbqZaOone15E0S1mvvt0ex9JJ5Rs2fIf/cgIPMp
	 4gZvQJhE35flAIxCEDliyRxPf5WV7Qw5M/Lhg3MoGLFOtYCg3qyWz4oV2qFgAG5RdI
	 8K9+JbgSb6eMN70PVBnliKL+RsFhBe7fd7n0788ChBym6KEtbkwkHhUqQBH/8yTgAa
	 g6ZpOkcfqkWvawRzNaIRsNusemJxNw9ShsQzJWZsOCXH/1UMAVun42eEtJhO2qA6qZ
	 alIGmf3Kmk58A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO8-00000007Fr6-46Zp;
	Mon, 26 Oct 2026 12:01:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Date: Mon, 26 Oct 2026 12:01:02 +0000
Message-ID: <179301587206.2527370.15001063107819712970.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020064306.1542865-1-fuad.tabba@linux.dev>
References: <20261020064306.1542865-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, broonie@kernel.org, ljs@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Oct 2026 07:43:06 +0100, Fuad Tabba wrote:
> KVM uses the VM's ID registers as the source of truth for what the
> guest has, but userspace can expose S1PIE or S1POE without the features
> they imply. As per the architecture, both imply TCR2 and ATS1A, and
> S1POE also implies HPDS. With TCR2 hidden, the world switch skips
> PIR_EL1, PIRE0_EL1 and POR_EL1 while KVM doesn't trap them, so the guest
> accesses registers that are neither trapped nor switched. Under VHE,
> that leaks values between guests. On nVHE and hVHE, pKVM included, the
> host kernel resumes with the guest's PIR_EL1 and PIRE0_EL1.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
      commit: 68c11eed4f8097ef1b71c30679e96eb654df29e0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



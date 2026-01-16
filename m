Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2891E3DED;
	Fri, 16 Jan 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768556901; cv=none; b=edlfwMTwwKN4LT/NN8z9o8NH4XfgnVrEVSRitv1cnnxL/uE6Zd0oWZ5acmcaSJzj7lXiOqUQSmkh3AA6H46WAXGvIm26BZNWXFdNWs4d89HTG7MpvL4mUoeLAqfdmVV5YfVA2A8PbslDX5uybMY7Ne2dESFdPQaf3IVlha1FLXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768556901; c=relaxed/simple;
	bh=IkRVBCOnX5HiBP2w/6X2FnPTKDEDjwhHkcdCqYBot/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVLdOhNw5GdSvXMOP6nhaF/5vZTiJbBPyrVb94Yovi+z3nA2+e/kRMLOkOS7Df893r8rLrCjq6fWWzndVefkwwYdUEY8gp5bgojHmF/Dd/RH5lnIIVqIR6vvNl6Zrhv6gv5h8kuBcvyxLfJ8/3yEcRkPYBj1iuYQV52UoXB2O0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQEQeryX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQEQeryX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509D8C116C6;
	Fri, 16 Jan 2026 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768556901;
	bh=IkRVBCOnX5HiBP2w/6X2FnPTKDEDjwhHkcdCqYBot/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQEQeryXltRdA+zXbpY5NVnnTOZw/TJVEVt0yqB6+A9uwzj/rN98aC5ffAIJMaDtE
	 wt39HeBjd5DVEQO94CD5DHvX71hgo8+pg6PDFESpWQgM29U/PEc3N9/PxqCo02B9YL
	 UXw4zi5FEz0+Bn2QciAWj6RfF5HuGi3Bq+2x1s9lpqTLfNP1mvLvMhJ58Jmd5mLdHS
	 S+BxQ3kbWSzq1TQT7wtK0x8Ab3QsO4r9tXQik6CB2PYIfWKxSIkpAIpMzq8997pu3Y
	 j3IlYbu5APx2AJp3JLo6/qaW7Xqc5DhKcXBxgndGimqWdPxz5BrOwnwSLGm4jxK9hD
	 yZUYRhdEh7izg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vggRG-00000002pcX-2qTD;
	Fri, 16 Jan 2026 09:48:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>
Cc: Bartlomiej Grzesik <bgrzesik@google.com>,
	Tomasz Nowicki <tnowicki@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
Date: Fri, 16 Jan 2026 09:48:14 +0000
Message-ID: <176855688030.3828453.16084185280555582394.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
References: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, korneld@google.com, bgrzesik@google.com, tnowicki@google.com, sebastianene@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 14 Nov 2025 11:11:53 +0000, Kornel Dulęba wrote:
> According to section 13.2 of the DEN0077 FF-A specification, when
> firmware does not support the requested version, it should reply with
> FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the error
> code as int32.
> Currently, the error checking logic compares the unsigned long return
> value it got from the SMC layer, against a "-1" literal. This fails due
> to a type mismatch: the literal is extended to 64 bits, whereas the
> register contains only 32 bits of ones(0x00000000ffffffff).
> Consequently, hyp_ffa_init misinterprets the "-1" return value as an
> invalid FF-A version. This prevents pKVM initialization on devices where
> FF-A is not supported in firmware.
> Fix this by explicitly casting res.a0 to s32.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix error checking for FFA_VERSION
      commit: 582234b0d8419e0b6cbfd87ae3f80568c8d0917e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



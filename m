Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713526;
	b=i8DPVkmM9O/UIHkO1Ok6TNLFvrToodXZOCHvwAeJoqwj5z7cgdYKDJI/UWcz8OeRZRwi
	 pALR84KdlyCNezmWjuq+is2qLMJJVbEFwUYo2poKmIt1eYOP7Tk1Mo3xAl+hG9Y9WFFfe
	 HeVsGcVlE7HmKhFFWJ0aNphvWfj1k9pXofoUAFkK0yl1Lh51PCRcoq3eCXGukP09laCpe
	 4OPQKmgNPw4O9lKnVJVyJsuiSaleaseSm+r62YOLD9VEo19pdsBRiZUJcTcINYdGnXAEp
	 wGnp66A7mMUqqxgLUFGYk5dAtIMd/36cSsWnKBKomkfTIHvaS+cBXTIg86WT9d02ykw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713526;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=o2yHkWvEtnkN3A4WpDWBOkZ18GIYbtWW9UYNN4OxDqg=;
	b=hMlUKWj+HyDD2OjBuJfPim5DxylfsEd0pMhqqd7jvW/bIPAf8yh5zjxhHj0oJKO54VOi
	 P/8rY2fBb/h+pVo6Uvt1eD9fBdOtgLoj/BTupQCioQrz7zdlym1+252/nMN245X9uUF2B
	 GMDSodJ8Q158FiAk8OMiFQdoWOPK3M8hhTIIWgIimH3Qca8FNkhqynwVm5161eNuNouSL
	 YKufKN+gDx4rO6rWz3leW5lRLtWvO2Fz+YBRisMQIIU9DkPnmkh43LgRDIXlxpc4uQPip
	 1lTmHCcKu7OAgZkcbygwU29kOfzp8+LJWPO7knSqK4G+EKA8XrMMH6KJVJtiMoePrFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nSozD/rQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A232606A327
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSozD/rQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E721F000C1;
	Tue,  3 Nov 2026 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793713525;
	bh=o2yHkWvEtnkN3A4WpDWBOkZ18GIYbtWW9UYNN4OxDqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSozD/rQBtSjk2s84ewtiC41JN2DFXotkiWN1SGqWMllAy8LORSqRGlxKa8LRIUqy
	 MrpFWX5VexARUMVb1r47HRskEk+iIKiVS/iztX9bjs7T2IYj2wkNZZcTWHlSRXDti8
	 QTYuoTpbuzZZcCj0NkvP7T0z6kGEr3x3meqAwC9+7hxzplAhBWnGHWgl4lhjOnoqi6
	 og8JJSAoVeaIu+rp54rYcYB3lSHSTeBqjE8iygujzBg2MXHKCmOEBcF6C6f7hC/3Yt
	 bNqTA1iPMOcQvn8Nm3060TuhCwvWkoYsmvRfw/npt7nUKDOmmP8MYxsP3Z/iHd94eh
	 TFfGk9Jlku2Zg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEpH-0000000AV4j-3AiO;
	Tue, 03 Nov 2026 13:45:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
Date: Tue,  3 Nov 2026 13:45:20 +0000
Message-ID: <179371351576.2945223.8554229259448605252.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026082633.2515820-1-maz@kernel.org>
References: <20261026082633.2515820-1-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, maz@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 26 Oct 2026 08:26:33 +0000, Marc Zyngier wrote:
> FEAT_MOPS is fun. CPUs are allowed to implement any of two ways to
> perform the memory copy, and the hypervisor is in charge of hiding
> the difference between implementation when the vcpu migrates from
> one to another. This is unhelpfully signalled with an exception,
> which KVM diligently handles.
> 
> Today, we don't really make a good job of it in the sense that
> if L1 also has the trap bit set, we don't forward the trap as
> the architecture would require us to do.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
      commit: 51f7c4a7d311930868041634bc041633b94d68c1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



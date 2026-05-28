Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF3A384CFF;
	Thu, 28 May 2026 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779960247; cv=none; b=t1AI3uZDXToeJrfwY3I3D8c4/vtnR1Lh+F9G+IXPpJ1JtdyHLR0C3IFAbFOZfpHmPprn92qzNPJkjwz7jzcDUvK8k6QmWoH7r424IZs73r7btPk++2uAfzABRlYeCW2egMH8EIvn8cAalpVUgNf8cem3q59AJoh8j+tzusjiDI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779960247; c=relaxed/simple;
	bh=RGv3OfEdDojdGp3cCxib27mjuJwnWlpLHZIeGOSHWR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFkCZ2yoDqpGkKi7nr5mxDAvsjq/HE/Ro0Keknb7ny17G2JL+Xrr2cgWLKJGR3EFNiTJo0XpW5GIWaaTNk4aoGxSbpayR51hfomnhtweJjmuiaY6KnWlf65XDCBbVAxzzng9bO9YYcemuf8rCsW1qcuOlvTLTmjUpJokkz//LGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku85Dlk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku85Dlk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B891F000E9;
	Thu, 28 May 2026 09:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779960246;
	bh=BIfn+AcWvUSTvZoWssHiVYP+db/bu8cCcQh2iVRttTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku85Dlk5bbc6YYEDeHnW50vE/MFzA10CHIyqU2BPc3jMyoXdHZsdXe9/EDRRQMOh4
	 S7RVJ3AuzN6rPiBpxRoKx55CwuMaxR6Qb/jNFPMDt+A6bRVSaUMKxbymlZFbu+3zZS
	 jfmrrJDagnVcOU9wMUuaZZ/h0XJLhvWSJtOZBUi+fwEg8zHS2l10MgCUokRdvmzY4X
	 jqo9l9QgsogaYzGx48qS0cUmjoCiick/BFoWwLigSnjdmm3DZG09D9ZeTViU4rUyad
	 QquIlstJdHPPHuk9NyOHwhTbHPiHOiq7z861sdF0JBzlIyzBOz30ymAlICLDqUQZht
	 KnCyHBgYmzK3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSWyC-00000006yjL-0Wbv;
	Thu, 28 May 2026 09:24:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Handle unsupported guest translation granule sizes
Date: Thu, 28 May 2026 10:24:01 +0100
Message-ID: <177996023466.1525303.2108207515102273832.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414000334.3947257-1-weilin.chang@arm.com>
References: <20260414000334.3947257-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 14 Apr 2026 01:03:30 +0100, Wei-Lin Chang wrote:
> This is v2 of fixing the granule size selection for software stage-1
> and stage-2 walks. Thanks to Marc for the feedback on v1 ([1]).
> 
> * Changes from v1:
> 
>   - Take the entire (v)tcr value for TGx decode helpers.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
      commit: a878096e0e86b44e758aafc6b26af97e8f548673
[2/4] KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
      commit: d7768b4f718503e79e7c626d29e9131b747148ee
[3/4] KVM: arm64: nv: Use literal granule size in TLBI range calculation
      commit: b154da8288add1f6fb958797d0b3462800f9fc77
[4/4] KVM: arm64: Fallback to a supported value for unsupported guest TGx
      commit: 8853566dfbab1a255ae72676ab5ec43e1631ddb7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



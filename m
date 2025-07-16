Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D092F5333
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 16:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752684498; cv=none; b=EW+XtYdwNT884POt8re+hX8LhVqz6kBhzKJYu7ZAfHOHLD1K0chNaEQ2mTSzTgxoClCg87gishFbV3qhME6c3FcUJfsGnrKjpkm2ZvpM5Hws/uLN+u8N+dID/AuUf4JqqqdAy5EsJQB4PQcz8xbP/nwJkI/FGlBYo0d9LUXp46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752684498; c=relaxed/simple;
	bh=IU7/L5RxATOuX3yZF/QTSGN5yb2p79l4vw6T4rgjhWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MM6r7k0ZLugFJpRUxauR2MSxWzycvpqV0tif+WShNCu4swKqH9lRDcBynYIxOwrax482QqBlISd3aRvv9eVyV7LFA5cP5tKc4CM44hjIIV5MR2s37NRck9rqSNiJt/VGsztJFv0X3CijuIyfwMjM2hllgJ8q0OeNObwnbKiwS9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pjt3hVxA; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pjt3hVxA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752684493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLeTs7FZjD4WJ4kxGKwc0GaLx29L2ONQcpWFPljBYmo=;
	b=Pjt3hVxAAPI5DQD3d/xhtNQ4TvfdzRo47XlJhBw1vrtwqkKb8QDYBQ7/GLI/fW0qfFmyn0
	DI89u4nTkvomLnprtdtM5+l973E29Q6If40UREFo6ErK6LaLWqxHlkjZq/9yPNLpksBKmM
	eBMmBrPqop+EWNuwcUKCqeXo1FxaveQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/5] KVM: arm64: Config driven dependencies for TCR2/SCTLR/MDCR
Date: Wed, 16 Jul 2025 09:47:54 -0700
Message-Id: <175268446558.2457435.12236491763380805714.b4-ty@linux.dev>
In-Reply-To: <20250714115503.3334242-1-maz@kernel.org>
References: <20250714115503.3334242-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 14 Jul 2025 12:54:58 +0100, Marc Zyngier wrote:
> Here's a very short (and hopefully not too controversial) series
> converting a few more registers to the config-driven sanitisation
> framework (this is mostly a leftover from the corresponding 6.16
> monster series).
> 
> Patches on top of -rc3.
> 
> [...]

Applied to next, thanks!

[1/5] arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
      https://git.kernel.org/kvmarm/kvmarm/c/a3ed7da911c1
[2/5] KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
      https://git.kernel.org/kvmarm/kvmarm/c/001e032c0f3f
[3/5] KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
      https://git.kernel.org/kvmarm/kvmarm/c/6bd4a274b026
[4/5] KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
      https://git.kernel.org/kvmarm/kvmarm/c/cd64587f10b1
[5/5] KVM: arm64: Tighten the definition of FEAT_PMUv3p9
      https://git.kernel.org/kvmarm/kvmarm/c/3096d238ec49

--
Best,
Oliver

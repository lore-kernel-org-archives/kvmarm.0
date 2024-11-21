Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BA64502F
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732177104; cv=none; b=uPRMO0PTXPVc/lk63F6QNOMaacUi3vLQD4wFop7o6cVQuoa3Hs9wdGPWHJgxxfcdSTvOwAl5JJckt0k+TN0p2Lyd2qBlRRO6EAPYkiQYEpKBUIq9YSsAFXpbR2KUQepoxNBanwu3EXObaIE8pZJLVqK0k7Vgq7nWherNjWy2zwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732177104; c=relaxed/simple;
	bh=lubLHOcZ4lpGIxrYzHsF9PwVexXg1u4y7Ees+c8LtaI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiByf2Xw61YXh9wGXJJSZwF4Wmfqrbiv0ACX7ovOCWFW76YJENojHCz8RFk8pPzDHz7rZvEbkJ4GHDK7ucLJcDH7V0MIEctDisBpbjc0tu+L+kokvE4lpWHXxPfF/CGv8zAoQas8G3ndxB5CWj/aCO4GKYJ0and00oMCzzF0td8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lzwuoQyR; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lzwuoQyR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732177098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYcHKE8tyoWtehGQXuSiAC0jZIaeRsKbtVQnj1j5LNs=;
	b=lzwuoQyRpN05WMzm7JMvpm7y2AWGlS/wciqfMOvDH+fc7A1H8VPaWmMeth1kpyz5NQFhJt
	phjKWq29bx1pXWD+AN2gD4qDyl02rm7i7aNKKDQBKkWfVYTvkwdS03B19sLJVrDMLOt9KF
	SVNfcqfwlep0FUnBoD4hUHNSQfUAT3c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Collection of fixes for 6.13
Date: Thu, 21 Nov 2024 00:18:03 -0800
Message-Id: <173217703275.53090.15374156507586889757.b4-ty@linux.dev>
In-Reply-To: <20241117165757.247686-1-maz@kernel.org>
References: <20241117165757.247686-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 17 Nov 2024 16:57:53 +0000, Marc Zyngier wrote:
> This is a more or less random collection of vgic fixes, addressing
> issues ranging from "purely cosmetic" all the way to "pretty annoying"
> (of which patch #1 is an example).
> 
> The general theme is around the tightening of the internal API in
> order to make it a bit more difficult to get things wrong, something
> that I'm particularly good at. There is a bit more I'd like to do on
> the ITS, but I'm testing the waters here.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
      https://git.kernel.org/kvmarm/kvmarm/c/d561491ba927
[2/4] KVM: arm64: vgic: Make vgic_get_irq() more robust
      https://git.kernel.org/kvmarm/kvmarm/c/add570b39f9f
[3/4] KVM: arm64: vgic: Kill VGIC_MAX_PRIVATE definition
      https://git.kernel.org/kvmarm/kvmarm/c/e7619f2a2f8f
[4/4] KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry sizes
      https://git.kernel.org/kvmarm/kvmarm/c/3b2c81d5feb2

--
Best,
Oliver

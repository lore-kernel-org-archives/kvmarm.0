Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE513C812
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 08:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724314572; cv=none; b=C8UWAhispfg5s/Xo2mWGtecXs3RtOw4DCWQH4ilo9tqI+9jwvR7njDRkCIClnV9CyRkDwGIocHYbQKIDwYwaAXwwOrfuoYYNSKbek8uRaqu5QylWdkdMe3IP1uUYcI0Vi6TD06ReXmLxpBrkK/OeIsBqyF5Xf1zNKvYOOFwbSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724314572; c=relaxed/simple;
	bh=o5E46Xsb+BlTB2zC+u0hFLeCrAXDtPVQ6nr9N66H1+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1sX8GZ+gK09vVWoiHWoKGAaUJcvPQKQ1zoYkwS9yoX3c5JJJxI7iGFMYjjCm5ebfrbrGvOlebsQ0/GucycDJ5yD0/MbwJHeUK+G81atmeiIi/90hZXbvrw4LCbsJTff36+H2k5DIkEoPWpAUKCoA8zzCyC+hNima6qG7rpAYi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jqxinqx+; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jqxinqx+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724314567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1gK+Roe+VZc4bhdfUlpfcFVrYk93QsyMczdTtdp7Mk=;
	b=Jqxinqx+WqcC2agGavlOiXIaKq+HhJTYeGSdWbOftYI9H1NPTixbPV616iIKrC9edDoRMW
	P/nt4GfHbfBlZ8BP4icfPUX4eF+iMalCGTiZH5QWml/JDx+LmtNKVMBcMFrb4Ct9IrJFRV
	xL7X5ZaY8s2RG3q4MuhM/DHuKCvf67Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: (subset) [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Thu, 22 Aug 2024 08:15:55 +0000
Message-ID: <172431442241.2387551.1840120236670803060.b4-ty@linux.dev>
In-Reply-To: <20240820100349.3544850-2-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org> <20240820100349.3544850-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 20 Aug 2024 11:03:38 +0100, Marc Zyngier wrote:
> On a system with a GICv3, if a guest hasn't been configured with
> GICv3 and that the host is not capable of GICv2 emulation,
> a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.
> 
> We therefore try to emulate the SGI access, only to hit a NULL
> pointer as no private interrupt is allocated (no GIC, remember?).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
        https://git.kernel.org/kvmarm/kvmarm/c/3e6245ebe7ef

--
Best,
Oliver

Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660791EB5DB
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675517; cv=none; b=Q/y+qa91wgvxcKTY70muOSRqQTO8gFuOTNtBMWGttG7TVbqjyHS+klVjhYAOoQRpCi6I/hbFfad0gAxLyvxj7f3nTiynEJa9/fVqkgd6Y5O/Eh7mfrkv+b/oncTLggHKZSv9PvlgQksPEKgwlH982Kciz5udIhzW/q2llKQCOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675517; c=relaxed/simple;
	bh=hxrjISdcMq/zhiwSZtMIXiWoTS8p4piOhKFH3YSYVqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3aXmaa3X54IFPuCq1Mcnt/b2X/r4dQzfzAHv7KM10C3wAdWwtueiYFY1T9pdMfJbYY+5UKAG7LxFFlgNlvMdtMcVHMP+yQEfr/42/HYqQrQZeocwTMM9Tt9r5+lQXhTx1wb89EgBIWpiadyoJ7Q0jTuYW6cnYvBdz1ja3OBDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TjBv3uTP; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TjBv3uTP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uthDb2V9VnfDGIFco/8/5Vth9/1+6ayqM33H17ywDDw=;
	b=TjBv3uTPpnUUUk1BOXj2DLhhvAirakucf1WD1UeUTLhIZzcMCu5BrrLjQSiNCyZ48vzpYG
	AcTpsZu1YGa/k38Jxuet+m5Hqn/IhN5tAHbcarvWnCTsURVefdFTUfJ9EcW5oGyj5MVUTG
	hblrSi8R7bLZ0CuccLJ4J+pBnfFS2f8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
Date: Fri,  8 Aug 2025 10:51:33 -0700
Message-Id: <175467548051.670500.10792473108238657623.b4-ty@linux.dev>
In-Reply-To: <20250730101828.1168707-1-maz@kernel.org>
References: <20250730101828.1168707-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 30 Jul 2025 11:18:28 +0100, Marc Zyngier wrote:
> Instead of checking for the ESR_EL2.VNCR bit being set (the only case
> we should be here), we are actually testing random bits in ESR_EL2.DFSC.
> 
> 13 obviously being a lucky number, it matches both permission and
> translation fault status codes, which explains why we never saw it
> failing. This was found by inspection, while reviewing a vaguely
> related patch.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
      https://git.kernel.org/kvmarm/kvmarm/c/07f557f60a9a

--
Best,
Oliver

Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE33F9E5
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707761160; cv=none; b=qjM90RmcBcYgui68z2R+jrVb1aOwc53PIh0GVRgSaK9y0ycG9VMoZcoNidVuWTiaCY3UCQWbzaB+HQtBMwfW83mGQ9Drhx5IdsMyOMpl8ztUQvcYleJ9U69e0zn8igTxtOPVLyHNL0Ev9l+oV9+KR8CbDAMvJh9d+hhlumzKPg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707761160; c=relaxed/simple;
	bh=Bgr4GvMQac6syWW4micE3Z/3TOPNn4+EOekg2y6fOTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEdAO8bXzlcb171KfW/pWFswKxqfyIad97Rq6a4ppuHdPNSQf5PVqKx1idIbJSPQKJjbc/hCgoWWmL38hNL7IfVpRTmy+31P2YB/lfss2jwbc32YVOq4iHcdi9jF5I5lE40i6acHznHzdp03nfArb5QJMTYgv70rkQ08z6qU/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IOMZJLh9; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IOMZJLh9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707761156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wb/muvq9ooz4eM0Ys3tybUTyrCipON3+4mc5fnC8K+k=;
	b=IOMZJLh984nJOGuhIzI6uGRNioUDClVj2rS2P6IP8K4CPboJa1TS/xSeAkv7fFSijXnOuW
	jk4f79jv7yXezZx9p2+cBPomUX5SYiOCGXGxfU+sD1iyBFJIsWQc0Mi18gxMPh6qrlN+AV
	uVAyr72gFfjrLi0xgarSQoIkagZ1DqM=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/2] ARM64: Fixes for FEAT_E2H0 handling
Date: Mon, 12 Feb 2024 18:05:42 +0000
Message-ID: <170776111436.2280274.3289030811512349732.b4-ty@linux.dev>
In-Reply-To: <20240212144736.1933112-1-maz@kernel.org>
References: <20240212144736.1933112-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 12 Feb 2024 14:47:34 +0000, Marc Zyngier wrote:
> As the FEAT_E2H0 handling series has made it to -next, some of its
> shortcomings are becoming apparent:
> 
> - A missing ID register in __read_sysreg_by_encoding() is causing CPU
>   hotplug to explode (reported by Marek)
> 
> - NV1 is getting advertised on HW that doesn't have FEAT_NV, which is
>   fairly harmless, but still annoying
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to __read_sysreg_by_encoding()
      https://git.kernel.org/kvmarm/kvmarm/c/87b8cf2387c5
[2/2] arm64: cpufeatures: Only check for NV1 if NV is present
      https://git.kernel.org/kvmarm/kvmarm/c/3673d01a2f55

--
Best,
Oliver

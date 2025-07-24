Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90843F9E8
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339781; cv=none; b=rbYm/56Y69M9mH+TCY8pzJDoTyLc+3IxQ4mQZkGAgJ0C4dbOeyVajM4e230KlL567Msj6+L3nDVZota+Xb5YxNrw5UKzfPKafiOOkX+1eAacVwx4mxmYYQ/7Z/DKdvNzJl7fwWDEAVB2M//TItF8v8bjUwHw7BcEE5RW7BpeJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339781; c=relaxed/simple;
	bh=G2HBA+80Hnp/o/+HnCtdRkgEieqGTr9btT5dvSiyXpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGhN4VjLBo/rg8iq2hJ7g+6IHCdWQUVhiuy+HRG0TNE3zd7ad6q4p0B9Cs/fxwsrbRYW9F+6SMb8Nm5ObmOPYLpuBf/c6yjTwPEBOs/TktpDcu+8MlCErcpHcXImTA/VSN5jZnp8Sl4Vmus0cw8dYMWTZizMiq2f2mUljK1IKUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k+dhxNAE; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k+dhxNAE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dyj/98p9fYiVWaxEDQPt8Sx++yKMmL/QgLw0vGI7G8w=;
	b=k+dhxNAEWiTMmnW7EcBUOsWxM+2mAc2kLTCsFYhuHEcnzTT5BF/2mfbNiKcdJod/cXhjrT
	OL4vEMVl3fIoocK/QAuvX8i7yzHQENI2TU0I+O01jz3oHlO3yDl28jHcRc7BlYaJhoCpMk
	Vn/y5JmND26j2HiaQR4ul55CNHq59ow=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes and clarifications for FEAT_S1POE
Date: Wed, 23 Jul 2025 23:49:16 -0700
Message-Id: <175333974801.2689259.7241226036667570185.b4-ty@linux.dev>
In-Reply-To: <20250701151648.754785-1-maz@kernel.org>
References: <20250701151648.754785-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 01 Jul 2025 16:16:46 +0100, Marc Zyngier wrote:
> I (almost accidentally) spotted a couple of issues with the current NV
> support for S1POE:
> 
> - wi->{e0,}poe and wr->{p,u}ov are used interchangeably, and sometimes
>   in conjunction -- none of that makes much sense
> 
> - The two rules describing WXN are not exactly been applied to the
>   correct state
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Remove the wi->{e0,}poe vs wr->{p,u}ov confusion
      https://git.kernel.org/kvmarm/kvmarm/c/a508d5afb708
[2/2] KVM: arm64: Follow specification when implementing WXN
      https://git.kernel.org/kvmarm/kvmarm/c/5152977340b6

--
Best,
Oliver

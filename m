Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071EC2571A9
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740605262; cv=none; b=Lf6yKl4MNlyeimdaTeecTHctNiFWvPL+2mmuHadMSeTwGP5WA1+Fy83gzak6gS1JZegBLY7CPP2MbM9RP8HtR5bvBliHlZdNvrBo87XFmGYDpsXNuk0lF/0M2ebK8mn+Gvhx1aR8RiaHbA1xkF0419/IktRfQRynqvs4FkltKaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740605262; c=relaxed/simple;
	bh=zG7o87npr70YDPPc621lHMTGJSM3DLc8E6eb0iwDoBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMTxAM3qjIPr7KYDc+SCe2c83prPagQF1y5a1CMKyWukg3gZSELcVTc+diVTHbc01CDWy9uhMZCwASt7BfD35LmuYqhLDx3ypHmrEIIoc+22oTrlHHAnoWGTEwzx2KRx5s67YGm7TNPSDjM4HHQftthkpeouNXs6IKgChh59TiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YdDtKS3A; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YdDtKS3A"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740605258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WQupw5lqPe3UBVt0VJ7EozeP/RmEXFaUJZzA9xr85no=;
	b=YdDtKS3APzBbLGdUXCJnyjBkTSD74uvkbxvIhRShXnNVaC0EJI/4V2pjG8ePcgC9KN2kXf
	xZNuKzwFxrOyj/t3oQ3XSBdzPjd1Tpsl9k9hxuJckm/ash/OMYOnxXjDzTNLWFU9DzrmSL
	VAvjb8QHTwEQ9SR8GuUcAsfesJUfwF4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm64: Fixes/clarification for GICv4 vLPI injection
Date: Wed, 26 Feb 2025 13:27:28 -0800
Message-Id: <174060523514.126155.10581342803638978418.b4-ty@linux.dev>
In-Reply-To: <20250226183124.82094-1-oliver.upton@linux.dev>
References: <20250226183124.82094-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 26 Feb 2025 10:31:20 -0800, Oliver Upton wrote:
> Small batch of fixes for vLPI injection issues that can happen when
> userspace is being mean:
> 
>  - MSI interrupt sources could be mapped to non-MSI GSI routing entries.
>    KVM doesn't account for the routing type and blindly attempts to map
>    a vLPI.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs
      https://git.kernel.org/kvmarm/kvmarm/c/a0d7e2fc61ab
[2/4] KVM: arm64: vgic-v4: Only WARN for HW IRQ mismatch when unmapping vLPI
      https://git.kernel.org/kvmarm/kvmarm/c/d0b79563fd60
[3/4] KVM: arm64: vgic-v4: Fall back to software irqbypass if LPI not found
      https://git.kernel.org/kvmarm/kvmarm/c/5c57533eb8c1
[4/4] KVM: arm64: Document ordering requirements for irqbypass
      https://git.kernel.org/kvmarm/kvmarm/c/d766d87cf4a0

--
Best,
Oliver

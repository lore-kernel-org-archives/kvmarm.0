Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91172222DD
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339780; cv=none; b=Hd/zQeGmRgj47eoRM9bZuaWNgr2uLGyj8SxAt28miux9CRLkwQXtdOLDYmSntl/Ycl5TsKsXohuzncaUBHIsAL8cZyU30Nm1IgSgrfb0x4qVSy/agJVSN9BummsIBGMLAbzNQf4QE66bs/3lKQEMOuqDw980lPsmdHq2Dp8qi2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339780; c=relaxed/simple;
	bh=goOH+iTSffYzDz4wOF5eYf/xPwqsAPUAOGfaT4xQwOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHfWrmanf5/o0v4yIqDI/W+CNHe87AC0LISBdSzG6aH91vAKg1roU1+0t4m7CRBkTX+dMd5TZbypIvlVNB/RY2W1H/G0WQsMz0mjyGJi2JjlBq4ULys1+dk7UaFRcJcSfj14L9TJq9jxaJvOBQuh+knET9KzED8/5CE6WB3LayM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BFwYKgP6; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BFwYKgP6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9fba5bx1Rr99IAgRBh7EOTeNdPdYaOyIv4sbcH95qHg=;
	b=BFwYKgP6btZOTZc1V4H/sD0Of99aayXu7wxw6mgsNirytHgfG7/XOU+tSYf3WnAo0i0sCT
	qCas8wFiGIBltggZo11b9eicJKDtdFr6IfXB6aB3V7x+RL/cyGJPJoK5nO9vuk3GM+5JcP
	JlEztQJTQJvp2N1qSTf1YFJXDHNzdd8=
From: Oliver Upton <oliver.upton@linux.dev>
To: rmk+kernel@armlinux.org.uk,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [resend][PATCH 2/2] arm64: kvm: trace_handle_exit: use string choices helper
Date: Wed, 23 Jul 2025 23:49:15 -0700
Message-Id: <175333974804.2689259.7219492328328147997.b4-ty@linux.dev>
In-Reply-To: <87o6ti5ksx.wl-kuninori.morimoto.gx@renesas.com>
References: <87o6ti5ksx.wl-kuninori.morimoto.gx@renesas.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 18 Jul 2025 01:50:38 +0000, Kuninori Morimoto wrote:
> We can use string choices helper, let's use it.
> 
> 

Applied to next, thanks!

[2/2] arm64: kvm: trace_handle_exit: use string choices helper
      https://git.kernel.org/kvmarm/kvmarm/c/f509de1b0f89

--
Best,
Oliver

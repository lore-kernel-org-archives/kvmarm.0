Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A49273F9
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339777; cv=none; b=loYqqmpMpyUvMtTxrKsYRFUlHWmT0SETlqpDRIvyUfM9qJdORzFBVr6hcENvysSuoocHlvDtP6gONmu20v7Xg68Ox8oGhlF2aAAQE+TCmH5scF6szWC19kHBsDBn1Rv9TI4GYqRoAnHRfzOpD5E/DNEk29uZ6Hq/t/2MfCYplzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339777; c=relaxed/simple;
	bh=AG+zhK/KuBF6ZDDPHE2SNsE2shD5FxQ5OgVRiRnJi74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4hVyegVZaaBPnTT2UL9Yqjl6vZV6Z6Ms9Lqy8Qu/rZWbK+oM37ti8gfbTO/QarLAXjUc/oFVGRfNVJBIFq/kku9PV1bfl7WPoRSoQxO3Mh3OAcTQAYG0frS0mdM39kEgLcjU8ExPIZ7tjNsT43AcI8i2ePI/pd2a7A+vjZs0uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bz90vry+; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bz90vry+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LeFQS5hveKm4hU0ToXW/iCGDnVMDNWtKTvmZJLGW35s=;
	b=bz90vry+UZ7I7N7iDhq/F2EgBvJoxdq7WqdyYpQhRpfxU9F+rIGQ5lDFuCIaZ44BHsymq7
	h03hw6qGswvz3oEK25H4yPQ5Unno5bQHPU9JEOBrpyP0QPn3WSqoBZsUkq1qNRR1XvmpFL
	uZvRt1zhvjYkAc4uIAQ5Gv0cKe3cwOU=
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
Subject: Re: [resend][PATCH 1/2] arm64: kvm: sys_regs: use string choices helper
Date: Wed, 23 Jul 2025 23:49:14 -0700
Message-Id: <175333974804.2689259.25654822874492399.b4-ty@linux.dev>
In-Reply-To: <87pldy5ktb.wl-kuninori.morimoto.gx@renesas.com>
References: <87pldy5ktb.wl-kuninori.morimoto.gx@renesas.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 18 Jul 2025 01:50:24 +0000, Kuninori Morimoto wrote:
> We can use string choices helper, let's use it.
> 
> 

Applied to next, thanks!

[1/2] arm64: kvm: sys_regs: use string choices helper
      https://git.kernel.org/kvmarm/kvmarm/c/30a597e19f24

--
Best,
Oliver

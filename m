Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C4B25B1DC
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 22:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752013494; cv=none; b=SpuzBaK5iEmrr4S4hlayZCWAr8dCY+b0R1AB+6JG1rSW+0KZS8VSm5t7Qexfx0seRQ/IOSQtxQYLz3hD76QwVU2DnKgcgCvxSFgSPgxVN+fS46R/6AtXfBUz6CP1nwAW7pd29DR7QKusj/fVHWReROJhilrXHU7felG7Xblhnk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752013494; c=relaxed/simple;
	bh=l6krfXpeh11Ta0y6LX9X7L4QIzGIeN9upT1tk3QaitQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DulFVeewOp2SKarSN+E/BmvwDydKCoCL8MwVQDlKcyhpUqT2dQ0+gIhoAhtrz6V8C0679GKntmEfrv9tdbZnZOoS5GF5l3VmiQ9TbkHnCT2iCppJO8qFyRCP4bSJ/X7V/C27IqKQM/upaR4lf5CDfj3KepEfC1062PfJdJ3qQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ObErs2xw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ObErs2xw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752013489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0gHIIODrhhdGVls2rVmx9Uyz58la+lWfKW4V8WRh8gI=;
	b=ObErs2xwKsqnb0SvubU2oaDqfFoLy9/r7regRmN+aeuOP0dEicWqzO8kBD+NoJw/5Pax+t
	GSuifAGT1pEeHmnDpPUnYR76R8ZHopXgM/d2EST9N+JVHjP91gAXpLer/RgeRV+HVO7K5P
	UMP10J9uQjXq/GbJH3MUl2Ewn4DUrvc=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	nd <nd@arm.com>,
	maz@kernel.org,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	will@kernel.org,
	tglx@linutronix.de,
	lpieralisi@kernel.org,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 0/5] KVM: arm64: Enable GICv3 guests on GICv5 hosts using FEAT_GCIE_LEGACY
Date: Tue,  8 Jul 2025 15:24:38 -0700
Message-Id: <175201339872.1946470.9170349330766710670.b4-ty@linux.dev>
In-Reply-To: <20250627100847.1022515-1-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 27 Jun 2025 10:09:01 +0000, Sascha Bischoff wrote:
> This series introduces support for running GICv3 guests on GICv5 hosts
> by leveraging the GICv5 legacy compatibility feature
> (FEAT_GCIE_LEGACY). The main motivation is to enable existing GICv3
> VMs on GICv5 system without VM or VMM modifications - things should
> work out of the box.
> 
> The changes are focused on two main areas:
> 
> [...]

I've picked this up now that the GICv5 driver is baking in -next. No
promises that these patches actually land in 6.17 (if the host side
doesn't land) but I'm quite happy with the KVM bits.

Applied to next, thanks!

[1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI interrupts
      https://git.kernel.org/kvmarm/kvmarm/c/244e9a89ca76
[2/5] irqchip/gic-v5: Populate struct gic_kvm_info
      https://git.kernel.org/kvmarm/kvmarm/c/1ec38ce3d024
[3/5] arm64/sysreg: Add ICH_VCTLR_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/b62f4b5dec91
[4/5] KVM: arm64: gic-v5: Support GICv3 compat
      https://git.kernel.org/kvmarm/kvmarm/c/c017e49ed138
[5/5] KVM: arm64: gic-v5: Probe for GICv5
      https://git.kernel.org/kvmarm/kvmarm/c/ff2aa6495d4b

--
Best,
Oliver

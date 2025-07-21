Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B824623F403
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753136702; cv=none; b=f9LuQ1hShMcx4htM+L4muVc9T+alWXc44Ri2/ToiEwIHWVYo3uGBCShKyBAYBNjJYkqGMdUQf9zZ5T90YBZivApvPo53KXS1IUv8HxX+7/fnzbcAsBVWpJGf46A0m1J3V5/FOhNwZchs2nmIy61gbGBOeeXUYD5x3ZateRcQ70E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753136702; c=relaxed/simple;
	bh=F+ws2eLWfD2NkWojYPpMSKKKu95g8Nt03OBK7Uspbo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h69T9M3JfqbcbqUQCn0kLUKVMfHrLkvMSlVN9N3uRM7BQZ4pspv9ANPvXdJodw+57HxpHjxfOouNPRnNiyjjLgyC5WPbdm+skqcKdoTBpEfOHBItPkT0d1Krl2tbnz/SPlKYDU5trqd8Qur1xhSZWkaJLxYCbqscCwWM2o+lsX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HZptrzZr; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HZptrzZr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753136698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0Swdc+rgZd6RYXOhWJTdQCOj/YJAeib/YMEr/j+xKM=;
	b=HZptrzZrIHb7zDppmEpiXbGBgqebupTQ8pylKpzfG1WZ/EjdDd5SeiMXYBLDklKXGyITLi
	8X+IcIKCMWgDj89IagWjCFxQnHacJ7CT8bZBk2TkoyPreH7B9QssECZFafwEcr3k17Kf+d
	b0IyMm2aybdhaf6d8GJ8DTu8aeKfnxQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
Date: Mon, 21 Jul 2025 15:24:45 -0700
Message-Id: <175313657127.2592298.3949452294355380877.b4-ty@linux.dev>
In-Reply-To: <20250720102229.179114-1-maz@kernel.org>
References: <20250720102229.179114-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 20 Jul 2025 11:22:29 +0100, Marc Zyngier wrote:
> Mark Brown reports that since we commit to making exceptions
> visible without the vcpu being loaded, the external abort selftest
> fails.
> 
> Upon investigation, it turns out that the code that makes registers
> affected by an exception visible to the guest is completely broken
> on VHE, as we don't check whether the system registers are loaded
> on the CPU at this point. We managed to get away with this so far,
> but that's obviously as bad as it gets,
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
      https://git.kernel.org/kvmarm/kvmarm/c/c6e35dff58d3

--
Best,
Oliver

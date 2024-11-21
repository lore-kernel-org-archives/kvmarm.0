Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65054502F
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 08:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732177112; cv=none; b=hyruDYfDl66Gmz+i2FTgbaOes4PVL88l/RzoEwsRuq/TZOd4RTHjTi0IQwPa/Yyfjj+hY9GBsevEPzgB1kgwOffFArlyeUfcikWwASYvii8dXFXGff4YxEalyqGyL4oMan6PAgsoz5NWw86VHhI1KKJYpH0c2M8Gw2YdeKE2JsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732177112; c=relaxed/simple;
	bh=o5SoUS1b5HAlGYwDksCkkxEFg7sXS138+INTHAEP500=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BPaxqVhoKj3OjqT/9Mocfr0xEOwFHupb/r59V02Fm+/l4jGdXjr0dzje1W5IvYnMM0BmSxj//t6/tZMokFuDujHODHSL4XXDb6DAM8pBJ16YUJmd33o5SPudk/w506D7dziDRBmDDrTOJ/8J8z7QmxaG8wvT0OVRrQ/ceR0cXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w3pxGZCa; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w3pxGZCa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732177107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLNXyzIboI6pc2qgE87idMdWECU8DxxKZWb8lIJUvoA=;
	b=w3pxGZCaySyzLzo0mJzQMpGuT0OvsiJ0GJpjfIllGxdmhzmf8HUV3P1OTAmq41uNSa0h/h
	UKtyjNG9PK2TDXw+KaFdvMW8MdldEul/cd1t7ea5FN542Cdt1Ip31hcFyKw9+OUEVCGp3X
	KKcx8wnjoNC4aJ4QHpDW4wsIKKGWqlE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: arm64: Mark set_sysreg_masks() as inline to avoid build failure
Date: Thu, 21 Nov 2024 00:18:04 -0800
Message-Id: <173217703276.53090.416338024630902187.b4-ty@linux.dev>
In-Reply-To: <20241120111516.304250-1-maz@kernel.org>
References: <20241120111516.304250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 20 Nov 2024 11:15:16 +0000, Marc Zyngier wrote:
> When compiling with CONFIG_CC_OPTIMIZE_FOR_SIZE=y, set_sysreg_masks()
> fails to compile thanks to:
> 
> 	BUILD_BUG_ON(!__builtin_constant_p(sr));
> 
> as the compiler doesn't identify sr as a constant, despite all the
> callers passing constants.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Mark set_sysreg_masks() as inline to avoid build failure
      https://git.kernel.org/kvmarm/kvmarm/c/0f3a0f23f562

--
Best,
Oliver

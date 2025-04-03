Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92BD24E019
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743695167; cv=none; b=oZOmOaTEx7T1k1afmzwrqNcQJwH0l0jDCiWTzjEM+iUchsTKeseiNJnrzAr+tujEN+A5TNKmjPwUrbVhYaXMNC23zB0MYjtAlgnjbSDg3j01nLWyQpwiMBkPrOMyAo3735UipaIHCcY8qbOsMOMmUmdkF03W23ViMmZMmbXjenA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743695167; c=relaxed/simple;
	bh=WLh4uxmMbJDh11SO0hrgwI4qi+lHxUe3RbJWTMlCZLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shRUgzgktT0udSt6MJNY2AZJPpafrgBVU/KRbX+3SMqybKIyYzDfEzyaEIZw2IcnS5KqDvws5MSLKpOLvZplQuvLiHLYE/Dd65ywABq2n1NK5p192yqUsWMmby1QBQG6yjv1715VYnBwenn6k9GAYlfxx+aDRqcoypI8Udpai8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X+F0bAT8; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X+F0bAT8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743695160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EiU6cYR/bj2/g90dtII0uhxK6wbkCA3FpSRFOm8Bd2w=;
	b=X+F0bAT8DyOsQVx+/xTAoLSPplt6wTqNk6sXXBOWvtNcKxzDBka7UFWIwVOdq1C1LPfNTj
	XcqhPiAOf8/I32X7NHen2GarperFx3U+z/YUdBiwo5VxmQqA7ObWiHLoIzORPg3MPa8AWV
	Et9xYK+QmLnan4TRqGYWswzCsQ0xrL0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fixes for resolving the fault IPA
Date: Thu,  3 Apr 2025 08:45:50 -0700
Message-Id: <174369514508.3034362.13165690020799838042.b4-ty@linux.dev>
In-Reply-To: <20250402201725.2963645-1-oliver.upton@linux.dev>
References: <20250402201725.2963645-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 02 Apr 2025 13:17:22 -0700, Oliver Upton wrote:
> KVM's heuristics for determining the fault IPA are a bit shaky and don't
> necessarily align with the letter of the architecture. On top of that,
> HPFAR_EL2 is UNKNOWN if an SEA occurred during a table walk. Re-walking
> the page tables will replay the SEA at EL2, becoming a panic in the hyp.
> 
> v1: https://lore.kernel.org/kvmarm/20250401224234.2906739-1-oliver.upton@linux.dev/
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
      https://git.kernel.org/kvmarm/kvmarm/c/fb8a3eba9c81
[2/3] arm64: Convert HPFAR_EL2 to sysreg table
      https://git.kernel.org/kvmarm/kvmarm/c/1cf3e126f152
[3/3] KVM: arm64: Don't translate FAR if invalid/unsafe
      https://git.kernel.org/kvmarm/kvmarm/c/26fbdf369227

--
Best,
Oliver

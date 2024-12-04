Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1F1372
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 00:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272756; cv=none; b=U38+zJG5sycgmV7VTEYhszLwOAmqBQX9NeUIhXVF9GGmr5G1XcFgMvqWjMZEWWE/kXAeqYfg98mAEmjvWWDnUMXwnzH8mK7DCAHRGzTp2H4T73KbrUm6sYVqxrN2MdrXaWgN2QwnuXhMiA3GRH/RA9bbZXaHvGeGQtTibfC1E5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272756; c=relaxed/simple;
	bh=odxI3owKIjmJytS8iq98DHJyPbubrAxeu5B75aU4mcg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKX7XTPLHcmht0fcT1bKTOa2sq4U1G3obVawgzcKTS2CslxLi9c81+L5tnsSF+cn9vvenpNhKYUyYMoIJ+8tJXKHiLSkUkhT0ZOfZXtRKry4fhgQLoxeCVblhoY/ORvNSgeDIo0drg2tJRUp3ztJBZ6yw1NST6DeWSEnSQHNasE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GF99kdzH; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GF99kdzH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733272752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BuKyh758gXL4H4w1qOWYdSoyL7IX7eUQIvDf/JiLSic=;
	b=GF99kdzHwPOPu8J2EKxn4AZYU4VtBVBTgBSgGQpLRe4dqm0Usij0/YgeP/TwfIEWMzsIdJ
	okjsGMZ6swvZymbOrNECi2alxbeBxt5roZGJetiMWmQQaCbPKbqMq59LkttJDiMm7DyKXg
	Xrn0znXvUv8G7xPO+7hnusDvfmje/Uk=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	stable@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
Date: Tue,  3 Dec 2024 16:38:55 -0800
Message-Id: <173327270646.1289915.18344519507054696527.b4-ty@linux.dev>
In-Reply-To: <20241203190236.505759-1-maz@kernel.org>
References: <20241203190236.505759-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 03 Dec 2024 19:02:36 +0000, Marc Zyngier wrote:
> Catalin reports that a hypervisor lying to a guest about the size
> of the ASID field may result in unexpected issues:
> 
> - if the underlying HW does only supports 8 bit ASIDs, the ASID
>   field in a TLBI VAE1* operation is only 8 bits, and the HW will
>   ignore the other 8 bits
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
      https://git.kernel.org/kvmarm/kvmarm/c/03c7527e97f7

--
Best,
Oliver

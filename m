Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C11898E6
	for <kvmarm@lists.linux.dev>; Fri, 27 Sep 2024 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727434387; cv=none; b=QR3HLFPuLGSs3nlGJtfjhsG/n6UhO2nVmwq5kn0dY+0GFVBen0ydn0qcaQs5zkAyGz8/GfuXjSozteXphBjp8S9LcJXvWGHyKhjgLH7j92KWg10HpESRh3wf/p3rLBOEHd23Yh5YFW3lviy3qo0DK/8AEeLVkeQ+0ugP7x1UJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727434387; c=relaxed/simple;
	bh=Er8qwACTXuX2tV8OfI9W5Z1ty4WEgcUvigooO14rXpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hr7iAgghtaaxB601hGAqDKqHeVFo3V+jtm/cvfHiUEdnGCnGyGuWeQlgnCxoB/MHmboIvgNvaIsUahhInpOwjlBxO/jjhjZErztw5pooMf1h6Jnp1iYfCbk8CuCzSrNMIm+k7zXCQ7bXMfLfTiomsJpMHDmNbf3nQ5v8a3cYu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s6hhI1e8; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s6hhI1e8"
Date: Fri, 27 Sep 2024 12:52:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727434381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3M8hPrTnw1oGXj1wOCJHUDC0lAW7yLN66xJWX7qEj6Q=;
	b=s6hhI1e8d4sL2abj+luZ5PNiL78gUn6onOGYq5zGeEzeYCKgVKEmVpd4TT0JPOUMEeBS8E
	RaWeCf+4Ea+ibv4o50dJfuLoTS5dLSSmP+qj+yGc/HLFtH0XdBzglZHU5rYZSyrrDM4DuC
	SoENffew+wmhgs1tWo7Tm1lovxQNHbA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Another reviewer reshuffle
Message-ID: <ZvaOiuvmZNq__ivV@linux.dev>
References: <20240927104956.1223658-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927104956.1223658-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 27, 2024 at 11:49:56AM +0100, Marc Zyngier wrote:
> It has been a while since James had any significant bandwidth to
> review KVM/arm64 patches. But in the meantime, Joey has stepped up
> and did a really good job reviewing some terrifying patch series.
> 
> Having talked with the interested parties, it appears that James
> is unlikely to have time for KVM in the near future, and that Joey
> is willing to take more responsibilities.
> 
> So let's appoint Joey as an official reviewer, and give James some
> breathing space, as well as my personal thanks. I'm sure he will
> be back one way or another!

Yes, thank you James for everything, I'm sure we'll still be seeing you
around ;-)

> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Welcome to the party, Joey!

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

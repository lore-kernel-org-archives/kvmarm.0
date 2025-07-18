Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615E821D3D9
	for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874024; cv=none; b=kPSHzcuQXUsHgIVsA5aoobIAx5bxlxM6DTYrUPC2bqT5PdzNnkwAwWTpoUiBm5dZSTgn7O1pmaEBOZqBZl21weM/e2pTbmpjOurGz2xzGhjD0LlmY/8bC3LV4fcfxOCnyckMk2hTLFUy46itBDiDBAnt3qx5pAwNllvJsmpEbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874024; c=relaxed/simple;
	bh=2CM4PM4YcNwNTDoDpIwtc5IwfgnCElSJzdiwNdBTOB0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=caIL8l7mwOsOKHOexXUJHo37B6LN2F1lkkDx67M6J2WkPQvQzsUV/kMfjqxk+bmRP29UEK0jBnL6NnZeBYj+p1dcLz9aaY7p21iwa4GEs5fN9BDqP95uK0FhUSz4aSiSlR71YYJ3G9C7WZHjLBcnzTGNiPxZrcaZTZv3DR6L8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1k3SEokf; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XTTfwGcf; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1k3SEokf";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XTTfwGcf"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1752874020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HNzdv87a/rWq9tLSyEQPN0gDEde6E0UtRnippuxMHZM=;
	b=1k3SEokf2DBVJWgiF+T/xnJOe2eEqWGJLJ00C8SsTwH8x1nM5SZiBDmLZUebOhfii+iVuG
	s4+tESctQnG48CFtQHqPgJwTltmpCoGIi2OyV/1oz6yHpnLeulrQnGooaWGSkHpY97elqF
	InEmN3BmvnWJfTfz45eaVaHk6La2pBV3EkfKx5fZcSwca6eNLFm62SJJiOaBxlZcpCzbYg
	F14bdVOShusu5A7bNHEUESC4troKiGYNlYfZHIlCSEsEvyHEM94Q3CRWKsE7NscCOwM2bo
	4maJC7nsozVTPffITe3MFsv8Phg/ZQJ/8iR76dyJuWP6JP39vHxYHCpfCb0ZpA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1752874020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HNzdv87a/rWq9tLSyEQPN0gDEde6E0UtRnippuxMHZM=;
	b=XTTfwGcffydfGuv9QlkDzZ39VMlTjrkghsf4EOfBdgI7BhVW6CZYXQHAY0fGzaXv/laho9
	ZnSs1FsFSv4KQoDA==
To: Marc Zyngier <maz@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Conor Dooley <conor+dt@kernel.org>, Jonathan
 Cameron <Jonathan.Cameron@huawei.com>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Rob Herring <robh@kernel.org>, Sascha
 Bischoff <sascha.bischoff@arm.com>, Timothy Hayes <timothy.hayes@arm.com>,
 Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Subject: Re: [GIT PULL] irqchip: Add GICv5 support
In-Reply-To: <20250717122306.4043011-1-maz@kernel.org>
References: <20250717122306.4043011-1-maz@kernel.org>
Date: Fri, 18 Jul 2025 23:26:58 +0200
Message-ID: <87y0slur4t.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Marc!

On Thu, Jul 17 2025 at 13:23, Marc Zyngier wrote:

> Thomas,
>
> After some time simmering in -next without much catching fire (only a
> single regression has been reported, which was promptly fixed), here's
> the pull request for the GICv5 core infrastructure.
>
> There are still a couple of patches on the list (mostly addressing
> error paths, and actively being reviewed), but I don't see anything
> that would warrant holding this any longer, and these fixes can be
> added down the line. If anything, this work has allowed us to
> pipe-clean a number of issues in the tree.
>
> Please note that the kvmarm tree also carries this branch, as this is
> a dependency for enabling GICv3 compatibility for guests on a GICv5
> host.

I'm fine with keeping this in the kvmarm tree only if that is intended
to hit the next merge window. There is no point to carry this
redundantly in two trees, unless there is some conflict to resolve in my
tree.

If the kvmarm stuff is not ready yet, then please let me know and I
happily pull in the pile.

Thanks,

        tglx

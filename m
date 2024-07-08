Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE7D14E2C4
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 19:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720468790; cv=none; b=kRDto6UHHLq35R4/x5cxgp5gUQ5zAg3S7+XViWA3VA9sL+VhhHYCroR2dkfKdyvX2SQl2IwNdEgyd4gamnmuMSJLOonc94MSn9dnC+KMLn8bW3YZ3Rh3Iyy/D22Lc5HNbzZ5WzJ5ve5pcW4Uh/pQ9yPig9tM2O/6ah0HbJX8Qdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720468790; c=relaxed/simple;
	bh=wEbCVQrw/izQqhppEtyh9amdh+Ry6r326cBlcIyo7tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brrUy0BlZ0Lt0hCHFH+KZag10kIoi7E6gwkVOrLRaNw1V6/2FhtXJbVRSWB5jNePQEWGLl/z5CD8ucs1z7R4Ye4YXbYY5y1EIZU8fozB3qF8VfaXoXmK7Yowrbj3+5ZwDhHnDWA2pNfvW4EXoP9ilCsG+T1zwZkQVyf89pY7npA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FTRvdSne; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FTRvdSne"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720468785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXdILr+L8L8g/ys+MWSjel1AuIWmtaURSqNPwEGloxc=;
	b=FTRvdSneCDphb74/Z9WKkTZnogAvwr1wle4pqnucWKf1uGcFh8j6zi3vTJ3llRQBxD6r1g
	nRlMG478mY7/cHNPf20du7JWrOGd+VOy3bW2/jEP20Jn+ITtQEN5+AM/RqjuvZODmnVL4U
	K4AG7YiCoiMphco5KdSSl/TXu0LF1+A=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: anshuman.khandual@arm.com
Date: Mon, 8 Jul 2024 19:59:41 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>, James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with
 negative polarity
Message-ID: <ZoxFLSYe5v46Y9OC@linux.dev>
References: <20240614125858.78361-1-maz@kernel.org>
 <171839668434.686757.6430070893119235107.b4-ty@linux.dev>
 <86bk3c3uss.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bk3c3uss.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Fri, Jul 05, 2024 at 01:08:51PM +0100, Marc Zyngier wrote:
> OK, I think I have come to my senses, and came to the conclusion that:
> 
> - I am officially losing the plot (blame the political climate)
> 
> - this "fix" is total b*ll*cks and must be dropped/reverted

Ouch, and I let it sail straight by me.

> Oliver, can you please drop or revert this patch from the kvmarm/next
> branch please?
> 
> Thanks and sorry for the noise.

Done, and sorry I didn't spot this in review.

commit:	cb52b5c8b81bfbc34df13537d82cd1849725d6c7

-- 
Thanks,
Oliver

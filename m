Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21887C6D1
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706809681; cv=none; b=PfP54nZKRkHFXjaCZBwpJlZ2m4iRy6xuIqqYnFxMTX424BXz9EMP5tKpdqPBuqwr3vagDqxtnvShc1W6yGaI25F7rcnQs5QzFNXP4neZECWGoTEy8JzUf0hEruuwWieUlJRv8w4WY+yacPZN0cRTw2DG8pWUz9V8vQ0w8+SeuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706809681; c=relaxed/simple;
	bh=l8fl1mJ4rIJqidIweHxe2hCcldoUktfx0+tpqsFCuRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TUV5jTDnee0dSMge7K7eRTgAh+LG0hvRcVDdshW59OC18DdEG+9MNEcqWPFvkxYO0YYJdQbhJ/aBTCgUu602R3fHMuCjTz8IqqIF0glAqHlxyt/JtiaZMm8cuCloX62v8oxSR0JqANzZmAFYnR78N1Z0lQCTpOXaZgchOlAPZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZPjqULQD; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZPjqULQD"
Date: Thu, 1 Feb 2024 17:47:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706809677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dYnISAFVo07pBLwSWWJ2J88UIhu0KIUulAzJ3pXX760=;
	b=ZPjqULQDLG0e/f2PYFjZAH7MwDvlQUoC2Giq0OJ/jHfSmbOXT86IlGUDYDiS0DPKbeuLKF
	6duUDayMxL6Z2SOlYPhFJI39Ce5TU9+NQrtJLhdc36pjw9YmGPxq6NIIL4hCBE0GCUCdzi
	2UPysrJRGsCauWfySedid+42nQ35/ws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 00/10] KVM: arm64: fix many kernel-doc warnings
Message-ID: <ZbvZSOKoOma0lFy1@linux.dev>
References: <20240117230714.31025-1-rdunlap@infradead.org>
 <618cb278-0b9f-4cc2-bfc6-bfcbefc79b69@infradead.org>
 <86le8470yn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86le8470yn.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 01:45:04PM +0000, Marc Zyngier wrote:
> On Thu, 01 Feb 2024 06:19:14 +0000,
> Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> > Hi,
> >
> > Any comments on this series?
> 
> This is currently earmarked for 6.9.

Yup, I'm going to start applying some stuff soon and I'll grab this.

-- 
Thanks,
Oliver

Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411BE1292F3
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706036431; cv=none; b=YkJpt0aF7RtHty3ePTfcVOU0iiIUvF36iMG0aqjqsYOxVYWE7pK3NQwvn1+yCeoQEk9PqPuzAXA/h7DdcFLkGCSTfSSfCMjYIcLZ02y8cksANktjpy0qP78lWv6drJv3306GS7klasFLFa7NngZIjgSqo1l7S/qZuyWPDRtIXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706036431; c=relaxed/simple;
	bh=mQE00aWkgMtqv7svnhbWuPmspbA1rLHb4HEe2MN8pW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3FLg9f4hHIa8BPaKH2pc6dvw5UPnIZvuPENlkpwwNsHB8bJPXiu8tkV7APlWIpQtFBQjQtLAtJf3yaDO8K2+z5T/cQFPdwA1w2A7QjxW4bHPq0mIbZ7j7kua7w8/F9acW9vUuIIc04KWDB534IiXIQDO2ePzbmox/AM5kT/7uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Slc3bqyG; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Slc3bqyG"
Date: Tue, 23 Jan 2024 19:00:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706036427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eYMck5L6uue4zc3PPO2ctKiLd5MW2oLCukny7sBp2yA=;
	b=Slc3bqyGnQbls7pi/u8B+xOBhLft1gJPx7L42fMBMqeCXrBmNvPKs+KsXRwaH9jUlwA7ry
	DI7wJgeioGokPC+o6du6iGrX71qjPvczafhmDNdTEOL8C+fMY9q+unxab9XJS5+2IbC4G+
	QXf3ed9n0ZqSo5P768GQLkR4RIM+jcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Morse <james.morse@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
Message-ID: <ZbAMxyGcSZY7Kl7Z@linux.dev>
References: <20231207150804.3425468-1-james.morse@arm.com>
 <ZXoTG1Y4O16Cjq39@linux.dev>
 <f06ed418-922d-54c5-22a0-bde127146b5a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06ed418-922d-54c5-22a0-bde127146b5a@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 19, 2024 at 05:15:59PM +0000, James Morse wrote:

[...]

> > We've already done something similar to hide our mistakes with IMP DEF
> > PMU versions in commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU
> > version as NI"), and I think MPAM may be a good candidate for something
> > similar.
> 
> As there is precedent, I feel less dirty doing that!
> 
> This also solves the problem of the VMM re-writing the broken value after the vCPU has
> started running, and getting a surprise error. A weird side effect of doing this would be
> you can write MPAM=1 on A53 and KVM will ignore it, I don't want user-space to start
> relying on that! I'll add a final-cap check so this can only be ignored on hardware that
> actually has MPAM, and could have been exposed to the bug.

Ah, good idea. I probably should've done something similar in the PMU
case.

-- 
Thanks,
Oliver

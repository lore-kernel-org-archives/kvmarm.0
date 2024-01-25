Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EAB73175
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706197681; cv=none; b=aEcTohlcKvOFAdWVXDKMK8fLnRkyQ5gCle9tSonNjpZYGYubGyi65g8uoVnq5XGckPRiNmaSuGMFUrhvrEovcmAgTQ8tZrF5Axf6geO8MY62Uo8eKHlmufSLuO40zV2yP8ixsMUuTE5w5iPebDRkXzLcRzshJTCBtdUUT+aLdhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706197681; c=relaxed/simple;
	bh=ruJNbJM+lXjN8eOkbsRsO/qJuuO+lype21X8FfBbk6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XkSJTwtdLebVQ3QQBHx2q6B250m1AYufowBdO1/K2hCf8wbKw5ALDRkE8XNki/lQr6SE9wHQ6EVhKWb9dzCsxWDGtVI7BPrr1Mn7cMi0FhxkS4XOfIscBH/YYx7zAPUryauXHHjzdgD0Eb0Q2jlAmRLCy3ACOR2Obn3utO6gAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sWM9qHwu; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sWM9qHwu"
Date: Thu, 25 Jan 2024 15:47:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706197677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6GdgkPksueJ10d0hvdhbVljnX3UdnJx8Y4TReITfac=;
	b=sWM9qHwufaDBQc46d+LpaH0oczvO+mP+O1m+T6AHsegD7XSO1Kr56yRCd5MklPY9tzh6/V
	NnwZiyqfHAur0gtnmtSMvYkNjcgsryS/LfjWE4FB7oqOGRADDAmuM0WWAMQtNvEfMyAt2Y
	S9TudHsnPFs/UWXMEp/OpMRviQGWEZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 00/15] KVM: arm64: Improvements to GICv3 LPI injection
Message-ID: <ZbKCqGw0GtSEfSPZ@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
 <86zfwt7k2e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfwt7k2e.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 25, 2024 at 11:02:01AM +0000, Marc Zyngier wrote:

[...]

> > I would've liked to have benchmark data showing the improvement on top
> > of upstream with this series, but I'm currently having issues with our
> > internal infrastructure and upstream kernels. However, this series has
> > been found to have a near 2x performance improvement to redis-memtier [*]
> > benchmarks on our kernel tree.
> 
> It'd be really good to have upstream-based numbers, with details of
> the actual setup (device assignment? virtio?) so that we can compare
> things and even track regressions in the future.

Yeah, that sort of thing isn't optional IMO, I just figured that getting
reviews on this would be a bit more productive while I try and recreate
the test correctly on top of upstream.

The test setup I based my "2x" statement on is 4 16 vCPU client VMs
talking to 1 16 vCPU server VM over NIC VFs assigned to the
respective VMs. 16 TX + 16 RX queues for each NIC. As I'm sure you're
aware, I know damn near nothing about the Redis setup itself, and I'll
need to do a bit of work to translate the thing I was using into a
script.

-- 
Thanks,
Oliver

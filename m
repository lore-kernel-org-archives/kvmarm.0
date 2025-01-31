Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705652F56
	for <kvmarm@lists.linux.dev>; Fri, 31 Jan 2025 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738362747; cv=none; b=Ij8Yu8uF9kqVJyiI8pNfPta8sMzQcBKbrztdu9S9nuyzJDfIZivXvM7/beVEJRl6aFeiOa5Ynp6eH7dOzwJo4uAO8vC1jhinD/4TpXQMmHyQClIQallbw4pdg+XMTOl01lLH5V4tGIBspbsv4xRgxFfc7TgJEVCQ5vM7imWELU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738362747; c=relaxed/simple;
	bh=filg/AMn2V5XxLVhFgMOngZitf2cIiSdIG1OP7o9tbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owx2zdP2VEOMnFnm2/0l+AZqNnXTJzEtajQZsXZpV2juQB0i/XJVXCIPdtTum3qiWVvm2yVZVlRclplxXE0LayL/XZb37THN5sY/fUgETWA/AlI/dwMbtHbKpFTJ4YtDk1pSfAFQGTdf/OPJJR8bJDO/YPSL2OZyT/XSH9KE2SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ehuwshZn; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ehuwshZn"
Date: Fri, 31 Jan 2025 22:32:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738362738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A3Bqe62g7W7r2RL3thtf4WjsyKswqUZfibH5kjKyu4s=;
	b=ehuwshZn70k7Vw406pKb+AHlH7rhG4mkvjCQs/olkmnbepFYpMLM20GPwoUWF3K8KCejgw
	hj5Z9upDwpgbHoFnJZBKefpJl9LlwhEVEzW8kg1bBzkve15Zuc1XvwbrPvGBXJC6ja0wzL
	CBtIemVrDWnJXl1pnHVTAiwOp6bH1VA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v4 11/19] KVM: arm64: Use debug_owner to track if debug
 regs need save/restore
Message-ID: <Z51PbTtzKh66dqco@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
 <20241219224116.3941496-12-oliver.upton@linux.dev>
 <5f62740f-a065-42d9-9f56-8fb648b9c63f@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f62740f-a065-42d9-9f56-8fb648b9c63f@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 31, 2025 at 12:22:22AM +0000, Mark Brown wrote:
> On Thu, Dec 19, 2024 at 02:41:08PM -0800, Oliver Upton wrote:
> 
> > Use the debug owner to determine if the debug regs are in use instead of
> > keeping around the DEBUG_DIRTY flag. Debug registers are now
> > saved/restored after the first trap, regardless of whether it was a read
> > or a write. This also shifts the point at which KVM becomes lazy to
> > vcpu_put() rather than the next exception taken from the guest.
> > 
> > Tested-by: James Clark <james.clark@linaro.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> We've started seeing issues on TX2 with the KVM debug-exceptions
> kselftest in pKVM boots:

Thanks for catching this. Just put a fix on the list [*], hopefully Marc
can pick it up sometime soon.

[*]: https://lore.kernel.org/kvmarm/20250131222922.1548780-3-oliver.upton@linux.dev/

-- 
Thanks,
Oliver

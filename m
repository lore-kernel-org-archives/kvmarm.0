Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299CB4502F
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 08:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732177122; cv=none; b=Pr4HjyZXf7D3ecwMxSoWCuf/Om51X6Fs2w5opvKAB9NwiQ2kPlvS3lyzQIaAsCSYeEzB64SIRJTs4oFRJ8XSPry8upjKmlfnMaNsgVni2j2gVA5athadt++HXibkTSyF+mKdzxgzGGfV5APVk4l6KXb9nki5LKTdOnAs07J6jrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732177122; c=relaxed/simple;
	bh=QRPnrxWyqZAgCNhbj+GgPt5QJ6vNuGbxwIN9RpwxTuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zg3fARoXnhO20mM53TuA7bMdAwoHRtMOv4eLcJDrO2Vq2y101Inpti+GHOQikfHESGaWhR40wh9D0hrVchFhshLtm5w9VOh3GuH1ThsfJKq97gQ/RwCcVcUj6IL5lUn6RwuXbau7eTB0n17gnHOxIX1dzjvwcngyzNSuE7yJD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cx/C75QH; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cx/C75QH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732177118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lKSMoRP6OgRIQWHm6aM+cKTCHNv0nZh6YYvIeuYXv3Q=;
	b=cx/C75QH5MKr9sbAUGtUBMs1ZPIFkXfzF3ned/VLEdZLwebE9u5CUguzgmJV5U/TvjIPG3
	IJZ4U6o4SNms/J8oOUAx/C9W0U5+uHFJQGQWugWcO86bqf3OnTJkb1yHxrPuoM/A5DSHT5
	Ky3frJb20Avxq2t+mjsJC3RNwneJynM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Fixes for PMU overflow state
Date: Thu, 21 Nov 2024 00:18:05 -0800
Message-Id: <173217703279.53090.16467187174223078171.b4-ty@linux.dev>
In-Reply-To: <20241120005230.2335682-1-oliver.upton@linux.dev>
References: <20241120005230.2335682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 19 Nov 2024 16:52:28 -0800, Oliver Upton wrote:
> Respin of Raghavendra's fix for evaluating PMU overflow [*], with
> another patch stuck on top for my own blatant disregard of the
> architecture in the vEL2 bits.
> 
> Since I fiddled with this on the M2 these patches are obviously untested
> due to the lack of PMUv3. I'll give it a spin on supporting hardware
> before actually applying patches, of course.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
      https://git.kernel.org/kvmarm/kvmarm/c/54bbee190d42
[2/2] KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters
      https://git.kernel.org/kvmarm/kvmarm/c/13905f4547b0

--
Best,
Oliver

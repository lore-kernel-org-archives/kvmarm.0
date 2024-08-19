Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13EF176233
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088362; cv=none; b=E6xEIpQHb+TtgP8FincyA/1mGcQS8YaE2jPwm1O5796U86gkH2GwNF6Cdseej5Cff1R2NbNcv6pkGIkSTLjDJdKHFYr5SfZ4GO6FkfFHh1Swkm7jOJde3ksqQDL5+vbMCTKSAL8tEXFhSMBhjNzvoEZ0t0Y/l+xk01IBVzP5AT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088362; c=relaxed/simple;
	bh=V8HqJZq8ou5qqu3gnI9Q6yW31ZSw3/U0vK1iIw+2vLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=InyMaenEpQv1X9UZQTiWCcD4G19BlgKE0x0CMa8Yzy6b8Us6+Jxiimc52JluSINwVv1QV4zKrosLCgfUvVj8eeW6i7v8LWbIJvKg6wHKtu+TAvAd8YfvTknXqymPkF3Paksuo2kSfCeBgd6iiinMOjtLKtxga6pZL88UpjXKrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v2sldeMK; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v2sldeMK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724088357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjXIgrQkbNbdREGaeSmiEsu2NJFDyg3k70yEW2RV1tI=;
	b=v2sldeMKhW8eJfG+muN64Qp4PR999jCGAV6mnCRNxSDgC4jjnTj65/nmmgps0FTCDPlVAZ
	PeIAx4O4z7VyjZkiwaHGX1+SDUJPmeGXbfajfOPfqPnZufNNvrEh3CqZepH1pgSn/aIx+I
	cawaL39lc9vEq6DUOW98JmSS3CkLrS8=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com,
	maz@kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-debug: Don't put unmarked LPIs
Date: Mon, 19 Aug 2024 17:25:47 +0000
Message-ID: <172408829923.848017.11368160825024844050.b4-ty@linux.dev>
In-Reply-To: <20240817101541.1664-1-yuzenghui@huawei.com>
References: <20240817101541.1664-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 17 Aug 2024 18:15:41 +0800, Zenghui Yu wrote:
> If there were LPIs being mapped behind our back (i.e., between .start() and
> .stop()), we would put them at iter_unmark_lpis() without checking if they
> were actually *marked*, which is obviously not good.
> 
> Switch to use the xa_for_each_marked() iterator to fix it.
> 
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic-debug: Don't put unmarked LPIs
      https://git.kernel.org/kvmarm/kvmarm/c/2240a50e6294

--
Best,
Oliver

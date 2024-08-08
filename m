Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFC5190067
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136873; cv=none; b=A58ZIFN5udrzJBJ4ZrXciMFx46pLCH1gvvpWg/fEp2t6pc3jjdfX7LQkkmH9zZkBAmRwiAizob+zOSS3gmkb9osJ2KzcGPoVdr6AjkEDf5XHUjudvSsx1CMJ6D0+G9LSI2LKLli1visL+HyTSfmcQqPji+efqnp82XekvWAakIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136873; c=relaxed/simple;
	bh=n1CckrRpxHusTNjhXFfmCWXWaNGy0qsTYBqlNkvgqk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/mhoTTLc0YOXqWz8njJl1Wnuzz3Ukk/V3mgetQQZBURkiVyJuYnASTL8S7WYxr4/apx0JnNsXTwlI81XYGVnKw6eZRuUWVfkB8TGAgScGw+wTMKxYQ8r1Zw9pXWoe6XaLxUcUBS0iPCfow32CxCqNrbM7DkNg9PTfpTnktWGEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FrY8Ujw6; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FrY8Ujw6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTGYHwhlXrNgcnqJdaAC4NJzJ7epnTy+OOYuWbGCTs8=;
	b=FrY8Ujw61+pqGjGoDbK093NopnMYwfH05klZqL+VL4ZZe1sNwmKdDAQAdjHH8xGO+QWWqn
	D89XBukPOnCfWfDPV81XZOPQ8u3nbvbfh7NdyTpEdrcdEIYVLiqfoNwRCycCgzUA5KLaUL
	SHmKzkclZv1xQpBNYzl5bDHjEhNrzeM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	wanghaibin.wang@huawei.com,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI
Date: Thu,  8 Aug 2024 17:07:39 +0000
Message-ID: <172313677516.561165.2999728205776923887.b4-ty@linux.dev>
In-Reply-To: <20240807052024.2084-1-yuzenghui@huawei.com>
References: <20240807052024.2084-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 7 Aug 2024 13:20:24 +0800, Zenghui Yu wrote:
> In case the guest doesn't have any LPI, we previously relied on the
> iterator setting
> 
> 	'intid = nr_spis + VGIC_NR_PRIVATE_IRQS' && 'lpi_idx = 1'
> 
> to exit the iterator. But it was broken with commit 85d3ccc8b75b ("KVM:
> arm64: vgic-debug: Use an xarray mark for debug iterator") -- the intid
> remains at 'nr_spis + VGIC_NR_PRIVATE_IRQS - 1', and we end up endlessly
> printing the last SPI's state.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI
      https://git.kernel.org/kvmarm/kvmarm/c/01ab08cafece

--
Best,
Oliver

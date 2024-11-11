Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0668468
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 19:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731354184; cv=none; b=ibNvPlGuZlNg/YIFtUsyYdEOnDYqDXrLvBiNdzU/lnUyNYH96tlz19UjTJGAC4zYGjz5gHnzQROUExwjF/IuPCmIcMcJNiItkJ0tG/xTzLkjBZqH5CTGzVfXZyVnEc4dXdMKKz0wyE0hHlqAjrw/OXvP42giA9/njyL/vzuHI1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731354184; c=relaxed/simple;
	bh=3ybO6wVjsJ/ytXTR0THKmVHsdkJ/Bqbog762X7DdMSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAt9d3OJVOz1Xd/LFpvwT4SpCqS2ehfxITYKEBMx3g8w98veg+xMppV/eh/JJ211l8SHIDAFbjVVpWN0G+Lzja4NGcmzlIFK1PRdnW+f3T51mrFVfhtMrkA/nHSQCxNGQTxhvhkr2zhbnG5TXdYfSnkObSOREyfVOfz/jToVU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mwkyHDJQ; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mwkyHDJQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731354179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQw70jFvuXYdTZwcdyKe95m4F0F8qYfh17sqc59kXHQ=;
	b=mwkyHDJQviuWAcb80iDB3X9aBED1OBejINpKT9VbC03LzYC9O93CXrzIyDsv4a18kw+ZEW
	kbNHQ+LMHAS4uHmqIQcrSI+AQrBIrVArwIVUpU35VvqfrqDBfA9LokFqNAIPfAYS7K2nqB
	9aXqo/LRL85pqyrVUGv6E/psTucrhbg=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	wangzhou1@hisilicon.com,
	joey.gouly@arm.com,
	james.morse@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	sebott@redhat.com
Subject: Re: [PATCH v2] KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace
Date: Mon, 11 Nov 2024 19:41:56 +0000
Message-ID: <173135408547.2760967.16338422848283490083.b4-ty@linux.dev>
In-Reply-To: <20241022073943.35764-1-shameerali.kolothum.thodi@huawei.com>
References: <20241022073943.35764-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 22 Oct 2024 08:39:43 +0100, Shameer Kolothum wrote:
> Only allow userspace to set VIPT(0b10) or PIPT(0b11) for L1Ip based on
> what hardware reports as both AIVIVT (0b01) and VPIPT (0b00) are
> documented as reserved.
> 
> Using a VIPT for Guest where hardware reports PIPT may lead to over
> invalidation, but is still correct. Hence, we can allow downgrading
> PIPT to VIPT, but not the other way around.
> 
> [...]

Sorry I didn't grab this earlier, for some reason I'm not getting your mail
at my linux.dev address.

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace
      https://git.kernel.org/kvmarm/kvmarm/c/e9b57d7f9740

--
Best,
Oliver

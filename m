Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501E1482EB
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771206; cv=none; b=kaBeiEQpoyC96482DlJLoAOcX4vnKpqwpA4YH8/lwslZy9nI6r6/xB7WzYpp4iagKhkfT30qZ5XL+8w8WK8AR/5+0VQf0TNeExBqdgkjVjMs0YAnZf0hl21nATHopTTiiZuWTgIcWCZkvbeb1zMBaxU7pna/X4Qw/qslnfwsLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771206; c=relaxed/simple;
	bh=9mHo3HwmaPJ0EdxIcuiLFd2TFEsc2iER8t6AM8kcW8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSm8QFijogXQ4lkVPvI7CgBL+9/68WiK0u1dCkh0PZWaiW7umoy5/oEQXSb2L68k5/yrr7uBt38JQtqiQUIectcwDmCLnus89BQHuqCAxaRZ+joZbqrbIhdhR0oZAeJ5BRDWGipjgZmqPUclYyeKChnHR7jSKKrQWN67dngr01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qEG6NPiv; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qEG6NPiv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707771203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CPFZQlkCiHweHHNFw7H0t7q9lq/OY1i7BruROgQTdYQ=;
	b=qEG6NPiv30fKr3u4j8rq85+ngEDKsFmQOg1Xpj87QlpxHk/ERxl9+AAxCTN11iXMp4Y3OD
	hvxvooEDnIVh7dCCAFPDwC/pDULgCS3JB4JrhFhCcq/PsoDTwHnEQ7Jf0B4o6BRjh1Fcm2
	ZtXVLYMh2BzFzcAcNysowthHve5wgyE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	maz@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	broonie@kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH v1] KVM: arm64: print Hyp mode
Date: Mon, 12 Feb 2024 20:52:54 +0000
Message-ID: <170777114722.3090079.7229054370901472042.b4-ty@linux.dev>
In-Reply-To: <20240209103719.3813599-1-joey.gouly@arm.com>
References: <20240209103719.3813599-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 9 Feb 2024 10:37:19 +0000, Joey Gouly wrote:
> Print which of the hyp modes is being used (hVHE, nVHE).
> 
> 

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: print Hyp mode
      https://git.kernel.org/kvmarm/kvmarm/c/1f3ca7023fe6

--
Best,
Oliver

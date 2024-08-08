Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDED1F19A
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136856; cv=none; b=jB7NiFs7hepxD/t6CMdB05ycsgsQAk6VHIGl3eIKAo3TlE49s8s97RRPtADUqfDY6kbVHBp9h5P2VAQH0puogiSTTERU6xeywE6H7GV5IxbUV9jqUeQtIY3nOPuR0+jLUcaQ9Dac063SCUMTF3OblPK0pI5PvN7LmN4YPEZWn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136856; c=relaxed/simple;
	bh=6eiUd63cMc6JYhGNU2uTDl0rOESo+KZYUbz/uB9vAF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCMjQmR8KHXkMqNfIomAs4Adc1ffK6A1sf9Xxp7bTTLeH0n0UjFzrOUZzz5WvgJCOfnSUqoc8pusS31+7q1ALyZlKn95jmYjQn+Vz3rFzr7nGNN5o9o+gSIl7MB1lK1ycOQgU9BDEPzFzvmrEvDV5vV0sa6KZ+mwWQxdo4t2fu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r7dn058l; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r7dn058l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TjISDC98VtmVoPYSRundSAb2umEeCk6YHvwLLUsCbvQ=;
	b=r7dn058l3tvjeSKxVpxoRJAgOkClOCQdCIpw4UNpJ4QC9hIeAucgP6UzwoJrqlKXxfiBYi
	TAzMFPn7WBTyopDBMy7ioz+0FSKQHMWsz+0e0m4mEwYEKtgonyYtgW+78M6UoPjkeE47PT
	w4htQuNDIvzd00nRPymaxW0IoYoxKVk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface
Date: Thu,  8 Aug 2024 17:07:19 +0000
Message-ID: <172313677523.561165.13999775650521712100.b4-ty@linux.dev>
In-Reply-To: <20240808091546.3262111-1-maz@kernel.org>
References: <20240808091546.3262111-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 8 Aug 2024 10:15:46 +0100, Marc Zyngier wrote:
> Tearing down a vcpu CPU interface involves freeing the private interrupt
> array. If we don't hold the lock, we may race against another thread
> trying to configure it. Yeah, fuzzers do wonderful things...
> 
> Taking the lock early solves this particular problem.
> 
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface
      https://git.kernel.org/kvmarm/kvmarm/c/9eb18136af9f

--
Best,
Oliver

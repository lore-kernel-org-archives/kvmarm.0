Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2AB60DFA
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 20:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396703; cv=none; b=rP/O9F/ddg2gF4z1lIDWCIU1EZL/TZvbf83fVG1CudfoR+Vh1/twi7lIzNONNV23ARdDJmuz5BAKROIB2S8mzUCEA2FcPPOLFt4ZSOVbhNY/2PB4aSmW+Tw6FQz7jxB/YsKI+2SNkH9ouDNBMZUjP4JqZB7Ia/z9dvE1wiGwBzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396703; c=relaxed/simple;
	bh=+W7DNZxtNtV9TFEpWMBwpTUHED4CAvoXFwVwGTFTzNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqxGnLhuV0bpVLz2QUWM4WVNIIf89pSL0kxJLe9Iovcfm+k585hCrWjq6d6iWHlatpmhHglMpOljRZwzqwefskwcbeNhHPWiLKdGpBhJoxz78KqD3NJqZ/qU3o0NMavu4O7tON49S7BnqgTBUlqQ7ffFTChetmMD8ZcENE29rK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P+lGmbBy; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P+lGmbBy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718396700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ssohT6bZ/mBcmwohvifeTFOklgZl6f4obf7UdfeZGKA=;
	b=P+lGmbByaBjhL7ZNgWqZqphBz02PqpguBgO54yZCg2CVAJtzoZ5nwr08aXKAx5BNRwcLAq
	ZfOxRNUp/kQLY33cx/ZE0DrvwGgUvVkWlPYkKePV/Xsn7CQUB9iHqNUTfCO3QC8R1hEZuf
	YN1WWfZJNZCZXqiCtKKfrX3XfuAvc3A=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: suzuki.poulose@arm.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity
Date: Fri, 14 Jun 2024 20:24:51 +0000
Message-ID: <171839668434.686757.6430070893119235107.b4-ty@linux.dev>
In-Reply-To: <20240614125858.78361-1-maz@kernel.org>
References: <20240614125858.78361-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 14 Jun 2024 13:58:58 +0100, Marc Zyngier wrote:
> The Fine Grained Trap extension is pretty messy as it doesn't
> consistently use the same polarity for all trap bits. A bunch
> of them, added later in the life of the architecture, have a
> *negative* priority.
> 
> So if these bits are disabled, they must be RES1 and not RES0.
> But that's not what the code implements, making the traps for
> these negative trap bits being always on instead of disabled.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity
      https://git.kernel.org/kvmarm/kvmarm/c/eb9d53d4a949

--
Best,
Oliver

Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E581D6B0
	for <kvmarm@lists.linux.dev>; Wed,  4 Oct 2023 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d/48tgus"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696444039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RHGl6xWhs0tENVvXmfAIBiogdIWWHOiNDVc38UfDAxo=;
	b=d/48tgusZMqvpxXO2+csYfQZASRRCWl2sC/kk8XdoDSZ1XJLUjAcWp0E7wvI8paY3kYw3M
	K6URqRJf/G8WbLueAbRv3UOYfq5zTE3l1FkCmKdnAqpPi4//e8PL3/YmmW85yIy0yFuEPE
	NHArvvtxg4p6KlL+a/02qAS5FzWotis=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Support for Arm v8.8 memcpy instructions in KVM guests
Date: Wed,  4 Oct 2023 18:27:08 +0000
Message-ID: <169644402344.3996132.10135608827504283886.b4-ty@linux.dev>
In-Reply-To: <20230922112508.1774352-1-kristina.martsenko@arm.com>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 22 Sep 2023 12:25:06 +0100, Kristina Martsenko wrote:
> This is v2 of the series to allow using the new Arm memory copy instructions
> in KVM guests. See v1 for more information [1].
> 
> Changes in v2:
>  - Dropped HCRX_EL2 vcpu field
>  - Rebased onto v6.6-rc2
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Add handler for MOPS exceptions
      https://git.kernel.org/kvmarm/kvmarm/c/17b8ac23488b
[2/2] KVM: arm64: Expose MOPS instructions to guests
      https://git.kernel.org/kvmarm/kvmarm/c/a24015b6cc66

--
Best,
Oliver

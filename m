Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51633A00C;
	Wed, 17 Jun 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781717345; cv=none; b=ixcqHGJZUqise7R4hq8g+YxUc92DPnrLzAG7KqX+sgmlQ0DQUnehDjhnqJssouhhXH9mlPn9OpOObRMjowknuO8EfhOTBgZZzfVI81ciuPxPAgCu/6p+sa6whGt7VvFSROv9n0MK/yKKK98HwCAAMywVTTgT8gof8rXutE+a8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781717345; c=relaxed/simple;
	bh=+rdESTWGPqV+1XxZf8NX/jqcLI76vwc8eMHYsVTW7Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYYoqey5TfGpWIqtDY2Of18saDq7jE88H3+A3pAjc6SuRgwaiCr9P2jsc1HuZh+YwEpEZ53VoIVoNbQjOH6RHledWA2N4hzM3LAHK9XCgg0NOB3D5XJ8Mk2wtQiBMKSRz/9OKYdO/4h1Y3XY6NHr4OodO/wb80+T83BqP5eBxNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaQIJnXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaQIJnXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C681F000E9;
	Wed, 17 Jun 2026 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781717344;
	bh=ORc6DNzCH93lgPn7FNZP6gSaQhoPVf/lEpdRrdeEA1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IaQIJnXWnFEpQ6m9OyPThpigdPTXhQpQ65EacbncSTq46LAkJPwo5oeMrxpSkdDqN
	 DH220wstLSCjndi4ARBTz0mAWtDdUu54w3QA+71xPGS2i6u5bN+YwYlazkk/AYcwGr
	 fidRW1tKkOVWOUAXb9bzKvm3PQ20GnObT8GKT+Rbymogn+9/g2LT0RCR6TsYszOG6J
	 JME6uReUsk0ufmRaINYWFm/2cqFdSbXh0h2ooOBSN1I/PgrYhFL6FsuWzhJ1wswEKR
	 kYdIFKgnlN5GHcBVOTwg+ZAN75F9EglYc5jgtfhMQQvmKmfhv9WXMJzAeJqVb6VCru
	 YW9BqXBS4/h7w==
Date: Wed, 17 Jun 2026 10:29:03 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Add Fuad Tabba as a reviewer
Message-ID: <ajLZXw3m4QGaYeTa@kernel.org>
References: <20260617131237.2842619-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617131237.2842619-1-tabba@google.com>

On Wed, Jun 17, 2026 at 02:12:36PM +0100, Fuad Tabba wrote:
> I have been working on KVM/arm64 for a couple of years, mostly on
> pKVM, and am currently upstreaming protected guest support, with more
> to come later. I already review KVM/arm64 patches more broadly, and
> am happy to continue doing so in an official capacity.
> 
> Add myself to the KVM/arm64 reviewer list.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Welcome to the party! Marc, I'm guessing you'll take this as a fix so
Fuad can suffer through reviews ASAP :)

Acked-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3fe46d7c4bc..61eb5dc2bd03 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13991,6 +13991,7 @@ F:	virt/kvm/*
>  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
>  M:	Marc Zyngier <maz@kernel.org>
>  M:	Oliver Upton <oupton@kernel.org>
> +R:	Fuad Tabba <tabba@google.com>
>  R:	Joey Gouly <joey.gouly@arm.com>
>  R:	Suzuki K Poulose <suzuki.poulose@arm.com>
>  R:	Zenghui Yu <yuzenghui@huawei.com>
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 

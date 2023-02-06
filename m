Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322C7B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:13:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675703489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=armcNc6KFMbkE4Jo9laBBFL+ptwPVauwQbZCWayn/8c=;
	b=NpBlqveckIMXyx3Lwkj+vADx4sDcp+mmPvHru6FEie7iAwHJQjKfikGQbGs5XiHs7bFPLF
	xdL6kfqrRq2a271R+EYuhC/OC4g8hK7KLe9H56yPCt1XC+7FWMUhDo1LS9cwzmTDKQJlbQ
	renU7mDUCgppcrswaH8HTjR1J5EYOdw=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] irqchip/apple-aic: Correctly map the vgic maintenance interrupt
Date: Mon,  6 Feb 2023 17:11:22 +0000
Message-Id: <167570346270.3822233.7990679414480648662.b4-ty@linux.dev>
In-Reply-To: <20230201164056.669509-1-maz@kernel.org>
References: <20230201164056.669509-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 1 Feb 2023 16:40:56 +0000, Marc Zyngier wrote:
> We currently allocate the vgic maintenance interrupt by calling into
> the low-level irqdomain code. Not only this is unnecessary, but this
> is also pretty wrong: we end-up skipping a bunch of irqdesc state
> setup
> 
> A simple "cat /proc/interrupt" shows how wrong we are, as the
> interrupt appears as "Edge" instead of "Level".
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] irqchip/apple-aic: Correctly map the vgic maintenance interrupt
      https://git.kernel.org/kvmarm/kvmarm/c/ad818e6010ef

--
Best,
Oliver

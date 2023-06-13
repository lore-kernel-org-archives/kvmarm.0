Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55F93C25
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 12:16:22 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686658580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSAEPk899fFIeec6HHaSoIZTwAJnWOrWf2em/FZAvE0=;
	b=ClpOLb+zqfw4RK3yxKIxW5y1+8cGDnRq77JdHFXZuP3cMEqwRLlSS+TD55Fnp8uHKO0zkK
	gRfVUhBm3yzUkAuRvhqxS4H8NRfaF0dWXFJXi5vwwvitbTX7xVyxpMAMXZpg2IbXmZvZZI
	xwShBVMuIUYeDtAj2xOcehf123cu2Z8=
From: Oliver Upton <oliver.upton@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kernel-janitors@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: timers: Fix resource leaks in kvm_timer_hyp_init()
Date: Tue, 13 Jun 2023 12:16:01 +0000
Message-ID: <168665854177.2681974.14382421414038699730.b4-ty@linux.dev>
In-Reply-To: <72fffc35-7669-40b1-9d14-113c43269cf3@kili.mountain>
References: <72fffc35-7669-40b1-9d14-113c43269cf3@kili.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 13 Jun 2023 09:43:39 +0300, Dan Carpenter wrote:
> Smatch detected this bug:
>     arch/arm64/kvm/arch_timer.c:1425 kvm_timer_hyp_init()
>     warn: missing unwind goto?
> 
> There are two resources to be freed the vtimer and ptimer.  The
> line that Smatch complains about should free the vtimer first
> before returning and then after that cleanup code should free
> the ptimer.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: timers: Fix resource leaks in kvm_timer_hyp_init()
      https://git.kernel.org/kvmarm/kvmarm/c/21e87daece5a

--
Best,
Oliver

Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C307C
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:28:51 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6Na5HPdYQumueESWAtILS5PbaewkSyT05UaySizfmg=;
	b=SkY8XFxoqZH/i7erZ9tU01KwzOnocihjrjhXnjmrRPtaBOBxPb3Edt2FkenRpBeslRVQ4r
	i+/iZSoeweo0eDyDov0V7pMi1GhAql5QkTAnDMJF4vzpnHAelQmBnHCe0YIbpwSS88gspK
	7jE1XUExFjFjWw2DURgVsyiYn+CXIN4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Kill CPACR_EL1_TTA definition
Date: Mon, 23 Jan 2023 20:28:38 +0000
Message-Id: <167450411333.2570464.16313880797706670802.b4-ty@linux.dev>
In-Reply-To: <20230112154803.1808559-1-maz@kernel.org>
References: <20230112154803.1808559-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Jan 2023 15:48:03 +0000, Marc Zyngier wrote:
> Since the One True Way is to use the new generated definition,
> kill the KVM-specific definition of CPACR_EL1_TTA, and move
> over to CPACR_ELx_TTA, hopefully for the same result.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Kill CPACR_EL1_TTA definition
      https://git.kernel.org/kvmarm/kvmarm/c/7a5e9c8f0b2d

--
Best,
Oliver

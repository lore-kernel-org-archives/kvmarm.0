Received: from out-46.mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3E17FE0
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 20:01:18 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689105676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BW7lu2mzgzGoDumkBjzINg6OFqwOhCaVlVWH0EynxSc=;
	b=lyVgupKC1qIjP3KD7eNvfKsAd1v8v8em8uJUofb+1dh3vYQFcPEvTWdYYG44rmUuKc4Eb1
	AraP3PTFuP5b/Oq+8JOUkFnSgIuVdVugPlvBC2QLTHA17Sqre82Yd8QB8liZjhKSMjHljd
	V4LCRrvNUnqzy3bVFke3mZmZrPGQ9OU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
Date: Tue, 11 Jul 2023 20:00:46 +0000
Message-ID: <168910562677.2605377.4826778238561780912.b4-ty@linux.dev>
In-Reply-To: <20230627140557.544885-1-maz@kernel.org>
References: <20230627140557.544885-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 27 Jun 2023 15:05:57 +0100, Marc Zyngier wrote:
> It recently appeared that, whien running VHE, there is a notable
> difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
> the architecture documents:
> 
> - When accessed from EL2, bits [19:18] and [16:10] same bits have
>   the same assignment as CNTHCTL_EL2
> - When accessed from EL1, bits [19:18] and [16:10] are RES0
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
      https://git.kernel.org/kvmarm/kvmarm/c/fe769e6c1f80

--
Best,
Oliver

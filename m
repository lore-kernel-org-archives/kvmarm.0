Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD518467
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 22:22:10 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675103475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iDcqrs/xuzO6IdPSvSvQfi+l+MKWADi+VSLIybsBcrI=;
	b=rgEVZ9d6cmLtzBlExV/5V3P97cwb7RQ0MSzQtLbjtphHMoRefKa14pn55fimXT7EDHdh7G
	8/Cm+BCu0PjnNTdje5AIPVJmSJ6zEiaVtBfNZOo3+mK/+UtdIiwhRMXoC805NKkYKfhX3Q
	2NlznwTbyi8EsbVLkkns/HbmY7VIvMs=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Drop Columbia-hosted mailing list
Date: Mon, 30 Jan 2023 18:31:08 +0000
Message-Id: <167510336268.1083059.2860531240390777372.b4-ty@linux.dev>
In-Reply-To: <20230113132809.1979119-1-maz@kernel.org>
References: <20230113132809.1979119-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 13 Jan 2023 13:28:09 +0000, Marc Zyngier wrote:
> After many years of awesome service, the kvmarm mailing list hosted by
> Columbia is being decommissioned, and replaced by kvmarm@lists.linux.dev.
> 
> Many thanks to Columbia for having hosted us for so long, and to the
> kernel.org folks for giving us a new home.
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Drop Columbia-hosted mailing list
      https://git.kernel.org/kvmarm/kvmarm/c/960c3028a1d5

--
Best,
Oliver

Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F3544495
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 17:56:54 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695405412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/vIlwev0NInC5X3bGDj9xIaIis5oChB8JH6RisijWU=;
	b=Dd1dWJO/4NuL36W09TKuSLMZSfNiVE4gJ8iFXmU8g6Dzw04WDj+DKCK4RPY0hh0Eem4g+Y
	4e4WPqFr/omIMOB9IOeZgUTjUhuLqXZ+gFgs4lPLdQOgUB5xQZnzC0O3Ztc6rKO5GJEjgj
	YW2yBrczpUEjdPTcwglIQf1Yhfx5UD4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Address soft lockups due to I-cache CMOs
Date: Fri, 22 Sep 2023 17:56:07 +0000
Message-ID: <169540533312.1416870.6209003020435706086.b4-ty@linux.dev>
In-Reply-To: <20230920080133.944717-1-oliver.upton@linux.dev>
References: <20230920080133.944717-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 20 Sep 2023 08:01:31 +0000, Oliver Upton wrote:
> Small series to address the soft lockups that Gavin hits when running
> KVM guests w/ hugepages on an Ampere Altra Max machine. While I
> absolutely loathe "fixing" the issue of slow I-cache CMOs in this way,
> I can't really think of an alternative.
> 
> Oliver Upton (2):
>   arm64: tlbflush: Rename MAX_TLBI_OPS
>   KVM: arm64: Avoid soft lockups due to I-cache maintenance
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] arm64: tlbflush: Rename MAX_TLBI_OPS
      https://git.kernel.org/kvmarm/kvmarm/c/ec1c3b9ff160
[2/2] KVM: arm64: Avoid soft lockups due to I-cache maintenance
      https://git.kernel.org/kvmarm/kvmarm/c/909b583f81b5

--
Best,
Oliver

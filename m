Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA3627ED2
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="niDDOtUw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698176058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGFv9nNyXkjRC7gzx1YN3bIT7P68k/2WpWgP/TeoPsc=;
	b=niDDOtUwCDYMF+cGtFw2Bxn0/z163ixYjhLvy4gn49nszXxU69mjJ3KtL3dW4COxOU5RRg
	BV5FoRin/Hxn9hlnVocN03Ov2/jyYaHwf1127MI1oQn3ko0k3QtS4bPf5TW/uE+zXOEAec
	nHA7nrPUsJkEd3ZitgHVHw+GB+eNN6w=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: PMU event filtering fixes
Date: Tue, 24 Oct 2023 19:33:57 +0000
Message-ID: <169817600537.1684379.12304541130454554096.b4-ty@linux.dev>
In-Reply-To: <20231019185618.3442949-1-oliver.upton@linux.dev>
References: <20231019185618.3442949-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 19 Oct 2023 18:56:16 +0000, Oliver Upton wrote:
> PMU event exception level filtering fixes
> 
> Fixes to KVM's handling of the PMUv3 exception level filtering bits:
> 
>  - NSH (count at EL2) and M (count at EL3) should be stateful when the
>    respective EL is advertised in the ID registers but have no effect on
>    event counting.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
      https://git.kernel.org/kvmarm/kvmarm/c/bc512d6a9b92
[2/2] KVM: arm64: Add PMU event filter bits required if EL3 is implemented
      https://git.kernel.org/kvmarm/kvmarm/c/ae8d3522e5b7

--
Best,
Oliver

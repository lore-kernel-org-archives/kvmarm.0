Received: from out-209.mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C749124A09
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRGaIjbL"
Date: Thu, 12 Oct 2023 12:47:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697114841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZ9ACy9q0K8a//vgGJWNbpd56b9FY1ywZnapIJn+tJU=;
	b=rRGaIjbL/RroesD2jDenYXaZsImfXC+68rPBgYiL69+Q/CmWrnjsYwZBYMc3NBAIKKnUnc
	jWjqQ2SO5Kc18nTS0dx7iWHAorLtqg7fRvPI5Z6luG62NrJoRW2p5Xtg2cQw5gpg91TGfq
	QTEIlyQqDXYjoUgGt/m3TKi8Sp37beI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Message-ID: <ZSfq1Im2k2JVIY5H@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
 <2e724a19-1a58-ac6d-1697-c4a2b7a6962a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e724a19-1a58-ac6d-1697-c4a2b7a6962a@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 12, 2023 at 10:43:30AM +0100, James Clark wrote:
> ARMV8_PMU_EVTYPE_MASK is still used in access_pmu_evtyper() and
> reset_pmevtyper(), although it's not really an issue if you can't set
> the bits in the first place. But it probably makes sense to use the same
> mask everywhere.

Agreed. Well, the masking done for reads in access_pmu_evtyper() is
pointless since we sanitise the value when written. I'll update
reset_pmevtyper() though.

-- 
Thanks,
Oliver

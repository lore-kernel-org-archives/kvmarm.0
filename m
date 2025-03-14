Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3754315D5C4
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 23:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741993915; cv=none; b=erScPLs/m+RxLSgCLcBybYLSZDuPObTwQrozFLNcT0I60NFKHrlCnV/jWyLfWXEQbNfLkjzbAuteaRT2riBWjnAx4cbEKKYqOWDssAUyEy2XSmtYK3VTB92DgwQpHTAGxd1udaEgBPuA3nWEv4kJsYMvbcC8I6miMajL9/U2ecI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741993915; c=relaxed/simple;
	bh=2SF3fw/Bf1Gobpwp10cuvz5NaPeBaDcy2QeQ9b67a9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryu2fEntEg0Z5gTythm5K4iW45rP/ojsaXOko5T61V6QkC6fdX1cz/3bngr0ob6qsWZZM30rZl55Nm7fQ1iJ1VwXyl6FAguK96XjeKfNndCJtQsf4oEYYosZxEDPEEMvFnI70dO/3U72Ts2wM84IOqlN4TMXstZQpn1aMyv5qNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vVbc0m6W; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vVbc0m6W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741993911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dvkY8LE8GxIxs55S0NwZi9F3m+UhYcVL1EwUpxmHvns=;
	b=vVbc0m6WD1NDLD+3S/6AFxUZl58jcM37eGR3bDoW0ejnx5hesy8QyjtjNIlpNHHX+F3SC8
	VXYGYqqzpBHfTRS3tuyw2y2NNp7Oqf/yiVFwa05SdfDgYbulhRlb5TIIXzov5f6JGV8MCz
	U4KVAKvm+eW66XoG1shaB7GTrYqMmSU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	maz@kernel.org,
	mark.rutland@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	broonie@kernel.org,
	qperret@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v3 0/4] KVM: arm64: Fix initializing HCRX_EL2 and other traps in pKVM
Date: Fri, 14 Mar 2025 16:11:40 -0700
Message-Id: <174199388872.1347355.17256091490684730021.b4-ty@linux.dev>
In-Reply-To: <20250314111832.4137161-1-tabba@google.com>
References: <20250314111832.4137161-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 14 Mar 2025 11:18:28 +0000, Fuad Tabba wrote:
> Changes since v2 [1]:
> - Remove WRITE_ONCE when setting hyp handle (Quentin)
> - Rebase on Linux 6.14-rc6
> 
> For context, please refer to v1 [2].
> 
> Cheers,
> /fuad
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Factor out setting HCRX_EL2 traps into separate function
      https://git.kernel.org/kvmarm/kvmarm/c/44f979bf434e
[2/4] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/066daa8d3bc2
[3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to separate function
      https://git.kernel.org/kvmarm/kvmarm/c/8b21fb47c778
[4/4] KVM: arm64: Create each pKVM hyp vcpu after its corresponding host vcpu
      https://git.kernel.org/kvmarm/kvmarm/c/1eab115486c5

--
Best,
Oliver

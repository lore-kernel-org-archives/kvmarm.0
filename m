Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D321923AD
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711961232; cv=none; b=e//qoo5vCMUPn8WBecBhyGi9PiBPTkzMMj09P2/IBe05GZmUzpi4uU0WlRbmkE+d2nA59nmOTdXZAK5Z//7K/haciQg3kyFG3VAhJROLoIO50gt8ghG7ClN6HNuYOAaUlBjKO5pWG9FlKVEt2eBvdfV3YnE7+Nc6bSILzns6qFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711961232; c=relaxed/simple;
	bh=ix2qK00FP5IBi1PQgAHDVdzPj91NwVTrepYzbn66IGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGHucmdFBmsqbMUzoEmvnnNahRCO15WglqFgnM2E8cvrlu8967vBzATdCedEIR0yJhFqDoqM+aj6HqazbDVS/+4QXghHnPdUSggAEsFeIwJtafutW3leBok0EAY9zG6KbMvX2JWvnQBkDtDBqjAMMHfV0c5Fwql4h6RyWo8/GOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UQBeVyzq; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UQBeVyzq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711961228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2lZnPx+pIKFHOT2yByGwM1F/AFheppqvKtpiJ37RpFg=;
	b=UQBeVyzqrgtlyaIMPSZAeqAMsAWCIBtRCie80W9G3APG3zvomwrgbQJgXFSm+F2cdduIs+
	QNPl0mjWtxwE5AXcmsFXiNT33OV3fMk+DcNXou8sL+XnafVhxuMwKoAbXU1MUEOQHFggzv
	C8gVEpJungdmIfQ/qKihD0/ozMWrGSo=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Fix early handling of FEAT_E2H0 not being implemented
Date: Mon,  1 Apr 2024 01:46:58 -0700
Message-Id: <171196113082.400673.17275243685234421882.b4-ty@linux.dev>
In-Reply-To: <20240321115414.3169115-1-maz@kernel.org>
References: <20240321115414.3169115-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Thu, 21 Mar 2024 11:54:14 +0000, Marc Zyngier wrote:
> Commit 3944382fa6f2 introduced checks for the FEAT_E2H0 not being
> implemented. However, the check is absolutely wrong and makes a
> point it testing a bit that is guaranteed to be zero.
> 
> On top of that, the detection happens way too late, after the
> init_el2_state has done its job.
> 
> [...]

Applied, thanks!

[1/1] arm64: Fix early handling of FEAT_E2H0 not being implemented
      commit: b3320142f3db9b3f2a23460abd3e22292e1530a5

Best regards,
-- 
Oliver Upton <oliver.upton@linux.dev>

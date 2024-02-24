Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A861AACE
	for <kvmarm@lists.linux.dev>; Sat, 24 Feb 2024 09:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708766150; cv=none; b=M19TgTqAW5zff1+RTE2DVfF2dY/i676V440+pgN0A7VwbYHaNjvzZhVlMSHckaAfHHzNOJbqd+Km0/ddgWA+/PdrM/C+E4b0ROWuOM2igrpOl1YRhrlMTFknwHoOFhXRndeEG0SgP03HZ9LBWnEU1MVhaDT74iGiWgWTdtMxNoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708766150; c=relaxed/simple;
	bh=/nCNfFV9yOQlHaWyqCnWCiiTJ197iuFEo6L8MiqkLUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aopCXzv+2TuBKO6ULvgYEO8Xm3jUfP/P4B2LXoXTPEIPBHQEGzAWFS1eN7UnFRYTscX/x8tHaixCNhKqiazgFo9hEHC/CqzQFP3mTCZa6FLm5HR8+xK8knVMoaja4hNCeT4i98arK89lZ1rvNp6FrqBQ5TI2g94UHNG4ECfE92o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xIBELcgT; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xIBELcgT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708766147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HhVrqgB6eeZ/tDE1lRVyDBNfVZMl8Jpt9yJZadWr00Q=;
	b=xIBELcgT62nj54hl49Gz51C1ZfDoO5tFtJqqTGqIUBUXx64dSxM+ReGylAMokje/sgCuAI
	xJY9aGTrmzf3gU8MhRI5pUXl7+Pd5VdUbRkrke4y2syP+hmVRpfwe6uYcZEOiwMJDcIP0M
	ZDF23hbkbPMLsTZ70zK1LVS1eVnpIG4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Bjorn Helgaas <helgaas@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: (subset) [PATCH 5/8] KVM: arm64: Fix typos
Date: Sat, 24 Feb 2024 09:15:35 +0000
Message-ID: <170876611826.323614.1992753993268344387.b4-ty@linux.dev>
In-Reply-To: <20240103231605.1801364-6-helgaas@kernel.org>
References: <20240103231605.1801364-1-helgaas@kernel.org> <20240103231605.1801364-6-helgaas@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 3 Jan 2024 17:16:02 -0600, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Fix typos, most reported by "codespell arch/arm64".  Only touches comments,
> no code changes.
> 
> 

Applied to kvmarm/next, thanks!

[5/8] KVM: arm64: Fix typos
      https://git.kernel.org/kvmarm/kvmarm/c/75841d89f3ed

--
Best,
Oliver

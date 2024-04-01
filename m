Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB65DDDC6
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711961201; cv=none; b=aAr/sTtHsI52TzVvH/RNGi9/udexCQR/UmdLFHsicOCVg7PQ9XzW1M4x4caNnKgZvR1ntbD7KdgJDEnA/KWteDIlV+WAKpQIjdzdm4oOadY8PUw1DMGjryGo8n7CmnpTV6zMS0boFjWAj6pkdkXAg3SRCMT1Of41Y4M2hq/wE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711961201; c=relaxed/simple;
	bh=grOi/p8MrKe5h9bVwcHdKwlRaeVYI2q/ncd/NvfH8ZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHH/CXszI5ZzXqLmusRlIzYc39LsVK5FGHFydXM+tEyUWsZbcU81bZojiJYyOou6pgcf/2KO+ctdX5Esw+9qK5/dRXTEIbKa3y0OzbO5w5xSvIoMcAfI461PCIvslEbYhsn5hAOqvL85ihmgLHvKjTBlyzjOskTUdvc0NwyLUh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tHtUQoJP; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tHtUQoJP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711961196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWliB/Q0qBmWiZWmY327MfhK1Arj2liOYYXQlbLdXT8=;
	b=tHtUQoJPeWHAJg8ct2Jk5CnQ80ea3BNiZeD4pdSmN2GfT67dKyHGeJXA4hHreA89DKmTSG
	IeDhBuMqU1Dq2sJoR+bfpAmTAtH6BpDLdlytxVdK+dqcIA8ape0D7/vHZap1VbSqBgZbp+
	Q22SPkQwgQvZY+rMgXceQo3jZGCvEp0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: TLBI fixes for the pgtable code
Date: Mon,  1 Apr 2024 01:46:23 -0700
Message-Id: <171196113082.400673.4048921777650670705.b4-ty@linux.dev>
In-Reply-To: <20240327124853.11206-1-will@kernel.org>
References: <20240327124853.11206-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, 27 Mar 2024 12:48:49 +0000, Will Deacon wrote:
> This is version two of the series I previously posted on Monday:
> 
>   https://lore.kernel.org/r/20240325185158.8565-1-will@kernel.org
> 
> We've got a long weekend coming up in the UK, so I wanted to get this
> out before I chuck the laptop in the river.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/4] KVM: arm64: Don't defer TLB invalidation when zapping table entries
      commit: f62d4c3eb687d87b616b4279acec7862553bda77
[2/4] KVM: arm64: Don't pass a TLBI level hint when zapping table entries
      commit: 36e008323926036650299cfbb2dca704c7aba849
[3/4] KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
      commit: 0f0ff097bf77663b8d2692e33d56119947611bb0
[4/4] KVM: arm64: Ensure target address is granule-aligned for range TLBI
      commit: 4c36a156738887c1edd78589fe192d757989bcde

-- 
Best,
Oliver

Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8418B474
	for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190401; cv=none; b=XN8ifyWuAM3Gwo7p9/JKhJ4u5Qy7EG7vIFbwvXmdpsnbVvxpx3j6MAaFGwnfw2Kn6vb4BFtEdi02IJFugwsYAZhAmws3tLbedubh0ymdQ6G8t82dQfDHXRulksx/+RkkzMXbaGa2XSdHGICQ1slI0W075bg4UZjoezuhBvLoT3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190401; c=relaxed/simple;
	bh=qLb0yN4NqnbyBII1d2B+3lYvrB94iEo9uUhFRuL55zI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmgOCJT+OImuykLJw1stMPFCJ/W3hww3IuV3Kl/8yEY1+Lfe7q7kk1moqCYbItxKfbMu2c1g4Mkskbo+e9wocvTtPlTrs0z9AbCej8BziNVCwMf7TVALxfupbkZ6TZ+xTge1AhaqtgbwXh/plJ8Smi1SRvODlebDzNmnmWTlgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bVLhXX6A; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bVLhXX6A"
Date: Tue, 20 Aug 2024 14:46:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724190396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5Wfc7SpUB43gQpOzvYVCumAuS/D3QJGlE7NYs8JIZw=;
	b=bVLhXX6ACG+AY083jKB2/YB67GL6xAZr+SctARVwqeTMLpzBMAOsbVM3WfbSqm6zh4r76g
	mUOj8v69L8QwaHRe/MwKm2OIxiAjn57MgwvJeITtSabcZPct2IubEQED4HP0TiUhukeenb
	+Ke9R7UHP+O8lmiVp5iK3gTnBhrf2nk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the
 absence of a vGICv3
Message-ID: <ZsUOtp9kfpqm1enx@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 11:03:38AM +0100, Marc Zyngier wrote:
> On a system with a GICv3, if a guest hasn't been configured with
> GICv3 and that the host is not capable of GICv2 emulation,
> a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.
> 
> We therefore try to emulate the SGI access, only to hit a NULL
> pointer as no private interrupt is allocated (no GIC, remember?).
> 
> The obvious fix is to give the guest what it deserves, in the
> shape of a UNDEF exception.
> 
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

LGTM, and just as an FYI I do plan on grabbing this for 6.11

-- 
Thanks,
Oliver

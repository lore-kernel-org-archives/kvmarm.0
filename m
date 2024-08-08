Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F6190493
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136936; cv=none; b=hVvDzk1Kf7RJz7LDiUOJm1pVTppOSXBGOS3WDk8udooIzfEQbSohjCPVtgoeEF8VJ4UD/zrn3FN/pCfySHv92Wb5fSIIJbMn93BXGD27G2ov02jvbLzwZHcyI3f7geH5n42NdFsK2JLzhBUFubw4glEfFenN249bun/PH0TIcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136936; c=relaxed/simple;
	bh=o0ouofDivzDbVdCcNXL0wzjNSLS++RMw3fLPLc5jUAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRndHJRShr86ZpbP3yDIHo2W/W3g8w0nWcodX0tuRoXwGjbkXmFfztAlZjsuEAXpgzFdEXIZBlJNz8aUf0fWmYpmqYV88MTivI/aIls45zLk4qcNm3OJWVxelwfc8D/pMwggDcUmqKYvNn9T8NLEz9hgn/bIiik1pbUiUbHx+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fqp/ny5y; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fqp/ny5y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=679sHMsabQp1CD97OrRjCvkbuEAESk7cJl/f+me4pGY=;
	b=fqp/ny5yotKGef+lDwkniatECMpL5V1HO51qnVHw1IOlkhI8j9MPnDy4v/e6fscj0wd6MM
	qAMExeEQ0gV0CmX4aRfZxORSBK7GGuV9LeW2JQ6EBSlgXQ2r/LNMaOUIUDyTDuPFppxBFQ
	1rSibq3s456e34UwcxlszZEp1kS2c1A=
From: Oliver Upton <oliver.upton@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list
Date: Thu,  8 Aug 2024 17:08:40 +0000
Message-ID: <172313677522.561165.3929802952412744723.b4-ty@linux.dev>
In-Reply-To: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>
References: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 31 Jul 2024 17:21:13 +0100, Mark Brown wrote:
> The ID register for S1PIE is ID_AA64MMFR3_EL1.S1PIE which is bits 11:8 but
> get-reg-list uses a shift of 4, checking SCTLRX instead. Use a shift of 8
> instead.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list
      https://git.kernel.org/kvmarm/kvmarm/c/ad518452fd26

--
Best,
Oliver

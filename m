Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79987219F9
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714574368; cv=none; b=SYaJUiwRXqNut16sZ4VxlL9z9Azk+uKu2iY1QZko220PGbypIuiSdmeyQUdH/39WGNGIZqPlUOfsxMujUcRaUuHEu1vOWkt9ZOEYUg60yje6QuSkZ6y7jr4J6nS4cJUnFRhyCAvs5Y213O2QMQc8XesPrHYDCL0R5ru2qWG0Gzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714574368; c=relaxed/simple;
	bh=QUYDv0VTIXp0qiNxkv1TQi490ytCntp9WhNMzszXUzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdmxfQWjI8nD47q9a/EYlT1AuUMqva98Ox1F6X9NkCn8yIXjuEIZlfydpL+4QsJ5BzfTMyE/qMoq6X917qfEgs2mcbEiQg/zdD/vZjA/5VATmiSkkKPh76DkANNCO8XzuurJR3dMv41HRVR+07beYUuaxgdtCyJnEBS3k6k2NnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U0bkadzh; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U0bkadzh"
Message-ID: <d9b32c79-d6f8-4b40-9925-36351d5a77c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714574364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFySzmBpJtGW+kTBkYjvoA38JRurQeTX8poRF1MLj/k=;
	b=U0bkadzhBideO6nQgUdsRX5UJa853CVobu1eJVbK1ribb0+pewDR2HmdBIaBt/ixRJKjTc
	/vCTzv2YB7FzdQRmO+FVJM1iwlj0b1IJSywMaK9kc9cNBqtQw2iyq3Tgx+oBaCLA2BSBRK
	RQxQs7zUXUeDe5OfpBSV6536Xzp4jXg=
Date: Wed, 1 May 2024 22:39:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: arm64: remove duplicated AA64MMFR1_EL1 XNX
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <E1s2AxF-00AWLv-03@rmk-PC.armlinux.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <E1s2AxF-00AWLv-03@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/5/1 22:29, Russell King (Oracle) wrote:
> Commit d5a32b60dc18 ("KVM: arm64: Allow userspace to change
> ID_AA64MMFR{0-2}_EL1") made certain fields in these registers writable,
> but in doing so, ID_AA64MMFR1_EL1_XNX was listed twice. Remove the
> duplication.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>

Thanks!

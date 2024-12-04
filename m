Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC831747F
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 00:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733272754; cv=none; b=VHloKc9hcE+D2dy0lWM5ceE87tKqOspF/MPSWLd5lQQP6hiSOSPJBG1JDMaPDS9+Vv+7ndGOL75TqasIbsxY6EDzwTUNXPo0dDTTyvmA51VbOtrHoxi10BJcmh8kGaeJ0CL9PphVZazucNv79crakTditaACq2X9qxJH8jJUS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733272754; c=relaxed/simple;
	bh=4ZZeELuMgC+amEUmtotKI7qUXL5BYA6ZhQjkp2Hvdvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=co4m8BY1JCL5MjL3eu6pwvgbjc9ZH1MVTOWxfDDiebEr8Dx/Xe/GkEJo5dwscvgJzG6m8LoGHiXbGIgO9koZFOEuwAp27RJAL6EsLx39SgrDvYqHJtttTM2pi7k8Sacbt2mtb+M7QVKqn8VdB2/EIAm1T9bLYx4hOBrSww+wTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r0zCO0D6; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r0zCO0D6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733272748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHzpDF1jzcP3VpWgxBFchha4CS21XuWcdfL49+iiQ0E=;
	b=r0zCO0D6Jv73i58Y6pPl/v5stz8NpgYMGRbZWzvRoOW90VM1d1p8ZMqaPUIodz+5RUqpxQ
	d8KnHX055C2Apgk2tZGJbFxLH9ieGp3v2A7jXIJu0YlzbeJ6UXIMKLkCNahBHfw7lKKilK
	5zbV6CAG4FvVcqhfSifgskfTV5orjcg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-its: Add error handling in vgic_its_cache_translation
Date: Tue,  3 Dec 2024 16:38:54 -0800
Message-Id: <173327270647.1289915.12344203563872763499.b4-ty@linux.dev>
In-Reply-To: <20241130144952.23729-1-keisuke.nishimura@inria.fr>
References: <20241130144952.23729-1-keisuke.nishimura@inria.fr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 30 Nov 2024 15:49:53 +0100, Keisuke Nishimura wrote:
> The return value of xa_store() needs to be checked. This fix adds an
> error handling path that resolves the kref inconsistency on failure. As
> suggested by Oliver Upton, this function does not return the error code
> intentionally because the translation cache is best effort.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm/arm64: vgic-its: Add error handling in vgic_its_cache_translation
      https://git.kernel.org/kvmarm/kvmarm/c/be7e61127422

--
Best,
Oliver

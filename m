Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E3F2BEFFE
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 07:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758265454; cv=none; b=CJZ7T66Oj9tSTxFNOlqNf6+hFE0Yo38lZxfb77c90xMQrmtgq3OqeJQOiEak1pVlRJkV42hEx5bPce+gSwMP7toePoJH4lQ6wFH0PjxCL45dTIVgR2a9m6ls4leEVUpNsi8tUQcb33897p5pIFniy1VPEfdoP+XpfHCDYoLOo9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758265454; c=relaxed/simple;
	bh=vYU5HysLaacNxRa1afm61SjQM2ARJJbuNFg+AbDDtcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYDTo58BcgS9OCEIxVOoPqKthLVqJJMOjntxGSUMLVH0aRojAF6N/Mxxv9YXssiZkb1nBZuZJ5X1AXpSV/QfjQOAjOa049jDM1arM8Zh9QTQ21LeZ46X/OIKZBmta/46RQ6jJ8U1zsV2CIJczPWSXKocU8t0ViX810ohjr8ngj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P1bMSJkM; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P1bMSJkM"
Date: Fri, 19 Sep 2025 00:04:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758265449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ahmi8I+GcTmmAZUmANc9eCnWSPON5wkIuYALFtP4uU=;
	b=P1bMSJkMLHyKesfT0AwsLgU06rAqK8HH8H7JNxf1pZVovtC+a3IwieOtPxAOR5lESys5+a
	uY1UZiiBKw9xLUlmC2bkvQs71/pvsZxJsK5Vk7m5GaLf2ZT8qK+BlJTdEV1bSDZO2scBxh
	T8+Ox9jlcZjN98OjqzJH6w5HZncTdT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH v2 00/10] KVM: arm64: Handle effective RES0 behaviour of
 undefined registers
Message-ID: <aM0AYEjk2vgzVzND@linux.dev>
References: <20250918151402.1665315-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918151402.1665315-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 18, 2025 at 04:13:52PM +0100, Marc Zyngier wrote:
> [After yesterday's blunder, I'm reposting this, with proper commit
>  messages, and having taken Oliver's feedback into account.]
> 
> When a feature is removed from a guest, we ensure that the trap and
> control bits for that particular feature are made RES0.
> 
> For example, SCTLR2_EL2 contains a large number of bits. For any
> feature FEAT_FOO that is controlled by a bit FOO in SCTLR2_EL2, we
> make sure that SCTLR2_EL2.FOO is RES0 if FEAT_FOO is not visible to
> the guest.
> 
> However, nothing makes SCTLR2_EL2 RES0 if FEAT_SCTLR2 is not visible.
> 
> This series aims at solving this sort of situations. It is still quite
> incomplete, but aims at bridging a couple of other series:
> 
> - 20250911114621.3724469-1-yangjinqian1@huawei.com which wants to
>   make EL2-related fields writable to allow migration
> 
> - 20250912212258.407350-1-oliver.upton@linux.dev which wants to align
>   the NV support with the rest of the kernel
> 
> Hopefully this helps getting to a point where we everything is
> sanitised according to the architecture, EL2 on the same footing as
> EL1, and everything migrating in every possible case.

Looks good, let it rip!

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

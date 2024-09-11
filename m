Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492AC1B9B26
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726077619; cv=none; b=cAk8udHc/DB4R1W8Qy2Q7Nk7hk0OXU37ONBYrgVfJLaEPG6SO4AACAYrIyDP3qItiTw9Nd7ISJTOCPKWitO8KmtJU5K55QuNcqsL501Mx6TJF2cI4aUGmW1JFT7Nsl1TuNZTQKmhhWPMkqo2/2mQVRBc4L2PKllmSI5dMElCCZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726077619; c=relaxed/simple;
	bh=IhnRCaZJTTAr/WcA+mYQrUVycqjcQVe3BQ0esoraofI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppx8xYaT08yH/mAhJ2+13OVlZbCE0350ny52nzES/9sELkwn3NsKptgt0Ivm3FT28GaNPKFMn2OGz9do13/ck9ZSvOZ36p9oka2+KrZiE9w2Nh93nZH6k4DJ1Hwumegdntuectu1Nyz74VeniCN2b7uwTtFYg2F/nhL36dD69Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NA9D5xLd; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NA9D5xLd"
Date: Wed, 11 Sep 2024 11:00:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726077613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ihUxWnJ1ESYco5Pe6kpjdBw8nJlk/3qj/ALs1xfzIA=;
	b=NA9D5xLd9af5GmohRLDHBX/ZD3NVd7AlhaZTqjyjEg8mJGwFv4ZsCJ+1CM3qgzlceWrf8L
	J/uEx+oZ9wy0Jw0FKSrCVgAm3JchXgWwSLiMX7x95t1U4ZnyMOQJHg74heIYduK+3WOMOX
	L1a5umMbadBCOtFfkKgP0GbmVHsFMRo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Get rid of REG_HIDDEN_USER
Message-ID: <ZuHapdH3F8ZnSuIC@linux.dev>
References: <20240904082419.1982402-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904082419.1982402-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 04, 2024 at 09:24:16AM +0100, Marc Zyngier wrote:
> REG_HIDDEN_USER was introduced as a way to deal with the ARMv8.3 flavour of
> FEAT_NV, where most EL12 sysreg accesses would trap and yet be mapped to a
> EL1 register (KVM doing in SW what FEAT_NV2 does in HW). This handling
> imposed that the EL12 register shouldn't be visible to userspace, hence the
> special REG_HIDDEN_USER visibility.
> 
> Since 4d4f52052ba8 ("KVM: arm64: nv: Drop EL12 register traps that are
> redirected to VNCR") and the admission that KVM would never be supporting
> the original FEAT_NV, REG_HIDDEN_USER only had a few users, all of which
> could either be replaced by a more ad-hoc mechanism, or removed altogether.
> 
> This series goes ahead and cleans it up for good, removing a tiny bit of
> unnecessary complexity.

Yeah, let's toss it.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

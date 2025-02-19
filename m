Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD581CAA65
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 23:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007158; cv=none; b=pRI0YxCfXNsmz3efRFzvvYF80MnzqU4F7lO54eWNTQE4G/6louO2FDdd8w5zgayoGotAIAvyzbl3m/kDDuiT9kyVZSG+abYhmCwsGYaeYWyeVfDxsjpsdY6CBoRVHMhQKXgdJ4CwnoLes/KEY697AxUd5Gu/MsiF+dj7Ts1q4Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007158; c=relaxed/simple;
	bh=SwVIv3Wq+khucr35x1I00QEauKzA1nGVYUlz47Jo98Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9hgvaUPsKh7t5ri04bNLHP7pKYx6Jtf6L1QXSM2pRjngnDkbBUUs1pa/imzpHZE0gtw7th5nWJQv7OjyhfNqM7HaSHziTUePDviwRoHavan0j5+ZxQU57ZqQuwjGxSsq6Ar8zIDs1k9GXnYXW8QuiIIfUwq02z0IROjbaZIAgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oo+3Vg/G; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oo+3Vg/G"
Date: Wed, 19 Feb 2025 15:19:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740007151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fETwu0L8tuv2gAhj94uky1reANW9J8SOc983NJCn42o=;
	b=Oo+3Vg/GkwMMP6P5U1rzYe+IcwpjTIyuFeGqIgKcvt0Ivu48GQwydujT3JBpRYxJN44xiq
	RpRLrC1JuWy2u6suu6NUAMjAAbLktGpYQTO1TsVY2F7C6rN02twpucUGoyS4yrN3shOtmz
	DKvOcQ7/VItsXMkwEVzyvQgrr7AmpfU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 13/14] KVM: arm64: Allow userspace to request
 KVM_ARM_VCPU_EL2*
Message-ID: <Z7Zm6ryZ126gMLZ2@linux.dev>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215173816.3767330-14-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 05:38:15PM +0000, Marc Zyngier wrote:
> Since we're (almost) feature complete, let's allow userspace to
> request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.
> 
> We also now advertise the features to userspace with a new capabilities.
> 
> It's going to be great...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

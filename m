Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1EC1DED4F
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729180428; cv=none; b=swRJ6lNNn7gOIsS9iPB7tSBKzHpb6X80AiSVJE+hQJa7JE/s6iWk2+4QcRu1FwM/h8dAgTy97aB7ji0vBXPem79Nm+eKmToGu/zDFclSdlQuJhrSTZ4doZVS525MwVAuZN/BQOR1AZ+JqstK3xGdh8wwRGBR9blFcpf+CKQ1SxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729180428; c=relaxed/simple;
	bh=hn1fO+qEPRtGcwMf/lrb5AntTEPnC/brJ08VovW7eK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRbAQ+uRBTySEgE7MewU1B3sGKJtT7munGS48IKysBYatwOmRdI3y5//rIFZHHEeb6P7/2qZZjsh/KvFz8UoUYgnMmiQnbN9x5/KILwebYDibCdA81FabIE2V9XaY51tid04IJjpXkKQ/Fi+A0cb2t8M3EdTenscxaeZuPsCm0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J2Sojln7; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J2Sojln7"
Date: Thu, 17 Oct 2024 08:53:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729180421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9/em7t+BBBQsHmvv6MKondUh0J9hRfQLQ0pF3UTvMI=;
	b=J2Sojln739VF7hD2MvZ3MKU0+SJfrp0UYqokah9/tb2c6CtvDCPhz7i2fW6xTukTyP7HyQ
	aKUwMqcBgQQLAQjAK8TCIdDIUbg4/i5PXM15ZDkx/UHvtSO1FvQJHfUT0nVEs84uqS2mDi
	6FmAT32wY2wzI45UquhuBMQEMVYDEsc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure vgic_ready() is ordered against
 MMIO registration
Message-ID: <ZxEy-swdecozHK7z@linux.dev>
References: <20241017001947.2707312-1-oliver.upton@linux.dev>
 <20241017001947.2707312-3-oliver.upton@linux.dev>
 <86ttdb40ux.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttdb40ux.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 08:58:30AM +0100, Marc Zyngier wrote:
> On Thu, 17 Oct 2024 01:19:47 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> I thought we would benefit from the removal of the early-out at the
> beginning of the function, specially given that this is only called on
> the first run of any vcpu -- and we can probably afford to take the
> locks on such a rare event. My impression is that we'd gain in
> robustness and maintainability.
> 
> This can come as a later patch if we agree that this is valuable.

I should've mentioned my rationale a bit more here, thanks for queuing
the patch anyway. Prolonged blackout for live migration is a problem for
larger VMs, and I was too chicken to have all vCPUs pile up on slots_lock
and config_lock.

Too lazy to prove this is/isn't an issue, so I figured I'd preserve the
existing flow as much as possible. If we get this wrong again (which
wouldn't be surprising) then let's drop the early out and just take the
locks.

Seem reasonable?

-- 
Thanks,
Oliver

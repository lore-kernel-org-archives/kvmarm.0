Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2E834DCEA
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 12:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757075304; cv=none; b=LaqiPO+SLM8EgM42HCiTO5AxAiNvIllVllUKTEENdNiUnNE86aNSD2rq7x45SXL9Y1bDyhmFOHIcK5PhhpabRxUl00JpkMk0fSdu0jv2o4O4Qb6QnNs4u2SCC9FDuJjRRk4Tnlf0vZa17S5OgJjoJ9YSLjc9r7sahbCOwy27ml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757075304; c=relaxed/simple;
	bh=ibsTdOKVTHzOiHGtxFfaN4rsNCes07pwocidoYo27qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HnB1rQnALX+eHkQWuitW2vdSBR0eiEIhy4b7mMDWuPP2hGd8eWN9xeuvVM98rSqEZdR2fHl0rND9rJ5hj6QNQBoqShZckGwLvWwwLo92rjSlemdHmlMcbRHr5hICZQHDNkOUdCnY8/nrPoUOQFS2qkOjuaYAhedvAegsgZw0jOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KNC6dl7f; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KNC6dl7f"
Date: Fri, 5 Sep 2025 01:55:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757075296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vtFqcEiQjlP0wLvGnyIFtDon3XMCTw+C5caJDyk77/Y=;
	b=KNC6dl7fy6EMOtqwVEw19yQPzfqr52NVN5XQjOmo9jd9KssNF3iH4BVXL+h8nMGxz7cGQR
	lWxav3WuCI5idW4Neu/3sRvXpn8lPKjkntlIV3G7Yugkry9orDdxFZnhEgC1YH3s403sai
	/iJa8R7S3uvAPbCzbdf4jEC5U6jociM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/5] KVM: arm64: vgic-v3: Don't require IRQs be disabled
 for LPI xarray lock
Message-ID: <aLqliECOeDGshBi_@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
 <20250904062348.223976-5-oliver.upton@linux.dev>
 <87plc5z58m.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plc5z58m.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 05, 2025 at 09:13:45AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index 480391a0dcad..a21b482844ce 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -28,7 +28,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
> >   *     kvm->arch.config_lock (mutex)
> >   *       its->cmd_lock (mutex)
> >   *         its->its_lock (mutex)
> > - *           vgic_dist->lpi_xa.xa_lock		must be taken with IRQs disabled
> > + *           vgic_dist->lpi_xa.xa_lock
> 
> Doesn't this contradict the commit message statement that we always
> take this lock with interrupts disabled?

[ relaying offline conversation ]

The changelog sucks hard on this one, what I was trying to say is there
are no longer any writers that acquire the xa_lock with IRQs disabled.
What remains is readers that have interrupts disabled, although readers
are RCU-protected and don't take the lock.

Thanks,
Oliver

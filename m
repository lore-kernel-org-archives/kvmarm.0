Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4541C8607
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740435799; cv=none; b=UZYR9S2zdGy2yOp/RbbX/OKHRJZTaBkHHywJw3YjbTce0QN+H7KMCVmE/8LYuy7BMK4kV4LIturj3SKZAie/Sflm9me1sRPg5tTZXnvIS3BvTwF8ZXmOcjehDDHuJQuaHeSCwxBhCg6Q075MbY3pNEOGSTZLqMLRu8PMQkFnfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740435799; c=relaxed/simple;
	bh=qmooO3AxZOs0ohQpJ4yo5y4Yi0jidhmcv0CFom4ARm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3jyFZt39ErfaBVWtGm+lOVPYy+5OdKvhEiF+GkworLLTuz+GIWIgccONP+NhTk9jMj/o6GwD65G0urNSXAg/wFOc/ABQfh/ipXYorWOYncXcWRITbBlHYrlZMtZkICb3V9z1pxXLIbkFjGC7wtd3ELPluGtoh3npHsyCkx924I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=maOIQzSv; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="maOIQzSv"
Date: Mon, 24 Feb 2025 14:23:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740435794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MytlJ2KGkzQ+RhdKVpvDJ1qR08yPF+KOv8QGFyqerQs=;
	b=maOIQzSvuUUmYk2SXkgSfup4ufEe8vHbBJ1FJO81wU3bAJfRUFrahN1yRRh9znIPT/o5TV
	WoB9p4K7A8zLUuGiNJ6GriZ8DtNyq3pPrqY+zl2aOneRbzq2EQxRQ9awhbiIE8t+IhjSRU
	HIruwKqVpJtTTT00ZjwDqRmDWWixvoY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: writable MIDR/REVIDR
Message-ID: <Z7zxSdW5b6rqe2bt@linux.dev>
References: <20250218163443.32836-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218163443.32836-1-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Tue, Feb 18, 2025 at 05:34:39PM +0100, Sebastian Ott wrote:
> Based on prior discussion [1] this series allows VMMs to change
> MIDR/REVIDR to enable migration between machines that differ in
> these registers. Since these are used for errata handling the
> errata management series [2] is a prerequisite for this one.
> 
> changes for V3:
> * handle VPIDR_EL2 as part of vcpu ctxt - thanks Oliver!

Thanks for respinning. While your changes are looking good, as I got
ready to apply this series I wound up peeling the onion a bit further
and have a few more concerns:

 - Current KVM allows guests to read SMIDR_EL1 despite the fact that we
   do not support SME (this is part of TID1 traps)

 - The "invariant" values that KVM presents to userspace originate from
   the boot CPU, not the CPU that resets the ID registers for a VM

 - A VMM that wants to present big-little can do so on current KVM by
   affining vCPUs, but cannot with this series

All of this is to say, I think your series is going to collide with
the pre-existing pile of crap we have. I'm going to pick up these
changes and rework them so we can send a fix for #1 to stable trees and
(hopefully) avoid breaking the old "invariant" behavior.

I'll post what I have as soon as I test it, hopefully we can get this
shaped up for 6.15.

Thanks,
Oliver

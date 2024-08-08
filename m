Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAE518E749
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723138798; cv=none; b=XV6fJmCTkdiZCSqyj2WOz2SG2FxaWF6ZPG7NO8FBrWo5JvGkdaBK/CinAM0x4saUXhoQOAHoXcSJXC5mcCkHrcbcM+7bC2yg/9O299gQ/HodRiIcM0MH2voIfi1Wg+09YdoKqKRK/acuHW9Wy8lENqCDALf6yRYCu0tRxxq3jRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723138798; c=relaxed/simple;
	bh=vlMvwX7tLo07urhAz05uAmJs10FYSsdkxmNFWxucPZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L76AVEM2qP1bFEHxeP4F8kmtcYq5JISYYDYbNUO67GJNOTVtjskvujlEL/gzCXvR3375tZywcn+QoHP7gZrInHfiej+Tjaa5x+2lglFKmGwfeI0WjDj18H9o4jUD0RvX3eCAR2Xt7pYkHEITVeJiEx9lN+Er5cqDEcE0ED4emt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X2xZWzrA; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X2xZWzrA"
Date: Thu, 8 Aug 2024 17:39:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723138794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PU9td7ADQRBZGj/enYPCIZwtkacU55RbD4RR/gJI18M=;
	b=X2xZWzrARBuj/9WT796oJ0R2HSxjkM4tTAS3fB93Kbk1JUe4BRlvfYoTuHyZmJxo/tzUMQ
	G0UC1MScRwlDskelMxCrhNVeVtPo82F4uA+xYr5nl/o7kPa4h/ALKPi5+2b3VrQz6F2eEg
	QuK1ycDpg4nccV98pPUI0V2iofQpf6g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, linuxarm@huawei.com
Subject: Re: [PATCH] KVM: arm64: Disable OS double lock visibility by default
 and ignore VMM writes
Message-ID: <ZrUC5O8XUuvlLJcc@linux.dev>
References: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Shameer,

I find myself asking *why* we need this, could you share some details
on the issue you're encountering?

Indeed, RAZ/WI is not a faithful implementation of FEAT_DoubleLock, but
I wouldn't expect it to be used in a VM in the first place.

On Thu, Aug 08, 2024 at 01:57:11PM +0100, Shameer Kolothum wrote:
> KVM exposes the OS double lock feature bit to Guests but returns
> RAZ/WI on Guest OSDLR_EL1 access. Make sure we are hiding OS double
> lock from Guests now. However we can't hide DoubleLock if the reported
> DebugVer is < 8.2. So report a minimum DebugVer of 8.2 to Guests.

What if a user wanted to virtualize an exact CPU model that only
implemented v8.0?

> All this may break migration from the older kernels. Take care of
> that by ignoring VMM writes for these values.

Ignoring userspace writes is a pretty big hammer. In situations where
KVM had advertised a feature that was outright not supported (e.g. IMP DEF
PMUs) it _might_ make sense. But with this change we're messing with a
CPU feature we *do* support.

Would allowing userspace to downgrade ID_AA664DFR0_EL1.DoubleLock to
0b1111 be enough?

-- 
Thanks,
Oliver

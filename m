Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD44C74
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725904267; cv=none; b=Jo9E3cfReEuXLx3pf1Q75h+Ko73FVi/YHODBvvPFQYJStgIgfiLptzhzF9nD82XoD+iS3bHBkjilR35ehZM50A5eFWX8ngo7g1VBHn0SMB90VqxS3chTlSMcCmTEsVDKSqyfChxDRuvhFRRSLoON8sNyxIiYQymeoP8PvuMs2Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725904267; c=relaxed/simple;
	bh=M+mxAvnLH5iteFvV4qIXDj718ruu32ZhGNikiczHnYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmiqHGJbloVPnOV3zt7AmDbbZ2twykrnSLLMw5oFtPxfkPgoZyjHTwhsvc/KWXlKo3+Iqg0JRO+CFa3Njg0Z+OEhFRFKBtvNIepJFVOQEhXnYGf710CMUf2h/0vnPFYjDN171Wm2cloleg9Hv9FyngsrX+IW6Qu2ZG138dXvAhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d8culTOO; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d8culTOO"
Date: Mon, 9 Sep 2024 17:50:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725904262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E81+cHEsBha02+hKhiACNHEEmD+Zfec6RJ7dwjIc2s4=;
	b=d8culTOOnAley/z585WdFKuVT4cUdnWcc+Oy2Ni83GPQFCmV6vVkbwkBq/BcuRt4EHCcIK
	bZv97VjGxi33t6Q1hXnDxK05HJUypTjQSpGwDqxgD+RTDudtS/AMkd6EzY4+QTU8ECport
	uyYGsqMj2zJz37Hq70r7WAqYKwGO6BY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Sebastian Ott <sebott@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Message-ID: <Zt81ga44ztdX_KET@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
 <20240619174036.483943-8-oliver.upton@linux.dev>
 <0db19a081d9e41f08b0043baeef16f16@huawei.com>
 <864j6o94fz.wl-maz@kernel.org>
 <Zt8o6fStuQXANSrX@linux.dev>
 <8e361ab82d6c4adcb15890cd3cab48ee@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e361ab82d6c4adcb15890cd3cab48ee@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 09, 2024 at 05:16:55PM +0000, Shameerali Kolothum Thodi wrote:
> > > It should be safe, as a PIPT CMO always does at least the same as
> > > VIPT, and potentially more if there is aliasing.
> > 
> > +1, there was no particular reason why this wasn't handled before.
> > 
> > We should be careful to only allow userspace to select VIPT or PIPT (where
> > permissible), and not necessarily any value lower than what's reported by
> > hardware.
> 
> VIPT 0b10
> PIPT 0b11
> 
> Ok. Just to clarify that " not necessarily any value lower than what's reported by
> hardware" means userspace can set PIPT if hardware supports VIPT?

By that I meant we disallow userspace from selecting AIVIVT (0b01) and
VPIPT (0b00). The former is reserved in ARMv8, and I don't think anyone
has ever built the latter.

> Based on this,
> " If we have differing I-cache policies, report it as the weakest - VIPT." , I was thinking
> the other way around(see "safe to downgrade PIPT to VIPT"). But Marc also
> seems to suggest PIPT CMO ends up doing atleast same as VIPT and more, so it looks like
> the other way. If that's the case, what does that "report it as the weakest" means for host?

PIPT is the non-aliasing flavor of I$. Using a VIPT software model on
PIPT will lead to overinvalidating, but still correct. Cannot do it the
other way around.

-- 
Thanks,
Oliver

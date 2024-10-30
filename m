Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF958F58
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 04:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730263166; cv=none; b=jNPv08iayA0lQ8el38OlaRZrJCEenLNYiU+LaIdk3cXIDjXIPYXVsV4EiQ5oXHiEGV3ACBMEE3Bt1KRbZZnf0wAHYDJkpTf1wbUfGq+GHuA/4Q+lg1E22QMUPwbY+QDrzgm/e6nRCoR4HRLQP7LqC774H3ustDCraZmHC5lvYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730263166; c=relaxed/simple;
	bh=cRtjpOFnK3lIH2p96pKrXOJJhMgj+bCnppTJtPLmW/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfmxO+AFXSJvzY1vO6IBM5+J2G6pZBKsFXmxAPKdaedEXZ3p9vys8ktOdbDlls4s9OtetTB/eCqMEVeLMkP2ixEzjtLgDa/SsAZ458YWmBGOMf/sZHjcR7cSYyQcwGu/VoDnl6cqrhj7s6VEoCCZDG47AKdVmpqSuuIfeIxchn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PoMWjfHl; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PoMWjfHl"
Date: Tue, 29 Oct 2024 21:39:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730263162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sp/Joqr6Fg+CbM6kllKhe4k7VezD6hpv2eBeT+NpJcM=;
	b=PoMWjfHlTy7H6Q3L8P7djXveyvh0HGtnyk/fdVX3t5Pr3Kp2rNPy1w8a5UNt0sUPepSSq4
	+O8NZl5UbPoxtVfPZnQgBadyXzdKzIDT+f4n2hZ0etV8o24RHVM6WBDO9nAO+MWMhzpAlD
	+zggZT7wSclLJEi+pg2CAIbdT5Mv0iI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 1/3] KVM: arm64: Add hypercall support for
 retrieving migration targets
Message-ID: <ZyG4cjIscLqCT7Dx@linux.dev>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
 <20241024094012.29452-2-shameerali.kolothum.thodi@huawei.com>
 <ZxrzhAh3qE9hLV-U@linux.dev>
 <d97cd23a1962460990a642ee8a653d2f@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d97cd23a1962460990a642ee8a653d2f@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 29, 2024 at 04:00:39PM +0000, Shameerali Kolothum Thodi wrote:
> > We can't treat a single register as both a signed quantity *and* a full
> > 64 bits of bitfields. Maybe just scrap the version and have this thing
> > either return a negative error or positive quantity of implementations.
> 
> Ok. I had  a look at PV_TIME_ST/ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> and got that idea. Separate registers make sense though.
> 
> Do we really need to skip the version number? The idea was to use that as a
> future proof for data format in case we realize that MIDR/REVIDR is not good
> enough for errata later.

That is definitely an approach we can take. The alternative I had in
mind was that we'd allocate a new function ID if we needed to break ABI
to correct shortcomings of the original interface.

-- 
Thanks,
Oliver

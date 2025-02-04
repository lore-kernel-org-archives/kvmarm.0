Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703252040B5
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713184; cv=none; b=FQ5kjXQIUxiA2mBgKdwiXxwogVcClwxH8Qtbv6/SKEwdFalt1XWXIriJ4JPrPdZMZx+NtavqHymZUNmlS9m/InqfunYKZRwuMQboDwSuiuOm+b0Uh8Rc7A0iPQIFnC4VAfKhU640lqYT0Id7E/SHhK8yHW2qOlbpP16XzH5CI9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713184; c=relaxed/simple;
	bh=HDBETOnnDKYdUbldkmXtgxU6aLAk4EpTG/rCxjNdfTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r81QyzmtZjmb42uB3tOLIhq2ta82fBjl9o0huHW86O7RmHEji257o9uKMqBHceew/Z1USnOrHiJApNRWLN4f+lsttvuMklmI9nuChyCo8GoUGxTQFg9uC12S6493M3yxdxbwymW2lG+Z5SQOp/0VPml1Hkh5yNJKYL65cvUk2m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IdJQbGFc; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IdJQbGFc"
Date: Tue, 4 Feb 2025 23:52:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738713180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Aty+ANBki8vd8K5qrbGPn1eFRL7U1+Ke6iGWT0ec40Y=;
	b=IdJQbGFcwdrAQZYo4ldhrPJfK+K3DW647JeHvI+fV3JfOpvYSaEnHJr1OK4wRok06P06C3
	1L9uJTC1ZB+KHMaiRRasHRgL1xTPYFR0u9f59apZgiEnvIMooyFJLV6qKjNXVsC90aL4PL
	73vvrkrHMQ+vqzvwvwWgjiNeollFHwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with
 kvm_host.h
Message-ID: <Z6KoUBdmjVRuqPnU@linux.dev>
References: <20250204195708.1703531-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204195708.1703531-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Tue, Feb 04, 2025 at 07:57:07PM +0000, Colton Lewis wrote:
> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
> causes confusing compilation problems when trying to use anything in
> the chain.
> 
> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
> because asm/kvm_host.h is huge and we only need a few functions from
> it. Move the required declarations to asm/arm_pmuv3.h.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Please do not move KVM namespaced functions into non-KVM headers. Having
a separate header for KVM<->PMUv3 driver interfaces is probably the
right thing to do, especially since you're going to be adding more with
partitioned PMU support.

-- 
Thanks,
Oliver

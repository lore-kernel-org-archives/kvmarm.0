Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794500007;
	b=YmWYgJpOC6I2CJeolz5YneGpEsHGJHnD7VCiKKHAAomQwg1e7FlHGoDYx1bXtHW5gKtA
	 68p+0vpDfXyQxZeXWtJIaUZvPY7LOhFXYCAQDr+Yu/9FvI2XoJ1pTXxY5MwnpbiO4Nteg
	 LjcnNn0WfQ9WA/o8QlFPPMJ7+2EIWYNzI/1nRLPpt/zdrJPp+l+JBbWTFOVeTmZGCfG8I
	 mce65+4em1SKjgBhdypmeWFF2/LioAXNSF89wWr5iHM0n2uKlYlxIptPcnb1LUqBg3CYG
	 KuC0N0//9+BSa6h7gmkvtiXM93iDRpaUB9KsZHfpOlILsvUI+G0tMExx1FWALeISE1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794500007;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7v68YZ5OR9YnCTmdJ/878LbBsOgRuy7SsL0cUuqtrJw=;
	b=QrWzo8mCMxYhOoZUne6ECQJreACn94DUhlM456OrQJyueOAM20ElBYKFxdK0nwxvSA6W
	 OXQ9T7JkXoFL8VI+F/4T0ddSw4TfOdDG+QeLoGQl4FTU+3LbaGPtdwiQ25arkJihGwH2a
	 V3fgUNLe7WL5urWMTWITI/AyzX9aU5QqJ1q+j8NEWr4EEGEiTmuTvGGEcnHAFLRvyKmGv
	 87d3gcEJiHZH24CuNoZV1tmxVYll8ajH241O63TnPU6J9iOMx+I9x+EFaPKe+xfFzA5TP
	 uNm0kpSAwlVZr4tX3jX5NXDQex4UTxrRNZkoE2z6eZA9jtqAAbLXT5tKv9IT+puPu1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="tDi7v/dp";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D969606A321
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 16:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D969606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tDi7v/dp
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 981501516;
	Thu, 12 Nov 2026 08:13:23 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B32A3F673;
	Thu, 12 Nov 2026 08:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794500006; bh=ypcXC4yZuFXp31/sANCT8ECJG0IUu2kVuWxgJOc2Qko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tDi7v/dpggh82dTCsclxMKT8WK2iJzpaE5YQvlleUIgkyLbucObj5dDU+MTipbEi/
	 iX7YexJdYCv2JNE8PISfAhXmue+W+lz43Bq3BKfGYpKSHuUAatImOfBaeoIQadPugC
	 wBAcVl9DYCmJtnvp1x6Kbbgztipo9zTExuTvLz5k=
Date: Thu, 12 Nov 2026 16:13:21 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 06/28] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <avXloVVaBeEwEplU@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-7-alexandru.elisei@arm.com>
 <atDtheEuNRs7v3Gx@gremlin>
 <avXcdwY89YPFGIlk@raptor>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avXcdwY89YPFGIlk@raptor>

Hi Lorenzo,

On Thu, Nov 12, 2026 at 03:34:15PM +0000, Alexandru Elisei wrote:
> Hi Lorenzo,
> 
> On Thu, Oct 15, 2026 at 05:51:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 03, 2026 at 05:06:01PM +0100, Alexandru Elisei wrote:
> > > [..]
> > > +	if (!entry)
> > > +		return;
> > 
> > Hmm, shouldn't failing to allocate here be an error, or at least a warning?
> 
> I don't think it's something that should cause the probe to fail. I could
> add a warning, I guess, to let the user know why KVM_CAP_ARM_SPE is missing
> even though the SPE module was loaded successfully.

On second thought, there's really no need to taint the kernel if the
allocation fails, KVM and the SPE driver can still function correctly.
Since the likelyhood of it happening is very low (it's a small allocation,
only three pointers), and userspace can detect it happening because
KVM_CAP_ARM_SPE is not available, I am inclined to keep it as it is and not
print a warning.

Thanks,
Alex

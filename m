Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324141B29BB
	for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724949933; cv=none; b=rSIoDqA/hRkFczerWQhLEE0ZmVCr5uVABdiEmDMxC8W0oOfwaL2CeHHyt3s+fVeA86rPzVZMTlqAPPk3gdiWJktT5Pv/RmLH8sF6AmFzVtWxqAj8qRT1E5AtJ8wJitO/jeM7sb5A6Bi4YhFxetyLHA1yD/ApwCmTsg4huC9SdyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724949933; c=relaxed/simple;
	bh=+6mS2vbhHOhMkVmi1xbKVk6cl//S8dAQDwQuzAvpXWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzfsW0x7A09AiWREFpsBTwJHOdmGzSGthnraLqh7prbD5SAjvKzOgUBHJQYkcRjCkZBpuKCeQOEfiu8qx+o62THXQSFpCAg786bW8FKhZDXjPVF1Ai7LM4pAnrONVZL8L29/RJCJFZ9XPhFFZGzk1nhFfLRzf2rgPmYQLgIHPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iVVQIeiu; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iVVQIeiu"
Date: Thu, 29 Aug 2024 09:45:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724949929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+F9Kr23D/wZKmjC82Pb8H8g1wt5p4xoSDM7i/o/YNcs=;
	b=iVVQIeiu8d+U5nDH7ICdB6QvVwq9h3VN+9xqOywv6Mb3yD5MvlhqRGq79wzRz2/P4c/Czx
	Ws0SnSlSR1Y7rxIstYXA+L9TThZRFYERT12J/Th/SsRIxmqZS7H9TjCv61zgX3x58Yse5L
	pi9exnPGPXVkw/gc03O9ckt20tyPkn0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Cope with lack of GICv3 in
 set_id_regs
Message-ID: <ZtClo9aoI50CukXz@linux.dev>
References: <20240829004622.3058639-1-oliver.upton@linux.dev>
 <f399b6b3-8ce4-49b0-85c8-ba9bfb7117ee@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f399b6b3-8ce4-49b0-85c8-ba9bfb7117ee@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 02:12:09PM +0100, Mark Brown wrote:
> On Thu, Aug 29, 2024 at 12:46:22AM +0000, Oliver Upton wrote:
> > Broonie reports that the set_id_regs test is failing as of commit
> > 5cb57a1aff75 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is
> > presented to the guest"). The test does not anticipate the 'late' ID
> > register fixup where KVM clobbers the GIC field in absence of GICv3.
> 
> A bit late but JFTR:
> 
> Tested-by: Mark Brown <broonie@kernel.org>

Great, thanks for the report + confirming the fix!

-- 
Thanks,
Oliver

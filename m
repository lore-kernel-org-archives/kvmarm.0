Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67288231A3B
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759865126; cv=none; b=iwFGGG+Y3MKPEaxavq3RLqnzNMbHQgcvk2JRRrtVjW9BcfwjIuTNczLnRSFqBqfU4zZ0pqKk0I96hKRqRdL0stV/gYMxksE9BfnIU9ZtNJd5UiDv+yzDLNwtgzpuosM6XHK0BgQ4S1TcLQ4qq3tYKFp4DsRKtiTQz0q/my8gW3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759865126; c=relaxed/simple;
	bh=EDgHwoAJzqvcFv+vwg/QTb+53s/c4vVsjUdQ6WejS8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBJ43eGY1s04yhrgfMSDhHS9aSOKFqw1avKsw7EY3TRT1pWyfHyPYMxaN6Yh2K/H1ZlWiz3AQvl6G337EUtRYgN1eYNHhEZBE24phUp0a3sy/q/xahZV5j2cOC2CHiY1a66YH4qPA7c9HWP/d0JZFpVoR9rxbqMnZxQwVQWz570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aB2uGtQi; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aB2uGtQi"
Date: Tue, 7 Oct 2025 11:31:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759865122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGuyQHKKKk5kaFnYuhxhE4b42paZhXgBeZT5hWvt874=;
	b=aB2uGtQixcZ8bSr2I9L34mScrQ9EMhFP/TKRKR2UDidJ2WNbGf16h1lI1ROwOwjItLfQyF
	A+3iMUiL6K6ryXgFbkzh7Akpe1haY8MYhH3afkhXVf9KxXv0rw1jqPFcKtAIEev+/X02z5
	STF0zp5wF586aMzKids38/SPamJVS4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
Message-ID: <aOVckTSJET5ORY1n@linux.dev>
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT

Hi Mukesh,

I find it a bit odd to refer to cpu_has_spe() in the shortlog, which
doesn't exist prior to this patch.

On Tue, Oct 07, 2025 at 11:53:56PM +0530, Mukesh Ojha wrote:
> commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
> initializes PMSCR_EL1 to 0 which is making the boot up stuck when KVM
> runs in VHE mode and reverting the change is fixing the issue.
> 
> [    2.967447] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    2.974061] PCI: CLS 0 bytes, default 64
> [    2.978171] Unpacking initramfs...
> [    2.982889] kvm [1]: nv: 568 coarse grained trap handlers
> [    2.988573] kvm [1]: IPA Size Limit: 40 bits
> 
> Lets guard the change with cpu_has_spe() check so that it only affects
> the cpu which has SPE feature supported.

This could benefit from being spelled out a bit more. In both cases we
check for the presence of FEAT_SPE, however I believe the issue you
observe is EL3 hasn't delegated ownership of the Profiling Buffer to
Non-secure nor does it reinject an UNDEF in response to the sysreg trap.

I agree that the change is correct but the rationale needs to be clear.

Thanks,
Oliver

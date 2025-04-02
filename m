Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53CA1917C2
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743612238; cv=none; b=kyAtEqZZDPZlGbTyxNb7qYt6OOmlWqmJOIz8QjfRf3g+3lSyvtJPkTDHfMrRjkm4bzciBIgXonX9uqKbf13ju1ORnDgjZrjWfSkwFauKSAI62MXxAf+Rm5mTWfepVabH4UY59csjBaGjGba+H1tA60eaqqajcEAMs55fSH6VTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743612238; c=relaxed/simple;
	bh=0+vjMn6MGe4SGiHigLwAz6N84qzUSCpdnJ+Gv3PVWQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Idmyy5PDOVaih2bhZ231Fm3XMKHCqp2X/V8Crozj5do7C26BnQPU0KLWF4gA41ZtbD7Pf36Yl6druWTccYRMOiSVDGD4HsKSzKOFI/xq2Iz39zZV2PUYb/Aq3r6/l3Sr6lFNoCNEN5Z1O3Y+viqNfJMAC7WLKB9TABzKYOHLyVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QV4LwqRB; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QV4LwqRB"
Date: Wed, 2 Apr 2025 09:43:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743612225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dC2BktL2U1qJZpOkA3oSO/rhAVApRNRqpBDF3LmdFzk=;
	b=QV4LwqRBXE/ZSwab145rZFh2Wh+9zagi8movC6n+xstcXwajIwpREX2Apbkb/XDWXiomdO
	Xvog9Upf8soPxXuBVSgRYIDNIqdyYyB0pF9fYyUy0nYrTBl8OAigLiFODBzCaoJApVPYv+
	Q+i1Ib8wS96p36xm0dkeJ7LBnEoUSM0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, mark.rutland@arm.com, lpieralisi@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smccc/kvm_guest: Remove the accidental semicolon
Message-ID: <Z-1pPLI8HRjg-bSx@linux.dev>
References: <20250402134401.146156-1-shameerali.kolothum.thodi@huawei.com>
 <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402-independent-hyrax-of-honor-4515fb@sudeepholla>
X-Migadu-Flow: FLOW_OUT

Hi Sudeep,

On Wed, Apr 02, 2025 at 02:58:06PM +0100, Sudeep Holla wrote:
> On Wed, Apr 02, 2025 at 02:44:01PM +0100, Shameer Kolothum wrote:
> > Fixes cocci reported warning:Unneeded semicolon
> > 
> 
> There was similar patch on the list [1] few days ago.
> 
> > Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
> 
> ^^^ Is this really necessary as they get backported as well ?

The blamed commit was introduced this release cycle so no concern about
backports.

> Since, KVM maintainers are in cc-ed, let me know if you guys want to pick
> this ? Else I can send it as part of my firmware (ffa/scmi) fixes.

I can grab the fix here in a moment, I've already got one queued up [*]
for the KVM guest driver anyway.

[*]: https://git.kernel.org/kvmarm/kvmarm/c/acfcaf90db1f

Thanks,
Oliver

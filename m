Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC938821
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736205660; cv=none; b=TeMu6d30ADtd86/XyPJwPfm0WxMzjMp7pzrHwtDuWSB8c97I8AlZ3t7Cn7rQ2WjBL0MsTriawC9svTSEXDAI5nhUw4wwGH1bGqtp7NKHntuMByYYBaflOyz93NxLldRQAVpsMqICj8Lk2bm0s3Hvjy9JsunlcrcdrDzG+I1Hwvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736205660; c=relaxed/simple;
	bh=2hTo7yY72ZrfGb8G0FjM0ORl9GOsTtm0JNv+Dby320M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htIxf+nk1sfDW8Oc0Fj9rZ6NMPtx+yTR2XkwbpUall82sdsaGr9hRsuQ4/igpaiFZWU4w1hmxmgkn+UuRGEzfcNeNiP6uGqfZL5fIOHd6ICTosM5xho/2T7KlvwLhUaanWO0kRe11aOQwj6f1uy5M5CAuPJEjcWKABshvWN+rNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dw1e1cto; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dw1e1cto"
Date: Mon, 6 Jan 2025 15:20:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736205655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNcyYWZnXfW6aFkgFU5YA1nQFdknczTHmN2ptcVvk0s=;
	b=dw1e1ctoHziDCJke08fFxKJCLhgc2JYbKdHAJnM5ClybtvuLq9GHJ+7Oke3os7lcHVj3+q
	jeCw0XOxumnJVBWPlJGPVMu+4dx5YojcAgWZP0Spu072Ds2cDLMh78NcGmBZotlJLh39Z1
	DQUT+WjFFtHp2FqGss8WJzK2B+vt4WE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com,
	tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MOPS in pKVM
Message-ID: <Z3xlT51luMieOAab@linux.dev>
References: <20250106112329.64013-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106112329.64013-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

+cc Fuad

On Mon, Jan 06, 2025 at 11:23:29AM +0000, Vladimir Murzin wrote:
> Flush HCRX_EL2 when switching between the host and the guests.
> 
> Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

We shouldn't be trusting the host's hcrx_el2 in this case and should
instead calculate it for the pVM similar to the other trap registers
(see pkvm_vcpu_init_traps() and friends).

It is apparent, though, that we erroneously exposed MOPS before commit
3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features for protected VMs").

-- 
Thanks,
Oliver 

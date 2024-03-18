Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434A55776
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710782551; cv=none; b=inPnDedPye4Ax3OZl97iKLVJIn+ViM4LJx3dCx42zJzv9L4J3WRotO7o2AtyBqXHh1ztbgqjGHR7q6+zPNiQQdbWnjQDHUtnsfL+D4ICEg+2DXEtzjTzB5lVlb4E4iGDYc8zwka18RznNKBKi1vcrYesi+4fB8CGY8pKONhOO5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710782551; c=relaxed/simple;
	bh=RJrWgzeoMtAA8xGKCEjgqVBMRizykgj3qzhMbAcO5Bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4c4b8AtFtFQFnDXhn7wFi82td95LCJaa0LXHnNQGf1OnWzlQdckI3qYwUZBiwudWTEABzxsliZzau0pvAjPwYjkaE8cBpYKoe6mHdp3l8sLcfMjpoE13xENw+y5LotUOFD3Sk/E49dz0c8lAGzne593oNql8iLVzIdfBQ4ONA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bj5cdJJq; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bj5cdJJq"
Date: Mon, 18 Mar 2024 17:22:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710782546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lmUnuMT6X6ljCwro06ZGTVVzpas2u24v+V3uk0OS4nk=;
	b=Bj5cdJJqm5Krv61/uQ7n4LUBPl93+J1ThiZbmohZp2SKFmW4IaC6/BydvJh/slMDKZFyRn
	r7+ERpHq+rS2QvBLEXi4zQhInOKiBBQ3MWVxFqbz8ik0XY7A8ShEGrTiV8CQKZp/ESKKX0
	LasH9Dmhb9oZxdxx2LFV3iuzvG+kJdA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Wujie Duan <wjduan@linx-info.com>, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Change back kvm fault condition to
 translation
Message-ID: <Zfh4TOQxzTUxGePf@linux.dev>
References: <20240318100249.220897-1-wjduan@linx-info.com>
 <864jd3269g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jd3269g.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Mar 18, 2024 at 10:17:47AM +0000, Marc Zyngier wrote:

> I think 7 tries are enough ;-). Here's what I was expecting:

Hopefully I'm looking at the right thread!

> - a subject indicating the nature of the issue as a one-liner
> - a commit message describing the exact situation
> - a Fixes: tag indicating the commit being fixed
> - a Cc: stable tag to indicate this needs backporting
> - Ard's Ack, as he's been kind enough to look into it
> 
> See below for the full patch and my own RB tag. In the future, please
> try to follow these guidelines.
> 
> Oliver, can you please pick this ASAP?

Yup, I'll queue it up but I only plan on sending the first set of fixes
after -rc1 as I'll be AFK for a few days this week. I'll get a respin of
the vPMU + nVHE stuff out too.

-- 
Thanks,
Oliver

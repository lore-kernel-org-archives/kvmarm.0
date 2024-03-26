Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FB619478
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 08:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711442552; cv=none; b=gECtiedEiMbBQdt+B/1C1KipYWaF2UKZ8aExmzmtvnlUN5F56vIktoCm2Cnb1ONSpKsAqzzbt/jk5JUixYH0E2u+rKDLBx2XlAXk46mOLiCFzvr5Wngnd2eBVwuCtZNqmJ2/7A66YuvkGxgjb2yiLdKkNiGkArUc3/C6o5KsVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711442552; c=relaxed/simple;
	bh=q5UAme1oB4H0g/pP6xPWP68g2m1LNo1TREV/gGVk5UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCmhtghmtnDm9PBXjfTA86uCqpBN4o5JCcRhIX5GL/B9I8fDToTjB/luaUC+h5J90YMAyNg17EcimIa3kQ1K0tr2ioOypSjsJBhTeLo4+G0DLYO+4B2xWT8RtpDk643SXCuR3kikNTbsy24XrqSPVNkfF4W+EZqjq91mb3ddyWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bglosqrz; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bglosqrz"
Date: Tue, 26 Mar 2024 01:42:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711442549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/RKu6qSQVXlpcN6JejyWa9aG5aIhVhSwxHBg5O7Imr8=;
	b=BglosqrzkG1Cg8t1P4ltdTyaXKjeqqNDnwiL3kXE1sDehRq5nREwzP+Xr6Ne9hvOS8jgsr
	knnYi4W2CL5McWS7cL1qWRMPtGy8DGXgFd89ULBuvxu4aetdkaykrG/g0kn8G6NkCHs+jL
	F6thk4SMFL6RZaTG0FjV104PMjhb6GU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Allow only the specified FF-A calls to
 be forwarded to TZ
Message-ID: <ZgKKcurtndJaIwAV@linux.dev>
References: <20240322124303.309423-1-sebastianene@google.com>
 <20240322124303.309423-2-sebastianene@google.com>
 <Zf45eDs8Bd1UQ94Z@linux.dev>
 <ZgFgI0Ky2m4MUbw-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgFgI0Ky2m4MUbw-@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 25, 2024 at 11:29:39AM +0000, Sebastian Ene wrote:
> On Fri, Mar 22, 2024 at 07:07:52PM -0700, Oliver Upton wrote:
> > On Fri, Mar 22, 2024 at 12:43:03PM +0000, Sebastian Ene wrote:
> > > The previous logic used a deny list to filter the FF-A calls. Because of
> > > this, some of the calls escaped the check and they were forwarded by
> > > default to Trustzone. (eg. FFA_MSG_SEND_DIRECT_REQ was denied but the 64
> > > bit version of the call was not).
> > > Modify the logic to use an allowlist and allow only the calls specified in
> > > the filter function to be proxied to TZ from the hypervisor.
> 
> Hi Oliver,
> 
> > 
> > I had discussed this with Will back when the feature was upstreamed and
> > he said there's a lot of off-label calls that necessitate a denylist
> > implementation. Has anything changed to give us confidence that we can
> > be restrictive, at least on the FF-A range?
> > 
> 
> I remember your proposal for having an allowlist instead. The current change makes
> sense if we have https://lore.kernel.org/kvmarm/20240322124303.309423-1-sebastianene@google.com/
> which opens the window for more FF-A calls to be forwarded to TZ.

Got it. Last time I didn't catch the level of abuse we expect to endure
from vendors, but now it seems we will not support non-conforming calls
that appear in standardized SMC ranges.

Adding mention of this to the changelog might be a good idea then.

-- 
Thanks,
Oliver

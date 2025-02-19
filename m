Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC819D882
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 19:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739991871; cv=none; b=rjZMIHuQn93DHkE+lbZIQB0emirKVixJqZriGGlOk8xrPdG2JYEurkp2iRBJrvKImP4FF0tKuE5U2ML23//15hpdTXP7swNiOQblphsQr+U8I0sQ2zJ20ykie3SywJqKiVbrvwEvOwR3QBs4oNKxIIHmUFaR2af5hNkrVZEx2cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739991871; c=relaxed/simple;
	bh=qTB5e9W0Ys0mCxDqvlIcmxJR8u3FjkDoucCLqOgT2e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWPwzh+f7mdriODS3duKyG6X5uxkeq/ZuLygySM4oHp3KcbCsb0+BBcGlBJptGpCJhmtio5/s8aFFo9TLhlAcwbl5Ibd/v+lEK3IGgYAxhye51wKdBP522gV2AMSbZ7MLPj6AntWgCrEOGlq8xjRNGa/HMdoE+43Qh6lmVnJeMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfSVRKIy; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfSVRKIy"
Date: Wed, 19 Feb 2025 11:04:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739991866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W6zk47/4FkBLywYJQuQtMPLTYPI0Mlf+FNTdse3N6ZY=;
	b=qfSVRKIyz0N96eyb2/fchCXV9IZQuTERYuYiqdmTT1Q16j2DTYZRmsaOLroYfNU/jy7Zwr
	GFaYNBUMLghClhBGonIAxfzRrV6mJTtT4FdnpDecu2+U/4s6ggEOH3UT/1L+jM6clbVN1C
	RjZ9bDP6vKDCkhlYeJk1gCICWTcRULQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Message-ID: <Z7YrLMz49_f14MRs@linux.dev>
References: <20250217112412.3963324-1-maz@kernel.org>
 <20250217112412.3963324-2-maz@kernel.org>
 <Z7OFvp7LMcOvWziA@linux.dev>
 <86a5airpyy.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a5airpyy.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 19, 2025 at 02:03:49PM +0000, Marc Zyngier wrote:
> On Mon, 17 Feb 2025 18:53:50 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > What do you think about adding a new vCPU attribute for selecting the
> > number of counters for a VM? We can allow non-nested VMs to use the
> > 'old' method of writing PMCR_EL0.N and force nested VMs to use the
> > attribute.
> 
> VCPU attribute? or PMU attribute? I'm really not keen on the former,
> but the latter is probably workable, as it is VM-wide, similar to the
> way we keep track of pmcr_n.

Well the _existing_ PMU attributes are actually vCPU attributes. I do
agree that accessing them as a VM attribute makes more sense, but that's
the UAPI we already have...

> > We can then enforce ordering on the attribute and prevent it from being
> > used after vCPU reset.
> 
> How would that work? Do you really want to mandate the PMU selection
> (with its counter capping) to strictly occur between vcpu creation and
> init?
> 
> This would, for example, break kvmtool which has these two operations
> back-to-back, and sneaking new device-specific actions in the middle
> is a bit unpalatable (there is a split between VM-wide and per-vcpu
> actions).
> 
> Any idea?

If we want to do this the 'right' way, we should provide VM attributes
for selecting the PMU implementation / configuring the event filter
to complement an attribute for setting the number of event counters.

I don't want to have a mix-and-match approach where vPMU attributes are
scattered between the vCPU and the VM since it requires a similar amount
of gymnastics in userspace to set crap up.

Thanks,
Oliver

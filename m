Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB0F3CB570
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 23:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514361; cv=none; b=u+wUBlf/t3vSc0955S4U95xjxhWWLuC1rWLIYy19A/PkpSiaC6MsIWxfXcN/61Ol4eVDMAGUChlYn2Pznmqf/le4Dt9hRoMi6s40UuGx9rhBvyx6EkAJh4BtFiptd0osSU4Du8nqpw/h2GVEzra+Wu9PE8G/k1YtWL2DGxOA/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514361; c=relaxed/simple;
	bh=O0kRRAHdRIIAGL+nLLhAmJ2XcxYiaNnMgxxbhES2Dg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ri19seWELAuzkhNTz6BdgXWcWbww9WePRpMedIDFDPEzDKWZXl2RfxOLNp3A3EzjL/CGS++CImZKCglrpdYLOru5PqVQqWKneFWcI6gq9B4kd7CdWvQWCDEJvWf43NjgwR6gY93q4eUUFq2xxtVGoleKXyNOfHCUxILaPO3TglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8tEdldg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8tEdldg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8A81F00893;
	Tue, 15 Sep 2026 23:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789514360;
	bh=GH7PvY7Ek5eU0oUzqvX7kiLyqSsMwpIZ9OKCy4/7MyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z8tEdldgVrlZDGnYYRBVfvXzbVbG0GfhvQQ4mfX8TcIc9tbzVexXVf/2nkAYkzism
	 eG1QjaPL1qAKyHkmrYSYr8wuKqtFeJb169Tzpgaetzrg+hTcDUpSZ5c83lXUmwTY79
	 O0h7vj+I68pXIMtKObunRugJ73mbA6MWitsM9gtohUcdC7mbgYv24RWfeaDKyQaYFf
	 Iv+HRs1M4nWlqoeA64HWLuMxgDRswcxHJB+k9xlGt+UstfGNe0e/UDf/O4lZ72bZIU
	 MyPh2kkPsKJI+ju8szynHwZOlcpeQEBUG5QqjwBbrBDtKlT4DjZP9WA+2bU892HLnE
	 Tt4RrQ8f2BSug==
Date: Tue, 15 Sep 2026 16:19:18 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 0/4] KVM: arm64: Reduce overhead of full S2 teardown
Message-ID: <aqnSdjE9puG1fsVL@kernel.org>
References: <20260912104834.3093878-1-maz@kernel.org>
 <8bf3f266-06fd-49e0-8de8-33c7a044e997@linux.alibaba.com>
 <865x086yhr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865x086yhr.wl-maz@kernel.org>

Hey,

On Mon, Sep 14, 2026 at 09:14:24AM +0100, Marc Zyngier wrote:
> > Another vCPU can therefore still use that shadow S2. The write lock
> > excludes software page-table updates, not hardware table walks.
> > The following interleaving is allowed:
> > 
> >   vCPU B / hardware walker        vCPU A
> >   ------------------------        ----------------------------
> >   Holds an old reference to T
> >                                   Clears parent, skips TLBI
> >                                   Drops T's last reference
> >                                   T is reused by the allocator
> >   Accesses T via the old reference
> >                                   Performs final VMID-wide TLBI
> >
> > The final flush barriers cannot retroactively protect a table that
> > has already been freed and reused.
> 
> T is a shadow page-table page on the host. How can vcpu B hold a
> reference on that page? It isn't even in the same address space.
> 
> Now, I can see that B could have a VA that *translate through* T, and
> that's rather annoying.
> 
> I'll have a think.

One option that may be worth considering is reusing the KVM_REQ_NESTED_S2_UNMAP
request for emulating VMALLS12E1*. All vCPUs that share the S2 MMU would
be forced to take EL1&0 out of context until the unmap operation
completes, at the expense of an unnecessary kick to vCPUs in a different
MMU context.

A bit hacky but seems more straightforward than wiring up some batching
mechanism for freeing table pages.

Thanks,
Oliver

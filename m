Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0894522EE5
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 01:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742260236; cv=none; b=fYh9ktN8c4DZDrfIoqcARwHXFNyrwvDqDrpBCN1wSnVFCIpmRIYdsUInXuQoXTc4lG2JEpAFUCl9Y8J8xs1O1teRh6+jVVlOV40l/hBcibY/RZQnIDXGeojKk8gXNVB3KNI6PcKJYXG5jwufQfWbVh2nY5UNlKP4HeSpM+3A36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742260236; c=relaxed/simple;
	bh=tM3HLjz53VhIBqvCJOALiWTgxizKnX4AgaioCYhWLFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DddrJElCy3HRXxFmVusvhvd5Blso2HLKH7ZOyWSUjoiQ9M3mVPzG4jGeNkIREKVEKiP2CEfUAW5WWOpVxgaiweb0JpZ5YAVx6G/qcujwA07qL9PFKYBNgOUa5dkjcgVzBlSwqVPtXebnfhpTs6PyjAp7PkXylo/iJRW2BG5HNDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Csrm2rCG; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Csrm2rCG"
Date: Mon, 17 Mar 2025 18:10:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742260232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D7L5JaSSP7KqK5qtYW4DA5/1ty6PTPAOJlyJZwmruf0=;
	b=Csrm2rCGWFTdWIezj3W3zZ5fgYba7sjxzjrPa38VV69seaAQVibkYqZ+Wj2UYRMTLERN9I
	NtjFA9M/wQTXuHzRl4vCGmHEbSVLXUQymtMth568BHR8IBRX5+M/1u0379YJGUpVH0sGLh
	YrK4HLy5JRY20dGs5FU4035VDclzalk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [RFC kvmtool 0/9] arm: Drop support for 32-bit kvmtool
Message-ID: <Z9jH-kMh1p0S4g3J@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <Z9f78K-m9h7YlzUr@raptor>
 <861puwnd5l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861puwnd5l.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 10:51:18AM +0000, Marc Zyngier wrote:
> On Mon, 17 Mar 2025 10:39:44 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Oliver,
> > 
> > I'm CC'ing Marc and Andre (Andre is the only person that I know for a fact
> > that ran 32 bit kvmtool).

Thanks Alex, forgot some folks :)

> > Haven't looked at the patches in detail, but as someone who ocassionally
> > contributes to kvmtool, I have to say it's always nice to have fewer things
> > to worry about. I, for one, never used 32 bit kvmtool, I just compiled for
> > 32 bit arm to make sure it doesn't break.
> > 
> > If nobody objects to dropping support for 32 bit kvmtool, I'm planning to
> > review the patches.
> 
> Frankly, the removal of 32bit support is long overdue. Every time I
> hack something in kvmtool (at least once a month), I have to wonder
> how to fit that in the 32bit code that I *know* to be dead code.

That's pretty much how I arrived at these patches, hacking on something
for arm64 and getting annoyed with the 32-bit stuff.

Thanks,
Oliver

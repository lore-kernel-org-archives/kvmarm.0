Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14545732B
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714645235; cv=none; b=CpID1fhh/vvWeyEpCTpxaEVwfGV5nxCNli4i/qaWUOFjx/XTWufYTNNSDTtZsIXBdJy+AVPhOw/Azji468A5nM4ddD/LzzAb1+LHTk2r1VrNKvThe6rHssu3EYSUtQoTjO32WUkvtCdlnOijye3pGevH8GqVVYO/DgBzQDIlGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714645235; c=relaxed/simple;
	bh=jCxOm2YUiLkjB71tw5e0np3dEbi94AGDR3wlvMU0wJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caZG/Pg96kllCrtfPfiN3S+NF7USt/QQWr1oUj++0gJ3lAuho5IlNYAJF/cdzMyG4/iX0cxvayAWc7cWW7LIiiho8Bbu5l+k6lg62JL0aMA+qo/HXShdS9kMcHGqw/JF19e2bsUCbtzhEfrzTRUqcp+m4RAZMzxcUn0jlZitdNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3qSGhHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3qSGhHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED98C113CC;
	Thu,  2 May 2024 10:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714645235;
	bh=jCxOm2YUiLkjB71tw5e0np3dEbi94AGDR3wlvMU0wJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u3qSGhHXmjDqsVcJDd9uiA26M9MZnUPUR6WsGn6/9oML2RvqOYYMGnoPKuoQqHJnY
	 1FAf7bXkpIikz9OJdELUjo/fOZClJUQz+j8H7utJP5SQNDD9ikhtJ7+CNwdgQ7t62F
	 XFDlME8PSkg/zj+1tWwHBnhHC2pTAo6cobRobDFhR857kSiFL52pRhCSHqIi3OpZWI
	 kfWEKEL2hDSOkaEMnck1RbYBfx0U0DPHEqIlrOiJSj/O1dLHICO61s3yALbsW6FTJO
	 yFlzb0h33lbYw/dik4o+zcLOQb6QMx2U5jPfdnPAm2xNvwFKmMPV3vwlh3/cN1VrPr
	 Jkj59invcW4gQ==
Date: Thu, 2 May 2024 11:20:30 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix hvhe/nvhe early alias parsing
Message-ID: <20240502102030.GA16965@willie-the-truck>
References: <20240501163400.15838-1-will@kernel.org>
 <20240501163400.15838-2-will@kernel.org>
 <ZjJ_mdsCa_fAy_NT@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjJ_mdsCa_fAy_NT@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hey Oliver,

On Wed, May 01, 2024 at 05:44:57PM +0000, Oliver Upton wrote:
> On Wed, May 01, 2024 at 05:33:59PM +0100, Will Deacon wrote:
> > Booting a kernel with "arm64_sw.hvhe=1 kvm-arm.mode=nvhe" on the
> > command-line results in KVM initialising using hVHE, whereas one might
> > expect the latter option to override the former.
> > 
> > Fix this by adding "arm64_sw.hvhe=0" to the alias expansion for
> > "kvm-arm.mode=nvhe".
> 
> Hmm, I wonder if it'd be better to just evaluate the sanitised VH field
> in hvhe_possible(). Otherwise I worry about keeping aliases in sync when
> new command line options come along.
> 
> This is similar to what we had before commit 35876f35f482 ("arm64:
> cpufeature: Add helper to test for CPU feature overrides") w/ the added
> use of the sanitised reg.
> 
> Thoughts?

I think that goes wonky when you have the arguments the other way around:

	"kvm-arm.mode=nvhe arm64_sw.hvhe=1"

would end up using nVHE.

Will

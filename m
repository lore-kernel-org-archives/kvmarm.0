Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163EC27702
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPDVrJrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DC5C43397;
	Thu,  5 Oct 2023 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696514904;
	bh=DK81/htK+2aR7Ilf7FzYj5ATkDZv3qQF17441LDLSQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LPDVrJrdB0gzVcVk+AiFyKdrZVSNnQpfOQFIaFc4NtyGmObglYpZx69OaOGxp+ZER
	 py5k8PfxXKyzgWa0b2AKIWe2JEdutccIbKszNnOyOg/Ez6fPRG84YUjD8WvCIk3BrB
	 1WH+4nc063LUHU7aoVjg469gO4QNqrTV5AaHuY6vc7cpm4IpVL2RZemXP5b+Af5nYr
	 GTtCI56AjK7ZEqTzzo2V0FRO/oCQXaDgSWFEBDAHo08W1lf4KelpMHDtumRkW9g5ZJ
	 JwdncdvmnOcD4i/6EiMekH2hr+KBQnZeckZ/4DPy7A5qJ2qSB6IYT2/b6+BV6HqVpM
	 9bEe+N6iDj5Eg==
Date: Thu, 5 Oct 2023 16:08:16 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, ankita@nvidia.com,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZR7DUK8/OHof3uAn@lpieralisi>
References: <20230907181459.18145-1-ankita@nvidia.com>
 <20230907181459.18145-3-ankita@nvidia.com>
 <ZP8q71+YXoU6O9uh@lpieralisi>
 <ZP9MQdRYmlawNsbC@nvidia.com>
 <ZQHUifAfJ+lZikAn@lpieralisi>
 <ZQIFfqgR5zcidRR3@nvidia.com>
 <ZRKW6uDR/+eXYMzl@lpieralisi>
 <ZRLiDf204zCpO6Mv@arm.com>
 <ZR6IZwcFNw55asW0@lpieralisi>
 <20231005115630.GL682044@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005115630.GL682044@nvidia.com>

On Thu, Oct 05, 2023 at 08:56:30AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 05, 2023 at 11:56:55AM +0200, Lorenzo Pieralisi wrote:
> > On Tue, Sep 26, 2023 at 02:52:13PM +0100, Catalin Marinas wrote:
> > 
> > [...]
> > 
> > > Anyway, the text looks fine to me. Thanks for putting it together
> > > Lorenzo.
> > 
> > Thanks !
> > 
> > > One thing not mentioned here is that pci-vfio still maps such memory as
> > > Device-nGnRnE in user space and relaxing this potentially creates an
> > > alias. But such alias is only relevant of both the VMM and the VM try to
> > > access the same device which I doubt is a realistic scenario.
> > 
> > A revised log, FWIW:
> 
> What is the plan here, do you want Ankit to resend the series with
> this text?

I have put together the text to summarize the discussions that led to
this patch; if that helps somehow, yes please, make it the commit log.

> There were no comments on patch 1/2?

I don't have enough background knowledge to make a statement on this
series' code, I just wanted to make sure the architectural details are
in the commit log so that it can help the reviewers and, if it makes
it to the kernel, future developers.

Thanks,
Lorenzo

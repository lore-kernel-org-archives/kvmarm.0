Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D9D5C96;
	Wed, 17 Sep 2025 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758121301; cv=none; b=TqvMW17VsMftRY/IhrzqK3begc8d/uJlsPSSp4k0AC3CMBfxXvtB94/pmDdnpIJSfyiigU+cadcq7ajv09N/NUoxvOjyR5pBgCUZlDwbkrM5txd110Za9r7nkM3rvPSvQBA9o2PqQJZdyM/lWCge98TfdYt4UZvHuBcZrocq8Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758121301; c=relaxed/simple;
	bh=FnHcUlKUC42/SYE9xNAGo27o6RvndkxUBiBXrKyn4ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTQw/D2fYJncmUZDN+nfeK/FslPui7uXC/MscGyF2EgvHuWluJQzuTW3/cG99HlZOVm9Yp65wOnK8hSFWaEb3OTYfqhnBmkqWeLQddmZ1gqTSQWRXFYYfVE3BX+4I1D985ArRr4+CgGawDMnPyTRZsXYew3mCwpa5Wd6fZb61iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZD9iNAKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZD9iNAKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F437C4CEE7;
	Wed, 17 Sep 2025 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758121301;
	bh=FnHcUlKUC42/SYE9xNAGo27o6RvndkxUBiBXrKyn4ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZD9iNAKAciuuXbJcA9dTxRlg9L+yS0ZBIjTtv3pO1JLNZDANejYVfBJl8Gmww85dy
	 zEfHpd/hCIIKzwOjetUnfjIr1oBlV4fuHX37qC9bP3/iSU+OBuNi6ovn+sC5xGpb9s
	 VluPfZGQl+q8JlHVeL9pk4yWoAFOufOlVBAKuc2oGJRotMhIpbJVQB4LNKU3rZLANC
	 czCejl5Comb+k+TvjEN5GPKWSB4To8WlMOTtSzBR40KRDXxH9soU5S8Yz2vOaE/Q9S
	 t8VKybdE2tHqpdy4P40/sFiLoN9MFDu6aX+ui6XBr1nKsd1FWdYRShUG2DuwJocOlJ
	 Hkt1VJExZpVSA==
Date: Wed, 17 Sep 2025 16:01:34 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <aMrNTny9jgZJd_Ef@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
 <aMl_5j8G3IGulAC6@google.com>
 <20250917123601.GA1326709@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917123601.GA1326709@ziepe.ca>

On Wed, Sep 17, 2025 at 09:36:01AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 16, 2025 at 03:19:02PM +0000, Mostafa Saleh wrote:
> 
> > I think the fix for the problem Will mentioned is to just use CMOs
> > before accessing the host structures, so that should be simple.
> > If it turns to be more complicated, I am happy to drop the support
> > for non-coherent devices from this series and we can add it later.
> 
> I feel like it is easier/better to fix the driver to use cachable
> memory than to add CMOs to the pkvm side..

Hmm, but for non-coherent SMMU hardware (which sadly exists in
production), I don't think there's a way for firmware to tell the driver
that it needs to issue CMOs for the page-tables and the CDs but not the
other in-memory data structures (e.g. STEs). I suppose we could do it in
some pKVM-specific way, but then that's not really helping anybody else.

Will

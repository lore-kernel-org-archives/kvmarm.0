Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ECB2DA757;
	Thu, 18 Sep 2025 10:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191217; cv=none; b=eej1eX8L5T5JHJELR+A4wLRWCILWRLKoz9di1+3Za5dB2gbkV7YufEWJBi0luuwhwYtTfdCNoQX/NLhdRKn4vQg2fFvXPo+XAnK/hWQb5G1bDGuORmcaMurlh2SsiEet6/26sOc5/y/i5jPjvOTPvJZNtW0jc1/YtW17wFHGL9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191217; c=relaxed/simple;
	bh=sF1A73VvtGB9XaGt3W5JSsV7eemrEK6rpb1l1Er5U4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAGZsLU0Gz+kysFMQ6+Mk3U2n9Y4uHjjek9xj6njaR8fnIiUqyz1/S0Ts9s7LYMExrRilSy406/uY7YPJG8cZGXVBRS9Q17TITkTFtaa6lg+ILGjz/+mYPONXpNJSef8jUXC3Zu/DcwXwlL8/tgRb4t4OWzsCm8yn1YGWgMtguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1zzuGQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1zzuGQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E21C4CEEB;
	Thu, 18 Sep 2025 10:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191217;
	bh=sF1A73VvtGB9XaGt3W5JSsV7eemrEK6rpb1l1Er5U4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K1zzuGQ1IyAP7rN8bAjxPCKuWxBOVPFyVgQbmSYdk2+6ldtbIGKD37s5zjPh0ka59
	 aFbSJKmPtZdoKfRTA0mKqVi1GpzqDCRJOtfiydL6CrKEQIXbFVD70NoxxUXh5QPl+b
	 4mcyZJtPnH7kqeP2PHfd2cs6QK+BNXP/BPIZnpE/7cUoCcbt9oSF7/xL9MBfdXbs39
	 7kmLXBYxcUJ3IopLad4+yYTRKQSf+rofLzeNxr0I7KjCbyk9u9uAmB99gdwheRKMGZ
	 yK5RkO33GDEah89sfUAcURR/s2QkRm48D/+zOMCB5D3J6c4BF0xNkuAafrnSuWY7lc
	 zZAN3WiY8ghZg==
Date: Thu, 18 Sep 2025 11:26:50 +0100
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
Message-ID: <aMveas3QWXUk6xpm@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
 <aMl_5j8G3IGulAC6@google.com>
 <20250917123601.GA1326709@ziepe.ca>
 <aMrNTny9jgZJd_Ef@willie-the-truck>
 <20250917151612.GH1326709@ziepe.ca>
 <aMrS71vQ_MaVonzi@willie-the-truck>
 <20250917155931.GI1326709@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917155931.GI1326709@ziepe.ca>

On Wed, Sep 17, 2025 at 12:59:31PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 17, 2025 at 04:25:35PM +0100, Will Deacon wrote:
> 
> > Ah right, so the driver would unnecessarily issue CMOs for the structures
> > that are just shared with the hypervisor. At least it's _functional_ that
> > way, but I'm sure people will complain!
> 
> Yes, functional, why would anyone complain? STE and CD manipulation is
> not fast path for anything?

Won't it also apply to cmdq insertion?

Will

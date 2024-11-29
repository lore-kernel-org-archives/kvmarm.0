Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D61A4F1B
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732898004; cv=none; b=Vn0IUH7775pKZsU1bekgGaoXzTPHSK/kghhSaUlGzKjIb0q2rao2OXZqpiyiFOAEKSb3+LchdSehyulPwP0I67E74tToJq9Y9R1B7ZcStlmevvCAJH1/YumutHbBDnaNvnDsZ6nwOMBjId0uEjrKXSuxL81qNAfKMSgqjqLC+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732898004; c=relaxed/simple;
	bh=kdPahxlehedR0bU11HAXpJw5Gjp74fVBXVHcgNP257w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnuRc3Fats8zTRQ6WeT1RPY0UenJsl95JwrDKpkcsRlcO+1X7e98iYaOBRs4c1OXwelENafzMiOCrQX7W69H+nBSV0zjDZCQ/GW9BvLGeEP6oBJTf07Q6pDxv4NyWkoci1CXxP6RW5d6uZ81SFMma+F5+6CeKb4r1uNo667QrVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 29 Nov 2024 08:33:02 -0800
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Add error handling in
 vgic_its_cache_translation
Message-ID: <Z0nsvvRNzjWTLI7A@linux.dev>
References: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
 <Z0iujBMl1ypdwfBu@linux.dev>
 <a62e682d-c2e8-424d-84c5-4e64468124a9@inria.fr>
 <Z0lrWynd3O8a1pG_@linux.dev>
 <e85e92f9-8387-4021-885e-a379a2898c9c@inria.fr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85e92f9-8387-4021-885e-a379a2898c9c@inria.fr>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 29, 2024 at 12:30:52PM +0100, Keisuke Nishimura wrote:
> On 29/11/2024 08:20, Oliver Upton wrote:
> >   - Store fails because of a failed memory allocation / error in xarray
> >     library.
> > 
> > We don't handle #3, and the correct thing to do in this case is to put
> > @irq since it was never made visible in the translation cache.
> > 
> > So I think we'd want to do something similar to the following.
> > 
> 
> Hello,
> 
> Thanks for the comment. xa_reserve() can allocate the memory in advance and
> ensure the success of the subsequent xa_store().

Yes, but xa_store() can fail for other reasons than a failed memory
allocation. Which is why I recommended adding an explicit error handling
path to cover *all* failures to store in the xarray.

-- 
Thanks,
Oliver

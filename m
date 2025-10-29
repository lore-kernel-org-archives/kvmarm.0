Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D487C337699;
	Wed, 29 Oct 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761755008; cv=none; b=Lb0LCWHjnE00EB9KxSGdmCMrEpYksg3HgleEyaaWoNz6WJXi05WGdRt3JLPRoEe63MZpjyW7Sy/oR8TypBfJ99OAciABGg25mlinnN0JKtITg5x+CuEncXeYXN7QZz1VXTTFg1nriNjicEaeObF9jN3q8GA0139qyllpRfZmfEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761755008; c=relaxed/simple;
	bh=jOD78Mx518TeQRICu+lIQf1/IpxzBTgMrkOiFkYx+R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heLADRhjtTXGZ+98d7IQpJyyWct+G4eeM7gpYa3np6Baxjon+QN/lz/pZ9olXjYSyx/cjrA79hd5mRpPcRNDIcC4rjFnw/0dqjg7edb0QQxn1iXJNLePzwb5CLrtziUyXzwEwgdGWoh5OU0LuIw1crYq3h5xIpgbaS7kvmFA4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0vhav7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0vhav7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05D1C4CEF7;
	Wed, 29 Oct 2025 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761755008;
	bh=jOD78Mx518TeQRICu+lIQf1/IpxzBTgMrkOiFkYx+R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0vhav7C2VPL1gKf2u+3Ur40CdOmOqdjOrKKrWG7AHr4Nm8plDumh6C4wMMJ4QRVR
	 53buwYqhXJHzccuJnVEjFyYHGS65dX7iL3dNE58Ar4bqqNPTKk/2g72cRS3jQP0UjC
	 YOe/LxCAj458t8pPGcHGjxFqiJPgKjFVRbS8SoEclzTcE9bommQ6J11raqL0tFGqsI
	 p+2LcKfHys9c4i4ETeRvEaEL9/RB6IGqh1iPMXqQrZ/4nQHv9u5F9XjhNN8OnkQjuY
	 lrxQhA9nnBX9j+Tjv/dl4tqnlkLAjMR2hFbe8DqbBLKnKBgDNGwNvLHCETQttgFII/
	 MBPsIuD9TrMxA==
Date: Wed, 29 Oct 2025 16:23:22 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oliver.upton@linux.dev, catalin.marinas@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	joey.gouly@arm.com, ayrton@google.com, yuzenghui@huawei.com,
	qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Check the untrusted offset in FF-A memory
 share
Message-ID: <aQI_essk_agEZTTR@willie-the-truck>
References: <20251017075710.2605118-1-sebastianene@google.com>
 <aPj2hTXbGUseUqhE@google.com>
 <aQHsD0MnZYSTDOf8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQHsD0MnZYSTDOf8@google.com>

On Wed, Oct 29, 2025 at 10:27:27AM +0000, Sebastian Ene wrote:
> On Wed, Oct 22, 2025 at 04:21:41PM +0100, Vincent Donnefort wrote:
> > On Fri, Oct 17, 2025 at 07:57:10AM +0000, Sebastian Ene wrote:
> > > Verify the offset to prevent OOB access in the hypervisor
> > 
> > I believe that would be just a read, so probably it would be difficult to use
> > this to compromise anything, except crashing the system?
> 
> The simplest way is to crash the system but a more advanced one might
> lead to a confused deputy attack:
> 
> 1. Use the original bug to trigger the overflow of the offset variable
> which bypasses this check:
> https://elixir.bootlin.com/linux/v6.18-rc2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L519
> 
> 2. Use the host_share_hyp from the host to create a mapping in the hyp
> address space so that : reg from reg = (void *)buf + offset; points to
> memory mapped in the hyp address space & controlled from the host.
> 
> 3. Make the __ffa_host_share_ranges fail (since we control the content of
> the reg) to trigger the recovery mechanism for __ffa_host_unshare_ranges
> (https://elixir.bootlin.com/linux/v6.18-rc2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L392)
> and replace the content of the reg with pages that we want to remove the
> host stage-2 FF-A annotation from.
> 
> With step(3) we can remove the host stage-2 FF-A annotation from pages
> without having to invoke the FF-A reclaim mechanism. This allows a
> confused deputy attack because the pages can be given to another entity
> after the annotation is removed (eg. given to a protected VM).

Crikey, it's convoluted but I think your reasoning is correct and I also
think that the patch fixes the issue:

Acked-by: Will Deacon <will@kernel.org>

Cheers,

Will

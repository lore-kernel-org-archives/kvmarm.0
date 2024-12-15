Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B928FD;
	Sun, 15 Dec 2024 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734254576; cv=none; b=nkKjWACvsPb7aq94B05ox0zUzAeAMleT1+rklmE4n8+yhWi/AZCNrBTCu/hXy7BxgJHAlryRFBFZG+gV8gji3U8p4AJplH27AeVieQqr8O0kl1FIJY76A+zR0oy8Asspy1LQKchIi91twU2DT40Vh0nCi1uz+D6ImueLz634u7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734254576; c=relaxed/simple;
	bh=VA/fr2fanU2w8E9A58sNN9gLlEV2wRsSO8gXxlKoJjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtXgfRgag4rTG27QgpnMmjzx3vPIA1H2OG/ZWGHh9rx6reJpwRPMe9hSx8rPBosj4N6UwEupQAdUhyGV5DWbbd2CUBRvKhYEftN1dB7+uz7GYaqcUDFJE0rUJr90MEVs7bSqjumKBM2IiYeCQWqZTfRv6GsU1D7Ik4O1yIsv0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhdoQNf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhdoQNf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB77C4CECE;
	Sun, 15 Dec 2024 09:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734254576;
	bh=VA/fr2fanU2w8E9A58sNN9gLlEV2wRsSO8gXxlKoJjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rhdoQNf8ZGsxq0OtLSI6TOY8eXGLpQiMg80mC9co5MB8vkpw0TO6RSdI2TXbLarRr
	 3puHKaN152VDKGxcAGKQHHoUv8YpKIcGE7RdDdhGElwIw2TV+oXx0ek8hpp+N495bn
	 eMNvUw87z4AMK5lq0N6m/Vfd2qbHpnzNSDSI0ALQ=
Date: Sun, 15 Dec 2024 10:22:53 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, gshan@redhat.com, james.morse@arm.com,
	maz@kernel.org, oliver.upton@linux.dev,
	shameerali.kolothum.thodi@huawei.com, vt@altlinux.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 6.6 v1] KVM: arm64: Disable MPAM visibility by default
 and ignore VMM writes
Message-ID: <2024121528-refurbish-plausibly-31c7@gregkh>
References: <20241212151406.1436382-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212151406.1436382-1-joey.gouly@arm.com>

On Thu, Dec 12, 2024 at 03:14:06PM +0000, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 6685f5d572c22e1003e7c0d089afe1c64340ab1f upstream.
> 
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling. A previous patch supplied the missing trap
> handling.
> 
> Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
> be migratable, but there is little point enabling the MPAM CPU
> interface on new VMs until there is something a guest can do with it.
> 
> Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
> that supports MPAM, politely ignore the VMMs attempts to set this bit.
> 
> Guests exposed to this bug have the sanitised value of the MPAM field,
> so only the correct value needs to be ignored. This means the field
> can continue to be used to block migration to incompatible hardware
> (between MPAM=1 and MPAM=5), and the VMM can't rely on the field
> being ignored.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20241030160317.2528209-7-joey.gouly@arm.com
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> [ joey: fixed up merge conflict, no ID_FILTERED macro in 6.6 ]
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: stable@vger.kernel.org # 6.6.x
> Cc: Vitaly Chikunov <vt@altlinux.org>
> Link: https://lore.kernel.org/linux-arm-kernel/20241202045830.e4yy3nkvxtzaybxk@altlinux.org/
> ---
> 
> This fixes an issue seen when using KVM with a 6.6 host kernel, and
> newer (6.13+) kernels in the guest.
> 
> Tested with a stripped down version of set_id_regs from the original
> patch series.

What about 6.12.y?  You can't just skip a stable tree, otherwise you
will get a regression when you upgrade to 6.12.y, right?

thanks,

greg k-h

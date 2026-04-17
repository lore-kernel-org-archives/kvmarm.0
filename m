Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFAE2882CD
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776439778; cv=none; b=Stc2ujNIhN7TqEQKAkscxu8j4twvau/czB6K8Tmnk7cwZwwCcaMpwo0FxXXsgjt52iUPL54YDEb0tiNtq8m6BzmBwjLvadImT+/bYNPHMr2cuGIDJr8Y+4F0a/8MjldRDKaZgpUGGMZVZqUxGAF7XGTVU5yqcFHl4M1SQ8rNXaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776439778; c=relaxed/simple;
	bh=wcGMZozAsLV99EU8C+5KOdPZvcpUqDFWXQ1NY3TqZQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTg6EckdK4fjUqkSpyWc5ymgGBG5ODPoUwo0IEgfCIsnKdSaxkZJ9y5SQoalMNeCwOLMzXkS2ILVvpIwUmcaE6GXWFveZIo9KsZ37+hQsj6glySFTqTKvcGOZNka3ci9g6oxbIn0IPhPz22LjNTjHkXqTdudSCZccl3XFolx+Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cVkeV0iL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cVkeV0iL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46F1C1C25;
	Fri, 17 Apr 2026 08:29:30 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A4B83F7D8;
	Fri, 17 Apr 2026 08:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776439775; bh=wcGMZozAsLV99EU8C+5KOdPZvcpUqDFWXQ1NY3TqZQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVkeV0iLONQ1/hrMFbrkQKa53f8amGrFR7rdEwPeNI7WmfoAQsZ9+4AZCq1xvwO71
	 4Whf/irnYBxohsiJRawXc0MGDFWo/UL2oTNA71wewXAUeSDZY2kNU3T+TAeCvGb3/2
	 YLJ+MoiCS9ob9LxtsVQue9erNzJwVbGyQHhcscU0=
Date: Fri, 17 Apr 2026 16:29:31 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 15/18] Documentation: KVM: Fix typos in VGICv5
 documentation
Message-ID: <20260417152931.GB3311048@e124191.cambridge.arm.com>
References: <20260415115559.2227718-1-maz@kernel.org>
 <20260415115559.2227718-16-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415115559.2227718-16-maz@kernel.org>

On Wed, Apr 15, 2026 at 12:55:56PM +0100, Marc Zyngier wrote:
> From: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> Fix two typos in the VGICv5 documentation.
> 
> Fixes: d51c978b7d3e ("KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI")
> Fixes: eb3c4d2c9a4d ("Documentation: KVM: Introduce documentation for VGICv5")
> Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/devices/arm-vgic-v5.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> index 29335ea823fc5..1985b2d880322 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -12,8 +12,8 @@ Only one VGIC instance may be instantiated through this API.  The created VGIC
>  will act as the VM interrupt controller, requiring emulated user-space devices
>  to inject interrupts to the VGIC instead of directly to CPUs.
>  
> -Creating a guest GICv5 device requires a host GICv5 host.  The current VGICv5
> -device only supports PPI interrupts.  These can either be injected from emulated
> +Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 device
> +only supports PPI interrupts.  These can either be injected from emulated
>  in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LINE
>  ioctl.
>  
> @@ -25,7 +25,7 @@ Groups:
>        request the initialization of the VGIC, no additional parameter in
>        kvm_device_attr.addr. Must be called after all VCPUs have been created.
>  
> -   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
> +   KVM_DEV_ARM_VGIC_USERPSPACE_PPIS

This still has a typo! There's a P lurking between USER and SPACE!

>        request the mask of userspace-drivable PPIs. Only a subset of the PPIs can
>        be directly driven from userspace with GICv5, and the returned mask
>        informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
> -- 
> 2.47.3
> 

Thanks,
Joey

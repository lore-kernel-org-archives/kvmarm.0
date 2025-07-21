Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DA92E172E;
	Mon, 21 Jul 2025 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118100; cv=none; b=WOHpFIa+DJrpNweLnfllSvyvZUC4TlQ/tf3RKVvnL0n4WW7y0y6uLJzL2Pvbg1C75vBVXkPb6NlKF21qO67P0hxD9J+WAXi8/olNhic78JhpR7IFmUH0SfAfyj4XjYIrJXmAhEkgEc86Je2EYV92g3E8f3gCwO//07GWOX5M8/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118100; c=relaxed/simple;
	bh=c0l5eADL3DJiA5CLjuYvNt1KKuvoQU9z9pZBTTWVbtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jS89go8m61UZk+3Rl3TT4R0PjhFyuDHB/1oxIt6beWyWoRTRDSh+7QVbWDy04sJNGrT/BVjPyyOU6qtJXyJGaWlJVu5r6Kw/ReVHtPps+jy2mHWb6nt61W0qh3MKe0yAlyJZVgCpTlb3CvtIp74KldwHTWZjjD2ytBxD6Bwmr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWFF9F6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWFF9F6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D09C4CEED;
	Mon, 21 Jul 2025 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118099;
	bh=c0l5eADL3DJiA5CLjuYvNt1KKuvoQU9z9pZBTTWVbtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZWFF9F6IBAY5fFf2QnyIqqBC9pEYTodsSPjIt6odICY1lu7aiHBApakvbkoMmbuBJ
	 Ctqo22Mxyi4b7Mb7bw4/F/Qd22n0Otz45sDtH1lCFRECJCr4PTjw21Q7Zgi+Nei1L1
	 eJW0SXy4vZouNmcijmGUnRJEtkOC8sEGpXjrRZB3S9U34QIGbz0Bfwx/S7O792LNKv
	 7urlFTyOczxy/uqyTik9fch0fb1xtgVeK2lwEV/xcLjms7ALF5az6YwWecPJNWm0GW
	 zK63l93FlwLkjDCSSJuQG0MKMoNxxodrJsZlLVuF11nnSieQoQWaQeh4JM/kM5Lpuh
	 wFJ0YPyEtz+nQ==
Date: Mon, 21 Jul 2025 18:14:53 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Jack Thomson <jackabt.amazon@gmail.com>, mark.rutland@arm.com,
	lpieralisi@kernel.org, sudeep.holla@arm.com, arnd@arndb.de,
	wei.liu@kernel.org, romank@linux.microsoft.com,
	mhklinux@outlook.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
	kvmarm@lists.linux.dev, roypat@amazon.com,
	Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH] arm64: kvm, smccc: Fix vendor uuid
Message-ID: <aH51jfOmPfF3XEke@willie-the-truck>
References: <20250721130558.50823-1-jackabt.amazon@gmail.com>
 <86jz418rh3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jz418rh3.wl-maz@kernel.org>

On Mon, Jul 21, 2025 at 04:59:36PM +0100, Marc Zyngier wrote:
> [+Will]
> 
> On Mon, 21 Jul 2025 14:05:58 +0100,
> Jack Thomson <jackabt.amazon@gmail.com> wrote:
> > 
> > From: Jack Thomson <jackabt@amazon.com>
> > 
> > Commit 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for
> > getting hypervisor UUID") replaced the explicit register constants
> > with the UUID_INIT macro. However, there is an endian issue, meaning
> > the UUID generated and used in the handshake didn't match UUID prior to
> > the commit.
> > 
> > The change in UUID causes the SMCCC vendor handshake to fail with older
> > guest kernels, meaning devices such as PTP were not available in the
> > guest.
> > 
> > This patch updates the parameters to the macro to generate a UUID which
> > matches the previous value, and re-establish backwards compatibility
> > with older guest kernels.
> > 
> > Fixes: 13423063c7cb ("arm64: kvm, smccc: Introduce and use API for getting hypervisor UUID")
> > getting hypervisor UUID")
> > Signed-off-by: Jack Thomson <jackabt@amazon.com>
> > ---
> >  include/linux/arm-smccc.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 784ebe4607a4..50b47eba7d01 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -113,7 +113,7 @@
> >  
> >  /* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
> >  #define ARM_SMCCC_VENDOR_HYP_UID_KVM UUID_INIT(\
> > -	0xb66fb428, 0xc52e, 0xe911, \
> > +	0x28b46fb6, 0x2ec5, 0x11e9, \
> >  	0xa9, 0xca, 0x4b, 0x56, \
> >  	0x4d, 0x00, 0x3a, 0x74)
> >  
> > 
> 
> Irk. This is remarkably embarrassing, and needs to be addressed ASAP,
> before 6.16 ships. FWIW, I've just posted a quickly whipped selftest
> that shows the problem[1].
> 
> Will, is there a chance you can pick this up and ferry it to Linus?
> If you do, please add:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Marc Zyngier <maz@kernel.org>

Sure, I'll grab it. Thanks!

Will

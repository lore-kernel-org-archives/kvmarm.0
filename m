Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D493E1203
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870021; cv=none; b=t48sEVLAhfxxfIVppC1lS/FOLUr+MALACJOtHwq+Cua4Pm1+b36aXbl0G8jCtTXqLYEh4B5XEkAW+JcHN6mQzs1KRdU0SfrjHd79vHGbL2GucOou7CzeOucWblXDS91yrSw7aWbJNLcm2MZyC3LZ6NCErp4XF03Nqe9gCKrFXIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870021; c=relaxed/simple;
	bh=Np2MkBsIsFANFsO1qHtbrDKJSjP8sLCCo6QHYD3E2Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4J6Dk9pt4EpnqiYeEMIKwSJI+6ARpM2KSV+U5Ltbz3uIZt2uGEUN4V1H5//iq7XR9XLVnXwvgjiIRb15WuNXl4RAf5Ne7dFbVeuhSYVPZ7FhKK0i9Px3V1O0J6KTt8UUeZxN7hgDQU1merjH3NaHTA/mtXivpUfXKF/SpLswMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oaixrPDJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oaixrPDJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D28DF497;
	Thu,  1 Oct 2026 08:53:35 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 441C63F86F;
	Thu,  1 Oct 2026 08:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790870019; bh=Np2MkBsIsFANFsO1qHtbrDKJSjP8sLCCo6QHYD3E2Bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oaixrPDJlSiXNRcvuEcbfbuuIRs3oxP64FXKPUF33cj6i2RRi15ouXaH4KVC+qeNf
	 rDetlXsnN4wAtgB2fNVsdi5sTJ3qRN0DAS7wSORsgMv6ht/noTFAteq4GpYqKIJqoz
	 Z14UONw7fkzl3tNNtv5I6sXbH2JnGyvIlUonZ/I0=
Date: Thu, 1 Oct 2026 16:53:33 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>, andrew.jones@linux.dev
Subject: Re: [PATCH v3 1/8] lib/alloc_page: check for NULL ptr passed to
 free_pages()
Message-ID: <ar6B_VliXFknpiFa@e143914.arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
 <20261001151645.2427065-2-joey.gouly@arm.com>
 <2d9acef5-7281-4e62-a6b2-0a025b9631c5@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9acef5-7281-4e62-a6b2-0a025b9631c5@sirena.org.uk>

On Thu, Oct 01, 2026 at 04:42:33PM +0100, Mark Brown wrote:
> On Thu, Oct 01, 2026 at 04:16:38PM +0100, Joey Gouly wrote:
> > Don't call virt_to_pfn() before checking for NULL.
> > ---
> >  lib/alloc_page.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> There's no signoff here.

Agh, relatively new setup and clearly some things still not setup
correctly! 

Just in case:

Signed-off-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

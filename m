Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD21F4E48
	for <kvmarm@lists.linux.dev>; Sat, 22 Mar 2025 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742641450; cv=none; b=jrz+nQEHHH1zgId+qfJ5HJhpR921r93YGBHX8c6zcQmt8jj3XPQBoLKpbsnl/MzAtfYZY1V3ShF2CmAX76n55vscpVuFOFpx61AHopwSqh1of4+eX+yKH03GryalchH30kbf41lvAVwonfl/W+HcG+NOhomLAjGz5ifKL5MR4UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742641450; c=relaxed/simple;
	bh=GGzb6Ni/kVEOcYQlnZc4ozY/RS9CVS/Yvb+CG28DI5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bgnystt9afH3rLm5iQNxTbhkoeGXQDf9t0wFC+6x3P9TZ7WwgFhXZ+iHfSe6N+OT/QbhJ7VTRcWl3syRT3NpZdahngpOx87i0wxkZkUd3xvOPGmpP/p44ffwCSWPfETTR5ajqBHuGt3Ixm+PP26xx4ADbzYSqJ83zK0GEsF4QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e2Core7/; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e2Core7/"
Date: Sat, 22 Mar 2025 12:04:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742641444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3AbPthiG4Ipqd9vExyooLnBvqplgAQmSYPkVfdf03+Y=;
	b=e2Core7/Axcims5mOpjjqGxzbcxGhawHug2Eeq1hYamx0mrfv4Yxw8mX59gbSevTtscTeN
	nHmtbx3WdGOrEfSX2WQycGiSgrnb7yoapTLpX8G9AGWVLYVquSh01sFoK55CpHdGhR7R3y
	QILVzcmDLxHtZS8UMr5+lAgERiJ3gtM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Message-ID: <20250322-4802e87f0e18f0b787adb5fb@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314154904.3946484-3-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 03:49:01PM +0000, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> --arch=aarch64, intentional or not, has been supported since the initial
> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> "aarch64" does not show up in the list of supported architectures, but
> it's displayed as the default architecture if doing ./configure --help
> on an arm64 machine.
> 
> Keep everything consistent and make sure that the default value for
> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> that use this configuration for kvm-unit-tests.
> 
> The help text for --arch changes from:
> 
>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> to:
> 
>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/configure b/configure
> index 06532a89..dc3413fc 100755
> --- a/configure
> +++ b/configure
> @@ -15,8 +15,9 @@ objdump=objdump
>  readelf=readelf
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> -host=$arch
> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$host
> +[ "$arch" = "aarch64" ] && arch="arm64"

I'd prefer we keep our block of assignments a block of assignments. We can
put this at the bottom of the block, or, since the whole point of this is
to make sure help text looks right, then just put it in usage() at the top.

Thanks,
drew

>  cross_prefix=
>  endian=""
>  pretty_print_stacks=yes
> -- 
> 2.48.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

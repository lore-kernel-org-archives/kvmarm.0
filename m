Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA724022C
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736781725; cv=none; b=l5EzIRL00dW+by5GlcG0r85cFI9n7Ax3xp8Ybgw/02WNv0217HYi5zT/hwMoLFI6svjWx5I7c435A1V/NAh4IYN8JX48M1lcHRfgBl60TV1ZuW9aiA9yak5FH+FqcGPdwreNW+6Fw8jcQUcWuRfEi1QoI5QillaPBzcOBS6Hc3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736781725; c=relaxed/simple;
	bh=tyOIJhFMVkyVT2cnxGJIsjuS9eAH56mamAHJwe36bBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE6SnBepmzY9dvT7i7CM4YMdZK/7T9s+geYsnPiiQG2WnFzdynk7rI5+OkgI53O64vV4+AA1mwerReWpuMMpIfPfj0Sp1p2sl+rttXMvokGy4fGWk/20PSc1V95rWisZLrNlxTvsC+K+zIjQtRn1OeYR7J6lvjMMSWoGkqc6D2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UjLtIJEJ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UjLtIJEJ"
Date: Mon, 13 Jan 2025 16:21:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736781711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S+csKsh3Lg7wrpCs4Aw/UvMnqMM5F3l+RfYbkKy7EYM=;
	b=UjLtIJEJqjbkAT36AMpiAe0fD9h+BuKq8WrfC8ZgnnfMKd7Nc4EDfAce3ipS7uSByGds+v
	FPOfxYRI2mn+Ou1KYtzN4wBPzc60mj76w4nF1c5Qi4gFd2ZJpG5K0VdSH0tHXY1qDE13Wg
	SJaTYVp8yxhDXi0xtO10SmV/D5z/LIs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 4/5] arm/arm64: Add support for
 --processor=max
Message-ID: <20250113-8711bc93ade1e8c83dfe3582@orel>
References: <20250110135848.35465-1-alexandru.elisei@arm.com>
 <20250110135848.35465-5-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110135848.35465-5-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 01:58:47PM +0000, Alexandru Elisei wrote:
> For arm64, newer architecture features are supported only on newer CPUs.
> Instead of expecting the user to know which CPU model supports which
> feature when using the TCG accelerator for qemu, let's make it easier and
> add support for the --processor 'max' value.
> 
> The --processor value is passed to the compiler's -mcpu argument and to
> qemu's -cpu argument. 'max' is a special value that only qemu understands -
> it means that all CPU features that qemu implements are supported by the
> guest CPU, and passing it to the compiler causes a build error. So omit the
> -mcpu argument when $PROCESSOR=max.
> 
> This affects only the TCG accelerator; when using KVM or HVF,
> kvm-unit-tests sets the cpu model to 'host'.
> 
> Note that using --processor=max with a 32 bit compiler will cause a build
> error: the CPU model that the compiler defaults to when the -mcpu argument
> is missing lacks support for some of the instructions that kvm-unit-tests
> uses. The solution in the case is to specify a CPU model for the compiler
> using --cflags:
> 
>   ./configure --arch=arm --processor=max --cflags=-mcpu=<cpu>
> 
> This patch doesn't introduce a regression for arm when --processor=max is
> used, it's only the error that changes: from an unknown processor type to
> using instructions that are not available on the processor.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/Makefile.common | 2 ++
>  configure           | 5 ++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a5d97bcf477a..b757250dc9ae 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -25,7 +25,9 @@ AUXFLAGS ?= 0x0
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> +ifneq ($(PROCESSOR),max)
>  CFLAGS += -mcpu=$(PROCESSOR)
> +endif
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2
> diff --git a/configure b/configure
> index 138840c3f76d..46964d36a7d8 100755
> --- a/configure
> +++ b/configure
> @@ -67,7 +67,10 @@ usage() {
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64/aarch64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> -	    --processor=PROCESSOR  processor to compile for ($default_processor)
> +	    --processor=PROCESSOR  processor to compile for ($default_processor). For arm and arm64, the
> +	                           value 'max' is special and it will be passed directly to
> +	                           qemu, bypassing the compiler. In this case, --cflags can be
> +	                           used to compile for a specific processor.
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> -- 
> 2.47.1
>

I don't think we want to overload processor this way. While mcpu and QEMU
could both understand the same cpu names, then it was mostly fine
(although it probably shouldn't have been overloaded before either). Now
that we want one name for compiling and another for running, then I think
we need another configure parameter, something like --qemu-cpu.

Thanks,
drew

> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

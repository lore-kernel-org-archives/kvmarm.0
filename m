Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C936C0D1;
	Thu, 19 Mar 2026 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933964; cv=none; b=DK7BrPTn01FBCWHxNLyrJ0xsxDEv35OAvp/dkLeJYaMLE1e80xxDrEnb0oeDihNVQe7Ebs3UR5Eni3oaYeOogrh2MRWiScbqDcKYLqEbwUv8MLo4PQoWZz7Zh26ivySdcanK3RQlHFSwmRc5HAMDLjco52XtTifbatTBJXK/A7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933964; c=relaxed/simple;
	bh=lIpOgdBbvM16P5tqFEIjnPNTwcU0BKLvZn4WJTVz8wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpWoLBheDMwUl+XrKnP4IKLtObitXNfRkox3DvgXO1yB1FytET+24gUPUP+FXozoQ0gcb29yxy0q4R0I4zZWoKqSRWbgHXrTc/TQ8VH7p4TExsq8HTNHQtvviyqgpUpndSUwMtgY2NcF3ID4+mG5FH3h0k/NF9Bd4HrnTFvj/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3sWSMu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3sWSMu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7570C19425;
	Thu, 19 Mar 2026 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933963;
	bh=lIpOgdBbvM16P5tqFEIjnPNTwcU0BKLvZn4WJTVz8wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3sWSMu0+JZlGQjS8+vacR9jy9R7vSv3KGrAB0VJ+FB7yj2ujcLfiweUTAUISebtd
	 Nm1k2oZKGvBqvA6Oz7RvdZl7HwTKgnhh6rfp6GMfasISJX933AlLpI5oIvUxX1Wx39
	 ct3V9ezIeu75k3SrxiwgVOgkhcKYXMQ5UC9ECA5WtS2F0r/jgLYt1tjfc8dSKVpi0y
	 yfQ5CHPW4059sGzFNy8tlqfObnZz+f+JoP3aA8+Mn9WQyaLn3+LxRGW2hixAr0hufC
	 ZQJFdYAMV7IdObi4zFeyP2IxgglWpJuV8MqUDyJVFYg8ZTkxV/2aTi5aNBZkV+SXY/
	 YhtMCFpg15Egg==
Date: Thu, 19 Mar 2026 15:25:58 +0000
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	tabba@google.com, steven.price@arm.com, aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com, oupton@kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: Re: [kvmtool PATCH v6 01/17] util/update_headers: Update
 linux/const.h from linux sources
Message-ID: <abwVhsU06OQOEdoD@willie-the-truck>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
 <20260227165624.1519865-2-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260227165624.1519865-2-suzuki.poulose@arm.com>

On Fri, Feb 27, 2026 at 04:56:08PM +0000, Suzuki K Poulose wrote:
> Building kvmtool from scratch gives me the following errors with buildroot:
> 
> In file included from include/kvm/pci.h:7,
>                  from include/kvm/vfio.h:6,
>                  from include/kvm/kvm-config.h:5,
>                  from include/kvm/kvm.h:6,
>                  from builtin-version.c:4:
> include/linux/virtio_pci.h:323:20: warning: implicit declaration of function ‘__KERNEL_DIV_ROUND_UP’ [-Wimplicit-function-declaration]
>   323 | #define MAX_CAP_ID __KERNEL_DIV_ROUND_UP(VIRTIO_DEV_PARTS_CAP + 1, 64)
>       |                    ^~~~~~~~~~~~~~~~~~~~~
> include/linux/virtio_pci.h:326:24: note: in expansion of macro ‘MAX_CAP_ID’
>   326 |  __le64 supported_caps[MAX_CAP_ID];
>       |                        ^~~~~~~~~~
> include/linux/virtio_pci.h:326:9: error: variably modified ‘supported_caps’ at file scope
>   326 |  __le64 supported_caps[MAX_CAP_ID];
> 
> We inherit linux/virtio_pci.h from the kernel sources and won't be good to fix
> it by including linux/kernel.h. Instead, pick up up uapi/linux/const.h from the
> kernel tree. This also removes the ifdefery linux/kernel.h
> 
> To prevent a build warning for redefinition, update the headers from v6.19,
> remove the hack from linux.kernel.h in one shot. This was also discussed in
> the Link, in another context.
> 
> Cc: Anup Patel <apatel@ventanamicro.com>
> Cc: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/all/20250211114018.GB8965@willie-the-truck/
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  include/linux/const.h  | 53 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/kernel.h |  3 ---
>  util/update_headers.sh |  1 +
>  3 files changed, 54 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/const.h
> 
> diff --git a/include/linux/const.h b/include/linux/const.h
> new file mode 100644
> index 00000000..b8f629ef
> --- /dev/null
> +++ b/include/linux/const.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* const.h: Macros for dealing with constants.  */
> +
> +#ifndef _UAPI_LINUX_CONST_H
> +#define _UAPI_LINUX_CONST_H
> +
> +/* Some constant macros are used in both assembler and
> + * C code.  Therefore we cannot annotate them always with
> + * 'UL' and other type specifiers unilaterally.  We
> + * use the following macros to deal with this.
> + *
> + * Similarly, _AT() will cast an expression with a type in C, but
> + * leave it unchanged in asm.
> + */
> +
> +#ifdef __ASSEMBLY__
> +#define _AC(X,Y)	X
> +#define _AT(T,X)	X
> +#else
> +#define __AC(X,Y)	(X##Y)
> +#define _AC(X,Y)	__AC(X,Y)
> +#define _AT(T,X)	((T)(X))
> +#endif
> +
> +#define _UL(x)		(_AC(x, UL))
> +#define _ULL(x)		(_AC(x, ULL))
> +
> +#define _BITUL(x)	(_UL(1) << (x))
> +#define _BITULL(x)	(_ULL(1) << (x))
> +
> +#if !defined(__ASSEMBLY__)
> +/*
> + * Missing asm support
> + *
> + * __BIT128() would not work in the asm code, as it shifts an
> + * 'unsigned __int128' data type as direct representation of
> + * 128 bit constants is not supported in the gcc compiler, as
> + * they get silently truncated.
> + *
> + * TODO: Please revisit this implementation when gcc compiler
> + * starts representing 128 bit constants directly like long
> + * and unsigned long etc. Subsequently drop the comment for
> + * GENMASK_U128() which would then start supporting asm code.
> + */
> +#define _BIT128(x)	((unsigned __int128)(1) << (x))
> +#endif
> +
> +#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
> +#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> +
> +#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> +
> +#endif /* _UAPI_LINUX_CONST_H */
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index df42d63a..6c22f1c0 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -8,9 +8,6 @@
>  #define round_down(x, y)	((x) & ~__round_mask(x, y))
>  
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> -#ifndef __KERNEL_DIV_ROUND_UP
> -#define __KERNEL_DIV_ROUND_UP(n,d)	DIV_ROUND_UP(n,d)
> -#endif
>  
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> diff --git a/util/update_headers.sh b/util/update_headers.sh
> index af75ca36..105bfc1d 100755
> --- a/util/update_headers.sh
> +++ b/util/update_headers.sh
> @@ -29,6 +29,7 @@ then
>  fi
>  
>  cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
> +cp -- "$LINUX_ROOT/include/uap/linux/const.h" include/linux

Typo ^^^

but, tbh, I don't think we need to add const.h to this list. Unlike
the virtio and kvm headers, we're probably fine sticking with a static
version. So you can just drop this hunk imo.

Will

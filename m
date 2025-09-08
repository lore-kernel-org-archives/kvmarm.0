Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A710678F59
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 11:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757332176; cv=none; b=YUOqgpb632CKOTqsk8Iw4CvNiI+60wZoB5y0zc6cJZu+xe92/hgOmf//t1QpZa2mlj9mo0qQsMQPhmDqQGLad8uQcFsVyLXmCPUo6rZCNXJqzgLtC6MVLGWSsyQHB7nQyKUpdbPzdmfxgHTvnlK55aYm/j4kq8bhpJHhTjCWjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757332176; c=relaxed/simple;
	bh=5Lmn+ua714sApnkFmVGEMUNXp7pW6BG4vTEQsiwJWUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTuM1AQJVnlTh2Rgp8cxL9YouXuy2vg1tOWTFKffdzWegMuPQZECdjXWMa9qXvMXG7NE6Yd+U9m+AVjVaqfWP2aVZ0cbyuXSTzWs7nKRJNA6T3ca/qXC5ixkCLDeuDtu2pdNEHV5lLzw1ULqp3Exyiu+ALyTHzKn8kyMf5xuEtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90BB41BCA;
	Mon,  8 Sep 2025 04:49:25 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.57.4.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46B5B3F63F;
	Mon,  8 Sep 2025 04:49:13 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:49:01 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, andrew.jones@linux.dev
Subject: Re: [kvm-unit-tests PATCH] arm64: mte: Fix MTE granule mask
Message-ID: <aL7CrQdvNy2V7VwA@e140010.arm.com>
References: <20250905124129.32435-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905124129.32435-1-vladimir.murzin@arm.com>

Hi Vladimir,

On Fri, Sep 05, 2025 at 01:41:29PM +0100, Vladimir Murzin wrote:
> So it generates correct mask when used together with MTE_TAG_SHIFT
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/mte.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/mte.c b/arm/mte.c
> index 95d58aaa..a1bed8a7 100644
> --- a/arm/mte.c
> +++ b/arm/mte.c
> @@ -26,7 +26,7 @@
>  #define MTE_TCF_ASYMM	0b11
>  
>  #define MTE_GRANULE_SIZE        UL(16)
> -#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
> +#define MTE_GRANULE_MASK        (MTE_GRANULE_SIZE - 1)

And this is how it's used:

#define untagged(p)									\
({											\
	unsigned long __in = (unsigned long)(p);					\
	typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\

I'm going to walk through how MTE_GRANULE_MASK is used, just to make sure I got
things right this time.

Without this change:

MTE_GRANULE_MASK = ~(0..01..1) = 1..10..0 -> LSB 4 bits are zero
~(MTE_GRANULE_MASK << MTE_TAG_SHIFT) = ~(1..10..0) = 0..01..1 -> bits 63:60 are
zero, and what is masked is actually the PAC field, not the logical tag.

With this patch:

MTE_GRANULE_MASK = 0..01..1 -> LSB 4 bits are 1
~(MTE_GRANULE_MASK << MTE_TAG_SHIFT) = ~(0..01..10..0) = 1..10..01..1 -> bits
59:56 are 0, and the logical tag is masked, which is what we want, so:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Also curious, I remember running the tests and I didn't see an error, how did
you catch this?

Thanks,
Alex

>  #define MTE_TAG_SHIFT           56
>  
>  #define untagged(p)									\
> -- 
> 2.34.1
> 

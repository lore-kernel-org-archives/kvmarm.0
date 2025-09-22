Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32890221F15
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758574815; cv=none; b=jTrwwzc+dxvvWewnPGS/XTKdSjHn5MwTfZ3UPTKMhuKeCXsL92sZnudopSWT1Fbsqhfuzwy7Ft17rrUGmrf38FGgc0j7XYYRLZaOEqbHdfs+hR2To5vcAUDwJUBAcX8gkA2qTt7iClN3mXCtokWlqZ7ha4dIYtnVZaigx/T+HMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758574815; c=relaxed/simple;
	bh=AggCKAT/ai9pPMS+uvkc8gHc61NeqPEoUM5TIXFt0jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3IKAxDiaJCOW3n+PZFGjVZjxm9bXYbPsBXdMoGHZXEMthlfNOAzBUpFnKKHMevaIOxm9YmLLZgyKUpvFfcAmMezAgovJPdm0NyII+mcRGVxwP8w9h2/1tfPxOV/7hqKohxKqSvf5g4NIM9R9EJhpKPrEtSc+PirdfmuRy4JlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zrRzt+Fd; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zrRzt+Fd"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46c889b310dso18652745e9.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 14:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758574811; x=1759179611; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZr0hPhFAud0Uw+aBiZrTvnM6zeOzyc8u94gFH2jTwA=;
        b=zrRzt+FdwsDl3CYACT2mS6NStwNJJ15juBKNIqYTfVe/3jPRF5CPfO0p04X2ZVPEHM
         j6bj5t3i10EC8U/xNygDbTaPGNh0GVAd4zhrdu9dBGZj3r2jXjhdiJ1D0hr9O22eTQqh
         V50iKO6NM5cb9Mc4QcIDGDuwykS/q3ZVSgJm29XgiYdhWoiPuXNgoazJNv0z93odnBEz
         76eALrAdgsqK6iBj2u+nCHJXQyw8Q3aHKuAS1XmW3QGZC57Lp35Jch701wJn90mJbvuT
         73ctFobINQdA/B01uBt9eyR/75fymx0MTi0MLPUy6OOrH3/x2E+Of2nSxgT2iwO2furR
         M0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758574811; x=1759179611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZr0hPhFAud0Uw+aBiZrTvnM6zeOzyc8u94gFH2jTwA=;
        b=do1sKwh3QFOIm9G0eZSGTfQbbPhh9C5YnANzWKvh2z56iNcht0WwFN7zLtiAN4wqg6
         jXuGbqp+eVYFghnKh+xsClpqw4iGDnbTaSzgWkh24Rxy2qPCfwNqwR9l9nGfWlwtKg0V
         cXS9ecl3Syjel1P45dX0mWohChQsG6JVhpHaHb5Q31y8E4BLLu+bCO0nVNs+/Zj8wShy
         JvMnRHjbxwy67fbZKXRiEsmIU4MMIz5Nsilk8H5VqQVaA7ybW99sTFhOKyyZnemInwtI
         1zNPQqHNFOOugkSftEmhoJZ56iChZGldJvdYIPYx0g+TWbypRF/Hql51Vsl4PH+Yag4B
         qTFg==
X-Forwarded-Encrypted: i=1; AJvYcCXdxcp5WVbw+nVd064wB/5mdIMLfh+x5saFQX6nS+FERjIMoHoXLYtw3tEllHSUznXhE/eBddw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCkF2JW/QQJliS9D4D46w6+JtMhYgfsHvnvSLyTeyPnG5zrg8Q
	q8hxS9W1DrV0s2I7kObhmm84DRgfKEn0fef8aOBwgRj3rHs5+Lp/sZ7mOVgMGzBalA==
X-Gm-Gg: ASbGncvwZXftsFWKfVjg4q0rDUosywWEK0Nw9c6/5yc9JAGUGRBM2S3C7Pr9gRMWzRt
	2pcpYllnmsSz73ipK4VPXpfQfIS8Noht8Fo0zri8PhsPmJjT+L/joE/vjr+cMKO4iUmH0m8WPQC
	mtBk+x/YvZTNXTFtv+M0CZ+x8bSJTyVaq3ZPv1jabiASQs5FyNdyJe1Ye2NOgmUQCx9ACPqPRyy
	hxs6f299W0epkx25iKevuQyBGqqwPf1RfTVXRN/ZO8wC9TuW9duxv1JQr6K++XK4Tua8b6NkCjM
	/yYxKYp00/cf/0PG0/Mj9fiNnysJqswSSoq1nDM3zgBFv5I53KCy7Y0eWHBhrI4U9AYVCkU0Wyx
	6bJY6CaVaAVkKZAGmB1Vhf1YPMaOTfmXtlNcEmESH98EeFe0dTReb6jw4ffc4lE3Z7A==
X-Google-Smtp-Source: AGHT+IGQQ4kfiQOVTFeyQzQt2jYtkM5/eyZicm9Wu0N0OnLEQ0zchv5LfIGa+8+xPV9iHI+UIbvczw==
X-Received: by 2002:a05:600c:8287:b0:46d:34cc:e9c1 with SMTP id 5b1f17b1804b1-46e1e0f7c74mr978165e9.4.1758574811415;
        Mon, 22 Sep 2025 14:00:11 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e1bc00695sm14039935e9.4.2025.09.22.14.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 14:00:11 -0700 (PDT)
Date: Mon, 22 Sep 2025 22:00:07 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, sebastianene@google.com, keirf@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Check range args for pKVM mem transitions
Message-ID: <aNG417MneSKBxyn8@google.com>
References: <20250919155056.2648137-1-vdonnefort@google.com>
 <87plbkxcvv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plbkxcvv.wl-maz@kernel.org>

On Sun, Sep 21, 2025 at 12:29:08PM +0100, Marc Zyngier wrote:
> On Fri, 19 Sep 2025 16:50:56 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > There's currently no verification for host issued ranges in most of the
> > pKVM memory transitions. The subsequent end boundary might therefore be
> > subject to overflow and could evade the later checks.
> > 
> > Close this loophole with an additional check_range_args() check on a per
> > public function basis.
> > 
> > host_unshare_guest transition is already protected via
> > __check_host_shared_guest(), while assert_host_shared_guest() callers
> > are already ignoring host checks.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > ---
> > 
> >  v1 -> v2:
> >    - Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
> >    - Rename to check_range_args().
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 8957734d6183..65fcd2148f59 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -712,6 +712,14 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
> >  	return check_page_state_range(&vm->pgt, addr, size, &d);
> >  }
> >  
> > +static bool check_range_args(u64 start, u64 nr_pages, u64 *size)
> > +{
> > +	if (check_mul_overflow(nr_pages, PAGE_SIZE, size))
> > +		return false;
> > +
> > +	return start < (start + *size);
> 
> I will echo Oliver's concern on v1: you probably want to convert the
> boundary check to be inclusive of the end of the range. Otherwise, a
> range that ends at the top of the 64bit range will be represented as
> 0, and fail the  check despite being perfectly valid.

Do you mean allowing something like start == 0xfffffffffffff000 and size ==
4096?

But I guess that would still put all the following checks using "addr + size" at
risk. Also, I believe even the code in pgtable.c wouldn't support a such range
as it is also using a u64 end boundary.

> 
> That's not a problem for PAs, as we will be stuck with at most 56bit
> PAs for quite a while, but VAs are a different story, and this sort of
> range check should be valid for VAs as well.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.

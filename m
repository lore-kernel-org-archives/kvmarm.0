Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792657899;
	b=Us8Idr4k56jXCdz6BZVCJFJyLgdm4dGjidG3y+ACvZC7rvmV6kVnArSwD1b5yvePInjc
	 xY2jnaR0XkgkqD3hGw22D0n1trc9cpSeYVE7P3DlgTmTBix3Xtqzex/NP+VkkGmW645jF
	 2ww1iZnBEOr/ejzQ3OH5IpUkvxgBgkSqpyiOY3FE0kJEhqCBZcI6ZMQ1etOJ/0iCiMxpy
	 jaBY8HspFs6fir/3kYKl9fSVcqbCoP51zWunEVH8kIza7vWTeLheZrMjzWiICdI668z2G
	 Q7r6KrY8k173nDJaAo2T1gUo/WUR55pm7Jk8CyUXZlYJ4fQoXUkHmV1/z9T7UgEKkpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792657899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=tNqEOrEbvKEdZLXsSkH26l7aedkHF5+jRM5uZ/OAFio=;
	b=2S4e0ysOGhFDtkRjE6b+eORMUYxmAVp55hCSpTCF8b30Fv8asrzH3T2ZsKBaE2DEpMaO
	 n9bhJzx8xqjTiHrfqiZ1kISOz/eEigNHGGYiVP3imn5K+9M9AnvgyAHrHbRKyJe4r5+Pu
	 9ravqyPl1ODkC3tiWAjuDDYAMGd+zP6vPFVnAdE3HNiHhETNAGttzdIrwnl/K0o/0t4Xa
	 igAtheL1+8gtBvHbgmUV5DV0T4T5BMsd8QtgkSvp/w7P8R/aKJupdmn8D7OeSEyGVJLwg
	 Ks/SJLSajnKx5LhByJl5fDL8B3qnoetMuH5/wMfOnNTYtk9GcnVNClmNynVAjMNvNFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kFCOIi6i;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C8B606A322
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 08:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62C8B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kFCOIi6i
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1df146015so12162635e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 01:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792657898; x=1793262698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tNqEOrEbvKEdZLXsSkH26l7aedkHF5+jRM5uZ/OAFio=;
        b=kFCOIi6iSIugFKt4W4XjY8D6rhUBtiVGU/Zs2e9LYZ/+KcJdvi2HnKxRyS9Pk1ozcZ
         donyZhQJ2Olgjk22HVXjk/NnBRzNE+UsWsYdif5/5oax7kXs78/iELye+DzYTwJvbWF+
         bCvW9rR1bE2IXGb1AgR8WokFJQUSzawZwzfVdCEbzCQyJ/ttLpVvEbeRRDtK4MIaEdJZ
         ey4yQBSQ3fFIt4sSqGlYbkxNmEFjKV3Tv617AACyrW/SBTxlliP85peCCxw74pu04f6s
         ZfW6QJhY2aHC/YG/VjT3eXiU5YfZv2h+FMii4x1wc75ZmT0lpHT/ghMVRys2ntF9CDzq
         YZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792657898; x=1793262698;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tNqEOrEbvKEdZLXsSkH26l7aedkHF5+jRM5uZ/OAFio=;
        b=kW9uFHm+7jH5ApvS/iP1L0HRHnfn5FBTKORn5THm8D+j1gcrjUfezn/j6IYMkOX+A9
         tHS1vkaCimxPhCu1kPtdGK9INzSwmg/0acoHkaXCgHhZUlEMXKETxSBMPQQJYxwmV6pM
         1LlCFRloX4qiyfj2JRIIZWFgRyXm0Arbo9EV78STNlNLbW/3Jsr9mmc2ahAIqTLJhZbM
         wpOzHiEKl+OHT4PID0Muj/yr4MJN40HWlTLlX3/V9PBK2kZEfSYBKdiTyF68BFrbWaZe
         XGcBXo49tk1WO4Fmbtu/jWgHatTb9R+eVPxzRs9SpnRgCczKBK7ArT+q2Y1fSKAr8tHR
         +Fsg==
X-Forwarded-Encrypted: i=1; AKwUvBx6StXosPHPIi939IDXjVkD9LSe9+GF5UE+a/TgxRoNabRnSOqPc2T9QSmRfo1tBRtJAbxrzNk=@lists.linux.dev
X-Gm-Message-State: AFq9FYK9CoGgVpEwiArlJhFfqDYzEsbAOW/jIoAQ7U2+ertv8teuZHua
	6KhjYC8HICcVWsFgWbwISnt5MGyDaF0cJikjkjAaQT2i0RV7ng4ayDfQ6yxXaxlBAw==
X-Gm-Gg: AYBFou0cvbbgeJINohQc/a7WDrahaxXkxk0JSHPCU9vcv6OGcvtKvO61vu1Z+CUl6dJ
	1nVWvOkvBhUNekjy21PywjcJ1ccyIzQ7CEa0s8cir6Q50YWG8JaR7N+D3Q4IIxNtHMtkskcE2oh
	5Ff9NrpDEk81LAcK2O4Tj9b6UvCv4nCrvH17EiG/LxlPhOOGRgARplH9rwX9OF0xnr0X+7GyIL7
	u4FnRjy2pHTnHywRfg/arZnZhwJEHZH0F7SpGykOqD9ZyUaEVYhQYArYjAoq06z6AUtCln7Um4b
	E3EaWBXOEPvHbzEJ+n1WZqyDzZIroZKWjLKSpXI7ibFY2RoHjP3PNliDW65Ag1mpgEuyJ6KghY/
	0ApHd0rfES7e0rAG/ZQerP0mRu/wAjy2L4cqpk3YhMvxCvoGOe1ZQQwmN26OdRerDcuMHaAH7mE
	ziTnGyTs5a+2iGsnuwaXVNa1lnQZpybuZj6EZIIzAz1M1kINHYWNq7uNdJsrrhDuMHr4tfDCfez
	vurlfRCfxLPgaXhq63LckxAX5x6pNNkWsDuGt+PtVTlcIU/N8POJ+y6B5ti+4180aTWR5uWK1xm
	38Zv7FI94bw0UQEGTWZN7ycf
X-Received: by 2002:a05:600c:34ca:b0:4a1:d10c:7170 with SMTP id 5b1f17b1804b1-4a1fdd34028mr98581465e9.31.1792657897259;
        Thu, 22 Oct 2026 01:31:37 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a0e64esm53407775e9.3.2026.10.22.01.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 01:31:36 -0700 (PDT)
Date: Thu, 22 Oct 2026 09:31:33 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com,
	andre.przywara@arm.com
Subject: Re: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
Message-ID: <atnJ5RdWkGQ9QZgQ@google.com>
References: <20261019145949.1922019-1-vdonnefort@google.com>
 <16679dd3-c168-4dee-bb9d-da9b0e3416cf@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16679dd3-c168-4dee-bb9d-da9b0e3416cf@arm.com>

On Tue, Oct 20, 2026 at 03:43:08PM +0100, Suzuki K Poulose wrote:
> On 19/10/2026 15:59, Vincent Donnefort wrote:
> > The THP support imposes an alignment of the memslot userspace address to
> > the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
> > size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
> > true on 4KiB page systems.
> > 
> > Use a huge-page size, based on the system page size. This value can be
> > massive for a 64KiB page system, so skip the alignment if we couldn't
> > even install one THP.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > index 36b3284e4a92..2c01dc32fa9a 100644
> > --- a/arm64/kvm.c
> > +++ b/arm64/kvm.c
> > @@ -18,6 +18,8 @@
> >   #include <asm/image.h>
> > +#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
> > +
> >   static struct arm64_image_header *kernel_header;
> >   struct kvm_ext kvm_req_ext[] = {
> > @@ -35,20 +37,23 @@ bool kvm__arch_cpu_supports_vm(void)
> >   void kvm__init_ram(struct kvm *kvm)
> >   {
> > -	u64 phys_start, phys_size;
> > +	u64 phys_start, phys_size, ram_alloc_align = SZ_64K;
> >   	void *host_mem;
> >   	int err;
> >   	/*
> > -	 * Allocate guest memory. We must align our buffer to 64K to
> > -	 * correlate with the maximum guest page size for virtio-mmio.
> > -	 * If using THP, then our minimal alignment becomes 2M.
> > -	 * 2M trumps 64K, so let's go with that.
> > +	 * Allocate guest memory. We must align our buffer to 64K to correlate
> > +	 * with the maximum guest page size for virtio-mmio. If using THP, then
> > +	 * our minimal alignment trumps 64K, so let's go with that.
> >   	 */
> >   	kvm->ram_size = kvm->cfg.ram_size;
> >   	kvm->arch.ram_alloc_size = kvm->ram_size;
> > -	if (!kvm->cfg.hugetlbfs_path)
> > -		kvm->arch.ram_alloc_size += SZ_2M;
> > +	if (!kvm->cfg.hugetlbfs_path) {
> > +		if (kvm->ram_size >= HUGEPAGE_SIZE)
> > +			ram_alloc_align = HUGEPAGE_SIZE;
> 
> There is logic in builtin-run.c to detect the host_ram_size(), could we
> use that instead to decide if we should apply this alignment ? Or retry
> the RAM allocation without the alignment on failure ?

As the mmap() sets MAP_NORESERVE, I believe it is only reserving address space,
I don't think a failure is expected because we increase the size of that
reservation or did I miss anything?

> 
> It doesn't look like a good idea to hard code this based just on the
> requested RAM size.

The idea is just if we know the guest doesn't have enough RAM to install at
least one THP, then there is no need over-mmap. But it isn't saving anything
really so perhaps I may as well drop it?

> 
> Cheers
> Suzuki
> 
> 

Thanks for having a look,

-- 
Vincent

> 
> > +
> > +		kvm->arch.ram_alloc_size += ram_alloc_align;
> > +	}
> >   	if (kvm->cfg.arch.guest_memfd)
> >   		kvm->arch.ram_alloc_start = mmap_guest_memfd(kvm,
> > @@ -63,7 +68,7 @@ void kvm__init_ram(struct kvm *kvm)
> >   		    kvm->arch.ram_alloc_size, errno);
> >   	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> > -					SZ_2M);
> > +					ram_alloc_align);
> >   	if (!kvm->cfg.arch.guest_memfd) {
> >   		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > 
> > base-commit: f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9
> 
